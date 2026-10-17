--
-- PostgreSQL database dump
--

\restrict BI6QnBYEbfPJtdrf5BcywlVOLbgraZwZcoNXsdFapXg07Qf82b3yeQFoA2HJUxD

-- Dumped from database version 14.21 (Homebrew)
-- Dumped by pg_dump version 14.21 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: audit_student_changes(); Type: FUNCTION; Schema: public; Owner: audit_writer
--

CREATE FUNCTION public.audit_student_changes() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog'
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


ALTER FUNCTION public.audit_student_changes() OWNER TO audit_writer;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log; Type: TABLE; Schema: public; Owner: fatush
--

CREATE TABLE public.audit_log (
    id bigint NOT NULL,
    tbl text NOT NULL,
    op text NOT NULL,
    old_row jsonb,
    new_row jsonb,
    changed_by text DEFAULT CURRENT_USER NOT NULL,
    at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.audit_log OWNER TO fatush;

--
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: public; Owner: fatush
--

ALTER TABLE public.audit_log ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.audit_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: fatush
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name text NOT NULL,
    parent_id integer
);


ALTER TABLE public.categories OWNER TO fatush;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: fatush
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO fatush;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fatush
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: fatush
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO fatush;

--
-- Name: students; Type: TABLE; Schema: public; Owner: fatush
--

CREATE TABLE public.students (
    student_id integer NOT NULL,
    name character varying(100) NOT NULL,
    course character varying(100),
    marks integer
);


ALTER TABLE public.students OWNER TO fatush;

--
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: public; Owner: fatush
--

CREATE SEQUENCE public.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.students_student_id_seq OWNER TO fatush;

--
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fatush
--

ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.student_id;


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: fatush
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: students student_id; Type: DEFAULT; Schema: public; Owner: fatush
--

ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_student_id_seq'::regclass);


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: fatush
--

COPY public.audit_log (id, tbl, op, old_row, new_row, changed_by, at) FROM stdin;
1	students	INSERT	\N	{"name": "Amina Hassan", "marks": 85, "course": "Computer Science", "student_id": 1}	fatush	2026-10-17 20:41:25.33945+03
2	students	INSERT	\N	{"name": "Brian Otieno", "marks": 72, "course": "Information Technology", "student_id": 2}	fatush	2026-10-17 20:41:25.33945+03
3	students	INSERT	\N	{"name": "Grace Wanjiku", "marks": 91, "course": "Database Systems", "student_id": 3}	fatush	2026-10-17 20:41:25.33945+03
4	students	INSERT	\N	{"name": "Kevin Mwangi", "marks": 68, "course": "Computer Science", "student_id": 4}	fatush	2026-10-17 20:41:25.33945+03
5	students	INSERT	\N	{"name": "Audit Test Student", "marks": 50, "course": "Testing", "student_id": 5}	fatush	2026-10-17 20:44:43.156834+03
6	students	DELETE	{"name": "Audit Test Student", "marks": 50, "course": "Testing", "student_id": 5}	\N	fatush	2026-10-17 20:45:30.141979+03
7	students	INSERT	\N	{"name": "Role Test Student", "marks": 60, "course": "Testing", "student_id": 7}	app_write	2026-10-17 20:48:20.351017+03
8	students	UPDATE	{"name": "Role Test Student", "marks": 60, "course": "Testing", "student_id": 7}	{"name": "Role Test Student", "marks": 65, "course": "Testing", "student_id": 7}	app_write	2026-10-17 20:50:38.750467+03
9	students	DELETE	{"name": "Role Test Student", "marks": 65, "course": "Testing", "student_id": 7}	\N	app_write	2026-10-17 20:50:44.215567+03
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: fatush
--

COPY public.categories (id, name, parent_id) FROM stdin;
1	Electronics	\N
2	Computers	1
3	Laptops	2
4	Phones	1
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: fatush
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	core tables	SQL	V1__core_tables.sql	-611980571	fatush	2026-10-17 20:41:25.228707	8	t
2	2	indexes	SQL	V2__indexes.sql	-544965834	fatush	2026-10-17 20:41:25.247459	4	t
3	3	audit and triggers	SQL	V3__audit_and_triggers.sql	-98868950	fatush	2026-10-17 20:41:25.25724	49	t
4	4	categories	SQL	V4__categories.sql	1726913007	fatush	2026-10-17 20:41:25.312101	9	t
5	5	security	SQL	V5__security.sql	1384952552	fatush	2026-10-17 20:41:25.326082	6	t
6	6	seed demo data	SQL	V6__seed_demo_data.sql	1281295674	fatush	2026-10-17 20:41:25.337431	5	t
7	7	row level security	SQL	V7__row_level_security.sql	294410211	fatush	2026-10-17 20:43:17.687398	10	t
8	8	secure audit trigger	SQL	V8__secure_audit_trigger.sql	-1852750102	fatush	2026-10-17 20:48:13.960837	16	t
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: fatush
--

