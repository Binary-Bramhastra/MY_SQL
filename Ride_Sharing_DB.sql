-- =====================================================
-- RIDE SHARING DATABASE MANAGEMENT SYSTEM
-- Complete SQL Project
-- =====================================================

DROP DATABASE IF EXISTS RideSharingDB;

CREATE DATABASE RideSharingDB;

USE RideSharingDB;

-- =====================================================
-- TABLE: DRIVERS
-- =====================================================

CREATE TABLE Drivers (
    DriverID INT AUTO_INCREMENT PRIMARY KEY,
    DriverName VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) UNIQUE,
    LicenseNumber VARCHAR(50) UNIQUE,
    ExperienceYears INT
);

-- =====================================================
-- TABLE: PASSENGERS
-- =====================================================

CREATE TABLE Passengers (
    PassengerID INT AUTO_INCREMENT PRIMARY KEY,
    PassengerName VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE
);

-- =====================================================
-- TABLE: VEHICLES
-- =====================================================

CREATE TABLE Vehicles (
    VehicleID INT AUTO_INCREMENT PRIMARY KEY,
    DriverID INT,
    VehicleNumber VARCHAR(20) UNIQUE,
    Model VARCHAR(50),
    Capacity INT,

    FOREIGN KEY (DriverID)
    REFERENCES Drivers(DriverID)
);

-- =====================================================
-- TABLE: RIDES
-- =====================================================

CREATE TABLE Rides (
    RideID INT AUTO_INCREMENT PRIMARY KEY,
    PassengerID INT,
    DriverID INT,
    PickupLocation VARCHAR(100),
    DropLocation VARCHAR(100),
    RideDate DATETIME,
    DistanceKM DECIMAL(6,2),
    Fare DECIMAL(10,2),
    RideStatus VARCHAR(20),

    FOREIGN KEY (PassengerID)
    REFERENCES Passengers(PassengerID),

    FOREIGN KEY (DriverID)
    REFERENCES Drivers(DriverID)
);

-- =====================================================
-- TABLE: PAYMENTS
-- =====================================================

CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    RideID INT,
    Amount DECIMAL(10,2),
    PaymentMethod VARCHAR(30),
    PaymentDate DATETIME,

    FOREIGN KEY (RideID)
    REFERENCES Rides(RideID)
);

-- =====================================================
-- TABLE: RATINGS
-- =====================================================

CREATE TABLE Ratings (
    RatingID INT AUTO_INCREMENT PRIMARY KEY,
    RideID INT,
    PassengerID INT,
    DriverID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Review VARCHAR(255),

    FOREIGN KEY (RideID)
    REFERENCES Rides(RideID),

    FOREIGN KEY (PassengerID)
    REFERENCES Passengers(PassengerID),

    FOREIGN KEY (DriverID)
    REFERENCES Drivers(DriverID)
);

-- =====================================================
-- SAMPLE DATA
-- =====================================================

INSERT INTO Drivers
(DriverName, Phone, LicenseNumber, ExperienceYears)
VALUES
('Rahul Sharma', '9876543210', 'DL12345', 5),
('Amit Patil', '9876543211', 'DL67890', 3),
('Sneha Joshi', '9876543212', 'DL24680', 4);

INSERT INTO Passengers
(PassengerName, Phone, Email)
VALUES
('Pranjal Deshpande', '9999999999', 'pranjal@gmail.com'),
('Riya Gupta', '8888888888', 'riya@gmail.com'),
('Aman Verma', '7777777777', 'aman@gmail.com');

INSERT INTO Vehicles
(DriverID, VehicleNumber, Model, Capacity)
VALUES
(1, 'MH24AB1234', 'Swift Dzire', 4),
(2, 'MH24XY5678', 'Hyundai Aura', 4),
(3, 'MH24PQ9012', 'Maruti Ertiga', 6);

INSERT INTO Rides
(PassengerID, DriverID, PickupLocation,
DropLocation, RideDate, DistanceKM, Fare, RideStatus)
VALUES
(1,1,'Railway Station','College',
'2026-06-01 10:00:00',12.5,250,'Completed'),

(2,2,'Bus Stand','Market',
'2026-06-02 11:30:00',8.0,180,'Completed'),

(3,3,'Airport','Hotel',
'2026-06-03 09:00:00',20.0,450,'Completed');

INSERT INTO Payments
(RideID, Amount, PaymentMethod, PaymentDate)
VALUES
(1,250,'UPI','2026-06-01 10:30:00'),
(2,180,'Cash','2026-06-02 12:00:00'),
(3,450,'Credit Card','2026-06-03 09:45:00');

INSERT INTO Ratings
(RideID, PassengerID, DriverID, Rating, Review)
VALUES
(1,1,1,5,'Excellent service'),
(2,2,2,4,'Comfortable ride'),
(3,3,3,5,'Very professional driver');

-- =====================================================
-- QUERIES
-- =====================================================

-- View All Drivers
SELECT * FROM Drivers;

-- View All Passengers
SELECT * FROM Passengers;

-- View All Vehicles
SELECT * FROM Vehicles;

-- View All Rides
SELECT * FROM Rides;

-- Ride History Report
SELECT
    R.RideID,
    P.PassengerName,
    D.DriverName,
    R.PickupLocation,
    R.DropLocation,
    R.Fare,
    R.RideStatus
FROM Rides R
JOIN Passengers P
ON R.PassengerID = P.PassengerID
JOIN Drivers D
ON R.DriverID = D.DriverID;

-- Total Revenue
SELECT
    SUM(Amount) AS TotalRevenue
FROM Payments;

-- Average Driver Rating
SELECT
    D.DriverName,
    AVG(RA.Rating) AS AverageRating
FROM Ratings RA
JOIN Drivers D
ON RA.DriverID = D.DriverID
GROUP BY D.DriverName;

-- Top Rated Driver
SELECT
    D.DriverName,
    AVG(RA.Rating) AS Rating
FROM Ratings RA
JOIN Drivers D
ON RA.DriverID = D.DriverID
GROUP BY D.DriverName
ORDER BY Rating DESC
LIMIT 1;

-- Total Rides Per Driver
SELECT
    D.DriverName,
    COUNT(R.RideID) AS TotalRides
FROM Drivers D
LEFT JOIN Rides R
ON D.DriverID = R.DriverID
GROUP BY D.DriverName;

-- Passenger Ride Count
SELECT
    P.PassengerName,
    COUNT(R.RideID) AS TotalTrips
FROM Passengers P
LEFT JOIN Rides R
ON P.PassengerID = R.PassengerID
GROUP BY P.PassengerName;

-- Completed Rides
SELECT *
FROM Rides
WHERE RideStatus = 'Completed';

-- =====================================================
-- END OF PROJECT
-- =====================================================