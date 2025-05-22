CREATE OR REPLACE PROCEDURE PRC_REGISTRAR_Y_LOGUEAR_USUARIO (
    p_nombre     IN  VARCHAR2,
    p_correo     IN  VARCHAR2,
    p_contrasenia IN VARCHAR2,
    p_token      OUT VARCHAR2,
    p_rol        OUT VARCHAR2
) AS
  v_usuario_id NUMBER;
  v_existente  NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_existente FROM usuario WHERE correo = p_correo;

  IF v_existente > 0 THEN
    p_token := 'CORREO_EXISTENTE';
    p_rol := NULL;
  ELSE
    INSERT INTO usuario (nombre, correo, contrasenia, estado)
    VALUES (p_nombre, p_correo, p_contrasenia, 'ACTIVO');

    SELECT id INTO v_usuario_id FROM usuario WHERE correo = p_correo;

    p_token := 'TOKEN_' || v_usuario_id;

    INSERT INTO token (id_usuario, token, fecha_expiracion)
    VALUES (v_usuario_id, p_token, CURRENT_TIMESTAMP + 1);

    -- Obtener su rol si tiene uno
    BEGIN
      SELECT r.nombre INTO p_rol
      FROM usuario_rol ur
      JOIN rol r ON ur.id_rol = r.id
      WHERE ur.id_usuario = v_usuario_id
      AND ROWNUM = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_rol := 'ESTUDIANTE'; -- Por defecto
    END;
  END IF;
END;
/
