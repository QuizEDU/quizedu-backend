CREATE OR REPLACE FUNCTION fnc_generar_codigo_acceso
RETURN VARCHAR2
IS
  v_codigo VARCHAR2(10);
BEGIN
  -- 6 caracteres alfanuméricos
  v_codigo := 
    DBMS_RANDOM.STRING('X', 3) || 
    DBMS_RANDOM.STRING('U', 3); -- mezcla letras y números

  RETURN UPPER(SUBSTR(REPLACE(v_codigo, ' ', ''), 1, 6));
END;
/