COPY public.students (student_id, name, course, marks) FROM stdin;
1	Amina Hassan	Computer Science	85
2	Brian Otieno	Information Technology	72
3	Grace Wanjiku	Database Systems	91
4	Kevin Mwangi	Computer Science	68
\.


--
-- Name: audit_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fatush
--

SELECT pg_catalog.setval('public.audit_log_id_seq', 9, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fatush
--

SELECT pg_catalog.setval('public.categories_id_seq', 4, true);


--
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fatush
--

SELECT pg_catalog.setval('public.students_student_id_seq', 7, true);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: fatush
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: fatush
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: fatush
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: fatush
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: fatush
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_students_course; Type: INDEX; Schema: public; Owner: fatush
--

CREATE INDEX idx_students_course ON public.students USING btree (course);


--
-- Name: idx_students_name; Type: INDEX; Schema: public; Owner: fatush
--

CREATE INDEX idx_students_name ON public.students USING btree (name);


--
-- Name: students trg_students_audit; Type: TRIGGER; Schema: public; Owner: fatush
--

CREATE TRIGGER trg_students_audit AFTER INSERT OR DELETE OR UPDATE ON public.students FOR EACH ROW EXECUTE FUNCTION public.audit_student_changes();


--
-- Name: categories categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fatush
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.categories(id);


--
-- Name: students; Type: ROW SECURITY; Schema: public; Owner: fatush
--

ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;

--
-- Name: students students_app_read; Type: POLICY; Schema: public; Owner: fatush
--

CREATE POLICY students_app_read ON public.students FOR SELECT TO app_read USING (true);


--
-- Name: students students_app_write_delete; Type: POLICY; Schema: public; Owner: fatush
--

CREATE POLICY students_app_write_delete ON public.students FOR DELETE TO app_write USING (true);


--
-- Name: students students_app_write_insert; Type: POLICY; Schema: public; Owner: fatush
--

CREATE POLICY students_app_write_insert ON public.students FOR INSERT TO app_write WITH CHECK (true);


--
-- Name: students students_app_write_select; Type: POLICY; Schema: public; Owner: fatush
--

CREATE POLICY students_app_write_select ON public.students FOR SELECT TO app_write USING (true);


--
-- Name: students students_app_write_update; Type: POLICY; Schema: public; Owner: fatush
--

CREATE POLICY students_app_write_update ON public.students FOR UPDATE TO app_write USING (true) WITH CHECK (true);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: fatush
--

GRANT USAGE ON SCHEMA public TO app_read;
GRANT USAGE ON SCHEMA public TO app_write;
GRANT USAGE ON SCHEMA public TO audit_writer;


--
-- Name: TABLE audit_log; Type: ACL; Schema: public; Owner: fatush
--

GRANT SELECT ON TABLE public.audit_log TO app_read;
GRANT SELECT ON TABLE public.audit_log TO app_write;
GRANT INSERT ON TABLE public.audit_log TO audit_writer;


--
-- Name: SEQUENCE audit_log_id_seq; Type: ACL; Schema: public; Owner: fatush
--

GRANT SELECT,USAGE ON SEQUENCE public.audit_log_id_seq TO app_write;
GRANT SELECT,USAGE ON SEQUENCE public.audit_log_id_seq TO audit_writer;


--
-- Name: TABLE categories; Type: ACL; Schema: public; Owner: fatush
--

GRANT SELECT ON TABLE public.categories TO app_read;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.categories TO app_write;


--
-- Name: SEQUENCE categories_id_seq; Type: ACL; Schema: public; Owner: fatush
--

GRANT SELECT,USAGE ON SEQUENCE public.categories_id_seq TO app_write;


--
-- Name: TABLE students; Type: ACL; Schema: public; Owner: fatush
--

GRANT SELECT ON TABLE public.students TO app_read;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.students TO app_write;


--
-- Name: SEQUENCE students_student_id_seq; Type: ACL; Schema: public; Owner: fatush
--

GRANT SELECT,USAGE ON SEQUENCE public.students_student_id_seq TO app_write;


--
-- PostgreSQL database dump complete
--

\unrestrict BI6QnBYEbfPJtdrf5BcywlVOLbgraZwZcoNXsdFapXg07Qf82b3yeQFoA2HJUxD

