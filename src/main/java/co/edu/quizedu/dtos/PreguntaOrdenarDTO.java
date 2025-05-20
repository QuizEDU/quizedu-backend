package co.edu.quizedu.dtos;

import java.util.List;

public record PreguntaOrdenarDTO(
        String enunciado,
        int tipoPreguntaId,         // 6 para tipo "ordenar"
        boolean esPublica,
        String dificultad,
        long usuarioId,
        long temaId,
        List<OpcionOrdenDTO> opciones
) {}
