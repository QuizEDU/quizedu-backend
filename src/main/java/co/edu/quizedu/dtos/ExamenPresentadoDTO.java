package co.edu.quizedu.dtos;

public record ExamenPresentadoDTO(
        Long evaluacionId,
        String nombreEvaluacion,
        String nombreCurso,
        Double calificacion,
        String fechaInicio,
        String fechaFin,
        Double tiempoMinutos,
        String estadoEvaluacion,
        String ipOrigen,
        Long cursoId,
        String nombreEstudiante
) {}

