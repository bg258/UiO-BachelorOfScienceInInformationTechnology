/*
Query the list of CITY names from STATION which have vowels
(i.e., a, e, i, o, and u) as both their first and last characters.
Your result cannot contain duplicates. */
SELECT DISTINCT
  CITY
FROM
  STATION
WHERE
  CITY LIKE ('%[aeiou]') and CITY LIKE ('[AEIOU]%');

/*
Weather Observation Station 9
Query the list of CITY names from STATION that do not start
with vowels. Your result cannot obtain duplicates. */
SELECT DISTINCT
  CITY
FROM
  STATION
WHERE CITY NOT LIKE ('[AEIOU]%');

/*
Weather Observation Station 10
Query the list of CITY names from STATION that do not end with wovels.
Your result cannot contain duplicates.*/
select distinct
  CITY
from
  STATION
where
  CITY not like ('%[aeiou]');

/*
Weather Observation Station 11
Query the list of CITY names from STATION that either do not start with vowels
or do not end with vowels. Your result cannot contain duplicates. */
select distinct
  CITY
from
  STATION
where
  CITY not like ('%[aeiou]') or CITY not like ('[AEIOU]%');

/*
Weather Observation Station 12
Query the list of CITY names from STATION that do not start with vowels
and do not end with vowels. Your result cannot contain duplicates. */
select distinct
  CITY
from
  STATION
where CITY not like ('%[aeiou]') and CITY not like ('[AEIOU]%');

/*
Higher than 75 Marks
Query the Name of any STUDENTS who scored higher than 75 Marks. Order your
outpyt by the last three characters of each name. If two or more studens both
have names ending in the same last three characters (i.e.: Bobby, Robby, etc.),
secondary sort them by ascending ID. */

SELECT
  Name
FROM
  STUDENTS
WHERE
  Marks > 75
ORDER BY Name, RIGHT(Name, 3), RIGHT(Name, 2), RIGHT(Name, 1), ID;

/*
Employee Names
Write a query that prints a list of employee names  (i.e.: the name attribute)
from the Employee table in alphabetical order. */
SELECT
  name
FROM
  Employee
ORDER BY name ASC;

/*
Employee Salaries
Write a query that prints a list of employee names (i.e.: the name attribute)
for employees in Employee having a salary greater than $2000 per month
who have been employees for less than 10 months. Sort your result by ascending
employee_id */
SELECT
  name
FROM
  Employee
WHERE
  salary > 2000
AND
  months < 10
ORDER BY
  employee_id ASC;


/*
Weather Observation Station 17
Query the Western Longitude (LONG_W)where the smallest Northern Latitude (LAT_N)
in STATION is greater than . Round your answer to  decimal places.*/
select
  cast(long_w as decimal(20, 4))
from
  station
where
  lat_n =
  (select
    min(lat_n)
  from
    station
  where lat_n > 38.7780);

/*
Weather Observation Station 18
Consider P1(a, b) and P2(c, d) to be two points on a 2D plane.

 happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
 happens to equal the minimum value in Western Longitude (LONG_W in STATION).
 happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
 happens to equal the maximum value in Western Longitude (LONG_W in STATION).
Query the Manhattan Distance between points  and  and round it to a scale of  decimal places.*/

SELECT cast((max(lat_n) - min(lat_n)) + (max(long_w) - min(long_w)) as decimal (20, 4))
FROM station;
