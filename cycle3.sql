--Display the count of teachers teaching two or three subjects
SELECT staffid,COUNT(subjectid) FROM faculty_subjects GROUP BY staffid HAVING COUNT(subjectid) IN (2,3);

--Display the maximum of average salary from Staff table based on their positions
SELECT MAX(Average) AS "MAXIMUM SALARY" FROM (SELECT AVG(Salary) as Average FROM STAFF GROUP BY position) AS "MAXIMUM SALARY";

--Display the minimum grade of students for from each class
SELECT classid,MAX(grade) AS "Min Grade" FROM student_schedules GROUP BY classid ORDER BY classid;

--Display subject name which contains character ‘a’
SELECT subjectname AS Subject FROM subjects WHERE subjectname LIKE '%a%';

--Display the name of students having mobile no starting with ‘95’
SELECT studphonenumber AS "Phone Number" FROM students WHERE studphonenumber LIKE '95%';

--Retrieve details of subjects where maximum duration is less than 45 minutes
SELECT classid AS "Class ID",MAX(duration) FROM classes GROUP BY classid ORDER BY classid;

--Display the list of students based on Student ID in ascending order and Student Name in descending order, Group by Subject Name
SELECT st.studentid,st.studfirstname,st.studlastname,su.subjectname FROM students st, student_schedules ss, classes cl,subjects su  WHERE st.studentid = ss.studentid AND ss.classid = cl.classid AND cl.subjectid = su.subjectid GROUP BY st.studfirstname,st.studentid,su.subjectname ORDER BY st.studentid ASC;

--Display position and average salary of staff belonging to state “Kerala” or“Tamil Nadu” where salary is more than 10000 and average salary is less than 25000
SELECT position,AVG(salary) FROM staff WHERE salary > 10000 AND stfstate IN ('Kerala','Tamil Nadu') GROUP BY position HAVING AVG(salary) < 25000;
