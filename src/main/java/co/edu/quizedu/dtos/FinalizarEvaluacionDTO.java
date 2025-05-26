package co.edu.quizedu.dtos;

import java.util.List;

public record FinalizarEvaluacionDTO(
        Long evaluacionId,
        Long estudianteId,
        Long cursoId,
        List<PresentarRespuestaDTO> respuestas
) {}