CREATE OR REPLACE FUNCTION fn_es_docente(p_usuario_id IN NUMBER)
RETURN NUMBER
AS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_count
  FROM usuario_rol ur
  JOIN rol r ON ur.id_rol = r.id
  WHERE ur.id_usuario = p_usuario_id
    AND UPPER(r.nombre) = 'DOCENTE';

  RETURN CASE WHEN v_count > 0 THEN 1 ELSE 0 END;
END;
/
