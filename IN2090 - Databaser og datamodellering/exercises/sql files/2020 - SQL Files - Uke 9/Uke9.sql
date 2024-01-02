-- Eksempel: Variable i delspørringer (1)
-- Finn navnet på alle drikkevarer som aldri har blitt solgt for lavere enn
-- gjennomsnittsprisen for alle salg

-- We have a category_id, category_name, description, picture.

SELECT p.product_name
FROM products AS p
  INNER JOIN categories AS c ON (p.category_id = c.category_id)
WHERE c.category_name = 'Beverages'AND
 (SELECT avg(unit_price)
  FROM order_details)
  <
  (SELECT min(d.unit_price)
   FROM order_details AS d
   WHERE p.product_id = d.product_id);


-- Eksempel: Variable i delspørringer (2)
-- Finn antall produkter for hver kategori
SELECT c.category_name, COUNT(*)
FROM categories AS c
  INNER JOIN products AS p ON (p.category_id = c.category_id)
GROUP BY c.category_name;

-- eller
SELECT c.category_name,
  (SELECT count(*)
   FROM products AS p
   WHERE p.category_id = c.category_id) AS nr_products
FROM categories AS c;

-- SORTERING --
-- For eksempel, for å sortere alle drikkevarer etter pris:
SELECT p.product_name, p.unit_price
FROM products AS p
  INNER JOIN categories AS c ON (p.category_id = c.category_id)
WHERE c.categorydescription = 'Beverages'
ORDER BY p.unit_price;

-- SORTERE PÅ FLERE KOLONNER OG REVERSERING --
-- For eksempel, for å sortere drikkevarer først på pris, og så på antall på lager,
-- begge i nedgående rekkefølger:
SELECT p.product_name, p.units_in_stock, p.unit_price
FROM products AS p
  INNER JOIN categories AS c ON (p.category_id = c.category_id)
WHERE c.category_name = 'Beverages'
ORDER BY p.unit_price DESC,
         p.units_in_stock DESC;

-- Begrense antall rader i resultatet
-- For eksempel, for å velge ut de dyreste 5 produktene:
SELECT p.product_name, p.unit_price
  FROM products AS p
ORDER BY p.unit_price DESC
LIMIT 5;


-- Eksempel 1: Finn navn og pris på produktet med lavest pris (1)
SELECT p.product_name, p.unit_price
FROM products AS p,
  (SELECT min(unit_price) AS minPrice
   FROM products) AS h
WHERE p.unit_price = h.minprice;


-- Eksempel 1: Finn navn og pris på produktet med lavest pris (2)
SELECT product_name, unit_price
FROM products
WHERE unit_price = (SELECT min(unit_price)
                    FROM products);

-- Eksempel 1: Finn navn og pris på produktet med lavest pris (3)
SELECT product_name, unit_price
FROM products
ORDER BY unit_price
LIMIT 1;

-- Aggregering i grupper: Eksempel 1
-- Finn antall produkter per bestilling
SELECT od.order_id, SUM(od.quantity)
FROM order_details AS od
  INNER JOIN products AS p USING (product_id)
GROUP BY od.order_id
LIMIT 10;

--  eller

SELECT o.order_id, sum(d.quantity) AS nr_products
FROM orders AS o INNER JOIN order_details AS d
    USING (order_id)
GROUP BY o.order_id;


--- Aggregering i grupper: Eksempel 2 ---
-- Finn navn og antall bestillinger den ansatte har håndtert, sortert
-- etter antall bestillinger fra høyest til lavest.
SELECT e.first_name, COUNT(o.order_id)
FROM employees AS e
  INNER JOIN orders AS o USING (employee_id)
GROUP BY (employee_id)
ORDER BY COUNT(o.order_id) DESC;

-- eller

SELECT format('%s %s', e.first_name, e.last_name) AS emp_name,
  count(o.order_id) AS num_orders
FROM orders AS o
  INNER JOIN employees AS e USING (employee_id)
GROUP BY e.employee_id
ORDER BY num_orders DESC;

