-- =====================================================
-- ONLINE EXAMINATION MANAGEMENT SYSTEM
-- Complete SQL Project
-- =====================================================

DROP DATABASE IF EXISTS OnlineExamDB;

CREATE DATABASE OnlineExamDB;

USE OnlineExamDB;

-- =====================================================
-- TABLE: STUDENTS
-- =====================================================

CREATE TABLE Students (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    RegistrationDate DATE
);

-- =====================================================
-- TABLE: INSTRUCTORS
-- =====================================================

CREATE TABLE Instructors (
    InstructorID INT AUTO_INCREMENT PRIMARY KEY,
    InstructorName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE
);

-- =====================================================
-- TABLE: COURSES
-- =====================================================

CREATE TABLE Courses (
    CourseID INT AUTO_INCREMENT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    InstructorID INT,

    FOREIGN KEY (InstructorID)
    REFERENCES Instructors(InstructorID)
);

-- =====================================================
-- TABLE: EXAMS
-- =====================================================

CREATE TABLE Exams (
    ExamID INT AUTO_INCREMENT PRIMARY KEY,
    CourseID INT,
    ExamTitle VARCHAR(100),
    ExamDate DATE,
    TotalMarks INT,
    DurationMinutes INT,

    FOREIGN KEY (CourseID)
    REFERENCES Courses(CourseID)
);

-- =====================================================
-- TABLE: QUESTIONS
-- =====================================================

CREATE TABLE Questions (
    QuestionID INT AUTO_INCREMENT PRIMARY KEY,
    ExamID INT,
    QuestionText VARCHAR(500),
    OptionA VARCHAR(200),
    OptionB VARCHAR(200),
    OptionC VARCHAR(200),
    OptionD VARCHAR(200),
    CorrectAnswer CHAR(1),

    FOREIGN KEY (ExamID)
    REFERENCES Exams(ExamID)
);

-- =====================================================
-- TABLE: EXAM ATTEMPTS
-- =====================================================

CREATE TABLE ExamAttempts (
    AttemptID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    ExamID INT,
    AttemptDate DATETIME,
    Score INT,

    FOREIGN KEY (StudentID)
    REFERENCES Students(StudentID),

    FOREIGN KEY (ExamID)
    REFERENCES Exams(ExamID)
);

-- =====================================================
-- TABLE: STUDENT ANSWERS
-- =====================================================

CREATE TABLE StudentAnswers (
    AnswerID INT AUTO_INCREMENT PRIMARY KEY,
    AttemptID INT,
    QuestionID INT,
    SelectedOption CHAR(1),

    FOREIGN KEY (AttemptID)
    REFERENCES ExamAttempts(AttemptID),

    FOREIGN KEY (QuestionID)
    REFERENCES Questions(QuestionID)
);

-- =====================================================
-- SAMPLE DATA
-- =====================================================

-- Students

INSERT INTO Students
(FirstName, LastName, Email, Phone, RegistrationDate)
VALUES
('Pranjal','Deshpande','pranjal@gmail.com','9876543210','2026-01-10'),
('Riya','Sharma','riya@gmail.com','9876543211','2026-01-15'),
('Shreeansh','Patil','aman@gmail.com','9876543212','2026-02-01');

-- Instructors

INSERT INTO Instructors
(InstructorName, Email)
VALUES
('Dr. Rajesh Kulkarni','rajesh@college.com'),
('Prof. Neha Joshi','neha@college.com');

-- Courses

INSERT INTO Courses
(CourseName, InstructorID)
VALUES
('Database Management System',1),
('Python Programming',2);

-- Exams

INSERT INTO Exams
(CourseID, ExamTitle, ExamDate, TotalMarks, DurationMinutes)
VALUES
(1,'DBMS Mid-Term','2026-06-15',100,90),
(2,'Python Assessment','2026-06-20',100,60);

-- Questions

INSERT INTO Questions
(ExamID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer)
VALUES
(1,
'What does SQL stand for?',
'Structured Query Language',
'Simple Query Language',
'System Query Language',
'Sequential Query Language',
'A'),

(1,
'Which command is used to retrieve data?',
'INSERT',
'DELETE',
'SELECT',
'UPDATE',
'C'),

(2,
'Which keyword is used to create a function in Python?',
'function',
'define',
'def',
'fun',
'C');

-- Exam Attempts

INSERT INTO ExamAttempts
(StudentID, ExamID, AttemptDate, Score)
VALUES
(1,1,'2026-06-15 10:00:00',85),
(2,1,'2026-06-15 10:30:00',78),
(3,2,'2026-06-20 11:00:00',90);

-- Student Answers

INSERT INTO StudentAnswers
(AttemptID, QuestionID, SelectedOption)
VALUES
(1,1,'A'),
(1,2,'C'),
(2,1,'A'),
(2,2,'B'),
(3,3,'C');

-- =====================================================
-- USEFUL QUERIES
-- =====================================================

-- View All Students

SELECT * FROM Students;

-- View All Courses

SELECT * FROM Courses;

-- View All Exams

SELECT * FROM Exams;

-- View All Questions

SELECT * FROM Questions;

-- Student Scores

SELECT
    S.FirstName,
    S.LastName,
    E.ExamTitle,
    EA.Score
FROM ExamAttempts EA
JOIN Students S
ON EA.StudentID = S.StudentID
JOIN Exams E
ON EA.ExamID = E.ExamID;

-- Average Score Per Exam

SELECT
    E.ExamTitle,
    AVG(EA.Score) AS AverageScore
FROM ExamAttempts EA
JOIN Exams E
ON EA.ExamID = E.ExamID
GROUP BY E.ExamTitle;

-- Highest Score

SELECT
    S.FirstName,
    S.LastName,
    E.ExamTitle,
    EA.Score
FROM ExamAttempts EA
JOIN Students S
ON EA.StudentID = S.StudentID
JOIN Exams E
ON EA.ExamID = E.ExamID
ORDER BY EA.Score DESC
LIMIT 1;

-- Students Registered

SELECT
    COUNT(*) AS TotalStudents
FROM Students;

-- Exams Conducted

SELECT
    COUNT(*) AS TotalExams
FROM Exams;

-- Questions Per Exam

SELECT
    E.ExamTitle,
    COUNT(Q.QuestionID) AS TotalQuestions
FROM Exams E
LEFT JOIN Questions Q
ON E.ExamID = Q.ExamID
GROUP BY E.ExamTitle;

-- Student Exam History

SELECT
    S.FirstName,
    S.LastName,
    E.ExamTitle,
    EA.AttemptDate,
    EA.Score
FROM ExamAttempts EA
JOIN Students S
ON EA.StudentID = S.StudentID
JOIN Exams E
ON EA.ExamID = E.ExamID
ORDER BY EA.AttemptDate;

-- =====================================================
-- END OF PROJECT
-- =====================================================