
-- STUDENT MANAGEMENT SYSTEM DATABASE
DROP DATABASE IF EXISTS student_management_system;
CREATE DATABASE student_management_system;
USE student_management_system;

-- STUDENTS TABLE
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male','Female','Other') NOT NULL,
    dob DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) UNIQUE,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- COURSES TABLE
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    credits INT NOT NULL
);

-- ENROLLMENTS TABLE
CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,

    FOREIGN KEY (student_id)
        REFERENCES Students(student_id)
        ON DELETE CASCADE,

    FOREIGN KEY (course_id)
        REFERENCES Courses(course_id)
        ON DELETE CASCADE
);

-- ATTENDANCE TABLE
CREATE TABLE Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('Present','Absent') NOT NULL,

    FOREIGN KEY (student_id)
        REFERENCES Students(student_id)
        ON DELETE CASCADE,

    FOREIGN KEY (course_id)
        REFERENCES Courses(course_id)
        ON DELETE CASCADE
);

-- MARKS TABLE
CREATE TABLE Marks (
    mark_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    marks_obtained DECIMAL(5,2) NOT NULL,
    max_marks DECIMAL(5,2) DEFAULT 100,

    FOREIGN KEY (student_id)
        REFERENCES Students(student_id)
        ON DELETE CASCADE,

    FOREIGN KEY (course_id)
        REFERENCES Courses(course_id)
        ON DELETE CASCADE
);

-- INSERT STUDENTS
INSERT INTO Students
(first_name,last_name,gender,dob,email,phone,address)
VALUES
('Pranjal','Jadhav','Female','2005-05-10','pranjalj@gmail.com','9876543216','Mumbai'),
('Shreeansh','Patil','Male','2005-08-12','shreeanshp@gmail.com','9876742140','Amravati'),
('Sushant','Nandgawali','Male','2006-04-17','sushantn@gmail.com','9877382042','Pune'),
('Harshad','Pathrikar','Male','2005-02-13','harshadp@gmail.com','9877382315','Akola'),
('Pranjal','Deshpande','Female','2005-07-11','pranjald@gmail.com','9876321686','Mumbai'),
('Tarang','Daga','Male','2006-04-28','tarang@gmail.com','9876dfd1686','Akola');


-- INSERT COURSES
INSERT INTO Courses
(course_name,course_code,credits)
VALUES
('Database Management System','DBMS101',4),
('Python Programming','PY101',3),
('Data Structures','DS101',4);


-- INSERT ENROLLMENTS
INSERT INTO Enrollments
(student_id,course_id,enrollment_date)
VALUES
(1,1,'2026-06-01'),
(1,2,'2026-06-01'),
(2,1,'2026-06-01'),
(3,3,'2026-06-01');

-- INSERT ATTENDANCE
INSERT INTO Attendance
(student_id,course_id,attendance_date,status)
VALUES
(1,1,'2026-06-05','Present'),
(2,1,'2026-06-05','Absent'),
(3,3,'2026-06-05','Present');


-- INSERT MARKS
INSERT INTO Marks
(student_id,course_id,marks_obtained,max_marks)
VALUES
(1,1,85,100),
(2,1,78,100),
(3,3,92,100);

-- STUDENTS TABLE OUTPUT
SELECT * FROM Students;
-- COURSES TABLE OUTPUT
SELECT * FROM Courses;
-- ENROLLMENTS TABLE OUTPUT
SELECT * FROM Enrollments;
-- ATTENDANCE TABLE OUTPUT
SELECT * FROM Attendance;
-- MARKS TABLE OUTPUT
SELECT * FROM Marks;

-- DASHBOARD REPORT
SELECT
(SELECT COUNT(*) FROM Students) AS Total_Students,
(SELECT COUNT(*) FROM Courses) AS Total_Courses,
(SELECT COUNT(*) FROM Attendance WHERE status='Present') AS Present_Students,
(SELECT COUNT(*) FROM Attendance WHERE status='Absent') AS Absent_Students,
(SELECT ROUND(AVG(marks_obtained),2) FROM Marks) AS Average_Marks;

-- SEARCH STUDENT
SELECT * FROM Students
WHERE first_name LIKE '%pranjal%';


-- ATTENDANCE REPORT
SELECT
s.student_id,
CONCAT(s.first_name,' ',s.last_name) AS Student_Name,
c.course_name,
a.attendance_date,
a.status
FROM Attendance a
JOIN Students s
ON a.student_id = s.student_id
JOIN Courses c
ON a.course_id = c.course_id;

-- RESULT REPORT WITH PERCENTAGE
SELECT
s.student_id,
CONCAT(s.first_name,' ',s.last_name) AS Student_Name,
c.course_name,
m.marks_obtained,
m.max_marks,
ROUND((m.marks_obtained / m.max_marks) * 100,2) AS Percentage
FROM Marks m
JOIN Students s
ON m.student_id = s.student_id
JOIN Courses c
ON m.course_id = c.course_id;