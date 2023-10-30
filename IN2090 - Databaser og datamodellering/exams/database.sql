CREATE TABLE barn(
  bid int PRIMARY KEY,
  navn text NOT NULL,
  snill BOOLEAN NOT NULL
);


INSERT INTO barn
VALUES (0, 'Ola', true),
       (1, 'Kari', true),
       (2, 'Per', false),
       (3, 'Nils', true),
       (4, 'Mari', false),
       (5, 'Kine', false),
       (6, 'Jasmin', true);


CREATE TABLE gave(
  gid int PRIMARY KEY,
  navn text NOT NULL,
  nyttig boolean NOT NULL
);

INSERT INTO gave
VALUES (0, 'Lekebil', false),
      (1, 'Sokker', true),
      (2, 'Sykkel', true),
      (3, 'Lekepistol', false),
      (4, 'Dataspill', false),
      (5, 'Fuglebrett', true),
      (6, 'Dukke', false),
      (7, 'Bok', true);

CREATE TABLE ønskeliste(
  barn int REFERENCES barn(bid),
  gave int REFERENCES gave(gid)
);

INSERT INTO ønskeliste
VALUES (1, 0),
       (1, 6),
       (0, 6),
       (0, 5),
       (3, 2),
       (5, 1),
       (5, 3),
       (5, 4),
       (4, 3),
       (4, 0),
       (6, 7);

-- Oppgave 5 - Snille barn(5)
-- Skriv en SQL-kommando som oppdaterer barnet med bid lik 0 sin snill -verdi
-- til false
UPDATE barn
SET snill = false
WHERE bid = 0;

-- Oppgave 6 - Nyttige gaver (5)
-- Skriv en spørring som finner alle barn som ønsker seg nyttige gaver som
-- har navn som starter med strengen 'Sokker'. Spørringen skal returnere
-- navnet på barnet og navnet på gaven
SELECT b.navn, g.navn
FROM ønskeliste AS s
  INNER JOIN barn AS b ON (s.barn = b.bid)
  INNER JOIN gave AS g ON (s.gave = g.gid)
WHERE g.navn LIKE 'Sokker%';

-- Oppgave 7 - Oversikts View
-- Skriv en SQL-kommando som lager et VIEW som heter oversikt og inneholder
-- én rad for for hvert ønske bid og navnet på barnet som har ønsket, gid og
-- navnet på gaven som er ønsket, hvorvidt barnet har vært snill og hvorvidt
-- gaven er nyttig. VIEWet skal være sortert først på på barnets navn, og så
-- på gavens navn i alfabetisk rekkefølge.

CREATE VIEW oversikt AS
SELECT b.bid, b.navn as barnN, g.gid, g.navn, b.snill, g.nyttig
FROM ønskeliste AS s
  INNER JOIN barn AS b ON (s.barn = b.bid)
  INNER JOIN gave AS g ON (s.gave = g.gid)
ORDER BY barnN, g.navn;

-- Oppgave 8 - Like ønsker
-- SKriv en SQL-spørring som finner alle par av ulike barn som har ønsket
-- seg det samme. Svaret skal kun inneholde unike rader. Du kan benytte VIEWet
-- fra oppgave 7 om du ønsker.
WITH
  par AS (
    SELECT DISTINCT b1.bid AS barn1, b2.bid AS barn2
    FROM barn b1, barn b2
    WHERE b1.bid != b2.bid
  )

SELECT
FROM ønskeliste AS o


-- Oppgave 9 - Populære gaver
-- Skriv en spørring som finner de tre mest populære nyttige gavene, og de tre
-- mest populære unyttige gavene. Resultatet skal inneholde navn på gaven, antall
-- barn som ønsker gaven, samt hvorvidt den er nyttig eller ikke. Du kan benytte
-- view’et fra oppgave 7.

(SELECT 'Popular', navn, COUNT(*) AS antall, COUNT(nyttig) AS nyttig
FROM oversikt
GROUP BY navn
ORDER BY antall DESC, nyttig DESC
LIMIT 3)

UNION

(SELECT 'Unyttige', navn, COUNT(*) AS antall, nyttig
FROM oversikt
GROUP BY navn, nyttig
ORDER BY antall, nyttig ASC
LIMIT 3);

-- Oppgave 10 - Gaveliste
-- Skriv en spørring som tilordner gaver til barn i henhold til følgende regler:
-- Snille barn får alt de ønsker seg
-- Usnille får kun nyttige ting de ønsker seg. Om de ikke ønsker seg noen
-- nyttige ting får de gaven med navn 'Genser'.

WITH
  snille_barn AS (
    SELECT 'Snille barn', b.navn, g.navn AS gave
    FROM ønskeliste AS s
      INNER JOIN barn AS b ON (s.barn = b.bid)
      INNER JOIN gave AS g ON (s.gave = g.gid)
    WHERE b.snill = 1
  ),
  usnille_gaver AS (
    SELECT 'Usnille', b.navn, g.navn AS gave
    FROM ønskeliste AS s
      INNER JOIN barn AS b ON (s.barn = b.bid)
      INNER JOIN gave AS g ON (s.gave = g.gid)
    WHERE g.nyttig = true AND
          b.snill = 0
  ),
  genser AS (
    SELECT 'Usnille', b.navn, 'Genser' AS gave
    FROM ønskeliste AS s
      INNER JOIN barn AS b ON (s.barn = b.bid)
      INNER JOIN gave AS g ON (s.gave = g.gid)
    WHERE g.nyttig = false AND
          b.snill = 0
  ),
  resultat AS (
    SELECT *
    FROM genser
    UNION
    SELECT *
    FROM usnille_gaver;
  )
