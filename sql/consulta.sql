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


SELECT * FROM plan_estudio;

SELECT u.id, u.nombre, pe.nombre AS plan_estudio
FROM unidad u
JOIN plan_estudio pe ON u.plan_estudio_id = pe.id
ORDER BY plan_estudio, u.nombre;

SELECT c.id, c.nombre, u.nombre AS unidad
FROM contenido c
JOIN unidad u ON c.unidad_id = u.id
ORDER BY unidad, c.nombre;

SELECT t.id, t.nombre AS tema, c.nombre AS contenido
FROM tema t
JOIN contenido c ON t.contenido_id = c.id
ORDER BY contenido, t.nombre;

SELECT c.nombre AS contenido, COUNT(t.id) AS total_temas
FROM contenido c
LEFT JOIN tema t ON t.contenido_id = c.id
GROUP BY c.nombre
ORDER BY total_temas DESC;

SELECT 
  pe.nombre AS plan_estudio,
  u.nombre AS unidad,
  c.nombre AS contenido,
  t.nombre AS tema
FROM tema t
JOIN contenido c ON t.contenido_id = c.id
JOIN unidad u ON c.unidad_id = u.id
JOIN plan_estudio pe ON u.plan_estudio_id = pe.id
ORDER BY pe.nombre, u.nombre, c.nombre, t.nombre;


SELECT 
  t.id AS tema_id,
  t.nombre AS tema,
  c.nombre AS contenido,
  u.nombre AS unidad,
  pe.nombre AS plan_estudio
FROM tema t
JOIN contenido c ON t.contenido_id = c.id
JOIN unidad u ON c.unidad_id = u.id
JOIN plan_estudio pe ON u.plan_estudio_id = pe.id
ORDER BY t.id;
