CREATE OR REPLACE TRIGGER trg_validar_docente
BEFORE INSERT OR UPDATE ON curso
FOR EACH ROW
DECLARE
  v_rol_nombre VARCHAR2(50);
BEGIN
  SELECT r.nombre INTO v_rol_nombre
  FROM usuario_rol ur
  JOIN rol r ON ur.id_rol = r.id
  WHERE ur.id_usuario = :NEW.docente_id
  AND ROWNUM = 1;

  IF v_rol_nombre != 'DOCENTE' THEN
    RAISE_APPLICATION_ERROR(-20001, 'El usuario asignado como docente no tiene el rol DOCENTE.');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20002, 'El usuario asignado como docente no existe o no tiene rol asignado.');
END;
/
