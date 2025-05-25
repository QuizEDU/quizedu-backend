package co.edu.quizedu.dtos;

public record PresentarRespuestaDTO(
        Long evaluacionId,
        Long estudianteId,
        Long cursoId,
        Long preguntaId,
        String tipo,                   // Ej: 'emparejar', 'ordenar', etc.
        String respuestaTexto,         // Para completar
        Long respuestaOpcionId,        // Para única / VF
        String respuestaCompuesta,     // Para múltiple u ordenar: '31,32,34'
        String emparejamientos         // Para emparejar: '31-32;33-34'
) {}
