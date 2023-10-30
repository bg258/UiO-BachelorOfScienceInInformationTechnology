/*
                                 marktz
                    IN2090 - Obligatorisk oppgave 4
                                 SQL 2                                        */

-- Denne oppgaven skal løses med filmdatabasen.
-- Oppgave 0
SELECT COUNT(*) FROM film; -- 692361 rader

-------------------------------------------------------------------------------

-- Oppgave 1
-- Skriv ut en tabell med to kolonner, først rollefigurnavn, så antall
-- ganger dette rollefigurnavnet forekommer i filmcharacter-tabellen. Ta
-- bare med navn som forekommer mer enn 2000 ganger. Sorter etter fallende
-- hyppighet. (90/91 rader)

-- Forklaring: Henter filmparticipation- og filmcharacter tabellen. Jeg
-- grupperer dem i filmcharacter. På denne måten vil vi da vite hvor mange
-- ganger dette "karakteret" spilles. Sist, men ikke minst, setter vi en
-- begrensning som sier at vi skal hente de navnet som forekommer mer enn
-- 2000 ganger. Vi ender opp med 91 rader til sammen.

SELECT c.filmcharacter, COUNT(*) AS hyppighet
FROM filmparticipation AS p
  INNER JOIN filmcharacter AS c USING (partid)
GROUP BY c.filmcharacter
HAVING COUNT(p.partid) > 2000
ORDER BY hyppighet DESC;

-------------------------------------------------------------------------------

-- Oppgave 2
-- Skriv ut filmtittel og produksjonsår for filmer som Stanley Kubrick har
-- registrert ("director"). (16 rader)

-- Løs oppgaven med:
-- 2a) INNER JOIN
-- 2b) NATURAL JOIN
-- 2C) IMPLISITT JOIN
-- Tips: Personer som har deltatt i en film finnes i tabellen filmparticipation.
-- Navn finnes i person.

-- Forklaring: For å løse denne oppgaven, det eneste vi tar i bruk er INNER JOIN.
-- Vi tar i bruk film-, filmparticipation- og person-tabellen. Vi "joiner" dem
-- med sine respektive attributer. Deretter, setter vi en begrensning som sier
-- at vi skal bare hente de filmene som regissøren "Stanley Kubrick" har regissert.

-- 2a) INNER JOIN
SELECT f.title AS filmtittel, f.prodyear AS produksjonsår
FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p USING (personid)
WHERE fp.parttype = 'director' AND
      p.firstname = 'Stanley' AND
      p.lastname = 'Kubrick'
ORDER BY produksjonsår DESC;

-- Forklaring: Denne gangen for å løse denne oppgaven, det eneste vi tar i bruk
-- er NATURAL JOIN som vil joine automatisk der attributene har likt navn. Vi
-- setter samme begrensning som i forrige oppgave.

-- 2b) NATURAL JOIN
SELECT title AS filmtittel , prodyear AS produksjonsår
FROM film
  NATURAL JOIN filmparticipation AS fp
  NATURAL JOIN person AS p
WHERE parttype = 'director' AND
      firstname = 'Stanley' AND
      lastname = 'Kubrick'
ORDER BY produksjonsår DESC;

-- Sist, men ikke minst, vil vi løse denne oppgaven ved hjelp av IMPLISITT JOIN.
-- Dette er et litt mer komplisert oppgave, siden vi må sørge for at vi joiner
-- tabellene på en riktig måte. Dette gjør vi i WHERE-klausen, hvor vi ser at
-- filmens sin ID må vøre likt filmid i filmparticipation-tabellen. I tillegg
-- må personens ID matche personens ID som ligger i filmparticipation-tabellen.
-- Sist, setter vi samme begrensning som i de to forrige oppgavene (2a og 2b)

-- 2c)IMPLISITT JOIN
SELECT f.title AS filmtittelm, f.prodyear AS produksjonsår
FROM film AS f,
     filmparticipation AS fp,
     person AS p
WHERE f.filmid = fp.filmid AND
      fp.personid = p.personid AND
      fp.parttype = 'director' AND
      p.firstname = 'Stanley' AND
      p.lastname = 'Kubrick'
ORDER BY produksjonsår DESC;

-------------------------------------------------------------------------------

-- Oppgave 3
-- Skriv ut personid og fullt navn til personer med fornavnet Ingrid (i person)
-- som har spilt rollen Ingrid (i filmcharacter). Fullt navn skal returneres
-- i en kolonne, ved å konkatenere fornavn med etternavn på formatet
-- "FORNAVN ETTERNAVN". Ta også med filmtittelen det gjelder og hvilket land
-- filmen er produsert i (fra filmcountry). (14 rader)

