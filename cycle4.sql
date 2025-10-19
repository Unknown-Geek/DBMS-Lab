-- Revoke insert privilege for a user on table Students and check whether you are able to insert a row in to the table
REVOKE INSERT ON students FROM s23b71;

-- Grant the permission to the user for inserting values in to students table and check whether insertion is possible or not
GRANT INSERT ON students TO s23b71;

-- Start a new transaction and insert a row into the Staff table. Commit the transaction and display the changes to the table
BEGIN TRANSACTION;
INSERT INTO STAFF VALUES (7, 'Chris', 'White', '5 St', 'City5', 'ST', 10005, 127, 1115555, '2022-05-01', 35000, 'Lecturer');
COMMIT;
SELECT * FROM STAFF;

-- Start a new transaction and insert a row into the Staff table.Undo the transaction and display the changes to the table
BEGIN TRANSACTION;
INSERT INTO STAFF VALUES (8, 'Anna', 'Brown', '5 St', 'City5', 'ST', 10005, 127, 1115555, '2022-05-01', 35000, 'Lecturer');
SELECT * FROM STAFF;
ROLLBACK;
SELECT * FROM STAFF;

-- Display the staffid and title for Faculty along with staffid and position for Staff in a single table. Indicate the source of the row in the result by adding an
-- additional column EMPLOYEE with possible values as ‘F’ (Faculties) and ‘S’ (Staff). Display all rows (Using UNION ALL)
SELECT staffid,title AS role, 'F' AS EMPLOYEE FROM faculty UNION ALL SELECT staffid,position AS role, 'S' AS EMPLOYEE FROM staff;

-- Find the pass percentage of a particular subject (using grade)
SELECT classid,
100.0 * COUNT
(
	CASE WHEN grade NOT IN ('F') THEN -5 END
) 
/ COUNT(*)
AS PASSPERCENTAGE
FROM student_schedules
GROUP BY classid
ORDER BY classid;

-- Display the number of students in each classroom on a particular building using JOINS
SELECT buildingcode,buildingname,classroomid,COUNT(studentid) FROM classes NATURAL JOIN classrooms NATURAL JOIN buildings NATURAL JOIN student_schedules GROUP BY buildingcode,buildingname,classroomid ORDER BY classroomid;

-- Display the list of students and staff who have the same zip code
SELECT s1.studfirstname,s1.studlastname,s2.stffirstname,s2.stflastname,s1.studzipcode FROM students s1 JOIN staff s2 ON s1.studzipcode = s2.stfzipcode;

-- Display the list of faculty who engage same subject (for any particular subject name)
SELECT stffirstname,stflastname,staffid,subjectname,subjectcode FROM staff NATURAL JOIN faculty_subjects NATURAL JOIN subjects WHERE subjectcode=101;