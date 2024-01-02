CREATE TABLE Ansatt(
  nr INT PRIMARY KEY,
  lønn INT,
  trekk INT,
  CHECK (
    (lønn IS NOT NULL AND trekk IS NOT NULL)
    OR
    (lønn IS NULL AND trekk IS NULL)
  )
);
