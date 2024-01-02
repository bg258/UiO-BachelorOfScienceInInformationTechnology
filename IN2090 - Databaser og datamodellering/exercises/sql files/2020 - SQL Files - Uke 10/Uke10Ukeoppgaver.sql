-- Uke 10: Ytre joins og mengdeoperatorer
-- Bruk filmdatabasen for å løse følgende oppgaver:

-- Oppgave 1
-- Finn ut hvor mange produksjoner (altså alt som forekommer i filmparticipation
-- tabellen ) hver person med etternavn "Abbott" har deltatt I (Husk å få med de
-- som har deltatt i 0 filmer). (243 rader)

SELECT format('%s %s', p.lastname, p.firstname),
       COUNT(fp.personid) AS produksjoner
FROM person AS p
  LEFT OUTER JOIN filmparticipation AS fp USING (personid)
WHERE p.lastname = 'Abbott'
GROUP BY fp.personid, p.lastname, p.firstname;

-- Løsningsforslag
SELECT p.personid, p.firstname, p.lastname, COUNT(fp.personid) AS count
FROM person AS p
  LEFT OUTER JOIN filmparticipation AS fp USING (personid)
WHERE p.lastname = 'Abbott'
GROUP BY p.personid, p.firstname, p.lastname;

-- Oppgave 2
-- Finn tittel på alle Western-filmer laget etter 2007 som ikke har en rating.
-- (14 rader). Løs oppgaven på ved å bruke:
-- a) NOT IN
-- c) EXCEPT
-- b) LEFT OUTER JOIN
-- d) NOT EXISTS


-- a) NOT IN
SELECT f.title
FROM film AS f
  INNER JOIN filmgenre AS g USING (filmid)
WHERE f.filmid NOT IN (SELECT filmid FROM filmrating) AND
      g.genre = 'Western' AND
      f.prodyear > 2007;

-- b) LEFT OUTER JOIN
SELECT f.title
FROM film AS f
  INNER JOIN filmgenre AS g USING (filmid)
  LEFT OUTER JOIN filmrating AS r USING (filmid)
WHERE g.genre = 'Western' AND
      f.prodyear > 2007 AND
      r.rank IS NULL;
-- Løsning

SELECT f.title
FROM film AS f
  INNER JOIN filmgenre AS g USING (filmid)
  LEFT OUTER JOIN filmrating AS r USING (filmid)
WHERE r.filmid IS NULL AND
      g.genre = 'Western' AND
      f.prodyear > 2007;

-- c) EXCEPT
SELECT title
FROM film
WHERE prodyear > 2007 AND
      filmid IN (
        (SELECT filmid
         FROM filmgenre
         WHERE genre = 'Western')
        EXCEPT
        (SELECT filmid
         FROM filmrating)
      );

-- D) NOT EXISTS
SELECT f.title
FROM film AS f
  INNER JOIN filmgenre AS fg USING (filmid)
WHERE f.prodyear > 2007 AND
      fg.genre = 'Western' AND
      NOT EXISTS (
        SELECT *
        FROM filmrating AS r
        WHERE r.filmid = f.filmid
      );

-- Oppgave 3
-- Finn antall filmer som enten er komedier, eller som Jim Carrey har spilt i (1 rad)


SELECT COUNT(filmid)
FROM film
WHERE filmid IN (
  (SELECT f.filmid
  FROM filmparticipation as fp
    INNER JOIN film AS f USING (filmid)
    INNER JOIN person AS p USING (personid)
  WHERE p.firstname = 'Jim' AND p.lastname = 'Carrey')
  UNION
  (SELECT f.filmid
   FROM film AS f
      INNER JOIN filmgenre AS g USING (filmid)
   WHERE g.genre = 'Comedy')
);

-- Løsning

SELECT COUNT(DISTINCT filmid) AS nr_movies
FROM film AS f
WHERE filmid IN (
  (SELECT filmid
   FROM filmgenre
   WHERE genre = 'Comedy')
   UNION
   (SELECT fp.filmid
    FROM person AS p
      INNER JOIN filmparticipation AS fp USING (personid)
    WHERE p.firstname = 'Jim' AND p.lastname = 'Carrey')
);

-- eller

SELECT COUNT(*) AS nr_movies
FROM (SELECT DISTINCT filmid
      FROM film
      WHERE filmid IN (
        (SELECT filmid
         FROM filmgenre
         WHERE genre =  'Comedy')
        UNION
        (SELECT fp.filmid
         FROM person AS p
            INNER JOIN filmparticipation AS fp USING (personid)
         WHERE p.firstname = 'Jim' AND p.lastname = 'Carrey'))) AS t;

-- Oppgave 4
-- Finn tittel på alle filmer som som Kim Carrey har spilt i, men som ikke er
-- komedier

