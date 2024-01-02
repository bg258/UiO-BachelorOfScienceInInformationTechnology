-- 10. Outer joins og mengdeoperatorer: Eksempler
-- Oppgaver
-- 1. Northwind: Finn navn og antall bestillinger for alle kunder som har gjort
--               færre enn 5 bestillinger

SELECT c.company_name, COUNT(o.order_id) AS antall_bestillinger
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
GROUP BY o.customer_id, c.company_name
HAVING count(o.order_id) < 5;

-- Løsningsforslag

SELECT c.company_name,
       COUNT(o.order_id) AS num_orders
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
GROUP BY c.company_name
HAVING COUNT(o.order_id) < 5;


-- 2. Northwind: Finn ut antall ganger hver ansatt har håndtert en ordre fra
--               hver kunde
-- Vi tar Kryssproduktet, fordi da vil vi finne alle mulige par
WITH
  handtert_av_kunde AS (
    SELECT e.employee_id,
           format('%s %s', e.first_name, e.last_name) AS fullname,
           c.customer_id,
           c.company_name AS company
    FROM customers c, employees e
  )
SELECT hk.fullname, hk.company, COUNT(o.order_id)
FROM handtert_av_kunde AS hk
  LEFT OUTER JOIN orders AS o ON o.employee_id = hk.employee_id AND
                                 o.customer_id = hk.customer_id
GROUP BY o.employee_id, o.customer_id, hk.fullname, hk.company;

-- Løsningsforslag

WITH
  all_combinations AS (
    SELECT e.employee_id,
           e.first_name || ' ' || e.last_name AS fullname,
           c.customer_id,
           c.company_name
    FROM employees AS e, customers AS c -- Kryssproduktet, alle kombinasjoner
  )
SELECT ac.fullname, ac.company_name, COUNT(o.order_id) AS num_transactions
FROM all_combinations AS ac
  LEFT OUTER JOIN orders AS o USING (employee_id, customer_id)
GROUP BY ac.company_name, ac.fullname;

-- 3. Northwind: Finn ut hvor mye penger hver kunde har kjøpt for, for de som
--               bestilt færre enn 100 produkter totalt.
SELECT c.company_name, SUM(d.unit_price * d.quantity * (1 - d.discount))
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
  LEFT OUTER JOIN order_details AS d USING (order_id)
GROUP BY o.customer_id, c.company_name,
HAVING SUM(d.quantity) < 100;

-- Løsningsforslag

SELECT c.company_name,
       SUM(d.unit_price * d.quantity * (1 - d.discount)) AS sum_money
FROM customers AS c
  LEFT OUTER JOIn orders AS o USING (customer_id)
  LEFT OUTER JOIN order_details AS d USING (order_id)
GROUP BY c.company_name
HAVING SUM(d.quantity) < 100 OR
       SUM(d.quantity) IS NULL; -- MERK: NULL < 100 er NULL

-- 4. Filmdatabasen: Finn alle filmer og serier som er laget i Norge
(SELECT COUNT(f.title)
FROM film AS f
  INNER JOIN filmcountry AS fc USING (filmid)
WHERE fc.country = 'Norway')
UNION
(SELECT COUNT(s.seriesid)
FROM series AS s
  INNER JOIN filmcountry AS f ON s.seriesid = f.filmid
WHERE f.country = 'Norway'
LIMIT 10);

-- Løsning

(SELECT 'Serie' AS type,
         s.maintitle AS title
FROM series AS s
  INNER JOIN filmcountry AS c ON (s.seriesid = c.filmid)
WHERE c.country = 'Norway')
UNION
(SELECT 'Film' AS type,
         f.title AS title
 FROM film AS f
  INNER JOIN filmcountry AS c USING (filmid)
 WHERE c.country = 'Norway');
-- 5. Filmdatabasen: Finn ut hvor mange filmer og serier som ble laget hvert år,
--                   sortert etter antall

WITH
  years AS (
    SELECT prodyear AS year
    FROM film
    UNION ALL
    SELECT firstprodyear AS year
    FROM series
)
SELECT year, count(*) AS nr
FROM years
GROUP BY year
ORDER BY nr;

-- 6. Filmdatabasen: Finn ut hvor mange filmer og serier som ble laget hvert
--                   hvert tiår, sortert etter antall(vanskelig!)

WITH
years AS (
SELECT prodyear AS year FROM film
UNION ALL
SELECT firstprodyear AS year FROM series
)
SELECT year/10, count(*) AS nr
FROM years
GROUP BY year/10 -- Heltallsdivisjon her gir tiår ORDER BY nr;


-- Oppgave 6: Løsning (penere output)

-- Finn ut hvor mange filmer og serier om ble laget hvert tiår, sorter etter antall (vanskelig!)
WITH
years AS (
SELECT prodyear AS year FROM film
UNION ALL
SELECT firstprodyear AS year FROM series
)
SELECT ((year/10)*10)::text || ' - ' || (((year/10)*10)+9)::text AS tiår,
count (*) AS nr FROM years
GROUP BY year/10 ORDER BY nr;
