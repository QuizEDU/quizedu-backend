package co.edu.quizedu.dtos;

public record PreguntaCompletarDTO(
        String enunciado,
        int tipoPreguntaId,          // 4 para tipo "completar"
        String respuestaCorrecta,    // La palabra o símbolo a completar (ej. "¬")
        boolean esPublica,
        String dificultad,
        long usuarioId,
        long temaId
) {}