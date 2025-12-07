-- Процедура создания оповещения
CREATE OR REPLACE PROCEDURE create_notification(
    p_user_id INT,
    p_title VARCHAR(200),
    p_message TEXT,
    p_audience_type VARCHAR(20) DEFAULT 'school',
    p_class_id INT DEFAULT NULL,
    p_audience_value VARCHAR(100) DEFAULT '',
    p_custom_recipients TEXT DEFAULT NULL,
    p_priority INT DEFAULT 0,
    p_publish_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_name VARCHAR(150);
    v_user_role INT;
    v_notification_id INT;
    v_formatted_message TEXT;
BEGIN
    -- Проверка пользователя
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = p_user_id) THEN
        RAISE EXCEPTION 'Пользователь с ID % не найден', p_user_id;
    END IF;
    
    -- Получаем информацию о пользователе
    SELECT u.fio, u.role_id INTO v_user_name, v_user_role
    FROM users u WHERE u.id = p_user_id;
    
    -- Форматируем сообщение
    v_formatted_message := CASE p_priority
        WHEN 0 THEN '[Обычное] '
        WHEN 1 THEN '[Важное] '
        WHEN 2 THEN '[СРОЧНО] '
        ELSE '[Уведомление] '
    END || p_message;
    
    -- Создаем оповещение
    INSERT INTO notifications (
        from_user_id,
        to_class_id,
        title,
        message,
        audience_type,
        audience_value,
        priority,
        is_read,
        created_at,
        created_by
    ) VALUES (
        p_user_id,
        p_class_id,
        p_title,
        v_formatted_message,
        p_audience_type,
        CASE p_audience_type
            WHEN 'class' AND p_class_id IS NOT NULL THEN
                (SELECT name FROM classes WHERE id = p_class_id)
            ELSE
                p_audience_value
        END,
        p_priority,
        FALSE,
        p_publish_date,
        p_user_id
    )
    RETURNING id INTO v_notification_id;
    
    RAISE NOTICE 'Создано оповещение ID: %', v_notification_id;
END;
$$;

