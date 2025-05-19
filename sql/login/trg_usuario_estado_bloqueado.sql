CREATE OR REPLACE TRIGGER trg_usuario_estado_bloqueado
AFTER UPDATE ON usuario
FOR EACH ROW
WHEN (OLD.estado != 'BLOQUEADO' AND NEW.estado = 'BLOQUEADO')
BEGIN
  UPDATE token
  SET valido = 'N'
  WHERE id_usuario = :NEW.id
    AND valido = 'S';
EXCEPTION
  WHEN OTHERS THEN
    -- Registrar el error o simplemente ignorar (silenciar si es esperado)
    NULL;
END;
/
