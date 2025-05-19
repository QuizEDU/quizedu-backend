SELECT * FROM tipo_pregunta;
SELECT * FROM tema where id = 8;


SELECT * FROM USUARIO WHERE id = 17;

SELECT * FROM banco_preguntas;
SELECT * FROM opcion_respuesta;
SELECT * FROM sub_pregunta;
SELECT * FROM respuesta_correcta;


SELECT 
  bp.id AS pregunta_id,
  bp.enunciado,
  tr.nombre AS tipo_pregunta,
  t.nombre AS tema,
  orp.id AS opcion_id,
  orp.texto AS opcion_texto,
  CASE 
    WHEN orp.id = bp.respuesta_correcta_opcion_id THEN '✔️ Correcta'
    ELSE '—'
  END AS estado
FROM banco_preguntas bp
JOIN tipo_pregunta tr ON bp.tipo_pregunta_id = tr.id
JOIN tema t ON bp.tema_id = t.id
LEFT JOIN opcion_respuesta orp ON orp.pregunta_id = bp.id
WHERE bp.id = 3  -- ← Cambia este ID por la pregunta que desees ver
ORDER BY bp.id, orp.id;
