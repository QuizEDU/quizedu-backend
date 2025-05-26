CREATE OR REPLACE PROCEDURE prc_registrar_inicio_evaluacion (
    p_evaluacion_id IN NUMBER,
    p_estudiante_id IN NUMBER,
    p_curso_id IN NUMBER,
    p_ip IN VARCHAR2
)
IS
    v_count NUMBER;
    v_estado_pendiente_id NUMBER;
BEGIN
    -- Verificar si ya existe un registro para esta evaluación y estudiante
    SELECT COUNT(*) INTO v_count
    FROM evaluacion_estudiante
    WHERE evaluacion_id = p_evaluacion_id
      AND estudiante_id = p_estudiante_id;

    IF v_count = 0 THEN
        -- Obtener el ID del estado 'en_progreso'
        SELECT id INTO v_estado_pendiente_id
        FROM estado_evaluacion_estudiante
        WHERE nombre = 'en_progreso';

        -- Insertar el nuevo registro
        INSERT INTO evaluacion_estudiante (
            evaluacion_id,
            estudiante_id,
            curso_id,
            fecha_inicio,
            calificacion,
            estado_id,
            ip_origen
        ) VALUES (
            p_evaluacion_id,
            p_estudiante_id,
            p_curso_id,
            SYSDATE,
            NULL,
            v_estado_pendiente_id,
            p_ip
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error en prc_registrar_inicio_evaluacion: ' || SQLERRM);
END;
/
