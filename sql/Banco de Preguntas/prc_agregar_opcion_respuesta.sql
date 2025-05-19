CREATE OR REPLACE PROCEDURE prc_agregar_opcion_respuesta (
    p_pregunta_id IN NUMBER,
    p_texto IN CLOB,
    p_es_correcta IN CHAR
)
AS
  v_exist NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_exist
  FROM banco_preguntas
  WHERE id = p_pregunta_id;

  IF v_exist = 0 THEN
    RAISE_APPLICATION_ERROR(-20011, 'La pregunta no existe');
  END IF;

  INSERT INTO opcion_respuesta (pregunta_id, texto, es_correcta)
  VALUES (p_pregunta_id, p_texto, p_es_correcta);
END;
/
