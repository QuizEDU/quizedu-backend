CREATE OR REPLACE TRIGGER trg_finalizar_evaluacion_estudiante
BEFORE UPDATE OF fecha_fin ON evaluacion_estudiante
FOR EACH ROW
DECLARE
  v_estado_id NUMBER;
BEGIN
  IF :NEW.fecha_fin IS NOT NULL THEN
    SELECT id INTO v_estado_id
    FROM estado_evaluacion_estudiante
    WHERE nombre = 'finalizado';

    :NEW.estado_id := v_estado_id;  -- ✅ sin UPDATE
  END IF;
END;
/
