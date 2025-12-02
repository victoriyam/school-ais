-- роли
INSERT INTO roles (id, name) VALUES 
(1, 'admin'), 
(2, 'teacher'), 
(3, 'student');

-- предметы
INSERT INTO subjects (id, name) VALUES
(1, 'Математика'),
(2, 'Алгебра'),
(3, 'Геометрия'),
(4, 'Русский язык'),
(5, 'Литература'),
(6, 'Химия'),
(7, 'География'),
(8, 'Физика'),
(9, 'Информатика'),
(10, 'Музыка'),
(11, 'ИЗО'),
(12, 'ОБЖ'),
(13, 'Технология'),
(14, 'История'),
(15, 'Обществознание'),
(16, 'Биология'),
(17, 'Английский язык'),
(18, 'Экономика'),
(19, 'Право');

-- классы
INSERT INTO classes (id, name) VALUES
(1, '5А'), (2, '5Б'), (3, '6А'), (4, '6Б'), (5, '7А'), (6, '7Б'),
(7, '8А'), (8, '8Б'), (9, '9А'), (10, '9Б'), (11, '10А'), (12, '10Б'),
(13, '11А'), (14, '11Б');

-- кабинеты
INSERT INTO classrooms (id, room_number, teacher_name) VALUES
(1, '100', 'Гончарова Е.В.'),
(2, '101', 'Андросова М.П.'),
(3, '102', 'Николаева Т.И.'),
(4, '103', 'Андреева О.С.'),
(5, '104', 'Маркова Д.К.'),
(6, '105', 'Облакова Н.В.'),
(7, '106', 'Васильев А.Р.'),
(8, '107', 'Гитарова Л.М.'),
(9, '108', 'Дмитриев С.Ю.'),
(10, '109', 'Шевцова И.А.'),
(11, '110', 'Иванова К.Л.'),
(12, '111', 'Сидорова Е.Н.'),
(13, '112', 'Щукина В.Г.'),
(14, '113', 'Богданов П.С.');

-- пользователи
-- Админ
INSERT INTO users (id, role_id, login, password_hash, fio, contacts) VALUES
(1, 1, 'boiko', 'admin123', 'Бойко Е.В.', 'Директор');

-- Учителя с кабинетами
INSERT INTO users (id, role_id, login, password_hash, fio, contacts) VALUES
(2, 2, 'goncharova', 'teacher123', 'Гончарова Е.В.', 'Математика, Алгебра, Геометрия'),
(3, 2, 'androsova', 'teacher123', 'Андросова М.П.', 'Математика, Алгебра, Геометрия'),
(4, 2, 'nikolaeva', 'teacher123', 'Николаева Т.И.', 'Русский язык, Литература'),
(5, 2, 'andreeva', 'teacher123', 'Андреева О.С.', 'Русский язык, Литература'),
(6, 2, 'markova', 'teacher123', 'Маркова Д.К.', 'Химия'),
(7, 2, 'oblakova', 'teacher123', 'Облакова Н.В.', 'География'),
(8, 2, 'vasiliev', 'teacher123', 'Васильев А.Р.', 'Физика, Информатика'),
(9, 2, 'gitrova', 'teacher123', 'Гитарова Л.М.', 'Музыка, ИЗО'),
(10, 2, 'dmitriev', 'teacher123', 'Дмитриев С.Ю.', 'ОБЖ, Технология'),
(11, 2, 'shevtsova', 'teacher123', 'Шевцова И.А.', 'История, Обществознание'),
(12, 2, 'ivanova', 'teacher123', 'Иванова К.Л.', 'Биология'),
(13, 2, 'sidorova', 'teacher123', 'Сидорова Е.Н.', 'Английский язык'),
(14, 2, 'shchukina', 'teacher123', 'Щукина В.Г.', 'Экономика, Право'),
(15, 2, 'bogdanov', 'teacher123', 'Богданов П.С.', 'Завуч');

