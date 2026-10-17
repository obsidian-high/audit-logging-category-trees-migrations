
-- Enable row-level security for student records.
ALTER TABLE students ENABLE ROW LEVEL SECURITY;

-- The application roles can access student rows through explicit policies.
CREATE POLICY students_app_read
ON students
FOR SELECT
TO app_read
USING (true);

CREATE POLICY students_app_write_select
ON students
FOR SELECT
TO app_write
USING (true);

CREATE POLICY students_app_write_insert
ON students
FOR INSERT
TO app_write
WITH CHECK (true);

CREATE POLICY students_app_write_update
ON students
FOR UPDATE
TO app_write
USING (true)
WITH CHECK (true);

CREATE POLICY students_app_write_delete
ON students
FOR DELETE
TO app_write
USING (true);
