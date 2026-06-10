
-- BANK MANAGEMENT SYSTEM DATABASE
-- MySQL Workbench Compatible


DROP DATABASE IF EXISTS bank_management_system;

CREATE DATABASE bank_management_system;

USE bank_management_system;

-- BANKS TABLE

CREATE TABLE Banks (
    bank_id INT AUTO_INCREMENT PRIMARY KEY,
    bank_name VARCHAR(100) NOT NULL UNIQUE,
    headquarters VARCHAR(100),
    established_year YEAR,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- BRANCHES TABLE


CREATE TABLE Branches (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    bank_id INT NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50),
    pincode VARCHAR(10),

    CONSTRAINT fk_branch_bank
    FOREIGN KEY (bank_id)
    REFERENCES Banks(bank_id)
    ON DELETE CASCADE
);


-- CUSTOMERS TABLE


CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male','Female','Other'),
    dob DATE,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ACCOUNTS TABLE


CREATE TABLE Accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,

    account_number VARCHAR(20) NOT NULL UNIQUE,

    account_type ENUM(
        'Savings',
        'Current',
        'Fixed Deposit'
    ) NOT NULL,

    balance DECIMAL(15,2) DEFAULT 0.00,

    opened_date DATE DEFAULT (CURRENT_DATE),

    CONSTRAINT chk_balance
    CHECK (balance >= 0),

    CONSTRAINT fk_account_customer
    FOREIGN KEY (customer_id)
    REFERENCES Customers(customer_id)
    ON DELETE CASCADE,

    CONSTRAINT fk_account_branch
    FOREIGN KEY (branch_id)
    REFERENCES Branches(branch_id)
);


-- ATM MACHINES TABLE


CREATE TABLE ATM_Machines (
    atm_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_id INT NOT NULL,

    atm_location VARCHAR(150) NOT NULL,

    installation_date DATE,

    status ENUM(
        'Active',
        'Inactive',
        'Maintenance'
    ) DEFAULT 'Active',

    CONSTRAINT fk_atm_branch
    FOREIGN KEY (branch_id)
    REFERENCES Branches(branch_id)
);


-- CARDS TABLE


CREATE TABLE Cards (
    card_id INT AUTO_INCREMENT PRIMARY KEY,

    account_id INT NOT NULL,

    card_number VARCHAR(20) UNIQUE NOT NULL,

    card_type ENUM(
        'Debit',
        'Credit'
    ) NOT NULL,

    expiry_date DATE,

    cvv CHAR(3),

    status ENUM(
        'Active',
        'Blocked',
        'Expired'
    ) DEFAULT 'Active',

    CONSTRAINT fk_card_account
    FOREIGN KEY (account_id)
    REFERENCES Accounts(account_id)
    ON DELETE CASCADE
);


-- TRANSACTIONS TABLE


CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,

    account_id INT NOT NULL,

    transaction_type ENUM(
        'Deposit',
        'Withdraw',
        'Transfer'
    ) NOT NULL,

    amount DECIMAL(12,2) NOT NULL,

    transaction_date TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP,

    description VARCHAR(255),

    CONSTRAINT chk_amount
    CHECK (amount > 0),

    CONSTRAINT fk_transaction_account
    FOREIGN KEY (account_id)
    REFERENCES Accounts(account_id)
    ON DELETE CASCADE
);


-- EMPLOYEES TABLE


CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,

    branch_id INT NOT NULL,

    first_name VARCHAR(50),
    last_name VARCHAR(50),

    designation VARCHAR(100),

    salary DECIMAL(10,2),

    hire_date DATE,

    phone VARCHAR(15) UNIQUE,

    CONSTRAINT chk_salary
    CHECK (salary > 0),

    CONSTRAINT fk_employee_branch
    FOREIGN KEY (branch_id)
    REFERENCES Branches(branch_id)
);


-- LOANS TABLE


CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,

    customer_id INT NOT NULL,

    loan_type ENUM(
        'Home',
        'Personal',
        'Vehicle',
        'Education'
    ),

    loan_amount DECIMAL(15,2),

    interest_rate DECIMAL(5,2),

    loan_date DATE,

    status ENUM(
        'Pending',
        'Approved',
        'Rejected',
        'Closed'
    ) DEFAULT 'Pending',

    CONSTRAINT chk_loan_amount
    CHECK (loan_amount > 0),

    CONSTRAINT fk_loan_customer
    FOREIGN KEY (customer_id)
    REFERENCES Customers(customer_id)
);

-
-- AUDIT LOG TABLE





-- INDEXES


CREATE INDEX idx_customer_phone
ON Customers(phone);

CREATE INDEX idx_customer_email
ON Customers(email);

CREATE INDEX idx_account_number
ON Accounts(account_number);

CREATE INDEX idx_card_number
ON Cards(card_number);

CREATE INDEX idx_transaction_date
ON Transactions(transaction_date);

CREATE INDEX idx_employee_phone
ON Employees(phone);

-- ==========================================
-- SAMPLE DATA
-- ==========================================

INSERT INTO Banks
(bank_name, headquarters, established_year)
VALUES
('State Bank of India', 'Mumbai', 1955);

INSERT INTO Branches
(bank_id, branch_name, city, state, pincode)
VALUES
(1,'SBI Main Branch','Mumbai','Maharashtra','400001'),
(1,'SBI Pune Branch','Pune','Maharashtra','411001'),
(1,'SBI Delhi','Delha','Delhi','411011');


