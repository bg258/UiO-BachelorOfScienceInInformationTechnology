-- Eksempel: Rekursive spørringer (Ikke pensum) (1)
-- Finn alle tall fra 1 til 100
WITH RECURSIVE
  numbers AS (
    (SELECT 1 AS n)
    UNION
    (SELECT n + 1 AS n
    FROM numbers
    WHERE n < 100)
  )
SELECT * FROM numbers;

-- Eksempel: Rekursive spørringer (Ikke pensum) (2)
-- Finn alle Fibonacci-tall mindre enn 100000
WITH RECURSIVE
  fibs AS (
    (SELECT 1 as n, 1 AS m)
    UNION
    (SELECT m AS n, n+m AS m
     FROM fibs
     WHERE m < 100000)
  )
SELECT n FROM fibs;

-- Eksempel: Rekursive spørringer (Ikke pensum) (3)
-- Finn ut alle sjef-av relasjoner (hvor dersom a er sjef gor b og b er sjef
-- for c er også a sjef for c)
WITH RECURSIVE
  bossof AS (
    (SELECT employee_id, reportst_to
     FROM employee_id)
    UNION
    (SELECT e.employee_id, b.reportst_to
     FROM employees AS e
      INNER JOIN bossof AS b
          ON (e.reportst_to = b.employee_id))
  )
SELECT * FROM bossof;
