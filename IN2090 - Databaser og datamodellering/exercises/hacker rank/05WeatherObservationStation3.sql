-- Query a list of CITY names from STATION for cities that have an even ID.
-- Print the results in any order, but exclude duplicates from the answer.
select distinct CITY
from STATION
where mod(id, 2) = 0;
