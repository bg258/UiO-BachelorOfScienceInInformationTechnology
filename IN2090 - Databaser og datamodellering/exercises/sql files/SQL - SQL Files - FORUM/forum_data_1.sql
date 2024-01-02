
BEGIN;

-- Insert adim members
INSERT INTO forum.member(username, mail, member_since, mem_type) VALUES
('prue_admin', 'admin@forum.com', '2019-01-03', 'admin'),
('david_admin', 'david@forum.com', '2019-01-03', 'admin'),
('kari_admin', 'kari@forum.com', '2019-04-12', 'admin');

-- Insert regular members
INSERT INTO forum.member(username, mail, member_since) VALUES
('hackzor1', 'hack@noobmail.com', '2019-01-10'),
('peter', 'peter_hs@outlook.com', '2019-04-11'),
('mary_sim', 'ms@gmail.com', '2020-02-10'),
('rartwa', 'rtw@hotmail.com', '2019-01-11'),
('qwerty', 'carl_pt@hotmail.com', '2019-02-11'),
('nandrez', 'my_mail@nandrez.com', '2020-05-17'),
('us3r', 'kari_norman@kvasir.no', '2020-08-19');

INSERT INTO forum.thread VALUES
(1, 'general'),
(2, 'greetings'),
(3, 'cats');

INSERT INTO forum.post(tid, username, content, posted_at) VALUES
(1, 'prue_admin', 'Welcome everyone! Im the admin, Prue!', '2019-01-03 12:00:00'),
(1, 'david_admin', 'I am the other admin, David!', '2019-01-03 12:03:10'),
(2, 'hackzor1', 'Hello, I am hackzor!', '2019-01-10 13:37:01'),
(2, 'mary_sim', 'Hello, I am Mary!', '2020-02-10 11:29:31'),
(2, 'qwerty', 'Is this a forum for cats?', '2019-02-12 11:09:30'),
(2, 'prue_admin', 'Its for anything :)', '2019-02-12 11:10:20'),
(3, 'prue_admin', 'I made this for talking about cats!', '2019-02-12 11:11:51'),
(3, 'qwerty', 'Great, thanks! Which cat is your fav?', '2019-02-12 13:40:28'),
(3, 'nandrez', 'Mine is leo, my cat...', '2020-05-17 18:00:18'),
(3, 'us3r', 'I like leo too!', '2020-05-21 18:01:37');

INSERT INTO forum.log_entry(username, log_in, log_out) VALUES
('prue_admin', '2019-01-03 11:59:11', NULL),
('david_admin', '2019-01-03 11:59:23', '2019-02-02 12:00:00'),
('david_admin', '2019-02-03 08:00:01', '2020-01-01 23:13:43'),
('david_admin', '2020-01-03 08:00:08', NULL),
('hackzor1', '2019-01-10 13:30:01', '2019-01-10 13:45:02'),
('hackzor1', '2019-01-10 13:30:01', '2019-01-10 13:45:02'),
('mary_sim', '2020-02-10 11:20:10', '2020-02-10 12:32:19'),
('qwerty', '2019-02-12 10:21:00', '2019-02-13 20:10:09'),
('nandrez', '2020-05-16 00:38:19', '2020-05-19 21:49:23'),
('us3r', '2020-05-21 18:00:09', '2020-05-21 19:03:11'),
('hackzor1', '2019-01-10 13:30:01', '2019-01-10 13:45:02');

COMMIT;
