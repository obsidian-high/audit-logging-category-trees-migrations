# Audit Logging, Category Trees, and Safe Migrations

## Project Overview

This project demonstrates PostgreSQL database design, versioned schema
migrations, audit logging, hierarchical category data, query optimization,
least-privilege security, and database backup and recovery.

## Requirements

- PostgreSQL
- Flyway
- PostgreSQL JDBC driver
- Git

## Database Safety

The project was developed and tested using a dedicated database named
`capstone_test`. The existing `bootcamp` database was not modified.

## Database Migrations

The canonical Flyway migrations are stored in `migrations/`.

| Migration | Purpose |
|---|---|
| V1 | Core student table |
| V2 | Audit logging and triggers |
| V3 | Database indexes |
| V4 | Hierarchical categories |
| V5 | Application read/write roles and permissions |
| V6 | Demonstration data |
| V7 | Row-level security policies |
| V8 | Secure audit trigger using a restricted owner |

Check migration status:

```bash
flyway -url="jdbc:postgresql://localhost:5432/capstone_test" \
  -user="fatush" -locations="filesystem:migrations" info
```

Apply pending migrations:

```bash
flyway -url="jdbc:postgresql://localhost:5432/capstone_test" \
  -user="fatush" -locations="filesystem:migrations" migrate
```

## Audit Logging

The `audit_log` table stores INSERT, UPDATE, and DELETE events,
including old and new row values in JSONB format.

The `trg_students_audit` trigger records changes to student records.
The audit function uses SECURITY DEFINER and a restricted `audit_writer`
role to permit audit inserts without granting application users direct
write access to the audit table.

Verification demonstrated that INSERT, UPDATE, and DELETE events were
recorded and attributed to the active `app_write` role.

## Category Hierarchy

The `categories` table uses a self-referencing parent relationship to
represent nested categories.

Example hierarchy:

Electronics
- Computers
  - Laptops
- Phones

A recursive common table expression can retrieve descendants of a
category.

## Query Optimization

The `students` table has indexes on `name` and `course`, in addition
to its primary-key index.

Query plan tested:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM students WHERE name = 'Amina Hassan';
```

Observed result: PostgreSQL used `idx_students_name` with an execution
time of approximately 0.151 ms in the local test environment.

Execution time depends on hardware, data size, caching, and database
conditions; this result is a demonstration, not a universal benchmark.

## Security Verification

The project defines separate `app_read` and `app_write` roles.

Tests confirmed:
- `app_write` could insert, update, and delete student records.
- All three operations were recorded in the audit log.
- `app_read` could not update student records.
- Amina Hassan's marks remained unchanged at 85 after the rejected
  update attempt.

Row-level security policies are included as a demonstration. The
current policies allow application roles to access all applicable
rows; they do not implement tenant-level data isolation.

## Backup and Recovery

Create a plain SQL backup:

```bash
mkdir -p backups
pg_dump capstone_test > backups/capstone_test_backup.sql
```

Restore into a separate test database:

```bash
createdb capstone_restore_test
psql capstone_restore_test < backups/capstone_test_backup.sql
```

Verify restored student records:

```bash
psql capstone_restore_test -c \
  "SELECT student_id, name, course, marks FROM students ORDER BY student_id;"
```

Verify restored audit records:

```bash
psql capstone_restore_test -c \
  "SELECT COUNT(*) AS audit_records FROM audit_log;"
```

The recovery test restored all four demonstration student records and
nine audit records. The database objects, indexes, trigger, security
policies, and grants were also present in the restore output.

The restore test was performed on the same PostgreSQL instance where
the required application and audit roles had already been created.

The included backup contains demonstration data only. Do not commit
real personal, confidential, or production database data to GitHub.

## NoSQL Design Decision

PostgreSQL was selected as the primary database because this project
depends on relational constraints, structured records, hierarchical
relationships, transactions, and auditable changes. A separate NoSQL
database was not introduced because no requirement demonstrated a
clear benefit that justified the added complexity.

## Repository Contents

- `migrations/` — versioned Flyway migrations
- `docs/` — project requirements and design documentation
- `backups/` — demonstration SQL backup
- `audit_demo.sql` — audit demonstration script
- `README.md` — setup, implementation, and verification guide

## Project Status

The migrations, audit logging, category hierarchy, indexes, application
roles, row-level security policies, and backup/restore process have
been executed and tested in the local PostgreSQL environment.
