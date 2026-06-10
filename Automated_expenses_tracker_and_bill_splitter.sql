-- ==========================================
-- AUTOMATED EXPENSE TRACKER & BILL SPLITTER
-- ==========================================

DROP DATABASE IF EXISTS expense_tracker;
CREATE DATABASE expense_tracker;
USE expense_tracker;

-- ==========================================
-- USERS TABLE
-- ==========================================

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- EXPENSE GROUPS
-- ==========================================

CREATE TABLE Expense_Groups (
    group_id INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    created_date DATE DEFAULT (CURRENT_DATE)
);

-- ==========================================
-- GROUP MEMBERS
-- ==========================================

CREATE TABLE Group_Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT NOT NULL,
    user_id INT NOT NULL,

    FOREIGN KEY (group_id)
        REFERENCES Expense_Groups(group_id)
        ON DELETE CASCADE,

    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

-- ==========================================
-- CATEGORIES
-- ==========================================

CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL
);

-- ==========================================
-- EXPENSES
-- ==========================================

CREATE TABLE Expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT,
    paid_by INT NOT NULL,
    category_id INT,
    expense_title VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(10,2) NOT NULL,
    expense_date DATE DEFAULT (CURRENT_DATE),

    FOREIGN KEY (group_id)
        REFERENCES Expense_Groups(group_id)
        ON DELETE CASCADE,

    FOREIGN KEY (paid_by)
        REFERENCES Users(user_id),

    FOREIGN KEY (category_id)
        REFERENCES Categories(category_id)
);

-- ==========================================
-- EXPENSE SPLITS
-- ==========================================

