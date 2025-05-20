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

DECLARE
  v_pregunta_id NUMBER;
BEGIN
  -- Crear pregunta tipo FALSO/VERDADERO directamente
  prc_crear_pregunta_banco(
    p_enunciado => 'El operador lógico ∧ representa la disyunción lógica.',
    p_tipo_pregunta_id => 3,  -- falso_verdadero
    p_respuesta_correcta => 'FALSO',
    p_respuesta_correcta_opcion_id => NULL,
    p_es_publica => 'S',
    p_dificultad => 'facil',
    p_usuario_id => 17,
    p_tema_id => 8,
    p_id_out => v_pregunta_id
  );

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Pregunta F/V creada con ID: ' || v_pregunta_id);
END;
/


DECLARE
  v_pregunta_id NUMBER;
BEGIN
  -- Crear pregunta tipo SELECCIÓN MÚLTIPLE
  prc_crear_pregunta_banco(
    p_enunciado => '¿Cuáles de los siguientes operadores lógicos existen en lógica proposicional?',
    p_tipo_pregunta_id => 2,  -- seleccion_multiple
    p_respuesta_correcta => NULL,
    p_respuesta_correcta_opcion_id => NULL,
    p_es_publica => 'S',
    p_dificultad => 'media',
    p_usuario_id => 17,   -- docente válido
    p_tema_id => 8,       -- tema válido
    p_id_out => v_pregunta_id
  );

  -- Insertar opciones (2 correctas, 2 incorrectas)
  prc_agregar_opcion_respuesta(v_pregunta_id, '∧', 'S');
  prc_agregar_opcion_respuesta(v_pregunta_id, '∨', 'S');
  prc_agregar_opcion_respuesta(v_pregunta_id, '√', 'N');
  prc_agregar_opcion_respuesta(v_pregunta_id, '≈', 'N');

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Pregunta múltiple creada con ID: ' || v_pregunta_id);
END;
/

DECLARE
  v_pregunta_id NUMBER;
BEGIN
  -- Crear pregunta tipo COMPLETAR
  prc_crear_pregunta_banco(
    p_enunciado => 'La negación de una proposición se representa con el símbolo ______.',
    p_tipo_pregunta_id => 4,  -- completar
    p_respuesta_correcta => '¬',
    p_respuesta_correcta_opcion_id => NULL,
    p_es_publica => 'S',
    p_dificultad => 'facil',
    p_usuario_id => 17,   -- docente válido
    p_tema_id => 8,       -- tema válido
    p_id_out => v_pregunta_id
  );

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Pregunta tipo completar creada con ID: ' || v_pregunta_id);
END;
/


DECLARE
  v_pregunta_id NUMBER;
BEGIN
  -- Paso 1: Crear la pregunta tipo ORDENAR
  prc_crear_pregunta_banco(
    p_enunciado => 'Ordena correctamente los pasos para analizar una proposición lógica compuesta:',
    p_tipo_pregunta_id => 6,  -- ordenar
    p_respuesta_correcta => NULL,
    p_respuesta_correcta_opcion_id => NULL,
    p_es_publica => 'S',
    p_dificultad => 'media',
    p_usuario_id => 17,
    p_tema_id => 8,
    p_id_out => v_pregunta_id
  );

  -- Paso 2: Insertar opciones con su orden correcto en el campo es_correcta
  prc_agregar_opcion_respuesta(v_pregunta_id, 'Identificar conectores', '1');
  prc_agregar_opcion_respuesta(v_pregunta_id, 'Aplicar negaciones', '2');
  prc_agregar_opcion_respuesta(v_pregunta_id, 'Evaluar conjunciones', '3');
  prc_agregar_opcion_respuesta(v_pregunta_id, 'Determinar valor de verdad', '4');

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Pregunta tipo ORDENAR creada con ID: ' || v_pregunta_id);
END;
/



DECLARE
  v_pregunta_id NUMBER;
BEGIN
  -- Crear la pregunta tipo emparejar
  prc_crear_pregunta_banco(
    p_enunciado => 'Empareja cada símbolo lógico con su significado correspondiente:',
    p_tipo_pregunta_id => 5,
    p_respuesta_correcta => NULL,
    p_respuesta_correcta_opcion_id => NULL,
    p_es_publica => 'S',
    p_dificultad => 'media',
    p_usuario_id => 17,
    p_tema_id => 8,
    p_id_out => v_pregunta_id
  );

  -- Insertar pares (simbolo / significado)
  prc_agregar_par_emparejamiento(v_pregunta_id, '∧', 'Conjunción', 'A');
  prc_agregar_par_emparejamiento(v_pregunta_id, '∨', 'Disyunción', 'B');
  prc_agregar_par_emparejamiento(v_pregunta_id, '¬', 'Negación', 'C');
  prc_agregar_par_emparejamiento(v_pregunta_id, '→', 'Condicional', 'D');
  prc_agregar_par_emparejamiento(v_pregunta_id, '↔', 'Bicondicional', 'E');
  prc_agregar_par_emparejamiento(v_pregunta_id, '⊕', 'Disyunción exclusiva', 'F');

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Pregunta tipo emparejar creada con ID: ' || v_pregunta_id);
END;
/
