package co.edu.quizedu.dtos;

public record ResumenEstudianteDTO(
        Long estudianteId,
        String nombreEstudiante,
        Integer evaluacionesRealizadas,
        Double promedioGeneral,
        Integer aprobadas,
        Integer reprobadas
) {}

