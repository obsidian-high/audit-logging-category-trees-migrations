-- Demonstrate audit logging.
-- Run against bootcamp after applying V2.

BEGIN;

-- INSERT example
INSERT INTO students (name, course, marks)
VALUES ('Audit Demo', 'Database Systems', 80);

-- UPDATE example
UPDATE students
SET marks = 81
WHERE name = 'Audit Demo'
  AND course = 'Database Systems';

-- DELETE example
DELETE FROM students
WHERE name = 'Audit Demo'
  AND course = 'Database Systems';

-- Inspect the audit trail
SELECT
    tbl,
    op,
    old_row ->> 'name' AS old_name,
    new_row ->> 'name' AS new_name,
    changed_by,
    at
FROM audit_log
ORDER BY at DESC;

-- Undo the demo data and audit records.
ROLLBACK;
