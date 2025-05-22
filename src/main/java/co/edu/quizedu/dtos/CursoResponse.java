package co.edu.quizedu.dtos;

import java.time.LocalDate;

public record CursoResponse(
        Integer id,
        String nombre,
        String descripcion,
        String codigoAcceso,
        LocalDate fechaInicio,
        LocalDate fechaFin,
        String estado
) {}