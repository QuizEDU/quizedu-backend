CREATE OR REPLACE VIEW vista_evaluaciones_disponibles AS
SELECT
  ce.estudiante_id,
  ec.evaluacion_id,
  e.nombre AS nombre_evaluacion,
  e.descripcion,
  e.tiempo_maximo,
  ec.fecha_apertura,
  ec.fecha_cierre,
  ec.intentos_permitidos,
  NVL(ee.intentos_realizados, 0) AS intentos_realizados,
  ce.CURSO_ID AS curso_id,
  c.nombre AS nombre_curso
FROM curso_estudiante ce
JOIN evaluacion_curso ec ON ce.curso_id = ec.curso_id
JOIN evaluacion e ON ec.evaluacion_id = e.id
JOIN curso c ON c.id = ce.curso_id
LEFT JOIN (
  SELECT evaluacion_id, estudiante_id, COUNT(*) AS intentos_realizados
  FROM evaluacion_estudiante
  GROUP BY evaluacion_id, estudiante_id
) ee ON ee.evaluacion_id = e.id AND ee.estudiante_id = ce.estudiante_id
WHERE CURRENT_TIMESTAMP BETWEEN ec.fecha_apertura AND ec.fecha_cierre;
