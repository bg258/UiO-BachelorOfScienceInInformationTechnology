-- Query all columns for all American cities in the CITY with populations
-- larger than 100000. The CountryCode for america is USA.
SELECT *
FROM CITY
WHERE COUNTRYCODE = 'USA'
AND POPULATION > 100000;
