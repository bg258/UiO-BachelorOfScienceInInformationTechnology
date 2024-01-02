-- Oppgave 2 - Nestede setninger
-- Skriv en spørring som bruker nestede-spørringer for å finne:
-- 1) Filmid og filmtype (fra FilmItem) for alle filmer som ble produsert
--    i 1894 (82)

SELECT fi.filmid, fi.filmtype
FROM filmitem AS fi JOIN film as f
ON fi.filmid = f.filmid
WHERE f.prodyear = 1894;

-- 2) Navn på alle kvinnelige skuespillere (cast) i filmen med filmid 357076(11)

SELECT P.firstname, P.lastname
FROM film AS F JOIN filmparticipation AS FP
ON F.filmid = FP.filmid JOIN person AS P on
FP.personid = P.personid
WHERE F.filmid = 357076 and P.gender = 'F' and FP.parttype = 'cast';
