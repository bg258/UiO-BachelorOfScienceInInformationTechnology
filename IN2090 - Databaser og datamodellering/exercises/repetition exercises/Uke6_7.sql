-- Uke 6 --
-- Spørring som finner navnene på alle par av kunder og leverandører som er
-- i samme by. (14 rader)

SELECT c.company_name, s.company_name
FROM customers As c,
     suppliers AS s
WHERE c.city = s.city;

-- Finn alle unike par av (fulle) navn på kunde og ansatte som har inngått en
-- handel med last (eng: freight) over 500 kg (13 rader)

SELECT c.company_name,
       e.first_name || ' ' || e.last_name
FROM customers c, employees e, orders o
WHERE o.customer_id = c.customer_id AND
      e.employee_id = o.employee_id AND
      o.freight > 500;

-- Finn ut hvilke drikkevarer som er kjøpt og av hvem

SELECT p.product_name, cs.company_name
FROM orders AS o
  INNER JOIN order_details AS od USING (order_id)
  INNER JOIN customers AS cs ON (o.customer_id = cs.customer_id)
  INNER JOIN products AS p ON (od.product_id = p.product_id)
  INNER JOIN categories AS c ON (p.category_id = c.category_id)
WHERE c.category_name = 'Beverages';

-- Finn navn og pris på alle produkter som er dyrere enn produktet
-- Laptop 2.5GHz?
SELECT P2.Name, P2.Price
FROM Product AS P1,
     Product AS P2,
WHERE P1.Name = 'Laptop 2.5GHz' AND
      P1.Price < P2.Price;

-- Spørring som finner "høflighets-tittel" og jobbtittel på alle sjefer
SELECT employee_id, title_of_courtesy, title, first_name, last_name
FROM employees
WHERE employee_id IN (
  SELECT reports_to
  FROM employees
);

-- Eller

SELECT DISTINCT e2.title_of_courtesy, e2.title
FROM employees AS e1 INNER JOIN employees AS e2
ON (e1.reports_to = e2.employee_id);

-- Finn navnet på alle drikkevarer
SELECT product_name
FROM products
  NATURAL JOIN categories
WHERE category_name = 'Beverages';


-- Følgende spørring finner antall solgte drikkevarer med delspørring
SELECT sum(d.quantity)
FROM (SELECT p.product_id
      FROM products AS p
        INNER JOIN categories AS c ON (p.category_id = c.category_id)
      WHERE c.category_name = 'Beverages') AS beverages
      INNER JOIN order_details AS d ON (beverages.product_id = d.product_id);

-- Eksempel: Finn navn og pris på produktet med lavest pris
SELECT p.product_name, p.unit_price
FROM (
  SELECT MIN(unit_price) AS minprice
  FROM products
) AS h
  INNER JOIN products AS p ON (p.unit_price = h.minprice);

-- eller

SELECT product_name
FROM products AS p
WHERE unit_price = (SELECT MIN(unit_price) FROM products);


-- Hva er den største differansen mellom prisen på laptopper?
WITH
  laptops AS (SELECT Price FROM products WHERE name LIKE '%Laptop%')
SELECT max(l1.Price - 12.Price) AS diff
FROM laptops AS l1, laptops AS l2

-- Finn kundenavn og produktnavn på alle kunder som har bestilt en drikkevare
-- som ikke lenger selges ("discontinued") [230 rader]

SELECT count(c.company_name)
FROM orders AS o
  INNER JOIN order_details AS od USING (order_id)
  INNER JOIN products AS p ON (od.product_id = p.product_id)
  INNER JOIN customers AS c ON (o.customer_id = c.customer_id)
  INNER JOIN categories AS cat ON (p.category_id = cat.category_id)
WHERE p.discontinued = 1 AND
      cat.category_name = 'Beverages';

SELECT COUNT(c.company_name)
FROM products AS p
  INNER JOIN order_details AS d ON (p.product_id = d.product_id)
  INNER JOIN orders AS o ON (o.order_id = d.order_id)
  INNER JOIN customers AS c ON (c.customer_id = o.customer_id)
  INNER JOIN categories AS g ON (g.category_id = p.category_id)
WHERE p.discontinued = 1 AND
      g.category_name = 'Beverages';

-- Finn navnet på alle drikkevarer som aldri har blitt solgt for lavere enn
-- gjennomsnittsprise for alle salg.


SELECT p.product_name
FROM products AS p INNER JOIN categories AS c
  ON (p.category_id = c.category_id)
WHERE c.category_name = 'Beverages' AND
  (SELECT avg(unit_price)
   FROM order_details) <
  (SELECT min(d.unit_price)
   FROM order_details AS d
   WHERE p.product_id = d.product_id);


-- Komplisert eksempel med WITH
-- Finn kundenavn og productnavn på alle kunder som har bestilt en drikkevare
-- som ikke lenger selges ("discontinued")

WITH
  beverages AS (
    SELECT p.product_id, p.product_name
    FROM products AS p
      INNER JOIN categories AS c
      ON (p.category_id = c.category_id)
    WHERE c.category_name = 'Beverages' AND
          p.discontinued = 1
  ),
  company_orders AS (
    SELECT u.company_name, d.product_id
    FROM customers AS u
      INNER JOIN orders AS o ON (u.customer_id = o.company_id)
      INNER JOIN order_details AS d (o.order_id = d.order_id)
  )
SELECT DISTINCT c.company_name, p.product_name
FROM beverages AS b INNER JOIN company_orders AS o
  ON (b.product_id = o.product_id);


-- Finn antall produkter som har en pris større eller lik 100 og alle som har
-- en pris mindre enn 100.