-- Процедура обновления оповещения
CREATE OR REPLACE PROCEDURE update_notification(
    p_notification_id INT,
    p_user_id INT,
    p_new_title VARCHAR(200) DEFAULT NULL,
    p_new_message TEXT DEFAULT NULL,
    p_new_audience_type VARCHAR(20) DEFAULT NULL,
    p_new_class_id INT DEFAULT NULL,
    p_new_audience_value VARCHAR(100) DEFAULT NULL,
    p_new_priority INT DEFAULT NULL,
    p_new_date TIMESTAMP DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_can_edit BOOLEAN := FALSE;
    v_created_by INT;
    v_user_role VARCHAR(10);
    v_formatted_message TEXT;
BEGIN
    -- Проверка существования оповещения
    IF NOT EXISTS (SELECT 1 FROM notifications WHERE id = p_notification_id) THEN
        RAISE EXCEPTION 'Оповещение с ID % не найдено', p_notification_id;
    END IF;
    
    -- Получаем информацию об оповещении и пользователе
    SELECT n.created_by, r.name INTO v_created_by, v_user_role
    FROM notifications n
    JOIN users u ON u.id = p_user_id
    JOIN roles r ON u.role_id = r.id
    WHERE n.id = p_notification_id;
    
    -- Проверка прав
    IF v_user_role = 'admin' OR v_created_by = p_user_id THEN
        v_can_edit := TRUE;
    END IF;
    
    IF NOT v_can_edit THEN
        RAISE EXCEPTION 'Нет прав для редактирования';
    END IF;
    
    -- Форматируем сообщение если есть новый приоритет или сообщение
    IF p_new_priority IS NOT NULL OR p_new_message IS NOT NULL THEN
        SELECT message INTO v_formatted_message FROM notifications WHERE id = p_notification_id;
        
        IF p_new_priority IS NOT NULL THEN
            v_formatted_message := CASE p_new_priority
                WHEN 0 THEN '[Обычное] '
                WHEN 1 THEN '[Важное] '
                WHEN 2 THEN '[СРОЧНО] '
                ELSE '[Уведомление] '
            END || COALESCE(p_new_message, regexp_replace(v_formatted_message, '^\[[^\]]+\]\s*', ''));
        END IF;
    END IF;
    
    -- Обновляем
    UPDATE notifications 
    SET 
        title = COALESCE(p_new_title, title),
        message = COALESCE(v_formatted_message, message),
        audience_type = COALESCE(p_new_audience_type, audience_type),
        to_class_id = COALESCE(p_new_class_id, to_class_id),
        audience_value = COALESCE(p_new_audience_value, audience_value),
        priority = COALESCE(p_new_priority, priority),
        created_at = COALESCE(p_new_date, created_at),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_notification_id;
    
    RAISE NOTICE 'Оповещение ID % обновлено', p_notification_id;
END;
$$;

-- Процедура удаления оповещения
CREATE OR REPLACE PROCEDURE delete_notification(
    p_notification_id INT,
    p_user_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_can_delete BOOLEAN := FALSE;
    v_created_by INT;
    v_user_role VARCHAR(10);
BEGIN
    -- Проверка существования
    IF NOT EXISTS (SELECT 1 FROM notifications WHERE id = p_notification_id) THEN
        RAISE EXCEPTION 'Оповещение с ID % не найдено', p_notification_id;
    END IF;
    
    -- Получаем информацию об оповещении и пользователе
    SELECT n.created_by, r.name INTO v_created_by, v_user_role
    FROM notifications n
    JOIN users u ON u.id = p_user_id
    JOIN roles r ON u.role_id = r.id
    WHERE n.id = p_notification_id;
    
    -- Проверка прав
    IF v_user_role = 'admin' OR v_created_by = p_user_id THEN
        v_can_delete := TRUE;
    END IF;
    
    IF NOT v_can_delete THEN
        RAISE EXCEPTION 'Нет прав для удаления';
    END IF;
    
    -- Удаляем
    DELETE FROM notifications WHERE id = p_notification_id;
    
    RAISE NOTICE 'Оповещение ID % удалено', p_notification_id;
END;
$$;

-- Процедура изменения статуса прочтения
CREATE OR REPLACE PROCEDURE mark_notification_read(
    p_notification_id INT,
    p_user_id INT,
    p_is_read BOOLEAN DEFAULT TRUE
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Проверка существования
    IF NOT EXISTS (SELECT 1 FROM notifications WHERE id = p_notification_id) THEN
        RAISE EXCEPTION 'Оповещение с ID % не найдено', p_notification_id;
    END IF;
    
    -- Проверка доступа пользователя к оповещению
    IF NOT EXISTS (
        SELECT 1 FROM notifications n
        WHERE n.id = p_notification_id
        AND (
            -- Админ видит все
            (SELECT r.name FROM users u JOIN roles r ON u.role_id = r.id WHERE u.id = p_user_id) = 'admin'
            OR
            -- Учитель видит оповещения для всех или для своих классов
            n.audience_type IN ('school', 'teachers', 'classes')
            OR
            -- Или оповещения для конкретного класса, где он преподает
            (n.audience_type = 'class' AND n.to_class_id IN (
                SELECT DISTINCT l.class_id 
                FROM lessons l 
                WHERE l.teacher_id = p_user_id
            ))
            OR
            -- Или свои собственные оповещения
            n.created_by = p_user_id
        )
    ) THEN
        RAISE EXCEPTION 'Нет доступа к этому оповещению';
    END IF;
    
    -- Обновляем статус
    UPDATE notifications 
    SET 
        is_read = p_is_read,
        read_at = CASE WHEN p_is_read THEN CURRENT_TIMESTAMP ELSE NULL END
    WHERE id = p_notification_id;
    
    RAISE NOTICE 'Статус оповещения ID % изменен на %', p_notification_id, 
        CASE WHEN p_is_read THEN 'прочитано' ELSE 'не прочитано' END;
END;
$$;

-- Функция получения оповещений
CREATE OR REPLACE FUNCTION get_notifications(
    p_user_id INT,
    p_only_unread BOOLEAN DEFAULT FALSE,
    p_limit_count INT DEFAULT 50
)
RETURNS TABLE (
    id INT,
    от_кого VARCHAR(150),
    кому VARCHAR(200),
    дата_время TIMESTAMP,
    заголовок VARCHAR(200),
    текст TEXT,
    тип_аудитории VARCHAR(20),
    id_класса INT,
    приоритет INT,
    прочитано BOOLEAN,
    можно_редактировать BOOLEAN,
    создано_пользователем INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_role VARCHAR(10);
BEGIN
    -- Получаем роль пользователя
    SELECT r.name INTO v_user_role
    FROM users u
    JOIN roles r ON u.role_id = r.id
    WHERE u.id = p_user_id;
    
    RETURN QUERY
    SELECT 
        n.id,
        COALESCE(n.from_user_display_name, u.fio, 'Система') as от_кого,
        CASE n.audience_type
            WHEN 'school' THEN 'Вся школа'
            WHEN 'teachers' THEN 'Все учителя'
            WHEN 'classes' THEN 'Все классы'
            WHEN 'class' THEN 'Класс ' || COALESCE(c.name, n.audience_value)
            WHEN 'custom' THEN n.audience_value
            ELSE 'Все'
        END as кому,
        n.created_at as дата_время,
        n.title as заголовок,
        n.message as текст,
        n.audience_type as тип_аудитории,
        n.to_class_id as id_класса,
        n.priority as приоритет,
        n.is_read as прочитано,
        (v_user_role = 'admin' OR n.created_by = p_user_id) as можно_редактировать,
        n.created_by as создано_пользователем
    FROM notifications n
    LEFT JOIN users u ON n.from_user_id = u.id
    LEFT JOIN classes c ON n.to_class_id = c.id
    WHERE 
        (NOT p_only_unread OR n.is_read = FALSE) AND
        (
            v_user_role = 'admin' OR
            n.audience_type IN ('school', 'teachers', 'classes') OR
            (n.audience_type = 'class' AND n.to_class_id IN (
                SELECT DISTINCT l.class_id FROM lessons l WHERE l.teacher_id = p_user_id
            )) OR
            n.created_by = p_user_id
        )
    ORDER BY n.priority DESC, n.created_at DESC
    LIMIT p_limit_count;
END;
$$;

-- Функция получения домашних заданий ученика
CREATE OR REPLACE FUNCTION get_student_homeworks(
    p_student_user_id INT,
    p_show_only_active BOOLEAN DEFAULT TRUE
)
RETURNS TABLE (
    homework_id INT,
    subject_name VARCHAR(100),
    topic VARCHAR(255),
    description TEXT,
    assigned_date DATE,
    deadline_date DATE,
    days_left INT,
    status VARCHAR(20),
    student_grade VARCHAR(2),
    teacher_fio VARCHAR(150),
    is_overdue TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        hw.id AS homework_id,
        s.name AS subject_name,
        hw.topic,
        hw.description,
        (hw.deadline_date - INTERVAL '7 days')::DATE AS assigned_date,
        hw.deadline_date,
        (hw.deadline_date - CURRENT_DATE)::INT AS days_left,
        -- СТАТУСЫ НА РУССКОМ
        CASE COALESCE(hws.status, 
            CASE 
                WHEN CURRENT_DATE > hw.deadline_date THEN 'overdue'
                ELSE 'missing'
            END)
            WHEN 'missing' THEN 'Не выполнено'
            WHEN 'submitted' THEN 'Сдано'
            WHEN 'checked' THEN 'Проверено'
            WHEN 'late' THEN 'Сдано с опозданием'
            WHEN 'returned' THEN 'Возвращено на доработку'
            WHEN 'overdue' THEN 'Просрочено'
            ELSE COALESCE(hws.status, 'Не выполнено')
        END AS status,
        hws.grade AS student_grade,
        u.fio AS teacher_fio,
        CASE 
            WHEN CURRENT_DATE > hw.deadline_date THEN 'Да'
            ELSE 'Нет'
        END AS is_overdue
    FROM students st
    JOIN homeworks hw ON st.class_id = hw.class_id
    JOIN subjects s ON hw.subject_id = s.id
    JOIN teachers t ON hw.teacher_id = t.user_id
    JOIN users u ON t.user_id = u.id
    LEFT JOIN homework_submissions hws ON hw.id = hws.homework_id 
        AND hws.student_id = p_student_user_id
    WHERE st.user_id = p_student_user_id
      AND (
          NOT p_show_only_active 
          OR hw.deadline_date >= CURRENT_DATE - 30
          OR hws.status IN ('submitted', 'checked', 'late', 'returned')
      )
    ORDER BY 
        hw.deadline_date ASC,
        s.name;
END;
$$;

-- Процедура создания пользователя
CREATE OR REPLACE PROCEDURE create_user(
    p_full_name VARCHAR(150),
    p_login VARCHAR(50),
    p_password_hash VARCHAR(100),
    p_role VARCHAR(20),
    p_email VARCHAR(100) DEFAULT NULL,
    p_student_class VARCHAR(20) DEFAULT NULL,
    p_student_new_class VARCHAR(20) DEFAULT NULL,
    p_student_notes TEXT DEFAULT NULL,
    p_teacher_subject VARCHAR(100) DEFAULT NULL,
    p_teacher_new_subject VARCHAR(100) DEFAULT NULL,
    p_teacher_position VARCHAR(100) DEFAULT NULL,
    p_admin_notes TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_id INT;
    v_role_id INT;
    v_class_id INT;
    v_subject_id INT;
    v_contacts TEXT := '';
    v_role_upper VARCHAR(20);
BEGIN
    -- Преобразуем роль в верхний регистр
    v_role_upper := UPPER(p_role);
    
    -- Получаем ID роли
    IF v_role_upper = 'STUDENT' THEN
        v_role_id := 3;
    ELSIF v_role_upper = 'TEACHER' THEN
        v_role_id := 2;
    ELSIF v_role_upper = 'ADMIN' THEN
        v_role_id := 1;
    ELSE
        RAISE EXCEPTION 'Неизвестная роль: %', p_role;
    END IF;
    
    -- Проверка уникальности логина
    IF EXISTS (SELECT 1 FROM users WHERE login = p_login) THEN
        RAISE EXCEPTION 'Логин "%" уже существует', p_login;
    END IF;
    
    -- Проверка email
    IF p_email IS NOT NULL THEN
        IF EXISTS (SELECT 1 FROM users WHERE email = p_email) THEN
            RAISE EXCEPTION 'Email "%" уже используется', p_email;
        END IF;
    END IF;
    
    -- Собираем контакты
    IF p_email IS NOT NULL THEN
        v_contacts := 'email: ' || p_email;
    END IF;
    
    -- Создаем пользователя
    INSERT INTO users (role_id, login, password_hash, fio, email, contacts, created_at)
    VALUES (v_role_id, p_login, p_password_hash, p_full_name, p_email, v_contacts, NOW())
    RETURNING id INTO v_user_id;
    
    -- Обрабатываем в зависимости от роли
    CASE v_role_upper
        WHEN 'STUDENT' THEN
            -- Обработка класса ученика
            IF p_student_new_class IS NOT NULL THEN
                -- Создаем новый класс
                INSERT INTO classes (name, created_at)
                VALUES (p_student_new_class, NOW())
                RETURNING id INTO v_class_id;
            ELSIF p_student_class IS NOT NULL THEN
                -- Ищем существующий класс
                SELECT id INTO v_class_id 
                FROM classes 
                WHERE name = p_student_class;
                
                IF v_class_id IS NULL THEN
                    RAISE EXCEPTION 'Класс "%" не найден', p_student_class;
                END IF;
            ELSE
                RAISE EXCEPTION 'Для ученика необходимо указать класс';
            END IF;
            
            -- Создаем запись ученика
            INSERT INTO students (user_id, class_id, notes, created_at)
            VALUES (v_user_id, v_class_id, p_student_notes, NOW());
            
            -- Добавляем в журнал (если таблица существует)
            BEGIN
                INSERT INTO lesson_journal (lesson_id, student_id, created_at)
                SELECT l.id, v_user_id, NOW()
                FROM lessons l
                WHERE l.class_id = v_class_id
                  AND l.date >= CURRENT_DATE
                ON CONFLICT DO NOTHING;
            EXCEPTION WHEN undefined_table THEN
                -- Таблицы нет, пропускаем
                NULL;
            END;
            
        WHEN 'TEACHER' THEN
            -- Обработка предмета учителя
            IF p_teacher_new_subject IS NOT NULL THEN
                -- Создаем новый предмет
                INSERT INTO subjects (name, created_at)
                VALUES (p_teacher_new_subject, NOW())
                RETURNING id INTO v_subject_id;
            ELSIF p_teacher_subject IS NOT NULL THEN
                -- Ищем существующий предмет
                SELECT id INTO v_subject_id 
                FROM subjects 
                WHERE name = p_teacher_subject;
                
                IF v_subject_id IS NULL THEN
                    RAISE EXCEPTION 'Предмет "%" не найден', p_teacher_subject;
                END IF;
            ELSE
                RAISE EXCEPTION 'Для учителя необходимо указать предмет';
            END IF;
            
            -- Создаем запись учителя
            INSERT INTO teachers (user_id, position, created_at)
            VALUES (v_user_id, p_teacher_position, NOW());
            
            -- Связываем учителя с предметом
            INSERT INTO teacher_subjects (teacher_id, subject_id, created_at)
            VALUES (v_user_id, v_subject_id, NOW());
            
        WHEN 'ADMIN' THEN
            -- Создаем запись администратора
            INSERT INTO administrators (user_id, notes, created_at)
            VALUES (v_user_id, p_admin_notes, NOW());
            
        ELSE
            RAISE EXCEPTION 'Неизвестная роль';
    END CASE;
    
    RAISE NOTICE 'Пользователь успешно создан: % (ID: %, Роль: %)', 
                 p_full_name, v_user_id, v_role_upper;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Ошибка при создании пользователя: %', SQLERRM;
END;
$$;
DROP FUNCTION IF EXISTS get_teacher_schedule_by_date(INT, DATE);

CREATE OR REPLACE FUNCTION get_teacher_schedule_by_date(
    p_teacher_id INT,
    p_date DATE DEFAULT CURRENT_DATE
) 
RETURNS TABLE (
    lesson_id BIGINT,      
    lesson_num INT,        -- Номер урока (1, 2, 3...)
    subject_name VARCHAR,  -- Название предмета
    class_name VARCHAR,    -- Название класса
    room_number VARCHAR    -- Номер кабинета
) 
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ((st.id::BIGINT * 100) + EXTRACT(ISODOW FROM p_date)::BIGINT) as virtual_lesson_id,
        st.lesson_num,
        s.name::VARCHAR,
        c.name::VARCHAR,
        cr.room_number::VARCHAR
    FROM schedule_template st
    JOIN subjects s ON st.subject_id = s.id
    JOIN classes c ON st.class_id = c.id
    JOIN classrooms cr ON st.room_id = cr.id
    WHERE st.teacher_id = p_teacher_id
      AND st.day_of_week = EXTRACT(ISODOW FROM p_date)
    ORDER BY st.lesson_num;
END;
$$ LANGUAGE plpgsql;
