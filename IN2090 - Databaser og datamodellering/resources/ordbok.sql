-- Forfatter: Leif Harald Karlsen (leifhka [at] ifi.uio.no)
--
-- Dette er et SQL-script som lager en tabell med navn ordbok_raw til bruk i IN2090, og som inneholder alle begrepene som finnes i ordbok.txt-filen.
-- For å opprette tabellen i deres egne database (den som har samme navn som brukernavnet deres), kan dere kjøre denne kommandoen:
--
-- Ifi-linuxmaskin=> psql -h dbpg-ifi-kurs01 -U brukernavn -d brukernavn -f ordbok.sql
--
-- hvor brukernavn byttes ut med ditt UiO-brukernavn og ordbok.sql er denne filen (som da ligger i samme mappe som du kjører denne kommandoen i).
-- Du kan så se alle begrepene med en enkel SELECT * FROM ordbok_raw;
--
-- Under følger en forklaring på de ulike kolonnene:
--
-- id: en enkel ID-kolonne bestående av en integer. Brukes ikke til noe nå, men kan bli brukt senere om vi ønsker mer kompliserte ordboks-database.
-- engelsk: Begrepet på engelsk.
-- norsk: Begrepet på norsk.
-- engelsk_forkortelse: Vanlig brukt forkortelse på engelsk.
-- norsk_forkortelse: Vanlig brukt forkortelse på norsk.
-- introdusert: To tall separert med bindestrek, det første tallet sier uke-nummer og det andre sier video-nummer den uken på videoen begrepet ble introdusert i.
-- lenke: Lenke til video som begrepet ble introdusert i (foreløpig ikke fylt ut).
--
-- Dersom man ønsker å sortere ordboken på en kolonne (f.eks. engelsk) kan man skrive:
--
-- SELECT * FROM ordbok_raw ORDER BY engelsk;
--
-- og tilsvarende for norsk. Vi skal lære mer om sortering senere i kurset. Faktisk er filen ordbok.txt generert av følgende spørring:
--
-- SELECT engelsk, norsk, introdusert
-- FROM ordbok_raw
-- ORDER BY engelsk;
--
-- Dette dokumentet kommer til å bli oppdatert i løpet av kurset. Dersom du ønsker nyeste versjon i din database er det bare å laste inn den nye filen på
-- samme måte som du lastet inn den gamle.

DROP TABLE IF EXISTS ordbok_raw CASCADE;
BEGIN;

CREATE TABLE ordbok_raw(id serial PRIMARY KEY, engelsk text UNIQUE, norsk text, engelsk_forkortelse text, norsk_forkortelse text, introdusert text, lenke text);
INSERT INTO ordbok_raw(engelsk, norsk, engelsk_forkortelse, norsk_forkortelse, introdusert, lenke)
VALUES
('Clause', 'Klausul', NULL, NULL, '05-01', NULL),
('Join', 'Join', NULL, NULL, '02-02', NULL),
('Natural join', 'Naturlig join', NULL, NULL, '02-02', NULL),
('Inner join', 'Indre join', NULL, NULL, '02-02', NULL),
('Implicit join', 'Implisitt join', NULL, NULL, '05-01', NULL),
('Explicit join', 'Eksplisitt join', NULL, NULL, '05-01', NULL),
('Outer join', 'Ytre join', NULL, NULL, NULL, NULL),
('Self join', 'Selv-join', NULL, NULL, '05-01', NULL),
('Role', 'Rolle', NULL, NULL, NULL, NULL),
('Relational algebra', 'Relasjonsalgebra', NULL, NULL, '02-01', NULL),
('Relational model', 'Relasjonsmodell', NULL, NULL, '02-01', NULL),
('Entity-relationship model', 'Entitet-relasjonsmodell', 'ER', 'ER', '03-01', NULL),
('Entity-relationship diagram', 'Entitet-relasjonsdiagram', 'ERD', 'ERD', '03-01', NULL),
('Entity type', 'Entitetstype', NULL, NULL, '03-01', NULL),
('Relation type', 'Relasjonstype', NULL, NULL, '03-01', NULL),
('Functional dependency', 'Funksjonell avhengighet', 'FD', NULL, NULL, NULL),
('Normal form', 'Normalform', 'NF', 'NF', NULL, NULL),
('Database', 'Database', 'DB', 'DB', '01-01', NULL),
('Relational database', 'Relasjonsdatabase', 'RDB', 'RDB', '01-01', NULL),
('Database management system', 'Databasesystem', 'DBMS', 'DBS', '01-01', NULL),
('Relational database management system', 'Relasjonsdatabasesystem', 'RDBMS', 'RDBS', '01-01', NULL),
('Attribute', 'Attributt', NULL, NULL, '02-01', NULL),
('Tuple', 'Tuppel', NULL, NULL, '02-01', NULL),
('Row', 'Rad', NULL, NULL, '05-01', NULL),
('Arity', 'Aritet', NULL, NULL, '03-02', NULL),
('Atomic', 'Atomær ', NULL, NULL, NULL, NULL),
('Binary relation', 'Binærrelasjon', NULL, NULL, '03-01', NULL),
('Candidate key', 'Kandidatnøkkel', NULL, NULL, '02-01', NULL),
('Column', 'Kolonne', NULL, NULL, '05-01', NULL),
('Constraint', 'Skranke', NULL, NULL, '02-01', NULL),
('Domain', 'Domene', NULL, NULL, '02-01', NULL),
('Entity', 'Entitet', NULL, NULL, '03-01', NULL),
('Foreign key', 'Fremmednøkkel', NULL, NULL, '02-01', NULL),
('Key', 'Nøkkel', NULL, NULL, '02-01', NULL),
('Primary key', 'Primærnøkkel', NULL, NULL, '02-01', NULL),
('Query', 'Spørring', NULL, NULL, '01-01', NULL),
('Relation', 'Relasjon', NULL, NULL, '02-01', NULL),
('Relation instance', 'Relasjonsinstans', NULL, NULL, '02-01', NULL),
('Relation state', 'Relasjonstilstand', NULL, NULL, '02-01', NULL),
('Schema', 'Skjema', NULL, NULL, '02-01', NULL),
('Super key', 'Supernøkkel', NULL, NULL, '02-01', NULL),
('Table', 'Tabell', NULL, NULL, '05-01', NULL),
('Ternary relation', 'Ternærrelasjon', NULL, NULL, '03-02', NULL),
('Total participation', 'Total deltakelse', NULL, NULL, '03-01', NULL),
('Partial participation', 'Partsiell deltakelse', NULL, NULL, '03-01', NULL),
('Weak key', 'Svak nøkkel', NULL, NULL, '03-01', NULL)
;

COMMIT;