-- Aggregering i grupper: Eksempel 3
-- Finn beskrivelsen av den kategorien med høyest gjennomsnittsprisen

SELECT c.description
FROM categories AS c
  INNER JOIN Products AS p USING (category_id)
GROUP BY (category_id)
ORDER BY avg(unit_price) DESC
LIMIT 1;

-- Eller

SELECT c.description, a.avgprice
FROM (SELECT category_id, avg(unit_price) AS avgprice
      FROM products
      GROUP BY category_id) AS a
     INNER JOIN categories AS c
     ON (c.category_id = a.category_id)
ORDER BY a.avgprice DESC
LIMIT 1;


-- Aggregering i grupper: Eksempel 4
-- Finn navn og total regning for hver kunde

SELECT c.company_name, SUM(od.unit_price * od.quantity * (1 - od.discount))
FROM order_details AS od
  INNER JOIN orders AS o ON (od.order_id = o.order_id)
  INNER JOIN customers AS c ON (o.customer_id = c.customer_id)
GROUP BY c.customer_id
LIMIT 1;

-- eller
SELECT sum(d.unit_price * d.quantity * (1 - d.discount)) AS customerTotal,
       c.company_name
FROM customers AS c
  INNER JOIN orders AS o
    ON (c.customer_id = o.customer_id)
  INNER JOIN order_details AS d
    ON (o.order_id = d.order_id)
GROUP BY c.customer_id;


-- Gruppere på flere kolonner
-- Finn antall produkter for hver kombinasjon av kategori og hvorvidt produktet
-- fortsatt selges
SELECT c.category_name, p.discontinued, COUNT(*) AS nr_products
FROM categories AS c
  INNER JOIN products AS p
    USING (category_id)
GROUP BY c.category_id, p.discontinued;


-- Filtrere på aggregat-resultat
-- F.eks dersom man vil vite kategorinavn og antall produkter på de kategoriene
-- som har flere enn 10 produkter.

SELECT category_name, nr_products
FROM (
  SELECT c.category_name, count(*) AS nr_products
  FROM categories AS c
    INNER JOIN products AS p USING (category_id)
  GROUP BY c.category_id
) AS t
WHERE nr_products > 10;

-- Eksempel 1: Implisitt informasjon om kategorier
-- Finn høyeste, laveste, og gjennomsnittsprisen på produktene i hver kategori
SELECT c.category_name, min(p.unit_price) as MIN, max(p.unit_price) as MAX,
       avg(p.unit_price) AS AVERAGE
FROM categories AS c
  INNER JOIN products AS p USING(category_id)
GROUP BY (category_id);

-- eller

SELECT c.category_id, c.category_name,
       max(p.unit_price) AS highest,
       min(p.unit_price) AS lowest,
       avg(p.unit_price) AS average
FROM categories AS c
  INNER JOIN products AS p USING (category_id)
GROUP BY c.category_id


-- Eksempel 2: Implisitt informasjon om land
-- Finn de tre mest kjøpte produktene for hvert land
-- Det første vi vil gjøre er å finne hvilke produkter er solgt i hvert land.
WITH
  ordered_country AS
  (SELECT DISTINCT d.product_id, c.country, COUNT(*) AS nr_ordered
   FROM customers AS c
    INNER JOIN orders AS o USING (customer_id)
    INNER JOIN order_details AS d USING (order_id)
    GROUP BY d.product_id, c.country
  ),
  sorted AS
  (SELECT * FROM ordered_country
   ORDER BY nr_ordered)
SELECT c2.country,
       (SELECT s.product_id
        FROM sorted as s
        WHERE c2.country = s.country
        LIMIT 1) as firstplace,

       (SELECT s.product_id
        FROM sorted as s
        WHERE c2.country = s.country
        LIMIT 1
        OFFSET 1) as secondplace,

       (SELECT s.product_id
        FROM sorted as s
        WHERE c2.country = s.country
        LIMIT 1
        OFFSET 2) as thirdplace

FROM (SELECT DISTINCT country FROM customers) as c2;
