package co.edu.quizedu.dtos;

import java.time.LocalDateTime;

public record EvaluacionResumenDTO(
        Long id,
        String nombre,
        String estado,
        Integer tiempoMaximo,
        LocalDateTime fechaCreacion,
        String nombreCurso // 🆕 nuevo campo
) {}