CREATE TABLE Expense_Splits (
    split_id INT AUTO_INCREMENT PRIMARY KEY,
    expense_id INT NOT NULL,
    user_id INT NOT NULL,
    amount_owed DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (expense_id)
        REFERENCES Expenses(expense_id)
        ON DELETE CASCADE,

    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

-- ==========================================
-- SETTLEMENTS
-- ==========================================

CREATE TABLE Settlements (
    settlement_id INT AUTO_INCREMENT PRIMARY KEY,
    payer_id INT NOT NULL,
    receiver_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE DEFAULT (CURRENT_DATE),

    FOREIGN KEY (payer_id)
        REFERENCES Users(user_id),

    FOREIGN KEY (receiver_id)
        REFERENCES Users(user_id)
);

-- ==========================================
-- NOTIFICATIONS
-- ==========================================

CREATE TABLE Notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    message VARCHAR(255),
    notification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

-- ==========================================
-- AUDIT LOG
-- ==========================================

CREATE TABLE Audit_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    action_type VARCHAR(20),
    record_id INT,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- SAMPLE CATEGORIES
-- ==========================================

INSERT INTO Categories(category_name)
VALUES
('Food'),
('Travel'),
('Rent'),
('Shopping'),
('Entertainment'),
('Medical'),
('Utilities');

-- ==========================================
-- SAMPLE USERS
-- ==========================================

INSERT INTO Users(full_name,email,phone)
VALUES
('Rahul Sharma','rahul@gmail.com','9876543210'),
('Amit Patil','amit@gmail.com','9876543211'),
('Priya Singh','priya@gmail.com','9876543212'),
('Neha Verma','neha@gmail.com','9876543213');

-- ==========================================
-- SAMPLE GROUP
-- ==========================================

INSERT INTO Expense_Groups
(group_name,description)
VALUES
('Goa Trip','Friends Goa Vacation');

-- ==========================================
-- GROUP MEMBERS
-- ==========================================

INSERT INTO Group_Members(group_id,user_id)
VALUES
(1,1),
(1,2),
(1,3),
(1,4);

-- ==========================================
-- SAMPLE EXPENSES
-- ==========================================

INSERT INTO Expenses
(group_id,paid_by,category_id,expense_title,description,amount)
VALUES
(1,1,2,'Hotel Booking','Beach Resort',8000),

(1,2,1,'Dinner',
'Sea Food Restaurant',4000),

(1,3,2,'Taxi Fare',
'Airport Pickup',2000);

-- ==========================================
-- EXPENSE SPLITS
-- ==========================================

INSERT INTO Expense_Splits
(expense_id,user_id,amount_owed)
VALUES

(1,1,2000),
(1,2,2000),
(1,3,2000),
(1,4,2000),

(2,1,1000),
(2,2,1000),
(2,3,1000),
(2,4,1000),

(3,1,500),
(3,2,500),
(3,3,500),
(3,4,500);

-- ==========================================
-- SAMPLE SETTLEMENT
-- ==========================================

INSERT INTO Settlements
(payer_id,receiver_id,amount)
VALUES
(2,1,1000),
(4,1,1500);

-- ==========================================
-- TRIGGER
-- ==========================================

DELIMITER $$

CREATE TRIGGER trg_expense_audit
AFTER INSERT ON Expenses
FOR EACH ROW
BEGIN

INSERT INTO Audit_Log
(table_name,
 action_type,
 record_id)
VALUES
('Expenses',
 'INSERT',
 NEW.expense_id);

END$$

DELIMITER ;

-- ==========================================
-- VIEW 1
-- TOTAL EXPENSES
-- ==========================================

CREATE VIEW vw_total_expenses AS
SELECT
expense_id,
expense_title,
amount,
expense_date
FROM Expenses;

-- ==========================================
-- VIEW 2
-- USER BALANCE
-- ==========================================

CREATE VIEW vw_user_balance AS
SELECT
u.user_id,
u.full_name,
SUM(es.amount_owed) AS Total_Amount_Owed
FROM Users u
JOIN Expense_Splits es
ON u.user_id = es.user_id
GROUP BY u.user_id,u.full_name;

-- ==========================================
-- VIEW 3
-- GROUP EXPENSE REPORT
-- ==========================================

CREATE VIEW vw_group_expenses AS
SELECT
g.group_name,
e.expense_title,
e.amount
FROM Expense_Groups g
JOIN Expenses e
ON g.group_id=e.group_id;

-- ==========================================
-- STORED PROCEDURE 1
-- ==========================================

DELIMITER $$

CREATE PROCEDURE GetUserExpenses(IN uid INT)
BEGIN

SELECT
u.full_name,
e.expense_title,
e.amount,
e.expense_date
FROM Users u
JOIN Expenses e
ON u.user_id=e.paid_by
WHERE u.user_id=uid;

END$$

DELIMITER ;

-- ==========================================
-- STORED PROCEDURE 2
-- ==========================================

DELIMITER $$

CREATE PROCEDURE GetGroupExpenses(IN gid INT)
BEGIN

SELECT
g.group_name,
e.expense_title,
e.amount
FROM Expense_Groups g
JOIN Expenses e
ON g.group_id=e.group_id
WHERE g.group_id=gid;

END$$

DELIMITER ;

-- ==========================================
-- REPORT QUERIES
-- ==========================================

-- All Users

SELECT * FROM Users;

-- All Expenses

SELECT * FROM Expenses;

-- Expense Splits

SELECT * FROM Expense_Splits;

-- Total Expense

SELECT
SUM(amount) AS Total_Expense
FROM Expenses;

-- Highest Expense

SELECT *
FROM Expenses
ORDER BY amount DESC
LIMIT 1;

-- Group Wise Expense

SELECT
g.group_name,
SUM(e.amount) AS Total_Expense
FROM Expense_Groups g
JOIN Expenses e
ON g.group_id=e.group_id
GROUP BY g.group_name;

-- User Wise Expense

SELECT
u.full_name,
SUM(e.amount) AS Total_Paid
FROM Users u
JOIN Expenses e
ON u.user_id=e.paid_by
GROUP BY u.full_name;

-- View Output

SELECT * FROM vw_total_expenses;

SELECT * FROM vw_user_balance;

SELECT * FROM vw_group_expenses;

-- Procedure Calls

CALL GetUserExpenses(1);

CALL GetGroupExpenses(1);

-- Audit Log Check

SELECT * FROM Audit_Log;