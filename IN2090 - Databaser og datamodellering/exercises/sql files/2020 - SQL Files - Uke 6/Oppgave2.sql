/*
Oppgave 2 - Teori
a) Hva er primærnøkkelen i relasjonens Ansatt?
   Primaærnøkkelen i relasjonen ansatt er ansattnr

   Hva med relasjonen AnsattDeltarIProsjekt?
   Primærnøkkelen i relasjonen AnsattDeltarIProsjekt er ansattr + prosjektnr.
   Vi kan tenke at dette er en primaernøkkel som består av to attributer.

b) Hva er nøkkelattributtene i relasjonen Ansatt?
   Nøkkelattributtet i dette tilfelle er forsatt ansattnr siden navn trenger
   ikke å være unik siden to ansatte kan ha samme navn og fodselsdato og ansattDato
   kan også gjentas flere ganger i databasen og er ikke unik.

   Hva med relasjonen AnsattDeltarIProsjekt?
   Jeg tenker at i dette tilfelle gjelder det samme som i første oppgave, altså
   ansattnr + prosjektnr siden kombinasjonen av disse gir oss unike verdier.
   Dersom vi velger å ta bort et attribut, får vi ikke da lenger det vi
   letter etter.

c) Har relasjonen Ansatt en kandidatnøkkel? I så fall, hva er kandidatnøkkelen?
  ansattnr (kandidatnøkkel = minimal supernøkkel. Primærnøkler er
  dermed også kandidatnøkler)

d) Alle kombinasjoner av attributter der kombinasjonen kun gir unike tupler, dvs alle kombinasjoner
   som består av minst én kandidatnøkkel: {ansattnr}, {ansattnr, navn}, {ansattnr, fødselsdato},
   {ansattnr, navn, fødselsdato}, {ansattnr, ansattdato}, {ansattnr, navn, ansattdato},
   {ansattnr, navn, fødselsdato, ansattdato}
e) kundenummer -> kundenavn, kundeadresse, postnr, poststed
  postnr -> poststed
