# Requirements Summary: Audit Logging and Category Trees

## 1. Project Overview
This project develops a PostgreSQL database system that manages student records, maintains an audit trail of database changes, and supports hierarchical categories. The project demonstrates database design, versioned migrations, security, performance optimization, and reliable backup procedures.

## 2. Objectives
- Store and manage student information, including names, courses, and marks.
- Automatically record inserts, updates, and deletions in an audit log.
- Organize categories into parent-child hierarchies.
- Apply version-controlled database migrations using Flyway.
- Enforce least-privilege database access.
- Optimize queries using indexes and execution-plan analysis.
- Create backups and verify recovery through a test restore.

## 3. Stakeholders and Users
- **Database administrator:** manages the schema, migrations, security, and backups.
- **Application user:** accesses permitted student and category operations.
- **Auditor:** reviews recorded changes to support accountability.

## 4. Functional Requirements
- The system shall store student IDs, names, courses, and marks.
- The system shall automatically record changes to student records, including the operation type, previous values, new values, user, and timestamp.
- The system shall allow categories to reference parent categories.
- The system shall support queries that retrieve category hierarchies.
- The system shall apply database changes through ordered Flyway migrations.
- The system shall provide separate read and write database roles.

## 5. Non-Functional Requirements
- **Security:** database users shall receive only the privileges they need.
- **Integrity:** primary keys, foreign keys, and constraints shall protect data consistency.
- **Performance:** query optimization shall be demonstrated using EXPLAIN ANALYZE measurements.
- **Reliability:** backups shall be created and a test restoration performed.
- **Maintainability:** migrations and project documentation shall be version-controlled.
- **Auditability:** critical student-record changes shall be traceable through audit records.

## 6. Data Entities
- **Students:** stores student information.
- **Audit Log:** stores details of database changes.
- **Categories:** stores categories and their parent-child relationships.

## 7. Scope and Assumptions
The project uses PostgreSQL as the primary relational database and Flyway to manage schema migrations. Redis or MongoDB will be considered only if a suitable use case is identified. The project uses demonstration data and is intended for educational purposes.
