package co.edu.quizedu.controller;

import co.edu.quizedu.dtos.CrearPreguntaRequest;
import co.edu.quizedu.dtos.TipoPreguntaDTO;
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
    public List<TipoPreguntaDTO> listar() {
        return preguntaService.listarTipos();
    }

    @GetMapping("/privadas/{usuarioId}")
    public ResponseEntity<List<Map<String, Object>>> obtenerPrivadas(@PathVariable Long usuarioId) {
        try {
            return ResponseEntity.ok(preguntaService.preguntasPrivadasPorDocente(usuarioId));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);
        }
    }

    @GetMapping("/publicas")
    public ResponseEntity<List<Map<String, Object>>> obtenerPublicas() {
        try {
            return ResponseEntity.ok(preguntaService.preguntasPublicas());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);
        }
    }
}
