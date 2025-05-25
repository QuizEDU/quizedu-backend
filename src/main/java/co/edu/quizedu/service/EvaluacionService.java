package co.edu.quizedu.service;

import co.edu.quizedu.dtos.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.*;

@Service
public class EvaluacionService {
    @Autowired
    private JdbcTemplate jdbc;

    public RespuestaDTO crearEvaluacionManual(CrearEvaluacionManualDTO dto) {
        String call = """
            BEGIN
              prc_crear_parcial_manual(
                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
              );
            END;
        """;

        try {
            jdbc.execute((Connection con) -> {
                CallableStatement cs = con.prepareCall(call);
                cs.setLong(1, dto.docenteId());
                cs.setString(2, dto.nombre());
                cs.setString(3, dto.descripcion());
                cs.setInt(4, dto.tiempoMaximo());
                cs.setString(5, dto.preguntasPesos());
                cs.setLong(6, dto.cursoId());
                cs.setTimestamp(7, Timestamp.valueOf(dto.fechaApertura()));
                cs.setTimestamp(8, Timestamp.valueOf(dto.fechaCierre()));
                cs.setInt(9, dto.intentos());
                cs.setDouble(10, dto.umbral());
                cs.registerOutParameter(11, Types.NUMERIC);

                cs.execute();
                Long idEval = cs.getLong(11);
                return new RespuestaDTO(true, "Evaluación creada con ID: " + idEval);
            });

        } catch (Exception e) {
            throw new RuntimeException("Error al crear la evaluación: " + e.getMessage(), e);
        }

        return new RespuestaDTO(true, "Evaluación creada correctamente");
    }

    public List<EvaluacionResumenDTO> listarEvaluacionesPorDocente(Long docenteId) {
        String sql = """
        SELECT 
            e.id, e.nombre, ev.nombre AS estado, 
            e.tiempo_maximo, e.fecha_creacion,
            c.nombre AS curso
        FROM evaluacion e
        JOIN estado_evaluacion ev ON ev.id = e.estado_id
        JOIN evaluacion_curso ec ON ec.evaluacion_id = e.id
        JOIN curso c ON c.id = ec.curso_id
        WHERE e.docente_id = ?
        ORDER BY e.fecha_creacion DESC
    """;

        return jdbc.query(sql, new Object[]{docenteId}, (rs, rowNum) ->
                new EvaluacionResumenDTO(
                        rs.getLong("id"),
                        rs.getString("nombre"),
                        rs.getString("estado"),
                        rs.getInt("tiempo_maximo"),
                        rs.getTimestamp("fecha_creacion").toLocalDateTime(),
                        rs.getString("curso")
                )
        );
    }

    public DetalleEvaluacionDTO obtenerDetalleEvaluacion(Long evaluacionId) {
        String evalSql = """
        SELECT e.id, e.nombre, e.descripcion, e.tiempo_maximo, est.nombre AS estado
        FROM evaluacion e
        JOIN estado_evaluacion est ON e.estado_id = est.id
        WHERE e.id = ?
    """;

        DetalleEvaluacionDTO evaluacion = jdbc.queryForObject(evalSql, new Object[]{evaluacionId}, (rs, rowNum) ->
                new DetalleEvaluacionDTO(
                        rs.getLong("id"),
                        rs.getString("nombre"),
                        rs.getString("descripcion"),
                        rs.getInt("tiempo_maximo"),
                        rs.getString("estado"),
                        new ArrayList<>()
                )
        );

        String preguntasSql = """
        SELECT p.id, p.enunciado, ep.porcentaje, ep.orden
        FROM evaluacion_pregunta ep
        JOIN banco_preguntas p ON ep.pregunta_id = p.id
        WHERE ep.evaluacion_id = ?
        ORDER BY ep.orden
    """;

        List<PreguntaEvaluacionDTO> preguntas = jdbc.query(preguntasSql, new Object[]{evaluacionId}, (rs, rowNum) ->
                new PreguntaEvaluacionDTO(
                        rs.getLong("id"),
                        rs.getString("enunciado"),
                        rs.getDouble("porcentaje"),
                        rs.getInt("orden")
                )
        );

        return new DetalleEvaluacionDTO(
                evaluacion.id(),
                evaluacion.nombre(),
                evaluacion.descripcion(),
                evaluacion.tiempoMaximo(),
                evaluacion.estado(),
                preguntas
        );
    }

