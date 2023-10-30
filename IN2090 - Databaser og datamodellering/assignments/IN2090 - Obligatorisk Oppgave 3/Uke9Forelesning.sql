-- 09- 01- Sortering --
-- For eksempel, for å sortere alle produkter etter pris:
SELECT product_name, unit_price
FROM products
ORDER BY unit_price;

-- Sortere på flere kolonner og reversering --
-- For eksempel, for å sortere drikkevarer først på pris, og så på antall på
-- lager, begge i nedadgående rekkefølge:
SELECT product_name, unit_price, units_in_stock
FROM products
ORDER BY unit_price DESC,
         units_in_stock DESC;

-- Begrense antall rader i resultatet
-- For eksempel, for å velge ut de dyreste 5 produktene: --
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 5;

-- Eksempel: Finn navn og pris på produktet med lavest pris
-- Ved min-aggregering og tabell-delspørring
SELECT p.product_name, p.unit_price
FROM products AS p
  INNER JOIN (SELECT min(unit_price) AS minprice FROM products) AS h
  ON p.unit_price = h.minprice;

-- Ved min-aggregering og verdi-delspørring
SELECT product_name, unit_price
FROM products
WHERE unit_price = (SELECT min(unit_price) FROM products);

-- ved ORDER BY og LIMIT 1
SELECT product_name, unit_price
FROM products
ORDER BY unit_price
LIMIT 1;

-- Hoppe over rader
-- Dersom vi ønsker å vise 10 og 10 producter av gangen, sortert etter pris,
-- kan man kjøre:
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 10
OFFSET <sidetall * 10>; -- Først 0, så 10, så 20, osv..



--------------------------------------------------------------------------------
-- 09.02 aggregering i grupper --
-- Aggregere i grupper: Eksempel
-- Finn gjennomsnittsprisen for hver kategori
SELECT category, AVG(Price) AS AveragePrice
FROM products
GROUP BY category;

-- Aggregering i grupper: Eksempel 1
-- Finn antall produkter per bestilling
SELECT order_id, SUM(quantity) AS nr_products
FROM order_details
GROUP BY order_id;


-- Aggregering i grupper: Eksempel 2
-- Finn gjennomsnittsprisen for hver kategori
SELECT c.category_name, AVG(unit_price)
FROM products AS p
  INNER JOIN categories AS c USING (category_id)
GROUP BY p.category_id, c.category_name;

SELECT c.category_name, avg(unit_price) AS Averageprice
FROM categories AS c
  INNER JOIN products AS p ON (c.category_id = p.category_id)
GROUP BY c.category_name;

-- Gruppere på flere kolonner
-- Finn antall produkter for hver kombinasjon av kategori og hvorvidt produktet
-- fortsatt selges
SELECT c.category_name, p.discontinued, COUNT(*) AS nr_products
FROM categories AS c
  INNER JOIN products AS p ON (c.category_id = p.category_id)
GROUP BY c.category_name, p.discontinued;


-- Aggregering i grupper: Eksempel 3
-- Finn navn på ansatte og antall bestillinger den ansatte har håndtert, sortert
-- etter antall bestillinger fra høyest til lavest
SELECT e.first_name, e.last_name, COUNT(*) AS bestillinger
FROM orders AS o
  INNER JOIN employees AS e USING (employee_id)
GROUP BY o.employee_id, e.first_name, e.last_name
ORDER BY count(*) DESC;

-- eller

SELECT format('%s %s', e.first_name, e.last_name) AS emp_name,
       COUNT(*) AS num_orders
FROM orders AS o
  INNER JOIN employees AS e ON (o.employee_id = e.employee_id)
GROUP BY e.first_name, e.last_name
ORDER BY num_orders DESC;

-- Filtrere på aggregatet-resultat
-- F.eks dersom man vil vite kategorinavn og antall produkter på de kategoriene
-- som har flere enn enn 10 proodukter.

SELECT category_name, nr_products
FROM (
  SELECT c.category_name, COUNT(*) AS nr_products
  FROM categories AS c
    INNER JOIN products AS p ON (c.category_id = p.category_id)
    GROUP BY c.category_name) AS t
WHERE nr_products > 10;


