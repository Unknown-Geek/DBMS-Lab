-- ============================================================================
-- CYCLE 6: TRIGGERS & CURSORS
-- ============================================================================

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Create a trigger such that before a row is deleted from Student_Schedules 
--    table, it is inserted into another table
-- ----------------------------------------------------------------------------

-- Create backup table
CREATE TABLE student_schedules_backup (
    classid INT,
    studentid INT,
    classstatus INT,
    grade VARCHAR(30),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create trigger function
CREATE OR REPLACE FUNCTION backup_student_schedule()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO student_schedules_backup 
        (classid, studentid, classstatus, grade)
    VALUES 
        (OLD.classid, OLD.studentid, OLD.classstatus, OLD.grade);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER before_delete_student_schedule
BEFORE DELETE ON student_schedules
FOR EACH ROW
EXECUTE FUNCTION backup_student_schedule();

-- Test the trigger
DELETE FROM student_schedules WHERE classid = 1 AND studentid = 1;
SELECT * FROM student_schedules_backup;

-- ----------------------------------------------------------------------------
-- 2. Create a trigger on Students table in which it stops deletion and 
--    updation on Sundays and allows insertion only on Fridays
-- ----------------------------------------------------------------------------

-- Create trigger function
CREATE OR REPLACE FUNCTION restrict_student_operations()
RETURNS TRIGGER AS $$
BEGIN
    -- Check for DELETE or UPDATE on Sunday
    IF (TG_OP = 'DELETE' OR TG_OP = 'UPDATE') AND 
       EXTRACT(DOW FROM CURRENT_DATE) = 0 THEN
        RAISE EXCEPTION 'DELETE and UPDATE operations are not allowed 
                         on Sundays';
    END IF;
    
    -- Check for INSERT only on Friday
    IF TG_OP = 'INSERT' AND EXTRACT(DOW FROM CURRENT_DATE) != 5 THEN
        RAISE EXCEPTION 'INSERT operation is only allowed on Fridays';
    END IF;
    
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER student_day_restriction
BEFORE INSERT OR UPDATE OR DELETE ON students
FOR EACH ROW
EXECUTE FUNCTION restrict_student_operations();

-- Test the trigger (will succeed/fail based on current day)
-- INSERT INTO students VALUES (6, 'Test', 'User', '123 St', 
--     'City', 'ST', 12345, 123, '1234567890');

-- ----------------------------------------------------------------------------
-- 3. Write a trigger on Staff table such that updation is not possible 
--    if new salary is greater than old salary
-- ----------------------------------------------------------------------------

-- Create trigger function
CREATE OR REPLACE FUNCTION prevent_salary_increase()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.salary > OLD.salary THEN
        RAISE EXCEPTION 'Salary cannot be increased. 
                         Old salary: %, New salary: %', 
                         OLD.salary, NEW.salary;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER no_salary_increase
BEFORE UPDATE ON staff
FOR EACH ROW
EXECUTE FUNCTION prevent_salary_increase();

-- Test the trigger (should fail)
UPDATE staff SET salary = 60000 WHERE staffid = 1;

-- Test the trigger (should succeed - decreasing salary)
UPDATE staff SET salary = 45000 WHERE staffid = 5;
SELECT * FROM staff WHERE staffid = 5;


-- ============================================================================
-- CURSORS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Write a PL/SQL block to display the details of Staff living in a 
--    particular city
-- ----------------------------------------------------------------------------

DO $$
DECLARE
    staff_cursor CURSOR FOR 
        SELECT staffid, stffirstname, stflastname, 
               stfstreetaddress, stfcity, stfstate, 
               stfzipcode, stfphonenumber
        FROM staff
        WHERE stfcity = 'Springfield';
    staff_record RECORD;
    count_staff INT := 0;
BEGIN
    RAISE NOTICE 'Staff Members Living in Springfield:';
    RAISE NOTICE '=========================================';
    
    OPEN staff_cursor;
    
    LOOP
        FETCH staff_cursor INTO staff_record;
        EXIT WHEN NOT FOUND;
        
        count_staff := count_staff + 1;
        RAISE NOTICE 'Staff ID: %', staff_record.staffid;
        RAISE NOTICE 'Name: % %', staff_record.stffirstname, 
                     staff_record.stflastname;
        RAISE NOTICE 'Address: %, %, % - %', 
                     staff_record.stfstreetaddress,
                     staff_record.stfcity,
                     staff_record.stfstate,
                     staff_record.stfzipcode;
        RAISE NOTICE 'Phone: %', staff_record.stfphonenumber;
        RAISE NOTICE '-----------------------------------------';
    END LOOP;
    
    CLOSE staff_cursor;
    
    RAISE NOTICE 'Total Staff in Springfield: %', count_staff;
END $$;

-- ----------------------------------------------------------------------------
-- 2. Using parameterized cursors list the name of staff who work in the 
--    same department in which 'xyz' works
-- ----------------------------------------------------------------------------

DO $$
DECLARE
    target_staff VARCHAR(30) := 'John';
    target_dept INT;
    staff_cursor CURSOR (dept_id INT) FOR
        SELECT DISTINCT s.staffid, s.stffirstname, s.stflastname, 
               c.departmentid, c.categorydescription
        FROM staff s
        JOIN faculty_subjects fs ON s.staffid = fs.staffid
        JOIN subjects sub ON fs.subjectid = sub.subjectid
        JOIN categories c ON sub.categoryid = c.categoryid
        WHERE c.departmentid = dept_id
        ORDER BY s.staffid;
    staff_record RECORD;
BEGIN
    -- Find department of target staff
    SELECT DISTINCT c.departmentid INTO target_dept
    FROM staff s
    JOIN faculty_subjects fs ON s.staffid = fs.staffid
    JOIN subjects sub ON fs.subjectid = sub.subjectid
    JOIN categories c ON sub.categoryid = c.categoryid
    WHERE s.stffirstname = target_staff
    LIMIT 1;
    
    IF target_dept IS NULL THEN
        RAISE NOTICE 'Staff member % not found or not assigned 
                      to any department', target_staff;
        RETURN;
    END IF;
    
    RAISE NOTICE 'Staff in Department % (same as %):',
                 target_dept, target_staff;
    RAISE NOTICE '==========================================';
    
    FOR staff_record IN staff_cursor(target_dept) LOOP
        RAISE NOTICE 'ID: %, Name: % %, Department: %, 
                      Category: %',
            staff_record.staffid,
            staff_record.stffirstname,
            staff_record.stflastname,
            staff_record.departmentid,
            staff_record.categorydescription;
    END LOOP;
END $$;

-- ----------------------------------------------------------------------------
-- 3. Write a PL/SQL block to display Staff_ID and salary of two highest 
--    paid staffs using cursors
-- ----------------------------------------------------------------------------

DO $$
DECLARE
    staff_cursor CURSOR FOR
        SELECT staffid, stffirstname, stflastname, salary
        FROM staff
        ORDER BY salary DESC
        LIMIT 2;
    staff_record RECORD;
    rank_num INT := 0;
BEGIN
    RAISE NOTICE 'Top 2 Highest Paid Staff Members:';
    RAISE NOTICE '==================================';
    
    FOR staff_record IN staff_cursor LOOP
        rank_num := rank_num + 1;
        RAISE NOTICE 'Rank #%', rank_num;
        RAISE NOTICE 'Staff ID: %', staff_record.staffid;
        RAISE NOTICE 'Name: % %', staff_record.stffirstname,
                     staff_record.stflastname;
        RAISE NOTICE 'Salary: %', staff_record.salary;
        RAISE NOTICE '----------------------------------';
    END LOOP;
END $$;
