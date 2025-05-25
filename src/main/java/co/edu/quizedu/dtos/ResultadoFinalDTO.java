package co.edu.quizedu.dtos;

public record ResultadoFinalDTO(
        boolean exito,
        String mensaje,
        Double calificacion
) {}