SELECT title
FROM film
WHERE filmid IN (
  (SELECT f.filmid
   FROM filmparticipation AS fp
      INNER JOIN film AS f USING (filmid)
      INNER JOIN person AS p USING (personid)
   WHERE p.firstname = 'Jim' AND p.lastname = 'Carrey')
   EXCEPT
   (SELECT f.filmid
    FROM film AS f
      INNER JOIN filmgenre AS g USING (filmid)
    WHERE g.genre = 'Comedy')
);


SELECT title
FROM film
WHERE filmid IN (
  (SELECT fp.filmid
   FROM person AS p
      INNER JOIN filmparticipation AS fp USING (personid)
   WHERE p.firstname = 'Jim' AND p.lastname = 'Carrey')
  EXCEPT
  (SELECT filmid
   FROM filmgenre
   WHERE genre = 'Comedy'));

-- eller

SELECT f.title
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p USING (personid)
WHERE p.firstname = 'Jim' AND
      p.lastname = 'Carrey' AND
      f.filmid NOT IN (SELECT filmid
                       FROM filmgenre
                       WHERE genre = 'Comedy');

-------------------------------------------------------------------------------
-- Bruk Northwind -databasen for å løse følgende oppgaver:
-- Oppgave 5
-- Finn navnet på alle firmaer (Customers og suppliers) som kommer fra Norge
-- eller Sverige. (6 rader)

(SELECT company_name
 FROM customers
 WHERE country = 'Norway' OR country = 'Sweden')
UNION
(SELECT s.company_name
 FROM shippers AS s
    INNER JOIN orders AS o ON (s.shipper_id = o.ship_via)
 WHERE o.ship_country = 'Norway' OR o.ship_country = 'Sweden');

 -- Løsning

(SELECT company_name
 FROM customers
 WHERE country = 'Sweden' OR
       country = 'Norway')
UNION

(SELECT company_name
 FROM suppliers
 WHERE country = 'Norway' OR
       country = 'Sweden');

-- Oppgave 6
-- Bruke EXISTS for å finne navnet på alle kunder som har kjøpt Pavlova. (31 rader)
SELECT c.company_name
FROM customers AS c
WHERE EXISTS (
  SELECT DISTINCT c.customer_id
  FROM customers AS c1
    INNER JOIN orders AS o USING (customer_id)
    INNER JOIN order_details AS d USING (order_id)
  WHERE d.product_id IN (
    SELECT product_id
    FROM products
    WHERE product_name = 'Pavlova'
  ) AND c.customer_id = o.customer_id
);

-- eller

SELECT DISTINCT c.company_name
FROM customers AS c
  INNER JOIN orders AS o USING (customer_id)
  INNER JOIN order_details AS d USING (order_id)
WHERE d.product_id IN (
  SELECT product_id
  FROM products
  WHERE product_name = 'Pavlova'
);

-- Løsning

SELECT c.company_name
FROM customers AS c
WHERE EXISTS (
  SELECT *
  FROM orders AS o
    INNER JOIN order_details AS d USING (order_id)
    INNER JOIN products AS p USING (product_id)
  WHERE o.customer = c.customer_id AND
        p.product_name = 'Pavlova'
);

-- Oppgave 7
-- Finn ut hvor mange kunder som befinner seg i sammme land som hver leverandør
-- (Supplier). Resultatet skal være to kolonner, en med leverandørnavnet, og
-- en kolonne med antall kunder fra samme land. Sorter resultatet etter antall
-- kunder i synkende rekkefølge (29 rader)
SELECT s.company_name, count(c.customer_id) AS num_customers
FROM suppliers AS s
     LEFT OUTER JOIN customers AS c USING (country)
GROUP BY s.supplier_id
ORDER BY num_customers DESC;


-- Oppgave 6.1.5
-- Let a and b be integer.valued attributes that may be NULL in some tuples.
-- For each of the following conditions (as may appear in a WHERE clause),
-- describe exactly the set of (a, b) tuples that satisfy the condition,
-- including the case where a and b / or b is null

-- Oppgave 6.1.5
/*
a)	a < 50 OR a >= 50
Alle tupler hvor a ikke er null.

b)	a = 0 OR b = 10
Alle tupler hvor a=o og b enten er null eller har en verdi
OG
Alle tupler hvor b=10 og a enten er null eller har en verdi.

c)	a = 20 AND b = 10
Hvis a og b er de eneste attributtene er (a,b)=(20,10) eneste
mulige kandidat.

d)	a = b
Hvis en av a eller b har verdien null, er resultatet av beregningen
a=b lik "unknown". Denne verdien er ikke lik 'true'.
Eneste tupler som tilfredstiller denne er derfor de hvor
a og b er ikke-null og har samme verdi.

e)	a > b
Tilsvarende. For at verdien skal kunne bli sann ('true'), må både
a og b være ulik null. Dessuten må verdien i a være større enn
den i b.
*/
