CREATE OR REPLACE PROCEDURE prc_agregar_par_emparejamiento (
  p_pregunta_id IN NUMBER,
  p_texto_izq IN CLOB,
  p_texto_der IN CLOB,
  p_codigo_par IN CHAR
)
AS
BEGIN
  -- Lado A
  INSERT INTO opcion_respuesta (pregunta_id, texto, es_correcta)
  VALUES (p_pregunta_id, p_texto_izq, p_codigo_par);

  -- Lado B
  INSERT INTO opcion_respuesta (pregunta_id, texto, es_correcta)
  VALUES (p_pregunta_id, p_texto_der, p_codigo_par);
END;
/
