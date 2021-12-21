SELECT SUM(a.value + 1) FROM - a
  WHERE NOT EXISTS (
    SELECT 1 FROM - b
    WHERE (
      (a.row = b.row - 1 AND a.col = b.col) OR
      (a.row = b.row + 1 AND a.col = b.col) OR
      (a.row = b.row AND a.col = b.col - 1) OR
      (a.row = b.row AND a.col = b.col + 1)
    ) AND b.value <= a.value
  )
