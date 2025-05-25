INSERT INTO tipo_seleccion (nombre) VALUES ('manual');
INSERT INTO tipo_seleccion (nombre) VALUES ('aleatorio');

INSERT INTO estado_evaluacion (nombre) VALUES ('publicada');
INSERT INTO estado_evaluacion (nombre) VALUES ('borrador');
-- Tabla: estado_evaluacion_estudiante
INSERT INTO estado_evaluacion_estudiante (nombre) VALUES ('pendiente');
INSERT INTO estado_evaluacion_estudiante (nombre) VALUES ('en_progreso');
INSERT INTO estado_evaluacion_estudiante (nombre) VALUES ('finalizado');


DECLARE
  v_evaluacion_id NUMBER;
BEGIN
  prc_crear_parcial_manual(
    p_docente_id        => 17,
    p_nombre_examen     => 'Parcial Unidad 1',
    p_descripcion       => 'Parcial de práctica sobre lógica proposicional',
    p_tiempo_max        => 40,
    p_preguntas_pesos   => '1:10,21:15,41:20,64:40,65:15',
    p_curso_id          => 8, -- Reemplaza con el ID real del curso
    p_fecha_apertura    => SYSTIMESTAMP,
    p_fecha_cierre      => SYSTIMESTAMP + INTERVAL '5' DAY,
    p_intentos          => 1,
    p_umbral            => 60,
    p_evaluacion_id     => v_evaluacion_id
  );

  DBMS_OUTPUT.PUT_LINE('✅ Evaluación creada con ID: ' || v_evaluacion_id);
END;
/

COMMIT;