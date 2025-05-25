CREATE OR REPLACE FUNCTION fn_validar_seleccion_multiple(
  p_pregunta_id IN NUMBER,
  p_respuesta_usuario IN VARCHAR2  -- formato: '31,32,34'
) RETURN VARCHAR2
IS
  v_correctas VARCHAR2(1000);
BEGIN
  SELECT LISTAGG(id, ',') WITHIN GROUP (ORDER BY id)
  INTO v_correctas
  FROM opcion_respuesta
  WHERE pregunta_id = p_pregunta_id AND es_correcta = 'S';

  IF v_correctas = p_respuesta_usuario THEN
    RETURN 'OK';
  ELSE
    RETURN 'INCORRECTO';
  END IF;
END;
/
