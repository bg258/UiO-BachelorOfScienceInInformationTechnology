Oppgave 5a)

Den greieste måten å sikre at studenter som registreres i Aktivitet
har opptak til emnet det registreres opptak til, er å la (bnavn, emne)
i Aktivitet være fremmednøkkel til opptak, slik det er gjort i
definisjonen av Aktivitet i oppgave 5b nedenfor.

Fordelen er at vi sikrer at integritetsregelen «en student må ha
opptak til emnet før aktivitet i emnet kan registreres» håndheves av
databasen. Dette skjer fordi det ikke er mulig å legge inn slik
aktivitet. Systemet vil ikke godta tuppelet.

Ulempen ved å implementere slike regler, er at feilsituasjoner kan
oppstå ved innsetting, sletting og endring av tupler i databasen:

Hvis en aktivitet i et emne for en student registreres før opptak til
emnet er registrert, vil vi få feil.

Hvis vi sletter et opptak i et emne for en student som det er
registrert aktivitet i emnet i, vil vi få en feilsituasjon.

Hvis vi endrer på verdien av (bnavn, emne) i en av de to tabellene kan
også en feil oppstå.


Oppgave 5b)

create table Aktivitet (
       bnavn char(8),
       emne varchar(12),
       dato date,
       akt varchar(2),
       min int,
       primary key (bnavn, emne, dato, akt),
       foreign key (bnavn, emne) references Opptak -- kan sløyfes
);


Oppgave 6

-- antar at fdato er CHAR(6)

select navn
from Student s, Opptak o
where s.bnavn = o.bnavn
    and o.emne = 'INF1300'
    and s.fdato like '__04__'
;

Oppgave 7

-- definerer sql-setningen Q:
(antall utenfor Oslo)

select count(bnavn)
from Student s, Opptak o
where s.bnavn = o.bnavn
    and o.emne = 'INF1000'
    and s.studieprogram like '%Design%'
    and s.postnr > '1299'

-- Den nestede setningen som skriver ut de to heltallene:

select (Q)              as antall_utenfor_Oslo,
       count(bnavn)-(Q) as antall_i_Oslo
from Student s, Opptak o
where s.bnavn = o.bnavn
    and o.emne = 'INF1000'
    and s.studieprogram like '%Design%'
;

-- her synes jeg to select setninger (Q og Q med «and s.postnr <= 1299»)
-- bør gi 100%.
-- plusspoeng til dem som tar hensyn til nil i postnr


Oppgave 8

-- hvis pnr er CHAR(5)

update Student
set kjønn = 'K'
where kjønn is null and
     (pnr like '__0__'
   or pnr like '__2__'
   or pnr like '__4__'
   or pnr like '__6__'
   or pnr like '__8__')
;

-- hvis pnr er INT

update Student
set kjønn = 'M'
where kjønn is null
    and (pnr//100) mod 10 in ('1','3','5','7','9')
;

Oppgave 9

-- Den indre setningen Q teller opp antall ukeoppgaver i INF1000:

select count(*)
from Ukeoppg
where emne = 'INF1000'


select bnavn
from (select bnavn, count(*)
      from Oppgave
      where emne = 'INF1000'
            and oppgaveid not like 'oblig%'
            and status is not null
            and status <> 'dg'
      group by bnavn
      having count(*) = ( Q ))
;

Oppgave 10

-- Tolkning A: ikke annen aktivitet enn oblig i Aktivitet, dvs kun
-- akt like 'o%'. Da gir følgende setning (Q) (bnavn, emne) hvor denne
-- betingelsen er brutt:

select bnavn, emne
from Aktivitet
where akt not like 'o%';

select emne, count (bnavn) as antall
from   Eksamen
where  karakter = 'F' 
       and (bnavn, emne) not in ( Q )
group by emne
;


-- Tolkning B: ikke annen status registrert i Oppgave, enn 'gk', 'ig'
-- (obliger) og 'dg' (stud har ikke arbeidet med ukeoppgaven). Da gir
-- følgende setning (Q) et par (bnavn, emne) hvor betingelsen brytes
-- (studenten har arbeidet med minst en annen oppgave som ikke er oblig):

select bnavn, emne
from   Oppgave
where  oppgaveid not like 'oblig%'
       and status is not null
       and status <> 'dg'
;
    

select emne, count (bnavn) as antall
from   Eksamen
where  karakter = 'F'
       and (bnavn, emne) not in ( Q )
group by emne
;

Oppgave 11

-- Lager et view av forrige setning;

create view AntBareOblig (emne, ant) as
       select emne, count (bnavn)
       from   Oppgave
       where   (bnavn, emne) not in ( Q )
       group by emne
;

create view AntUkeOppg (emne, bnavn, ant) as
       select emne, bnavn, count(*)
       from   Oppgave
       where  oppgaveid not like 'oblig%'
       and
       




select e.emne, karakter,
       count(e.bnavn) as antall,
       bareobl,
       avg(antuoppg),
       avg(a.min)
from Eksamen e, Aktivitet a
group by e.emne, e.karakter
       



