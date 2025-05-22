CREATE OR REPLACE PROCEDURE prc_inscribir_estudiante (
  p_curso_id      IN NUMBER,
  p_estudiante_id IN NUMBER
) AS
  v_existe NUMBER;
BEGIN
  -- Validar que no esté inscrito
  SELECT COUNT(*) INTO v_existe
  FROM curso_estudiante
  WHERE curso_id = p_curso_id AND estudiante_id = p_estudiante_id;

  IF v_existe > 0 THEN
    RAISE_APPLICATION_ERROR(-20012, 'Ya estás inscrito en este curso.');
  END IF;

  -- Insertar inscripción
  INSERT INTO curso_estudiante (curso_id, estudiante_id)
  VALUES (p_curso_id, p_estudiante_id);
END;
/
