-- ======================
-- Planes de estudio
-- ======================
BEGIN
  prc_crear_plan_estudio('Plan Básico General');
  prc_crear_plan_estudio('Plan Ingeniería');
  prc_crear_plan_estudio('Plan Educación Primaria');
END;
/

-- ======================
-- Unidades para cada plan
-- ======================
DECLARE v_plan_id NUMBER;
BEGIN
  SELECT id INTO v_plan_id FROM plan_estudio WHERE nombre = 'Plan Básico General';
  prc_crear_unidad('Unidad de Lógica', v_plan_id);
  prc_crear_unidad('Unidad de Matemáticas', v_plan_id);
  prc_crear_unidad('Unidad de Lenguaje', v_plan_id);
END;
/

DECLARE v_plan_id NUMBER;
BEGIN
  SELECT id INTO v_plan_id FROM plan_estudio WHERE nombre = 'Plan Ingeniería';
  prc_crear_unidad('Unidad de Programación', v_plan_id);
  prc_crear_unidad('Unidad de Física', v_plan_id);
  prc_crear_unidad('Unidad de Cálculo', v_plan_id);
END;
/

DECLARE v_plan_id NUMBER;
BEGIN
  SELECT id INTO v_plan_id FROM plan_estudio WHERE nombre = 'Plan Educación Primaria';
  prc_crear_unidad('Unidad de Ciencias', v_plan_id);
  prc_crear_unidad('Unidad de Matemática Básica', v_plan_id);
  prc_crear_unidad('Unidad de Lectura', v_plan_id);
END;
/

-- ======================
-- Contenidos por unidad
-- ======================
DECLARE v_unidad_id NUMBER;
BEGIN
  -- Lógica
  SELECT id INTO v_unidad_id FROM unidad WHERE nombre = 'Unidad de Lógica';
  prc_crear_contenido('Operadores Lógicos', v_unidad_id);
  prc_crear_contenido('Tablas de verdad', v_unidad_id);

  -- Matemáticas
  SELECT id INTO v_unidad_id FROM unidad WHERE nombre = 'Unidad de Matemáticas';
  prc_crear_contenido('Fracciones', v_unidad_id);
  prc_crear_contenido('Álgebra', v_unidad_id);

  -- Lenguaje
  SELECT id INTO v_unidad_id FROM unidad WHERE nombre = 'Unidad de Lenguaje';
  prc_crear_contenido('Ortografía básica', v_unidad_id);
  prc_crear_contenido('Redacción de párrafos', v_unidad_id);

  -- Programación
  SELECT id INTO v_unidad_id FROM unidad WHERE nombre = 'Unidad de Programación';
  prc_crear_contenido('Variables y tipos de datos', v_unidad_id);
  prc_crear_contenido('Estructuras de control', v_unidad_id);

  -- Física
  SELECT id INTO v_unidad_id FROM unidad WHERE nombre = 'Unidad de Física';
  prc_crear_contenido('Movimiento rectilíneo', v_unidad_id);
  prc_crear_contenido('Fuerzas y leyes de Newton', v_unidad_id);

  -- Cálculo
  SELECT id INTO v_unidad_id FROM unidad WHERE nombre = 'Unidad de Cálculo';
  prc_crear_contenido('Derivadas', v_unidad_id);
  prc_crear_contenido('Límites', v_unidad_id);

  -- Ciencias
  SELECT id INTO v_unidad_id FROM unidad WHERE nombre = 'Unidad de Ciencias';
  prc_crear_contenido('Los seres vivos', v_unidad_id);
  prc_crear_contenido('El agua y su ciclo', v_unidad_id);

  -- Matemática Básica
  SELECT id INTO v_unidad_id FROM unidad WHERE nombre = 'Unidad de Matemática Básica';
  prc_crear_contenido('Sumas y restas', v_unidad_id);
  prc_crear_contenido('Multiplicación y división', v_unidad_id);

  -- Lectura
  SELECT id INTO v_unidad_id FROM unidad WHERE nombre = 'Unidad de Lectura';
  prc_crear_contenido('Comprensión lectora', v_unidad_id);
  prc_crear_contenido('Lectura en voz alta', v_unidad_id);
END;
/

-- ======================
-- Temas (mínimo 40 en total)
-- ======================
DECLARE 
  v_cont_id contenido.id%TYPE;
  v_ids SYS_REFCURSOR;
  v_id_list DBMS_SQL.NUMBER_TABLE;
  v_index NUMBER := 1;
BEGIN
    -- Cargar todos los IDs de contenido en memoria
    OPEN v_ids FOR SELECT id FROM contenido;
    FETCH v_ids BULK COLLECT INTO v_id_list;
    CLOSE v_ids;

    -- Generar 20 temas usando rotación de contenidos
    FOR i IN 1..20 LOOP
        v_cont_id := v_id_list(MOD(i - 1, v_id_list.COUNT) + 1);
        prc_crear_tema('Tema automático #' || TO_CHAR(i), v_cont_id);
    END LOOP;

    -- Algunos específicos
    SELECT id INTO v_cont_id FROM contenido WHERE nombre = 'Fracciones';
    prc_crear_tema('Fracciones equivalentes', v_cont_id);
    prc_crear_tema('Suma de fracciones', v_cont_id);

    SELECT id INTO v_cont_id FROM contenido WHERE nombre = 'Ortografía básica';
    prc_crear_tema('Uso de la b y v', v_cont_id);
    prc_crear_tema('Acentuación', v_cont_id);

    SELECT id INTO v_cont_id FROM contenido WHERE nombre = 'Comprensión lectora';
    prc_crear_tema('Ideas principales y secundarias', v_cont_id);
    prc_crear_tema('Inferencias en textos', v_cont_id);
END;
/

COMMIT;
