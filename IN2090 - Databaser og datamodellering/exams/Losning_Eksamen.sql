CREATE TABLE barn(
  bid int PRIMARY KEY,
  navn text NOT NULL,
  snill boolean NOT NULL
);

CREATE TABLE gave(
  gid int PRIMARY KEY,
  navn text NOT NULL,
  nyttig boolean NOT NUll
);

CREATE TABLE ønskeliste(
  barn int REFERENCES barn(bid),
  gave int REFERENCES gave(gid)
);

-- 5. Snille barn (5)
-- Skriv en SQL-kommando som oppdaterer barnet med bid lik 0 sin snill-verdi
-- til false.

-- Løsningsforslag
UPDATE barn
SET snill = false
WHERE bid = 0;

-- Oppgave 6 - Nyttige gaver (5)
-- Skriv en spørring som finner alle barn som ønsker seg nyttige gaver som
-- har navn som starter med strengen 'Sokker'. Spørringen skal returnere
-- navnet på barnet og navnet på gaven
SELECT b.navn AS barn, g.navn AS gave
FROM barn AS b
  INNER JOIN ønskeliste AS ø ON (b.bid = ø.barn)
  INNER JOIN gave AS ø ON (ø.gave = g.gid)
WHERE g.nyttig AND g.navn LIKE 'Sokker%';


-- Oppgave 7 - Oversikts View
-- Skriv en SQL-kommando som lager et VIEW som heter oversikt og inneholder
-- én rad for for hvert ønske bid og navnet på barnet som har ønsket, gid og
-- navnet på gaven som er ønsket, hvorvidt barnet har vært snill og hvorvidt
-- gaven er nyttig. VIEWet skal være sortert først på på barnets navn, og så
-- på gavens navn i alfabetisk rekkefølge.

CREATE VIEW oversikt AS
SELECT b.bid, b.navn AS barn, g.gid, g.navn AS gave, b.snill, g.nyttig
FROM barn AS b
  INNER JOIN ønskeliste AS ø ON (b.bid = ø.barn)
  INNER JOIN gave AS g ON (ø.gave = g.gid)
ORDER BY barn, gave;

-- Oppgave 8 - Like ønsker
-- SKriv en SQL-spørring som finner alle par av ulike barn som har ønsket
-- seg det samme. Svaret skal kun inneholde unike rader. Du kan benytte VIEWet
-- fra oppgave 7 om du ønsker.

WITH
  likt_ønske AS (
    SELECT b1.barn AS barn1, b2.barn AS barn2
    FROM ønskeliste AS b1
      INNER JOIN ønskeliste AS b2 USING (gave)
    WHERE b1.barn != b2.barn
  )
SELECT DISTINCT b1.navn, b2.navn
FROM likt_ønske AS l
  INNER JOIN barn AS b1 ON (l.barn1 = b1.bid)
  INNER JOIN barn AS b2 ON (l.barn2 = b2.bid)

-- SELECT
SELECT DISTINCT b1.barn, b2.barn
FROM oversikt AS b1
  INNER JOIN oversikt AS b2 USING (gid)
WHERE b1.bid != b2.bid;


-- Oppgave 9 - Populære gaver
-- Skriv en spørring som finner de tre mest populære nyttige gavene, og de tre
-- mest populære unyttige gavene. Resultatet skal inneholde navn på gaven, antall
-- barn som ønsker gaven, samt hvorvidt den er nyttig eller ikke. Du kan benytte
-- view’et fra oppgave 7.

SELECT gave, count(*) AS antall_ønsker, true AS nyttig FROM oversikt
WHERE nyttig
GROUP BY gave
ORDER BY antall_ønsker
LIMIT 3
UNION
SELECT gave, count(*) as antall_ønsker, false AS nyttig FROM oversikt
WHERE NOT nyttig
GROUP BY gave
ORDER BY antall_ønsker LIMIT 3;


-- Oppgave 10 - Gaveliste
-- Skriv en spørring som tilordner gaver til barn i henhold til følgende regler:
-- Snille barn får alt de ønsker seg
-- Usnille får kun nyttige ting de ønsker seg. Om de ikke ønsker seg noen
-- nyttige ting får de gaven med navn 'Genser'.

WITH
usnille_med_ønsker AS (
SELECT bid, barn, gave FROM oversikt
WHERE snill = false AND
nyttig = true
),
usnille_uten_ønkser AS (
SELECT navn AS barn, 'Genser' AS gave FROM barn
WHERE snill = false AND
bid NOT IN (SELECT bid FROM usnille_med_ønsker)
)
SELECT barn, gave
FROM oversikt
WHERE snill = true
UNION ALL
SELECT barn, gave
FROM usnille_med_ønsker UNION ALL
SELECT barn, gave
FROM usnille_uten_ønsker;
