CREATE OR REPLACE TRIGGER trg_validar_estudiante
BEFORE INSERT ON curso_estudiante
FOR EACH ROW
DECLARE
  v_rol_nombre VARCHAR2(50);
BEGIN
  SELECT r.nombre INTO v_rol_nombre
  FROM usuario_rol ur
  JOIN rol r ON ur.id_rol = r.id
  WHERE ur.id_usuario = :NEW.estudiante_id
  AND ROWNUM = 1;

  IF v_rol_nombre != 'ESTUDIANTE' THEN
    RAISE_APPLICATION_ERROR(-20003, 'Solo usuarios con rol ESTUDIANTE pueden inscribirse a cursos.');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20004, 'El usuario no existe o no tiene rol asignado.');
END;
/
