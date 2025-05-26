CREATE OR REPLACE PROCEDURE prc_registrar_respuesta_estudiante(
  p_evaluacion_id IN NUMBER,
  p_estudiante_id IN NUMBER,
  p_pregunta_id IN NUMBER,
  p_curso_id IN NUMBER,
  p_respuesta_texto IN CLOB,
  p_respuesta_opcion_id IN NUMBER,
  p_respuesta_compuesta IN CLOB,
  p_es_correcta IN CHAR
) IS
BEGIN
  INSERT INTO respuesta_estudiante (
    evaluacion_id, estudiante_id, pregunta_id, curso_id,
    respuesta_texto, respuesta_opcion_id, respuesta_compuesta,
    es_correcta, fecha_respuesta
  ) VALUES (
    p_evaluacion_id,
    p_estudiante_id,
    p_pregunta_id,
    p_curso_id,
    p_respuesta_texto,
    CASE
      WHEN p_respuesta_opcion_id IS NULL OR p_respuesta_opcion_id = 0 THEN NULL
      ELSE p_respuesta_opcion_id
    END,
    p_respuesta_compuesta,
    p_es_correcta,
    CURRENT_TIMESTAMP
  );

  prc_actualizar_tasa(p_pregunta_id);
END;
/
