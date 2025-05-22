CREATE OR REPLACE PROCEDURE prc_calificar_evaluacion_estudiante(
  p_evaluacion_id   IN  NUMBER,
  p_estudiante_id   IN  NUMBER,
  p_calificacion    OUT NUMBER
) IS
  v_estado_id NUMBER;
BEGIN
  -- Calcular la calificación
  SELECT COALESCE(SUM(p.porcentaje), 0)
  INTO p_calificacion
  FROM respuesta_estudiante r
  JOIN evaluacion_pregunta p
    ON r.evaluacion_id = p.evaluacion_id
   AND r.pregunta_id = p.pregunta_id
  WHERE r.evaluacion_id = p_evaluacion_id
    AND r.estudiante_id = p_estudiante_id
    AND r.es_correcta = 'S';

  -- Obtener el ID del estado 'finalizado'
  SELECT id INTO v_estado_id FROM estado_evaluacion_estudiante
  WHERE nombre = 'finalizado';

  -- Actualizar la tabla evaluacion_estudiante
  UPDATE evaluacion_estudiante
  SET calificacion = p_calificacion,
      estado_id = v_estado_id,
      fecha_fin = CURRENT_TIMESTAMP
  WHERE evaluacion_id = p_evaluacion_id
    AND estudiante_id = p_estudiante_id;
END;
/
