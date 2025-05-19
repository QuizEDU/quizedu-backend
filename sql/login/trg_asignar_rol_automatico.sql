CREATE OR REPLACE TRIGGER trg_asignar_rol_automatico
AFTER INSERT ON usuario
FOR EACH ROW
DECLARE
  v_rol_id NUMBER;
  v_rol_nombre VARCHAR2(20);
BEGIN
  -- Determinar rol según el dominio del correo
  IF LOWER(:NEW.correo) LIKE '%@estudiante.com' THEN
    v_rol_nombre := 'ESTUDIANTE';
  ELSIF LOWER(:NEW.correo) LIKE '%@docente.com' THEN
    v_rol_nombre := 'DOCENTE';
  ELSIF LOWER(:NEW.correo) LIKE '%@admin.com' THEN
    v_rol_nombre := 'ADMIN';
  ELSE
    -- Valor por defecto en caso de no coincidir
    v_rol_nombre := 'ESTUDIANTE';
  END IF;

  -- Buscar el ID del rol correspondiente
  SELECT id INTO v_rol_id
  FROM rol
  WHERE nombre = v_rol_nombre;

  -- Insertar en usuario_rol
  INSERT INTO usuario_rol (id_usuario, id_rol)
  VALUES (:NEW.id, v_rol_id);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Si no se encuentra el rol, no hace nada (puedes lanzar error si prefieres)
    NULL;
END;
