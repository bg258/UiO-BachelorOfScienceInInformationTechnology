-- Uke 7 --
-- Avansert SQL - Bruk Filmdatabasen (fdb)
-- 1) Hvilke verdier forekommer i attributtet filmtype i relasjonen filmitem?
--    Lag en oversikt over filmtypene og hvor mange filmer innen hver type.
SELECT filmtype, COUNT(*) AS antall_filmer
FROM filmitem AS f
GROUP BY filmtype;

-- Løsning
SELECT filmtype, COUNT(*) ant
FROM filmitem
GROUP BY filmtype
ORDER BY ant DESC;

-- 2) Skriv ut serietittel, produksjonsår og antall episoder for de 15 eldste
--    TV-seriene i Filmdatabasen (sortert stigende etter produksjonsår) (15)
SELECT s.maintitle AS serietittel,
       s.firstprodyear AS produksjonsår,
       COUNT(*) AS antall_episoder
FROM series AS s
  INNER JOIN episode AS e USING (seriesid)
GROUP BY s.seriesid, s.maintitle, s.firstprodyear
ORDER BY produksjonsår ASC
LIMIT 15;

-- Løsning
SELECT s.serieid,
       maintitle,
       firstprodyear,
       COUNT(e.episodeid)
FROM series s
  INNER JOIN episode e ON (s.seriesid = e.seriesid)
GROUP BY s.seriesid, maintitle, firstprodyear
ORDER BY firstprodyear ASC
LIMIT 15;

-- 3) Mange titler har vært brukt i flere filmer. Skriv ut en oversikt over
--    titler som har vært brukt i mer enn 30 filmer. Bak hver tittel skriv
--    antall ganger der er brukt. Ordne linjene med hyppigst forekommende
--    tittel først (12 eller 26).
SELECT title, COUNT(*) AS hyppighet
FROM film AS f
GROUP BY title
HAVING COUNT(*) > 30
ORDER BY hyppighet DESC;

-- Løsning
SELECT title, COUNT(*) AS ant
FROM film
GROUP BY title
HAVING COUNT(*) > 30
ORDER BY ant DESC;

-- Bare kinofilmer (12 rader)
SELECT title, COUNT(*) AS ant
FROM film INNER JOIN filmitem ON film.filmid = filmitem.filmid
WHERE filmitem.filmtype = 'C'
GROUP BY title
HAVING COUNT(*) > 30
ORDER BY ant DESC;

-- 4) Finn de "Pirates of the Caribbean"-filmene som er med i flere enn 3 genre (4)
SELECT f.title, COUNT(*) AS antall_genre
FROM film AS f
  INNER JOIN filmgenre AS g USING (filmid)
WHERE f.title LIKE '%Pirates of the Caribbean%'
GROUP BY f.title
HAVING COUNT(*) > 3
ORDER BY antall_genre DESC;

-- Løsning
SELECT title, COUNT(*) AS antall_genre
FROM film f
  NATURAL JOIN filmgenre fg
WHERE f.title LIKE 'Pirates of the Caribbean%'
GROUP BY f.filmid, title
HAVING COUNT(*) > 3;

-- 5) Hvilke verdier (fornavn) forekommer hyppigst i firstname-attributtet i
--    tabellen Person? Finn alle fornavn, og sorter fallende etter antall
--    forekommster. Ikke tell med forekomster der fornavn-verdien er tom.
--    Begrens gjerne antall rader (176030 rader, 16108 for flest navn)
SELECT firstname,
       COUNT(*) AS hyppighet
FROM person
WHERE firstname != ''
GROUP BY firstname
ORDER BY hyppighet DESC
LIMIT 1;

-- Løsning
SELECT p.firstname, COUNT(*) AS sammeFornavn
FROM Person p
WHERE p.firstname <> ''
GROUP BY p.firstname
ORDER BY COUNT(*) DESC
LIMIT 20;

-- 6) Finn filmene som er med i flest genrer: Skriv ut filmid, tittel og antall
--    genre, og sorter fallende etter antall genre. Du kan begrense resultatet
--    til 25 rader.
SELECT f.title,
       COUNT(*) AS genre
