# Audit Logging, Category Trees, and Safe Migrations

## Objective
This lab explores PostgreSQL audit logging, hierarchical data,
versioned schema migrations, and least-privilege database security.

## Requirements
- PostgreSQL
- Flyway
- A database named `bootcamp`

## Step 1: Audit Logging
V2 creates an audit log table and a reusable trigger function.
The trigger records INSERT, UPDATE, and DELETE operations in JSONB,
including the old and new row values where applicable.

## Step 2: Audit Demonstration
The `audit_demo.sql` script demonstrates all three operations.
It uses a transaction and ROLLBACK so the demonstration does not
permanently modify the student data.

## Step 3: Category Tree
V3 creates a self-referencing categories table.
A recursive common table expression can retrieve categories
and their descendants.

## Step 4: Versioned Migrations
The V1 through V4 SQL files represent ordered schema changes.
Flyway can track and apply these migrations.

## Step 5: Least-Privilege Security
V4 defines separate read and write roles and grants only the
permissions needed for their intended tasks. Login credentials
should be configured securely and never committed to GitHub.

## Files
- `V1__core_tables.sql`: Core student table
- `V2__audit_log.sql`: Audit table, function, and trigger
- `V3__categories.sql`: Category hierarchy
- `V4__security.sql`: Database roles and permissions
- `audit_demo.sql`: Demonstration of audit operations

## Verification
Run the scripts in a test database, inspect the audit records,
query the category tree, check Flyway migration status, and verify
that read and write roles have the intended permissions.

## Status
SQL scripts are prepared for execution. Successful execution and
verification should be recorded after running the lab locally.
