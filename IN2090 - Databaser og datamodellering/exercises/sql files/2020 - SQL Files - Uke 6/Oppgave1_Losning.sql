CREATE TABLE Kunde (
  kundenummer INT PRIMARY KEY,
  kundenavn VARCHAR(50) NOT NULL,
  kundeadresse VARCHAR(50),
  postnr VARCHAR(4),
  poststed VARCHAR(20)
);

CREATE TABLE Ansatt (
  ansattr INT PRIMARY KEY,
  navn varchar(50) NOT NULL,
  fødselsdato date,
  ansattDato date
);

CREATE TABLE Prosjekt (
  prosjektnummer INT PRIMARY KEY,
  prosjektleder INT,
  prosjektnavn VARCHAR(50) NOT NULL,
  kundenummer INT,
  status VARCHAR(8) CHECK (status = 'planlagt' OR status = 'aktiv'
    OR status = 'ferdig'),

  FOREIGN KEY(kundenummer) REFERENCES Kunde(kundenummer),
  FOREIGN KEY(prosjektleder) REFERENCES Ansatt(ansattnr)
);

CREATE TABLE ansattDeltarIProsjekt(
  ansattnr INT,
  prosjektnummer INT,

  PRIMARY KEY(ansattnr, prosjektnummer),
  FOREIGN KEY (ansattnr) REFERENCES Ansatt(ansattnr),
  FOREIGN KEY (prosjektnummer) REFERENCES Prosjekt(prosjektnummer)
);
