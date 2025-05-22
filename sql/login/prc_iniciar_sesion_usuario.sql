CREATE OR REPLACE PROCEDURE prc_iniciar_sesion_usuario (
    p_correo        IN  VARCHAR2,
    p_contrasenia   IN  VARCHAR2,
    p_token         OUT VARCHAR2,
    p_rol           OUT VARCHAR2
) AS
    v_usuario_id NUMBER;
BEGIN
    -- Verificar credenciales y estado del usuario
    SELECT id INTO v_usuario_id
    FROM usuario
    WHERE correo = p_correo
      AND contrasenia = p_contrasenia
      AND estado = 'ACTIVO';

    -- Generar token
    p_token := 'TOKEN_' || v_usuario_id;

    -- Insertar token en la tabla correspondiente
    INSERT INTO token (id_usuario, token, fecha_expiracion)
    VALUES (v_usuario_id, p_token, CURRENT_TIMESTAMP + 1);

    -- Obtener el rol del usuario
    SELECT r.nombre INTO p_rol
    FROM usuario_rol ur
    JOIN rol r ON ur.id_rol = r.id
    WHERE ur.id_usuario = v_usuario_id
    AND ROWNUM = 1;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_token := 'LOGIN_INVALIDO';
        p_rol := NULL;
END;
/
