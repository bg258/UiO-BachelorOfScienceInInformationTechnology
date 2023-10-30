BEGIN;

-- FartøyID -> Registreringsmerke bryter med BCNF
-- Tillukningen til FartøyID er {FartøyID, Registreringsmerke},
-- altså får vi følgende (som ikke bryter med BCNF):
CREATE TABLE fiskeri.Fartøy (
    FartøyID text PRIMARY KEY, 
    Registreringsmerke text
);

-- Har nå en tabell med alle attributter bortsett fra Registreringsmerke
-- Tillatelsekode -> Tillatelse bryter med BCNF
-- Tillukningen til Tillatelsekode er {Tillatelsekode, Tillatelse},
-- så får følgende (som ikke bryter BCNF):
CREATE TABLE fiskeri.TillatelseInfo (
    Tillatelsekode text PRIMARY KEY, 
    Tillatelse text 
);

-- Har nå en tabell med alle attributter bortsett fra Registreringsmerke og Tillatelse
-- TillatelseID -> Datapr bryter med BCNF
-- Tillukningen til TillatelseID er {TillatelseID, Datapr, FartøyID, Tillatelsekode,
--                                   TillatelseGjelderFraDato, TillatelseGjelderTilDato,
--                                   KvotestrGjelderFraDato, KvotestrGjelderTilDato},
-- så får følgende (som ikke bryter BCNF):
CREATE TABLE fiskeri.Tillatelse (
    Datapr text, 
    FartøyID text REFERENCES fiskeri.Fartøy(FartøyID), 
    Tillatelsekode text REFERENCES fiskeri.TillatelseInfo(Tillatelsekode), 
    TillatelseID text PRIMARY KEY, 
    TillatelseGjelderFraDato timestamp, 
    TillatelseGjelderTilDato timestamp,
    KvotestrGjelderFraDato date,
    KvotestrGjelderTilDato date
);
    
-- Står nå igjen med følgende tabell, som ikke bryter med BCNF:
CREATE TABLE fiskeri.TillatelseDetaljer (
    TillatelseID text REFERENCES fiskeri.Tillatelse(TillatelseID), 
    Linjenummer int,
    Linjenummerbeskrivelse text,
    Kvotestørrelse text,
    CONSTRAINT td_pk PRIMARY KEY (TillatelseID, Linjenummer)
);

-- Setter så inn data fra fiskeri.kvoter i hver tabell:

INSERT INTO fiskeri.Fartøy
SELECT DISTINCT FartøyID, Registreringsmerke
FROM fiskeri.kvoter;

INSERT INTO fiskeri.TillatelseInfo
SELECT DISTINCT Tillatelsekode, Tillatelse
FROM fiskeri.kvoter;

INSERT INTO fiskeri.Tillatelse
SELECT DISTINCT Datapr, FartøyID, Tillatelsekode, TillatelseID,
    TillatelseGjelderFraDato, TillatelseGjelderTilDato,
    KvotestrGjelderFraDato, KvotestrGjelderTilDato
FROM fiskeri.kvoter;

INSERT INTO fiskeri.TillatelseDetaljer
SELECT DISTINCT TillatelseID, Linjenummer, Linjenummerbeskrivelse, Kvotestørrelse
FROM fiskeri.kvoter
WHERE Linjenummer IS NOT NULL; -- Finnes rader i kvoter som mangler linjenummer

COMMIT;
