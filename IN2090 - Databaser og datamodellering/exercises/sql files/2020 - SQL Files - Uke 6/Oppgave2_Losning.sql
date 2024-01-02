-- OPPGAVE 2
/*
a) Ansatt: ansattnr
   AnsattDeltarIProsjekt: {ansattnr, prosjektnr} (én primærnøkkel som består av to attributter)
b) Ansatt: ansattnr
   AnsattDeltarIProsjekt: ansattnr og prosjektnr
c) ansattnr (kandidatnøkkel = minimal supernøkkel. Primærnøkler er dermed også kandidatnøkler)
d) Alle kombinasjoner av attributter der kombinasjonen kun gir unike tupler, dvs alle kombinasjoner
   som består av minst én kandidatnøkkel: {ansattnr}, {ansattnr, navn}, {ansattnr, fødselsdato},
   {ansattnr, navn, fødselsdato}, {ansattnr, ansattdato}, {ansattnr, navn, ansattdato},
   {ansattnr, navn, fødselsdato, ansattdato}
e) kundenummer -> kundenavn, kundeadresse, postnr, poststed
   postnr -> poststed
