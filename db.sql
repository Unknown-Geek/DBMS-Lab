--
-- PostgreSQL database dump
--

-- Dumped from database version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.2)
-- Dumped by pg_dump version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.2)

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
-- Name: before_schedules_delete_fn(); Type: FUNCTION; Schema: public; Owner: s23b71
--

CREATE FUNCTION public.before_schedules_delete_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        begin 
        insert into deleted_student_schedules values(old.classid,old.studentid,old.classstatus,old.grade);
        return old;
end; $$;


ALTER FUNCTION public.before_schedules_delete_fn() OWNER TO s23b71;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: buildings; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.buildings (
    buildingcode integer NOT NULL,
    buildingname character varying(30) NOT NULL,
    numberoffloors integer NOT NULL
);


ALTER TABLE public.buildings OWNER TO s23b71;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.categories (
    categoryid integer NOT NULL,
    categorydescription character varying(30) NOT NULL,
    departmentid integer NOT NULL
);


ALTER TABLE public.categories OWNER TO s23b71;

--
-- Name: classes; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.classes (
    classid integer NOT NULL,
    subjectid integer,
    classroomid integer,
    starttime time without time zone NOT NULL,
    duration integer NOT NULL
);


ALTER TABLE public.classes OWNER TO s23b71;

--
-- Name: classrooms; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.classrooms (
    classroomid integer NOT NULL,
    buildingcode integer,
    phoneavailable integer NOT NULL
);


ALTER TABLE public.classrooms OWNER TO s23b71;

--
-- Name: deleted_student_schedules; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.deleted_student_schedules (
    classid integer,
    studentid integer,
    classstatus character varying(30),
    grade integer
);


ALTER TABLE public.deleted_student_schedules OWNER TO s23b71;

--
-- Name: staff; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.staff (
    staffid integer NOT NULL,
    stffirstname character varying(30) NOT NULL,
    stflastname character varying(30) NOT NULL,
    stfstreetaddress character varying(30) NOT NULL,
    stfcity character varying(30) NOT NULL,
    stfstate character varying(30) NOT NULL,
    stfzipcode integer NOT NULL,
    stfareacode integer NOT NULL,
    stfphonenumber integer NOT NULL,
    joiningdate date NOT NULL,
    salary integer NOT NULL,
    "position" character varying(30) NOT NULL,
    CONSTRAINT salary CHECK ((salary > 0))
);


ALTER TABLE public.staff OWNER TO s23b71;

--
-- Name: subjects; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.subjects (
    subjectid integer NOT NULL,
    categoryid integer,
    subjectcode integer NOT NULL,
    subjectname character varying(30) NOT NULL
);


ALTER TABLE public.subjects OWNER TO s23b71;

--
-- Name: details; Type: VIEW; Schema: public; Owner: s23b71
--

CREATE VIEW public.details AS
 SELECT s.stffirstname,
    c.classid,
    sb.subjectname
   FROM public.staff s,
    public.classes c,
    public.subjects sb;


ALTER TABLE public.details OWNER TO s23b71;

--
-- Name: faculty; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.faculty (
    staffid integer NOT NULL,
    title character varying(30) NOT NULL,
    status character varying(30) NOT NULL,
    tenured date
);


ALTER TABLE public.faculty OWNER TO s23b71;

--
-- Name: faculty_categories; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.faculty_categories (
    staffid integer NOT NULL,
    categoryid integer NOT NULL
);


ALTER TABLE public.faculty_categories OWNER TO s23b71;

--
-- Name: faculty_classes; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.faculty_classes (
    staffid integer NOT NULL,
    classid integer NOT NULL
);


ALTER TABLE public.faculty_classes OWNER TO s23b71;

--
-- Name: faculty_subjects; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.faculty_subjects (
    staffid integer NOT NULL,
    subjectid integer NOT NULL,
    proficiencyrating integer NOT NULL
);


ALTER TABLE public.faculty_subjects OWNER TO s23b71;

--
-- Name: list; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.list (
    stffirstname character varying(30),
    stflastname character varying(30)
);


ALTER TABLE public.list OWNER TO s23b71;

--
-- Name: student_class_status; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.student_class_status (
    classstatus integer NOT NULL,
    classdescription character varying(30) NOT NULL
);


ALTER TABLE public.student_class_status OWNER TO s23b71;

--
-- Name: student_schedules; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.student_schedules (
    classid integer NOT NULL,
    studentid integer NOT NULL,
    classstatus integer,
    grade character varying(30) NOT NULL
);


ALTER TABLE public.student_schedules OWNER TO s23b71;

