package co.edu.quizedu.service;

import co.edu.quizedu.dtos.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EstadisticasService {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<ExamenPresentadoDTO> obtenerExamenesPorEstudiante(Long estudianteId) {
        String sql = """
            SELECT 
              evaluacion_id,
              nombre_evaluacion,
              nombre_curso,
              calificacion,
              TO_CHAR(fecha_inicio, 'YYYY-MM-DD HH24:MI') AS fecha_inicio,
              TO_CHAR(fecha_fin, 'YYYY-MM-DD HH24:MI') AS fecha_fin,
              tiempo_minutos,
              estado_evaluacion,
              curso_id
            FROM vista_mis_examenes
            WHERE estudiante_id = ?
            ORDER BY fecha_inicio DESC
        """;

        return jdbcTemplate.query(sql, new Object[]{estudianteId}, (rs, rowNum) -> new ExamenPresentadoDTO(
                rs.getLong("evaluacion_id"),
                rs.getString("nombre_evaluacion"),
                rs.getString("nombre_curso"),
                rs.getDouble("calificacion"),
                rs.getString("fecha_inicio"),
                rs.getString("fecha_fin"),
                rs.getDouble("tiempo_minutos"),
                rs.getString("estado_evaluacion"),null,rs.getLong("curso_id"),null
        ));
    }
    public ResumenEstudianteDTO obtenerResumenEstudiante(Long estudianteId) {
        String sql = """
        SELECT * FROM vista_desempeno_estudiante WHERE estudiante_id = ?
    """;

        return jdbcTemplate.queryForObject(sql, new Object[]{estudianteId}, (rs, rowNum) -> new ResumenEstudianteDTO(
                rs.getLong("estudiante_id"),
                rs.getString("nombre_estudiante"),
                rs.getInt("evaluaciones_realizadas"),
                rs.getDouble("promedio_general"),
                rs.getInt("aprobadas"),
                rs.getInt("reprobadas")
        ));
    }

    public List<RendimientoTemaDTO> obtenerRendimientoPorTema(Long estudianteId) {
        String sql = """
        SELECT * FROM vista_rendimiento_tema_estudiante WHERE estudiante_id = ?
    """;

        return jdbcTemplate.query(sql, new Object[]{estudianteId}, (rs, rowNum) -> new RendimientoTemaDTO(
                rs.getLong("tema_id"),
                rs.getString("nombre_tema"),
                rs.getDouble("promedio_tema"),
                rs.getInt("evaluaciones_con_este_tema")
        ));
    }
    public ResumenDocenteDTO obtenerResumenDocente(Long docenteId) {
        return jdbcTemplate.queryForObject("""
        SELECT * FROM vista_estadistica_global_docente WHERE docente_id = ?
    """, new Object[]{docenteId}, (rs, rowNum) -> new ResumenDocenteDTO(
                rs.getLong("docente_id"),
                rs.getString("nombre_docente"),
                rs.getInt("cursos_asignados"),
                rs.getInt("preguntas_creadas"),
                rs.getDouble("promedio_general_docente")
        ));
    }

    public List<EstadisticaPreguntaDTO> obtenerEstadisticasPreguntasDocente(Long docenteId) {
        return jdbcTemplate.query("""
        SELECT * FROM vista_estadisticas_pregunta_por_curso WHERE docente_id = ?
    """, new Object[]{docenteId}, (rs, rowNum) -> new EstadisticaPreguntaDTO(
                rs.getLong("pregunta_id"),
                rs.getString("enunciado"),
                "S".equals(rs.getString("requiere_revision")),
                rs.getInt("total_respuestas"),
                rs.getInt("correctas"),
                rs.getInt("incorrectas"),
                rs.getDouble("porcentaje_correctas"),
                rs.getLong("curso_id")
        ));
    }

    public List<EstadisticaPreguntaDTO> obtenerPreguntasCriticas(Long docenteId) {
        return jdbcTemplate.query("""
        SELECT * FROM vista_preguntas_con_bajo_desempeno WHERE docente_id = ?
    """, new Object[]{docenteId}, (rs, rowNum) -> new EstadisticaPreguntaDTO(
                rs.getLong("pregunta_id"),
                rs.getString("enunciado"),
                true,
                rs.getInt("total_respuestas"),
                rs.getInt("correctas"),
                rs.getInt("incorrectas"),
                rs.getDouble("porcentaje_aciertos"),null
        ));
    }

    public List<ProgresoEstudianteCursoDTO> obtenerProgresoPorCurso(Long docenteId, Long cursoId) {
        return jdbcTemplate.query("""
        SELECT * FROM vista_progreso_estudiantes_por_curso 
        WHERE curso_id = ? AND curso_id IN (SELECT id FROM curso WHERE docente_id = ?)
    """, new Object[]{cursoId, docenteId}, (rs, rowNum) -> new ProgresoEstudianteCursoDTO(
                rs.getLong("curso_id"),
                rs.getString("nombre_curso"),
                rs.getLong("estudiante_id"),
                rs.getString("nombre_estudiante"),
                rs.getInt("evaluaciones_presentadas"),
                rs.getInt("evaluaciones_totales"),
                rs.getDouble("progreso")
        ));
    }

    public List<ExamenPresentadoDTO> obtenerExamenesDocente(Long docenteId) {
        return jdbcTemplate.query("""
        SELECT * FROM vista_examenes_presentados 
        WHERE docente_id = ? 
        ORDER BY fecha_inicio DESC
    """, new Object[]{docenteId}, (rs, rowNum) -> new ExamenPresentadoDTO(
                rs.getLong("evaluacion_id"),
                rs.getString("nombre_evaluacion"),
                rs.getString("nombre_curso"),
                rs.getDouble("calificacion"),
                rs.getString("fecha_inicio"),
                rs.getString("fecha_fin"),
                rs.getDouble("tiempo_minutos"),
                rs.getString("estado_evaluacion"),
                rs.getString("ip_origen"),
                rs.getLong("curso_id"),
                rs.getString("nombre_estudiante")
        ));
    }


}
