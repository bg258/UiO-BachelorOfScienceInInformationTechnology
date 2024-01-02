CREATE TABLE Ansatt(
	ansatt_id int primary key, 
    navn varchar(40) not null, 
    lonn int, 
    avdNr int
);

CREATE TABLE Avdeling(
	avd_id int primary key,
    navn varchar(40) not null, 
    leder int,
    FOREIGN KEY(leder) references Ansatt(ansatt_id)
);

ALTER TABLE Ansatt 
ADD FOREIGN KEY(avd_id)
references Avdeling(avd_id)
ON DELETE SET NULL;


CREATE TABLE Prosjekt (
	prnr int not null, 
    anr INT references Ansatt(ansatt_id), 
    timer int not null,
    PRIMARY KEY(prnr, anr)
);


drop table Prosjekt;

INSERT INTO Ansatt
VALUES(1, 'Marky', 10000, 1);

INSERT INTO Avdeling 
VALUES(1, 'Databaser', 1);

INSERT INTO Prosjekt
VALUES(101, 1, 80);


/* For hver prosjekt, list opp medvirkende avdelinger som har minst 10 ansatte og sorter dem
   etter insats (Altså: ta bare med avdelinger som har minst 10 ansatte):
   
   - Ansatt(anr, navn, lonn, avd)
   - Avdeling(avdnr, a-navn, leder)
   - Prosjektplan(pnr, anr, timer)
   */

SELECT pnr AS prosjekt, avdnr AS avdnummer, 
       a-navn AS avdeling, sum(timer) AS innsats
FROM Ansatt A, Avdeling, Prosjektplan P,
WHERE avd = avdnr  AND A.anr = P.anr 
GROUP BY pnr, avdnr, a-navn
HAVING SUM(timer) > 99 AND
	9 < (SELECT COUNT(*)
         FROM Ansatt A1 
         WHERE A1.avd = avdnr)
ORDER BY prosjekt, innsats DESC;