-- Forklaring: For å løse følgende oppgave, tar vi i bruk 5 ulike tabeller.
-- Når vi har "joinet" sammen alle disse tabellene, setter vi en begrensning på
-- at vi ser etter de personer som har "Ingrid" som første navn, men som også
-- har spilt en film karakter med samme navnet, nemlig "Ingrid". Vi får et
-- resultat av 14 rader til sammen.

SELECT p.firstname || ' ' || p.lastname AS fullname,
       f.title AS filmtittel,
       c.country AS produsert_i
FROM filmparticipation AS fp
  INNER JOIN filmcharacter AS fc ON (fp.partid = fc.partid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
  INNER JOIN film AS f ON (fp.filmid = f.filmid)
  INNER JOIN filmcountry AS c ON (fp.filmid = c.filmid)
WHERE p.firstname = 'Ingrid' AND
      fc.filmcharacter = 'Ingrid';

-------------------------------------------------------------------------------

-- Oppgave 4
-- Skriv ut filmid, tittel og antall sjangre (fra filmgenre) for filmer som
-- inneholder tekststrengen "Antoine " (legg merke til mellomrom etter "Antoine".)
-- Husk å også få med filmer uten sjanger. (17 rader, hvorav 4 har flere enn 0 sjangre)

-- Forklaring: Siden i denne oppgaven, skal vi returnere filmid, tittel og antall
-- sjangre for filmer som inneholder tekststrengen "Antoine " kan vi tenke oss
-- at det kan hende at noen filmer ikke har noen sjangre. Derfor "joiner" vi
-- film-tabellen med filmgenre med en "LEFT OUTER JOIN". Dette vil sørge for
-- at vi får returnert filmid og tittel, uansett om filmen har 0 sjangre.

SELECT f.filmid AS ID,
       f.title AS filmtittel,
       COUNT(g.filmid) AS antall_sjangre
FROM film AS f
  LEFT OUTER JOIN filmgenre AS g USING (filmid)
WHERE f.title LIKE ('%Antoine %')
GROUP BY f.filmid, f.title
ORDER BY antall_sjangre DESC;

-------------------------------------------------------------------------------

-- Oppgave 5
-- Finn antall deltagere i hver deltagelsestype (parttype) per film blant kino
-- filmer som har "Lord of the Rings" som del av tittelen (hint: kinofilmer
-- har filmtype "C" i tabellen filmitem. Skriv ut filmtittel, deltagelsestype og
-- antall deltagere). (27 rader)

-- Forklaring: For å løse følgende oppgave tar vi i bruk film-, filmitem og
-- filmparticipation-tabellen. Vi seter en begrensning på at vi vil bare se
-- etter filmer som tilhører "kino"-typen og at filmen skal inneholde "Lord of
-- the rings" som en del av tittelen. Deretter grupperer vi resultatet etter
-- filmid, tittel og parttype. Vi returner en tabell med tittel, deltagelsestype
-- og hvor mange deltagere denne typen inneholder.

SELECT f.title AS filmtittel,
       fp.parttype AS deltagelsestype,
       COUNT(fp.personid) AS antall_deltagere
FROM film AS f
  INNER JOIN filmitem AS i USING (filmid)
  INNER JOIN filmparticipation AS fp USING (filmid)
WHERE i.filmtype = 'C' AND
      f.title LIKE ('%Lord of the Rings%')
GROUP BY fp.filmid,
         f.title,
         fp.parttype
ORDER BY f.title, antall_deltagere ASC;

-------------------------------------------------------------------------------

-- Oppgave 6
-- Tittel og produksjonsår for alle filmene som ble utgitt i det laveste
-- produksjonsåret. Spørringen kan ikke anta at du vet antall filmer dette
-- gjelder (IKKE BRUK LIMIT) (2.rader)

-- Forklaring: For å løse denne oppgaven har jeg tatt i bruk IN-metoden, som
-- henter ut den minste produksjonsår fra film-tabellen og bruker den for å
-- hente alle filmer med det respektive produksjonsår. Vi ender opp med 2 filmer.

/*
title             | prodyear
-------------------------------+----------
Roundhay Garden Scene         |     1888
Traffic Crossing Leeds Bridge |     1888

(2 rows)
*/

SELECT title, prodyear
FROM film
WHERE prodyear IN (
  SELECT MIN(prodyear)
  FROM film
);

-------------------------------------------------------------------------------

-- Oppgave 7
-- Finn tittel og produksjonsår på filmer som både er med i sjangeren
-- "Film Noir" og "Comedy" (3 rader)

-- Forklaring: Siden oppgaven ber oss om å finne tittel og produksjonsår for
-- de filmene som er både i sjangeren "Film-noir" og "Comedy", min løsning
-- går ut på at jeg finner først alle filmid for filmene som tilhører "Film-noir"
-- sjangeren. Derretter finner jeg alle filmid som tilhører "Comedy" sjangeren.
-- Nå som vi har to tabeller kan vi da ta snittet av dem (INSERSECT), for å
-- få fellesID.

SELECT title, prodyear
FROM film
WHERE filmid IN (
  (SELECT f.filmid
  FROM film AS f
    INNER JOIN filmgenre AS g USING (filmid)
  WHERE g.genre = 'Film-Noir')
  INTERSECT
  (SELECT f.filmid
   FROM film AS f
      INNER JOIN filmgenre AS g USING (filmid)
   WHERE g.genre = 'Comedy')
)
ORDER BY prodyear ASC;

-------------------------------------------------------------------------------

-- Oppgave 8
-- Lag en spørring som returnerer tittel og produksjonsår for alle filmer
-- fra både oppgave 6 og 7. (5 rader)

-- Forklaring: Denne oppgaven var litt grei, siden jeg bare tok løsningene
-- jeg hadde på oppgave 6 og oppgave 7 og tok union av de ;)

