-- ==========================================
-- Poblar tabla ROL
-- ==========================================
INSERT INTO rol (nombre) VALUES ('ADMIN');
INSERT INTO rol (nombre) VALUES ('DOCENTE');
INSERT INTO rol (nombre) VALUES ('ESTUDIANTE');

-- ==========================================
-- Poblar tabla USUARIO (el trigger asignará el rol automáticamente)
-- ==========================================
-- 15 estudiantes
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Carlos Esteban', 'carlos1@estudiante.com', 'pass1', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Lucía Ramírez', 'lucia2@estudiante.com', 'pass2', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Mateo Torres', 'mateo3@estudiante.com', 'pass3', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Valentina Ruiz', 'valen4@estudiante.com', 'pass4', 'PENDIENTE');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Samuel Gómez', 'samuel5@estudiante.com', 'pass5', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Daniela López', 'daniela6@estudiante.com', 'pass6', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Santiago Ortiz', 'santi7@estudiante.com', 'pass7', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Mariana Cruz', 'mariana8@estudiante.com', 'pass8', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Felipe Salazar', 'felipe9@estudiante.com', 'pass9', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Isabella Moreno', 'isa10@estudiante.com', 'pass10', 'PENDIENTE');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Julián Rojas', 'julian11@estudiante.com', 'pass11', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Camila Rivera', 'camila12@estudiante.com', 'pass12', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Tomás Peña', 'tomas13@estudiante.com', 'pass13', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Sara Herrera', 'sara14@estudiante.com', 'pass14', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Sebastián Castillo', 'sebas15@estudiante.com', 'pass15', 'ACTIVO');

-- 15 docentes
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Laura Gómez', 'laura1@docente.com', 'pass16', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Jorge Díaz', 'jorge2@docente.com', 'pass17', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Natalia Ruiz', 'natalia3@docente.com', 'pass18', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Pedro Ríos', 'pedro4@docente.com', 'pass19', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Carolina Vélez', 'caro5@docente.com', 'pass20', 'PENDIENTE');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Ricardo Mejía', 'ricky6@docente.com', 'pass21', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Ana Páez', 'ana7@docente.com', 'pass22', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Diego Castro', 'diego8@docente.com', 'pass23', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Viviana Torres', 'viviana9@docente.com', 'pass24', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Esteban Pardo', 'esteban10@docente.com', 'pass25', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Paula Molina', 'paula11@docente.com', 'pass26', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Oscar Ramírez', 'oscar12@docente.com', 'pass27', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Ximena Castaño', 'ximena13@docente.com', 'pass28', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Andrés Lara', 'andres14@docente.com', 'pass29', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Tatiana López', 'tati15@docente.com', 'pass30', 'ACTIVO');

-- 10 administradores
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Admin1', 'admin1@admin.com', 'adminpass1', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Admin2', 'admin2@admin.com', 'adminpass2', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Admin3', 'admin3@admin.com', 'adminpass3', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Admin4', 'admin4@admin.com', 'adminpass4', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Admin5', 'admin5@admin.com', 'adminpass5', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Admin6', 'admin6@admin.com', 'adminpass6', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Admin7', 'admin7@admin.com', 'adminpass7', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Admin8', 'admin8@admin.com', 'adminpass8', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Admin9', 'admin9@admin.com', 'adminpass9', 'ACTIVO');
INSERT INTO usuario (nombre, correo, contrasenia, estado)
VALUES ('Admin10', 'admin10@admin.com', 'adminpass10', 'ACTIVO');

-- ==========================================
-- Confirmar los cambios
-- ==========================================
COMMIT;
