/*
                  marktz
        IN2090 - Obligatorisk Oppgave 2
                  SQL 1                              */

--+---------+--
--|Oppgave 2|--
--+---------+--

-- a) Timelistelinjer som er lagt inn for timeliste nummer 3
-- Jeg selecterer alle timeliste linjer med som er lagt inn for timeliste
-- nummer 3. Jeg får et svar av 9 rader til sammen.

SELECT *
  FROM timelistelinje
  WHERE timelistenr = 3; -- 9 rows


-- B) Hvor mange timelister det er
-- En spørring som teller antall timelister. Jeg får et svar av 8 rader til
-- sammen.

SELECT COUNT(*) AS AntallTimelister
  FROM Timeliste; -- 8 rows

-- Eller

SELECT COUNT(timelistenr) AS AntallTimelister
  FROM timeliste; -- 8 rows

-- C) Hvor mange timelister som det ikke er utbetalt for.
-- En spørring som vil da telle eller inkludere alle timelister som det ikke
-- er utbetalt for, det vil si enten aktive eller levert. Jeg får til sammen
-- 3 rader.

SELECT COUNT(*) AS IkkeUtbetaltTimelister
  FROM Timeliste
  WHERE status <> 'utbetalt'; -- 3 rows

-- eller

SELECT COUNT(timelistenr) AS IkkeUtbetaltTimelister
  FROM timeliste
  WHERE status != 'utbetalt'; -- 3 rows.

-- D) Antall Timelistelinjer, og antall Timelistelinjer med en pauseverdi
-- En spørring som printer en relasjon med antall timelistelinjer og
-- antall timelistelinjer som har en pausverdi (utifra alle timelistelinjer.)
-- Jeg kjører to COUNT-operasjoner og får 34 rader for antall timelistelinjer
-- og 12 rader for antall timelistelinjer med en pauseverdi.

SELECT
  COUNT(*) as antall, -- 34 rader
  COUNT(CASE WHEN pause IS NOT NULL THEN 1 END) as antallmedpause -- 12 rader
FROM Timelistelinje;

-- Eller

SELECT
  COUNT(*) as antall, -- 34 rader
  (SELECT COUNT(*) as antallmedpause-- 12 rader
    FROM Timelistelinje
    WHERE pause IS NOT NULL)
FROM Timelistelinje;


-- E) Alle timelistelinjer som ikke har pauseverdier (der pause er satt til null)
-- En spørring som ser etter alle timelistelinjer som ikke har pauseverdier,
-- det vil si der selve verdien er definert som NULL. Svaret for dette er 22 rader
-- til sammen.

SELECT *
  FROM Timelistelinje
  WHERE pause IS NULL; -- 22 rows

--+---------+--
--|Oppgave 3|--
--+---------+--

-- Bruk SQL til å finne ut:
-- a) Antall timer som det ikke er utbetalt timer for. Her kan det også
--    være lurt å ta i bruk viewet varighet, men merk at varigheten her er i
--    minutter, ikke timer.

-- Det jeg gjør  i dette tilfelle er å lage en spørring som henter summen av
-- alle minuter som det ikke er utbetalt for og deler dem inn i 60, for å så
-- få antall timer. Joiner sammen Varighet tabellen og timeliste tabellen.
-- Til slutt lager jeg en betingelse som sier at den skal hente alle rader der
-- status ikke er lik utbetalt (ser etter statusene "aktiv" eller "levert")!

-- Jeg vil gjerne påpeke at dersom vi deler minuttene med en float verdi,
-- altså (60.0), så vil vi få 13.5 timer til sammen og ikke 13 (det vi fikk
-- uten å dele på en float verdi).

SELECT SUM(v.varighet)/ 60  AS timer  -- SUM(v.varighet) AS minuter,
FROM Varighet AS v
  INNER JOIN Timeliste AS tl ON (v.timelistenr = tl.timelistenr)
WHERE tl.status <> 'utbetalt';


/*SELECT cast((SUM(v.varighet) / 60.0) as float) AS timer  -- SUM(v.varighet) AS minuter,
FROM Varighet AS v
  INNER JOIN Timeliste AS tl ON (v.timelistenr = tl.timelistenr)
WHERE tl.status <> 'utbetalt';*/


-- b) Hvilke timelister (nr og beskrivelse ) har en timelistelinje med
--    en beskrivelse som inneholder ´test´ eller ´Test´. Ikke vis duplikater

-- En spørring som etter distincte timelister som har en timelistelinje med
-- en beskrivelse som inneholder ordet ´test´ eller ´Test´. Jeg antar at i dette
-- tilfelle vil vi også inkludere ordene "Stresstesting" eller "Testing", og
-- ikke bare Test 1, osv...

