-- Oppgave 3
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
