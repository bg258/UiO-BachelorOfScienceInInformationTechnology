-- UKE 9: AGGREGERING
-- Eksempel: Variable i delspørringer (1)
-- Finn navnet på alle drikkevarer som aldri har blitt solgt for lavere enn
-- gjennomsnittsprisen for alle salg.

-- MERK: --
-- Man kan bruke variabler fra en spørring i dens delspørringer
SELECT p.product_name
FROM products AS p
  INNER JOIN categories AS c USING (category_id)
WHERE c.category_name = 'Beverages' AND
  (SELECT AVG(unit_price)
   FROM order_details)
  <
  (SELECT MIN(d.unit_price)
   FROM order_details AS d
   WHERE p.product_id = d.product_id);


-- Eksempel: Variable i delspørringer (2)
-- Finn antall produkter for hver kategori
SELECT c.category_name,
       (SELECT COUNT(*)
        FROM products AS p
        WHERE p.category_id = c.category_id) AS nr_products
FROM categories AS c;

-- Eksempel 1: Finn navn og pris på produktet med lavest pris (1)
-- Ved min-aggregering og tabell-delspørring
SELECT product_name, unit_price
FROM products
WHERE unit_price = (SELECT MIN(unit_price)
                    FROM products);

-- Løsning

SELECT p.product_name, p.unit_price
FROM products AS p,
  (SELECT min(unit_price) AS minprice
   FROM products) AS h
WHERE p.unit_price = h.minprice;

-- Tredje løsning (Ved ORDER BY og LIMIT 1)
SELECT product_name, unit_price
FROM products
ORDER BY unit_price
LIMIT 1;

-- Aggregering i grupper: Eksempel --
-- Finn gjennomsnittsprisen for hver kategori --
SELECT Category, AVG(price) AS Averageprice
FROM products
GROUP BY Category;

-- Aggregering i grupper: Eksempel 1
-- Finn antall produkter per bestilling
SELECT d.order_id, COUNT(d.quantity) AS antall_produkter
FROM orders AS o
  INNER JOIN order_details AS d USING (order_id)
GROUP BY d.order_id
LIMIT 10;

-- Aggregering i grupper: Eksempel 2
-- Finn navn på ansatte og antall bestillinger den ansatte har håndtert, sortert
-- etter antall bestillinger fra høyest til lavest.

SELECT e.first_name || ' ' || e.last_name,
       COUNT(o.order_id) AS antall_bestillinger
FROM orders AS o
  INNER JOIN employees AS e USING (employee_id)
GROUP BY o.employee_id, e.first_name, e.last_name
ORDER BY antall_bestillinger DESC;

-- Løsning
SELECT format('%s %s', e.first_name, e.last_name) AS emp_name,
       COUNT(o.order_id) AS num_orders
FROM orders AS o
  INNER JOIN employees AS e USING (employee_id)
GROUP BY e.employee_id
ORDER BY num_orders DESC;


-- Aggregering i grupper: Eksempel 3
-- Finn beskrivelsen av den kategorien med høyest gjennomsnittsprisen
SELECT c.category_name, AVG(unit_price) AS average
FROM products AS p
  INNER JOIN categories AS c USING (category_id)
GROUP BY c.category_id
ORDER BY average DESC
LIMIT 1;

-- Løsning
SELECT c.description, a.avgprice
FROM (SELECT category_id, avg(unit_price) AS avgprice
      FROM products
      GROUP BY category_id) AS a
      INNER JOIN categories AS c ON (c.category_id = a.category_id)
ORDER BY a.avgprice DESC
LIMIT 1;

-- Aggregering i grupper: Eksempel 4
-- Finn navn og total regning for hver kunde
SELECT c.contact_name,
       SUM(d.unit_price * d.quantity * (1 - d.discount)) AS total_regning
FROM customers AS c
  INNER JOIN orders AS o USING (customer_id)
  INNER JOIN order_details AS d ON (d.order_id = o.order_id)
GROUP BY c.customer_id
ORDER BY total_regning DESC
LIMIT 10;

-- Løsning
SELECT SUM(d.unit_price * d.quantity * (1 - d.discount)) AS customertotal,
       c.company_name
FROM customers AS c
  INNER JOIN orders AS o ON (c.customer_id = o.customer_id)
  INNER JOIN order_details AS d ON (o.order_id = d.order_id)
GROUP BY c.customer_id;


-- Gruppere på flere kolonner
-- Finn antall produkter for hver kombinasjon av kategori og hvorvidt
-- produktet fortsatt selges
SELECT c.category_name, p.discontinued , COUNT(*) as nr_products
FROM categories AS c
  INNER JOIN products AS p USING (category_id)
GROUP BY c.category_id, p.discontinued;

-- Filtrere på aggregat-resultat
-- Nå kan vi gjøre dette med en delspørring:
SELECT category_name, nr_products
FROM (
  SELECT c.category_name, COUNT(*) AS nr_products
  FROM categories AS c
    INNER JOIN products AS p USING (category_id)
  GROUP BY c.category_id) AS t
WHERE nr_products > 10;

-- Men det finnes en egen klausul for å begrense på uttrykkene i SELECT,
-- slik som aggregater.

SELECT c.category_name, COUNT(*) AS nr_products
FROM categories AS c
  INNER JOIN products AS p USING (category_id)
GROUP BY c.category_id
HAVING COUNT(*) > 10;

-- Eksempel 1: Implisitt informasjon om kategorier
-- Finn høyeste, laveste og gjennomsnittsprisen på produktene i hver kategori.
SELECT c.category_id, c.category_name,
       max(p.unit_price) AS highest,
       min(p.unit_price) AS lowest,
       avg(p.unit_price) AS average
FROM categories AS c
  INNER JOIN products AS p USING (category_id)
GROUP BY c.category_id;

-- Eksempel 2: Implisitt informasjon om land
-- Finn de tre mest kjøte produktene for hvert land
WITH
  sold_by_country AS (
    SELECT c.country, p.product_id, p.product_name, COUNT(*) AS nr_sold
    FROM products AS p
      INNER JOIN order_details AS d USING (product_id)
      INNER JOIN orders AS o USING (order_id)
      INNER JOIN customers AS c USING (customer_id)
    GROUP BY c.country, product_id
  ),
  sold_ordered AS (
    SELECT *
    FROM sold_by_country ORDER BY nr_sold DESC
  )
SELECT c.country,
  (SELECT s.product_name FROM sold_ordered AS s
   WHERE s.country = c.country
   LIMIT 1) AS first_place,
  (SELECT s.product_name FROM sold_ordered AS s
   WHERE s.country = c.country
   OFFSET 1
   LIMIT 1) AS second_place,
  (SELECT s.product_name FROM sold_ordered AS s
   WHERE s.country = c.country
   OFFSET 2
   LIMIT 1) AS third_place
FROM (SELECT DISTINCT country FROM customers) AS c;
