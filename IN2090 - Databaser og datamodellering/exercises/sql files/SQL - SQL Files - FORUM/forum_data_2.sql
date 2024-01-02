BEGIN;

INSERT INTO forum.post(tid, username, content, posted_at) VALUES
(3, 'prue_admin', 'Please talk more about cats!', now() - '3 hours'::interval),
(1, 'prue_admin', 'Welcome to new members!', now() - '2 hours'::interval),
(2, 'david_admin', 'Welcome to new members here as well!', now() - '1 hour'::interval),
(2, 'hackzor1', 'More members, cool!', now() - '50 minutes'::interval),
(3, 'hackzor1', 'Any news on peoples cats?', now() - '49 minutes'::interval),
(3, 'qwerty', 'Mine is fine, eating now...', now() - '47 minutes'::interval),
(3, 'hackzor1', 'Awsome! Nice to hear from you!', now() - '40 minutes'::interval),
(3, 'qwerty', 'I know!', now() - '31 minutes'::interval);

INSERT INTO forum.log_entry(username, log_in, log_out) VALUES
('hackzor1', now() - '2 hours'::interval, NULL),
('mary_sim', now() - '2 hours'::interval, now() - '1 hour'::interval),
('qwerty', current_date - '3 hours'::interval, NULL),
('nandrez', current_date - '2 hours'::interval, current_date + '2 hours'::interval),
('us3r', now() - '1 hour'::interval, NULL),
('hackzor1', current_date - '5 hours'::interval, current_date - '3 hours'::interval);

COMMIT;

