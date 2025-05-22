CREATE OR REPLACE PROCEDURE prc_actualizar_tasa(p_pregunta_id IN NUMBER) IS
  total_respuestas NUMBER;
  respuestas_correctas NUMBER;
  nueva_tasa NUMBER(5,2);
BEGIN
  SELECT COUNT(*) INTO total_respuestas
  FROM respuesta_estudiante
  WHERE pregunta_id = p_pregunta_id;

  SELECT COUNT(*) INTO respuestas_correctas
  FROM respuesta_estudiante
  WHERE pregunta_id = p_pregunta_id AND es_correcta = 'S';

  IF total_respuestas > 0 THEN
    nueva_tasa := (respuestas_correctas / total_respuestas) * 100;

    UPDATE banco_preguntas
    SET tasa_respuesta_correcta = nueva_tasa,
        requiere_revision = CASE WHEN nueva_tasa < 50 THEN 'S' ELSE 'N' END
    WHERE id = p_pregunta_id;
  END IF;
END;
/
