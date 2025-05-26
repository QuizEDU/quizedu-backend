CREATE OR REPLACE PROCEDURE prc_responder_pregunta (
  p_evaluacion_id IN NUMBER,
  p_estudiante_id IN NUMBER,
  p_curso_id IN NUMBER,
  p_pregunta_id IN NUMBER,
  p_tipo IN VARCHAR2,
  p_respuesta_texto IN CLOB,
  p_respuesta_opcion_id IN NUMBER,
  p_respuesta_compuesta IN CLOB,
  p_emparejamientos IN VARCHAR2 -- solo para emparejar
)
IS
  v_correcta CHAR(1) := 'N';
  v_opcion_id NUMBER;
BEGIN
  CASE p_tipo
    WHEN 'falso_verdadero' THEN
      v_opcion_id := NVL(p_respuesta_opcion_id, 0); -- solo para VF se convierte null en 0
      IF v_opcion_id = fn_vf_correcta(p_pregunta_id) THEN
        v_correcta := 'S';
      END IF;

    WHEN 'seleccion_unica' THEN
      IF p_respuesta_opcion_id = fn_opcion_correcta_id(p_pregunta_id) THEN
        v_correcta := 'S';
      END IF;

    WHEN 'seleccion_multiple' THEN
      IF fn_validar_seleccion_multiple(p_pregunta_id, p_respuesta_compuesta) = 'OK' THEN
        v_correcta := 'S';
      END IF;

    WHEN 'completar' THEN
      IF UPPER(TRIM(p_respuesta_texto)) = UPPER(TRIM(fn_respuesta_correcta_texto(p_pregunta_id))) THEN
        v_correcta := 'S';
      END IF;

    WHEN 'ordenar' THEN
      IF fn_validar_orden_usuario(p_pregunta_id, p_respuesta_compuesta) = 'OK' THEN
        v_correcta := 'S';
      END IF;

    WHEN 'emparejar' THEN
      IF fn_validar_emparejamiento_usuario(p_pregunta_id, p_emparejamientos) = 'OK' THEN
        v_correcta := 'S';
      END IF;
  END CASE;

  -- Registrar la respuesta
  prc_registrar_respuesta_estudiante(
    p_evaluacion_id,
    p_estudiante_id,
    p_pregunta_id,
    p_curso_id,
    p_respuesta_texto,
    -- Usa la opción corregida solo en VF, el resto pasa la original
    CASE 
      WHEN p_tipo = 'falso_verdadero' THEN NVL(p_respuesta_opcion_id, 0)
      ELSE p_respuesta_opcion_id
    END,
    p_respuesta_compuesta,
    v_correcta
  );
END;
/
