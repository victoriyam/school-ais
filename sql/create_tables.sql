-- роли
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL UNIQUE
);

-- предметы
CREATE TABLE subjects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- классы
CREATE TABLE classes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(10) NOT NULL UNIQUE
);

-- кабинеты
CREATE TABLE classrooms (
    id SERIAL PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    teacher_name VARCHAR(100)
);

-- пользователи
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    role_id INT NOT NULL REFERENCES roles(id),
    login VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    fio VARCHAR(150) NOT NULL,
    contacts TEXT
);

-- ученики
CREATE TABLE students (
    user_id INT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    class_id INT NOT NULL REFERENCES classes(id)
);

-- учителя
CREATE TABLE teachers (
    user_id INT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    room_id INT REFERENCES classrooms(id)
);

-- администратор
CREATE TABLE administrators (
    user_id INT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    position VARCHAR(100)
);

-- предмет учителя
CREATE TABLE teacher_subjects (
    id SERIAL PRIMARY KEY,
    teacher_id INT NOT NULL REFERENCES teachers(user_id) ON DELETE CASCADE,
    subject_id INT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    UNIQUE(teacher_id, subject_id)
);

-- уроки
CREATE TABLE lessons (
    id SERIAL PRIMARY KEY,
    teacher_id INT NOT NULL REFERENCES teachers(user_id) ON DELETE CASCADE,
    class_id INT NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    subject_id INT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    room_id INT NOT NULL REFERENCES classrooms(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    lesson_num INT NOT NULL,
    topic VARCHAR(255)
);

-- журнал
CREATE TABLE lesson_journal (
    id SERIAL PRIMARY KEY,
    lesson_id INT NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    student_id INT NOT NULL REFERENCES students(user_id) ON DELETE CASCADE,
    presence CHAR(1) DEFAULT '',
    grade VARCHAR(10) DEFAULT '',
    UNIQUE(lesson_id, student_id)
);

-- оценки
CREATE TABLE grades (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES students(user_id) ON DELETE CASCADE,
    subject_id INT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    grade_value VARCHAR(10) NOT NULL,
    attendance CHAR(1) DEFAULT ''
);

-- расписание
CREATE TABLE schedule_template (
    id SERIAL PRIMARY KEY,
    class_id INT NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    subject_id INT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    teacher_id INT NOT NULL REFERENCES teachers(user_id) ON DELETE CASCADE,
    room_id INT NOT NULL REFERENCES classrooms(id) ON DELETE CASCADE,
    day_of_week INT NOT NULL,
    lesson_num INT NOT NULL,
    UNIQUE(class_id, day_of_week, lesson_num)
);

-- сессии
CREATE TABLE user_sessions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    session_token VARCHAR(100) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL
);

-- домашнее задание от учителя
CREATE TABLE homeworks (
    id SERIAL PRIMARY KEY,
    teacher_id INT NOT NULL REFERENCES teachers(user_id) ON DELETE CASCADE,
    class_id INT NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    subject_id INT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    topic VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    deadline_date DATE NOT NULL
);
-- домашнее задание от ученика
CREATE TABLE homework_submissions (
    id SERIAL PRIMARY KEY,
    homework_id INT NOT NULL REFERENCES homeworks(id) ON DELETE CASCADE,
    student_id INT NOT NULL REFERENCES students(user_id) ON DELETE CASCADE,
    submission_text TEXT,
    status VARCHAR(20) NOT NULL CHECK (status IN ('submitted', 'checked', 'late', 'returned', 'missing')),
    grade VARCHAR(2),
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    feedback TEXT
);


-- материалы
CREATE TABLE study_materials (
    id SERIAL PRIMARY KEY,
    teacher_id INT NOT NULL REFERENCES teachers(user_id) ON DELETE CASCADE,
    subject_id INT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL
);

-- оповещения
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    from_user_id INT REFERENCES users(id) ON DELETE CASCADE,
    to_class_id INT REFERENCES classes(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE
);
