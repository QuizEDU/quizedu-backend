CREATE OR REPLACE FUNCTION fn_opcion_correcta_id (
  p_pregunta_id IN NUMBER
) RETURN NUMBER
IS
  v_opcion_id NUMBER;
BEGIN
  SELECT id INTO v_opcion_id
  FROM opcion_respuesta
  WHERE pregunta_id = p_pregunta_id AND es_correcta = 'S'
  FETCH FIRST 1 ROWS ONLY;

  RETURN v_opcion_id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;
/
