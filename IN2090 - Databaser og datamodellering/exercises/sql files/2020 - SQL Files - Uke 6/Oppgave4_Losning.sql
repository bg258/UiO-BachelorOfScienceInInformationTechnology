-- A) En liste med alle kunder. Listen skal inneholde kundenummer, kundenavn
--    og kundeadresse

SELECT k.kundenummer, k.kundenavn, k.kundeadresse
FROM kunde k;

-- B) Navn på alle prosjektledere. Dersom en ansatt er prosjektleder for flere
--    prosjekter skal navnet kun forekomme en gang.
SELECT DISTINCT a.navn
FROM prosjekt p
  INNER JOIN ansatt a ON p.prosjektleder = a.ansattnr;

-- C) Alle ansattnummerene som er knyttet til prosjektet med prosjektnavn "Ruter App"
SELECT adip.ansattnr
FROM AnsattDeltarIProsjekt adip
  INNER JOIN prosjekt p ON adip.prosjektnummer = p.prosjektnummer
WHERE p.prosjektnavn = = 'Manhattan Project'; --'Ruter App';
-- Samme type oppgave, mer eksplosivt prosjekt.

-- D) En liste over ansatte som er knyttet til prosjekter som har kunden med
--    navn "NSB"
SELECT a.*
FROM kunde k
  INNER JOIN prosjekt p on k.kundenummer = p.kundenummer
  INNER JOIN AnsattDeltarIProsjekt adip on p.prosjektnummer = adip.prosjektnummer
  INNER JOIN Ansatt a ON adip.ansattnr = a.ansattnr
WHERE k.kundenavn = = 'Batman'; -- 'NSB';
-- Samme type oppgave, flere flaggermuser.
