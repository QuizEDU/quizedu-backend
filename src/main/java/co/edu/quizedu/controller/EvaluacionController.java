package co.edu.quizedu.controller;

import co.edu.quizedu.dtos.*;
import co.edu.quizedu.service.EvaluacionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/evaluaciones")
public class EvaluacionController {

    @Autowired
    private EvaluacionService evaluacionService;

    @PostMapping("/manual")
    public ResponseEntity<RespuestaDTO> crearEvaluacionManual(@RequestBody CrearEvaluacionManualDTO dto) {
        try {
            RespuestaDTO respuesta = evaluacionService.crearEvaluacionManual(dto);
            return ResponseEntity.ok(respuesta);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new RespuestaDTO(false, e.getMessage()));
        }
    }

    @GetMapping("/docente/{idDocente}")
    public ResponseEntity<List<EvaluacionResumenDTO>> listarPorDocente(@PathVariable Long idDocente) {
        return ResponseEntity.ok(evaluacionService.listarEvaluacionesPorDocente(idDocente));
    }

    @GetMapping("/{id}")
    public ResponseEntity<DetalleEvaluacionDTO> obtenerDetalle(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(evaluacionService.obtenerDetalleEvaluacion(id));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(null);
        }
    }

    @GetMapping("/preguntas/docente/{id}")
    public ResponseEntity<List<PreguntaDisponibleDTO>> obtenerPreguntasDocente(@PathVariable Long id) {
        return ResponseEntity.ok(evaluacionService.obtenerPreguntasDisponibles(id));
    }
}