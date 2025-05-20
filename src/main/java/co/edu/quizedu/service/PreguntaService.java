package co.edu.quizedu.service;

import co.edu.quizedu.dtos.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class PreguntaService {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<TipoPreguntaDTO> listarTipos() {
        return jdbcTemplate.query("SELECT id, nombre FROM tipo_pregunta ORDER BY id",
                (rs, rowNum) -> new TipoPreguntaDTO(
                        rs.getLong("id"),
                        rs.getString("nombre")
                )
        );
    }

    public List<Map<String, Object>> preguntasPrivadasPorDocente(Long usuarioId) {
        String sql = """
        SELECT bp.id, bp.enunciado, tp.nombre AS tipo, bp.dificultad, bp.tasa_respuesta_correcta,
               t.nombre AS tema, c.nombre AS contenido, u.nombre AS unidad, pe.nombre AS plan_estudio
         FROM banco_preguntas bp
         LEFT JOIN tipo_pregunta tp ON bp.tipo_pregunta_id = tp.id
         LEFT JOIN tema t ON bp.tema_id = t.id
         LEFT JOIN contenido c ON t.contenido_id = c.id
         LEFT JOIN unidad u ON c.unidad_id = u.id
         LEFT JOIN plan_estudio pe ON u.plan_estudio_id = pe.id
         WHERE bp.usuario_id = ? AND bp.es_publica = 'N'
         ORDER BY bp.id DESC
    """;

        return jdbcTemplate.queryForList(sql, usuarioId);
    }

    public List<Map<String, Object>> preguntasPublicas() {
        String sql = """
         SELECT bp.id, bp.enunciado, tp.nombre AS tipo, bp.dificultad, bp.tasa_respuesta_correcta,
                t.nombre AS tema, c.nombre AS contenido, u.nombre AS unidad, pe.nombre AS plan_estudio
         FROM banco_preguntas bp
         LEFT JOIN tipo_pregunta tp ON bp.tipo_pregunta_id = tp.id
         LEFT JOIN tema t ON bp.tema_id = t.id
         LEFT JOIN contenido c ON t.contenido_id = c.id
         LEFT JOIN unidad u ON c.unidad_id = u.id
         LEFT JOIN plan_estudio pe ON u.plan_estudio_id = pe.id
         WHERE bp.es_publica = 'S'
         ORDER BY bp.id DESC
    """;

        return jdbcTemplate.queryForList(sql);
    }
    public void crearPreguntaSeleccionUnica(PreguntaSeleccionUnicaDTO dto) {
        // Construir las llamadas a prc_agregar_opcion_respuesta
        String opcionesPLSQL = dto.opciones().stream()
                .map(opcion -> """
            prc_agregar_opcion_respuesta(
              v_pregunta_id,
              '%s',
              '%s'
            );
            """.formatted(
                                escapeSql(opcion.texto()),
                                opcion.esCorrecta() ? "S" : "N"
                        )
                ).collect(Collectors.joining("\n"));

        // Armar bloque PL/SQL
        String plsql = """
        DECLARE
          v_pregunta_id NUMBER;
        BEGIN
          -- Crear la pregunta
          prc_crear_pregunta_banco(
            p_enunciado => '%s',
            p_tipo_pregunta_id => %d,
            p_respuesta_correcta => NULL,
            p_respuesta_correcta_opcion_id => NULL,
            p_es_publica => '%s',
            p_dificultad => '%s',
            p_usuario_id => %d,
            p_tema_id => %d,
            p_id_out => v_pregunta_id
          );

          -- Insertar opciones
          %s

          -- Asignar opción correcta
          UPDATE banco_preguntas
          SET respuesta_correcta_opcion_id = fn_opcion_correcta_id(v_pregunta_id)
          WHERE id = v_pregunta_id;

          COMMIT;
        END;
        """.formatted(
                escapeSql(dto.enunciado()),
                dto.tipoPreguntaId(),
                dto.esPublica() ? "S" : "N",
                escapeSql(dto.dificultad()),
                dto.usuarioId(),
                dto.temaId(),
                opcionesPLSQL
        );

        jdbcTemplate.execute(plsql);
    }

    public void crearPreguntaVerdaderoFalso(PreguntaVFDTO dto) {
        String plsql = """
        DECLARE
          v_pregunta_id NUMBER;
        BEGIN
          prc_crear_pregunta_banco(
            p_enunciado => '%s',
            p_tipo_pregunta_id => %d,
            p_respuesta_correcta => '%s',
            p_respuesta_correcta_opcion_id => NULL,
            p_es_publica => '%s',
            p_dificultad => '%s',
            p_usuario_id => %d,
            p_tema_id => %d,
            p_id_out => v_pregunta_id
          );

          COMMIT;
        END;
        """.formatted(
                escapeSql(dto.enunciado()),
                dto.tipoPreguntaId(),
                escapeSql(dto.respuestaCorrecta().toUpperCase()),
                dto.esPublica() ? "S" : "N",
                escapeSql(dto.dificultad()),
                dto.usuarioId(),
                dto.temaId()
        );

        jdbcTemplate.execute(plsql);
    }

    public void crearPreguntaSeleccionMultiple(PreguntaSeleccionMultipleDTO dto) {
        // Generar las líneas de opciones dinámicamente
        String opcionesPLSQL = dto.opciones().stream()
                .map(op -> """
            prc_agregar_opcion_respuesta(
              v_pregunta_id,
              '%s',
              '%s'
            );
            """.formatted(
                                escapeSql(op.texto()),
                                op.esCorrecta() ? "S" : "N"
                        )
                ).collect(Collectors.joining("\n"));

        // Armar el bloque PL/SQL completo
        String plsql = """
        DECLARE
          v_pregunta_id NUMBER;
        BEGIN
          -- Crear pregunta tipo SELECCIÓN MÚLTIPLE
          prc_crear_pregunta_banco(
            p_enunciado => '%s',
            p_tipo_pregunta_id => %d,
            p_respuesta_correcta => NULL,
            p_respuesta_correcta_opcion_id => NULL,
            p_es_publica => '%s',
            p_dificultad => '%s',
            p_usuario_id => %d,
            p_tema_id => %d,
            p_id_out => v_pregunta_id
          );

          -- Insertar opciones
          %s

          COMMIT;
        END;
        """.formatted(
                escapeSql(dto.enunciado()),
                dto.tipoPreguntaId(),
                dto.esPublica() ? "S" : "N",
                escapeSql(dto.dificultad()),
                dto.usuarioId(),
                dto.temaId(),
                opcionesPLSQL
        );

        // Ejecutar el bloque
        jdbcTemplate.execute(plsql);
    }

    public void crearPreguntaCompletar(PreguntaCompletarDTO dto) {
        String plsql = """
        DECLARE
          v_pregunta_id NUMBER;
        BEGIN
          -- Crear pregunta tipo COMPLETAR
          prc_crear_pregunta_banco(
            p_enunciado => '%s',
            p_tipo_pregunta_id => %d,
            p_respuesta_correcta => '%s',
            p_respuesta_correcta_opcion_id => NULL,
            p_es_publica => '%s',
            p_dificultad => '%s',
            p_usuario_id => %d,
            p_tema_id => %d,
            p_id_out => v_pregunta_id
          );

          COMMIT;
        END;
        """.formatted(
                escapeSql(dto.enunciado()),
                dto.tipoPreguntaId(),
                escapeSql(dto.respuestaCorrecta()),
                dto.esPublica() ? "S" : "N",
                escapeSql(dto.dificultad()),
                dto.usuarioId(),
                dto.temaId()
        );

        jdbcTemplate.execute(plsql);
    }

    public void crearPreguntaOrdenar(PreguntaOrdenarDTO dto) {
        String opcionesPLSQL = dto.opciones().stream()
                .map(op -> """
            prc_agregar_opcion_respuesta(
              v_pregunta_id,
              '%s',
              '%d'
            );
            """.formatted(
                                escapeSql(op.texto()),
                                op.ordenCorrecto()
                        )
                ).collect(Collectors.joining("\n"));

        String plsql = """
        DECLARE
          v_pregunta_id NUMBER;
        BEGIN
          -- Crear pregunta tipo ORDENAR
          prc_crear_pregunta_banco(
            p_enunciado => '%s',
            p_tipo_pregunta_id => %d,
            p_respuesta_correcta => NULL,
            p_respuesta_correcta_opcion_id => NULL,
            p_es_publica => '%s',
            p_dificultad => '%s',
            p_usuario_id => %d,
            p_tema_id => %d,
            p_id_out => v_pregunta_id
          );

          -- Insertar opciones con su orden
          %s

          COMMIT;
        END;
        """.formatted(
                escapeSql(dto.enunciado()),
                dto.tipoPreguntaId(),
                dto.esPublica() ? "S" : "N",
                escapeSql(dto.dificultad()),
                dto.usuarioId(),
                dto.temaId(),
                opcionesPLSQL
        );

        jdbcTemplate.execute(plsql);
    }

    public void crearPreguntaEmparejar(PreguntaEmparejarDTO dto) {
        String paresPLSQL = dto.pares().stream()
                .map(par -> """
            prc_agregar_par_emparejamiento(
              v_pregunta_id,
              '%s',
              '%s',
              '%s'
            );
            """.formatted(
                                escapeSql(par.izquierda()),
                                escapeSql(par.derecha()),
                                escapeSql(par.letra())
                        )
                ).collect(Collectors.joining("\n"));

        String plsql = """
        DECLARE
          v_pregunta_id NUMBER;
        BEGIN
          -- Crear pregunta tipo EMPAREJAR
          prc_crear_pregunta_banco(
            p_enunciado => '%s',
            p_tipo_pregunta_id => %d,
            p_respuesta_correcta => NULL,
            p_respuesta_correcta_opcion_id => NULL,
            p_es_publica => '%s',
            p_dificultad => '%s',
            p_usuario_id => %d,
            p_tema_id => %d,
            p_id_out => v_pregunta_id
          );

          -- Insertar pares de emparejamiento
          %s

          COMMIT;
        END;
        """.formatted(
                escapeSql(dto.enunciado()),
                dto.tipoPreguntaId(),
                dto.esPublica() ? "S" : "N",
                escapeSql(dto.dificultad()),
                dto.usuarioId(),
                dto.temaId(),
                paresPLSQL
        );

        jdbcTemplate.execute(plsql);
    }

    private String escapeSql(String input) {
        return input.replace("'", "''");
    }

}
