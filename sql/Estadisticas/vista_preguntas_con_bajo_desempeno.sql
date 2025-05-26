CREATE OR REPLACE VIEW vista_preguntas_con_bajo_desempeno AS
SELECT 
  p.id AS pregunta_id,
  DBMS_LOB.SUBSTR(p.enunciado, 100) AS enunciado,
  u.id AS docente_id,
  u.nombre AS nombre_docente,
  COUNT(r.id) AS total_respuestas,
  SUM(CASE WHEN r.es_correcta = 'S' THEN 1 ELSE 0 END) AS correctas,
  SUM(CASE WHEN r.es_correcta = 'N' THEN 1 ELSE 0 END) AS incorrectas,
  ROUND(
    (SUM(CASE WHEN r.es_correcta = 'S' THEN 1 ELSE 0 END) * 100.0) / 
    NULLIF(COUNT(r.id), 0),
    2
  ) AS porcentaje_aciertos
FROM banco_preguntas p
JOIN usuario u ON p.usuario_id = u.id
LEFT JOIN respuesta_estudiante r ON r.pregunta_id = p.id
GROUP BY p.id, DBMS_LOB.SUBSTR(p.enunciado, 100), u.id, u.nombre
HAVING ROUND(
  (SUM(CASE WHEN r.es_correcta = 'S' THEN 1 ELSE 0 END) * 100.0) / 
  NULLIF(COUNT(r.id), 0), 2
) < 50;
