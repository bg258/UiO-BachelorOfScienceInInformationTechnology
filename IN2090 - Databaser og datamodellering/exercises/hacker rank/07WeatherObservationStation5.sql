/*
Query the two cities in STATION with the shortest and longest CITY names,
as well as their respective lengths(i.e.: number of characters in the name).
If there is more than one smallest or largest city, choose the one that comes
first when ordered aphabetically.

- Explanation -
When ordered alphabetically, the CITY names are listed as ABC, DEF, PQRS, and
WXY, with lengths 3, 3, 4, and 3. The longest name is PQRS, but there are 3
options for shortest name city. Choosen ABC, because it comes first alphabetically. */

SELECT CITY, LENGTH(CITY)
FROM STATION
WHERE LENGTH(CITY) IN (
    SELECT MAX(LENGTH(CITY))
    FROM STATION
)
ORDER BY CITY ASC LIMIT 1;

SELECT CITY, LENGTH(CITY)
FROM STATION
WHERE LENGTH(CITY) IN (
   SELECT MIN(LENGTH(CITY))
   FROM STATION
)
ORDER BY CITY ASC LIMIT 1;
