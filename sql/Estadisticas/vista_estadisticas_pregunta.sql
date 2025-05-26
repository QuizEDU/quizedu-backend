CREATE OR REPLACE VIEW vista_estadisticas_pregunta AS
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
