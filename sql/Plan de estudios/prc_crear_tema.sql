CREATE OR REPLACE PROCEDURE prc_crear_tema (
    p_nombre IN VARCHAR2,
    p_contenido_id IN NUMBER
)
AS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM tema
  WHERE UPPER(nombre) = UPPER(p_nombre)
    AND contenido_id = p_contenido_id;

  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20004, 'Ya existe un tema con ese nombre en este contenido.');
  END IF;

  INSERT INTO tema (nombre, contenido_id)
  VALUES (p_nombre, p_contenido_id);
END;
/
