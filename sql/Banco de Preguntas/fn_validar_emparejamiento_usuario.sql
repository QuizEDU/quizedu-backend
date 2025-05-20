CREATE OR REPLACE FUNCTION fn_validar_emparejamiento_usuario (
  p_pregunta_id IN NUMBER,
  p_pares_usuario IN VARCHAR2  -- formato: '101-102;103-104'
) RETURN VARCHAR2
IS
  v_total_pares NUMBER := 0;
  v_correctos NUMBER := 0;
  v_par VARCHAR2(100);
  v_id_izq NUMBER;
  v_id_der NUMBER;
  v_parte VARCHAR2(1000);
  v_es_izq VARCHAR2(10);
  v_es_der VARCHAR2(10);
BEGIN
  FOR par_str IN (
    SELECT REGEXP_SUBSTR(p_pares_usuario, '[^;]+', 1, LEVEL) AS par
    FROM dual
    CONNECT BY REGEXP_SUBSTR(p_pares_usuario, '[^;]+', 1, LEVEL) IS NOT NULL
  ) LOOP
    v_par := par_str.par;
    v_total_pares := v_total_pares + 1;

    -- Separar los dos IDs del par
    v_id_izq := TO_NUMBER(REGEXP_SUBSTR(v_par, '[^-]+', 1, 1));
    v_id_der := TO_NUMBER(REGEXP_SUBSTR(v_par, '[^-]+', 1, 2));

    -- Obtener es_correcta de ambos
    SELECT es_correcta INTO v_es_izq FROM opcion_respuesta 
    WHERE id = v_id_izq AND pregunta_id = p_pregunta_id;

    SELECT es_correcta INTO v_es_der FROM opcion_respuesta 
    WHERE id = v_id_der AND pregunta_id = p_pregunta_id;

    -- Comparar si hacen parte del mismo par lógico
    IF v_es_izq = v_es_der THEN
      v_correctos := v_correctos + 1;
    END IF;
  END LOOP;

  IF v_correctos = v_total_pares THEN
    RETURN 'OK';
  ELSE
    RETURN 'INCORRECTO';
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    RETURN 'ERROR: ' || SQLERRM;
END;
/
