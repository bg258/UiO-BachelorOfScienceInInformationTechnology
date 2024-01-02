-- SQL
/*
En ting vi gjerne ønsker å ha lagret i en database, er informasjon om et firmas
kunder, prosjekter og ansatte. I denne oppgaven har vi et relasjonsdatabaseskjema
for slike data, som ser slik ut:

Kunde(kundenummer, kundenavn, [kundeadresse], [postnr], [poststed])
Prosjekt(prosjektnummer, [prosjektleder], prosjektnavn, [kundenummer], [status])
Ansatt(ansattnr, navn, [fødselsdato], [ansattDato])
AnsattDeltarIProsjekt(ansattnr, prosjektnr)

I relasjonene er det som står før parantesen relasjonsnavnet, de kommaseparerte
ordene er relasjonsattributer, mens det som er understrekket er primærnøkkelen.
Der flere attributer er understrekket, er primærnøkkelen kombinasjonen av
attributene. Attributer som står i [klammeparanteser ], er attributer som kan
inneholde null

Relasjonene har følgende fremmednøkkler:
Prosjekt(kundenummer) → Kunde(kundenummer)
AnsattDeltarIProsjekt(prosjektnr) → Prosjekt(prosjektnummer)
Prosjekt(prosjektleder) → Ansatt(ansattnr)
AnsattDeltarIProsjekt(ansattnr) → Ansatt(ansattnr)

Det er anbefalt å gjøre oppgavene i rekkefølgen som er satt opp.
 */

-- Oppgave 1 - CREATE TABLE
-- Skriv SQL setninger som oppretter tabellene i skjemaet. Finn passende datatyper
-- for attributene . I tillegg ønsker vi at attrbuttet status i relasjonen PROSJEKT
-- kun skal kunne inneholde verdiene planlagt, aktiv eller ferdig.

CREATE TABLE Kunde(
  kundenummer integer PRIMARY KEY auto_increment,
  kundenavn varchar(20) not null,
  kundeadresse varchar(15),
  postnr integer(4),
  poststed varchar(15)
);

-- or

CREATE TABLE Kunde(
  kundenummer int auto_increment,
  kundenavn text NOT NULL,
  kundeadresse text NOT NULL,
  postnr int,
  poststed text,

  CONSTRAINT kunde_nummer PRIMARY KEY(kundenummer)
);


CREATE TABLE Prosjekt (
  prosjektnummer int auto_increment,
  prosjektleder int,
  prosjektnavn text not null,
  kundenummer int,
  status text,
  CONSTRAINT sjekkStatus CHECK (status = 'planlagt'
                             OR status = 'aktiv'
                             OR status = 'ferdig'),
  PRIMARY KEY(prosjektnummer),
  FOREIGN KEY(kundenummer) REFERENCES Kunde(kundenummer)
);

-- ALTER TABLE Prosjekt
-- FOREIGN KEY (prosjektleder) REFERENCES Ansatt(ansattr);

CREATE TABLE Ansatt(
  ansattnr int PRIMARY KEY auto_increment,
  navn text not null,
  fodselsdato date,
  ansattDato date
);

CREATE TABLE AnsattDeltarIProsjekt(
  ansattnr int,
  prosjektnr int,
  PRIMARY KEY(ansattnr, prosjektnr),
  FOREIGN KEY(ansattnr) REFERENCES Ansatt(ansattnr),
  FOREIGN KEY(prosjektnr) REFERENCES Prosjekt(prosjektnummer)
);


ALTER TABLE Prosjekt
ADD FOREIGN KEY (prosjektleder)
REFERENCES Ansatt(ansattnr);
