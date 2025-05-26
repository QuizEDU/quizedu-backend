CREATE OR REPLACE VIEW vista_rendimiento_tema_estudiante AS
SELECT 
  r.estudiante_id,
  t.id AS tema_id,
  t.nombre AS nombre_tema,
  ROUND(AVG(NVL(ee.calificacion, 0)), 2) AS promedio_tema,
  COUNT(DISTINCT r.evaluacion_id) AS evaluaciones_con_este_tema
FROM respuesta_estudiante r
JOIN banco_preguntas p ON p.id = r.pregunta_id
JOIN tema t ON t.id = p.tema_id
JOIN evaluacion_estudiante ee ON ee.evaluacion_id = r.evaluacion_id AND ee.estudiante_id = r.estudiante_id
GROUP BY r.estudiante_id, t.id, t.nombre;
