-- Oppgave 1 - CREATE TABLE
-- Skriv SQL-setninger som oppretter tabellene i skjemaet. Finn passende datatyper
-- for attributtene. I tillegg ønsker vi at attributtene status i relasjonen Prosjekt
-- kun skal kunne inneholde verdiene "planlagt", "aktiv", eller "ferdig"
BEGIN;
CREATE SCHEMA Firma;
CREATE TABLE Kunde(
  kundenummer INT PRIMARY KEY,
  kundenavn TEXT NOT NULL,
  kundeadresse TEXT,
  postnr INT,
  poststed TEXT
);


CREATE TABLE Ansatt(
  ansattnr INT PRIMARY KEY,
  navn TEXT NOT NULL,
  fødselsdato DATE,
  ansattDato DATE
);


CREATE TABLE Prosjekt(
  prosjektnummer INT PRIMARY KEY,
  prosjektleder INT,
  prosjektnavn TEXT NOT NULL,
  kundenummer INT,
  status TEXT
  CHECK (status = 'planlagt' OR
         status = 'aktiv' OR
         status = 'ferdig'),
  FOREIGN KEY (kundenummer) REFERENCES Kunde (kundenummer),
  FOREIGN KEY (prosjektleder) REFERENCES Ansatt (ansattnr)
);

CREATE TABLE AnsattDeltarIProsjekt(
  ansattnr INT,
  prosjektnr INT,

  PRIMARY KEY(ansattnr, prosjektnr),
  FOREIGN KEY(prosjektnr) REFERENCES Prosjekt(prosjektnummer),
  FOREIGN KEY(ansattnr) REFERENCES Ansatt(ansattnr)
);
END;

-- Oppgave 2 - Teori
-- A) Hva er primærnøkkelen i relasjonen Ansatt? Hva med relasjonen AnsattDeltarIProsjekt?
--    - Primaernøkkelen i relasjonen Ansatt er ansattnr.
--    - Primaernøkkelen i relasjonen AnsattDeltarIProsjekt er Ansattnr og prosjektnr kombinert sammen

-- B) Hva er nøkkelattributtene i relasjonen Ansatt? Hva med relasjonen AnsattDeltarIProsjekt?
--   -  Siden primaernøkkelen vår består bare av et element, kan vi si at nøkkelattributtet
--   -  i dette tilfelle vil da være selve primaernøkkelen, nemlig ansattnr.
--   -  For AnsattDeltarIProsjekt vil det være ansattnr og prosjektnummer

-- C) Har relasjonen Ansatt en kandidatnøkkel? I så fall, hva er kandidatnøkkelen?
--   - Ansatt har bare en primaernøkkel noe som gjør dedn også til å være en kandidatnøkkel, siden
--   - den er minimal.

-- D) Hva er supernøklene i relasjonen Ansatt?
--   - {ansattnr}, {ansattnr, navn}, {ansattnr, fødselsdato}, {ansattnr, ansattDato},
--     {ansattnr, navn, fødselsdato}, osv ...

-- E) Postnummer fungerer slik at om du har et postnummer, så vet du hva
--    poststedet er. Hva er de funksjonelle avhengighetene i relasjonen Kunde?
-- Vil det være sånn at dersom du har et postnummer, så vil du automatisk ha
-- et poststed. Og hvis du ikke har poststedet, så vil det også bety at du
-- ikke har et postnummer tilgjengelig. Det kan ikke være sånn at du har et
-- postnummer og ikke et poststed.

-- e) kundenummer -> kundenavn, kundeadresse, postnr, poststed
--    postnr -> poststed


-- Oppgave 3 - INSERT
-- Fyll tabellene med data. Skriv INSERT-setninger som gjør det mulig å teste
-- noen av SELECT-setningene som skal skrives i neste oppgave.

-- Prøv også å legge til data i AnsattDeltarIProsjekt for et ansattnr eller
-- prosjektnr som ikke finnes. Dette skal gi deg en feilmelding. Hva er det
-- som hindrer deg i å legge til slike data?

-- Oppgave 3- INSERT
-- Fyll tabellene med data. Skriv insert-setninger som gjør det mulig å teste
-- noen av select-setningene som skal skrives i neste oppgave.

-- Kunde tabell - 6 Kunder
INSERT INTO Kunde (kundenummer, kundenavn, kundeadresse, postnr, poststed)
VALUES
  (1, 'Lena R Willingham', '561  Woodridge Lane', 49092, 'Vicksburg'),
  (2, 'Manuel M Norman', '415  Fantages Way', 04240, 'Lewiston'),
  (3, 'Richard C Banks', '2438  Rockwell Lane', 27801, 'Rocky Mount'),
  (4, 'Tara F Thaxton', '1633  Metz Lane', 02192, 'Needham'),
  (5, 'Johnny J Donaldson', '1803  Oak Way', 63868, 'Morehouse'),
  (6, 'Bonita D Griggs', '2197  Rogers Street', 45202, 'Cincinnati');

