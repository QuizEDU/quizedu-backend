CREATE OR REPLACE FUNCTION fn_vf_correcta (
  p_pregunta_id IN NUMBER
) RETURN NUMBER
IS
  v_respuesta_correcta VARCHAR2(50);
BEGIN
  SELECT respuesta_correcta
  INTO v_respuesta_correcta
  FROM banco_preguntas
  WHERE id = p_pregunta_id;

  IF UPPER(TRIM(v_respuesta_correcta)) = 'FALSO' THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
  WHEN OTHERS THEN
    RETURN 0;
END;
/
