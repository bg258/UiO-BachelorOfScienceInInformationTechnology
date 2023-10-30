 -- SQL
 -- Alle oppgavene for denne uken løses ved bruk av filmdatabasen.
 -- Oppgave 1  - Enkle SELECT - setninger
 -- Skriv en spørring som finner:
 -- 1) Alle sjangere i tabellen Genre (28)

 SELECT *
 FROM genre;

-- or

SELECT COUNT(*)
FROM genre;

-- 2) Filmid og tittel for alle filmer utgitt i 1892 (12)
SELECT filmid, title
FROM film
WHERE prodyear = 1892;

-- Løsning
SELECT f.filmid, f.title
FROM film f
WHERE f.prodyear = 1892;

-- 3) Filmid og tittel for alle filmer der filmid er mellom 2000 og 2030 (14)

SELECT filmid, title
FROM film
WHERE filmid >= 2000 AND
      filmid <= 2030;

-- Løsning
SELECT f.filmid, f.title
FROM film f
WHERE f.filmid >= 2000 AND f.filmid <= 2030;

-- 4) Filmid og tittel på alle filmer med Star Wars i navnet (129)
SELECT filmid, title
FROM film
WHERE title LIKE ('%Star Wars%');

-- Løsning
SELECT f.title, f.filmid
FROM Film f
WHERE f.title LIKE '%Star Wars%';

-- 5) Fornavn og etternavn til personid 465221 (1)
SELECT firstname, lastname
FROM person
WHERE personid = 465221;

-- Løsning

SELECT p.firstname, p.lastname
FROM person p
WHERE p.personid = 465221;

-- 6) Alle unike rolletyper (parttype) i tabellen filmparticipation (7)
SELECT DISTINCT parttype
FROM filmparticipation;

-- 7) Tittel og produksjonsår for alle filmer som inneholder ordene "Rush Hour" (15)
SELECT title, prodyear
FROM film
WHERE title LIKE ('%Rush Hour%');

-- Løsning

SELECT f.title, f.prodyear
FROM film f
WHERE f.title LIKE '%Rush Hour%';

-- 8) Vid filmid, navn og produksjonsår for filmer som inneholder ordet "Norge" (27)
SELECT filmid, title, prodyear
FROM film
WHERE title LIKE ('%Norge%');

-- 9) Vis filmid for kinofilmer som har filmtittelen Love (kinofilmer har filmtype "C") (42)
SELECT filmid
FROM film AS f
  INNER JOIN filmitem AS item USING (filmid)
WHERE item.filmtype = 'C' AND
      f.title = 'Love';

-- Løsning

SELECT fi.filmid
FROM filmitem fi
  INNER JOIN film f ON f.filmid = fi.filmid
WHERE fi.filmtype = 'C' AND
      f.title = 'Love';

-- 10) Hvor mange filmer i filmdatabasen er norske?
SELECT DISTINCT COUNT(filmid)
FROM filmcountry
WHERE country = 'Norway';


-- Oppgave 2- Nestede setninger:
-- Skriv en spørring som bruker nestede-spørringer for å finne:
-- 1) Filmid og filmtype (fra Filmitem) for alle filmer som ble produsert i 1894 (82)
SELECT f.filmid, item.filmtype
FROM film AS f
  INNER JOIN filmitem AS item USING (filmid)
WHERE f.prodyear = 1894;

-- Løsning
SELECT *
FROM filmitem fi
WHERE fi.filmid ON (SELECT f.filmid FROM film f WHERE f.prodyear = 1894);

--- Ekvivalent med

SELECT *
FROM filmitem fi
  INNER JOIN film f ON (f.filmid = fi.filmid)
WHERE f.prodyear = 1894;

-- 2) Navn på alle kvinnelige skuespillere (cast) i filmen med filmid 357076 (11)
SELECT DISTINCT firstname || ' ' || lastname
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE f.filmid = 357076 AND
      fp.parttype = 'cast' AND
      p.gender = 'F';

-- Løsning

SELECT p.firstname, p.lastname
FROM person p
WHERE p.gender = 'F' AND p.personid IN
  (SELECT fp.personid
   FROM filmparticipation fp
   WHERE fp.filmid = 357076 AND fp.parttype = 'cast')
ORDER BY p.lastname;

-- Oppgave 3 - Setninger med ulike typer JOIN
-- Skriv en spørring som finner:
-- 1) Alle sjangere (eng: genres) til filmen 'Pirates of the Caribbean: The
--    Legend of Jack Sparrow' (5)

SELECT genre
FROM film
  INNER JOIN filmgenre USING (filmid)
WHERE title = 'Pirates of the Caribbean: The Legend of Jack Sparrow';

-- Løsning
SELECT f.title, fg.genre
FROM film f
  NATURAL JOIN filmgenre fg
WHERE f.title = 'Pirates of the Caribbean: The Legend of Jack Sparrow';


-- 2) Alle sjangere for filmen med filmid 985057 (9)
SELECT genre
FROM film
  INNER JOIN filmgenre USING (filmid)
WHERE filmid = 985057;

-- Løsning
SELECT * FROM film NATURAL JOIN filmgenre WHERE filmid = 985057;