    public List<PreguntaDisponibleDTO> obtenerPreguntasDisponibles(Long docenteId) {
        String sql = """
        SELECT p.id, DBMS_LOB.SUBSTR(p.enunciado, 4000) AS enunciado, 
               p.dificultad, t.nombre AS tema, 
               CASE WHEN p.es_publica = 'S' THEN 1 ELSE 0 END AS publica,
               u.nombre AS autor
        FROM banco_preguntas p
        JOIN tema t ON p.tema_id = t.id
        JOIN usuario u ON p.usuario_id = u.id
        WHERE p.es_publica = 'S' OR p.usuario_id = ?
        ORDER BY DBMS_LOB.SUBSTR(p.enunciado, 4000)
    """;

        return jdbc.query(sql, new Object[]{docenteId}, (rs, rowNum) ->
                new PreguntaDisponibleDTO(
                        rs.getLong("id"),
                        rs.getString("enunciado"),
                        rs.getString("dificultad"),
                        rs.getString("tema"),
                        rs.getInt("publica") == 1,
                        rs.getString("autor")
                )
        );
    }

    public List<EvaluacionDisponibleDTO> listarEvaluacionesDisponibles(Long estudianteId) {
        String sql = """
        SELECT 
            evaluacion_id,
            nombre_evaluacion,
            descripcion,
            tiempo_maximo,
            fecha_apertura,
            fecha_cierre,
            intentos_permitidos,
            intentos_realizados,
            curso_id,
            nombre_curso
        FROM vista_evaluaciones_disponibles
        WHERE estudiante_id = ?
        ORDER BY fecha_apertura DESC
    """;

        return jdbc.query(sql, new Object[]{estudianteId}, (rs, rowNum) ->
                new EvaluacionDisponibleDTO(
                        rs.getLong("evaluacion_id"),
                        rs.getString("nombre_evaluacion"),
                        rs.getString("descripcion"),
                        rs.getInt("tiempo_maximo"),
                        rs.getTimestamp("fecha_apertura").toLocalDateTime(),
                        rs.getTimestamp("fecha_cierre").toLocalDateTime(),
                        rs.getInt("intentos_permitidos"),
                        rs.getInt("intentos_realizados"),
                        rs.getLong("curso_id"),
                        rs.getString("nombre_curso")
                )
        );
    }

    public RespuestaDTO registrarInicioEvaluacion(InicioEvaluacionDTO dto) {
        String call = """
        BEGIN
            prc_registrar_inicio_evaluacion(?, ?, ?, ?);
        END;
    """;

        try {
            jdbc.execute((Connection con) -> {
                CallableStatement cs = con.prepareCall(call);
                cs.setLong(1, dto.evaluacionId());
                cs.setLong(2, dto.estudianteId());
                cs.setLong(3, dto.cursoId());
                cs.setString(4, dto.ip());
                cs.execute();
                return null;
            });
            return new RespuestaDTO(true, "Inicio registrado");
        } catch (Exception e) {
            throw new RuntimeException("Error al registrar inicio: " + e.getMessage(), e);
        }
    }

    public List<PreguntaEvaluacionDTO> obtenerPreguntasPorEvaluacion(Long evaluacionId) {
        String sql = """
        SELECT p.id, DBMS_LOB.SUBSTR(p.enunciado, 4000) AS enunciado, ep.porcentaje, ep.orden
        FROM evaluacion_pregunta ep
        JOIN banco_preguntas p ON p.id = ep.pregunta_id
        WHERE ep.evaluacion_id = ?
        ORDER BY ep.orden
    """;

        return jdbc.query(sql, new Object[]{evaluacionId}, (rs, rowNum) ->
                new PreguntaEvaluacionDTO(
                        rs.getLong("id"),
                        rs.getString("enunciado"),
                        rs.getDouble("porcentaje"),
                        rs.getInt("orden")
                )
        );
    }

