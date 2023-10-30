-- Uke 10 --
-- INNER JOINS og manglende verdier med aggregater
-- Hvor mange har kjøpt hvert produkt?
SELECT ProductName, count(o.Customer) AS num
FROM products AS p
  INNER JOIN orders AS o
GROUP BY p.ProductID;

-- Eksempel: LEFT OUTER JOIN
-- LEFT OUTER JOIN mellom products og orders
SELECT *
FROM products AS p
  LEFT OUTER JOIN orders AS o ON p.ProductID = o.ProductID;

-- Eksempel: LEFT OUTER JOIN
-- Hvor mange har kjøpt hvert produkt?
SELECT p.ProductName, COUNT(o.Customer) AS num
FROM products AS p
  LEFT OUTER JOIN orders AS o
ON p.ProductID = o.ProductID
GROUP BY p.ProductID;


-- Andre nyttige bruksområder for ytre joins
SELECT p.Name, n.Phone, e.Email
FROM Persons AS p
  LEFT OUTER JOIN Numbers AS n ON (p.ID = n.ID)
  LEFT OUTER JOIN Emails AS e ON (p.ID = e.ID);

-- Ytre join - Eksempel
-- Finn antall bestillinger gjort av hver kunde
SELECT c.company_name, COUNT(o.order_id) AS bestillinger
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
GROUP BY o.customer_id, c.company_name
ORDER BY bestillinger;

-- Løsning
SELECT c.company_name, COUNT(o.order_id) AS num_orders
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
GROUP BY c.customer_id;

-- Ytre join-Eksempel (2)
-- Finn ut hvor mye penger hver kunde har bestilt, for de som har færre en
-- 5 bestillinger.

SELECT c.company_name,
       SUM(d.unit_price * d.quantity * (1 - d.discount))
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
  LEFT OUTER JOIN order_details AS d ON (o.order_id = d.order_id)
GROUP BY o.customer_id, c.company_name
HAVING COUNT(DISTINCT o.order_id) < 5;

-- Løsning

SELECT c.company_name,
       SUM(d.unit_price * d.quantity) AS sum_money
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
  LEFT OUTER JOIN order_details AS d USING (order_id)
GROUP BY c.customer_id
HAVING COUNT(DISTINCT o.order_id) < 5;

-- Ytre join - Eksempel (3)
-- Finn ut hvor mye penger hver kunde har bestilt, for de som har færre enn
-- 100 produkter.

SELECT c.company_name,
       SUM(d.unit_price * d.quantity * (1 - d.discount))
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
  LEFT OUTER JOIN order_details AS d USING (order_id)
GROUP BY o.customer_id, c.company_name
HAVING SUM(d.quantity) < 100 OR
       SUM(d.quantity) IS NULL;

-- Løsning
SELECT c.company_name,
       SUM(d.unit_price * d.quantity) AS sum_money
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
  LEFT OUTER JOIN order_details AS d USING (order_id)
GROUP BY c.customer_id
HAVING SUM(d.quantity) < 100 OR
       SUM(d.quantity) IS NULL; -- Merk: NULL < 100 er NULL

-- Ytre join-eksempel (4)
-- Finn ut antall ganger hver ansatt har håndtert en ordre fra hver kunde
WITH
  employee_customer AS (
    SELECT s.customer_id AS customer_id , c.employee_id AS employee_id
    FROM customers s, employees c
  )
SELECT ec.customer_id, ec.employee_id, COUNT(o.order_id)
FROM employee_customer AS ec
  LEFT OUTER JOIN orders AS o ON (ec.employee_id = o.employee_id AND
                                  ec.customer_id = o.customer_id)
GROUP BY ec.customer_id, ec.employee_id
ORDER BY ec.customer_id, ec.employee_id
LIMIT 9;

-- Løsning

WITH
  all_combinations AS (
    SELECT e.employee_id,
           e.first_name || ' ' || e.last_name AS full_name,
           c.customer_id,
           c.company_name
    FROM employees AS e, customers AS c -- Kryssproduktet
  )
SELECT ac.full_name,
       ac.company_name,
       COUNT(o.order_id) AS num_transactions
FROM all_combinations AS ac
  LEFT OUTER JOIN orders AS o ON (ac.employee_id = o.employee_id AND
                                  ac.customer_id = o.customer_id)
GROUP BY ac.customer_id, ac.company_name,
         ac.employee_id, ac.fullname;


-- Ytre join-eksempel (5)
-- Finn navnet på alle kunder som ikke har bestilt noe
SELECT c.company_name
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
WHERE o.customer_id IS NULL;