-- Løsning
WITH
  oppgave_6 AS (
    SELECT title, prodyear
    FROM film
    WHERE prodyear IN (
      SELECT MIN(prodyear)
      FROM film
    )
  ),
  oppgave_7 AS (
    SELECT title, prodyear
    FROM film
    WHERE filmid IN (
      (SELECT f.filmid
      FROM film AS f
        INNER JOIN filmgenre AS g USING (filmid)
      WHERE g.genre = 'Film-Noir')
      INTERSECT
      (SELECT f.filmid
       FROM film AS f
          INNER JOIN filmgenre AS g USING (filmid)
       WHERE g.genre = 'Comedy')
    )
  )
(SELECT *
 FROM oppgave_6)
UNION
(SELECT *
 FROM oppgave_7);

-------------------------------------------------------------------------------

-- Oppgave 9
-- Finn tittel og produksjonsår for alle filmer der Stanley Kubrick både
-- hadde parrtype director og cast (ref oppgave 2) (2 rader)

-- Forklaring: Siden oppgaven ber oss om å finne tittel og produksjonsår for
-- de filmene som Stanley Kubrick både hadde parttype director og cast, min løsning
-- går ut på at jeg finner først alle filmid for filmene som han var "director" i
-- Derretter finner jeg alle filmid som han var "cast" i. Nå som vi har to
-- tabeller kan vi da ta snittet av dem (INSERSECT), for å få fellesID på
-- disse filmene.

SELECT f.title AS filmtittel, f.prodyear AS produksjonsår
FROM film AS f
WHERE filmid IN (
  (SELECT f1.filmid
   FROM film AS f1
     INNER JOIN filmparticipation AS fp USING (filmid)
     INNER JOIN person AS p USING (personid)
   WHERE fp.parttype = 'director' AND
         p.firstname = 'Stanley' AND
         p.lastname = 'Kubrick')
  INTERSECT

  (SELECT f2.filmid
   FROM film AS f2
     INNER JOIN filmparticipation AS fp USING (filmid)
     INNER JOIN person AS p USING (personid)
   WHERE fp.parttype = 'cast' AND
         p.firstname = 'Stanley' AND
         p.lastname = 'Kubrick')
);

-------------------------------------------------------------------------------

-- Oppgave 10
-- Hvilke TV-serier  med flere enn 1000 brukerstemmer (votes) har fått
-- den høyeste scoren (rank) blant slike serier? Skriv ut maintitle (3 rader)
-- Tips: TV-serier finnes i tabellen series, og informasjon om brukerstemmer
--       og score i filmrating. Husk at man kan bruke WITH dersom man vil
--       gjenbruke en spørring.

-- Forklaring: Det første jeg gjør er at jeg "joiner" sammen series-tabellen og
-- filmrating-tabellen. Deretter setter jeg en begrensning som ser etter alle
-- TV-serier med flere enn 1000 brukerstemmer som har fått den høyeste
-- ranken blant disse TV-serier. Dette setter jeg i en liten "subspørring"

