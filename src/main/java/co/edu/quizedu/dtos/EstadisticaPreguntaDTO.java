package co.edu.quizedu.dtos;

public record EstadisticaPreguntaDTO(
        Long preguntaId,
        String enunciado,
        Boolean requiereRevision,
        Integer totalRespuestas,
        Integer correctas,
        Integer incorrectas,
        Double porcentajeCorrectas
) {}
