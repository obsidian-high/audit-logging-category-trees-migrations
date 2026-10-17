-- Give the audit trigger a dedicated, restricted owner.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_roles WHERE rolname = 'audit_writer'
    ) THEN
        CREATE ROLE audit_writer NOLOGIN;
    END IF;
END
$$;

GRANT USAGE ON SCHEMA public TO audit_writer;
GRANT INSERT ON public.audit_log TO audit_writer;
GRANT USAGE, SELECT ON SEQUENCE public.audit_log_id_seq
TO audit_writer;

-- Replace the trigger function with a hardened SECURITY DEFINER function.
CREATE OR REPLACE FUNCTION public.audit_student_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog
AS $$
BEGIN
    INSERT INTO public.audit_log
        (tbl, op, old_row, new_row, changed_by)
    VALUES (
        TG_TABLE_NAME,
        TG_OP,
        CASE WHEN TG_OP IN ('UPDATE', 'DELETE')
             THEN to_jsonb(OLD) END,
        CASE WHEN TG_OP IN ('INSERT', 'UPDATE')
             THEN to_jsonb(NEW) END,
        COALESCE(
            NULLIF(current_setting('role', true), 'none'),
            session_user::text
        )
    );

    RETURN COALESCE(NEW, OLD);
END;
$$;

-- Transfer ownership to the restricted audit role.
GRANT CREATE ON SCHEMA public TO audit_writer;
ALTER FUNCTION public.audit_student_changes() OWNER TO audit_writer;
REVOKE CREATE ON SCHEMA public FROM audit_writer;
