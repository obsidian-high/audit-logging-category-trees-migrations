-- V4: Least-privilege security

CREATE ROLE app_read;
CREATE ROLE app_write;

GRANT CONNECT ON DATABASE bootcamp TO app_read, app_write;
GRANT USAGE ON SCHEMA public TO app_read, app_write;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_read;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public TO app_write;

GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA public TO app_write;

-- Create a login separately, using a secure password.
-- Example:
-- CREATE USER api LOGIN PASSWORD 'replace-with-a-strong-password';
-- GRANT app_write TO api;
