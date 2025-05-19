CREATE OR REPLACE PROCEDURE prc_crear_plan_estudio (
    p_nombre IN VARCHAR2
)
AS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM plan_estudio
  WHERE UPPER(nombre) = UPPER(p_nombre);

  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Ya existe un plan de estudio con ese nombre.');
  END IF;

  INSERT INTO plan_estudio (nombre)
  VALUES (p_nombre);
END;
/
