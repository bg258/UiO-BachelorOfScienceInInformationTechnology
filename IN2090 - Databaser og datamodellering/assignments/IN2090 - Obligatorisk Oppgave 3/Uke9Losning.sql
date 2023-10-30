-- Avansert SQL - Bruk Filmdatabasen
-- 1) Hvilke verdier forekommer i attributtet filmtype i relasjonen filmitem?
--    Lag en oversikt over filmtypene og hvor mange filmer innen hver type

SELECT filmtype, COUNT(*) AS ant
FROM filmitem
GROUP BY filmtype
ORDER BY ant DESC;

-- 2) Skriv ut serietittel, produksjonsår og antall episoder for de 15 eldste
--    TV-seriene i filmdatabasen (sortert stigende etter produksjonsår)

SELECT s.seriesid, maintitle, firstprodyear, COUNT(e.episodeid)
FROM series s
  INNER JOIN episode e ON s.serieid = e.seriesid
GROUP BY s.seriesid, maintitle, firstprodyear
ORDER BY firstprodyear ASC
LIMIT 15;

-- 3) Mange titler har vært i bruk i flere filmer.