-- Ученики 5А-11Б (по 3 в каждом классе)
INSERT INTO users (id, role_id, login, password_hash, fio, contacts) VALUES
-- 5А (ID: 16-18)
(16, 3, 'student_5a_1', 'student123', 'Иванов И.И.', '5А'),
(17, 3, 'student_5a_2', 'student123', 'Смирнов С.С.', '5А'),
(18, 3, 'student_5a_3', 'student123', 'Козлова К.К.', '5А'),
-- 5Б (ID: 19-21)
(19, 3, 'student_5b_1', 'student123', 'Петров П.П.', '5Б'),
(20, 3, 'student_5b_2', 'student123', 'Соколова А.А.', '5Б'),
(21, 3, 'student_5b_3', 'student123', 'Морозов М.М.', '5Б'),
-- 6А (ID: 22-24)
(22, 3, 'student_6a_1', 'student123', 'Волков В.В.', '6А'),
(23, 3, 'student_6a_2', 'student123', 'Лебедева Л.Л.', '6А'),
(24, 3, 'student_6a_3', 'student123', 'Новиков Н.Н.', '6А'),
-- 6Б (ID: 25-27)
(25, 3, 'student_6b_1', 'student123', 'Федоров Ф.Ф.', '6Б'),
(26, 3, 'student_6b_2', 'student123', 'Егорова Е.Е.', '6Б'),
(27, 3, 'student_6b_3', 'student123', 'Антонов А.А.', '6Б'),
-- 7А (ID: 28-30)
(28, 3, 'student_7a_1', 'student123', 'Григорьев Г.Г.', '7А'),
(29, 3, 'student_7a_2', 'student123', 'Дмитриева Д.Д.', '7А'),
(30, 3, 'student_7a_3', 'student123', 'Степанов С.С.', '7А'),
-- 7Б (ID: 31-33)
(31, 3, 'student_7b_1', 'student123', 'Романов Р.Р.', '7Б'),
(32, 3, 'student_7b_2', 'student123', 'Орлова О.О.', '7Б'),
(33, 3, 'student_7b_3', 'student123', 'Титов Т.Т.', '7Б'),
-- 8А (ID: 34-36)
(34, 3, 'student_8a_1', 'student123', 'Кузнецов К.К.', '8А'),
(35, 3, 'student_8a_2', 'student123', 'Васильева В.В.', '8А'),
(36, 3, 'student_8a_3', 'student123', 'Сергеев С.С.', '8А'),
-- 8Б (ID: 37-39)
(37, 3, 'student_8b_1', 'student123', 'Алексеев А.А.', '8Б'),
(38, 3, 'student_8b_2', 'student123', 'Зайцева З.З.', '8Б'),
(39, 3, 'student_8b_3', 'student123', 'Борисов Б.Б.', '8Б'),
-- 9А (ID: 40-42)
(40, 3, 'student_9a_1', 'student123', 'Максимов М.М.', '9А'),
(41, 3, 'student_9a_2', 'student123', 'Ильина И.И.', '9А'),
(42, 3, 'student_9a_3', 'student123', 'Горбунов Г.Г.', '9А'),
-- 9Б (ID: 43-45)
(43, 3, 'student_9b_1', 'student123', 'Ефимов Е.Е.', '9Б'),
(44, 3, 'student_9b_2', 'student123', 'Жукова Ж.Ж.', '9Б'),
(45, 3, 'student_9b_3', 'student123', 'Зимин З.З.', '9Б'),
-- 10А (ID: 46-48)
(46, 3, 'student_10a_1', 'student123', 'Кириллов К.К.', '10А'),
(47, 3, 'student_10a_2', 'student123', 'Ларионов Л.Л.', '10А'),
(48, 3, 'student_10a_3', 'student123', 'Макаров М.М.', '10А'),
-- 10Б (ID: 49-51)
(49, 3, 'student_10b_1', 'student123', 'Назаров Н.Н.', '10Б'),
(50, 3, 'student_10b_2', 'student123', 'Овчинников О.О.', '10Б'),
(51, 3, 'student_10b_3', 'student123', 'Павлов П.П.', '10Б'),
-- 11А (ID: 52-54)
(52, 3, 'student_11a_1', 'student123', 'Рубцов Р.Р.', '11А'),
(53, 3, 'student_11a_2', 'student123', 'Сазонов С.С.', '11А'),
(54, 3, 'student_11a_3', 'student123', 'Тихонов Т.Т.', '11А'),
-- 11Б (ID: 55-57)
(55, 3, 'student_11b_1', 'student123', 'Уваров У.У.', '11Б'),
(56, 3, 'student_11b_2', 'student123', 'Фомин Ф.Ф.', '11Б'),
(57, 3, 'student_11b_3', 'student123', 'Хохлов Х.Х.', '11Б');

