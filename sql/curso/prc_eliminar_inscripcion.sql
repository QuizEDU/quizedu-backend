CREATE OR REPLACE PROCEDURE prc_eliminar_inscripcion (
  p_curso_id IN NUMBER,
  p_estudiante_id IN NUMBER
) AS
BEGIN
  DELETE FROM curso_estudiante
  WHERE curso_id = p_curso_id AND estudiante_id = p_estudiante_id;
END;
/
