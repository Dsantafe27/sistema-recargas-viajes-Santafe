-- A. Auditoría del estado de las tarjetas

-- Consulta 1: Cambios de estado por mes durante el último año
SELECT 
    TO_CHAR(fecha_cambio, 'YYYY-MM') AS mes,
    COUNT(*) AS cantidad_cambios
FROM auditoria_estado_tarjeta
WHERE fecha_cambio >= NOW() - INTERVAL '1 year'
GROUP BY mes
ORDER BY mes;

-- Consulta 2: Tarjetas con más cambios de estado
SELECT id_tarjeta, COUNT(*) AS total_cambios
FROM auditoria_estado_tarjeta
GROUP BY id_tarjeta
ORDER BY total_cambios DESC
LIMIT 5;

-- B. Promociones aplicadas en recargas

-- Consulta 3: Recargas con descripción de la promoción aplicada
SELECT r.recarga_id, p.nombre AS promocion, p.descripcion
FROM recargas r
JOIN recarga_promocion rp ON r.recarga_id = rp.id_recarga
JOIN promocion p ON rp.id_promocion = p.id_promocion;

-- Consulta 4: Monto total por promoción (últimos 3 meses)
SELECT p.nombre, SUM(r.monto) AS monto_total
FROM recargas r
JOIN recarga_promocion rp ON r.recarga_id = rp.id_recarga
JOIN promocion p ON rp.id_promocion = p.id_promocion
WHERE r.fecha BETWEEN p.fecha_inicio AND p.fecha_fin
GROUP BY p.nombre
ORDER BY monto_total DESC;

-- Consulta 5: Promociones cuyo nombre contenga "bonus"
SELECT * FROM promocion
WHERE nombre ILIKE '%bonus%';

-- C. Registro de dispositivos de validación

-- Consulta 6: Viajes sin registro de validación
SELECT * FROM viajes
WHERE id_dispositivo_validador IS NULL;

-- Consulta 7: Validaciones realizadas por dispositivos móviles en abril de 2025
SELECT v.*
FROM viajes v
JOIN dispositivo_validador d ON v.id_dispositivo_validador = d.id_dispositivo
WHERE d.tipo_dispositivo = 'validador movil'
  AND EXTRACT(MONTH FROM v.fecha) = 4
  AND EXTRACT(YEAR FROM v.fecha) = 2025;

-- Consulta 8: Dispositivo con mayor cantidad de validaciones
SELECT d.id_dispositivo, d.tipo_dispositivo, COUNT(v.viaje_id) AS total_validaciones
FROM dispositivo_validador d
LEFT JOIN viajes v ON d.id_dispositivo = v.id_dispositivo_validador
GROUP BY d.id_dispositivo, d.tipo_dispositivo
ORDER BY total_validaciones DESC
LIMIT 1;

-- D. Mejora Adicional: Análisis de viajes frecuentes por usuario

-- Consulta 9: Usuarios con viajes frecuentes y detalles
SELECT u.usuario_id, u.nombre, vf.dia_semana, vf.hora, vf.cantidad
FROM viaje_frecuente vf
JOIN usuarios u ON vf.id_usuario = u.usuario_id;

-- Consulta 10: Horarios más comunes de viaje
SELECT hora, COUNT(*) AS usuarios
FROM viaje_frecuente
GROUP BY hora
ORDER BY usuarios DESC;

-- Consulta 11: Días más usados para viajar
SELECT dia_semana, COUNT(*) AS total_usuarios
FROM viaje_frecuente
GROUP BY dia_semana
ORDER BY total_usuarios DESC
LIMIT 5;