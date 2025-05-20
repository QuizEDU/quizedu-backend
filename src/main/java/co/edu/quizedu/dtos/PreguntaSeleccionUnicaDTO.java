package co.edu.quizedu.dtos;

import java.util.List;

public record PreguntaSeleccionUnicaDTO(
        String enunciado,
        int tipoPreguntaId,
        boolean esPublica,
        String dificultad,
        int usuarioId,
        int temaId,
        List<OpcionDTO> opciones
) {}