CREATE OR REPLACE TRIGGER trg_validar_docente_en_pregunta
BEFORE INSERT ON banco_preguntas
FOR EACH ROW
DECLARE
  v_es_docente NUMBER;
BEGIN
  v_es_docente := fn_es_docente(:NEW.usuario_id);

  IF v_es_docente = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Solo los usuarios con rol DOCENTE pueden crear preguntas.');
  END IF;
END;
/
