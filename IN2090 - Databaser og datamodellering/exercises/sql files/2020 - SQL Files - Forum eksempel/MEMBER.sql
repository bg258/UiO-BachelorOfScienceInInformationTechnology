-- Eksempel: Database for et forum
-- I tillegg ønsker vi at følgende skal holde:

-- 1. Username skal ikke kunne inneholde mellomrom

CREATE SCHEMA FORUM;

CREATE TABLE Member(
  username text PRIMARY KEY,
  CONSTRAINT CHECK (username NOT LIKE '% %'),
  email text,
  CHECK (email LIKE '%@%.%'),
  type varchar(8) DEFAULT 'normal'
  CHECK (type = 'normal' OR type = 'admin'),
  MemberSince date
  CHECK (MemberSince <= now())
);

-- Løsningsforslag
CREATE SCHEMA forum;
CREATE TABLE FORUM.member(
  username text PRIMARY KEY
    CHECK (NOT username LIKE '% %'),
  mail text NOT NULL
    CHECK (mail LIKE '%@%.%'),
  -- ^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$'
  member_since date NOT NULL
    CHECK (member_since <= CURRENT_DATE),
  mem_type text NOT NULL
    CHECK (mem_type = 'normal' OR mem_type = 'admin')
);