FROM film AS f
  INNER JOIN filmgenre AS g USING (filmid)
GROUP BY g.filmid, f.title
ORDER BY genre DESC
LIMIT 25;

-- Løsning
SELECT filmid, title, COUNT(*)
FROM film
  NATURAL JOIN filmgenre
GROUP BY filmid, title
ORDER BY COUNT(*) DESC
LIMIT 25;


-- 7) Lag en oversikt over regissører som har regissert mer enn 5 norske filmer (60).
SELECT p.firstname,
       p.lastname,
       COUNT(*) AS filmer_regissert
FROM filmparticipation AS fp
  INNER JOIN film AS f USING (filmid)
  INNER JOIN filmcountry AS c ON (f.filmid = c.filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE c.country = 'Norway' AND
      fp.parttype = 'director'
GROUP BY p.personid, p.firstname, p.lastname
HAVING COUNT(*) > 5
ORDER BY filmer_regissert DESC;

-- Løsning
SELECT lastname || ', ' || firstname AS navn
FROM Filmcountry
  NATURAL JOIN Film
  NATURAL JOIN Filmparticipation
  NATURAL JOIN Person
WHERE country = 'Norway'
  AND parttype = 'director'
GROUP BY lastname, firstname
HAVING COUNT(*) > 5

-- 8) Skriv ut serieid, serietittel og produksjonsår for TV-serier, sortert
--    fallende etter produksjonsår. Begrens resultatet til 50 filmer.
--    Tips: Ikke ta med serier der produksjonsår er null
SELECT seriesid, maintitle, firstprodyear
FROM series
WHERE firstprodyear IS NOT NULL
ORDER BY firstprodyear -- DESC
LIMIT 10;

-- Løsning
SELECT s.seriesid, maintitle, firstprodyear
FROM series s
WHERE firstprodyear IS NOT NULL
ORDER BY firstprodyear DESC
LIMIT 50;


-- 9) Hva er gjennomsnittlig score (rank) for filmer over 100 000 stemmer (votes)?
SELECT AVG(rank)
FROM filmrating
WHERE votes > 100000;

-- Løsning
SELECT avg(rank)
FROM filmrating
WHERE votes > 100000;

-- 10) Hvilke filmer (tittel og score) med over 100 000 stemmer har en høyere
--     score enn snittet blant filmer med over 100 000 stemmer (subspørring!) (20)
WITH
  film_ider AS (
    SELECT f.filmid AS filmid,
           f.title AS title
    FROM film AS f
      INNER JOIN filmrating AS r USING (filmid)
    WHERE r.votes > 100000
  )

SELECT f.title, AVG(rank)
FROM filmrating AS r
  INNER JOIN film_ider AS f USING (filmid)
  INNER JOIN film AS fi ON (r.filmid = fi.filmid)
GROUP BY r.filmid, f.title, r.rank
HAVING r.rank > (SELECT avg(rank)
                 FROM filmrating AS r
                 WHERE r.filmid IN (SELECT filmid
                                    FROM film_ider));
-- Løsning
SELECT title, rank
FROM film
  INNER JOIN filmrating ON film.filmid = filmrating.filmid
WHERE vots > 100000 AND rank >= (
  SELECT avg(rank)
  FROM filmrating
  WHERE votes > 100000
);

-- 11) Hvilke 100 verdier (fornavn) forekommer hyppigst i firstname-attributtet
--     i tabellen Person?
SELECT firstname, COUNT(*) AS hyppighet
FROM person AS p
GROUP BY firstname
ORDER BY hyppighet DESC
LIMIT 100;

-- Løsning
SELECT firstname, COUNT(*) AS sammeFornavn
FROM Person
WHERE firstname <> ''
GROUP BY firstname
ORDER BY sammeFornavn DESC
LIMIT 100;

