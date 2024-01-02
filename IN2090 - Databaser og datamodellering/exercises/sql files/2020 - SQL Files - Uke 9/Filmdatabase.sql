CREATE TABLE Film(
	filmid int AUTO_INCREMENT,
	title varchar(100), 
    productionYear int(4),
    PRIMARY KEY(filmid)
);

CREATE TABLE Filmgenere(
	genre varchar(10), 
    filmid int,
    FOREIGN KEY(filmid) references Film(filmid)
);

INSERT INTO Film(filmid, title)
VALUES(filmid, 'Pirates of the Caribean', 2008);

INSERT INTO Film(filmid, title)
VALUES(filmid, 'The fast and the furious');

INSERT INTO Film(filmid, title)
VALUES(filmid, 'Pirates of the Caribean: Stonesearch');

INSERT INTO Filmgenere(genre, filmid)
VALUES('Comedy', 1);

INSERT INTO Filmgenere(genre, filmid)
VALUES('Family', 2);

INSERT INTO Film(filmid, title)
VALUES(filmid, '300: Rise of an empire');

CREATE TABLE Filmcountry(
	Country VARCHAR(40), 
    filmid int,
    FOREIGN KEY(filmid) references Film(filmid)
);

INSERT INTO Filmcountry
VALUES('Norway', 1);

INSERT INTO Filmcountry
VALUES('USA', 2);

INSERT INTO Filmcountry
VALUES('Norway', 3);

INSERT INTO Filmcountry
VALUES('Norway', 4);



CREATE TABLE Person(
	personid int primary key auto_increment,
	fornavn VARCHAR(40), 
    etternavn VARCHAR(40) 
);

INSERT INTO Person 
VALUES(personid, 'Mark', 'Tzvetoslavov');

INSERT INTO Person 
VALUES(null, 'Tzvetoslavov');

INSERT INTO Person 
VALUES('Mark', 'Tzvetoslavov');

INSERT INTO Person 
VALUES('Mark', 'Tzvetoslavov');

INSERT INTO Person 
VALUES(personid, 'Juan', 'Janek');

INSERT INTO Person 
VALUES('Mark', 'Tzvetoslavov');

INSERT INTO Person 
VALUES('Juan', 'Janek');

INSERT INTO Person 
VALUES(null, 'Tzvetoslavov');

CREATE TABLE Participation(
	pid integer PRIMARY KEY,
	personid integer references Person(personid),
    partName VARCHAR(40),
    filmid integer references Film(filmid)
);


INSERT INTO Participation
VALUES (1, 1, 'director', 1);

INSERT INTO Participation
VALUES (4, 1, 'director', 3);
	
CREATE TABLE ParticipationValue(
	pid integer references Participation,
    value VARCHAR(40)
);