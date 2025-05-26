CREATE OR REPLACE TRIGGER trg_actualizar_tasa_respuesta
AFTER INSERT ON respuesta_estudiante
DECLARE
  CURSOR c_preguntas IS
    SELECT DISTINCT pregunta_id
    FROM respuesta_estudiante
    WHERE fecha_respuesta = (
      SELECT MAX(fecha_respuesta) FROM respuesta_estudiante
    );
BEGIN
  FOR r IN c_preguntas LOOP
    prc_actualizar_tasa(r.pregunta_id);
  END LOOP;
END;
/
