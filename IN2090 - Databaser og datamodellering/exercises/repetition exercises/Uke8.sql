-- Uke 8
-- psql -h dbpg-ifi-kurs01 -U marktz -d fdb
-- Bruk filmdatabasen for å løse følgende oppgaver:
-- Oppgave 1
-- Finn ut hvor mange produksjoner (altså alt som forekommer i filmparticipation
-- tabellen) hver person med etternavn 'Abbott' har deltatt i (husk å få med de
-- som har deltatt i 0 filmer). (243 rader)
SELECT p.firstname, p.lastname, COUNT(fp.filmid) AS ant_produksjoner
FROM person AS p
  LEFT OUTER JOIN filmparticipation AS fp USING (personid)
WHERE p.lastname = 'Abbott'
GROUP BY fp.personid, p.firstname, p.lastname
ORDER BY ant_produksjoner;

-- Oppgave 2
-- Finn tittel på alle Western-filmer laget etter 2007 som ikke har en rating.
-- Løs oppgaven på ved å bruke: (14 rader)
-- a) NOT IN
SELECT f.title
FROM film AS f
  INNER JOIN filmgenre AS g USING(filmid)
WHERE f.filmid NOT IN (SELECT filmid FROM filmrating) AND
      g.genre = 'Western' AND
      f.prodyear > 2007;
-- b) LEFT OUTER JOIN
SELECT f.title
FROM film AS f
  INNER JOIN filmgere AS f USING (filmid)
  LEFT OUTER JOIN filmrating AS r USING (filmid)
WHERE r.filmid IS NULL AND
      g.genre = 'Western' AND
      f.prodyear > 2007;

-- c) EXCEPT
-- d) NOT EXISTS
SELECT f.title
FROM film AS f
  INNER JOIN filmgenre AS fg USING (filmid)
WHERE f.prodyear > 2007 AND
      f.genre = 'Western' AND
      NOT EXISTS (
        SELECT *
        FROM filmrating AS r
        WHERE r.filmid = f.filmid
      )

-- Oppgave 3
-- Finn antall filmer som enten er komedier, eller som Jim Carrey har spilt i. (1 rad)
SELECT COUNT(DISTINCT filmid) AS nr_movies
FROM film
WHERE filmid IN (
  (SELECT filmid
   FROM filmgenre
   WHERE genre = 'Comedy')
   UNION
   (SELECT fp.filmid
    FROM person AS p
      INNER JOIN filmparticipation AS fp USING (personid)
    WHERE p.firstname = 'Jim' AND p.lastname = 'Carrey')
)
-- Oppgave 4
-- Finn tittel på alle filmer som som Jim Carrey har spilt i, men som ikke er
-- komedier. (62 rader)

SELECT title
FROM film
WHERE filmid IN (
  (SELECT filmid
   FROM filmparticipation AS fp
      INNER JOIN person AS p USING (personid)
  WHERE p.firstname = 'Jim' AND
        p.lastname = 'Carrey')
  EXCEPT
  (SELECT filmid
   FROM filmgenre
   WHERE genre = 'Comedy')
);

-- Løsning
SELECT title
FROM film
WHERE filmid IN (
  (SELECT fp.filmid
   FROM person AS p
      INNER JOIN filmparticipation AS fp USING (personid
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
-- Oppgave 5
-- Finn navnet på alle firmaer (Customers og Suppliers) som kommer fra Norge
-- eller Sverige. (6 rader)

SELECT company_name
FROM suppliers
WHERE country = 'Norway' OR
      country = 'Sweden'
UNION
SELECT company_name
FROM customers
WHERE country = 'Norway' OR
      country = 'Sweden';

-- Oppgave 6
-- BRUK exists for å finne navnet på alle kunder som har kjøpt Pavlova. (31 rader)
SELECT DISTINCT company_name
FROM customers c
WHERE EXISTS (
  SELECT customer_id
  FROM orders AS o
    INNER JOIN order_details AS d USING (order_id)
    INNER JOIN products AS p USING (product_id)
  WHERE p.product_name = 'Pavlova' AND
        c.customer_id = o.customer_id
);

-- Oppgave 6
-- Finn ut hvor mange kunder som befinner seg i samme land som hver leverandør (supplier).
-- Resultatet skal være to kolonner, en med leverandørnavnet, og en kolonne med
-- antall kunder fra samme land. Sorter resultatet etter antall kunder i
-- synkende rekkefølge (29 rader)
SELECT s.company_name, COUNT(c.customer_id) AS num_customers
FROM suppliers AS s
  LEFT OUTER JOIN customers c USING (country)
GROUP BY s.supplier_id
ORDER BY num_customers DESC;