-- админ
INSERT INTO administrators (user_id, position) VALUES (1, 'Директор');

--учителя
INSERT INTO teachers (user_id, room_id) VALUES
(2, 1), (3, 2), (4, 3), (5, 4), (6, 5), (7, 6), (8, 7), (9, 8), 
(10, 9), (11, 10), (12, 11), (13, 12), (14, 13), (15, 14);

-- ученики
INSERT INTO students (user_id, class_id) VALUES
-- 5А
(16, 1), (17, 1), (18, 1),
-- 5Б
(19, 2), (20, 2), (21, 2),
-- 6А
(22, 3), (23, 3), (24, 3),
-- 6Б
(25, 4), (26, 4), (27, 4),
-- 7А
(28, 5), (29, 5), (30, 5),
-- 7Б
(31, 6), (32, 6), (33, 6),
-- 8А
(34, 7), (35, 7), (36, 7),
-- 8Б
(37, 8), (38, 8), (39, 8),
-- 9А
(40, 9), (41, 9), (42, 9),
-- 9Б
(43, 10), (44, 10), (45, 10),
-- 10А
(46, 11), (47, 11), (48, 11),
-- 10Б
(49, 12), (50, 12), (51, 12),
-- 11А
(52, 13), (53, 13), (54, 13),
-- 11Б
(55, 14), (56, 14), (57, 14);

-- учитель и предмет, который он ведет
INSERT INTO teacher_subjects (teacher_id, subject_id) VALUES
-- Гончарова
(2, 1), (2, 2), (2, 3),
-- Андросова
(3, 1), (3, 2), (3, 3),
-- Николаева
(4, 4), (4, 5),
-- Андреева
(5, 4), (5, 5),
-- Маркова
(6, 6),
-- Облакова
(7, 7),
-- Васильев
(8, 8), (8, 9),
-- Гитарова
(9, 10), (9, 11),
-- Дмитриев
(10, 12), (10, 13),
-- Шевцова
(11, 14), (11, 15),
-- Иванова
(12, 16),
-- Сидорова
(13, 17),
-- Щукина
(14, 18), (14, 19);

-- расписание для 10-х классов
INSERT INTO schedule_template (id, class_id, subject_id, teacher_id, room_id, day_of_week, lesson_num) VALUES
-- 10А класс
(1, 11, 1, 2, 1, 1, 1),   -- Пн, 1 урок: Математика
(2, 11, 4, 4, 3, 1, 2),   -- Пн, 2 урок: Русский
(3, 11, 8, 8, 7, 1, 3),   -- Пн, 3 урок: Физика
(4, 11, 17, 13, 12, 2, 1), -- Вт, 1 урок: Английский
(5, 11, 2, 2, 1, 2, 2),   -- Вт, 2 урок: Алгебра
(6, 11, 14, 11, 10, 3, 1), -- Ср, 1 урок: История
(7, 11, 9, 8, 7, 3, 2),   -- Ср, 2 урок: Информатика
(8, 11, 3, 2, 1, 4, 1),   -- Чт, 1 урок: Геометрия
(9, 11, 5, 4, 3, 4, 2),   -- Чт, 2 урок: Литература
(10, 11, 15, 11, 10, 5, 1), -- Пт, 1 урок: Обществознание
-- 10Б класс
(11, 12, 1, 3, 2, 1, 1),  -- Пн, 1 урок: Математика
(12, 12, 4, 5, 4, 1, 2),  -- Пн, 2 урок: Русский
(13, 12, 6, 6, 5, 2, 1),  -- Вт, 1 урок: Химия
(14, 12, 7, 7, 6, 2, 2),  -- Вт, 2 урок: География
(15, 12, 16, 12, 11, 3, 1); -- Ср, 1 урок: Биология

