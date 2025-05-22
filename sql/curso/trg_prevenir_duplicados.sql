CREATE OR REPLACE TRIGGER trg_prevenir_duplicados
BEFORE INSERT ON curso_estudiante
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM curso_estudiante
  WHERE curso_id = :NEW.curso_id
    AND estudiante_id = :NEW.estudiante_id;

  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20005, 'El estudiante ya está inscrito en este curso.');
  END IF;
END;
/
