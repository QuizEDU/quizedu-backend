package co.edu.quizedu.service;

import co.edu.quizedu.dtos.CrearPlanEstudioRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class PlanEstudioService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public void crearPlanEstudio(CrearPlanEstudioRequest request) {
        try {
            jdbcTemplate.execute((Connection con) -> {
                CallableStatement cs = con.prepareCall("{ call prc_crear_plan_estudio(?) }");
                cs.setString(1, request.nombre());
                cs.execute();
                return null;
            });
        } catch (Exception e) {
            String mensaje = e.getMessage();

            if (mensaje != null && mensaje.contains("ORA-20001")) {
                throw new ResponseStatusException(HttpStatus.CONFLICT, "Ya existe un plan de estudio con ese nombre.");
            }

            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Error inesperado al crear el plan de estudio.");
        }
    }

    public List<Map<String, Object>> listarPlanes() {
        return jdbcTemplate.queryForList("SELECT * FROM plan_estudio ORDER BY nombre");
    }

    public List<Map<String, Object>> listarUnidadesPorPlan(Long planId) {
        return jdbcTemplate.queryForList("""
            SELECT u.id, u.nombre
            FROM unidad u
            WHERE u.plan_estudio_id = ?
            ORDER BY u.nombre
        """, planId);
    }

    public List<Map<String, Object>> listarContenidosPorUnidad(Long unidadId) {
        return jdbcTemplate.queryForList("""
            SELECT c.id, c.nombre
            FROM contenido c
            WHERE c.unidad_id = ?
            ORDER BY c.nombre
        """, unidadId);
    }

    public List<Map<String, Object>> listarTemasPorContenido(Long contenidoId) {
        return jdbcTemplate.queryForList("""
            SELECT t.id, t.nombre
            FROM tema t
            WHERE t.contenido_id = ?
            ORDER BY t.nombre
        """, contenidoId);
    }

    public List<Map<String, Object>> obtenerEstructuraAgrupada(Long planId) {
        String sql = """
        SELECT 
          pe.id AS plan_id,
          pe.nombre AS plan_nombre,
          u.id AS unidad_id,
          u.nombre AS unidad_nombre,
          c.id AS contenido_id,
          c.nombre AS contenido_nombre,
          t.id AS tema_id,
          t.nombre AS tema_nombre
        FROM tema t
        JOIN contenido c ON t.contenido_id = c.id
        JOIN unidad u ON c.unidad_id = u.id
        JOIN plan_estudio pe ON u.plan_estudio_id = pe.id
        """ + (planId != null ? "WHERE pe.id = ?" : "") + """
        ORDER BY pe.id, u.id, c.id, t.id
    """;

        List<Map<String, Object>> rows = planId != null
                ? jdbcTemplate.queryForList(sql, planId)
                : jdbcTemplate.queryForList(sql);

        Map<Long, Map<String, Object>> planes = new LinkedHashMap<>();

        for (Map<String, Object> row : rows) {
            Long planIdRow = ((Number) row.get("plan_id")).longValue();
            Long unidadId = ((Number) row.get("unidad_id")).longValue();
            Long contenidoId = ((Number) row.get("contenido_id")).longValue();
            Long temaId = ((Number) row.get("tema_id")).longValue();

            // Plan
            Map<String, Object> plan = planes.computeIfAbsent(planIdRow, id -> {
                Map<String, Object> p = new LinkedHashMap<>();
                p.put("id", planIdRow);
                p.put("nombre", row.get("plan_nombre"));
                p.put("unidades", new LinkedHashMap<Long, Map<String, Object>>());
                return p;
            });

            // Unidad
            Map<Long, Map<String, Object>> unidades = (Map<Long, Map<String, Object>>) plan.get("unidades");
            Map<String, Object> unidad = unidades.computeIfAbsent(unidadId, id -> {
                Map<String, Object> u = new LinkedHashMap<>();
                u.put("id", unidadId);
                u.put("nombre", row.get("unidad_nombre"));
                u.put("contenidos", new LinkedHashMap<Long, Map<String, Object>>());
                return u;
            });

            // Contenido
            Map<Long, Map<String, Object>> contenidos = (Map<Long, Map<String, Object>>) unidad.get("contenidos");
            Map<String, Object> contenido = contenidos.computeIfAbsent(contenidoId, id -> {
                Map<String, Object> c = new LinkedHashMap<>();
                c.put("id", contenidoId);
                c.put("nombre", row.get("contenido_nombre"));
                c.put("temas", new ArrayList<Map<String, Object>>());
                return c;
            });

            // Tema
            List<Map<String, Object>> temas = (List<Map<String, Object>>) contenido.get("temas");
            temas.add(Map.of(
                    "id", temaId,
                    "nombre", row.get("tema_nombre")
            ));
        }

        // Convertir a estructura anidada
        return planes.values().stream().map(plan -> {
            Map<Long, Map<String, Object>> unidadesMap = (Map<Long, Map<String, Object>>) plan.remove("unidades");
            List<Map<String, Object>> unidadesList = new ArrayList<>();

            for (Map<String, Object> unidad : unidadesMap.values()) {
                Map<Long, Map<String, Object>> contenidosMap = (Map<Long, Map<String, Object>>) unidad.remove("contenidos");
                List<Map<String, Object>> contenidosList = new ArrayList<>();

                for (Map<String, Object> contenido : contenidosMap.values()) {
                    contenidosList.add(contenido);
                }

                unidad.put("contenidos", contenidosList);
                unidadesList.add(unidad);
            }

            plan.put("unidades", unidadesList);
            return plan;
        }).toList();
    }

}

