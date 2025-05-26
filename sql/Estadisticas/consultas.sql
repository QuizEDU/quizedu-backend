
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
  d.nombre AS nombre_docente
FROM evaluacion_estudiante ee
JOIN usuario u ON ee.estudiante_id = u.id
JOIN curso c ON ee.curso_id = c.id
JOIN usuario d ON c.docente_id = d.id
JOIN evaluacion e ON ee.evaluacion_id = e.id
ORDER BY ee.fecha_inicio DESC;


SELECT 
  p.id AS pregunta_id,
  DBMS_LOB.SUBSTR(p.enunciado, 100) AS enunciado,
  p.usuario_id AS docente_id,
  u.nombre AS nombre_docente,
  p.requiere_revision,
  COUNT(r.id) AS total_respuestas,
  SUM(CASE WHEN r.es_correcta = 'S' THEN 1 ELSE 0 END) AS correctas,
  SUM(CASE WHEN r.es_correcta = 'N' THEN 1 ELSE 0 END) AS incorrectas,
  NVL(ROUND(
    (SUM(CASE WHEN r.es_correcta = 'S' THEN 1 ELSE 0 END) * 100.0) / NULLIF(COUNT(r.id), 0),
    2
  ), 0) AS porcentaje_correctas
FROM banco_preguntas p
JOIN usuario u ON p.usuario_id = u.id
LEFT JOIN respuesta_estudiante r ON p.id = r.pregunta_id
GROUP BY 
  p.id, 
  DBMS_LOB.SUBSTR(p.enunciado, 100),
  p.usuario_id,
  u.nombre,
  p.requiere_revision;



SELECT 
  c.id AS curso_id,
  c.nombre AS nombre_curso,
  d.id AS docente_id,
  d.nombre AS nombre_docente,
  COUNT(DISTINCT ce.estudiante_id) AS cantidad_estudiantes,
  COUNT(DISTINCT ee.evaluacion_id) AS cantidad_evaluaciones,
  ROUND(AVG(NVL(ee.calificacion, 0)), 2) AS promedio_calificacion
FROM curso c
JOIN usuario d ON c.docente_id = d.id
LEFT JOIN curso_estudiante ce ON ce.curso_id = c.id
LEFT JOIN evaluacion_estudiante ee ON ee.curso_id = c.id
GROUP BY c.id, c.nombre, d.id, d.nombre;


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


SELECT 
  c.id AS curso_id,
  c.nombre AS nombre_curso,
  u.id AS estudiante_id,
  u.nombre || ' (' || u.correo || ')' AS nombre_estudiante,
  COUNT(DISTINCT ee.evaluacion_id) AS evaluaciones_presentadas,
  ROUND(AVG(NVL(ee.calificacion, 0)), 2) AS promedio_calificacion
FROM curso c
JOIN curso_estudiante ce ON ce.curso_id = c.id
JOIN usuario u ON ce.estudiante_id = u.id
LEFT JOIN evaluacion_estudiante ee 
  ON ee.estudiante_id = u.id AND ee.curso_id = c.id
GROUP BY 
  c.id, c.nombre,
  u.id, u.nombre, u.correo;

  SELECT 
  c.id AS curso_id,
  c.nombre AS nombre_curso,
  u.id AS estudiante_id,
  u.nombre || ' (' || u.correo || ')' AS nombre_estudiante,
  e.id AS evaluacion_id,
  e.nombre AS nombre_evaluacion,
  ee.fecha_fin AS fecha_presentacion,
  ROUND(NVL(ee.calificacion, 0), 2) AS nota_obtenida,
  COUNT(r.id) AS total_respuestas,
  SUM(CASE WHEN r.es_correcta = 'S' THEN 1 ELSE 0 END) AS correctas,
  SUM(CASE WHEN r.es_correcta = 'N' THEN 1 ELSE 0 END) AS incorrectas
FROM evaluacion_estudiante ee
JOIN curso c ON ee.curso_id = c.id
JOIN usuario u ON ee.estudiante_id = u.id
JOIN evaluacion e ON ee.evaluacion_id = e.id
LEFT JOIN respuesta_estudiante r 
  ON r.evaluacion_id = ee.evaluacion_id 
  AND r.estudiante_id = ee.estudiante_id 
  AND r.curso_id = ee.curso_id
GROUP BY 
  c.id, c.nombre,
  u.id, u.nombre, u.correo,
  e.id, e.nombre,
  ee.fecha_fin,
  ee.calificacion;

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

SELECT 
  p.id AS pregunta_id,
  DBMS_LOB.SUBSTR(p.enunciado, 100) AS enunciado,
  u.id AS docente_id,
  u.nombre AS nombre_docente,
  COUNT(r.id) AS total_respuestas,
  SUM(CASE WHEN r.es_correcta = 'S' THEN 1 ELSE 0 END) AS correctas,
  ROUND(
    (SUM(CASE WHEN r.es_correcta = 'S' THEN 1 ELSE 0 END) * 100.0) / 
    NULLIF(COUNT(r.id), 0), 2
  ) AS porcentaje_aciertos
FROM banco_preguntas p
JOIN usuario u ON p.usuario_id = u.id
LEFT JOIN respuesta_estudiante r ON r.pregunta_id = p.id
GROUP BY p.id, DBMS_LOB.SUBSTR(p.enunciado, 100), u.id, u.nombre
HAVING ROUND(
    (SUM(CASE WHEN r.es_correcta = 'S' THEN 1 ELSE 0 END) * 100.0) / 
    NULLIF(COUNT(r.id), 0), 2
  ) < 50;


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


 SELECT * FROM vista_preguntas_con_bajo_desempeno WHERE docente_id = 41;
 SELECT * FROM vista_examenes_presentados WHERE docente_id = 41 ORDER BY fecha_inicio DESC;








 SELECT * FROM vista_desempeno_estudiante;

 SELECT * FROM vista_estadistica_global_docente;

 SELECT * FROM vista_estadisticas_pregunta;

 SELECT * FROM vista_examenes_presentados;

 SELECT * FROM vista_mis_examenes;

 SELECT * FROM vista_rendimiento_tema_estudiante;





