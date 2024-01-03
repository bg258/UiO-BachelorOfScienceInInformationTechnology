/* Ja, svaret på Oppgave 5,6,7 og 8 er her */

/*Fjerne tabellen deres for at kjøringene skal fungere */
DROP TABLE IF EXISTS Eier, Jpers CASCADE;
DROP VIEW IF EXISTS Personer, Organisasjon;

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

/* Oppgave 7 */
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
Oppgave 8
Definer tabellen Eier slik at integritetsreglene over ikke kan brytes.
ant må være et heltall større eller lik 0. Husk å definere primær og
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
