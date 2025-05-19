SELECT u.id,
       u.nombre,
       u.correo,
       u.estado,
       r.nombre AS rol
FROM usuario u
JOIN usuario_rol ur ON u.id = ur.id_usuario
JOIN rol r ON ur.id_rol = r.id
WHERE u.CORREO = 'afva@docente.com'
ORDER BY r.nombre, u.nombre;
