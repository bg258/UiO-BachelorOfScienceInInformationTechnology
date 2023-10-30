CREATE TABLE database.land(
  lid int PRIMARY KEY,
  navn text NOT NULL
);

INSERT INTO database.land
VALUES (1, 'Norge'),
       (2, 'Frankrike'),
       (3, 'Italia'),
       (4, 'Tyskland'),
       (5, 'Sverige'),
       (6, 'Storbritannia'),
       (7, 'USA');

CREATE TABLE database.by(
  bid int PRIMARY KEY,
  navn text NOT NULL,
  lid int REFERENCES database.land(lid)
);

INSERT INTO database.by
VALUES (1, 'Oslo', 1),
       (2, 'Kristiansand', 1),
       (3, 'Bergen', 1),
       (4, 'Roma', 3),
       (5, 'Firenze', 3),
       (6, 'Paris', 2),
       (7, 'Lyon', 2),
       (8, 'Berlin', 4),
       (9, 'Brenen', 4),
       (10, 'Hamburg', 4),
       (11, 'Stockholm', 5),
       (12, 'Gøteborg', 5),
       (13, 'London', 6),
       (14, 'New York', 7);

CREATE TABLE database.poi(
  pid int PRIMARY KEY,
  navn text NOT NULL,
  adresse TEXT,
  bid int REFERENCES database.by(bid),
  type text not null
);

INSERT INTO database.poi
VALUES (1, 'Eiffeltårnet', '5 avenue Anatole', 6, 'Kulturminne'),
       (2, 'Eiffeltårnets bygning', '6 avenue Anatole', 6, 'Kaffe'),
       (3, 'Paris de la mouer', '7 avenue Anatole', 6, 'Kaffe'),
       (4, 'Eiffeltårnets bygning', '6 avenue Anatole', 6, 'Kaffe'),
       (5, 'Liberte', '5 avenue Anatole', 7, 'Utsikt'),
       (6, 'Liberte bygning', '6 avenue Anatole', 7, 'Kaffe'),
       (7, 'Liberte 2', '7 avenue Anatole', 7, 'Kaffe'),
       (8, 'Liberte 3', '6 avenue Anatole', 7, 'Kaffe');




CREATE TABLE database.væermelding(
  bid int REFERENCES database.by(bid),
  dato date,
  nedbør float NOT NULL,
  vind int NOT NULL,
  PRIMARY KEY(bid, dato)
);

INSERT INTO database.væermelding
VALUES (6, '2020-12-17', 0.0, 3),
       (7, '2020-12-17', 0.0, 3);




/*
Oppgave 6Italiensk værmelding (5)

Skriv en SQL-spørring som finner morgendagens (17.12.2020) værmelding for alle
byer i Italia. Spørringen skal skrive ut navnet på byen, antall millimeter regn
og vindstyrken. Sorter resultatet alfabetisk på bynavn.*/
SELECT b.navn, v.nedbør, v.vind
FROM land AS l
  INNER JOIN by AS b USING (lid)
  INNER JOIN værmelding AS v ON (b.bid = v.bid)
WHERE l.navn = 'Italia' AND
      v.dato = '2020-12-17'
ORDER BY b.navn ASC;


--
/*
Oppgave 7Ukesmelding for jula (5)

Skriv en SQL-spørring som finner navn, totalt antall millimeter nedbør og
gjennomsnittlig vindstyrke i romjulsuka (altså fra og med dato 24.12.2020 til
  og med dato 31.12.2020) for hver by.*/


SELECT b.navn, SUM(v.nedbør), AVG(v.vind) AS avg_vindstyrke
FROM land AS l
  INNER JOIN by AS b USING (lid)
  INNER JOIN væermelding AS v ON (b.bid = v.bid)
WHERE v.dato >= '2020-12-24' AND
      v.dato <= '2020-12-31'
GROUP BY b.lid, b.navn; -- Kunne også brukt b.lid (id til hver by)

/*
Oppgave 8Byer uten regn og vind (5)

Skriv en SQL-spørring som finner navn på alle byer hvor det ikke er meldt noe
regn og ikke noe vind fra og med julaften (24.12.2020) og ut året. Spørringen
skal skrive ut navnet på byene. Du kan anta at vi har værmelding (og både nedbør
  og vindstyrke) for alle byer hver dag i julen. */

SELECT DISTINCT b.navn
FROM land AS l
  INNER JOIN by AS b USING (lid)
  INNER JOIN værmelding AS v ON (b.bid = v.bid)
WHERE v.dato >= '2020-12-24' AND
      v.dato <= '2020-12-31'
GROUP BY b.lid, b.navn
HAVING SUM(v.nedbør) = 0 AND
       SUM(v.vind) = 0;

/*

Oppgave 9Steder og vær (10)

Skriv en SQL-kommando som lager et VIEW med navn "Steder" som viser dagens
værmelding (nedbør i mm. og vindstyrke) for både byer og POIs i samme tabell.
Du kan anta at dagens dato finnes i variabelen "current_date" (slik som i PostgreSQL).

VIEWet skal ha 4 kolonner, en med navnet på stedet, en med plassering som er landet
dersom stedet er en by og adressen dersom stedet er en POI, samt nedbør og vindstyrke.
For POIs er nedbør og vindstyrke lik byen den befinner seg i sin nedbør og vindstyrke.
Vi er kun interessert i steder som faktisk har en posisjon, altså skal posisjon
aldri være NULL. F.eks. kan innholdet i VIEWet se slik ut: */


CREATE VIEW Steder AS
SELECT b.navn AS navn, l.navn AS posisjon, v.nedbør, v.vind
FROM land AS l
  INNER JOIN by AS b USING (lid)
  INNER JOIN væermelding AS v ON (b.bid = v.bid)
WHERE v.dato = current_date
UNION
SELECT p.navn, p.adresse, v.nedbør, v.vind
FROM poi AS p
  INNER JOIN by AS b USING (bid)
  INNER JOIN væermelding AS v ON (b.bid = v.bid)
WHERE v.dato = current_date AND
      p.adresse IS NOT NULL;

/*
La oss seie at du skal reise på ferie til Frankrike og ønsker å finne ut kva
for ein by du skal reise til for å gå tur og sjå på musea. Skriv derfor ei
SQL-spørjing som finnar den byen i Frankrike med opphald (0 mm. nedbør) i morgon
(17.12.2020), som har minst 3 kaféar og som har flest musea. */

-- Jeg er litt usikker på hvordan jeg skal se etter museumer, så jeg antar
-- at denne typen er satt til å være "Kulturminner". Hvis dette ikke
-- er tilfelle, er det bare å forandre Kulturminne med det som tilsvarer museumer.

WITH byer AS (
    SELECT DISTINCT b.bid
    FROM land AS l
      INNER JOIN by AS b USING (lid)
      INNER JOIN værmelding AS v ON (b.bid = v.bid)
      INNER JOIN poi AS p ON (b.bid = p.bid)
    WHERE l.navn = 'Frankrike' AND
          v.nedbør = 0 AND
          v.dato = '2020-12-17' AND
          p.type = 'Kafé'
    GROUP BY b.bid, p.type
    HAVING COUNT(*) > 2
  )
SELECT b.navn
FROM poi AS p
  INNER JOIN byer AS c USING (bid)
  INNER JOIN by AS b USING (bid)
WHERE p.type = 'Museum' -- Kulturminne
GROUP BY c.bid, b.navn, p.type
ORDER BY p.type DESC;