SELECT DISTINCT t.timelistenr AS timeliste, t.beskrivelse AS beskrivelse -- 3 rows
  FROM Timelistelinje AS tl
    INNER JOIN Timeliste AS t ON (tl.timelistenr = t.timelistenr)
  WHERE tl.beskrivelse LIKE ('%test%') OR tl.beskrivelse LIKE ('%Test%');



-- C) Hvor mye penger som har blitt utbetalt, dersom man blir utdelt 200
--    kr per time. Tips: Finn først antall timer som er utbetalt penger for
--    (ref. oppg. 3a).

-- Vi kan tenke oss at dette spørring tar utgangspunkt i oppgave a. Den eneste
-- forskjeller her er at vi har ganget antall timer med 200 kr. En annen endring
-- vi har gjort her er at vi har forandret statusen til å være "utbetalt", siden
-- vi skal regne hvor mye penger som har blitt utbetalt.

-- En liten pirk her, er at jeg er litt usiker om resultatet her bør være i int
-- eller float form, så vil kommentere at svaret varierer litt, siden vi regner
-- med float og vi avrunder ikke.


SELECT SUM(v.varighet / 60 * 200) AS utbetalt -- 11400
FROM Varighet AS v
  INNER JOIN Timeliste AS tl ON (v.timelistenr = tl.timelistenr)
WHERE tl.status = 'utbetalt';

/*
SELECT cast((SUM(v.varighet) / 60.0) as float) * 200 AS utbetalt --  13266.6666666667
FROM Varighet AS v
  INNER JOIN Timeliste AS tl ON (v.timelistenr = tl.timelistenr)
WHERE tl.status = 'utbetalt';*/


--+---------+--
--|Oppgave 4|--
--+---------+--

-- Oppgave 4
-- a) Forklar hvorfor følgende to spørringer IKKE GIR likt svar:
-- Grunnen til at følgende to spørringer IKKER GIR likt svar er fordi vi bruker
-- NATURAL JOIN på den enne spørring og INNER JOIN på den andre.


-- I følgende spørring bruker vi den såkalte "NATURAL JOIN". Det som dette gjør
-- er at den slår sammen (joiner) alle attributer med samme navn. NATURAL JOIN
-- vil være et veldig farlig operasjon, siden den vil også sla seg sammen med
-- flere attributter, og ikke bare en. I vårt tifelle, vil timeliste tabellen og
-- timelistelinje ha bade timelistenr og beskrivelse som felles attributt. Så
-- denne spørring vil da hente frem alle resultater som matcher sammen i både
-- timelistenr og beskrivelse.

-- Vi får da 1 rad som resultat, siden timelistenr 2 har felles nr og beskrivelse
-- i timelistelinje tabellen.

SELECT COUNT(*) -- 1 row
  FROM timeliste NATURAL JOIN timelistelinje;

-- I følgende spørring bruker vi den såkalte "INNER JOIN". I dette tilfelle,
-- vil den ha forskjellige resultat fra en "NATURAL JOIN" spørring siden vi
-- spesifiserer hvor vi skal sla sammen tabellene. Med andre ord, vi spesifiserer
-- attributtene vi vil slå sammen. I dette eksemplet velger vi å joine tabellene
-- hvor timelistenr er likt i begge relasjonene. Dette resulterer til at vi får
-- ulikt svar fra forrige spørring, nemlig 8 rader til sammen.

SELECT COUNT(*) -- 8 rows
  FROM timeliste AS t
  INNER JOIN timeliste as l
  ON (t.timelistenr = l.timelistenr);


-- b) Forklar hvorfor følgende to spørringer GIR likt svar:

-- Nå som vi har en idee på hvordan "NATURAL JOIN" og "INNER JOIN" fungerer, kan
-- vi komme frem til at følgende to spørringer GIR likt svar. Hvis vi tenker på
-- første spørring, vil vi da slå sammen (joine) tabellene "timeliste" og "varighet"
-- der de har likt attributtnavn. Hvis vi ser på de ulike attributtene, vil vi
-- da oppdage at de joines etter "timelistenr" og ikke noe mer. Dette vil da
-- tolkes som en INNER JOIN hvor vi spesifiserer at vi vil joine dem der attributt-
-- navnet er "timelistenr". Dette vil føre til at vi får to like svar, men med 2
-- forskjellige spørring-strukturer.

-- I dette tilfelle får vi 34 rader i begge tilfeller, men det er ikke alltid
-- sånn at NATURAL JOIN og INNER JOIN vil gi samme resultat, fordi de vil
-- kanskje ha likt attributtnavn, men kanskje ha forskjellige betydninger.

SELECT COUNT(*) -- 34 rows
  FROM timeliste NATURAL JOIN varighet;

SELECT COUNT(*) -- 34 rows
  FROM timeliste AS t
  INNER JOIN varighet AS v ON (t.timelistenr = v.timelistenr);
