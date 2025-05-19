CREATE OR REPLACE PROCEDURE prc_crear_contenido (
    p_nombre IN VARCHAR2,
    p_unidad_id IN NUMBER
)
AS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM contenido
  WHERE UPPER(nombre) = UPPER(p_nombre)
    AND unidad_id = p_unidad_id;

  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Ya existe un contenido con ese nombre en esta unidad.');
  END IF;

  INSERT INTO contenido (nombre, unidad_id)
  VALUES (p_nombre, p_unidad_id);
END;
/
