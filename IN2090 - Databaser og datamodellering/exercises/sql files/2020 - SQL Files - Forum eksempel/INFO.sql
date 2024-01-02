CREATE VIEW
  forum.logged_in AS
    SELECT m.username, now() - l.logged_in AS time_logged_in, m.mail
    FROM forum.member AS m
      INNER JOIN forum.log_entry AS l ON (m.username = l.username)
    WHERE l.log_out IS NULL;


CREATE VIEW forum.dash_board AS
  SELECT
    (SELECT count(*)
      FROM forum.logged_in) AS active_users ,
    (SELECT count(*)
      FROM forum.log_entry
      WHERE log_out >= current_date::timestamp OR
      log_out IS NULL) AS logins_today ,
    (SELECT count(*)
    FROM forum.thread AS t
    INNER JOIN forum.post AS p
    ON (t.tid = p.tid)
    WHERE posted_at >= current_date::timestamp) AS posts_today,
    (SELECT count(*) total_nr_posts FROM forum.thread AS t
    INNER JOIN forum.post AS p
    ON (t.tid = p.tid)) AS total_posts;
