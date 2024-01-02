-- Find the difference between the total number of CITY entries in the table
-- For example, if there are three records in the table with CITY values
-- 'New York', 'New York', 'Bengalaru', there are two different city names:
-- New York' and 'Bengalaru. The query returns 1, because
select COUNT(CITY) - COUNT(select CITY)
from STATION;
