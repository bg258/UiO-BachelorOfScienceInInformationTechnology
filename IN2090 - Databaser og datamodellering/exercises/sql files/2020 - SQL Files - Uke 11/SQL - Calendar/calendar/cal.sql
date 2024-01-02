DROP TABLE IF EXISTS calendar;
CREATE TABLE calendar(
    eid SERIAL PRIMARY KEY,
    event text NOT NULL,
    starts timestamp(0) NOT NULL,
    ends timestamp(0) CHECK (starts < ends)
);