SELECT (SELECT COUNT(*)
        FROM products
        WHERE unit_price <= 100) AS cheap,
       (SELECT COUNT(*)
        FROM products
        WHERE unit_price > 100) AS expensive;


-- Uke 7
-- CREATE-eksempel
CREATE TABLE Student (
  SID int,
  StdName text,
  StdBirthdate date
);

-- Skranker: NOT NULL
CREATE TABLE Student(
  SID int,
  StdName text NOT NULL,
  StdBirthdate date
);

-- Skranker: UNIQUE
CREATE TABLE Student(
  SID int UNIQUE,
  StdName text NOT NULL,
  StdBirthdate date
);

-- Skranker: PRIMARY KEY
CREATE TABLE Student(
  SID int UNIQUE NOT NULL,
  StdName text NOT NULL,
  StdBirthdate date
);

-- er det samme som
CREATE TABLE Student(
  SID int PRIMARY KEY,
  StdName text NOT NULL,
  StdBirthdate date
);

-- ALTERNATIV SYNTAKS FOR SKRANKER
CREATE TABLE Student(
  SID int,
  StdName text NOT NULL,
  StdBirthdate DATE,
  CONSTRAINT sid_pk PRIMARY KEY (SID)
);

-- Denne syntaksen er nødvendig om vi ønsker å ha skranker over flere kolonner
-- F.eks. om kombinasjonen av StdName og StdBirthdate alltid er unik:

CREATE TABLE Student(
  SID int,
  StdName text NOT NULL,
  StdBirthdate date,
  CONSTRAINT sid_pk PRIMARY KEY (SID),
  CONSTRAINT name_bd_un UNIQUE (StdName, StdBirthdate)
);

-- Skranker: REFERENCES
CREATE TABLE TakesCourse(
  SID int REFERENCES Student(SID),
  CID int REFERENCES Course(CID),
  Semester text
);

-- Sette inn data
INSERT INTO Students
VALUES (0, 'Anna Consuma', '1978-10-09'),
       (1, 'Peter Younf', '2009-03-01');

-- Andre måter å sette inn data
CREATE TABLE Students2018 (
  SID int PRIMARY KEY,
  StdName text NOT NULL
);

INSERT INTO Students2018
SELECT S.SID, S.StdName
FROM Students AS s
  INNER JOIN TakesCourse AS T
WHERE T.Semester LIKE '%18';

-- Ny tabell basert på SELECT direkte
CREATE TABLE Students2018 AS
SELECT S.SID, S.StdName
FROM Students AS s
  INNER JOIN TakesCourse AS T
    ON (S.SID = T.SID)
WHERE T.Semester LIKE '%18';

-- Default-verdier
CREATE TABLE personer(
  pid int PRIMARY KEY,
  navn text NOT NULL,
  nationalitet TEXT DEFAULT 'norge'
);

-- SERIAL
CREATE TABLE Student(
  SID SERIAL PRIMARY KEY,
  StdName text NOT NULL,
  StdBirthdate date
);

-- DATA
-- Følgende laster inn innholdet fra CSVen ~/documents/people.csv (med
-- separator ',' og null-verdi ' ') inn i tabellen Persons

COPY persons
FROM '~/documents/people.csv' DELIMITER ',' NULL AS '';

-- $ cat persons.csv | psql <flag> -c
-- FROM '~/documents/people.csv' DELIMITER ',' NULL AS '';

-- SLETTE DATA
DELETE
FROM Students
WHERE StdBirthdate > '1990-01-01';

-- Oppdatere ting
ALTER TABLE Students
RENAME TO UIOStudents;

-- ELLER
ALTER TABLE Courses
ADD COLUMN Teacher text;

-- LEGGE TIL SKRANKER I ETTERTID
ALTER TABLE courses
ADD CONSTRAINT CID_PK PRIMARY KEY (cid);

-- OPPDATERE DATA
UPDATE Students
SET StdBirthdate = '1987-10-03'
WHERE StdName = 'Sam Penny'

--ELLER
UPDATE northwind.products
SET price = price * 1.1
WHERE quantityperunit LIKE '%bottles%';

---- VIEWS ----
-- Merk at vi nesten aldri er interessert i dataene slik de er lagret.
-- Et view er egentlig bare en navngitt spørring og lages slik

CREATE VIEW StudentTakesCourse (StdName text, CourseName text)
AS
  SELECT S.StdName, C.CourseName
  FROM students AS s,
       courses AS c,
       TakesCourse as t
  WHERE s.SID = t.SID AND c.CID = t.CID;

-- views for utledbare verdier
CREATE VIEW person_alder AS
SELECT navn,
       fødselsdato,
       EXTRACT (year FROM age(current_date, fødselsdato)) AS alder
FROM person;

-- MATERIALISERTE VIEWS
-- Dersom et view brukes veldig ofte kan det lønne seg å materialisere det.
CREATE MATERIALIZED VIEW person_alder AS
SELECT navn,
       fødselsdato,
       EXTRACT (year FROM age(current_date, fødselsdato)) AS alder
FROM person;

-- Men, den kan enkelt oppdateres når de tabellene den avhenger av oppdateres
-- Dette skjer derimot ikke automatisk, man må kjøre følgende for å oppdatere det:
REFRESH MATERIALIZED VIEW person_alder;


-- SQL SCRIPTS
CREATE TABLE IF NOT EXISTS persons(name text, born date);
CREATE TABLE persons(name text, born date);

\echo 'This is a message'

-- Transaksjoner - Syntaks
BEGIN;
UPDATE balances
SET balance = balance - 100
WHERE ID = 1;

UPDATE balances
SET balance = balance + 100
WHERE ID = 100;

COMMIT;
