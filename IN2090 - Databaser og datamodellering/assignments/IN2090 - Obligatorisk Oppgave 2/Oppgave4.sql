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
