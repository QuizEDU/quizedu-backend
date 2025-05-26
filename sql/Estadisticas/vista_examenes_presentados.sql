CREATE OR REPLACE VIEW vista_examenes_presentados AS
SELECT 
  ee.evaluacion_id,
  ee.curso_id,
  e.nombre AS nombre_evaluacion,
  c.nombre AS nombre_curso,
  u.id AS estudiante_id,
  u.nombre || ' (' || u.correo || ')' AS nombre_estudiante,
  ee.fecha_inicio,
  ee.fecha_fin,
  NVL(ROUND(ee.calificacion, 2), 0) AS calificacion,
  ee.ip_origen,
  NVL(ROUND((CAST(ee.fecha_fin AS DATE) - CAST(ee.fecha_inicio AS DATE)) * 24 * 60, 2), 0) AS tiempo_minutos,
  d.id AS docente_id,
  d.nombre AS nombre_docente,
  est.nombre AS estado_evaluacion
FROM evaluacion_estudiante ee
JOIN usuario u ON ee.estudiante_id = u.id
JOIN curso c ON ee.curso_id = c.id
JOIN usuario d ON c.docente_id = d.id
JOIN evaluacion e ON ee.evaluacion_id = e.id
JOIN estado_evaluacion_estudiante est ON est.id = ee.estado_id;
