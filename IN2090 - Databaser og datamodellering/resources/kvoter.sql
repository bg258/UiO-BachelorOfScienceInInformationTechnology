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
