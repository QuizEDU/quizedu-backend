package co.edu.quizedu.dtos;

public record CrearPreguntaRequest(
        String enunciado,
        Long tipoPreguntaId,
        String respuestaCorrecta,
        Long respuestaCorrectaOpcionId, // puede ser null si no aplica
        String esPublica, // 'S' o 'N'
        String dificultad, // 'facil', 'media', 'dificil'
        Long usuarioId,
        Long temaId
) {}