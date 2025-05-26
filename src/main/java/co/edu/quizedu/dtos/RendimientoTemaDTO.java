package co.edu.quizedu.dtos;

public record RendimientoTemaDTO(
        Long temaId,
        String nombreTema,
        Double promedioTema,
        Integer evaluacionesConEsteTema
) {}