--------------------------------------------------------------------------------

-- 09.03. Avanserte eksempler
-- Eksempel: Variable i delspørringer
-- Finn navnet på alle produkter som har lavere pris nå enn gjennomsnittsprisen
-- den er soldt for tidligere.

-- Min løsning
SELECT p.product_name
FROM (SELECT product_id, avg(unit_price) AS gjennomsnitt
      FROM order_details
      GROUP BY product_id
      ORDER BY avg(unit_price) DESC) AS t
INNER JOIN products AS p USING (product_id)
WHERE p.unit_price < gjennomsnitt;

-- Annen løsning
-- Merk: Man kan bruke variabler fra en spørring i dens delspørringer
SELECT p.product_name
FROM products AS p
WHERE p.unit_price < (SELECT avg(unit_price)
                      FROM order_details AS d
                      WHERE d.product_id = p.product_id);
-- Eller
SELECT p.product_name
FROM products AS p
  INNER JOIN (SELECT product_id, avg(unit_price) AS avg_price
              FROM order_details
              GROUP BY product_id) AS a USING (product_id)
WHERE p.unit_price < a.avg_price;


-- Eksempel: Variable i delspørringer (2)
-- Finn antall producter for hver kategori.
SELECT c.category_name, COUNT(*) AS antallProdukter
FROM products AS p
  INNER JOIN categories AS c USING (category_id)
GROUP BY p.category_id, c.category_name
ORDER BY count(*) ASC;

-- Første løsning
SELECT c.category_name, COUNT(*) AS nr_products
FROM categories AS c
  INNER JOIN products AS p USING (category_id)
GROUP BY c.category_name;

-- Løsning med delspørringer
SELECT c.category_name,
       (SELECT COUNT(*)
        FROM products AS p
        WHERE p.category_id = c.category_id) AS nr_products
FROM categories AS c;


-- utlede informasjon om entiteter
-- - Aggregering i grupper, sortering og å begrense svaret er svært nyttig
--   når man har store mengde data.
-- - Når vi grupperer kan vi enten utlede implisitt informasjon om allerede
--   eksisterende entiteter.
-- - Eller lage ny entiteter fra attributter.
-- - Sortering og begrensning lar oss hente ut de mest interssante objektene.
-- - Dette gjør også at vi kan lage langt mer interessante views

-- Eksempel 1: Implisitt informasjon om kategorier.
-- For hver kategori, finn høyeste, laveste, og gjennomsnittsprisen på
-- produktene i kategorien, samt antall produkter.

SELECT c.category_name,
       MAX(p.unit_price) AS høyeste,
       AVG(p.unit_price) AS gjennomsnitt,
       MIN(p.unit_price) AS laveste,
       COUNT(*) AS antallProdukter
FROM products AS p
  INNER JOIN categories AS c USING (category_id)
GROUP BY p.category_id, c.category_name;

-- Løsning

SELECT c.category_id, c.category_name,
       max(p.unit_price) AS highest,
       min(p.unit_price) AS lowest,
       avg(p.unit_price) AS average,
       COUNT(*) AS nr_products
FROM categories AS c
  INNER JOIN products AS p USING (category_id)
GROUP BY c.category_id, c.category_name;

-- Eksempel 2: Implisitt informasjon om land
-- Finn de tre mest kjøpte produktene for hvert land.
WITH
  bought_by_country AS (
    SELECT c.country, p.product_name, count(*) AS nr_bought
    FROM customers AS c
      INNER JOIN orders AS o USING (customer_id)
      INNER JOIN order_details AS d USING (order_id)
      INNER JOIN products AS p USING (product_id)
    GROUP BY c.country, p.product_name
  ),
  countries AS (
    SELECT DISTINCT country FROM customers
  )
SELECT country, (SELECT b.product_name
                 FROM bought_by_country AS b
                 WHERE c.country = b.country
                 ORDER BY nr_bought DESC
                 LIMIT 1) AS firstplace,

                 (SELECT b.product_name
                  FROM bought_by_country AS b
                  WHERE c.country = b.country
                  ORDER BY nr_bought DESC
                  LIMIT 1
                  OFFSET 1) AS secondplace,

                  (SELECT b.product_name
                   FROM bought_by_country AS b
                   WHERE c.country = b.country
                   ORDER BY nr_bought DESC
                   LIMIT 1
                   OFFSET 2) AS thirdplace
