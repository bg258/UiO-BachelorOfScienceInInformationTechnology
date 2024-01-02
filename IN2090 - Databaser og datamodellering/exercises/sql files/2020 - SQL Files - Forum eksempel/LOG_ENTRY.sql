CREATE TABLE Log_Entry(
  LID text,
  login date
    CHECK (login <= current_date AND login IS NOT NULL),
  logout date
    CHECK (login < logout),

  PRIMARY KEY(LID, login, logout),
  FOREIGN KEY(LID) REFERENCES Member(username)
);

-- Løsningsforslag
CREATE TABLE forum.log_entry(
  lid int PRIMARY KEY,
  username text REFERENCES forum.member(username),
  log_in timestamp NOT NULL
    CHECK (log_in <= now()),
  log_out timestamp
    CHECK (log_out > log_in)
);
