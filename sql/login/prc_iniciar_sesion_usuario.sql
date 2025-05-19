CREATE OR REPLACE PROCEDURE prc_iniciar_sesion_usuario (
    p_correo IN VARCHAR2,
    p_contrasenia IN VARCHAR2,
    p_token OUT VARCHAR2
) AS
  v_usuario_id NUMBER;
BEGIN
  SELECT id INTO v_usuario_id
  FROM usuario
  WHERE correo = p_correo
    AND contrasenia = p_contrasenia
    AND estado = 'ACTIVO';

  p_token := 'TOKEN_' || DBMS_RANDOM.STRING('U', 20);

  INSERT INTO token (id_usuario, token, fecha_expiracion)
  VALUES (v_usuario_id, p_token, CURRENT_TIMESTAMP + 1);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    p_token := 'LOGIN_INVALIDO';
END;
/