FROM countries AS c;


-- Anbefalingssystem (Komplisert eksempel! Utenfor pensum!)
-- Vi vil lage en spørring som finner ut:
--    hvilke produkter vi kan anbefale en kunde å kjøpe
--    basert på hva kunden har kjøpt
--    og hva andre kunder som har kjøpt det samme har kjøpt.

-- boug vil gi oss muligheten til å se hvilke kunder som har kjøpt hva
WITH
  bought AS (-- Relaterer kunde ID-er til produkt-IDene til de de har kjøpt
    SELECT DISTINCT c.customer_id, d.product_id
    FROM customers AS c
      INNER JOIN orders USING (customer_id)
      INNER JOIN order_details AS d USING (order_id)
  ),
  -- Relaterer  par av produkter til antallet ganger disse er kjøpt av samme kunde
  correspondences AS (
    SELECT b1.product_id AS prod1, b2.product_id AS prod2, COUNT(*) AS correspondence
    FROM bought AS b1
      INNER JOIN bought AS b2 USING (customer_id)
      WHERE b1.product_id != b2.product_id -- Fjern par hvor produktene er like
      GROUP BY b1.product_id, b2.product_id --  Grupper på par av produkter
      HAVING COUNT(*) > 18 -- Antall korrespondanser bør være litt høyt
  ),
  recommend AS (-- Relaterer kunde ID-er til anbefalte produkters ID-er
  SELECT DISTINCT b.customer_id, c.prod2 AS produkt_id -- Vil ikke ha duplikater
  FROM correspondences AS c
    INNER JOIN bought AS b ON (b.product_id = c.prod1)
  WHERE NOT c.prod2 IN (SELECT product_id
                        FROM bought AS bi
                        WHERE b.customer_id = bi.customer_id))
-- Til slutt finn navn på både kunde og produkt og aggregerer produktnavnene
-- for hver kunde i ett array med aggragatfunksjonen array_agg
SELECT c.company_name, array_agg(p.product_name) AS recommended_products
FROM customers AS c
  INNER JOIN recommend AS r USING (customer_id)
  INNER JOIN products AS p USING (product_id)
GROUP BY (c.customer_id, c.company_name);


WITH
bought AS ( -- Relaterer kunde-IDer til produkt-IDene til det de har kjøpt
SELECT DISTINCT c.customer_id, d.product_id -- Vil ikke ha duplikater! FROM customers AS c
INNER JOIN orders USING (customer_id)
INNER JOIN order_details AS d USING (order_id) ),
correspondences AS ( -- Relaterer par av produkter til antallet ganger disse er kjøpt av samme kunde SELECT b1.product_id AS prod1, b2.product_id AS prod2, count(*) AS correspondence
FROM bought AS b1
INNER JOIN bought b2 USING (customer_id)
WHERE b1.product_id != b2.product_id -- Fjern par hvor produktene er like GROUP BY b1.product_id, b2.product_id -- Gruppér på par av produkter HAVING count(*) > 18 -- Antall korrespondanser bør være litt høyt
),
reccomend AS ( -- Relaterer kunde-IDer til anbefalte produkters IDer
SELECT DISTINCT b.customer_id, c.prod2 AS product_id -- Vil ikke ha duplikater! FROM correspondences AS c
INNER JOIN bought AS b
ON (b.product_id = c.prod1)
WHERE NOT c.prod2 IN -- Fjern produkter som kunden allerede har kjøpt
 )
(SELECT product_id
FROM bought AS bi
WHERE b.customer_id = bi.customer_id)
-- Til slutt finn navn på både kunde og produkt og aggreger produktnavnene -- for hver kunde i ett array med aggregatfunksjonen array_agg
SELECT c.company_name, array_agg(p.product_name) AS reccomended_products FROM customers AS c INNER JOIN reccomend AS r USING (customer_id)
INNER JOIN products AS p USING (product_id) GROUP BY c.customer_id, c.company_name;
