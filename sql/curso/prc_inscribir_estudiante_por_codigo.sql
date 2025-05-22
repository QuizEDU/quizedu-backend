CREATE OR REPLACE PROCEDURE prc_inscribir_estudiante_por_codigo (
  p_codigo_acceso IN VARCHAR2,
  p_estudiante_id IN NUMBER
) AS
  v_curso_id NUMBER;
BEGIN
  -- Obtener ID del curso por código
  SELECT id INTO v_curso_id
  FROM curso
  WHERE codigo_acceso = p_codigo_acceso
    AND estado = 'ACTIVO';

  -- Reutilizar procedimiento existente
  prc_inscribir_estudiante(v_curso_id, p_estudiante_id);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20020, 'No se encontró un curso activo con ese código.');
END;
/
