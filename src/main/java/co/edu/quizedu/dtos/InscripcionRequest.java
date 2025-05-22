package co.edu.quizedu.dtos;

public record InscripcionRequest(
        Integer estudianteId,
        String codigoAcceso
) {}