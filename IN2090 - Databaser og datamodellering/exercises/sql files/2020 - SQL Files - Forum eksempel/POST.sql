CREATE TABLE forum.post(
  tid int REFERENCES forum.thread(tid),
  username text REFERENCES forum.member(username),
  posted_at timestamp NOT NULL
    CHECK (posted_at <= now()),
  content text NOT NULL
    CHECK (content != ' '), 
  CONSTRAINT
    post_pk PRIMARY KEY (tid, username, posted_at)
);
