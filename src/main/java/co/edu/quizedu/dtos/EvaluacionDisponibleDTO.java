package co.edu.quizedu.dtos;

import java.time.LocalDateTime;

public record EvaluacionDisponibleDTO(
        Long evaluacionId,
        String nombreEvaluacion,
        String descripcion,
        Integer tiempoMaximo,
        LocalDateTime fechaApertura,
        LocalDateTime fechaCierre,
        Integer intentosPermitidos,
        Integer intentosRealizados,
        Long cursoId,
        String nombreCurso,
        Boolean inicioRegistrado,
        Boolean puedePresentar
) {}
