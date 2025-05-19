CREATE OR REPLACE PROCEDURE prc_agregar_subpregunta (
    p_pregunta_padre_id IN NUMBER,
    p_enunciado IN CLOB,
    p_porcentaje IN NUMBER,
    p_tipo_subpregunta IN VARCHAR2,
    p_respuesta_correcta IN CLOB,
    p_tiempo_maximo IN NUMBER
)
AS
  v_total_porcentaje NUMBER;
BEGIN
  SELECT NVL(SUM(porcentaje), 0)
  INTO v_total_porcentaje
  FROM sub_pregunta
  WHERE pregunta_padre_id = p_pregunta_padre_id;

  IF v_total_porcentaje + p_porcentaje > 100 THEN
    RAISE_APPLICATION_ERROR(-20012, 'El porcentaje total excede 100%');
  END IF;

  INSERT INTO sub_pregunta (
    pregunta_padre_id, enunciado, porcentaje,
    tipo_subpregunta, respuesta_correcta, tiempo_maximo
  )
  VALUES (
    p_pregunta_padre_id, p_enunciado, p_porcentaje,
    p_tipo_subpregunta, p_respuesta_correcta, p_tiempo_maximo
  );
END;
/
