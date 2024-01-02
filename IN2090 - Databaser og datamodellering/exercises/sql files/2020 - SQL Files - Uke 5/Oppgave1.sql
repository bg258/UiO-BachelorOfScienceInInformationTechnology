/*
SQL
Alle oppgavene for denne uken løses ved bruk av filmdatabasen (se semesterside
for hvordan du kobler deg til den), og ikke din personlig database. Tallene
som er i parantes indikerer forventet antall rader fra spørringen */

-- Oppgave 1 - Enkle SELECT - setninger
-- Skriv en spørring som finner:

-- 1) Alle sjangere i Tabellen Genre (28)
SELECT *
FROM genre;

-- 2) Filmid og tittel for alle filmer utgitt i 1892 (12)
SELECT filmid, title
FROM film
WHERE prodyear = 1892;

-- 3) Filmid og tittel for alle filmer der filmid er mellom 2000 og 2030 (14)
SELECT filmid, title
FROM film
WHERE filmid > 2000 AND filmid < 2030;

-- 4) Filmid og tittel på alle filmer med Star Wars i navnet (129)
SELECT filmid, title
FROM film
WHERE title LIKE '%Star Wars%';

-- 5) Fornavn og etternavn til personid 465221(1)
SELECT firstname, lastname
FROM person
WHERE personid = 465221; -- Johny deep

-- 6) Alle unike rolle typer (parttyper i tabellen FilmParticipation) (7)
SELECT DISTINCT parttype
FROM filmparticipation;

-- 7) Tittle og navn og produksjonsår for alle som filmer som inneholder ordene «Rush Hour»(15)
SELECT filmid, title, prodyear
FROM film
WHERE title LIKE '%Rush Hour%';

-- 8) Vis filmid, navn og produksjonsår for filmer som innehlder ordet «Norge»(27)
SELECT filmid, title, prodyear
FROM film
WHERE title LIKE '%Norge%';

-- 9) Vis filmid for kinofilmer som har filmtittelen Love (kinofilmer har filmType "C") (42)
SELECT F.filmid
FROM film as F JOIN filmitem AS fp
ON F.filmid = fp.filmid
WHERE fp.filmtype = 'C' AND F.title = 'Love';

-- 10) Hvor mange filmer i filmdatabasen er norske?
SELECT COUNT(filmid)
FROM filmcountry
WHERE country = 'Norway';
