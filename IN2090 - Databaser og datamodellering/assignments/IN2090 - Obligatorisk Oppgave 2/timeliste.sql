INSERT INTO Timeliste (timelistenr, status, levert, utbetalt, beskrivelse)
VALUES
  (1, 'utbetalt', '2016-07-04', '2016-07-13', 'HMS-kurs'),
  (2, 'utbetalt', '2016-07-08', '2016-07-13', 'Innføring'),
  (3, 'utbetalt', '2016-07-19', '2016-07-27', 'Test av database'),
  (4, 'levert', '2016-07-20', NULL, 'Innlegging av virksomhetsdokumenter'),
  (5, 'utbetalt', '2016-07-20', '2016-07-27', 'Oppsporing av manglende underlagsinformasjon'),
  (6, 'aktiv', NULL, NULL, 'Identifisering av manglende funksjonalitet'),
  (7, 'utbetalt', '2016-08-01', '2016-08-10', 'Opprettelse av testdatabase'),
  (8, 'aktiv', '2016-08-10', NULL, 'Videreutvikling av testdatabase');

/*

1|utbetalt|2016-07-04|2016-07-13|HMS-kurs
2|utbetalt|2016-07-08|2016-07-13|Innføring
3|utbetalt|2016-07-19|2016-07-27|Test av database
4|levert|2016-07-20||Innlegging av virksomhetsdokumenter
5|utbetalt|2016-07-20|2016-07-27|Oppsporing av manglende underlagsinformasjon
6|aktiv|||Identifisering av manglende funksjonalitet
7|utbetalt|2016-08-01|2016-08-10|Opprettelse av testdatabase
8|aktiv|2016-08-10||Videreutvikling av testdatabase

*/
