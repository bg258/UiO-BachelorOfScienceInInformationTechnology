-- UKE 9 (UKE 7)
-- Avansert SQL - Bruk Filmdatabasen (fdb)
-- 1) Hvilke verdier forekommer i attributtet filmtype i relasjonen filmitem?
--    Lag en oversikt over filmtypene og hvor mange filmer innen hver type. (7)
SELECT filmtype, COUNT(filmid) AS antallFilmer
FROM filmitem
GROUP BY (filmtype);

-- 2) Skriv ut serietittel, produksjonår og antall episoder for de 15 eldste
--    TV-seriene i filmdatabasen (sorter stigende etter produksjonår).

SELECT s.seriesid, s.maintitle, s.firstprodyear, COUNT(*) as totalEpisodes
FROM series AS s
  INNER JOIN episode AS e USING(seriesid)
GROUP BY firstprodyear, maintitle
ORDER BY firstprodyear
LIMIT 15;

-- 3) Mange titler har vært brukt i flere filmer. Skriv ut en oversikt over
--    titler som har vært brukt i mer enn 30 filmer. Bak hver tittel skriv antall
--    ganger den er brukt. Ordne linjene med hyppigst forekommende tittel
--    først (12 eller 26)
SELECT f.title, COUNT(*) AS hyppighet
FROM film AS f
GROUP BY (f.title)
HAVING COUNT(*) > 30
ORDER BY hyppighet ASC;

-- 4) Finn de "Pirates of the Caribbean"-filmene som er med i flere enn
--    3 genre (4)

SELECT f.title, COUNT(*) antallGenre
FROM film AS f
  INNER JOIN filmgenre AS g ON (f.filmid = g.filmid)
WHERE f.title LIKE ('%Pirates of the Caribbean%')
GROUP BY (f.title)
HAVING COUNT(g.genre) > 3;


-- 5) Hvilke verdier (fornavn) forekommer hyppigst i firstname-attributtet i
--    tabellen Person? Finn alle fornavn, og sorter fallende etter antall
--    forekomster. Ikke tell med forekomster der fornavn-verdien er tom.
--    Begrens gjerne antall rader (176030 rader, 16108 for flest navn).
SELECT firstname, COUNT(*) AS antallGanger
FROM Person
GROUP BY firstname
HAVING firstname IS NOT NULL
ORDER BY antallGanger DESC
LIMIT 10;

-- 6) Finn filmene som er med i flest genrer: Skriv ut filmid, tittel og antall
--    genre, og sorter fallende etter antall genre. Du kan begrense resultatet
--    til 25 rader.
SELECT f.filmid, f.title, COUNT(*) antallGenre
FROM film AS f
  INNER JOIN filmgenre AS g ON (f.filmid = g.filmid)
GROUP BY (f.filmid, f.title)
ORDER BY antallGenre DESC
LIMIT 25;

-- 7) Lag en oversikt over regissører som har regissert mer enn 5 norske filmer (60)
SELECT fp.personid, p.firstname, p.lastname, COUNT(*) AS filmsDirected
FROM film AS f
  INNER JOIN filmparticipation AS fp ON (f.filmid = fp.filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
  INNER JOIN filmcountry as c ON (f.filmid = c.filmid)
WHERE c.country = 'Norway' AND fp.parttype = 'director'
GROUP BY (fp.personid, p.firstname, p.lastname)
HAVING COUNT(*) > 5;

-- 8) Skriv ut serieid, serietittel og produksjonsår for TV-serier, sortert
--    fallende etter produksjonår. Begrens resultatet til 50 filmer. Tips:
--    Ikke ta med serier der produksjonsåret er null
SELECT seriesid, maintitle, firstprodyear
FROM series
WHERE firstprodyear IS NOT NULL
ORDER BY firstprodyear DESC
LIMIT 50;

-- 9) Hva er gjennomsnittlig score (rank) for filmer med over 100 000 stemmer (votes)?
SELECT avg(rank)
FROM filmrating
WHERE votes > 100000;

-- 10) Hvilke filmer (tittel og score) med over 100 000 stemmer har en høyere
--     score enn snittet blant filmer med over 100 000 stemmer (subspørring!) (20)
SELECT f.title, rank
FROM film AS f
  INNER JOIN filmrating AS r ON (f.filmid = r.filmid)
