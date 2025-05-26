CREATE OR REPLACE VIEW vista_estadisticas_pregunta_por_curso AS
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
  ), 0) AS porcentaje_correctas,
  c.id AS curso_id,
  c.nombre AS nombre_curso
FROM banco_preguntas p
JOIN usuario u ON p.usuario_id = u.id
LEFT JOIN respuesta_estudiante r ON p.id = r.pregunta_id
JOIN evaluacion_pregunta ep ON ep.pregunta_id = p.id
JOIN evaluacion_curso ec ON ec.evaluacion_id = ep.evaluacion_id
JOIN curso c ON c.id = ec.curso_id
GROUP BY 
  p.id, 
  DBMS_LOB.SUBSTR(p.enunciado, 100),
  p.usuario_id,
  u.nombre,
  p.requiere_revision,
  c.id,
  c.nombre;
