package co.edu.quizedu.dtos;

public record PreguntaVFDTO(
        String enunciado,
        int tipoPreguntaId,           // ID del tipo de pregunta (ej. 3 para F/V)
        String respuestaCorrecta,     // "VERDADERO" o "FALSO"
        boolean esPublica,            // true = 'S', false = 'N'
        String dificultad,            // "facil", "media", "dificil"
        long usuarioId,               // ID del usuario que la crea
        long temaId                   // ID del tema asociado
) {}
