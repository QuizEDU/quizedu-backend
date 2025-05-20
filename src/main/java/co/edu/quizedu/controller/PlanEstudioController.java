package co.edu.quizedu.controller;


import co.edu.quizedu.dtos.CrearContenidoRequest;
import co.edu.quizedu.dtos.CrearPlanEstudioRequest;
import co.edu.quizedu.dtos.CrearTemaRequest;
import co.edu.quizedu.dtos.CrearUnidadRequest;
import co.edu.quizedu.service.PlanEstudioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/plan-estudio")
public class PlanEstudioController {

    @Autowired
    private PlanEstudioService service;

    @PostMapping
    public void crear(@RequestBody CrearPlanEstudioRequest request) {
        service.crearPlanEstudio(request);
    }

    @PostMapping("/unidad")
    public void crearUnidad(@RequestBody CrearUnidadRequest request) {
        service.crearUnidad(request);
    }

    @PostMapping("/contenido")
    public void crearContenido(@RequestBody CrearContenidoRequest request) {
        service.crearContenido(request);
    }

    @PostMapping("/tema")
    public void crearTema(@RequestBody CrearTemaRequest request) {
        service.crearTema(request);
    }

    @GetMapping
    public List<Map<String, Object>> listarPlanes() {
        return service.listarPlanes();
    }

    @GetMapping("/{id}/unidades")
    public List<Map<String, Object>> unidadesPorPlan(@PathVariable Long id) {
        return service.listarUnidadesPorPlan(id);
    }

    @GetMapping("/unidad/{id}/contenidos")
    public List<Map<String, Object>> contenidosPorUnidad(@PathVariable Long id) {
        return service.listarContenidosPorUnidad(id);
    }

    @GetMapping("/contenido/{id}/temas")
    public List<Map<String, Object>> temasPorContenido(@PathVariable Long id) {
        return service.listarTemasPorContenido(id);
    }

    @GetMapping("/estructura")
    public List<Map<String, Object>> estructuraAgrupada(@RequestParam(required = false) Long id) {
        return service.obtenerEstructuraAgrupada(id);
    }
}