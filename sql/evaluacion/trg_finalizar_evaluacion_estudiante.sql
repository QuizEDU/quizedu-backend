CREATE OR REPLACE TRIGGER trg_finalizar_evaluacion_estudiante
BEFORE UPDATE OF fecha_fin ON evaluacion_estudiante
FOR EACH ROW
BEGIN
  IF :NEW.fecha_fin IS NOT NULL THEN
    -- Buscar ID de estado 'finalizado'
    UPDATE evaluacion_estudiante
    SET estado_id = (
      SELECT id FROM estado_evaluacion_estudiante WHERE nombre = 'finalizado'
    )
    WHERE evaluacion_id = :NEW.evaluacion_id AND estudiante_id = :NEW.estudiante_id;
  END IF;
END;
/
