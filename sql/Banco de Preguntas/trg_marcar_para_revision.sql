CREATE OR REPLACE TRIGGER trg_marcar_para_revision
BEFORE UPDATE ON banco_preguntas
FOR EACH ROW
BEGIN
  IF :NEW.tasa_respuesta_correcta < 50 THEN
    :NEW.requiere_revision := 'S';
  END IF;
END;
/
