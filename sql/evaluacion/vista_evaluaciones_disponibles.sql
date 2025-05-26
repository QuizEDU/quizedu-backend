CREATE OR REPLACE VIEW vista_evaluaciones_disponibles AS
SELECT 
    e.id AS evaluacion_id,
    e.nombre AS nombre_evaluacion,
    e.descripcion,
    e.tiempo_maximo,
    ec.fecha_apertura,
    ec.fecha_cierre,
    ec.intentos_permitidos,
    COALESCE(ee.intentos_realizados, 0) AS intentos_realizados,
    c.id AS curso_id,
    c.nombre AS nombre_curso,

    CASE 
        WHEN ee.fecha_inicio IS NOT NULL THEN 1
        ELSE 0
    END AS inicio_registrado,
    ee.estudiante_id

FROM evaluacion e
JOIN evaluacion_curso ec ON ec.evaluacion_id = e.id
JOIN curso c ON c.id = ec.curso_id
LEFT JOIN (
    SELECT evaluacion_id, curso_id, estudiante_id, MAX(fecha_inicio) AS fecha_inicio, COUNT(*) AS intentos_realizados
    FROM evaluacion_estudiante
    GROUP BY evaluacion_id, curso_id, estudiante_id
) ee ON ee.evaluacion_id = e.id AND ee.curso_id = c.id AND ee.estudiante_id = 42
WHERE CURRENT_TIMESTAMP BETWEEN ec.fecha_apertura AND ec.fecha_cierre;