--
-- Name: students; Type: TABLE; Schema: public; Owner: s23b71
--

CREATE TABLE public.students (
    studentid integer NOT NULL,
    studfirstname character varying(30) NOT NULL,
    studlastname character varying(30) NOT NULL,
    studstreetaddress character varying(30) NOT NULL,
    studcity character varying(30) NOT NULL,
    studstate character varying(30) NOT NULL,
    studzipcode integer NOT NULL,
    studareacode integer NOT NULL,
    studphonenumber character varying(30)
);


ALTER TABLE public.students OWNER TO s23b71;

--
-- Data for Name: buildings; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.buildings (buildingcode, buildingname, numberoffloors) FROM stdin;
1	Building A	3
2	Building B	4
3	Building C	2
4	Building D	3
5	Building E	1
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.categories (categoryid, categorydescription, departmentid) FROM stdin;
1	Math	1
2	Science	2
3	Arts	3
4	History	4
5	Literature	5
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.classes (classid, subjectid, classroomid, starttime, duration) FROM stdin;
1	1	1	09:00:00	60
2	2	2	10:30:00	75
4	4	4	08:00:00	120
3	3	3	14:00:00	30
5	5	5	16:30:00	20
\.


--
-- Data for Name: classrooms; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.classrooms (classroomid, buildingcode, phoneavailable) FROM stdin;
1	1	1
2	2	0
3	3	1
4	4	0
5	5	1
\.


--
-- Data for Name: deleted_student_schedules; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.deleted_student_schedules (classid, studentid, classstatus, grade) FROM stdin;
\.


--
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.faculty (staffid, title, status, tenured) FROM stdin;
1	Dr.	Active	2030-06-06
2	Prof.	Active	2026-08-09
3	Dr.	On Leave	2032-01-01
4	Dr.	Active	2025-08-08
5	Prof.	Retired	2028-02-01
\.


--
-- Data for Name: faculty_categories; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.faculty_categories (staffid, categoryid) FROM stdin;
1	1
2	2
3	3
4	4
5	5
\.


--
-- Data for Name: faculty_classes; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.faculty_classes (staffid, classid) FROM stdin;
1	1
2	2
3	3
4	4
5	5
\.


--
-- Data for Name: faculty_subjects; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.faculty_subjects (staffid, subjectid, proficiencyrating) FROM stdin;
1	1	5
4	4	4
1	3	5
2	5	3
2	1	4
\.


--
-- Data for Name: list; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.list (stffirstname, stflastname) FROM stdin;
John	Doe
Mike	Johnson
Chris	White
Chris	White
Emily	Davis
\.


--
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.staff (staffid, stffirstname, stflastname, stfstreetaddress, stfcity, stfstate, stfzipcode, stfareacode, stfphonenumber, joiningdate, salary, "position") FROM stdin;
2	Jane	Smith	456 Oak St	Champaign	Tamil Nadu	61820	217	5555678	2019-03-15	10500	Lecturer
4	Emily	Davis	101 Maple St	Bloomington	Tamil Nadu	61701	309	5552345	2022-11-05	18000	Assistant Professor
5	Sarah	Brown	202 Birch St	Decatur	Kerala	62521	217	5556789	2023-02-28	20000	Instructor
6	Chris	White	5 St	City5	ST	10005	127	1115555	2022-05-01	35000	Lecturer
1	John	Doe	123 Elm St	Springfield	Kerala	60601	217	5551234	2020-01-01	5500	Professor
3	Mike	Johnson	789 Pine St	Peoria	Kerala	61604	309	5558765	2021-08-22	15500	Associate Professor
7	Chris	White	5 St	City5	ST	10005	127	1115555	2022-05-01	35000	Lecturer
\.


--
-- Data for Name: student_class_status; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.student_class_status (classstatus, classdescription) FROM stdin;
1	Enrolled
2	Completed
3	Dropped
4	Failed
5	Withdrawn
\.


--
-- Data for Name: student_schedules; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.student_schedules (classid, studentid, classstatus, grade) FROM stdin;
1	1	1	A
1	2	2	B
2	4	4	D
2	5	5	F
1	3	3	F
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.students (studentid, studfirstname, studlastname, studstreetaddress, studcity, studstate, studzipcode, studareacode, studphonenumber) FROM stdin;
1	Alice	Green	100 Oak St	Chicago	IL	60601	312	9512334466
2	Bob	White	200 Pine St	Naperville	IL	60540	630	9534657562
5	Eva	Red	500 Elm St	Rockford	IL	61101	815	9598943580
3	Charlie	Black	300 Birch St	Aurora	IL	60502	630	1234343556
4	David	Blue	400 Maple St	Peoria	IL	61604	309	1234453434
6	Anna	Brown	6 St	City1	ST	10006	130	1114444
\.


