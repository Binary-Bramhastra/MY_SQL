-- ==========================================
-- VIDEO GAME COLLECTION DATABASE PROJECT
-- ==========================================

DROP DATABASE IF EXISTS VideoGameCollectionDB;

CREATE DATABASE VideoGameCollectionDB;

USE VideoGameCollectionDB;

-- ==========================================
-- TABLE: DEVELOPERS
-- ==========================================

CREATE TABLE Developers (
    DeveloperID INT AUTO_INCREMENT PRIMARY KEY,
    DeveloperName VARCHAR(100) NOT NULL,
    Country VARCHAR(50)
);

-- ==========================================
-- TABLE: PUBLISHERS
-- ==========================================

CREATE TABLE Publishers (
    PublisherID INT AUTO_INCREMENT PRIMARY KEY,
    PublisherName VARCHAR(100) NOT NULL,
    Country VARCHAR(50)
);

-- ==========================================
-- TABLE: PLATFORMS
-- ==========================================

CREATE TABLE Platforms (
    PlatformID INT AUTO_INCREMENT PRIMARY KEY,
    PlatformName VARCHAR(50) NOT NULL,
    Manufacturer VARCHAR(50)
);

-- ==========================================
-- TABLE: GAMES
-- ==========================================

CREATE TABLE Games (
    GameID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Genre VARCHAR(50),
    ReleaseYear INT,
    DeveloperID INT,
    PublisherID INT,

    FOREIGN KEY (DeveloperID)
        REFERENCES Developers(DeveloperID),

    FOREIGN KEY (PublisherID)
        REFERENCES Publishers(PublisherID)
);

-- ==========================================
-- TABLE: USERS
-- ==========================================

CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    UserName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE
);

-- ==========================================
-- TABLE: GAME COLLECTION
-- ==========================================

CREATE TABLE GameCollection (
    CollectionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    GameID INT,
    PlatformID INT,
    PurchaseDate DATE,
    Status VARCHAR(30),

    FOREIGN KEY (UserID)
        REFERENCES Users(UserID),

    FOREIGN KEY (GameID)
        REFERENCES Games(GameID),

    FOREIGN KEY (PlatformID)
        REFERENCES Platforms(PlatformID)
);

-- ==========================================
-- TABLE: REVIEWS
-- ==========================================

CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    GameID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 10),
    ReviewText VARCHAR(255),

    FOREIGN KEY (UserID)
        REFERENCES Users(UserID),

    FOREIGN KEY (GameID)
        REFERENCES Games(GameID)
);

-- ==========================================
-- SAMPLE DATA
-- ==========================================

INSERT INTO Developers (DeveloperName, Country)
VALUES
('Rockstar Games', 'USA'),
('Mojang Studios', 'Sweden'),
('Ubisoft Montreal', 'Canada'),
('CD Projekt Red', 'Poland');

INSERT INTO Publishers (PublisherName, Country)
VALUES
('Take-Two Interactive', 'USA'),
('Xbox Game Studios', 'USA'),
('Ubisoft', 'France'),
('CD Projekt', 'Poland');

INSERT INTO Platforms (PlatformName, Manufacturer)
VALUES
('PC', 'Various'),
('PlayStation 5', 'Sony'),
('Xbox Series X', 'Microsoft'),
('Nintendo Switch', 'Nintendo');

INSERT INTO Games
(Title, Genre, ReleaseYear, DeveloperID, PublisherID)
VALUES
('Grand Theft Auto V', 'Action', 2013, 1, 1),
('Minecraft', 'Sandbox', 2011, 2, 2),
('Assassins Creed Valhalla', 'RPG', 2020, 3, 3),
('Cyberpunk 2077', 'RPG', 2020, 4, 4);

INSERT INTO Users
(UserName, Email, JoinDate)
VALUES
('Pranjal', 'pranjal@gmail.com', '2026-01-01'),
('Riya', 'riya@gmail.com', '2026-02-01'),
('Aman', 'aman@gmail.com', '2026-03-01');

INSERT INTO GameCollection
(UserID, GameID, PlatformID, PurchaseDate, Status)
VALUES
(1,1,1,'2026-03-10','Completed'),
(1,2,2,'2026-03-15','Playing'),
(2,3,1,'2026-04-01','Completed'),
(3,4,3,'2026-05-01','Wishlist');

INSERT INTO Reviews
(UserID, GameID, Rating, ReviewText)
VALUES
(1,1,9,'Amazing open world game'),
(1,2,10,'Very creative gameplay'),
(2,3,8,'Great story and graphics'),
(3,4,7,'Good but buggy');

-- ==========================================
-- QUERIES
-- ==========================================

-- View All Games
SELECT * FROM Games;

-- View All Users
SELECT * FROM Users;

-- View All Platforms
SELECT * FROM Platforms;

-- Games Owned By Users
SELECT
    U.UserName,
    G.Title,
    P.PlatformName,
    GC.Status
FROM GameCollection GC
JOIN Users U
    ON GC.UserID = U.UserID
JOIN Games G
    ON GC.GameID = G.GameID
JOIN Platforms P
    ON GC.PlatformID = P.PlatformID;

-- Average Rating Per Game
SELECT
    G.Title,
    ROUND(AVG(R.Rating),2) AS AverageRating
FROM Games G
JOIN Reviews R
    ON G.GameID = R.GameID
GROUP BY G.Title;

-- Count Games By Genre
SELECT
    Genre,
    COUNT(*) AS TotalGames
FROM Games
GROUP BY Genre;

-- Top Rated Games
SELECT
    G.Title,
    AVG(R.Rating) AS Rating
FROM Games G
JOIN Reviews R
    ON G.GameID = R.GameID
GROUP BY G.Title
ORDER BY Rating DESC;

-- User Collection Count
SELECT
    U.UserName,
    COUNT(GC.GameID) AS TotalGamesOwned
FROM Users U
LEFT JOIN GameCollection GC
    ON U.UserID = GC.UserID
GROUP BY U.UserName;

-- Completed Games
SELECT
    U.UserName,
    G.Title
FROM GameCollection GC
JOIN Users U
    ON GC.UserID = U.UserID
JOIN Games G
    ON GC.GameID = G.GameID
WHERE GC.Status = 'Completed';

-- ==========================================
-- END OF PROJECT
-- ==========================================