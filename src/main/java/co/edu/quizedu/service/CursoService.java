package co.edu.quizedu.service;

import co.edu.quizedu.dtos.CursoRequest;
import co.edu.quizedu.dtos.CursoResponse;
import co.edu.quizedu.dtos.InscripcionRequest;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.sql.Types;
import java.util.List;
import java.util.Map;

@Service
public class CursoService {

    private final JdbcTemplate jdbc;

    public CursoService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public CursoResponse crearCurso(CursoRequest request) {
        SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                .withProcedureName("prc_crear_curso")
                .declareParameters(
                        new SqlParameter("p_nombre", Types.VARCHAR),
                        new SqlParameter("p_descripcion", Types.CLOB),
                        new SqlParameter("p_docente_id", Types.INTEGER),
                        new SqlParameter("p_plan_estudio_id", Types.INTEGER),
                        new SqlParameter("p_fecha_inicio", Types.DATE),
                        new SqlParameter("p_fecha_fin", Types.DATE),
                        new SqlOutParameter("p_id_out", Types.INTEGER)  // 👈 importante
                );

        SqlParameterSource in = new MapSqlParameterSource()
                .addValue("p_nombre", request.nombre())
                .addValue("p_descripcion", request.descripcion())
                .addValue("p_docente_id", request.docenteId())
                .addValue("p_plan_estudio_id", request.planEstudioId())
                .addValue("p_fecha_inicio", request.fechaInicio())
                .addValue("p_fecha_fin", request.fechaFin());

        Map<String, Object> out = call.execute(in);

        Integer idCurso = (Integer) out.get("p_id_out");

        return obtenerCursoPorId(idCurso);
    }


    public CursoResponse obtenerCursoPorId(Integer id) {
        String sql = """
            SELECT id, nombre, descripcion, codigo_acceso, fecha_inicio, fecha_fin, estado
            FROM curso WHERE id = ?
        """;
        return jdbc.queryForObject(sql, (rs, rowNum) -> new CursoResponse(
                rs.getInt("id"),
                rs.getString("nombre"),
                rs.getString("descripcion"),
                rs.getString("codigo_acceso"),
                rs.getDate("fecha_inicio").toLocalDate(),
                rs.getDate("fecha_fin").toLocalDate(),
                rs.getString("estado")
        ), id);
    }

    public void inscribirEstudiante(InscripcionRequest request) {
        jdbc.update("BEGIN prc_inscribir_estudiante_por_codigo(?, ?); END;",
                request.codigoAcceso(), request.estudianteId()
        );
    }

    public List<CursoResponse> cursosDeEstudiante(int estudianteId) {
        String sql = """
            SELECT c.id, c.nombre, c.descripcion, c.codigo_acceso, c.fecha_inicio, c.fecha_fin, c.estado
            FROM curso_estudiante ce
            JOIN curso c ON ce.curso_id = c.id
            WHERE ce.estudiante_id = ?
        """;
        return jdbc.query(sql, (rs, rowNum) -> new CursoResponse(
                rs.getInt("id"),
                rs.getString("nombre"),
                rs.getString("descripcion"),
                rs.getString("codigo_acceso"),
                rs.getDate("fecha_inicio").toLocalDate(),
                rs.getDate("fecha_fin").toLocalDate(),
                rs.getString("estado")
        ), estudianteId);
    }

    public List<CursoResponse> cursosDelDocente(int docenteId) {
        String sql = """
        SELECT id, nombre, descripcion, codigo_acceso, fecha_inicio, fecha_fin, estado
        FROM curso
        WHERE docente_id = ?
    """;
        return jdbc.query(sql, (rs, rowNum) -> new CursoResponse(
                rs.getInt("id"),
                rs.getString("nombre"),
                rs.getString("descripcion"),
                rs.getString("codigo_acceso"),
                rs.getDate("fecha_inicio").toLocalDate(),
                rs.getDate("fecha_fin").toLocalDate(),
                rs.getString("estado")
        ), docenteId);
    }

    public List<Map<String, Object>> estudiantesDelCurso(int cursoId, int docenteId) {
        // Validar que el curso le pertenece al docente
        Integer count = jdbc.queryForObject("""
        SELECT COUNT(*) FROM curso WHERE id = ? AND docente_id = ?
    """, Integer.class, cursoId, docenteId);

        if (count == null || count == 0)
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "El curso no pertenece al docente.");

        // Listar estudiantes
        String sql = """
        SELECT u.id, u.nombre, u.correo, u.estado
        FROM curso_estudiante ce
        JOIN usuario u ON ce.estudiante_id = u.id
        WHERE ce.curso_id = ?
    """;

        return jdbc.queryForList(sql, cursoId);
    }
}
