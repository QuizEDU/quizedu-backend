package co.edu.quizedu.dtos;

import java.time.LocalDate;

public record CursoRequest(
        String nombre,
        String descripcion,
        Integer docenteId,
        Integer planEstudioId,
        LocalDate fechaInicio,
        LocalDate fechaFin
) {}