-- 3) Tittel, porduksjonsår og filmtype for alle filmer som ble produsert i 1894 (82)
SELECT f.title, f.prodyear, i.filmtype
FROM film AS f
  INNER JOIN filmitem AS i USING (filmid)
WHERE f.prodyear = 1894;

-- Løsning
SELECT f.title, f.prodyear, fi.filmtype
FROM Film f, Filmitem fi
WHERE f.prodyear = 1894 AND
      f.filmid = fi.filmid;

-- eller
SELECT f.title, f.prodyear, fi.filmtype
FROM film f
  NATURAL JOIN filmitem fi
WHERE f.prodyear = 1894;

SELECT f.title, f.prodyear, fi.filmtype
FROM film f
  INNER JOIN filmitem fi ON f.filmid = fi.filmid
WHERE f.prodyear = 1894;

-- 4) Alle kvinnelige skuespillere (Cast) i filmen med filmid 357076. Skriv ut navn
--    og på skuespillerne og filmid (11)
SELECT DISTINCT f.filmid AS ID,
                firstname || ' ' || lastname AS fullname
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE f.filmid = 357076 AND
      fp.parttype = 'cast' AND
      p.gender = 'F';

-- Løsning
SELECT DISTINCT p.firstname, p.lastname, fp.filmid
FROM person p,
     filmparticipation fp
WHERE p.gender = 'F'
  AND fp.filmid = 357076
  AND fp.parttype = 'cast'
  AND p.personid = fp.personid;

-- eler

SELECT DISTINCT p.firstname, p.lastname, fp.filmid
FROM person p
  NATURAL JOIN filmparticipation FP
WHERE p.gender = 'F'
  AND fp.filmid = 356076
  AND fp.parttype = 'cast';

-- eller
SELECT DISTINCT p.firstname, p.lastname, fp.filmid
FROM Person p
  INNER JOIN filmparticipation fp ON p.personid = fp.personid
WHERE p.gender = 'F'
  AND fp.filmid = 357076
  AND fp.parttype = 'cast';

-- 5) Finn fornavn og etternavn på alle personer som har deltatt i TV-serien
--    South Park. Bruk tabellene Person, Filmparticipation og Series, og løs det med:
-- INNER JOIN (21)
SELECT DISTINCT p.firstname, p.lastname
FROM series AS s
  INNER JOIN filmparticipation AS f ON (s.seriesid = f.filmid)
  INNER JOIN person AS p ON (f.personid = p.personid)
WHERE maintitle = 'South Park';

-- IMPLISITT JOIN (21)
SELECT DISTINCT p.firstname, p.lastname
FROM series AS s,
     filmparticipation AS fp,
     person AS p
WHERE s.seriesid = fp.filmid AND
      fp.personid = p.personid AND
      s.maintitle = 'South Park';

-- NATURAL JOIN
SELECT DISTINCT p.firstname, p.lastname
FROM series AS s
  NATURAL JOIN filmparticipation AS f
  NATURAL JOIN person AS p
WHERE maintitle = 'South Park';

-- Hvorfor gir NATURAL JOIN ulik resultat fra INNER JOIN og implisitt JOIN? Forklar.
-- Den joiner tabellen med andre attributter som har likt navn, derfor vil vi
-- få ulikt svar fra det vi forventer.


-- 6) Finn navn på alle skuespillere (cast) i filmen, deres rolle (parttype)
--    i filmen "Harry Potter and the Goblet of Fire" (vær presis med staving),
--    få med tittelen til filmen også (90)
SELECT DISTINCT p.firstname, p.lastname, fp.parttype
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE fp.parttype = 'cast' AND
      f.title = 'Harry Potter and the Goblet of Fire';

-- Løsning

SELECT DISTINCT p.firstname, p.lastname, fp.parttype, f.title
FROM Person p NATURAL JOIN Filmparticipation fp NATURAL JOIN film f
WHERE title = 'Harry Potter and the Goblet of Fire' AND parttype = 'cast';

-- 7) Finn navn på alle skuespillere (cast) i filmen Baile Perfumado (14)
SELECT DISTINCT firstname || ' ' || lastname AS fullname
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE fp.parttype = 'cast' AND
      f.title = 'Baile Perfumado';

-- Løsning

SELECT DISTINCT p.firstname || ' ' || p.lastname AS name
FROM film f NATURAL JOIN filmparticipation fp NATURAL JOIN person p
WHERE fp.parttype = 'cast'
AND f.title = 'Baile Perfumado';

-- 8) Skriv ut tittel og regissør for norske filmer produsert før 1960 (269)
SELECT DISTINCT f.title, p.firstname || ' ' || p.lastname
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
  INNER JOIN filmcountry AS c USING (filmid)
WHERE c.country = 'Norway' AND
      fp.parttype = 'director' AND
      f.prodyear < 1960;

-- Løsning

select film.title, person.firstname || ' ' || person.lastname as fullname
from filmcountry
    natural join film
    natural join filmparticipation
    natural join person
where filmcountry.country = 'Norway'
    and parttype = 'director'
    and prodyear < 1960;
