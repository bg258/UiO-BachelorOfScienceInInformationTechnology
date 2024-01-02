-- Oppgave 4 - SELECT
-- Skriv SQL-spørringer som henter ut følgende informasjon:
-- A) En liste med alle kunder. Listen skal inneholde kundenummer, kundenavn
--    og kundeadresse.

SELECT kundenummer, kundenavn, kundeadresse
FROM Kunde;

-- B) Navn på alle prosjektledere. Dersom en ansatt er prosjektleder for flere
--    prosjekter skal navnet kun forekomme en gang.

SELECT DISTINCT A.navn
FROM Ansatt AS A
  INNER JOIN Prosjekt AS P ON (A.ansattnr = P.prosjektleder);

-- C) Alle ansatnummerene som er knyttet til prosjektet med prosjektnavn "Ruter App"
--    I dette tilfelle har jeg ikke et prosjekt som heter "Ruter App". Jeg har
--    valgt derfor å kalle på prosjektet med navn 'PROJECT INVICTUS'

SELECT A.ansattnr
FROM AnsattDeltarIProsjekt AS AP
  INNER JOIN Ansatt AS A ON (AP.ansattnr = A.ansattnr)
  INNER JOIN Prosjekt AS P ON (AP.prosjektnr = P.prosjektnummer)
WHERE P.prosjektnavn = 'PROJECT INVICTUS';

-- D) En liste over ansatte som er knyttet til prosjekter som har kunden med
--    med navn "NSB".
--    I dette tilfelle har jeg ikke et kunde med navn "NSB" så velger
--    i stedet å bruke kunden med navn "Richard C Banks"

SELECT A.ansattnr AS ID, A.navn AS Name
FROM AnsattDeltarIProsjekt AS AP
  INNER JOIN Ansatt AS A ON (AP.ansattnr = A.ansattnr)
  INNER JOIN Prosjekt as P ON (AP.prosjektnummer = P.prosjektnummer)
  INNER JOIN Kunde AS K ON (K.kundenummer = P.kundenummer)
WHERE K.kundenavn = 'Richard C Banks';
