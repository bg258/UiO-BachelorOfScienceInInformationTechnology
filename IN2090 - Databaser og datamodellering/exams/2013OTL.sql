DROP TABLE JuridiskPerson, Jpers, Ansatt, Eier CASCADE;


/* TEST-data start*/
/*
En juridisk person (enhet) er enten en person identifisert med et
fødselsnummer, eller et selskap, firma, organisasjon e.l. identifisert med et
organisasjonsnummer. Et organisasjonsnummer består av 9 siffer; første siffer
er enten 8 eller 9. Et fødselsnummer består av en fødselsdato på formen
DDMMÅÅ etterfulgt av et femsifret personnummer. Fødselsnummeret har derfor
alltid 11 siffer og begynner med sifferet 0, 1, 2 eller 3. (Ingen måned har mer
enn 31 dager). Personer har altså fødselsnummer, mens alle andre juridiske
personer har organisasjonsnummer. Vi får tilgang til tabellen

JuridiskPerson (jpid, navn)

med informasjon over navn på juridiske personer. Vi vet ikke om alle jpid-
verdier er korrekte, dvs. om alle jpid-verdier er fødselsnummer/organisasjons-
nummer som beskrevet over. Vi vet heller ikke om flere navn kan være oppført
med samme jpid eller om noen navn-verdier er null.

*/
CREATE TABLE JuridiskPerson(
    Jpid Varchar(11),
    navn text
);

INSERT INTO JuridiskPerson(Jpid, navn)
VALUES
('12109124921', 'Odd-Tørres Lunde'),
('12109124921', 'Odd-Tørres Lunde'),
('12109124921', 'Odd-Tørres Lunde'),
('12109124921', 'Odd-Tørres Lunde'),
('12109124921', 'Odd-Tørres Lunde'),
('31059824323', 'Fredrik Kalsen'),
('02039824321', 'Torkil Lundegård'),
('22059024321', 'Marta Primveien'),
('22079026321', 'Marte Lunde'),
('1309924321', 'Omir Ahbulha'),
('31000000000', 'Karl Lunde'),
('12100026371', 'Stein Michael Storme'),
('12358926321', NULL),
('800123123', NULL),
('900234234', NULL),
('32123123123', NULL),
('32123123123', NULL),
('823451568', 'Omega AS'),
('823455368', 'Statoil ASA'),
('963455370', 'SQL-skulen AS'),
('800001234', 'Eies kun av en person'),
('800002345', 'Eies av flere personer'),
('912312451', 'tl;dr SQL'),
('923451569', 'UiO'),
(NULL , NULL),
(NULL , 'NULL Heller ikkje denne'),
('50494' ,'**DEnne skal ikkje bli overført');

SELECT *
FROM JuridiskPerson;
/* TEST-data slutt*/

/* Oppgave 5
Definer en ny tabell JPers (jpid, navn) slik at det ikke er mulig å legge
inn juridiske personer med lik jpid eller navn-verdier som er null.
*/
CREATE TABLE JPers(
    Jpid VARCHAR(11) PRIMARY KEY,
    Navn text NOT NULL
);


/* Oppgave 6 */
INSERT INTO JPers(Jpid, navn)
SELECT DISTINCT Jpid, navn
FROM JuridiskPerson
WHERE navn IS NOT NULL
AND (
  char_length(Jpid) = 9
  AND substring(jpid,1,1) IN ('8','9')
  OR
  char_length(Jpid) = 11
  AND substring(jpid,1,1) IN ('0','1','2')
  OR
  char_length(jpid) = 11
  AND substring(jpid,1,2) IN ('30','31')
);
/* OR bør alltid innkapsles*/
/* Kommentarer:
-
- char_length er ein funksjon som eksistere i psql. Du kan bruke jpid LIKE '9________' i stedet for char_length
- Du kan bruke DISTINCT eller GROUP BY (men då må du ha begge feltene) for å ikke få feilmelding.
*/

SELECT j.*
FROM Jpers j;

/* Sjekker at data er korrekt.
HUSK: Du har ikke mulighet til å teste under eksamen*/

/*
Oppgave 7
Definer to views:
Person(fnr, navn)
Organisasjon(orgnr, navn)
Person skal kun ha personer med fødselsnummer, mens Organisasjon
kun skal ha juridiske personer med organisasjonsnummer.
*/

CREATE VIEW Personer AS
  SELECT jpid AS fnr, navn
  FROM JPers
  WHERE (char_length(Jpid) = 11
    AND substring(jpid,1,1) IN ('0','1','2')
    OR
    char_length(jpid) = 11
    AND substring(jpid,1,2) IN ('30','31'));

CREATE VIEW Organisasjon AS
  SELECT jpid AS orgnr, navn
  FROM JPers
  WHERE (char_length(Jpid) = 9
    AND substring(jpid,1,1) IN ('8','9'));
