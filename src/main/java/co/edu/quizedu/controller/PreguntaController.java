package co.edu.quizedu.controller;

import co.edu.quizedu.dtos.*;
import co.edu.quizedu.service.PreguntaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/preguntas")
public class PreguntaController {

    @Autowired
    private PreguntaService preguntaService;

    @GetMapping("/tipo")
    public ResponseEntity<?> listar() {
        try {
            return ResponseEntity.ok(preguntaService.listarTipos());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/privadas/{usuarioId}")
    public ResponseEntity<?> obtenerPrivadas(@PathVariable Long usuarioId) {
        try {
            return ResponseEntity.ok(preguntaService.preguntasPrivadasPorDocente(usuarioId));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/publicas")
    public ResponseEntity<?> obtenerPublicas() {
        try {
            return ResponseEntity.ok(preguntaService.preguntasPublicas());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/vf")
    public ResponseEntity<?> crearVerdaderoFalso(@RequestBody PreguntaVFDTO dto) {
        try {
            preguntaService.crearPreguntaVerdaderoFalso(dto);
            return ResponseEntity.ok(new RespuestaDTO(true, "Pregunta verdadero/falso creada exitosamente."));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("error", e.getMessage()));
        }
    }


    @PostMapping("/seleccion-unica")
    public ResponseEntity<?> crearSeleccionUnica(@RequestBody PreguntaSeleccionUnicaDTO dto) {
        try {
            preguntaService.crearPreguntaSeleccionUnica(dto);
            return ResponseEntity.ok(new RespuestaDTO(true, "Pregunta de selección única creada exitosamente."));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new RespuestaDTO(false, e.getMessage()));
        }
    }

    @PostMapping("/seleccion-multiple")
    public ResponseEntity<?> crearSeleccionMultiple(@RequestBody PreguntaSeleccionMultipleDTO dto) {
        try {
            preguntaService.crearPreguntaSeleccionMultiple(dto);
            return ResponseEntity.ok(new RespuestaDTO(true, "Pregunta de selección múltiple creada exitosamente."));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new RespuestaDTO(false, e.getMessage()));
        }
    }

    @PostMapping("/completar")
    public ResponseEntity<?> crearCompletar(@RequestBody PreguntaCompletarDTO dto) {
        try {
            preguntaService.crearPreguntaCompletar(dto);
            return ResponseEntity.ok(new RespuestaDTO(true, "Pregunta de completar creada exitosamente."));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new RespuestaDTO(false, e.getMessage()));
        }
    }

    @PostMapping("/ordenar")
    public ResponseEntity<?> crearOrdenar(@RequestBody PreguntaOrdenarDTO dto) {
        try {
            preguntaService.crearPreguntaOrdenar(dto);
            return ResponseEntity.ok(new RespuestaDTO(true, "Pregunta de ordenar creada exitosamente."));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new RespuestaDTO(false, e.getMessage()));
        }
    }

    @PostMapping("/emparejar")
    public ResponseEntity<?> crearEmparejar(@RequestBody PreguntaEmparejarDTO dto) {
        try {
            preguntaService.crearPreguntaEmparejar(dto);
            return ResponseEntity.ok(new RespuestaDTO(true, "Pregunta de emparejamiento creada exitosamente."));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new RespuestaDTO(false, e.getMessage()));
        }
    }
}