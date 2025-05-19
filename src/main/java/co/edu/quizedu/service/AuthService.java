package co.edu.quizedu.service;

import co.edu.quizedu.dtos.LoginRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;
import java.sql.SQLException;

import co.edu.quizedu.dtos.AuthResponse;
import co.edu.quizedu.dtos.RegistroRequest;

import javax.sql.DataSource;

@Service
public class AuthService {

    @Autowired
    private DataSource dataSource;
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public AuthResponse registrarYLoguear(RegistroRequest request) {
        try (Connection con = dataSource.getConnection()) {
            CallableStatement cs = con.prepareCall("{ call SYSTEM.PRC_REGISTRAR_Y_LOGUEAR_USUARIO(?, ?, ?, ?) }");
            cs.setString(1, request.nombre());
            cs.setString(2, request.correo());
            cs.setString(3, request.contrasenia());
            cs.registerOutParameter(4, Types.VARCHAR);

            cs.execute();

            String token = cs.getString(4);
            if ("CORREO_EXISTENTE".equals(token)) {
                return new AuthResponse("CORREO_EXISTENTE", null);
            }
            return new AuthResponse("OK", token);

        } catch (SQLException e) {
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
            return new AuthResponse("ERROR", null);
        }
    }

    public AuthResponse iniciarSesion(LoginRequest request) {
        try (Connection con = dataSource.getConnection()) {
            CallableStatement cs = con.prepareCall("{ call prc_iniciar_sesion_usuario(?, ?, ?) }");
            cs.setString(1, request.correo());
            cs.setString(2, request.contrasenia());
            cs.registerOutParameter(3, Types.VARCHAR);
            cs.execute();

            String token = cs.getString(3);
            if ("LOGIN_INVALIDO".equals(token)) {
                return new AuthResponse("LOGIN_INVALIDO", null);
            }
            return new AuthResponse("OK", token);

        } catch (SQLException e) {
            return new AuthResponse("ERROR", null);
        }
    }

}
