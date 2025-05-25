package co.edu.quizedu.dtos;

public record InicioEvaluacionDTO(
        Long evaluacionId,
        Long estudianteId,
        Long cursoId,
        String ip
) {}