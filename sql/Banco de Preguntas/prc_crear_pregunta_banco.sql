CREATE OR REPLACE PROCEDURE prc_crear_pregunta_banco (
    p_enunciado IN CLOB,
    p_tipo_pregunta_id IN NUMBER,
    p_respuesta_correcta IN CLOB,
    p_respuesta_correcta_opcion_id IN NUMBER,
    p_es_publica IN CHAR,
    p_dificultad IN VARCHAR2,
    p_usuario_id IN NUMBER,
    p_tema_id IN NUMBER,
    p_id_out OUT NUMBER  -- ✅ Nuevo parámetro de salida
)
AS
BEGIN
  IF p_enunciado IS NULL OR p_tipo_pregunta_id IS NULL OR p_usuario_id IS NULL OR p_tema_id IS NULL THEN
    RAISE_APPLICATION_ERROR(-20010, 'Campos obligatorios incompletos');
  END IF;

  INSERT INTO banco_preguntas (
    enunciado,
    tipo_pregunta_id,
    respuesta_correcta,
    respuesta_correcta_opcion_id,
    es_publica,
    dificultad,
    tasa_respuesta_correcta,
    requiere_revision,
    usuario_id,
    tema_id
  )
  VALUES (
    p_enunciado,
    p_tipo_pregunta_id,
    p_respuesta_correcta,
    p_respuesta_correcta_opcion_id,
    p_es_publica,
    p_dificultad,
    100,
    'N',
    p_usuario_id,
    p_tema_id
  )
  RETURNING id INTO p_id_out;  -- ✅ Aquí devolvemos el ID
END;
/
