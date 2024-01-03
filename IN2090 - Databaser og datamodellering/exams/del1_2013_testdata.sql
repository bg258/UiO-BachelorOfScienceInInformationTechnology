DROP TABLE JuridiskPerson, Jpers CASCADE;


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
