-- Oppgave 2
-- a) Timelistelinjer som er lagt inn for timeliste nummer 3
-- Jeg selecterer alle timeliste linjer med som er lagt inn for timeliste
-- nummer 3. Jeg får et svar av 9 rader til sammen.

SELECT * AS timelister3
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

SELECT COUNT(*) AS !utbetaltTimelister
  FROM Timeliste
  WHERE status <> 'utbetalt'; -- 3 rows

-- eller

SELECT COUNT(timelistenr) AS !utbetaltTimelister
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

SELECT * AS linjerUtenPauseverdier
  FROM Timelistelinje
  WHERE pause IS NULL; -- 22 rows
