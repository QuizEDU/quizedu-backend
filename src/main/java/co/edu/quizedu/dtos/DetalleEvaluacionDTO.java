package co.edu.quizedu.dtos;

import java.util.List;

public record DetalleEvaluacionDTO(
        Long id,
        String nombre,
        String descripcion,
        Integer tiempoMaximo,
        String estado,
        List<PreguntaEvaluacionDTO> preguntas
) {}