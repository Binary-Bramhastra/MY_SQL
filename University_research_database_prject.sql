-- UNIVERSITY RESEARCH & INNOVATION MANAGEMENT SYSTEM

DROP DATABASE IF EXISTS university_research_db;
CREATE DATABASE university_research_db;
USE university_research_db;

-- DEPARTMENTS
CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    hod_name VARCHAR(100) NOT NULL
);


-- PROFESSORS

CREATE TABLE Professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    designation VARCHAR(50),
    department_id INT,
    FOREIGN KEY (department_id)
        REFERENCES Departments(department_id)
        ON DELETE SET NULL
);


-- RESEARCHERS
CREATE TABLE Researchers (
    researcher_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    specialization VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id)
        REFERENCES Departments(department_id)
        ON DELETE SET NULL
);


-- STUDENTS


CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    course VARCHAR(100),
    year_of_study INT,
    department_id INT,
    FOREIGN KEY (department_id)
        REFERENCES Departments(department_id)
        ON DELETE SET NULL
);

-- RESEARCH PROJECTS


CREATE TABLE Research_Projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_title VARCHAR(200),
    domain_area VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2),
    status ENUM('Pending','Ongoing','Completed'),
    lead_researcher_id INT,
    FOREIGN KEY (lead_researcher_id)
        REFERENCES Researchers(researcher_id)
        ON DELETE SET NULL
);


-- PROJECT MEMBERS


CREATE TABLE Project_Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT,
    student_id INT,
    role_name VARCHAR(50),

    FOREIGN KEY (project_id)
        REFERENCES Research_Projects(project_id)
        ON DELETE CASCADE,

    FOREIGN KEY (student_id)
        REFERENCES Students(student_id)
        ON DELETE CASCADE
);


-- PUBLICATIONS


CREATE TABLE Publications (
    publication_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT,
    title VARCHAR(250),
    journal_name VARCHAR(150),
    publication_year YEAR,

    FOREIGN KEY (project_id)
        REFERENCES Research_Projects(project_id)
        ON DELETE CASCADE
);


-- CONFERENCES


CREATE TABLE Conferences (
    conference_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT,
    conference_name VARCHAR(200),
    location VARCHAR(100),
    conference_date DATE,

    FOREIGN KEY (project_id)
        REFERENCES Research_Projects(project_id)
        ON DELETE CASCADE
);

-- FUNDING AGENCIES

CREATE TABLE Funding_Agencies (
    agency_id INT AUTO_INCREMENT PRIMARY KEY,
    agency_name VARCHAR(150),
    country VARCHAR(50)
);

-- RESEARCH GRANTS


CREATE TABLE Research_Grants (
    grant_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT,
    agency_id INT,
    grant_amount DECIMAL(12,2),
    grant_date DATE,

    FOREIGN KEY (project_id)
        REFERENCES Research_Projects(project_id)
        ON DELETE CASCADE,

    FOREIGN KEY (agency_id)
        REFERENCES Funding_Agencies(agency_id)
        ON DELETE CASCADE
);


-- PATENTS


CREATE TABLE Patents (
    patent_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT,
    patent_title VARCHAR(250),
    filing_date DATE,
    status VARCHAR(50),

    FOREIGN KEY (project_id)
        REFERENCES Research_Projects(project_id)
        ON DELETE CASCADE
);

-- INDUSTRY PARTNERS


CREATE TABLE Industry_Partners (
    partner_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(150),
    industry_type VARCHAR(100),
    contact_email VARCHAR(100)
);


-- SAMPLE DATA


INSERT INTO Departments (department_name, hod_name)
VALUES
('Computer Science','Dr Sharma'),
('Information Technology','Dr Patil'),
('Electronics','Dr Verma');

INSERT INTO Professors
(first_name,last_name,email,designation,department_id)
VALUES
('Shreeansh','Patil','ShreeanshP@uni.edu','Professor',1),
('Pranjal','Deshpande','PranjalD@uni.edu','Associate Professor',2),
('Sushant','Nanadgawali','sushantN@uni.edu','Professor',3);

