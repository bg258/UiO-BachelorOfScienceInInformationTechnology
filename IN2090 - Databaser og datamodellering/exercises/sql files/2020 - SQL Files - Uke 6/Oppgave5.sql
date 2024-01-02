-- Oppgave 5 - CRUD
-- De siste ukene har vi sett på hvordan vi henter ut informasjon fra en
-- database. Dette er bare en del av helheten - i en database vil vi normalt
-- også legge inn, endre og slette data.

-- Disse 4 grunnlegende operasjonene kalles gjerne CRUD - Create, Read, Update, Delete
-- I dette oppgavesettet har du også prøvd deg på create delen, nemlig INSERT.
-- For å fullføre kabalen må vi lære oss de to siste operasjonene:

-- Finn ut hvordan du kan bruke UPDATE for å endre en tuppel. . Skriv en
-- UPDATE-spørring som endrer en rad du la inn i Oppgave 3.

UPDATE Kunde
SET postnr = 1111
WHERE postnr > 45000;

-- Finn ut hvordan du kan bruke DELETE for å slette en tuppel.
-- Skriv en DELETE- spørring som sletter én rad du la inn i Oppgave 3
-- (eller legg til en ny rad som du så sletter).

DELETE
FROM AnsattDeltarIProsjekt
WHERE ansattnr = 12;
