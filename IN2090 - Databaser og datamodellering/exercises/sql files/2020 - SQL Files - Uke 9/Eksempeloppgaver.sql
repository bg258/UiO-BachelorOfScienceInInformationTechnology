-- 09- Eksempler: Aggregerinng og sortering
-- 1. Finn produktnavn, kategorinavn og pris på produkter, sortert etter
--    kategorinavn og deretter produktnavn.

SELECT p.product_name, c.category_name, p.unit_price AS price
FROM products AS p
  INNER JOIN categories AS c USING (category_id)
GROUP BY c.category_name, p.product_name, p.unit_price
ORDER BY c.category_name, p.unit_price ASC, p.product_name;

-- Løsningsfoslag
SELECT c.category_name, p.product_name, p.unit_price
FROM categories AS c
  INNER JOIN products AS p ON (c.category_id = p.category_id)
ORDER BY c.category_name, p.product_name;

-- 2. Finn navnet på de 10 høyeste ratede filmene i Filmdatabasen med mer enn
--    1000 stemmer
SELECT f.title, r.rank
FROM film AS f
  INNER JOIN filmrating AS r USING (filmid)
WHERE r.votes > 1000
ORDER BY r.rank DESC
LIMIT 10;

-- Løsningsforslag
SELECT f.title, r.rank
FROM film AS f
  INNER JOIN filmrating  AS r USING (filmid)
WHERE r.votes > 1000
ORDER BY r.rank DESC
LIMIT 10;

-- 3. Finn ut hvor mange kunder kommer fra hvert land.
SELECT DISTINCT country, COUNT(customer_id) AS num_kunder
FROM customers
GROUP BY country
ORDER BY num_kunder DESC;

-- Løsningsforslag
SELECT country, count(*) AS nr_customers
FROM customers
GROUP BY country;

-- 4. Finn navn og total regning for hver kunde (anta at ingen bestillinger
--    ennå ikke er betalt for)
SELECT c.company_name, SUM (od.unit_price * od.quantity * (1 - od.discount))
FROM customers AS c
  INNER JOIN orders AS o ON c.customer_id = o.customer_id
  INNER JOIn order_details AS od ON o.order_id = od.order_id
GROUP BY o.customer_id, c.company_name;

--Løsningsforslag
SELECT c.company_name,
       sum(d.unit_price * d.quantity * (1 - d.discount)) AS customertotal
FROM customers AS c
  INNER JOIN orders AS o USING (customer_id)
  INNER JOIN order_details AS d USING (order_id)
GROUP BY c.customer_id, c.company_name;

-- 5. Finn navn og total regning for hver kunde som har kjøpt fler enn 1000
--    varer, sortert alfabetisk etter firmanavn.
SELECT c.company_name, SUM (od.unit_price * od.quantity * (1 - od.discount))
FROM customers AS c
  INNER JOIN orders AS o ON c.customer_id = o.customer_id
  INNER JOIN order_details AS od ON o.order_id = od.order_id
GROUP BY o.customer_id, c.company_name
HAVING SUM(od.quantity) > 1000;

-- Løsningsforslag

SELECT c.company_name,
       SUM(d.unit_price * d.quantity * (1 - d.discount)) AS customertotal
FROM customers AS C
  INNER JOIN orders AS o USING (customer_id)
  INNER JOIN order_details AS d USING (order_id)
GROUP BY c.customer_id, c.company_name
HAVING sum(d.quantity) > 1000
ORDER BY c.company_name;

-- 6. Finn de 10 skuespillerne som har spilt i flest filmer, men som har spilt
--    i filmer med gjennomsnitts-rating høyere enn 9, sortert etter antall
--    filmer de har spilt i.
SELECT p.firstname, p.lastname, COUNT(fp.filmid) AS antallFilmer
FROM filmparticipation AS fp
  INNER JOIN person AS p ON fp.personid = p.personid
  INNER JOIN filmrating AS r ON fp.filmid = r.filmid
GROUP BY fp.personid, p.firstname, p.lastname
HAVING avg(r.rank) > 9
ORDER BY antallFilmer DESC
LIMIT 10;

-- Løsningsforslag
WITH
  played_in AS (
    SELECT DISTINCT fp.personid, fp.filmid, r.rank
    FROM filmparticipation AS fp
      INNER JOIN film  AS f USING (filmid)
      INNER JOIN filmrating AS r USING (filmid)
    WHERE fp.parttype = 'cast'
  )
SELECT p.personid, p.firstname, p.lastname, COUNT(*) AS nr_played_in
FROM person AS p
  INNER JOIN played_in AS pi USING (personid)
GROUP BY p.personid, p.firstname, p.lastname
HAVING avg(pi.rank) > 9
ORDER BY nr_played_in DESC
LIMIT 10;
