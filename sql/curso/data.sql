DECLARE
  v_id1 NUMBER;
  v_id2 NUMBER;
  v_id3 NUMBER;
  v_id4 NUMBER;
BEGIN
  prc_crear_curso('Curso Matemáticas 6°', 'Curso introductorio de matemáticas básicas.', 16, 1, DATE '2025-07-01', DATE '2025-11-30', v_id1);
  prc_crear_curso('Curso Física General', 'Conceptos fundamentales de la física.', 17, 2, DATE '2025-07-01', DATE '2025-11-30', v_id2);
  prc_crear_curso('Curso Lenguaje Primaria', 'Desarrollo de comprensión lectora.', 18, 3, DATE '2025-07-01', DATE '2025-11-30', v_id3);
  prc_crear_curso('Curso Tecnología Educativa', 'Tecnología aplicada al aula.', 19, 2, DATE '2025-07-01', DATE '2025-11-30', v_id4);

  -- Insertar 10 estudiantes en cada curso (10 * 4 = 40)
  FOR i IN 1..10 LOOP
    INSERT INTO curso_estudiante (curso_id, estudiante_id) VALUES (v_id1, i);
    INSERT INTO curso_estudiante (curso_id, estudiante_id) VALUES (v_id2, i);
    INSERT INTO curso_estudiante (curso_id, estudiante_id) VALUES (v_id3, i + 2); -- otros 10
    INSERT INTO curso_estudiante (curso_id, estudiante_id) VALUES (v_id4, i + 4); -- otros 10
  END LOOP;
  COMMIT;
END;
/