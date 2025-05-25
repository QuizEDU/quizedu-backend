package co.edu.quizedu.dtos;

public record PreguntaDisponibleDTO(
        Long id,
        String enunciado,
        String dificultad,
        String tema,
        boolean esPublica,
        String autor
) {}