WHERE votes > 100000 AND rank > (SELECT avg(rank)
                                 FROM filmrating
                                 WHERE votes > 100000);

-- 11) Hvilke 100 verdier (fornavn) forekommer hyppigst i firstname-attributtet
--     i tabellen Person?
SELECT firstname, COUNT(*) hyppighet
FROM person
WHERE firstname <> ''
GROUP BY firstname
ORDER BY hyppighet DESC
LIMIT 100;

-- 12) Hvilke to fornavn forekommer mer enn 6000 ganger og akkurat like mange
--     ganger? (Paul og Peter, vanskelig!)
SELECT firstname, COUNT(*) AS hypighet
FROM person
WHERE firstname <> ''
GROUP BY firstname
HAVING COUNT(*) > 6000;

-- 13) Hvor mange filmer har Tancred Ibsen regissert?

SELECT COUNT(*) AS filmsDirected
FROM person AS p
  INNER JOIN filmparticipation AS f ON (p.personid = f.personid)
  INNER JOIN film AS fm ON (f.filmid = fm.filmid)
WHERE p.firstname = 'Tancred' AND p.lastname = 'Ibsen';

-- 14) Lag en oversikt over regissører mer enn 5 norske filmer

SELECT fp.personid, p.firstname, p.lastname, COUNT(*) AS filmsDirected
FROM film AS f
  INNER JOIN filmparticipation AS fp ON (f.filmid = fp.filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
  INNER JOIN filmcountry as c ON (f.filmid = c.filmid)
WHERE c.country = 'Norway' AND fp.parttype = 'director'
GROUP BY (fp.personid, p.firstname, p.lastname)
HAVING COUNT(*) > 5;

-- 15) Lag en oversikt (filmtittel) over norske filmer med mer enn en regissør.
SELECT f.title, COUNT(*) as TotalDirectors
FROM film AS f
  INNER JOIN filmparticipation AS fp ON (f.filmid = fp.filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
  INNER JOIN filmcountry AS c ON (f.filmid = c.filmid)
WHERE c.country = 'Norway' AND fp.parttype = 'director'
GROUP BY f.filmid, f.title
HAVING COUNT(*) > 1;


-- 16) Finn regissører som har regissert alene mer enn 5 norske filmer (utfordring!) (49)
SELECT p.firstname, p.lastname
FROM film AS f
  INNER JOIN filmparticipation AS fp ON (f.filmid = fp.filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
  INNER JOIN filmcountry AS c ON (f.filmid = c.filmid)
WHERE c.country = 'Norway'
  AND fp.parttype = 'director'
  AND fp.filmid NOT IN
    ( SELECT filmid
      FROM Filmcountry
          NATURAL JOIN Film
          NATURAL JOIN Filmparticipation
          NATURAL JOIN Person
      WHERE country = 'Norway'
      AND parttype = 'director'
      GROUP BY filmid, title
      HAVING COUNT(*) > 1 )
GROUP BY fp.personid, p.firstname, p.lastname
HAVING COUNT(*) > 5;

-- 17) Finn tittel, produksjonsår og filmtype for alle kinofilmer som ble
--     produsert i året 1893 (4)
SELECT f.title, f.prodyear, fi.filmtype
FROM film AS f
  INNER JOIN filmitem AS fi USING(filmid)
WHERE fi.filmtype = 'C' AND prodyear = 1893;


-- 18) Finn navn på alle skuespillere (cast) i filmen Baile Perfumado (14)
SELECT p.firstname, p.lastname
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE f.title = 'Baile Perfumado' AND fp.parttype = 'cast';

-- 19) Finn tittel og produksjonsår for alle filmene som Ingmar Bergman har vært regissør
--     (director) for. Sorter tuplene kronologisk etter produksjonår (62).
SELECT  f.title, f.prodyear
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE fp.parttype = 'director'
  AND p.firstname = 'Ingmar'
  AND p.lastname = 'Bergman'
ORDER BY f.prodyear ASC;

-- 20) Finn produksjonsår for første og siste film Ingmar Bergman reggirte.
(SELECT f.prodyear
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE fp.parttype = 'director'
  AND p.firstname = 'Ingmar'
  AND p.lastname = 'Bergman'
ORDER BY f.prodyear DESC
LIMIT 1)
UNION (
SELECT f.prodyear
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE fp.parttype = 'director'
  AND p.firstname = 'Ingmar'
  AND p.lastname = 'Bergman'
ORDER BY f.prodyear ASC
LIMIT 1);