-- 12) Hvilke to fornavn forekommer mer enn 6000 ganger og akkurat like
--     mange ganger? (Paul og Peter, vanskelig!)
SELECT A.fornavn, A.antall, B.fornavn, B.antall
FROM (
  SELECT firstname AS fornavn, COUNT(*) AS antall
  FROM person
  GROUP BY firstname
  HAVING COUNT(*) > 5999) AS A
INNER JOIN (
  SELECT firstname AS fornavn, COUNT(*) AS antall
  FROM Person
  GROUP BY firstname
  HAVING COUNT(*) > 5999) AS B
ON A.antall = B.antall AND A.fornavn <> B.fornavn;


-- 13) Hvor mange filmer har Tancred Ibsen regissert?
-- Tancred Ibsen har regissert 24 filmer
SELECT DISTINCT COUNT(*)
FROM filmparticipation AS fp
  INNER JOIN film AS f USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE p.firstname = 'Tancred' AND
      p.lastname = 'Ibsen' AND
      fp.parttype = 'director';

-- Løsning
SELECT COUNT(DISTINCT filmid) AS tancredIbsenFilmer
FROM Filmparticipation
  NATURAL JOIN Person
WHERE
  lastname = 'Ibsen' AND firstname = 'Tancred' AND parttype = 'director';

-- eller

SELECT COUNT(*) AS tancredIbsenFilmer
FROM (
  SELECT DISTINCT filmid AS tancredIbsenFilmer
  FROM filmparticipation
    NATURAL JOIN Person
  WHERE
    lastname = 'Ibsen' AND firstname = 'Tancred' AND parttype = 'director') AS t;


-- 14) Lag en oversikt over regissører som har regissert mer enn 5 norske
--     filmer (60).
SELECT p.firstname, p.lastname,
       COUNT(*) AS antall_filmer
FROM filmparticipation AS fp
  INNER JOIN film AS f ON (fp.filmid = f.filmid)
  INNER JOIN filmcountry AS fc ON (f.filmid = fc.filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE fp.parttype = 'director' AND
      fc.country = 'Norway'
GROUP BY fp.personid, p.firstname, p.lastname
HAVING COUNT(*) > 5
ORDER BY antall_filmer DESC;

-- Løsning
SELECT lastname || ', ' || firstname AS navn
FROM filmcountry
  NATURAL JOIN film
  NATURAL JOIN filmparticipation
  NATURAL JOIN person
WHERE country = 'Norway'
  AND parttype = 'director'
GROUP BY lastname, firstname
HAVING COUNT(*) > 5
ORDER BY lastname ASC;


-- 15) Lag en oversikt (filmtittel) over norske filmer med mer enn én regissør. (135)
SELECT f.title
FROM filmparticipation AS fp
  INNER JOIN film AS f ON (fp.filmid = f.filmid)
  INNER JOIN filmcountry AS fc ON (f.filmid = fc.filmid)
WHERE fp.parttype = 'director' AND
      fc.country = 'Norway'
GROUP BY fp.filmid, f.title
HAVING COUNT(*) > 1;

-- Løsning
SELECT filmid, title
FROM filmcountry
  NATURAL JOIN film
  NATURAL JOIN filmparticipation
  NATURAL JOIN person
WHERE country = 'Norway'
  AND parttype = 'director'
GROUP BY filmid, title
HAVING COUNT(*) > 1;

-- 16) Finn regissører som har regissert alene mer enn 5 norske filmer (49)
WITH
  regissør AS (
    SELECT p.personid
    FROM filmparticipation AS fp
      INNER JOIN person AS p USING (personid)
    WHERE fp.parttype = 'director'
    GROUP BY fp.filmid
    HAVING COUNT(*) < 2
  )
SELECT p.firstname,
       p.lastname,
       COUNT(*)
FROM filmparticipation AS fp
  INNER JOIN person AS p USING (personid)
  INNER JOIN filmcountry AS c ON (fp.filmid = c.filmid)
WHERE c.country = 'Norway' AND
      fp.personid IN (SELECT * FROM regissør)
GROUP BY fp.personid, p.firstname, p.lastname
HAVING COUNT(*) > 5;

