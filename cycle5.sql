-- Create a view from faculty, staff and student relation to display faculty name,classid, subject name based on schedule given.
CREATE VIEW details AS SELECT s.stffirstname,c.classid,sb.subjectname FROM staff as s,classes as c,subjects as sb;

-- Use assert statement to check whether Classroom table has at least 1 data
DO $$
DECLARE classroom_count INTEGER;
BEGIN
	SELECT COUNT(*) INTO classroom_count FROM classrooms;
	ASSERT classroom_count>0, 'No data in classrooms table';
END $$;

-- Write a PL/SQL block to do the following:
-- a. Using control structures, display the list of faculties who have been hired between two dates
DO $$
DECLARE record RECORD;
BEGIN
RAISE NOTICE 'The list of faculties is : ';
FOR record IN 
   	SELECT stffirstname,stflastname FROM staff WHERE joiningdate BETWEEN '2020-01-01' AND '2023-01-01' ORDER BY joiningdate
  	LOOP 
	   RAISE NOTICE '% %', record.stffirstname, record.stflastname;
	END LOOP;
END $$;

-- b. Using CASE statement, satisfy the following conditions accepting Staff ID as input:
-- Case 1: if salary < 5000, give 50% increment
-- Case 2: if salary between 5000 and 10000, give 10% increment
-- Case 3: if salary > 10000, display a message ‘No Increment’ 

DO $$
DECLARE 
	s_id INTEGER := 1;
	s_salary INTEGER;
	new_salary INTEGER;
BEGIN
	SELECT salary into s_salary FROM staff WHERE staffid = s_id;
	CASE
		WHEN s_salary < 5000 THEN 
			new_salary := (1.5*s_salary);
			RAISE NOTICE 'Old Salary : % , New Salary : %',s_salary,new_salary;

		WHEN s_salary < 10000 THEN 
			new_salary := (1.1*s_salary);
			RAISE NOTICE 'Old Salary : % , New Salary : %',s_salary,new_salary;

		WHEN s_salary > 10000 THEN
			RAISE NOTICE 'No Increment';

		ELSE
			RAISE NOTICE 'Invalid';
	END CASE; 
END $$;

-- c. Read the Faculty table row by row using WHILE loop and display the last name of the faculty (Example: ‘Last Name: Antony’)
DO $$
DECLARE 
	count INTEGER;
	lastname TEXT;
	i INTEGER := 0;
BEGIN
	SELECT COUNT(*) INTO count FROM staff;
	WHILE i < count 
		LOOP 
			SELECT stflastname INTO lastname FROM staff ORDER BY staffid
			OFFSET i LIMIT 1;

			RAISE NOTICE 'Last Name : %',lastname;

			i := i + 1;
		END LOOP;
END $$;