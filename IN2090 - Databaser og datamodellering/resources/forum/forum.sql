DROP SCHEMA IF EXISTS forum CASCADE;

BEGIN; -- Begin transaction

CREATE SCHEMA forum;

CREATE TABLE forum.member (
    username text PRIMARY KEY CHECK (NOT username LIKE '% %'),
    mail text NOT NULL CHECK (mail ~ '^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$'),
    member_since date NOT NULL CHECK (member_since <= current_date),
    mem_type text NOT NULL CHECK (mem_type = 'normal' OR mem_type = 'admin') DEFAULT 'normal'
);
CREATE TABLE forum.thread (
    tid int PRIMARY KEY,
    name text NOT NULL
);
CREATE TABLE forum.post (
    tid int REFERENCES forum.thread(tid),
    username text REFERENCES forum.member(username),
    posted_at timestamp NOT NULL CHECK (posted_at <= now()),
    content text NOT NULL CHECK (content != ''),
    CONSTRAINT post_pk PRIMARY KEY (tid, username, posted_at)
);
CREATE TABLE forum.log_entry (
    lid SERIAL PRIMARY KEY,
    username text REFERENCES forum.member(username),
    log_in timestamp NOT NULL CHECK (log_in <= now()),
    log_out timestamp CHECK (log_out > log_in)
);

CREATE VIEW forum.logged_in AS
SELECT m.username, now() - l.log_in AS time_logged_in, m.mail
FROM forum.member AS m
     INNER JOIN forum.log_entry AS l ON (m.username = l.username)
WHERE l.log_out IS NULL;

CREATE VIEW forum.dash_board AS
SELECT
    (SELECT count(*) FROM forum.logged_in) AS active_users,

    (SELECT count(*) FROM forum.log_entry
     WHERE log_out >= current_date::timestamp OR
           log_out IS NULL) AS logins_today,

    (SELECT count(*) FROM forum.post
     WHERE posted_at >= current_date::timestamp) AS posts_today,

    (SELECT count(*) total_nr_posts
     FROM forum.post) AS total_posts;
COMMIT;