-- уроки
INSERT INTO lessons (id, teacher_id, class_id, subject_id, room_id, date, lesson_num, topic) VALUES
(1, 2, 11, 1, 1, CURRENT_DATE, 1, 'Решение квадратных уравнений'),
(2, 4, 11, 4, 3, CURRENT_DATE, 2, 'Анализ художественного текста'),
(3, 8, 11, 8, 7, CURRENT_DATE, 3, 'Законы Ньютона'),
(4, 13, 11, 17, 12, CURRENT_DATE + 1, 1, 'Грамматика английского языка'),
(5, 2, 11, 2, 1, CURRENT_DATE + 1, 2, 'Решение систем уравнений'),
(6, 11, 11, 14, 10, CURRENT_DATE + 2, 1, 'Вторая мировая война'),
(7, 8, 11, 9, 7, CURRENT_DATE + 2, 2, 'Основы программирования');

-- журнал
INSERT INTO lesson_journal (lesson_id, student_id, presence, grade) VALUES
-- Урок 1 (Математика 10А)
(1, 46, '', '5'),  -- Кириллов
(1, 47, 'н', ''),  -- Ларионов отсутствовал
(1, 48, '', '4'),  -- Макаров
-- Урок 2 (Русский 10А)
(2, 46, '', '4'),
(2, 47, '', '5'),
(2, 48, '', '3'),
-- Урок 3 (Физика 10А)
(3, 46, '', '5'),
(3, 47, 'б', ''),  -- Ларионов болел
(3, 48, '', '4');

-- оценки
INSERT INTO grades (id, student_id, subject_id, date, grade_value, attendance) VALUES
-- Кириллов (46)
(1, 46, 1, CURRENT_DATE - 7, '5', ''),
(2, 46, 1, CURRENT_DATE - 5, '4', ''),
(3, 46, 4, CURRENT_DATE - 6, '5', ''),
(4, 46, 8, CURRENT_DATE - 4, '4', ''),
(5, 46, 17, CURRENT_DATE - 3, '5', ''),
-- Ларионов (47)
(6, 47, 1, CURRENT_DATE - 7, '3', ''),
(7, 47, 4, CURRENT_DATE - 6, '4', ''),
(8, 47, 8, CURRENT_DATE - 4, '5', ''),
(9, 47, 17, CURRENT_DATE - 3, '4', ''),
-- Макаров (48)
(10, 48, 1, CURRENT_DATE - 7, '4', ''),
(11, 48, 4, CURRENT_DATE - 6, '3', ''),
(12, 48, 8, CURRENT_DATE - 4, '4', ''),
(13, 48, 17, CURRENT_DATE - 3, '3', '');

-- сессии пользователей
INSERT INTO user_sessions (id, user_id, session_token, expires_at) VALUES
(1, 2, 'teacher_math_token', CURRENT_TIMESTAMP + INTERVAL '1 day'),     -- Гончарова
(2, 46, 'student_10a_token', CURRENT_TIMESTAMP + INTERVAL '1 day'),     -- Кириллов
(3, 1, 'admin_token', CURRENT_TIMESTAMP + INTERVAL '1 day'),            -- Админ
(4, 8, 'teacher_physics_token', CURRENT_TIMESTAMP + INTERVAL '1 day'),  -- Васильев
(5, 47, 'student_10a_2_token', CURRENT_TIMESTAMP + INTERVAL '1 day');   -- Ларионов