--
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: s23b71
--

COPY public.subjects (subjectid, categoryid, subjectcode, subjectname) FROM stdin;
1	1	101	Calculus I
2	2	201	Introduction to Programming
3	3	301	Classical Mechanics
4	4	401	Cell Biology
5	5	501	Organic Chemistry
\.


--
-- Name: buildings buildings_pkey; Type: CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.buildings
    ADD CONSTRAINT buildings_pkey PRIMARY KEY (buildingcode);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (categoryid);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (classid);


--
-- Name: classrooms classrooms_pkey; Type: CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.classrooms
    ADD CONSTRAINT classrooms_pkey PRIMARY KEY (classroomid);


--
-- Name: faculty_categories faculty_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.faculty_categories
    ADD CONSTRAINT faculty_categories_pkey PRIMARY KEY (staffid, categoryid);


--
-- Name: faculty_classes faculty_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.faculty_classes
    ADD CONSTRAINT faculty_classes_pkey PRIMARY KEY (staffid, classid);


--
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (staffid);


--
-- Name: faculty_subjects faculty_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.faculty_subjects
    ADD CONSTRAINT faculty_subjects_pkey PRIMARY KEY (staffid, subjectid);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (staffid);


--
-- Name: student_class_status student_class_status_pkey; Type: CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.student_class_status
    ADD CONSTRAINT student_class_status_pkey PRIMARY KEY (classstatus);


--
-- Name: student_schedules student_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.student_schedules
    ADD CONSTRAINT student_schedules_pkey PRIMARY KEY (classid, studentid);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (studentid);


--
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (subjectid);


--
-- Name: student_schedules before_student_schedule_delete; Type: TRIGGER; Schema: public; Owner: s23b71
--

CREATE TRIGGER before_student_schedule_delete BEFORE DELETE ON public.student_schedules FOR EACH ROW EXECUTE FUNCTION public.before_schedules_delete_fn();


--
-- Name: classes classes_classroomid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_classroomid_fkey FOREIGN KEY (classroomid) REFERENCES public.classrooms(classroomid);


--
-- Name: classes classes_subjectid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES public.subjects(subjectid);


--
-- Name: classrooms classrooms_buildingcode_fkey; Type: FK CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.classrooms
    ADD CONSTRAINT classrooms_buildingcode_fkey FOREIGN KEY (buildingcode) REFERENCES public.buildings(buildingcode);


--
-- Name: faculty_categories faculty_categories_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.faculty_categories
    ADD CONSTRAINT faculty_categories_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.categories(categoryid);


--
-- Name: faculty_categories faculty_categories_staffid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.faculty_categories
    ADD CONSTRAINT faculty_categories_staffid_fkey FOREIGN KEY (staffid) REFERENCES public.staff(staffid);


--
-- Name: faculty_classes faculty_classes_classid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.faculty_classes
    ADD CONSTRAINT faculty_classes_classid_fkey FOREIGN KEY (classid) REFERENCES public.classes(classid);


--
-- Name: faculty_classes faculty_classes_staffid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.faculty_classes
    ADD CONSTRAINT faculty_classes_staffid_fkey FOREIGN KEY (staffid) REFERENCES public.staff(staffid);


--
-- Name: faculty faculty_staffid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_staffid_fkey FOREIGN KEY (staffid) REFERENCES public.staff(staffid);


--
-- Name: faculty_subjects faculty_subjects_staffid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.faculty_subjects
    ADD CONSTRAINT faculty_subjects_staffid_fkey FOREIGN KEY (staffid) REFERENCES public.staff(staffid);


--
-- Name: faculty_subjects faculty_subjects_subjectid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.faculty_subjects
    ADD CONSTRAINT faculty_subjects_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES public.subjects(subjectid);


--
-- Name: student_schedules student_schedules_classstatus_fkey; Type: FK CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.student_schedules
    ADD CONSTRAINT student_schedules_classstatus_fkey FOREIGN KEY (classstatus) REFERENCES public.student_class_status(classstatus);


--
-- Name: subjects subjects_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: s23b71
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.categories(categoryid);


--
-- Name: TABLE students; Type: ACL; Schema: public; Owner: s23b71
--

REVOKE ALL ON TABLE public.students FROM s23b71;
GRANT SELECT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.students TO s23b71;


--
-- PostgreSQL database dump complete
--

