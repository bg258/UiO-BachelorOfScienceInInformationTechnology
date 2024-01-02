-- OPPGAVE 5
-- 5a
UPDATE kunde
SET postnr = '9999'
WHERE kundenummer = 126;
-- 5b
INSERT INTO ansatt VALUES (404, 'You are fired', null, null);
DELETE FROM ansatt WHERE ansattnr = 404;
