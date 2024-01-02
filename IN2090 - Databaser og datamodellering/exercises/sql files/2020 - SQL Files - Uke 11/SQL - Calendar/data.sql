INSERT INTO calendar(event, starts, ends)
VALUES ('IN2090 lecture', current_date + '12 hours'::interval, current_date + '14 hours'::interval),
       ('Meeting with the King', current_date + '15 hours'::interval, current_date + '16 hours'::interval),
       ('Do dishes', current_date + '18 hours'::interval, current_date + '19 hours'::interval),
       ('Party', current_date + '1 day 18 hours'::interval, current_date + '1 day 19 hours'::interval),
       ('Meeting with Rob', current_date - '2 day 12 hours'::interval, current_date - '2 day 11 hours'::interval);
