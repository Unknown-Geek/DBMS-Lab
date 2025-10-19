-- Display the list of faculties who have more than 5 years tenure period
SELECT *,(tenured - CURRENT_DATE)/365 as "Remaining Years" FROM faculty;

-- Calculate the remaining tenure period from the current data 
SELECT * FROM faculty f,staff s WHERE f.staffid = s.staffid and (f.tenured - s.joiningdate)/365 > 5;

-- Display the list of staff who have salary greater than 10000 and less than 50000
SELECT * FROM staff WHERE salary > 10000 and salary < 50000;

-- Count the number of positions in the staff relation
SELECT COUNT(DISTINCT position) FROM staff;

-- Count the number of staff from a particular area code
SELECT COUNT(*) FROM staff WHERE stfareacode = 217; 