/*
Vi får også tilgang til en relasjon med informasjon om eierskap i
aksjeselskaper (delmengde av organisasjoner med organisasjonsnummer):

EierAntAksjer(jpid, orgnr, ant)

Et tuppel fra denne betyr at den juridiske personen med fødselsnummer/organisajonsnummer
jpid eier ant aksjer i selskapet med organisasjonsnummer
orgnr. Både personer og selskaper kan eie aksjer, men ingen eier aksjer i personer
(orgnr må være et organisasjonsnummer). Både jpid-verdier og orgnrverdier
må finnes som jpid-verdi i JPers-tabellen.
Vi er usikre på kvaliteten her også og skal lage en ny tabell Eier med de
samme attributtene.
*/

/*
Oppgave 8
Definer tabellen Eier slik at integritetsreglene over ikke kan brytes.
ant må være et heltall større eller lik 0. Husk å definere primærog
eventuelle kandidatnøkler.
*/
CREATE TABLE Eier(
  jpid varchar(11) references JPers(jpid),
  orgnr varchar(9) references JPers(jpid),
  antAksjer int,
  PRIMARY KEY(jpid,orgnr),
  check(char_length(orgnr) = 9
	AND substring(orgnr,1,1) IN ('8','9')
    AND antAksjer > 0)
);
/*
På eksamen vil du bli trukket for å ikke ta med fremmednøkkel, manglende sjekk av org, ant.
Visst jpid er den eneste kolonnen i primærnøkkel vil du også bli trukket.
*/

/* TEST-data start*/
-- Eiere(personer) av UiO
INSERT INTO Eier(jpid,orgnr,antAksjer)
SELECT p.fnr, '923451569', random()*100
FROM personer p
LIMIT 5;

-- Eiere(firma) av UiO
INSERT INTO Eier(jpid,orgnr,antAksjer)
SELECT O.OrgNr, '923451569', random()*100
FROM Organisasjon O
LIMIT 2;

-- Eiere(personer) av Omega AS
INSERT INTO Eier(jpid,orgnr,antAksjer)
SELECT p.fnr, '823451568', random()*100
FROM personer p
WHERE p.navn LIKE '%Lunde%'
LIMIT 3;

--Eiere(firma) av Omega AS
INSERT INTO Eier(jpid,orgnr,antAksjer)
SELECT O.OrgNr, '823451568', random()*100
FROM Organisasjon O
LIMIT 4;

--Statoil: alle aksjer eiges av Statoil
INSERT INTO Eier(jpid,orgnr,antAksjer)
VALUES('823455368','823455368', random()*100);


INSERT INTO Eier(jpid,orgnr,antAksjer)
SELECT '31059824323', '800001234', 100
FROM personer p
LIMIT 1;


INSERT INTO Eier(jpid,orgnr,antAksjer)
SELECT '12109124921', '800002345', 100
FROM personer p
LIMIT 1;

INSERT INTO Eier(jpid,orgnr,antAksjer)
SELECT '31059824323', '800002345', 100
FROM personer p
LIMIT 1;

CREATE VIEW EierAntAksjer AS
  SELECT
    JP.jpid, jp.navn as JuridiskNavn,
    O.Orgnr,
    O.Navn AS OrganisasjonNavn,
    antAksjer
  FROM Eier E
  INNER JOIN Jpers Jp ON JP.Jpid=E.Jpid
  INNER JOIN Organisasjon O ON O.orgnr=E.orgnr;
/* TEST-data slutt*/

/*
Oppgave 9
Skriv en SELECT-setning som gir en oversikt over alle aksjeselska-
per sortert etter navn. (Aksjeselskaper er selskaper som finnes som
orgnr i EierAntAksjer-tabellen).
*/
SELECT  OrgNr, OrganisasjonNavn
FROM EierAntAksjer
ORDER BY OrganisasjonNavn;
/* ASC er standard i ORDER BY
DESC må presiseres*/

/*
Oppgave 10
Lag den samme oversikten, og for hvert aksjelskap ta med antall
forskjellige eiere og hvor mange aksjer det totalt er i selskapet.
*/
SELECT OrganisasjonNavn, COUNT(DISTINCT jpid), SUM(antAksjer)
FROM EierAntAksjer
GROUP BY OrgNr, OrganisasjonNavn
ORDER BY OrganisasjonNavn;

/*
Oppgave 11
Skriv en SELECT-setning som skriver ut navn på aksjeselskaper
og for hvert selskap hvor mange prosent av aksjene som eies av
personer (med fødselsnummer), og hvor mange prosent av aksjene
som eies av selskapet selv. (Selskaper kan eie aksjer i eget selskap).
*/

SELECT EA.OrganisasjonNavn,
  (SELECT SUM(E.antAksjer) /* sub-select kan kun returnere ein tuppel i en rad*/
    FROM Eier E
    INNER JOIN Personer P ON P.fnr = E.jpid
    WHERE E.orgnr=EA.orgnr) * 100.00 / SUM(EA.antAksjer) AS ProsentPersoner,
  (SELECT SUM(E.antAksjer)
    FROM Eier E
    INNER JOIN Organisasjon O ON O.orgnr = E.jpid
    WHERE E.orgnr=O.orgnr
      AND E.orgnr=EA.orgnr) * 100.00 / SUM(EA.antAksjer) AS ProsentSelskapet,
  (SELECT SUM(E.antAksjer)
    FROM Eier E
    INNER JOIN Organisasjon O ON O.orgnr = E.jpid
    WHERE E.jpid <> E.orgnr
      AND E.orgnr=EA.orgnr) * 100.00 / SUM(EA.antAksjer) AS ProsentAndre

