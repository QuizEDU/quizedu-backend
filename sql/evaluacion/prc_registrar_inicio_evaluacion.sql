CREATE OR REPLACE PROCEDURE prc_registrar_inicio_evaluacion(
  p_evaluacion_id IN NUMBER,
  p_estudiante_id IN NUMBER,
  p_curso_id IN NUMBER,
  p_ip_origen IN VARCHAR2
) IS
  v_estado_id NUMBER;
BEGIN
  SELECT id INTO v_estado_id FROM estado_evaluacion_estudiante WHERE nombre = 'en_progreso';

  UPDATE evaluacion_estudiante
  SET fecha_inicio = CURRENT_TIMESTAMP,
      estado_id = v_estado_id,
      ip_origen = p_ip_origen
  WHERE evaluacion_id = p_evaluacion_id AND estudiante_id = p_estudiante_id;
END;
/