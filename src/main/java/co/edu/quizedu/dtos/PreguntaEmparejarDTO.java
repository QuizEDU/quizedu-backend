package co.edu.quizedu.dtos;

import java.util.List;

public record PreguntaEmparejarDTO(
        String enunciado,
        int tipoPreguntaId,         // 5 para tipo "emparejar"
        boolean esPublica,
        String dificultad,
        long usuarioId,
        long temaId,
        List<ParEmparejamientoDTO> pares
) {}
