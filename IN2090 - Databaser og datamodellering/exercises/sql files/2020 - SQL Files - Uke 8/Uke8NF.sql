/*

Oppgave 3
Lag et skjema på BCNF som inneholder dataene for 2019 i "Fisketillatelser med
fartøytilknytting og kvotestørrelser" fra Fiskedirektoratet!

*/

-- Starter med å laste ned filen og åpne i et regnearkprogram (e.g Libreoffice)
-- og åpner arket med navn "2019".

-- Oppgave 3 - Løsning: Lage tabell

DROP SCHEMA IF EXISTS fiskeri;
BEGIN;
CREATE SCHEMA fiskeri;
CREATE TABLE fiskeri.kvoter(
  Datapr text,
  FartøyID text,
  Registreringsmerke text,
  Tillatelsekode text,
  Tillatelse text,
  TillatelseID text,
  TillatelseGjelderFraDato timestamp,
  TillatelseGjelderTilDato timestamp,
  Linjenummer int,
  Linjenummerbeskrivelse text,
  Kvotestørrelse text,
  KvotestrGjelderFraDato date,
  KvotestrGjelderTilDato date
);
COMMIT;


-- Oppgave 3 - løsning: Datainnlasting
-- Åpner CSV-filen med f.eks VIM, og utfører følgende search/replace:
--    :%s/\(\d\d\)\.\(\d\d\)\.\(\d\d\d\d\)/\3-\2-\1/g
-- for å få datoer på riktig format.

-- Kjøre følgende kommando for å laste dataene inn i tabellen vår.
-- cat kvoter.csv | psql <flagg> -c "COPY kvoter FROM stdin DELIMITER ';' NULL AS ''";
-- hvor <flagg> er de vanlige tilkobligsdetaljene til den personlige databasen


-- Oppgave 3 – Løsning: Bestemme FDer og dekomponering
-- FDer:
--  1. FartøyID → Registreringsmerke
--  2. Tillatelsekode → Tillatelse
--  3. TillatelseID → Datapr
--  4. TillatelseID → FartøyID
--  5. TillatelseID → Tillatelsekode
--  6. TillatelseID → TillatelseGjelderFraDato
--  7. TillatelseID → TillatelseGjelderTilDato
--  8. TillatelseID → KvotestrGjelderFraDato
--  9. TillatelseID → KvotestrGjelderTilDato
--  10. TillatelseID, Linjenummer → Linjenummerbeskrivelse
--  11. TillatelseID, Linjenummer → Kvotestørrelse
--  Kandidatnøkkel: {TillatelseID, Linjenummer}

-- Oppgave 3 - Løsning: Dekomponering
BEGIN:
-- FartøyID → Registreringsmerke
-- Tillukningen til FartøyID er {FartøyID, Registreringsmerke},
-- altså får vi følgende (som ikke bryter med BCNF)
CREATE TABLE fiskeri.Fartøy(
  FartøyID text PRIMARY KEY,
  Registreringsmerke text
);

-- Har nå en tabell med alle attributter bortsett fra Registreringsmerke
-- Tillatelsekode → Tillatelse bryter med BCNF
-- Tillukningen til Tillatelsekode er {Tillatelsekode, Tillatelse},
-- så får følgende (som ikke bryter BCNF)
CREATE TABLE fiskeri.TillatelseInfo(
  Tillatelsekode text PRIMARY KEY,
  Tillatelse text
);

-- Har nå en tabell med alle attributter bortsett fra Registreringsmerke og Tillatelse
-- TillatelseID → Datapr bryter med BCNF
-- Tillukningen til TillatelseID er {TillatelseID, Datapr, FartøyID, Tillatelsekode,
--                                   TillatelseGjelderFraDato, TillatelseGjelderTilDato
--                                   KvotestrGjelderFraDato, KvotestrGjelderTilDato},
-- så får følgende (som ikke bryter med BCNF):
CREATE TABLE fiskeri.Tillatelse(
  Datapr te xt,
  FartøyID text REFERENCES fiskeri.Fartøy(FartøyID),
  Tillatelsekode text REFERENCES fiskeri.TillatelseInfo(Tillatelsekode),
  TillatelseID text PRIMARY KEY,
  TillatelseGjelderFraDato timestamp,
  TillatelseGjelderTilDato timestamp,
  KvotestrGjelderFraDato date,
  KvotestrGjelderTilDato date
);

-- Står nå igjen med følgende tabell, som ikke bryter med BCNF:
CREATE TABLE fiskeri.TillatelseDetaljer(
  TillatelseID text REFERENCES fiskeri.Tillatelse(TillatelseID),
  Linjenummer int,
  Linjenummerbeskrivelse text,
  Kvotestørrelse text,
  CONSTRAINT td_pk PRIMARY KEY(TillatelseID, Linjenummer)
);


-- Oppgave 3 - Løsning: Migrering
-- Setter så inn data fra fiskeri. Kvoter i hver tabell:
INSERT INTO fiskeri.Fartøy
SELECT DISTINCT FartøyID , Registreringsmerke FROM fiskeri.kvoter;

INSERT INTO fiskeri.TillatelseInfo
SELECT DISTINCT Tillatelsekode , Tillatelse FROM fiskeri.kvoter;

INSERT INTO fiskeri.Tillatelse
SELECT DISTINCT Datapr , FartøyID , Tillatelsekode , TillatelseID ,
TillatelseGjelderFraDato , TillatelseGjelderTilDato ,
KvotestrGjelderFraDato , KvotestrGjelderTilDato FROM fiskeri.kvoter;

INSERT INTO fiskeri.TillatelseDetaljer
SELECT DISTINCT TillatelseID , Linjenummer , Linjenummerbeskrivelse , Kvotestørrelse FROM fiskeri.kvoter
WHERE Linjenummer IS NOT NULL; -- Finnes rader i kvoter som mangler linjenummer
COMMIT;
