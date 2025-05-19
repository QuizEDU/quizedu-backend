CREATE OR REPLACE PROCEDURE prc_crear_unidad (
    p_nombre IN VARCHAR2,
    p_plan_estudio_id IN NUMBER
)
AS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM unidad
  WHERE UPPER(nombre) = UPPER(p_nombre)
    AND plan_estudio_id = p_plan_estudio_id;

  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Ya existe una unidad con ese nombre en este plan de estudio.');
  END IF;

  INSERT INTO unidad (nombre, plan_estudio_id)
  VALUES (p_nombre, p_plan_estudio_id);
END;
/
