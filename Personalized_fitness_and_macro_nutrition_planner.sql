-- FITNESS & NUTRITION PLANNER

DROP DATABASE IF EXISTS FitnessPlannerDB;
CREATE DATABASE FitnessPlannerDB;
USE FitnessPlannerDB;

-- TABLES
-- user
CREATE TABLE Users(
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10),
    weight_kg DECIMAL(5,2),
    height_cm DECIMAL(5,2),
    goal VARCHAR(50)
);

-- foods 
CREATE TABLE Foods(
    food_id INT AUTO_INCREMENT PRIMARY KEY,
    food_name VARCHAR(100),
    calories INT,
    protein DECIMAL(5,2),
    carbs DECIMAL(5,2),
    fats DECIMAL(5,2)
);

-- meals
CREATE TABLE Meals(
    meal_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    meal_type VARCHAR(20),
    meal_date DATE,
    FOREIGN KEY(user_id) REFERENCES Users(user_id)
);

-- MealDetails
CREATE TABLE MealDetails(
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    meal_id INT,
    food_id INT,
    quantity_g INT,
    FOREIGN KEY(meal_id) REFERENCES Meals(meal_id),
    FOREIGN KEY(food_id) REFERENCES Foods(food_id)
);

-- workouts 
CREATE TABLE Workouts(
    workout_id INT AUTO_INCREMENT PRIMARY KEY,
    workout_name VARCHAR(100),
    calories_burned_per_hour INT
);

-- workoutlog
CREATE TABLE WorkoutLog(
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    workout_id INT,
    workout_date DATE,
    duration_minutes INT,
    FOREIGN KEY(user_id) REFERENCES Users(user_id),
    FOREIGN KEY(workout_id) REFERENCES Workouts(workout_id)
);

CREATE TABLE WeightLog(
    weight_log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    log_date DATE,
    weight_kg DECIMAL(5,2),
    FOREIGN KEY(user_id) REFERENCES Users(user_id)
);

CREATE TABLE AuditLog(
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(100),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SAMPLE DATA


INSERT INTO Users
(name,age,gender,weight_kg,height_cm,goal)
VALUES
('Tarang',20,'Male',70,175,'Gain Muscle'),
('Sushant',22,'Male',82,180,'Lose Weight'),
('Pranjald',21,'Female',60,165,'Maintain');

INSERT INTO Foods
(food_name,calories,protein,carbs,fats)
VALUES
('Chicken Breast',165,31,0,3.6),
('Rice',130,2.7,28,0.3),
('Egg',155,13,1.1,11),
('Apple',52,0.3,14,0.2),
('Oats',68,2.4,12,1.4);

INSERT INTO Meals
(user_id,meal_type,meal_date)
VALUES
(1,'Breakfast','2026-06-09'),
(1,'Lunch','2026-06-09'),
(2,'Dinner','2026-06-09');

INSERT INTO MealDetails
(meal_id,food_id,quantity_g)
VALUES
(1,5,100),
(1,3,100),
(2,1,150),
(2,2,200),
(3,4,150);

INSERT INTO Workouts
(workout_name,calories_burned_per_hour)
VALUES
('Running',600),
('Gym Training',450),
('Cycling',500);

INSERT INTO WorkoutLog
(user_id,workout_id,workout_date,duration_minutes)
VALUES
(1,2,'2026-06-09',60),
(2,1,'2026-06-09',45),
(3,3,'2026-06-09',30);

INSERT INTO WeightLog
(user_id,log_date,weight_kg)
VALUES
(1,'2026-06-01',72),
(1,'2026-06-09',70),
(2,'2026-06-01',85),
(2,'2026-06-09',82);


-- FUNCTION


DELIMITER $$

CREATE FUNCTION CalculateBMI(
    weight DECIMAL(5,2),
    height DECIMAL(5,2)
)
RETURNS DECIMAL(5,2)

DETERMINISTIC

BEGIN
    RETURN weight / POWER(height/100,2);
END$$

DELIMITER ;


-- VIEW


CREATE VIEW UserBMIReport AS
SELECT
user_id,
name,
weight_kg,
height_cm,
ROUND(CalculateBMI(weight_kg,height_cm),2) AS BMI
FROM Users;


-- STORED PROCEDURE


DELIMITER $$

CREATE PROCEDURE GetWorkoutReport()
BEGIN

SELECT
u.name,
w.workout_name,
wl.duration_minutes,
ROUND(
(w.calories_burned_per_hour/60)
* wl.duration_minutes
) AS Calories_Burned

FROM WorkoutLog wl
JOIN Users u
ON wl.user_id=u.user_id
JOIN Workouts w
ON wl.workout_id=w.workout_id;

END$$

DELIMITER ;


-- TRIGGER


DELIMITER $$

CREATE TRIGGER trg_user_insert
AFTER INSERT
ON Users
FOR EACH ROW

BEGIN

INSERT INTO AuditLog(user_name)
VALUES(NEW.name);

END$$

DELIMITER ;

-- TEST TRIGGER


INSERT INTO Users
(name,age,gender,weight_kg,height_cm,goal)
VALUES
('Harshad',24,'Male',75,178,'Maintain');

-- REPORT QUERIES


SELECT * FROM Users;

SELECT * FROM Foods;

SELECT * FROM WeightLog;

SELECT * FROM AuditLog;

SELECT * FROM UserBMIReport;

CALL GetWorkoutReport();

SELECT
u.name,
f.food_name,
md.quantity_g

FROM MealDetails md
JOIN Foods f
ON md.food_id=f.food_id
JOIN Meals m
ON md.meal_id=m.meal_id
JOIN Users u
ON m.user_id=u.user_id;

SELECT
name,
ROUND(CalculateBMI(weight_kg,height_cm),2)
AS BMI
FROM Users;