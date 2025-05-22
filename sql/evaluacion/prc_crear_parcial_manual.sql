CREATE OR REPLACE PROCEDURE prc_crear_parcial_manual(
  p_docente_id        IN NUMBER,
  p_nombre_examen     IN VARCHAR2,
  p_descripcion       IN VARCHAR2,
  p_tiempo_max        IN NUMBER,
  p_preguntas_pesos   IN VARCHAR2, -- Ejemplo: '3:10,22:15,27:20'
  p_curso_id          IN NUMBER,
  p_fecha_apertura    IN TIMESTAMP,
  p_fecha_cierre      IN TIMESTAMP,
  p_intentos          IN NUMBER,
  p_umbral            IN NUMBER,
  p_evaluacion_id     OUT NUMBER
) IS
  v_tipo_seleccion_id NUMBER;
  v_estado_id         NUMBER;
  v_orden             NUMBER := 1;

  v_par               VARCHAR2(1000);
  v_id                NUMBER;
  v_porcentaje        NUMBER;

  v_start_pos         PLS_INTEGER := 1;
  v_end_pos           PLS_INTEGER;
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
    p_descripcion,
    p_tiempo_max,
    v_tipo_seleccion_id,
    v_estado_id,
    p_docente_id
  ) RETURNING id INTO p_evaluacion_id;

  -- Parsear string tipo '3:10,22:15,27:20'
  LOOP
    v_end_pos := INSTR(p_preguntas_pesos, ',', v_start_pos);
    IF v_end_pos > 0 THEN
      v_par := SUBSTR(p_preguntas_pesos, v_start_pos, v_end_pos - v_start_pos);
    ELSE
      v_par := SUBSTR(p_preguntas_pesos, v_start_pos);
    END IF;

    IF v_par IS NOT NULL THEN
      v_id := TO_NUMBER(SUBSTR(v_par, 1, INSTR(v_par, ':') - 1));
      v_porcentaje := TO_NUMBER(SUBSTR(v_par, INSTR(v_par, ':') + 1));

      INSERT INTO evaluacion_pregunta (
        evaluacion_id, pregunta_id, porcentaje, orden
      ) VALUES (
        p_evaluacion_id, v_id, v_porcentaje, v_orden
      );

      v_orden := v_orden + 1;
    END IF;

    EXIT WHEN v_end_pos = 0;
    v_start_pos := v_end_pos + 1;
  END LOOP;

  -- Asignar evaluación al curso
  prc_asignar_evaluacion_a_curso(
    p_evaluacion_id,
    p_curso_id,
    p_fecha_apertura,
    p_fecha_cierre,
    p_intentos,
    p_umbral
  );

  DBMS_OUTPUT.PUT_LINE('Parcial creado con ID: ' || p_evaluacion_id);
END;
/