-- Løsning
SELECT lastname || ', ' || firstname AS navn, COUNT(*) AS antall
FROM filmcountry
  NATURAL JOIN film
  NATURAL JOIN filmparticipation
  NATURAL JOIN person
WHERE country = 'Norway'
  AND parttype = 'director'
  AND filmid NOT IN
    (SELECT filmid
     FROM filmcountry
        NATURAL JOIN film
        NATURAL JOIN filmparticipation
        NATURAL JOIN person
     WHERE country = 'Norway'
       AND parttype = 'director'
     GROUP BY filmid, title
     HAVING COUNT(*) > 1)
GROUP BY lastname, firstname
HAVING COUNT(*) > 5
ORDER BY antall DESC;

-- 17) Finn tittel, produksjonsår og filmtype for alle kinofilmer som ble
--     produsert i året 1893. (4)
SELECT f.title, f.prodyear, i.filmtype
FROM film AS f
  INNER JOIN filmitem AS i USING (filmid)
WHERE f.prodyear = 1893;

-- Løsning
SELECT f.title, f.prodyear, fi.filmtype
FROM film f NATURAL JOIN filmitem fi
WHERE f.prodyear = 1893;

-- 18) Finn navn på alle skuespillere (cast) i filmen Baile Perfumado (14)
SELECT DISTINCT p.firstname, p.lastname
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE fp.parttype = 'cast' AND
      f.title = 'Baile Perfumado';

-- Løsning
SELECT DISTINCT p.firstname || ' ' || p.lastname AS name
FROM film f
  NATURAL JOIN filmparticipation fp
  NATURAL JOIN person p
WHERE fp.parttype LIKE 'cast'
  AND f.title LIKE 'Baile Perfumado';

-- 19) Finn tittel og produksjonsår for alle filmene som Ingmar Bergman har vært
--     regissør (director) for. Sorter tuplene kronologisk etter produksjonsår. (62)
SELECT f.title, f.prodyear AS production_year
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE fp.parttype = 'director' AND
      p.firstname = 'Ingmar' AND
      p.lastname = 'Bergman'
ORDER BY production_year;

-- Løsning
SELECT f.title, f.prodyear
FROM film f
  NATURAL JOIN filmparticipation fp
  NATURAL JOIN person p
WHERE p.lastname LIKE 'Bergman'
  AND p.firstname LIKE 'Ingmar'
  AND fp.parttype LIKE 'director'
ORDER BY f.prodyear DESC;

-- 20) Finn produksjonsår for første og siste film Ingmar Bergman regisserte.
SELECT MIN(f.prodyear) AS første_film,
       MAX(f.prodyear) AS siste_film
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE fp.parttype = 'director' AND
      p.firstname = 'Ingmar' AND
      p.lastname = 'Bergman';

-- Løsning
SELECT MIN(f.prodyear) AS first, MAX(f.prodyear) AS last
FROM film f
  NATURAL JOIN filmparticipation fp
  NATURAL JOIN person p
WHERE fp.parttype LIKE 'director'
  AND p.lastname LIKE 'Bergman'
  AND p.firstname LIKE 'Ingmar';

-- 21) Finn tittel og produksjonsår for de filmene hvor mer enn 300 personer
--     har deltatt, uansett hvilken funksjon de har hatt (11).
SELECT DISTINCT f.title, f.prodyear, COUNT(*)
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
GROUP BY fp.filmid, f.title, f.prodyear
HAVING COUNT(*) > 300;

-- Løsning
SELECT f.title, f.prodyear, COUNT(*) AS participants
FROM film f
  NATURAL JOIN filmparticipation fp
GROUP BY f.title, f.prodyear
HAVING COUNT(DISTINCT fp.personid) > 300
ORDER BY participants DESC;

-- 22) Finn oversikt over regissører som har regissert kinofilmer over et
--     stort tidsspenn. I tillegg til navn, ta med antall kinofilmer og første
--     og siste år (prodyear) personen hadde regi. Skriv ut alle som har et
--     tidsintervall på mer enn 49 år mellom første og siste film og
--     sorter dem etter lengden på dette tidsintervall, de lengste først.
SELECT p.firstname || ' ' || p.lastname AS name,
       COUNT(*) AS produced,
       MIN(f.prodyear) AS first, MAX(f.prodyear) AS last,
       MAX(f.prodyear) - MIN(f.prodyear) AS periode
