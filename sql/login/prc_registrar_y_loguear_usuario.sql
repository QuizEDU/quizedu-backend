CREATE OR REPLACE PROCEDURE PRC_REGISTRAR_Y_LOGUEAR_USUARIO (
    p_nombre IN VARCHAR2,
    p_correo IN VARCHAR2,
    p_contrasenia IN VARCHAR2,
    p_token OUT VARCHAR2
) AS
  v_usuario_id NUMBER;
  v_existente NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_existente FROM usuario WHERE correo = p_correo;

  IF v_existente > 0 THEN
    p_token := 'CORREO_EXISTENTE';
  ELSE
    INSERT INTO usuario (nombre, correo, contrasenia, estado)
    VALUES (p_nombre, p_correo, p_contrasenia, 'ACTIVO');

    SELECT id INTO v_usuario_id FROM usuario WHERE correo = p_correo;

    p_token := 'TOKEN_' || DBMS_RANDOM.STRING('U', 20);

    INSERT INTO token (id_usuario, token, fecha_expiracion)
    VALUES (v_usuario_id, p_token, CURRENT_TIMESTAMP + 1);
  END IF;
END;
/