-- Eksempel: UNION --
-- Finn navn på alle produkter som enten kommer fra eller er solgt til Norge
(SELECT p.product_name
FROM products AS p
  INNER JOIN suppliers AS s USING (supplier_id)
WHERE s.country = 'Norway')
UNION
(SELECT pr.product_name
FROM orders AS p
  INNER JOIN order_details AS od USING (order_id)
  INNER JOIN products AS pr ON (od.product_id = pr.product_id)
WHERE p.ship_country = 'Norway');

-- Løsning
(SELECT p.product_name
 FROM products AS p
    INNER JOIN order_details AS d USING (product_id)
    INNER JOIN orders AS o USING (order_id)
    INNER JOIN customers AS c USING (customer_id)
 WHERE c.country = 'Norway')
UNION
(SELECT p.product_name
 FROM products AS p
    INNER JOIN suppliers AS s USING (supplier_id)
 WHERE s.country = 'Norway');

-- Eksempel: Snitt
-- Finn navnet på alle sjefer som har håndtert bestillinger
SELECT first_name, last_name
FROM employees
WHERE employee_id IN (
  (SELECT reports_to
   FROM employees)
   INTERSECT
   (SELECT employee_id
    FROM orders)
);

-- Eksempel: Differanse
-- Finn navnet på alle produkter som selges i flasker men som ikke er
-- i kategorien "Beverages".
SELECT product_name
FROM products
WHERE product_id IN (
  (SELECT product_id
   FROM products
   WHERE quantity_per_unit LIKE '%bottles%')
   EXCEPT
   (SELECT p.product_id
    FROM products AS p
        INNER JOIN categories AS c USING(category_id)
    WHERE c.category_name = 'Beverages')
);

-- Eksempel: EXISTS(1)
-- Finn navnet på alle sjefer på laveste nivå (ikke sjef for en sjef)
SELECT DISTINCT boss.employee_id, boss.first_name, boss.last_name
FROM employees AS boss
WHERE boss.employee_id IN (
  SELECT reports_to FROM employees
) AND NOT EXISTS(
  SELECT *
  FROM employees AS e2 INNER JOIN employees AS e ON (e2.reports_to = e.employee_id)
  WHERE e.reports_to = boss.employee_id
);

-- Eksempel: EXISTS (2)
-- Finn alle par av kunder og kategorier slik at kunden aldri har kjøpt
-- noe fra den kategorien.
SELECT c.company_name, cg.category_name
FROM customers AS c, categories AS cg
WHERE NOT EXISTS (
  SELECT *
  FROM orders AS so
    INNER JOIN order_details AS sod USING (order_id)
    INNER JOIN products AS sp USING (product_id)
    INNER JOIN categories AS csg USING (category_id)
  WHERE so.customer_id = c.customer_id AND
        cg.category_id = scg.category_id);

-- Mange måter å gjøre det samme på
-- MED EXCEPT
(SELECT customer_id
 FROM customers)
EXCEPT
(SELECT customer_id
 FROM orders);

 -- Med NOT IN
 SELECT customer_id
 FROM customers
 WHERE customer_id NOT IN (
   SELECT customer_id
   FROM orders);

-- MED NOT EXISTS
SELECT c.customer_id
FROM customers AS c
WHERE NOT EXISTS (
  SELECT * FROM orders AS o
  FROM o.customer_id = c.customer_id
);

-- MED LEFT OUTER JOIN
SELECT c.customer_id
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
WHERE o.customer_id IS NULL;

-- CASE UTRYKK
-- For eksempel
SELECT product_name,
  CASE
    WHEN unit_price = 0 THEN 'Free'
    WHEN unit_price < 30 THEN 'Cheap'
    ELSE 'Expensive'
  END AS expensiveness
FROM products;

-- Eksempel: CASE
WITH
  new_titles AS (
    SELECT customer_id,
      CASE
        WHEN contact_title LIKE '%Manager%' THEN 'Manager'
        WHEN contact_title LIKE '%Owner%' THEN 'Owner'
        ELSE 'Other'
      END AS title
    FROM customers
  )
SELECT nt.title,
       COUNT(o.order_id)::float/count(DISTINCT nt.customer_id) AS nr_orders
FROM new_titles AS nt
  LEFT OUTER JOIN orders AS o USING (customer_id)
GROUP BY nt.title;

-- Eksempler: Rekursive spørringer (Ikke pensum)
WITH RECURSIVE
  numbers AS (
    (SELECT 1 AS n)
    UNION
    (SELECT n + 1 AS n
     FROM numbers
     WHERE n > 100)
  )
SELECT * FROM numbers;