-- 21) Finn tittel og produksjonsår for de filmene hvor mer enn 300 personer
--     har deltatt, uansett hvilken funksjon de har hatt (11)
SELECT f.title, f.prodyear
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
GROUP BY fp.filmid, f.title, f.prodyear
HAVING COUNT(*) > 300;

-- 22) Finn oversikt over regissører som har regissert kinofilmer over et stort
--     tidspenn. I tillegg til navn, ta med antall kinofilmer og første og siste
--     år (prodyear) personen hadde regi. Skriv ut alle som har et tidsintervall
--     på mer enn 49 år mellom første og siste film og sorter dem etter lenden
--     på dette tidsintervallet,  de lengste først (230)


-- 23) Finn filmid, tittel og antall medregissører (parrtype "director") (0 der
--     han har regissert alene) for filmer som Ingmar Bergman har reggisert
SELECT f.title, f.prodyear, COUNT(*) as AntallMedregissører
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE fp.parttype = 'director'
  AND p.firstname = 'Ingmar'
  AND p.lastname = 'Bergman'
GROUP BY f.title, f.prodyear, fp.personid;

-- 24) Finn filmid, antall involverte personer, produksjonsår og rating for alle
--     filmer som Ingmar Bergman har regissert. Ordne kronologisk etter
--     produksjonår.

SELECT f.title, f.prodyear, COUNT(*) as cast, fr.rank
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN filmrating AS fr USING (filmid)
WHERE fp.filmid IN (
          SELECT fp.filmid
          FROM film AS f
            INNER JOIN filmparticipation AS fp USING (filmid)
            INNER JOIN person AS p ON (fp.personid = p.personid)
          WHERE fp.parttype = 'director'
            AND p.firstname = 'Ingmar'
            AND p.lastname = 'Bergman'
          GROUP BY fp.filmid)
AND fr.rank IS NOT NULL
GROUP BY fp.filmid, f.title, f.prodyear, fr.rank;

-- 25) Finn produksjonsår og tittel for alle filmer som både Angelina Jolie
--     og Antonio Banderas har deltatt i sammen.

WITH Angelina_jolie AS
    (
    SELECT fp.filmid
    FROM film AS f
      INNER JOIN filmparticipation AS fp USING (filmid)
      INNER JOIN person AS p ON (fp.personid = p.personid)
    WHERE p.firstname = 'Angelina' AND p.lastname = 'Jolie'
    ),
    Antonio_Banderas AS
    (
    SELECT fp.filmid
    FROM film AS f
      INNER JOIN filmparticipation AS fp USING (filmid)
      INNER JOIN person AS p ON (fp.personid = p.personid)
    WHERE p.firstname = 'Antonio' AND p.lastname = 'Banderas'
    ),
    result AS (
     SELECT *
     FROM Angelina_jolie AS a
      NATURAL JOIN Antonio_Banderas
    )
SELECT f.title, f.prodyear
FROM film AS f
WHERE f.filmid IN (SELECT * FROM result);

-- 26) Finn tittel, navn og roller for personer for personer som har hatt mer
--     enn en rolle i samme film, blant kinofilmer som ble produsert i 2003.
--     (Med forskjellige roller mener vi cast, director, producer. Vi skal
--      altså ikke ha med de som har to ulike cast-roller).

-- 27) Finn navn og antall filmer for personer som har deltatt i mer enn 15
--     filmer i 2008, 2009 eller 2010, men som ikke har deltatt i noen filmer
--     i 2005.
SELECT p.firstname, p.lastname, COUNT(*) antallFilmer
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
WHERE f.prodyear IN (2008, 2009, 2010) AND f.prodyear != 2005
GROUP BY (fp.personid, p.firstname, p.lastname)
HAVING COUNT(fp.personid) > 15;

-- 28) Finn navn på regissør og filmtittel for filmer hvor mer enn 200 personer
--     har deltatt, uansett hvilken funksjon de har hatt. Ta ikke med filmer
--     som har hatt flere (mer enn en) regissører.
SELECT f.title
FROM Film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
GROUP BY fp.filmid, f.title
HAVING COUNT(*) > 200 AND COUNT(p.personid
