CREATE OR REPLACE TRIGGER trg_actualizar_tasa_respuesta
AFTER INSERT ON respuesta_estudiante
FOR EACH ROW
BEGIN
  prc_actualizar_tasa(:NEW.pregunta_id);
END;
/
