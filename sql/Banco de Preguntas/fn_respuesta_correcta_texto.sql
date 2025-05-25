CREATE OR REPLACE FUNCTION fn_respuesta_correcta_texto(
  p_pregunta_id IN NUMBER
) RETURN VARCHAR2
IS
  v_texto VARCHAR2(4000);
BEGIN
  SELECT respuesta_correcta
  INTO v_texto
  FROM banco_preguntas
  WHERE id = p_pregunta_id;

  RETURN v_texto;
END;
/
