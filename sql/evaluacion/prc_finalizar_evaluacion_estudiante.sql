CREATE OR REPLACE PROCEDURE prc_finalizar_evaluacion_estudiante(
  p_evaluacion_id IN NUMBER,
  p_estudiante_id IN NUMBER
) IS
  v_estado_id NUMBER;
BEGIN
  SELECT id INTO v_estado_id FROM estado_evaluacion_estudiante WHERE nombre = 'finalizado';

  UPDATE evaluacion_estudiante
  SET fecha_fin = CURRENT_TIMESTAMP,
      estado_id = v_estado_id
  WHERE evaluacion_id = p_evaluacion_id AND estudiante_id = p_estudiante_id;
END;
/
