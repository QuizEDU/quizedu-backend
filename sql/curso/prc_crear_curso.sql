CREATE OR REPLACE PROCEDURE prc_crear_curso (
  p_nombre            IN VARCHAR2,
  p_descripcion       IN CLOB,
  p_docente_id        IN NUMBER,
  p_plan_estudio_id   IN NUMBER,
  p_fecha_inicio      IN DATE,
  p_fecha_fin         IN DATE,
  p_id_out            OUT NUMBER
) AS
  v_rol_nombre VARCHAR2(50);
  v_codigo VARCHAR2(10);
  v_count NUMBER;

  -- Función anidada para generar un código único
  FUNCTION generar_codigo_unico RETURN VARCHAR2 IS
    v_temp VARCHAR2(10);
  BEGIN
    LOOP
      v_temp := fnc_generar_codigo_acceso();
      SELECT COUNT(*) INTO v_count FROM curso WHERE codigo_acceso = v_temp;
      EXIT WHEN v_count = 0;
    END LOOP;
    RETURN v_temp;
  END;
BEGIN
  -- Validar rol docente
  SELECT r.nombre INTO v_rol_nombre
  FROM usuario_rol ur
  JOIN rol r ON ur.id_rol = r.id
  WHERE ur.id_usuario = p_docente_id
  AND ROWNUM = 1;

  IF v_rol_nombre != 'DOCENTE' THEN
    RAISE_APPLICATION_ERROR(-20010, 'El usuario no tiene rol DOCENTE.');
  END IF;

  -- Generar código único
  v_codigo := generar_codigo_unico();

  -- Insertar curso y obtener ID
  INSERT INTO curso (
    nombre, descripcion, docente_id, plan_estudio_id,
    fecha_inicio, fecha_fin, codigo_acceso
  ) VALUES (
    p_nombre, p_descripcion, p_docente_id, p_plan_estudio_id,
    p_fecha_inicio, p_fecha_fin, v_codigo
  )
  RETURNING id INTO p_id_out;
END;
/
