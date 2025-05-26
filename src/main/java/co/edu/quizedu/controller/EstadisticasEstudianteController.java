package co.edu.quizedu.controller;

import co.edu.quizedu.dtos.ExamenPresentadoDTO;
import co.edu.quizedu.dtos.RendimientoTemaDTO;
import co.edu.quizedu.dtos.ResumenEstudianteDTO;
import co.edu.quizedu.service.EstadisticasService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/estadisticas/estudiante")
public class EstadisticasEstudianteController {

    @Autowired
    private EstadisticasService estadisticasService;

    @GetMapping("/{id}/examenes")
    public ResponseEntity<List<ExamenPresentadoDTO>> getExamenes(@PathVariable Long id) {
        return ResponseEntity.ok(estadisticasService.obtenerExamenesPorEstudiante(id));
    }

    @GetMapping("/{id}/resumen")
    public ResponseEntity<ResumenEstudianteDTO> getResumen(@PathVariable Long id) {
        return ResponseEntity.ok(estadisticasService.obtenerResumenEstudiante(id));
    }

    @GetMapping("/{id}/rendimiento-temas")
    public ResponseEntity<List<RendimientoTemaDTO>> getPorTema(@PathVariable Long id) {
        return ResponseEntity.ok(estadisticasService.obtenerRendimientoPorTema(id));
    }
}