FROM film f
  NATURAL JOIN filmparticipation fp
  NATURAL JOIN person p
WHERE fp.parttype LIKE 'director'
GROUP BY p.personid, name
HAVING (MAX(f.prodyear) - MIN(f.prodyear) > 49)
ORDER BY periode DESC;


-- 23) Finn filmid, tittel og antall medregissører (partype 'director') (0 der
--     han regissert alene) for filmer som Ingmar Bergman har regissert (62)
WITH
  ingmarbergmanmovies AS (
    SELECT fp.filmid
    FROM filmparticipation fp INNER JOIN person p ON fp.personid = p.personid
    WHERE fp.parttype = 'director'
    AND p.firstname = 'Ingmar'
    AND p.lastname = 'Bergman'
  ),
  ant_regissorer AS (
    SELECT fp.filmid, COUNT(*) AS ant
    FROM filmparticipation fp
    WHERE fp.filmid IN (SELECT * FROM ingmarbergmanmovies)
    AND fp.parttype = 'director'
    GROUP BY fp.filmid
  )
SELECT f.filmid, f.title, (ar.ant - 1) AS ant_medregissorer
FROM film f INNER JOIN ant_regissorer ar ON f.filmid = ar.filmid;


-- 24) Finn filmid, antall involverte personer, produksjonsår og rating
--     for alle filmer som Ingmar Bergman har regissert. Ordne kronologisk
--     etter produksjonsår (56)
SELECT f.filmid, COUNT(fp.partid) AS involverte, f.prodyear, r.rank
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
  INNER JOIN filmrating AS r ON (fp.filmid = r.filmid)
WHERE fp.parttype = 'director' AND
      p.firstname = 'Ingmar' AND
      p.lastname = 'Bergman'
GROUP BY f.filmid, r.rank, f.prodyear
ORDER BY f.prodyear DESC;

-- Løsning
WITH
  ingmarbergmanmovies AS (
    SELECT fp.filmid
    FROM filmparticipation fp
      INNER JOIN person p ON fp.personid = p.personid
    WHERE fp.parttype = 'director'
    AND p.firstname = 'Ingmar'
    AND p.lastname = 'Bergman'
  ),
  crew AS (
    SELECT fp.filmid, COUNT(*) AS ant
    FROM filmparticipation fp
    WHERE fp.filmid IN (SELECT * FROM ingmarbergmanmovies)
    GROUP BY filmid
  )
SELECT f.filmid, c.ant, f.prodyear, fr.rank AS rating
FROM film d
  iNNER JOIN crew c ON f.filmid = c.filmid
  INNER JOIN filmrating fr ON fr.filmid = f.filmid
WHERE f.filmid IN (SELECT * FROM ingmarbergmanmovies)
ORDER BY f.prodyear;

-- 25) Finn produksjonsår og tittel for alle filmer som både angelina Jolie og
--     Antonio Banderas har deltatt i sammen.
WITH
  antonio_banderas AS (
    SELECT fp.filmid AS filmid
    FROM filmparticipation AS fp
      INNER JOIN person AS p USING (personid)
    WHERE p.firstname = 'Antonio' AND
          p.lastname = 'Banderas'
  ),
  angelina_jolie AS (
    SELECT fp.filmid AS filmid
    FROM filmparticipation AS fp
      INNER JOIN person AS p USING (personid)
    WHERE p.firstname = 'Angelina' AND
          p.lastname = 'Jolie'
  ),
  id_er AS (
    SELECT filmid
    FROM antonio_banderas AS ab
      INNER JOIN angelina_jolie AS aj USING (filmid)
  )
SELECT f.title, f.prodyear
FROM film AS f
  INNER JOIN id_er USING (filmid);


