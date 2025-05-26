package co.edu.quizedu.dtos;

public record ProgresoEstudianteCursoDTO(
        Long cursoId,
        String nombreCurso,
        Long estudianteId,
        String nombreEstudiante,
        Integer evaluacionesPresentadas,
        Integer evaluacionesTotales,
        Double progreso
) {}
