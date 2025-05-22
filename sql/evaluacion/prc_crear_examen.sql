CREATE OR REPLACE PROCEDURE prc_crear_examen(
  p_docente_id     IN  NUMBER,
  p_nombre_examen  IN  VARCHAR2,
  p_curso_id       IN  NUMBER,
  p_fecha_apertura IN  TIMESTAMP,
  p_fecha_cierre   IN  TIMESTAMP,
  p_tiempo_max     IN  NUMBER DEFAULT 30,
  p_intentos       IN  NUMBER DEFAULT 1,
  p_umbral         IN  NUMBER DEFAULT 60,
  p_evaluacion_id  OUT NUMBER
) IS
  v_tipo_seleccion_id NUMBER;
  v_estado_id NUMBER;
  v_orden NUMBER := 1;
BEGIN
  -- Obtener IDs de dominio
  SELECT id INTO v_tipo_seleccion_id FROM tipo_seleccion WHERE nombre = 'manual';
  SELECT id INTO v_estado_id FROM estado_evaluacion WHERE nombre = 'borrador';

  -- Crear evaluación
  INSERT INTO evaluacion (
    nombre, descripcion, tiempo_maximo,
    tipo_seleccion_id, estado_id, docente_id
  ) VALUES (
    p_nombre_examen,
    'Generada automáticamente para el docente ' || p_docente_id,
    p_tiempo_max,
    v_tipo_seleccion_id,
    v_estado_id,
    p_docente_id
  )
  RETURNING id INTO p_evaluacion_id;

  -- Agregar 10 preguntas del docente o públicas
  FOR pregunta IN (
    SELECT id FROM banco_preguntas
    WHERE es_publica = 'S' OR usuario_id = p_docente_id
    ORDER BY DBMS_RANDOM.VALUE
    FETCH FIRST 10 ROWS ONLY
  ) LOOP
    INSERT INTO evaluacion_pregunta (
      evaluacion_id, pregunta_id, porcentaje, orden
    ) VALUES (
      p_evaluacion_id, pregunta.id, 10, v_orden
    );
    v_orden := v_orden + 1;
  END LOOP;

  -- Asignar evaluación al curso usando tu procedimiento
  prc_asignar_evaluacion_a_curso(
    p_evaluacion_id,
    p_curso_id,
    p_fecha_apertura,
    p_fecha_cierre,
    p_intentos,
    p_umbral
  );

  DBMS_OUTPUT.PUT_LINE('Examen creado con ID: ' || p_evaluacion_id);
END;
/
