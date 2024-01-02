/*
Query the NAME field for all american cities in the CITY table with populatons
larger than 120000. The CountryCode for America is USA. */
SELECT NAME
FROM CITY
WHERE CountryCode = 'USA'
AND POPULATION > 120000;
