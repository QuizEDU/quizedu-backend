-- Índice por pregunta para estadísticas
CREATE INDEX idx_respuesta_pregunta_correcta
ON respuesta_estudiante (pregunta_id, es_correcta);

-- Índice auxiliar solo por pregunta (útil si haces más análisis)
CREATE INDEX idx_respuesta_pregunta
ON respuesta_estudiante (pregunta_id);
