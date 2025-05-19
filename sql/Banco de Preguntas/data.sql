INSERT INTO tipo_pregunta (id, nombre) VALUES (1, 'seleccion_unica');
INSERT INTO tipo_pregunta (id, nombre) VALUES (2, 'seleccion_multiple');
INSERT INTO tipo_pregunta (id, nombre) VALUES (3, 'falso_verdadero');
INSERT INTO tipo_pregunta (id, nombre) VALUES (4, 'completar');
INSERT INTO tipo_pregunta (id, nombre) VALUES (5, 'emparejar');
INSERT INTO tipo_pregunta (id, nombre) VALUES (6, 'ordenar');


DECLARE
  v_pregunta_id NUMBER;
BEGIN
  -- Paso 1: Crear pregunta con retorno del ID
  prc_crear_pregunta_banco(
    p_enunciado => '¿Cuál es el resultado lógico de verdadero ∧ falso?',
    p_tipo_pregunta_id => 1,
    p_respuesta_correcta => NULL,
    p_respuesta_correcta_opcion_id => NULL,
    p_es_publica => 'N',
    p_dificultad => 'media',
    p_usuario_id => 17,
    p_tema_id => 8,
    p_id_out => v_pregunta_id
  );

  -- Paso 2: Insertar opciones
  prc_agregar_opcion_respuesta(v_pregunta_id, 'Falso', 'S');      -- Correcta
  prc_agregar_opcion_respuesta(v_pregunta_id, 'Verdadero', 'N');
  prc_agregar_opcion_respuesta(v_pregunta_id, 'Ambos', 'N');

  -- Paso 3: Asignar automáticamente la opción correcta usando la función
  UPDATE banco_preguntas
  SET respuesta_correcta_opcion_id = fn_opcion_correcta_id(v_pregunta_id)
  WHERE id = v_pregunta_id;

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Pregunta creada con ID: ' || v_pregunta_id);
END;
/
