CREATE OR REPLACE VIEW vista_mis_examenes AS
SELECT 
  ee.estudiante_id,
  e.id AS evaluacion_id,
  e.nombre AS nombre_evaluacion,
  c.nombre AS nombre_curso,
  ROUND(NVL(ee.calificacion, 0), 2) AS calificacion,
  ee.fecha_inicio,
  ee.fecha_fin,
  NVL(ROUND((CAST(ee.fecha_fin AS DATE) - CAST(ee.fecha_inicio AS DATE)) * 24 * 60, 2), 0) AS tiempo_minutos,
  est.nombre AS estado_evaluacion
FROM evaluacion_estudiante ee
JOIN evaluacion e ON e.id = ee.evaluacion_id
JOIN curso c ON c.id = ee.curso_id
JOIN estado_evaluacion_estudiante est ON est.id = ee.estado_id;
