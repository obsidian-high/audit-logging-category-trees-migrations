-- V1: Core tables
-- Create the students table if it does not already exist.

CREATE TABLE IF NOT EXISTS students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    course VARCHAR(100),
    marks INTEGER
);
