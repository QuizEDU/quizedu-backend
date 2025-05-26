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
ORDER BY bp.id, orp.id;


SELECT 
  bp.id AS pregunta_id,
  bp.enunciado,
  tp.nombre AS tipo_pregunta,
  orp.texto AS opcion,
  orp.es_correcta,
  t.nombre AS tema
FROM banco_preguntas bp
JOIN tipo_pregunta tp ON bp.tipo_pregunta_id = tp.id
JOIN tema t ON bp.tema_id = t.id
LEFT JOIN opcion_respuesta orp ON orp.pregunta_id = bp.id
WHERE tp.nombre = 'seleccion_multiple'
ORDER BY bp.id DESC, orp.id;

SELECT 
  bp.id AS pregunta_id,
  bp.enunciado,
  tp.nombre AS tipo_pregunta,
  bp.respuesta_correcta,
  bp.dificultad,
  bp.es_publica,
  t.nombre AS tema,
  u.nombre AS docente
FROM banco_preguntas bp
JOIN tipo_pregunta tp ON bp.tipo_pregunta_id = tp.id
JOIN tema t ON bp.tema_id = t.id
JOIN usuario u ON bp.usuario_id = u.id
WHERE tp.nombre = 'falso_verdadero'
ORDER BY bp.id DESC;

SELECT 
  bp.id,
  bp.enunciado,
  bp.respuesta_correcta,
  tp.nombre AS tipo,
  u.nombre AS docente,
  t.nombre AS tema
FROM banco_preguntas bp
JOIN tipo_pregunta tp ON bp.tipo_pregunta_id = tp.id
JOIN usuario u ON bp.usuario_id = u.id
JOIN tema t ON bp.tema_id = t.id
WHERE tp.nombre = 'completar'
ORDER BY bp.id DESC;


SELECT 
  bp.id AS pregunta_id,
  bp.enunciado,
  orp.id AS opcion_id,
  orp.texto AS texto_opcion,
  orp.es_correcta AS orden_correcto
FROM banco_preguntas bp
JOIN opcion_respuesta orp ON orp.pregunta_id = bp.id
WHERE bp.tipo_pregunta_id = 6  -- solo tipo ORDENAR
  AND bp.usuario_id = 17
ORDER BY bp.id DESC, TO_NUMBER(orp.es_correcta);


SELECT fn_validar_orden_usuario(26, '27,28,29,30') FROM dual;
-- Resultado: 'OK'

SELECT fn_validar_orden_usuario(26, '28,27,29,30') FROM dual;
-- Resultado: 'INCORRECTO'


SELECT 
  bp.id AS pregunta_id,
  bp.enunciado,
  orp.id AS opcion_id,
  orp.texto AS texto_opcion,
  orp.es_correcta AS codigo_par
FROM banco_preguntas bp
JOIN opcion_respuesta orp ON bp.id = orp.pregunta_id
WHERE bp.tipo_pregunta_id = 5  -- solo preguntas de tipo EMPAREJAR
  AND bp.usuario_id = 17
ORDER BY bp.id DESC, orp.es_correcta, orp.id;

SELECT fn_validar_emparejamiento_usuario(27, '31-32;33-34;35-36;37-38;39-40;41-42') AS resultado
FROM dual;

SELECT fn_validar_emparejamiento_usuario(63, '51-52;49-50;47-48') AS resultado
FROM dual;



SELECT fn_validar_emparejamiento_usuario(27, '31-32;33-34;35-36;37-38;39-42;41-40') AS resultado
FROM dual;




SELECT bp.id, bp.enunciado, tp.nombre AS tipo, bp.dificultad, bp.tasa_respuesta_correcta,
       t.nombre AS tema, c.nombre AS contenido, u.nombre AS unidad, pe.nombre AS plan_estudio
FROM banco_preguntas bp
LEFT JOIN tipo_pregunta tp ON bp.tipo_pregunta_id = tp.id
LEFT JOIN tema t ON bp.tema_id = t.id
LEFT JOIN contenido c ON t.contenido_id = c.id
LEFT JOIN unidad u ON c.unidad_id = u.id
LEFT JOIN plan_estudio pe ON u.plan_estudio_id = pe.id
WHERE bp.es_publica = 'N';

SELECT * FROM usuario;


SELECT * FROM banco_preguntas;

SELECT * FROM EVALUACION;