-- Løsning
SELECT f.title, f.prodyear
FROM film f
  NATURAL JOIN filmparticipation fp
  NATURAL JOIN person p
WHERE p.firstname = 'Angelina' AND p.lastname = 'Jolie'
  AND fp.filmid IN (
    SELECT fp2.filmid
    FROM filmparticipation fp2 NATURAL JOIN person p
    WHERE p.firstname = 'Antonio' AND p.lastname = 'Banderas'
  );

-- 26) Finn tittel, navn og roller for personer som har hatt mer enn en rolle
--     i samme film blant kinofilmer som ble produsert i 2003. (Med forskjellige
--     roller mener vi cast, director, producer osv. Vi skal altså ikke ha med
--     de som har to ulike cast-roller)
SELECT f.title, p.firstname || ' ' || p.lastname AS name, fp.parttype
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
  INNER JOIN filmitem AS i ON (fp.filmid = i.filmid)
WHERE i.filmtype = 'C' AND
      f.prodyear = 2003
GROUP BY p.personid, fp.parttype, p.firstname, p.lastname, f.title
HAVING COUNT(*) > 1
ORDER BY f.title
LIMIT 10;


-- Løsning
SELECT DISTINCT f.title, concat(p.firstname, ' ', p.lastname) AS name, fp.parttype
FROM film f NATURAL JOIN filmparticipation fp NATURAL JOIN person p
INNER JOIN (
    SELECT fp.personid, fp.filmid
    FROM filmparticipation fp NATURAL JOIN film NATURAL JOIN filmitem
    WHERE film.prodyear = 2003 AND filmitem.filmtype = 'C'
    GROUP BY fp.personid, fp.filmid
    HAVING count(distinct parttype) > 1
) q ON q.filmid = fp.filmid AND q.personid = fp.personid
ORDER BY name ASC;

-- eller
SELECT DISTINCT f.title, p.firstname || ' ' || p.lastname as name, fp.parttype
FROM film f NATURAL JOIN filmitem fi NATURAL JOIN filmparticipation fp NATURAL JOIN person p
WHERE f.prodyear = 2003
AND fi.filmtype = 'C'
GROUP BY f.title, p.firstname, p.lastname, fp.parttype, fp.personid, f.filmid
HAVING (
    SELECT count(distinct fp1.parttype)
    FROM filmparticipation fp1
    WHERE fp1.personid = fp.personid AND f.filmid = fp1.filmid) > 1
ORDER BY f.title, name, fp.parttype;


-- 27) Finn navn og antall filmer for personer som har deltatt i mer enn 15
--     15 filmer i 2008, 2009 eller 2010, men som ikke har deltatt i noen filmer
--     i 2005.

WITH
  filmer_2008_9_10 AS (
    SELECT filmid
    FROM film
    WHERE prodyear = 2008 OR
          prodyear = 2009 OR
          prodyear = 2010
  ),
  filmer_2005 AS (
    SELECT filmid
    FROM film
    WHERE prodyear = 2005
  ),
  personer_med_15_filmer AS (
    SELECT fp.personid personid, fp.filmid AS filmid
    FROM filmparticipation AS fp
      INNER JOIN person AS p USING (personid)
    WHERE fp.filmid NOT IN (SELECT *
                            FROM filmer_2005) AND
          fp.filmid IN (SELECT *
                        FROM filmer_2008_9_10)
    GROUP BY fp.personid, fp.filmid)
SELECT COUNT(*)
FROM filmparticipation AS fp
  INNER JOIN personer_med_15_filmer USING (personid, filmid)
GROUP BY fp.personid
HAVING COUNT(*) > 15;

-- Løsning
SELECT p.firstname || ' ' || p.lastname AS name, count(distinct filmid) AS antall
FROM film f NATURAL JOIN filmparticipation fp NATURAL JOIN person p
WHERE f.prodyear IN (2008,2009,2010) AND fp.personid not IN (
    SELECT personid
    FROM filmparticipation fp NATURAL JOIN film f
    WHERE f.prodyear = 2005
)
GROUP BY fp.personid, name
HAVING count(distinct filmid) > 15;

