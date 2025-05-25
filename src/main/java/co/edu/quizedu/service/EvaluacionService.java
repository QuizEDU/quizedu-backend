package co.edu.quizedu.service;

import co.edu.quizedu.dtos.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

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


}
