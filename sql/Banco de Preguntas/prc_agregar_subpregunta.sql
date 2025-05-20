CREATE OR REPLACE PROCEDURE prc_crear_subpregunta_pregunta (
    p_pregunta_padre_id IN NUMBER,
    p_enunciado IN CLOB,
    p_tipo_pregunta_id IN NUMBER,
    p_respuesta_correcta IN CLOB,
    p_respuesta_correcta_opcion_id IN NUMBER,
    p_dificultad IN VARCHAR2,
    p_usuario_id IN NUMBER,
    p_tema_id IN NUMBER,
    p_porcentaje IN NUMBER,
    p_tiempo_maximo IN NUMBER,
    p_id_out OUT NUMBER
)
AS
  v_total_porcentaje NUMBER;
BEGIN
  -- Validar porcentaje acumulado
  SELECT NVL(SUM(porcentaje), 0)
  INTO v_total_porcentaje
  FROM banco_preguntas
  WHERE pregunta_padre_id = p_pregunta_padre_id;

  IF v_total_porcentaje + p_porcentaje > 100 THEN
    RAISE_APPLICATION_ERROR(-20012, 'El porcentaje total de subpreguntas excede 100%');
  END IF;

  -- Insertar como subpregunta (pregunta hija)
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
    tema_id,
    pregunta_padre_id,
    porcentaje,
    tiempo_maximo
  )
  VALUES (
    p_enunciado,
    p_tipo_pregunta_id,
    p_respuesta_correcta,
    p_respuesta_correcta_opcion_id,
    'N',
    p_dificultad,
    100,
    'N',
    p_usuario_id,
    p_tema_id,
    p_pregunta_padre_id,
    p_porcentaje,
    p_tiempo_maximo
  )
  RETURNING id INTO p_id_out;
END;
/