-- 28) Finn navn på regisørrer og filmtittel for filmer hvor mer enn 200
--     personer har deltatt, uansett hvilken funksjon de har hatt.
--     Ta ikke med filmer som har hatt flere regissører (mer enn én). (33)
WITH
  filmer_med_en_regissør AS (
    SELECT fp.filmid
    FROM filmparticipation AS fp
    WHERE fp.parttype = 'director'
    GROUP BY fp.filmid
    HAVING COUNT(*) = 1
  ),
  resultat AS (
    SELECT fp.filmid
    FROM film AS f
      INNER JOIN filmparticipation AS fp USING (filmid)
      INNER JOIN person AS p ON (fp.personid = p.personid)
    WHERE fp.filmid IN (SELECT *
                        FROM filmer_med_en_regissør)
    GROUP BY fp.filmid
    HAVING COUNT(*) > 200
  )

SELECT f.title, p.firstname || ' ' || p.lastname
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE fp.parttype = 'director' AND
      fp.filmid IN (SELECT * FROM resultat);

-- Løsning

SELECT p.firstname, p.lastname, f.title
FROM film f NATURAL JOIN filmparticipation fp NATURAL JOIN person p
WHERE fp.parttype = 'director' AND
f.filmid IN(SELECT f.filmid
            FROM film f NATURAL JOIN filmparticipation fp
            GROUP BY f.filmid
            HAVING count(distinct fp.personid) > 200) AND
f.filmid not IN(SELECT f.filmid
                FROM film f NATURAL JOIN filmparticipation fp
                WHERE fp.parttype='director'
                GROUP BY f.filmid
                HAVING count(fp.parttype) > 1);
-- 29) Finn navn i leksikografisk orden på regissører som har regissert alene
--     kinofilmer med mer enn 150 deltakere og som har en regissørkarriere på
--     mer enn 49 år.

SELECT p.lastname || ', ' || p.firstname AS name
FROM person p
WHERE p.personid IN (
    SELECT fp.personid
    FROM filmparticipation fp
    WHERE parttype = 'director'
    AND fp.filmid IN (
        SELECT filmid
        FROM filmparticipation NATURAL JOIN film f
        WHERE parttype = 'director'
        AND filmid IN (
            SELECT filmid
            FROM filmparticipation fp
            GROUP BY filmid
            HAVING count(*) > 150
        )
        GROUP BY filmid
        HAVING count(*) = 1
    )
) AND p.personid IN (
    SELECT fp.personid
    FROM filmparticipation fp NATURAL JOIN film f NATURAL JOIN filmitem i
    WHERE fp.parttype = 'director'
        AND i.filmtype = 'C'
    GROUP BY fp.personid
    HAVING max(f.prodyear)-min(f.prodyear) > 49
)
ORDER BY name ASC;

-- eller
SELECT DISTINCT p.firstname, p.lastname
FROM film f0 NATURAL JOIN filmparticipation fp NATURAL JOIN person p
WHERE fp.parttype = 'director' AND
exists (SELECT f.filmid
        FROM film f NATURAL JOIN filmitem fi NATURAL JOIN filmparticipation fp1
        WHERE fp1.parttype = 'director' AND fi.filmtype='C' AND fp1.personid = fp.personid AND f.filmid
        IN (SELECT f2.filmid
            FROM film f2 NATURAL JOIN filmitem fi2 NATURAL JOIN filmparticipation fp3
            WHERE fp3.parttype='director' AND fi2.filmtype='C' AND f2.filmid
            IN (SELECT f3.filmid
                FROM film f3 NATURAL JOIN filmitem fi3 NATURAL JOIN filmparticipation fp4
                WHERE fi3.filmtype ='C'
                GROUP BY f3.filmid
                HAVING count(distinct fp4.personid) > 150)
        GROUP BY f2.filmid
        HAVING count(fp3.parttype) = 1))
GROUP BY p.firstname, p.lastname
HAVING (max(f0.prodyear) - min(f0.prodyear) > 49)
ORDER BY p.firstname, p.lastname DESC
