CREATE OR REPLACE VIEW vista_progreso_estudiantes_por_curso AS
SELECT 
  c.id AS curso_id,
  c.nombre AS nombre_curso,
  u.id AS estudiante_id,
  u.nombre AS nombre_estudiante,
  COUNT(DISTINCT ee.evaluacion_id) AS evaluaciones_presentadas,
  COUNT(DISTINCT ec.evaluacion_id) AS evaluaciones_totales,
  ROUND(
    (COUNT(DISTINCT ee.evaluacion_id) * 100.0) / 
    NULLIF(COUNT(DISTINCT ec.evaluacion_id), 0), 2
  ) AS progreso
FROM curso c
JOIN curso_estudiante ce ON ce.curso_id = c.id
JOIN usuario u ON u.id = ce.estudiante_id
LEFT JOIN evaluacion_curso ec ON ec.curso_id = c.id
LEFT JOIN evaluacion_estudiante ee ON ee.estudiante_id = u.id AND ee.curso_id = c.id
GROUP BY c.id, c.nombre, u.id, u.nombre;
