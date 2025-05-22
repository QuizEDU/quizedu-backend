CREATE OR REPLACE TRIGGER trg_validar_periodo_evaluacion
BEFORE INSERT ON respuesta_estudiante
FOR EACH ROW
DECLARE
  v_apertura TIMESTAMP;
  v_cierre TIMESTAMP;
BEGIN
  SELECT fecha_apertura, fecha_cierre INTO v_apertura, v_cierre
  FROM evaluacion_curso
  WHERE evaluacion_id = :NEW.evaluacion_id AND curso_id = :NEW.curso_id;

  IF SYSDATE < v_apertura OR SYSDATE > v_cierre THEN
    RAISE_APPLICATION_ERROR(-20001, 'La evaluación no está disponible en este momento.');
  END IF;
END;
/