FROM EierAntAksjer EA
GROUP BY EA.Orgnr, OrganisasjonNavn;

/*E.orgnr=O.orgnr selskap E.jpid <> E.orgnr andre*/

/* Dette er ein veldig utfordrende spørring*/

/*Oppgave 12
Forklar likevel kort hva du ville sjekke om vi ikke visste om tabellen
var korrekt.

Jeg ville sjekke følgende
1. at (fnr, orgnr) er entydig (bare ett ansettelsesforhold mellom person og
organisasjon).
2. at fnr finnes i JPers som jpid (fremmednøkkel)
3. at fnr forekommer i Person
4. at orgnr finnes i JPers som jpid (fremmednøkkel)
5. at orgnr forekommer i Organisasjon
6. stillingsbrøk må være over 0
*/
CREATE TABLE Ansatt(
  fnr varchar(11),
  orgnr varchar(9),
  sbrøk int,
  PRIMARY KEY(fnr,orgnr),
  CHECK(sbrøk > 0)
);

/*testdata start*/

/*Legge inn ansatte i Omega AS*/
INSERT INTO Ansatt(fnr,orgnr,sbrøk)
SELECT p.fnr, '823451568', random()*100 /* Gir vilkårlig verdi mellom 1 - 100*/
FROM personer p
WHERE p.navn LIKE '%Lunde%'
LIMIT 3;

INSERT INTO Ansatt(fnr,orgnr,sbrøk)
SELECT p.fnr, '823455368', random()*100 /* Gir vilkårlig verdi mellom 1 - 100*/
FROM personer p
LIMIT 8;

--Enkeltmannsforetak
INSERT INTO Ansatt(fnr,orgnr,sbrøk)
SELECT '31059824323', '923451569', 100
FROM personer p
LIMIT 1;

INSERT INTO Ansatt(fnr,orgnr,sbrøk)
SELECT '12109124921', '912312451', 100
FROM personer p
LIMIT 1;

INSERT INTO Ansatt(fnr,orgnr,sbrøk)
SELECT '31059824323', '800001234', 100
FROM personer p
LIMIT 1;

INSERT INTO Ansatt(fnr,orgnr,sbrøk)
SELECT '12109124921', '800002345', 80
FROM personer p
LIMIT 1;

INSERT INTO Ansatt(fnr,orgnr,sbrøk)
SELECT '31059824323', '800002345', 50
FROM personer p
LIMIT 1;


/*testdata slutt */

/*
Oppgave 13
Lag en oversikt over antall ansatte i alle selskaper.
*/
SELECT O.navn, COUNT(A.fnr) AS antallAnsatte
FROM Ansatt A
JOIN Organisasjon O ON A.Orgnr=O.orgnr
GROUP BY o.orgnr,o.navn;
/*
Selskaper med bare en tilsatt kaller vi et enkeltmannsforetak.

Oppgave 14
Lag et view over alle enkeltmannsforetak.
*/
CREATE VIEW enkeltmannsforetak AS
SELECT navn
FROM Ansatt A
JOIN Organisasjon O ON A.Orgnr=O.orgnr
GROUP BY o.navn
HAVING COUNT(a.fnr) = 1;

/*
Oppgave 15
Skriv ut en liste over selskaper der alle aksjene eies av personer.
*/
SELECT DISTINCT OrganisasjonNavn
FROM EierAntAksjer EA
GROUP BY OrganisasjonNavn,Orgnr
HAVING (SELECT SUM(E.antAksjer)
          FROM Eier E
          JOIN Personer P ON P.fnr = E.jpid
          WHERE E.jpid=P.fnr
            AND E.orgnr=EA.orgnr) = SUM(EA.antAksjer);


/*
Oppgave 16
Skriv ut en liste over selskaper (navn) og ansatte (navn) der alle
aksjene eies av ansatte i selskapet, sammen med antall aksjer pr.
ansatt har. Sorter lista etter selskaper med flest aksjer først.
*/
SELECT O.Navn, P.navn, E.antAksjer
FROM Ansatt A
JOIN Personer P ON P.fnr=A.fnr
JOIN Eier E ON E.jpid=A.fnr AND E.orgnr=A.orgnr
JOIN Organisasjon O ON O.OrgNr=A.OrgNr
GROUP BY O.navn, E.orgnr, P.navn, A.fnr, A.orgnr, E.antAksjer
HAVING (SELECT SUM(E1.antAksjer)
          FROM Eier E1
          JOIN Personer P ON P.fnr=E1.jpid
          WHERE E1.jpid=A.fnr
            AND E1.orgnr=A.orgnr) = SUM(E.antAksjer)
ORDER BY E.antAksjer DESC, O.Navn, P.Navn;
