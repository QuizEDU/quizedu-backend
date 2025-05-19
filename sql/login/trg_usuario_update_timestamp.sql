CREATE OR REPLACE TRIGGER trg_usuario_update_timestamp
BEFORE UPDATE ON usuario
FOR EACH ROW
BEGIN
  :NEW.fecha_actualizacion := CURRENT_TIMESTAMP;
END;
