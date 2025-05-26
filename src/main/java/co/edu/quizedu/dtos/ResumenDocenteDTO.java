package co.edu.quizedu.dtos;

public record ResumenDocenteDTO(
        Long docenteId,
        String nombreDocente,
        Integer cursosAsignados,
        Integer preguntasCreadas,
        Double promedioGeneralDocente
) {}
