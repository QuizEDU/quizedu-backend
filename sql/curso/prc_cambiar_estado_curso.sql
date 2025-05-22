CREATE OR REPLACE PROCEDURE prc_cambiar_estado_curso (
  p_curso_id IN NUMBER,
  p_nuevo_estado IN VARCHAR2
) AS
BEGIN
  IF p_nuevo_estado NOT IN ('ACTIVO', 'CERRADO', 'CANCELADO') THEN
    RAISE_APPLICATION_ERROR(-20021, 'Estado no válido.');
  END IF;

  UPDATE curso
  SET estado = p_nuevo_estado
  WHERE id = p_curso_id;
END;
/
