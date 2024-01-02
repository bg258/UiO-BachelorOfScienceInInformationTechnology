-- Calender "database"
DROP TABLE IF EXISTS calendar;
CREATE TABLE calendar(
  eid SERIAL PRIMARY KEY,
  event TEXT NOT NULL,
  starts timestamp(0) NOT NULL,
  ends timestamp(0)
  CHECK (starts < ends)
);
