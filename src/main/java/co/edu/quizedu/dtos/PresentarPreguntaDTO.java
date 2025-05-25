package co.edu.quizedu.dtos;

import java.util.List;

public record PresentarPreguntaDTO(
        Long id,
        String enunciado,
        String tipo,
        String dificultad,
        Double porcentaje,
        Integer orden,
        List<PresentarOpcionDTO> opciones,
        List<PresentarOpcionEmparejamientoDTO> izquierda,
        List<PresentarOpcionEmparejamientoDTO> derecha
) {}