-- Ansatt tabell - 15 Ansatte
INSERT INTO Ansatt (ansattnr, navn, fødselsdato, ansattDato)
VALUES
  (1, 'Naomi J Livingstone', '1949-4-28', '2005-01-01'),
  (2, 'Gary L Bartlett', '1985-10-28', '2003-01-01'),
  (3, 'Leonard J Thomas', '1989-10-24', '2001-01-01'),
  (4, 'Kim L Crump', '1958-11-7', '2005-01-01'),
  (5, 'Carol M Glass', '1963-6-19', '2005-01-01'),
  (6, 'Clifton M McFarlane', '1970-3-31', '2003-01-01'),
  (7, 'Kathryn R Jenkins', '1958-3-29', '2003-01-01'),
  (8, 'Cynthia E Rapp', '1973-10-23', '2001-01-01'),
  (9, 'Jesus L Christiansen', '1980-12-5', '2005-01-01'),
  (10, 'Otto D Newcombe', '1961-7-9', '2003-01-01'),
  (11, 'Amy P Harris', '1995-2-17', '2005-01-01'),
  (12, 'Margaret J Augustine', '1963-4-2', '2003-01-01'),
  (13, 'Patsy N Whitmarsh', '1988-3-20', '2003-01-01'),
  (14, 'Helen S Prescott', '1982-4-15', '2005-01-01'),
  (15, 'Essie D Craft', '1975-1-3', '2001-01-01');


-- Prosjekt tabell
INSERT INTO Prosjekt (prosjektnummer, prosjektleder, prosjektnavn, kundenummer, status)
VALUES
  (1, 2, 'PROJECT BOGOTA', 1, 'planlagt'),
  (2, 4, 'PROJECT VEYRON', 3, 'aktiv'),
  (3, 15, 'PROJECT INVICTUS', 4, 'planlagt');


-- AnsattDeltarIProsjekt tabell
INSERT INTO AnsattDeltarIProsjekt(ansattnr, prosjektnr)
VALUES
  (1, 1),
  (2, 1),
  (4, 1),
  (6, 1),
  (8, 1),
  (10, 1),
  (3, 2),
  (5, 2),
  (7, 2),
  (9, 2),
  (11, 2),
  (12, 3),
  (13, 3),
  (14, 1),
  (15, 1),
  (15, 3),
  (2, 2),
  (2, 3),
  (8, 3),
  (9, 1),
  (14, 2),
  (13, 1),
  (12, 2),
  (1, 2);

-- Oppgave 4 - SELECT
-- Skriv SQL-spørringer som henter ut følgende informasjon:
-- A) En liste over alle kunder. Listen skal inneholde kundenummer, kundenavn
--    og kundeadresse.

SELECT kundenummer, kundenavn, kundeadresse
FROM Kunde
WHERE kundeadresse IS NOT NULL;

-- B) Navn på alle prosjektledere. Dersom en ansatt er prosjekleder for flere
--    prosjekter skal navnet kun forekomme en gang.
SELECT DISTINCT a.navn
FROM Ansatt AS a
  INNER JOIN prosjekt as p ON (a.ansattnr = p.prosjektleder);

-- C) Alle ansattnummerene som er knyttet til prosjektet med prosjektnavn "Ruter App".
SELECT a.ansattnr, a.navn
FROM ansatt AS a
  INNER JOIN AnsattDeltarIProsjekt AS adip USING (ansattnr)
  INNER JOIN Prosjekt AS p ON (adip.prosjektnr = p.prosjektnummer)
WHERE p.prosjektnavn = 'PROJECT INVICTUS'; -- 'Ruter App'

-- D) En liste over alle ansatte som er knyttet til prosjekter som har kunden
--    med navn "NSB"
SELECT a.ansattnr, a.navn, a.fødselsdato AS BURSDAG
FROM Ansatt AS A
  INNER JOIN AnsattDeltarIProsjekt AS adip USING (ansattnr)
  INNER JOIN Prosjekt AS p ON (adip.prosjektnr = p.prosjektnummer)
  INNER JOIN Kunde AS k ON (p.kundenummer = k.kundenummer)
WHERE k.kundenavn = 'Lena R Willingham';

-- Oppgave 5 - CRUD
-- De siste ukene har vi sett på hvordan vi henter ut informasjon fra en database.
-- Dette er bare en del av helheten - i en database vil vi normalt også legge
-- inn, endre og slette data. Disse 4 grunnleggende  operasjonene kalles gjerne
-- CRUD -- Create, read, update, delete.

-- I dette oppgavesettet har du også prøvd deg på CREATE-delen, nemlig INSERT.
-- For å fullføre kabalen må vi lære de to siste operasjonene:
-- a) Finn ut hvordan du kan bruke UPDATE for å endre en tuppel (=rad). Skriv
--    en UPDATE-spørring som endrer en rad du la inn i Oppgave 3.

UPDATE Kunde
SET kundenavn = 'Marky Mark & The Funky Bunch'
WHERE kundenavn = 'Lena R Willingham';

-- b) Finn ut hvordan du kan bruke DELETE for å slette en tuppel.
--    Skriv en DELETE-spørring som sletter en rad du la inn i Oppgave 3 (eller
--    legg til en ny rad som du så sletter)
DELETE
FROM AnsattDeltarIProsjekt
WHERE ansattnr = 5 AND
      prosjektnr = 2;
