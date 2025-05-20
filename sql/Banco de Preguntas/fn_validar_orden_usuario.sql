CREATE OR REPLACE FUNCTION fn_validar_orden_usuario (
  p_pregunta_id IN NUMBER,
  p_respuesta_usuario IN VARCHAR2  -- Ejemplo: '28,27,29,30'
) RETURN VARCHAR2
IS
  v_respuesta_correcta VARCHAR2(1000);
BEGIN
  -- Obtener el orden correcto de los IDs según orden_correcto
  SELECT LISTAGG(id, ',') WITHIN GROUP (ORDER BY es_correcta)
  INTO v_respuesta_correcta
  FROM opcion_respuesta
  WHERE pregunta_id = p_pregunta_id;

  -- Comparar con lo enviado por el usuario
  IF v_respuesta_correcta = p_respuesta_usuario THEN
    RETURN 'OK';
  ELSE
    RETURN 'INCORRECTO';
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'ERROR: PREGUNTA NO EXISTE';
END;
/

