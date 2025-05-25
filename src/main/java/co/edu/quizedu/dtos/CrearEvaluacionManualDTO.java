package co.edu.quizedu.dtos;

import java.time.LocalDateTime;

public record CrearEvaluacionManualDTO(
        Long docenteId,
        String nombre,
        String descripcion,
        Integer tiempoMaximo,
        String preguntasPesos, // Ej: "3:10,22:20"
        Long cursoId,
        LocalDateTime fechaApertura,
        LocalDateTime fechaCierre,
        Integer intentos,
        Double umbral
) {}