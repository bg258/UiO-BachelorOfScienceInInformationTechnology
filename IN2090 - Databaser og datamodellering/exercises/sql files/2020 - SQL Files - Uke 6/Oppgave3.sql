-- Oppgave 3- INSERT
-- Fyll tabellene med data. Skriv insert-setninger som gjør det mulig å teste
-- noen av select-setningene som skal skrives i neste oppgave.

-- Kunde tabell - 6 Kunder
INSERT INTO Kunde (kundenummer, kundenavn, kundeadresse, postnr, poststed)
VALUES
  (kundenummer, 'Lena R Willingham', '561  Woodridge Lane', 49092, 'Vicksburg'),
  (kundenummer, 'Manuel M Norman', '415  Fantages Way', 04240, 'Lewiston'),
  (kundenummer, 'Richard C Banks', '2438  Rockwell Lane', 27801, 'Rocky Mount'),
  (kundenummer, 'Tara F Thaxton', '1633  Metz Lane', 02192, 'Needham'),
  (kundenummer, 'Johnny J Donaldson', '1803  Oak Way', 63868, 'Morehouse'),
  (kundenummer, 'Bonita D Griggs', '2197  Rogers Street', 45202, 'Cincinnati');

-- Ansatt tabell - 15 Ansatte
INSERT INTO Ansatt (ansattnr, navn, fodselsdato, ansattDato)
VALUES
  (ansattnr, 'Naomi J Livingstone', '1949-4-28', '2005-01-01'),
  (ansattnr, 'Gary L Bartlett', '1985-10-28', '2003-01-01'),
  (ansattnr, 'Leonard J Thomas', '1989-10-24', '2001-01-01'),
  (ansattnr, 'Kim L Crump', '1958-11-7', '2005-01-01'),
  (ansattnr, 'Carol M Glass', '1963-6-19', '2005-01-01'),
  (ansattnr, 'Clifton M McFarlane', '1970-3-31', '2003-01-01'),
  (ansattnr, 'Kathryn R Jenkins', '1958-3-29', '2003-01-01'),
  (ansattnr, 'Cynthia E Rapp', '1973-10-23', '2001-01-01'),
  (ansattnr, 'Jesus L Christiansen', '1980-12-5', '2005-01-01'),
  (ansattnr, 'Otto D Newcombe', '1961-7-9', '2003-01-01'),
  (ansattnr, 'Amy P Harris', '1995-2-17', '2005-01-01'),
  (ansattnr, 'Margaret J Augustine', '1963-4-2', '2003-01-01'),
  (ansattnr, 'Patsy N Whitmarsh', '1988-3-20', '2003-01-01'),
  (ansattnr, 'Helen S Prescott', '1982-4-15', '2005-01-01'),
  (ansattnr, 'Essie D Craft', '1975-1-3', '2001-01-01');


-- Prosjekt tabell
INSERT INTO Prosjekt (prosjektnummer, prosjektleder, prosjektnavn, kundenummer, status)
VALUES
  (prosjektnummer, 2, 'PROJECT BOGOTA', 1, 'planlagt'),
  (prosjektnummer, 4, 'PROJECT VEYRON', 3, 'aktiv'),
  (prosjektnummer, 15, 'PROJECT INVICTUS', 4, 'planlagt');


-- AnsattDeltarIProsjekt tabell
INSERT INTO AnsattDeltarIProsjekt(ansattnr, prosjektnr)
VALUES
  (1, 1),
  (2, 1),
  (4, 1),
  (6, 1),
  (8, 1),
  (10, 1),
  (3, 2),
  (5, 2),
  (7, 2),
  (9, 2),
  (11, 2),
  (12, 3),
  (13, 3),
  (14, 1),
  (15, 1),
  (15, 3),
  (2, 2),
  (2, 3),
  (8, 3),
  (9, 1),
  (14, 2),
  (13, 1),
  (12, 2),
  (1, 2);
