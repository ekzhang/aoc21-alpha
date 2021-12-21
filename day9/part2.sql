SELECT DISTINCT COUNT(*) size FROM -
  WHERE component != -1
  GROUP BY component
  ORDER BY size DESC
  LIMIT 3
