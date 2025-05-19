CREATE OR REPLACE TRIGGER trg_actualizar_fecha_usuario
AFTER INSERT OR UPDATE ON banco_preguntas
FOR EACH ROW
BEGIN
  UPDATE usuario
  SET fecha_actualizacion = CURRENT_TIMESTAMP
  WHERE id = :NEW.usuario_id;
END;
/
