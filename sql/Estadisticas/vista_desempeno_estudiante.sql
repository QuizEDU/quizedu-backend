CREATE OR REPLACE VIEW vista_desempeno_estudiante AS
SELECT 
  u.id AS estudiante_id,
  u.nombre || ' (' || u.correo || ')' AS nombre_estudiante,
  COUNT(DISTINCT ee.evaluacion_id) AS evaluaciones_realizadas,
  ROUND(AVG(NVL(ee.calificacion, 0)), 2) AS promedio_general,
  SUM(CASE WHEN ee.calificacion >= ec.umbral_aprobacion THEN 1 ELSE 0 END) AS aprobadas,
  SUM(CASE WHEN ee.calificacion < ec.umbral_aprobacion THEN 1 ELSE 0 END) AS reprobadas
FROM usuario u
JOIN evaluacion_estudiante ee ON ee.estudiante_id = u.id
JOIN evaluacion_curso ec ON ec.evaluacion_id = ee.evaluacion_id AND ec.curso_id = ee.curso_id
WHERE EXISTS (
    SELECT 1 FROM usuario_rol ur JOIN rol r ON ur.id_rol = r.id WHERE r.nombre = 'ESTUDIANTE' AND ur.id_usuario = u.id
)
GROUP BY u.id, u.nombre, u.correo;