    public List<PresentarPreguntaDTO> obtenerPreguntasParaPresentar(Long evaluacionId) {
        String sql = """
        SELECT p.id, DBMS_LOB.SUBSTR(p.enunciado, 4000) AS enunciado,
               tp.nombre AS tipo, p.dificultad,
               ep.porcentaje, ep.orden
        FROM evaluacion_pregunta ep
        JOIN banco_preguntas p ON p.id = ep.pregunta_id
        JOIN tipo_pregunta tp ON tp.id = p.tipo_pregunta_id
        WHERE ep.evaluacion_id = ?
        ORDER BY ep.orden
    """;

        return jdbc.query(sql, new Object[]{evaluacionId}, (rs, rowNum) -> {
            Long preguntaId = rs.getLong("id");
            String tipo = rs.getString("tipo");

            List<PresentarOpcionDTO> opciones = List.of();
            List<PresentarOpcionEmparejamientoDTO> izquierda = List.of();
            List<PresentarOpcionEmparejamientoDTO> derecha = List.of();

            switch (tipo) {
                case "seleccion_unica":
                case "seleccion_multiple":
                    opciones = mezclarOpciones(obtenerOpciones(preguntaId));
                    break;
                case "falso_verdadero":
                    opciones = List.of(
                            new PresentarOpcionDTO(0L, "Verdadero"),
                            new PresentarOpcionDTO(1L, "Falso")
                    );
                    break;
                case "ordenar":
                    opciones = mezclarOpciones(obtenerOpciones(preguntaId));
                    break;
                case "emparejar":
                    var lados = obtenerOpcionesEmparejamiento(preguntaId);
                    izquierda = lados.get("izquierda");
                    derecha = lados.get("derecha");
                    break;
            }

            return new PresentarPreguntaDTO(
                    preguntaId,
                    rs.getString("enunciado"),
                    tipo,
                    rs.getString("dificultad"),
                    rs.getDouble("porcentaje"),
                    rs.getInt("orden"),
                    opciones,
                    izquierda,
                    derecha
            );
        });
    }


    private List<PresentarOpcionDTO> obtenerOpciones(Long preguntaId) {
        String sql = """
        SELECT id, DBMS_LOB.SUBSTR(texto, 4000) AS texto
        FROM opcion_respuesta
        WHERE pregunta_id = ?
    """;

        List<PresentarOpcionDTO> opciones = jdbc.query(sql, new Object[]{preguntaId}, (rs, rowNum) ->
                new PresentarOpcionDTO(rs.getLong("id"), rs.getString("texto"))
        );

        Collections.shuffle(opciones); // ✅ desordenar si es "ordenar"
        return opciones;
    }

    private Map<String, List<PresentarOpcionEmparejamientoDTO>> obtenerOpcionesEmparejamiento(Long preguntaId) {
        String sql = """
        SELECT id, texto, es_correcta
        FROM opcion_respuesta
        WHERE pregunta_id = ?
    """;

        List<Map<String, Object>> datos = jdbc.queryForList(sql, preguntaId);

        Map<String, List<PresentarOpcionEmparejamientoDTO>> agrupados = new HashMap<>();
        for (Map<String, Object> fila : datos) {
            String clave = (String) fila.get("es_correcta");
            Long id = ((Number) fila.get("id")).longValue();
            String texto = (String) fila.get("texto");

            agrupados.computeIfAbsent(clave, k -> new ArrayList<>())
                    .add(new PresentarOpcionEmparejamientoDTO(id, texto));
        }

        List<PresentarOpcionEmparejamientoDTO> izquierda = new ArrayList<>();
        List<PresentarOpcionEmparejamientoDTO> derecha = new ArrayList<>();

        for (List<PresentarOpcionEmparejamientoDTO> par : agrupados.values()) {
            if (par.size() == 2) {
                izquierda.add(par.get(0));
                derecha.add(par.get(1));
            }
        }

        Collections.shuffle(izquierda);
        Collections.shuffle(derecha);

        Map<String, List<PresentarOpcionEmparejamientoDTO>> resultado = new HashMap<>();
        resultado.put("izquierda", izquierda);
        resultado.put("derecha", derecha);
        return resultado;
    }

    private <T> List<T> mezclarOpciones(List<T> lista) {
        List<T> copia = new ArrayList<>(lista);
        Collections.shuffle(copia);
        return copia;
    }

    private <T> List<T> mezclarPares(List<T> lista) {
        List<T> copia = new ArrayList<>(lista);
        Collections.shuffle(copia);
        return copia;
    }

}