INSERT INTO Customers
(first_name,last_name,gender,dob,phone,email,address)
VALUES
('Rohan','Patil','Male','1998-02-15','9876543212','rohan@gmail.com','Nagpur'),
('Anjali','Deshmukh','Female','2001-07-12','9876543213','anjali@gmail.com','Nashik'),
('Vikas','Joshi','Male','1997-04-21','9876543214','vikas@gmail.com','Aurangabad'),
('Pooja','Shinde','Female','2000-09-30','9876543215','pooja@gmail.com','Kolhapur'),
('Karan','Mehta','Male','1999-12-10','9876543216','karan@gmail.com','Mumbai'),
('Neha','Kulkarni','Female','2002-03-14','9876543217','neha@gmail.com','Pune'),
('Suresh','Jadhav','Male','1995-06-25','9876543218','suresh@gmail.com','Solapur'),
('Meena','Pawar','Female','1998-11-18','9876543219','meena@gmail.com','Latur'),
('Arjun','More','Male','2001-01-08','9876543220','arjun@gmail.com','Sangli'),
('Kavita','Chavan','Female','1996-05-27','9876543221','kavita@gmail.com','Satara');


INSERT INTO Accounts
(customer_id,branch_id,account_number,account_type,balance)
VALUES
(1,1,'SBI10001','Savings',50000),
(2,2,'SBI10002','Current',75000),
(3,1,'SBI10003','Savings',45000),
(4,2,'SBI10004','Current',120000),
(5,1,'SBI10005','Savings',67000),
(6,2,'SBI10006','Current',80000),
(7,1,'SBI10007','Savings',52000),
(8,2,'SBI10008','Savings',95000),
(9,1,'SBI10009','Current',150000),
(10,2,'SBI10010','Savings',33000);
INSERT INTO ATM_Machines
(branch_id,atm_location,installation_date)
VALUES
(1,'Mumbai Central','2023-01-10'),
(2,'Pune Station','2023-03-15');


INSERT INTO Cards
(account_id,card_number,card_type,expiry_date,cvv)
VALUES
(1,'1111222233334444','Debit','2029-12-31','111'),
(2,'2222333344445555','Credit','2029-12-31','222'),
(3,'3333444455556666','Debit','2029-12-31','333'),
(4,'4444555566667777','Credit','2029-12-31','444'),
(5,'5555666677778888','Debit','2029-12-31','555'),
(6,'6666777788889999','Credit','2029-12-31','666'),
(7,'7777888899990000','Debit','2029-12-31','777'),
(8,'8888999900001111','Credit','2029-12-31','888'),
(9,'9999000011112222','Debit','2029-12-31','999'),
(10,'1212121212121212','Credit','2029-12-31','123');

INSERT INTO Employees
(branch_id,first_name,last_name,designation,salary,hire_date,phone)
VALUES
(1,'Raj','Patil','Cashier',35000,'2022-02-10','9000000003'),
(1,'Sunil','Sharma','Clerk',30000,'2023-01-05','9000000004'),
(1,'Geeta','Joshi','Officer',50000,'2021-07-11','9000000005'),
(2,'Rakesh','Pawar','Cashier',36000,'2022-03-20','9000000006'),
(2,'Priyanka','More','Officer',52000,'2020-09-12','9000000007'),
(2,'Ajay','Kulkarni','Clerk',31000,'2023-04-15','9000000008'),
(1,'Deepak','Jadhav','Manager',80000,'2019-05-10','9000000009'),
(2,'Snehal','Patil','Assistant Manager',65000,'2021-11-25','9000000010');

INSERT INTO Loans
(customer_id,loan_type,loan_amount,interest_rate,loan_date,status)
VALUES
(2,'Personal',300000,10.5,'2025-02-10','Approved'),
(3,'Vehicle',500000,9.0,'2025-03-15','Approved'),
(4,'Education',250000,7.5,'2025-04-01','Pending'),
(5,'Home',1500000,8.2,'2025-01-20','Approved'),
(6,'Personal',200000,11.0,'2025-05-05','Rejected'),
(7,'Vehicle',600000,8.9,'2025-02-28','Approved'),
(8,'Education',400000,7.2,'2025-03-12','Approved'),
(9,'Home',2500000,8.0,'2025-04-18','Pending'),
(10,'Personal',150000,10.0,'2025-05-01','Approved');


-- VIEW


CREATE VIEW Customer_Account_Details AS
SELECT
c.customer_id,
c.first_name,
c.last_name,
a.account_number,
a.account_type,
a.balance
FROM Customers c
JOIN Accounts a
ON c.customer_id = a.customer_id;




-- STORED PROCEDURE


DELIMITER $$

CREATE PROCEDURE GetCustomerAccounts(
    IN cust_id INT
)
BEGIN

SELECT
c.customer_id,
c.first_name,
c.last_name,
a.account_number,
a.account_type,
a.balance

FROM Customers c
JOIN Accounts a
ON c.customer_id = a.customer_id

WHERE c.customer_id = cust_id;

END $$

DELIMITER ;


-- TEST QUERIES


SELECT * FROM Banks;
SELECT * FROM Branches;
SELECT * FROM Customers;
SELECT * FROM Accounts;
SELECT * FROM Cards;

SELECT * FROM Employees;
SELECT * FROM Loans;


SELECT * FROM Customer_Account_Details;

CALL GetCustomerAccounts(1);