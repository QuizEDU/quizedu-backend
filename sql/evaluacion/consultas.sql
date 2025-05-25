
SELECT e.id, e.nombre, e.descripcion, e.tiempo_maximo, 
       ts.nombre AS tipo_seleccion, ee.nombre AS estado, 
       u.nombre AS docente, e.fecha_creacion
FROM evaluacion e
JOIN tipo_seleccion ts ON e.tipo_seleccion_id = ts.id
JOIN estado_evaluacion ee ON e.estado_id = ee.id
JOIN usuario u ON e.docente_id = u.id
WHERE e.docente_id = 17
ORDER BY e.fecha_creacion DESC;


SELECT * FROM estado_evaluacion;
SELECT * FROM tipo_seleccion;
SELECT * FROM estado_evaluacion_estudiante;



SELECT 
  e.id AS evaluacion_id,
  e.nombre AS nombre_evaluacion,
  e.descripcion,
  e.tiempo_maximo,
  ep.orden,
  bp.id AS pregunta_id,
  bp.enunciado,
  tp.nombre AS tipo_pregunta,
  t.nombre AS tema,
  ep.porcentaje,
  orp.id AS opcion_id,
  orp.texto AS opcion_texto,
  CASE 
    WHEN orp.id = bp.respuesta_correcta_opcion_id THEN '✔️ Correcta'
    WHEN orp.es_correcta = 'S' THEN '✔️ Correcta'
    ELSE '—'
  END AS estado_opcion
FROM evaluacion e
JOIN evaluacion_pregunta ep ON ep.evaluacion_id = e.id
JOIN banco_preguntas bp ON bp.id = ep.pregunta_id
JOIN tipo_pregunta tp ON tp.id = bp.tipo_pregunta_id
JOIN tema t ON t.id = bp.tema_id
LEFT JOIN opcion_respuesta orp ON orp.pregunta_id = bp.id
WHERE e.docente_id = 17
ORDER BY e.id, ep.orden, orp.id;


SELECT
  ec.evaluacion_id,
  e.nombre AS nombre_evaluacion,
  e.descripcion,
  e.tiempo_maximo,
  ec.fecha_apertura,
  ec.fecha_cierre,
  ec.intentos_permitidos,
  ee.intentos_realizados,
  c.nombre AS nombre_curso,
  e.fecha_creacion
FROM curso_estudiante ce
JOIN evaluacion_curso ec ON ce.curso_id = ec.curso_id
JOIN evaluacion e ON ec.evaluacion_id = e.id
JOIN curso c ON c.id = ce.curso_id
LEFT JOIN (
  SELECT evaluacion_id, estudiante_id, COUNT(*) AS intentos_realizados
  FROM evaluacion_estudiante
  GROUP BY evaluacion_id, estudiante_id
) ee ON ee.evaluacion_id = e.id AND ee.estudiante_id = ce.estudiante_id
WHERE ce.estudiante_id = 1
  AND CURRENT_TIMESTAMP BETWEEN ec.fecha_apertura AND ec.fecha_cierre
  AND NVL(ee.intentos_realizados, 0) < ec.intentos_permitidos;


  CREATE OR REPLACE VIEW vista_evaluaciones_disponibles AS
SELECT
  ce.estudiante_id,
  ec.evaluacion_id,
  e.nombre AS nombre_evaluacion,
  e.descripcion,
  e.tiempo_maximo,
  ec.fecha_apertura,
  ec.fecha_cierre,
  ec.intentos_permitidos,
  NVL(ee.intentos_realizados, 0) AS intentos_realizados,
  c.nombre AS nombre_curso
FROM curso_estudiante ce
JOIN evaluacion_curso ec ON ce.curso_id = ec.curso_id
JOIN evaluacion e ON ec.evaluacion_id = e.id
JOIN curso c ON c.id = ce.curso_id
LEFT JOIN (
  SELECT evaluacion_id, estudiante_id, COUNT(*) AS intentos_realizados
  FROM evaluacion_estudiante
  GROUP BY evaluacion_id, estudiante_id
) ee ON ee.evaluacion_id = e.id AND ee.estudiante_id = ce.estudiante_id
WHERE CURRENT_TIMESTAMP BETWEEN ec.fecha_apertura AND ec.fecha_cierre;

        SELECT 
            evaluacion_id,
            nombre_evaluacion,
            descripcion,
            tiempo_maximo,
            fecha_apertura,
            fecha_cierre,
            intentos_permitidos,
            intentos_realizados,
            nombre_curso
        FROM vista_evaluaciones_disponibles
        WHERE estudiante_id = 1
        ORDER BY fecha_apertura DESC;

