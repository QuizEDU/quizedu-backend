package co.edu.quizedu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ConexionController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/conexion")
    public String verificarConexion() {
        return jdbcTemplate.queryForObject("SELECT 'OK Oracle' FROM dual", String.class);
    }
}