INSERT INTO Researchers
(first_name,last_name,email,specialization,department_id)
VALUES
('Pranjal','Jadhav','PranjalJ@uni.edu','Artificial Intelligence',1),
('Harshad','patikar','HarshadP@uni.edu','Machine Learning',2),
('Tarang','Daga','TarangD@uni.edu','IoT Systems',3);

INSERT INTO Students
(first_name,last_name,email,course,year_of_study,department_id)
VALUES
('Anjali','Bondre','AnjaliB@gmail.com','BTech CS',3,1),
('Anuj','Harne','AnujH@gmail.com','BTech IT',2,2),
('Gargi','Barbude','GargiB@gmail.com','BTech ECE',4,3);

INSERT INTO Research_Projects
(project_title,domain_area,start_date,end_date,budget,status,lead_researcher_id)
VALUES
('AI Healthcare Analytics','Artificial Intelligence',
'2025-01-01','2026-12-31',500000,'Ongoing',1),

('Smart Agriculture Using IoT','Internet of Things',
'2025-02-01','2026-11-30',350000,'Ongoing',3),

('Cyber Security Monitoring System','Cyber Security',
'2024-01-01','2025-12-31',400000,'Completed',2);

INSERT INTO Project_Members
(project_id,student_id,role_name)
VALUES
(1,1,'Data Analyst'),
(2,3,'IoT Developer'),
(3,2,'Security Tester');

INSERT INTO Publications
(project_id,title,journal_name,publication_year)
VALUES
(1,'AI for Medical Diagnosis','IEEE Journal',2025),
(2,'IoT Smart Farming','Springer',2025),
(3,'Cyber Defense Techniques','Elsevier',2024);

INSERT INTO Conferences
(project_id,conference_name,location,conference_date)
VALUES
(1,'International AI Conference','Mumbai','2025-09-15'),
(2,'IoT World Summit','Pune','2025-10-10'),
(3,'Cyber Security Expo','Delhi','2025-11-20');

INSERT INTO Funding_Agencies
(agency_name,country)
VALUES
('DST India','India'),
('AI Research Foundation','USA'),
('Tech Innovation Fund','Germany');

INSERT INTO Research_Grants
(project_id,agency_id,grant_amount,grant_date)
VALUES
(1,1,300000,'2025-03-01'),
(2,2,250000,'2025-04-01'),
(3,3,200000,'2024-06-01');

INSERT INTO Patents
(project_id,patent_title,filing_date,status)
VALUES
(1,'AI Diagnosis Engine','2025-05-15','Approved'),
(2,'Smart Irrigation Controller','2025-06-01','Under Review');

INSERT INTO Industry_Partners
(company_name,industry_type,contact_email)
VALUES
('TechNova Pvt Ltd','Software','contact@technova.com'),
('AgriSmart Solutions','Agriculture Technology','info@agrismart.com'),
('CyberSecure Ltd','Cyber Security','support@cybersecure.com');


-- OUTPUT QUERIES

SELECT * FROM Departments;
SELECT * FROM Professors;
SELECT * FROM Researchers;
SELECT * FROM Students;
SELECT * FROM Research_Projects;
SELECT * FROM Publications;
SELECT * FROM Conferences;
SELECT * FROM Funding_Agencies;
SELECT * FROM Research_Grants;
SELECT * FROM Patents;
SELECT * FROM Industry_Partners;


-- PROJECT REPORT


SELECT
    rp.project_title,
    CONCAT(r.first_name,' ',r.last_name) AS Lead_Researcher,
    rp.budget,
    rp.status
FROM Research_Projects rp
JOIN Researchers r
ON rp.lead_researcher_id = r.researcher_id;


-- TOTAL FUNDING BY PROJECT


SELECT
    rp.project_title,
    SUM(rg.grant_amount) AS Total_Funding
FROM Research_Projects rp
JOIN Research_Grants rg
ON rp.project_id = rg.project_id
GROUP BY rp.project_title;