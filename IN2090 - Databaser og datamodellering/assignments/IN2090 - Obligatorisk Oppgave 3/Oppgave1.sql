-- Oppgave 1
-- Det begrepsmessige skjemaet for en relasjonsdatabase for plassreservering
-- i tog inneholder (blant annet) følgende tabeller:

-- Tog(togNr, startStasjon, endeStasjon, ankomstTid)
-- TogTabell(togNr, avgangsTid, stasjon)
-- Plass(dato, togNr, vognNr, plassNr, vindu, ledig)

DROP SCHEMA IF EXISTS TogDatabase CASCADE;
BEGIN; -- Begin transaction
CREATE SCHEMA TogDatabase;

-- Hver rad i Tog beskriver en togrute, hvor startStasjon og endeStasjon
-- er navn på stasjonene som ruten hhv. starter og slutter ved, og ankomstTid
-- er klokkeslettet toget ankommer endeStasjon. Hver togRute går maks en gang i døgnet.

CREATE TABLE Tog(
  togNr INT PRIMARY KEY, -- auto_increment eller serial
  startStasjon TEXT NOT NULL, -- varchar(50)
  endeStasjon TEXT NOT NULL, -- varchar(50)
  ankomstTid TIME NOT NULL,
  CONSTRAINT togRute UNIQUE (startStasjon, endeStasjon)
);

-- Følgende utrykk vil tillates å sette inn i vårt tabell, siden hver togrute
-- som settes inn er unikt.
INSERT INTO Tog
VALUES (1, 'Oslo Lufthavn', 'Basel SBB', '14:00:00'),
       (2, 'Alicante Railway Station', 'Viana do Castelo', '09:00:00'),
       (3, 'Düsseldorf Hauptbahnhof', 'Kraków Central', '16:00:00'),
       (4, 'Leningradskiy Railway Station', 'Palaeofarsalos', '16:00:00');

-- Følgende uttrykk vil gi feil, siden vi har definert at start stasjonen og
-- endestasjonen (altså et bestemt togrute) skal være unikt.
INSERT INTO Tog
VALUES (5, 'Oslo Lufthavn', 'Basel SBB', '18:00:00');


-- Tabellen TogTabell inneholder informasjon om klokkeslettet (avgangsTid)
-- toget på en bestemt rute (gitt ved togNr) kjører fra en bestemet stasjon (stasjon)

CREATE TABLE TogTabell(
  togNr INT REFERENCES Tog(togNr),
  avgangsTid TIME NOT NULL,
  stasjon TEXT NOT NULL, -- varchar(50)
  CONSTRAINT togTid PRIMARY KEY (togNr, avgangsTid),
  CONSTRAINT unikTogNr UNIQUE(togNr)
);

INSERT INTO TogTabell
VALUES (1, '09:00:00','Oslo Lufthavn'),
       (2, '06:00:00', 'Alicante Railway Station'),
       (3, '13:00:00', 'Düsseldorf Hauptbahnhof'),
       (4, '05:00:00', 'Leningradskiy Railway Station');

-- Følgende utrykk vil gi oss en feilmelding siden togNr og avgangsTid skal
-- være ment til å være unikt.

INSERT INTO TogTabell
VALUES (1, '08:00:00', 'Oslo Lufthavn');

-- Hver rad i Plass beskriver ett sete (gitt ved vognNr og plassNr) på et bestemt
-- tog (togNr) på en bestemt dag (dato), samt hvorvidt plassen er et vindussette
-- (vindu) og om det er ledig (ledig.)

-- En ting jeg vil gjerne påpeke er at for å gjøre databasen vår mer
-- originalt, kan vi istedenfor ha en boolean datatype både i "vindu" og "ledig"
-- kan vi da opprette dem til å være en TEXT med en CHECK skranke. Begge
-- alternativer vil da være ritkig, siden PostgreSQL tillater boolean verdier.

-- lagde en check skranke som sørger for at togplasset ikke gjelder for
-- datoer som er allerede har gått. Dette vil gjelde for nævarende datoer eller
-- fremtide datoer.


CREATE TABLE Plass(
  dato DATE,
  togNr INT NOT NULL REFERENCES Tog(togNr),
  vognNr int NOT NULL,
  plassNr int NOT NULL,
  vindu TEXT NOT NULL
  CHECK (vindu = 'vindussette' OR vindu = 'ikke vindussette'),
  ledig TEXT NOT NULL
  CHECK (ledig = 'ledig' OR ledig = 'ikke ledig'),
  PRIMARY KEY(dato, togNr, vognNr, plassNr)
);

INSERT INTO Plass
VALUES (null, 1, 2, 3, 'vindussette', 'ledig');
       ('2020-11-19', 1, 2, 4, 'vindussette', 'ledig'),
       ('2020-11-19', 1, 3, 1, 'ikke vindussette', 'ikke ledig'),
       ('2020-11-19', 1, 3, 2, 'ikke vindussette', 'ikke ledig'),
       ('2020-11-19', 2, 1, 3, 'vindussette', 'ikke ledig');

-- Følgende utrykk vil gi oss en feilmelding siden dato, togNr, vognNr og plassNr
-- skal være ment til å være unikt.

INSERT INTO Plass
VALUES ('2020-11-19', 1, 2, 3, 'ikke vindussette', 'ikke ledig');

COMMIT;
