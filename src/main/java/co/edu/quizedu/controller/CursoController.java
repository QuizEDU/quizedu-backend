package co.edu.quizedu.controller;

import co.edu.quizedu.dtos.CursoRequest;
import co.edu.quizedu.dtos.InscripcionRequest;
import co.edu.quizedu.service.CursoService;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.Map;

@RestController
@RequestMapping("/api/cursos")
public class CursoController {

    private final CursoService service;

    public CursoController(CursoService service) {
        this.service = service;
    }

    @PostMapping
    public ResponseEntity<?> crearCurso(@RequestBody CursoRequest request) {
        try {
            return ResponseEntity.ok(service.crearCurso(request));
        } catch (DataAccessException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/inscribirse")
    public ResponseEntity<?> inscribirse(@RequestBody InscripcionRequest request) {
        try {
            service.inscribirEstudiante(request);
            return ResponseEntity.ok(Map.of("mensaje", "Inscripción exitosa"));
        } catch (DataAccessException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/estudiante/{id}")
    public ResponseEntity<?> cursosEstudiante(@PathVariable int id) {
        try {
            return ResponseEntity.ok(service.cursosDeEstudiante(id));
        } catch (DataAccessException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/docente/{id}")
    public ResponseEntity<?> cursosDelDocente(@PathVariable int id) {
        try {
            return ResponseEntity.ok(service.cursosDelDocente(id));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/{cursoId}/docente/{docenteId}/estudiantes")
    public ResponseEntity<?> estudiantesDelCurso(@PathVariable int cursoId, @PathVariable int docenteId) {
        try {
            return ResponseEntity.ok(service.estudiantesDelCurso(cursoId, docenteId));
        } catch (ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("error", ex.getReason()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", e.getMessage()));
        }
    }
}