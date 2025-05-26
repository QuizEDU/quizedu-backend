CREATE OR REPLACE VIEW vista_estadistica_global_docente AS
SELECT 
  u.id AS docente_id,
  u.nombre AS nombre_docente,
  COUNT(DISTINCT c.id) AS cursos_asignados,
  COUNT(DISTINCT p.id) AS preguntas_creadas,
  ROUND(AVG(NVL(ee.calificacion, 0)), 2) AS promedio_general_docente
FROM usuario u
LEFT JOIN curso c ON c.docente_id = u.id
LEFT JOIN banco_preguntas p ON p.usuario_id = u.id
LEFT JOIN evaluacion_estudiante ee 
  ON ee.curso_id = c.id
GROUP BY u.id, u.nombre;
