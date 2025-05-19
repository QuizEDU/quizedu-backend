CREATE OR REPLACE TRIGGER trg_eliminar_dependencias_pregunta
AFTER DELETE ON banco_preguntas
FOR EACH ROW
BEGIN
  DELETE FROM opcion_respuesta WHERE pregunta_id = :OLD.id;
  DELETE FROM sub_pregunta WHERE pregunta_padre_id = :OLD.id;
  DELETE FROM respuesta_correcta WHERE banco_pregunta_id = :OLD.id;
END;
/
