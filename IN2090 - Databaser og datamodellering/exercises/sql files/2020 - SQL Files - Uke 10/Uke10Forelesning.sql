-- 10. Outer joins
-- Repetisjon: Inner joins
-- Hvilken kunde har kjøpt hvilket produkt?
SELECT ProductName, Customer
FROM products AS p
  INNER JOIN orders AS o ON p.ProductID = o.ProductID;

-- Inner joins og manglende verdier med aggregater
-- Hvor mange har kjøpt hvert produkt?
SELECT ProductName, count(o.Customer) AS num
FROM products AS p
  INNER JOIN orders AS o ON p.ProductID = o.ProductID
GROUP BY p.ProductID;

-- Eksempel: Left Outer Join
-- Left outer join mellom products og orders
SELECT *
FROM products AS p
  LEFT OUTER JOIN orders AS o ON p.ProductID = o.ProductID;

-- Andre nyttige bruksområder for ytre joins
-- For eksempel:
SELECT p.Name. n.Phone. e.Email
FROM Persons AS p
  LEFT OUTER JOIN Numbers AS n ON (p.ID = n.ID)
  LEFT OUTER JOIN Emails AS e ON (p.ID = e.ID);

-- Ytre join-eksempel (1)
-- Finn antall bestillinger gjort av hver kunde
SELECT c.company_name, COUNT(o.order_id) AS num_orders
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
GROUP BY c.customer_id;


-- Ytre join-eksempel (2)
-- Finn ut hvor mye penger hver kunde har bestilt, for de som har færre enn 5
-- bestillinger
SELECT c.company_name,
       SUM(d.unit_price * d.quantity) AS sum_money
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
  LEFT OUTER JOIN order_details AS d USING (order_id)
GROUP BY c.customer_id
  HAVING COUNT(DISTINCT o.order_id) < 5;


-- Ytre join-eksempel (3)
-- Finn ut hvor mye penger hver kunde har bestilt, for de som har færre
-- enn 100 produkter totalt
SELECT c.company_name,
       SUM(d.unit_price * d.quantity) AS sum_money
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
  LEFT OUTER JOIN order_details AS d USING (order_id)
GROUP BY c.customer_id
HAVING SUM(d.quantity) < 100 OR SUM(d.quantity) IS NULL;

-- ytre join-eksempel (4)
-- Finn ut antall ganger hver ansatt har håndtert en ordre fra hver kunde
SELECT e.first_name, c.company_name, COUNT(o.order_id) antallBestillinger
FROM orders AS o
  LEFT OUTER JOIN employees AS e USING (employee_id)
  LEFT OUTER JOIN customers AS c USING (customer_id)
GROUP BY o.employee_id, o.customer_id, e.first_name, c.company_name;

-- Løsning
WITH
  all_combinations AS (
    SELECT e.employee_id,
           format('%s %s', e.first_name, e.last_name) AS fullname,
           c.customer_id,
           c.company_name
    FROM employees  AS e, customers AS c -- Kryssproduktet, alle kombinasjoner
  )
SELECT ac.fullname,
       ac.company_name,
       COUNT(o.order_id) AS num_transactions
FROM all_combinations AS ac
  LEFT OUTER JOIN orders AS o
  ON (ac.employee_id = o.employee_id AND
      ac.customer_id = o.customer_id)
GROUP BY ac.customer_id, ac.company_name,
         ac.employee_id, ac.fullname;


-- Ytre joins-eksempel (5)
-- Finn navnet på alle kunder som ikke har bestilt noe
SELECT c.company_name
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
WHERE o.customer_id IS NULL;

-- Eksempel: Union
-- Finn navn på alle produkter som enten kommer fra eller solgt til Norge
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
SELECT first_name, last_name
FROM employees
WHERE employee_id IN (
  (SELECT reportst_to
   FROM employees)
   INTERSECT
   (SELECT employee_id
   FROM orders)
);


-- Eksempel: Differanse
-- Finn navnet på alle produkter som selges i flasker men som ikke er i
-- kategorien beverages.
SELECT product_name
FROM products
WHERE product_id IN (
  (SELECT product_id
   FROM products
   WHERE quantity_per_unit LIKE '%bottles%')
   EXCEPT
   (SELECT p.product_id
    FROM products AS p
      INNER JOIN categories AS c
    USING (category_id)
    WHERE c.category_name = 'Beverages')
);

-- Eksempel: EXISTS (1)
-- Finn navnet til alle sjefer på laveste nivå (ikke sjef for en sjef)
SELECT DISTINCT boss.employee_id, boss.first_name, boss.last_name
FROM employees AS boss
WHERE boss.employee_id IN
  (SELECT reportst_to FROM employees) AND NOT EXISTS (
   SELECT *
   FROM employees AS e2
    INNER JOIN employees AS e on (e2.reportst_to = e.employee_id)
    WHERE e.reportst_to = boss.employee_id
  );

-- Eksempel: EXISTS (2)
-- Finn alle par av kunder og kategorier slik at kunden aldri har kjøpt noe
-- fra den kategorien.
SELECT c.company_name, cg.category_name
FROM customers AS c, categories AS cg
WHERE NOT EXISTS (
  SELECT *
  FROM orders AS so
    INNER JOIN order_details AS sod USING (order_id)
    INNER JOIN products AS sp USING (product_id)
    INNER JOIN categories AS scg USING (category_id)
  WHERE so.customer_id = c.customer_id AND
        cg.category_id = scg.category_id
);

-- Mange måter å gjøre det samme på
-- Finn ID på alle kunder som ikke har bestilt noe:
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
  FROM orders
);

-- Med NOT EXISTS
SELECT c.customer_id
FROM customers AS c
WHERE NOT EXISTS (
  SELECT *
  FROM orders AS o
  WHERE o.customer_id = c.customer_id
);

-- Med LEFT OUTER JOIN
SELECT c.customer_id
FROM customers AS c
  LEFT OUTER JOIN orders AS o USING (customer_id)
WHERE o.customer_id IS NULL;


-- CASE-uttrykk
SELECT product_name,
  CASE
    WHEN unit_price = 0 THEN 'FREE'
    WHEN unit_price < 30 THEN 'CHEAP'
    ELSE 'EXPENSIVE'
  END AS expensiveness
FROM products;

-- Eksempel: CASE
-- Finn ut hvor mange bestillinger i gjennomsnutt personenen i de tre
-- kategoriene "sjefer", "eiere" og "andre" har behandlet
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
