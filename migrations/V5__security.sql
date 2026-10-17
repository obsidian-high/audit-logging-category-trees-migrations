
CREATE ROLE app_read NOLOGIN;
CREATE ROLE app_write NOLOGIN;

GRANT USAGE ON SCHEMA public TO app_read, app_write;

GRANT SELECT ON students, audit_log TO app_read;

GRANT SELECT, INSERT, UPDATE, DELETE
ON students TO app_write;

GRANT USAGE, SELECT
ON SEQUENCE students_student_id_seq
TO app_write;

GRANT USAGE, SELECT
ON SEQUENCE audit_log_id_seq
TO app_write;

-- Audit records should not be directly modified by the application.
GRANT SELECT ON audit_log TO app_write;

GRANT SELECT ON categories TO app_read;

GRANT SELECT, INSERT, UPDATE, DELETE
ON categories TO app_write;

GRANT USAGE, SELECT
ON SEQUENCE categories_id_seq TO app_write;