-- дз от учителя
INSERT INTO homeworks (id, teacher_id, class_id, subject_id, topic, description, deadline_date) VALUES
(1, 2, 11, 1, 'Квадратные уравнения', 'Решить задачи 1-20 из учебника стр. 45-50', CURRENT_DATE + 7),
(2, 4, 11, 4, 'Сочинение', 'Написать сочинение на тему "Весна" (объем 2 страницы)', CURRENT_DATE + 5),
(3, 8, 11, 8, 'Лабораторная работа №3', 'Выполнить измерения по физике', CURRENT_DATE + 3),
(4, 13, 11, 17, 'Перевод текста', 'Перевести текст с английского на русский', CURRENT_DATE + 4),
(5, 11, 11, 14, 'Доклад', 'Подготовить доклад по теме "Вторая мировая война"', CURRENT_DATE + 10);

-- дз от ученика
INSERT INTO homework_submissions (id, homework_id, student_id, submission_text, status, grade) VALUES
(1, 1, 46, 'Выполнил все задачи, прилагаю решение', 'checked', 5),
(2, 1, 47, 'Сделал только первые 10 задач', 'submitted', NULL),
(3, 1, 48, 'Не успел сделать', 'late', NULL),
(4, 2, 46, 'Сочинение прилагается', 'checked', 4),
(5, 2, 47, 'Не готово', 'submitted', NULL),
(6, 3, 46, 'Лабораторная работа выполнена', 'checked', 5),
(7, 3, 48, 'Частично выполнено', 'returned', 3);

-- материалы
INSERT INTO study_materials (id, teacher_id, subject_id, title, file_path) VALUES
(1, 2, 1, 'Алгебра 10 класс', '/materials/algebra_10.pdf'),
(2, 2, 3, 'Геометрия задачи', '/materials/geometry_tasks.pdf'),
(3, 4, 4, 'Русский язык правила', '/materials/russian_rules.pdf'),
(4, 8, 8, 'Физика лабораторные работы', '/materials/physics_lab.pdf'),
(5, 8, 9, 'Python для начинающих', '/materials/python_basics.pdf'),
(6, 13, 17, 'Английская грамматика', '/materials/english_grammar.pdf'),
(7, 11, 14, 'История России XX век', '/materials/history_xx.pdf');

-- оповещения
INSERT INTO notifications (id, from_user_id, to_class_id, title, message, is_read) VALUES
(1, 1, 11, 'Родительское собрание', 'Уважаемые родители! Родительское собрание состоится 25 марта в 18:00 в актовом зале.', FALSE),
(2, 2, 11, 'Контрольная работа', 'Напоминаю о контрольной работе по математике 20 марта. Не забудьте подготовиться!', FALSE),
(3, 4, NULL, 'Изменение расписания', 'Всем учителям: планерка в понедельник в 8:30 в кабинете директора.', FALSE),
(4, NULL, NULL, 'Школьный субботник', 'Уважаемые ученики и учителя! Школьный субботник состоится 22 марта с 10:00.', FALSE),
(5, 8, 11, 'Лабораторная работа', 'Принести на следующий урок лабораторные тетради и калькуляторы.', FALSE);

-- сброс (нужно чтобы ничего не ломалось при добавлении нового компонента, чтобы idшник был по порядку)
SELECT setval('roles_id_seq', (SELECT MAX(id) FROM roles));
SELECT setval('subjects_id_seq', (SELECT MAX(id) FROM subjects));
SELECT setval('classes_id_seq', (SELECT MAX(id) FROM classes));
SELECT setval('classrooms_id_seq', (SELECT MAX(id) FROM classrooms));
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
SELECT setval('schedule_template_id_seq', (SELECT MAX(id) FROM schedule_template));
SELECT setval('lessons_id_seq', (SELECT MAX(id) FROM lessons));
SELECT setval('lesson_journal_id_seq', (SELECT MAX(id) FROM lesson_journal));
SELECT setval('grades_id_seq', (SELECT MAX(id) FROM grades));
SELECT setval('user_sessions_id_seq', (SELECT MAX(id) FROM user_sessions));
SELECT setval('homeworks_id_seq', (SELECT MAX(id) FROM homeworks));
SELECT setval('homework_submissions_id_seq', (SELECT MAX(id) FROM homework_submissions));
SELECT setval('study_materials_id_seq', (SELECT MAX(id) FROM study_materials));
SELECT setval('notifications_id_seq', (SELECT MAX(id) FROM notifications));
