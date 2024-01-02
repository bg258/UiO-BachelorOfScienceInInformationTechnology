-- OPPGAVE 3
INSERT INTO kunde VALUES
    (123, 'Donald', '1313 Webfoot Walk', null, 'Duckburg, Calisota'),
    (124, 'Batman', 'Wayne Manor', '0123', 'Gotham City'),
    (125, 'Flanders', '740 Evergreen Terrace', '9653', 'Springfield'),
    (126, 'Paddington Bear', '32 Windsor Gardens', null, 'London'),
    (127, 'Spongebob SquarePants', '124 Conch Street', null, 'Bikini Bottom');

INSERT INTO ansatt VALUES
    (321, 'Lois Lane', '1962-01-01', '1962-08-16'),
    (320, 'Sirius Black', '1980-12-08', '2001-11-30'),
    (319, 'Lord Emsworth', '1969-9-26', '1968-11-22'),
    (318, 'Sherlock Holmes', '1965-7-29', '1964-12-4'),
    (317, 'Monica Geller', '1962-10-5', '1963-02-16');

INSERT INTO prosjekt VALUES
    (981, 321, 'Manhattan Project', 124, 'ferdig'),
    (980, 320, 'Development of Windows Vista', 123, 'aktiv');

INSERT INTO ansattDeltarIProsjekt VALUES
    (319, 981),
    (319, 980),
    (317, 980),
    (318, 981);
