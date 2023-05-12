/*

Comparing the fastest Q3 times in 2022 and 2023 at the races that have taken so far this year (Bahrain, Saudi Arabia, Australia)

Used the 'Formula 1 World Championship (1950 - 2022)' dataset on Kaggle. https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020

*/


-- Joined Drivers and Qualifying tables, casting Q1, Q2, and Q3 as times

SELECT qual.driverId, qual.position, CAST(qual.q1 AS time) AS Q1, CAST(qual.q2 AS time) AS Q2, CAST(qual.q3 AS time) AS Q3, drv.forename, drv.surname
FROM F1..drivers drv
JOIN F1..qualifying qual
	ON drv.driverId = qual.driverID

-- Joined the races table to the 2 existing tables

SELECT qual.driverId, qual.position, CAST(qual.q1 AS time) AS Q1, CAST(qual.q2 AS time) AS Q2, CAST(qual.q3 AS time) AS Q3, drv.forename, drv.surname, rac.year, rac.name
FROM F1..drivers drv
JOIN F1..qualifying qual
	ON drv.driverId = qual.driverID
JOIN F1..races rac ON rac.raceId = qual.raceId

-- Looking at the fastest Q3 times in 2023, NULL times have been removed which would indicate an elimination from Q2 

SELECT qual.position, CAST(qual.q3 AS time) AS Q3, drv.forename, drv.surname, rac.year, rac.name
FROM F1..drivers drv
JOIN F1..qualifying qual
	ON drv.driverId = qual.driverID
JOIN F1..races rac ON rac.raceId = qual.raceId
WHERE q3 IS NOT NULL
	AND year = 2023
ORDER BY q3 ASC


-- Looking at the fastest Q3 times in 2022, limiting the results to the races that have taken place so far in 2023

SELECT qual.position, CAST(qual.q3 AS time) AS Q3, drv.forename, drv.surname, rac.year, rac.name
FROM F1..drivers drv
JOIN F1..qualifying qual
	ON drv.driverId = qual.driverID
JOIN F1..races rac ON rac.raceId = qual.raceId
WHERE q3 IS NOT NULL
	AND year = 2022
	AND (name = 'Bahrain Grand Prix' OR name = 'Saudi Arabian Grand Prix' OR name = 'Australian Grand Prix')
ORDER BY q3 ASC


/*

Tableau Queries

*/

-- Comparing Q3 2023, 2022 in Bahrain, ordered by Qualifying time and resulting position 

SELECT qual.position, CAST(qual.q3 AS time) AS Q3, rac.year, rac.name, drv.forename + ' ' + drv.surname AS Driver, code
FROM F1..drivers drv
JOIN F1..qualifying qual
	ON drv.driverId = qual.driverID
JOIN F1..races rac ON rac.raceId = qual.raceId
WHERE q3 IS NOT NULL
	AND (year = 2022 OR year = 2023)
	AND name LIKE '%Bahrain%'
ORDER BY q3 ASC, position ASC

-- Comparing Q3 2023, 2022 in Saudi Arabia, ordered by Qualifying time and resulting position

SELECT qual.position, CAST(qual.q3 AS time) AS Q3, rac.year, rac.name, drv.forename + ' ' + drv.surname AS Driver, code
FROM F1..drivers drv
JOIN F1..qualifying qual
	ON drv.driverId = qual.driverID
JOIN F1..races rac ON rac.raceId = qual.raceId
WHERE q3 IS NOT NULL
	AND (year = 2022 OR year = 2023)
	AND name LIKE '%Saudi%'
ORDER BY q3 ASC, position ASC

-- Comparing Q3 2023, 2022 in Australia, ordered by Qualifying time and resulting position

SELECT qual.position, CAST(qual.q3 AS time) AS Q3, rac.year, rac.name, drv.forename + ' ' + drv.surname AS Driver, code
FROM F1..drivers drv
JOIN F1..qualifying qual
	ON drv.driverId = qual.driverID
JOIN F1..races rac ON rac.raceId = qual.raceId
WHERE q3 IS NOT NULL
	AND (year = 2022 OR year = 2023)
	AND name LIKE '%Australia%'
ORDER BY q3 ASC, position ASC


