DROP TABLE IF EXISTS Ansatt CASCADE;
/*Oppgave 12 */
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
