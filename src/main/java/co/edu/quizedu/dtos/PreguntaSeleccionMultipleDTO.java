package co.edu.quizedu.dtos;

import java.util.List;

public record PreguntaSeleccionMultipleDTO(
        String enunciado,
        int tipoPreguntaId,             // 2 para seleccion_multiple
        boolean esPublica,
        String dificultad,
        long usuarioId,
        long temaId,
        List<OpcionDTO> opciones        // Lista de opciones con texto y si es correcta
) {}