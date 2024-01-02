-- Oppgave 3 - Setninger med ulike typer JOIN
-- Skriv en spørring som finner:

-- 1) Alle sjangere (eng: genres) til filmen "Pirates of the Caribbean: The
--    legend of Jack Sparrow" (5)

SELECT FG.genre
FROM filmgenre AS FG JOIN film AS F
ON FG.filmid = F.filmid
WHERE F.title = 'Pirates of the Caribbean: The Legend of Jack Sparrow';


-- 2) Alle sjangere for filmen med filmid 985057 (9)
SELECT genre
FROM filmgenre NATURAL JOIN film
WHERE filmid = 985057;

-- 3) Tittel, produksjonsår og filmtype for alle filmtyper som ble
--    ble produsert i 1894 (82)

SELECT title, prodyear, filmtype
FROM film NATURAL JOIN filmitem
WHERE prodyear = 1894;

-- 4) Alle kvinnelige skuespillere (cast) i filmen med filmid 35706. Skriv ut
--    navn og på skuespillerene og filmid (11)
SELECT F.filmid, F.title, P.firstname, P.lastname
FROM film AS F JOIN filmparticipation AS FP
ON F.filmid = FP.filmid JOIN person AS P on
FP.personid = P.personid
WHERE F.filmid = 357076 and P.gender = 'F' and FP.parttype = 'cast';

-- 5) Finn fornavn og etternavn på alle personer som har deltatt i TV-serien
--    South Park.
--    Bruk tabellene Person, FilmParticipation og Series, og løs det med:
--    a) INNER JOIN
SELECT count(P.firstname)
FROM series AS S


-- 6) Finn navn på alle skuespillere (cast) i filmen, deres rolle (parttype)
--    i filmen «Harry Potter and the Goblet of Fire» (vær presis med staving),
--    få med tittelen til filmen også (90)

SELECT DISTINCT P.firstname, P.lastname, FP.parttype, F.title
FROM film AS F JOIN filmparticipation AS FP
ON F.filmid = FP.filmid JOIN person AS P on
FP.personid = P.personid
WHERE F.title = 'Harry Potter and the Goblet of Fire' and FP.parttype = 'cast';


-- 7) Finn navn på alle skuespillere(cast) i filmen Baile Perfumado(14)
SELECT DISTINCT P.firstname, P.lastname, FP.parttype, F.title
FROM film AS F JOIN filmparticipation AS FP
ON F.filmid = FP.filmid JOIN person AS P on
FP.personid = P.personid
WHERE F.title = 'Baile Perfumado' and FP.parttype = 'cast';

-- 8) Skriv ut tittel og regissør for norske filmer produsert før 1960(269)
SELECT F.title, P.firstname, P.lastname
FROM film AS F
  JOIN filmcountry AS FC on F.filmid = FC.filmid
  JOIN filmparticipation AS FP on FC.filmid = FP.filmid
  JOIN person AS P ON FP.personid = P.personid
where FC.country = 'Norway' and F.prodyear < 1960 and FP.parttype = 'director';
