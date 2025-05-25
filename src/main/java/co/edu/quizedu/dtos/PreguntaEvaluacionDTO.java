package co.edu.quizedu.dtos;

public record PreguntaEvaluacionDTO(
        Long id,
        String enunciado,
        Double porcentaje,
        Integer orden
) {}
