/* Mengdeoperatorer*/
-- Eksempler fra filmdatabasen --
SELECT C.country
FROM Filcountry C
WHERE C.filmid < 50
ORDER BY C.Country;

-- I forrige eksempel lagde vi en spørring som hentet
-- ut de første 50 filmer. I dette tilfelle skal vi lage en
-- spørring som henter ut de første 30 filmer
SELECT C.country
FROM Filmcountry C
WHERE C.filmid < 30
ORDER BY C.country;

/* Det er en mengde operator med navn: () union all () som
   gir oss muligheten til å slå sammen 2 andre sql spørringer
   sammen. Altså alt som ligger i den enne spørring og alt
   som ligger i den andre spørring. */

(SELECT C.country
 FROM Filmcountry C
 WHERE C.filmid < 50
 ORDER BY C.contry)

 UNION ALL

 (SELECT C.country
  FROM Filmcountry C
  WHERE C.filmid < 30
  ORDER BY C.country);

-------------------------------------------------------------------------------
/* () UNION ALL() EKSEMPEL */
(SELECT C.country, C.filmid
 FROM Filmcountry C
 WHERE C.filmid < 50
 ORDER BY C.country)

 UNION ALL

 (SELECT C.filmid, C.country
  FROM Filmcountry C
  WHERE C.filmid < 30
  ORDER BY C.country);

-- Error: UNION types text and integer cannot be matched
-- LINE 6: SELECT C.filmid, C.country


-- Derimot, hvis vi bytter rekkefølgen på typene i mengden,
-- ender vi opp med følgende resultat:

(SELECT C.country, C.filmid
 FROM Filmcountry C
 WHERE C.filmid < 50
 ORDER BY C.country) UNION ALL
(SELECT C.country, C.filmid
 FROM Filmcountry C
 WHERE C.filmid < 30
 ORDER BY C.country);

-------------------------------------------------------------------------------
-- Ofte stilte spørsmål
-- Tenk at man har 2 tabeller med ulik data. For å være mer konkret, den ene
-- tabellen har Land og filmid, mens den andre tabell har Film-navn og filmid:
-- Er disse multimengdene unionkompatible? Ja, det er de!

(SELECT C.country, C.filmid
 FROM Filmcountry C
 WHERE C.filmid < 50
 ORDER BY C.country)

 UNION ALL
(SELECT F.title, F.filmid
 FROM Film F
 WHERE F.filmid < 30
 ORDER BY F.title);

 -- Følgende SQL-spørring vil da returnere forekomster dersom hvilket som helst
 -- film fra den ene mengden har samme navn som et land i menden med ulike land.

(SELECT C.country
 FROM Filmcountry C
) INTERSECT ALL
(SELECT F.title
 FROM Film F);

 -- For å fjerne duplikater, kan man egentlig fjerne "all" ordet, så
 -- får vi et resultat uten noen duplikater.
 (SELECT C.country
  FROM Filmcountry C
) INTERSECT
 (SELECT F.title
  FROM Film F);

/*
Et view er en tenkt relasjon som vi bruker som mellomresultat i kompliserte
SQL-beregninger.
*/

CREATE VIEW Innsats AS
  SELECT anr, SUM(timer) AS timer
  FROM Prosjektplan
  GROUP BY anr;


-- En liten fortsettelse av forrige oppgave
CREATE VIEW Bonus(anr, bonusiNOK) AS
  (SELECT anr, 3000
   FROM Innsats
   WHERE timer >= 500)
UNION
  (SELECT anr, 1500
   FROM Innsats
   WHERE timer >= 300 AND timer < 500);


-- Eksempel som bygger på følgende eksempel
CREATE VIEW funksjoner (personid, antroller) AS
SELECT p.personid, COUNT(DISTINCT parttype)
FROM person p, filmparticipation x
WHERE x.personid = p.personid
GROUP BY p.personid
HAVING COUNT(DISTINCT parttype) > 1;


SELECT MAX(firstname) ||  ',' || MAX(lastname) AS navn
  parttype AS deltakerfunksjon
  COUNT(*) AS antall_filmer
FROM person p,
     filmparticipation x,
     funksjoner f
WHERE x.personid = p.personid
     AND f.personid = p.personid
     AND f.antroller < 5
GROUP BY p.personid, parttype;


/*
Eksempel
Finn navn på ansatte som skal arbeide mer enn 10 timer på
samtlige av sine prosjekter

Ansatt(anr, navn, lonn, avd)
Avdeling(avdnr, avdelingsnavn, leder)
Prosjekt(pnr, anr, timer)
*/

SELECT A.navn
FROM Ansatt A
WHERE not exists (
  SELECT *
  FROM Prosjektplan P
  WHERE P.anr = A.anr
  AND P.timer <= 10
);
