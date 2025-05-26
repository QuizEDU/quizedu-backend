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

    ce.estudiante_id,

    CASE
        WHEN CURRENT_TIMESTAMP BETWEEN ec.fecha_apertura AND ec.fecha_cierre
             AND COALESCE(ee.intentos_realizados, 0) < ec.intentos_permitidos
             AND NOT EXISTS (
                 SELECT 1 
                 FROM evaluacion_estudiante ee2 
                 WHERE ee2.evaluacion_id = e.id 
                   AND ee2.curso_id = c.id 
                   AND ee2.estudiante_id = ce.estudiante_id
                   AND ee2.estado_id = (
                        SELECT id FROM estado_evaluacion_estudiante 
                        WHERE LOWER(nombre) = 'finalizado'
                   )
             )
        THEN 'SI'
        ELSE 'NO'
    END AS puede_presentar

FROM evaluacion e
JOIN evaluacion_curso ec ON ec.evaluacion_id = e.id
JOIN curso c ON c.id = ec.curso_id
JOIN curso_estudiante ce ON ce.curso_id = c.id
LEFT JOIN (
    SELECT evaluacion_id, curso_id, estudiante_id, 
           MAX(fecha_inicio) AS fecha_inicio, 
           COUNT(*) AS intentos_realizados
    FROM evaluacion_estudiante
    GROUP BY evaluacion_id, curso_id, estudiante_id
) ee ON ee.evaluacion_id = e.id 
     AND ee.curso_id = c.id 
     AND ee.estudiante_id = ce.estudiante_id
WHERE CURRENT_TIMESTAMP BETWEEN ec.fecha_apertura AND ec.fecha_cierre;
