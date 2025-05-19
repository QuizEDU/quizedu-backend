package co.edu.quizedu.controller;

import co.edu.quizedu.dtos.AuthResponse;
import co.edu.quizedu.dtos.LoginRequest;
import co.edu.quizedu.dtos.RegistroRequest;
import co.edu.quizedu.service.AuthService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> registrar(@RequestBody RegistroRequest request) {
        AuthResponse response = authService.registrarYLoguear(request);
        return switch (response.resultado()) {
            case "OK" -> ResponseEntity.ok(response);
            case "CORREO_EXISTENTE" -> ResponseEntity.status(HttpStatus.CONFLICT).body(response);
            default -> ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        };
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        AuthResponse response = authService.iniciarSesion(request);
        return switch (response.resultado()) {
            case "OK" -> ResponseEntity.ok(response);
            case "LOGIN_INVALIDO" -> ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            default -> ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        };
    }
}
