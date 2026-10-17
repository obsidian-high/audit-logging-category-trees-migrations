
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    course VARCHAR(100),
    marks INTEGER
);
