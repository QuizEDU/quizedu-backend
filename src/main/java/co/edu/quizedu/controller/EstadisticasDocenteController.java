package co.edu.quizedu.controller;

import co.edu.quizedu.dtos.EstadisticaPreguntaDTO;
import co.edu.quizedu.dtos.ExamenPresentadoDTO;
import co.edu.quizedu.dtos.ProgresoEstudianteCursoDTO;
import co.edu.quizedu.dtos.ResumenDocenteDTO;
import co.edu.quizedu.service.EstadisticasService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/estadisticas/docente")
public class EstadisticasDocenteController {

    @Autowired
    private EstadisticasService estadisticasService;

    @GetMapping("/{id}/resumen")
    public ResponseEntity<ResumenDocenteDTO> getResumen(@PathVariable Long id) {
        return ResponseEntity.ok(estadisticasService.obtenerResumenDocente(id));
    }

    @GetMapping("/{id}/preguntas")
    public ResponseEntity<List<EstadisticaPreguntaDTO>> getEstadisticasPreguntas(@PathVariable Long id) {
        return ResponseEntity.ok(estadisticasService.obtenerEstadisticasPreguntasDocente(id));
    }

    @GetMapping("/{id}/preguntas-criticas")
    public ResponseEntity<List<EstadisticaPreguntaDTO>> getPreguntasCriticas(@PathVariable Long id) {
        return ResponseEntity.ok(estadisticasService.obtenerPreguntasCriticas(id));
    }

    @GetMapping("/{id}/curso/{cursoId}/progreso")
    public ResponseEntity<List<ProgresoEstudianteCursoDTO>> getProgresoCurso(
            @PathVariable Long id,
            @PathVariable Long cursoId) {
        return ResponseEntity.ok(estadisticasService.obtenerProgresoPorCurso(id, cursoId));
    }

    @GetMapping("/{id}/examenes")
    public ResponseEntity<List<ExamenPresentadoDTO>> getExamenesPresentados(@PathVariable Long id) {
        return ResponseEntity.ok(estadisticasService.obtenerExamenesDocente(id));
    }
}
