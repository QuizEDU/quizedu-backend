CREATE OR REPLACE PROCEDURE prc_asignar_evaluacion_a_curso(
  p_evaluacion_id IN NUMBER,
  p_curso_id IN NUMBER,
  p_fecha_apertura IN TIMESTAMP,
  p_fecha_cierre IN TIMESTAMP,
  p_intentos IN NUMBER,
  p_umbral_aprobacion IN NUMBER
) IS
BEGIN
  INSERT INTO evaluacion_curso (
    evaluacion_id, curso_id, fecha_apertura, fecha_cierre,
    intentos_permitidos, umbral_aprobacion
  ) VALUES (
    p_evaluacion_id, p_curso_id, p_fecha_apertura, p_fecha_cierre,
    p_intentos, p_umbral_aprobacion
  );
END;
/