SELECT s.maintitle AS title, r.rank
FROM series AS s
  INNER JOIN filmrating AS r ON (s.seriesid = r.filmid)
WHERE r.votes > 1000 AND
      r.rank = (
        SELECT MAX(rank)
        FROM filmrating
        WHERE votes > 1000
      )
ORDER BY s.maintitle;

-------------------------------------------------------------------------------

-- Oppgave 11
-- Hvilke land forekommer bare en gang i tabellen filmcountry? Resultatet
-- skal kun ha en kolonne som inneholder navnene på landene. (9 rader)

SELECT country
FROM filmcountry
GROUP BY country
HAVING COUNT(*) = 1;

-------------------------------------------------------------------------------

-- Oppgave 12
-- I tabellen filmcharacter kan vi si at unike rollenavn er rollenavn som bare
-- forekommer en gang i tabellen. Hvilke skuespillere (navn og antall filmer)
-- har spilt figurer med unikt rollenavn i mer enn 199 filmer? ( 3 eller 13 rader


-- Denne tabellen vil da ha alle unike rollenavn som bare forekommer
-- en gang i filmcharacter-tabellen.

WITH
  unike_rollenavn AS (
    SELECT filmcharacter
    FROM filmcharacter
    GROUP BY filmcharacter
    HAVING COUNT(*) = 1
  ),
  -- Derreter vil dette være vårt "siste" versjon av tabellen, siden
  -- denne henter partid-en til disse film-filmcharacters fra forrige tabell.
  -- Dette gjør vi ved å joine den sammen med filmcharacter-tabellen hvor
  -- filmcharacteren er likt.

  ID_til_rollenavn AS (
    SELECT partid
    FROM filmcharacter AS fc
      INNER JOIN unike_rollenavn AS ur ON (fc.filmcharacter = ur.filmcharacter)
  )

-- Sist, men ikke minst, vil vi hente navnet på personen som har spilt mer enn
-- 199 unike roller med ulik rollenavn.

SELECT format('%s %s', p.firstname, p.lastname) AS full_name,
       COUNT(*) AS num_of_roles
FROM filmparticipation AS fp
  INNER JOIN ID_til_rollenavn AS ur USING (partid)
  INNER JOIN person AS p ON (fp.personid = p.personid)
GROUP BY full_name
HAVING COUNT(*) > 199
ORDER BY num_of_roles DESC;

-------------------------------------------------------------------------------

-- Oppgave 13
-- Fornavn og etternavn på personer på personer som har registrert filmer
-- over 60 000 stemmer, der alle disse filmene har fått en score (rank) på 8
-- eller høyere. (49 rader)

-- Forklaring:
-- Lager 2 ulike tabeller. Den ene tabellen (directors_with_60000_votes) vil
-- inneholde en tabell med alle navn på regissører med filmer med over
-- 60000 votes (stemmer).

-- Den andre tabellen, inneholder da navn på alle regissører med filmer over
-- 60000 votes men med en rank på mindre enn 8.

-- Siden vi bare ser etter navn på regissører hvor alle filmene de har regissert
-- er over 8+, kan vi ta differansen av første tabell med den andre. På denne
-- måten vil vi da ha alle de 49 navnene hvor alle filmene de har regissert har
-- en rank på 8+

WITH
  directors_with_60000_votes AS (
    SELECT format('%s %s', p.firstname, p.lastname) AS fullname
    FROM filmparticipation AS fp
      INNER JOIN film AS f USING (filmid)
      INNER JOIN filmrating AS r USING (filmid)
      INNER JOIN person AS p USING(personid)
    WHERE fp.parttype = 'director' AND
          r.votes > 60000
    GROUP BY fullname
  ),

  directors_with_less_than_8_rank AS (
    SELECT format('%s %s', p.firstname, p.lastname) AS fullname
    FROM filmparticipation AS fp
      INNER JOIN film AS f USING (filmid)
      INNER JOIN filmrating AS r USING (filmid)
      INNER JOIN person AS p USING(personid)
    WHERE fp.parttype = 'director' AND
          r.votes > 60000 AND
          r.rank < 8
    GROUP BY fullname
  )
(SELECT *
 FROM directors_with_60000_votes)
EXCEPT
(SELECT *
 FROM directors_with_less_than_8_rank);

 -------------------------------------------------------------------------------
