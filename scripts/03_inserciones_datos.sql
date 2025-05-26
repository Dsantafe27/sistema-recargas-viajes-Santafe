-- 1. Insertar 150 registros en auditoria_estado_tarjeta
-- Solo si hay tarjetas creadas
INSERT INTO auditoria_estado_tarjeta (id_tarjeta, estado_anterior, estado_nuevo, usuario_que_cambia)
SELECT 
    floor(random() * 100 + 1)::INT,
    CASE WHEN random() > 0.5 THEN 'activa' ELSE 'bloqueada' END,
    CASE WHEN random() > 0.5 THEN 'bloqueada' ELSE 'activa' END,
    'admin'
FROM GENERATE_SERIES(1, 150)
WHERE EXISTS (SELECT 1 FROM tarjetas LIMIT 1);

-- 2. Insertar promociones
INSERT INTO promocion (nombre, descripcion, fecha_inicio, fecha_fin)
SELECT *
FROM (
    VALUES
    ('Promo Verano', 'Recarga doble puntos', '2025-01-01'::DATE, '2025-03-31'::DATE),
    ('Bonus Especial', 'Bono de puntos extra', '2025-02-01'::DATE, '2025-02-28'::DATE),
    ('Black Friday', 'Descuento especial', '2025-11-25'::DATE, '2025-11-27'::DATE)
) AS data(nombre, descripcion, fecha_inicio, fecha_fin)
WHERE NOT EXISTS (SELECT 1 FROM promocion WHERE nombre = data.nombre);

-- 3. Insertar relaciones entre recargas y promociones
INSERT INTO recarga_promocion (id_recarga, id_promocion)
SELECT r.recarga_id, p.id_promocion
FROM (
    SELECT recarga_id, ROW_NUMBER() OVER () AS rn 
    FROM recargas 
    ORDER BY recarga_id 
    LIMIT 100
) r
JOIN (
    SELECT id_promocion, ROW_NUMBER() OVER () AS rn 
    FROM promocion 
    ORDER BY id_promocion 
    LIMIT 100
) p ON r.rn = p.rn
ON CONFLICT DO NOTHING;

-- 4. Insertar dispositivos validadores
INSERT INTO dispositivo_validador (tipo_dispositivo, ubicacion, estado, fecha_instalacion)
SELECT 
    CASE (random() * 2)::INT
        WHEN 0 THEN 'torniquete'
        WHEN 1 THEN 'validador movil'
        WHEN 2 THEN 'app'
    END,
    'Ubicación ' || i,
    'activo',
    NOW() - (random() * INTERVAL '365 days')
FROM GENERATE_SERIES(1, 20) AS i;

-- 5. Insertar patrones de viaje frecuente
INSERT INTO viaje_frecuente (id_usuario, dia_semana, hora, cantidad)
SELECT 
    FLOOR(RANDOM() * 100 + 1)::INT,
    CASE (RANDOM() * 6)::INT
        WHEN 0 THEN 'lunes'
        WHEN 1 THEN 'martes'
        WHEN 2 THEN 'miércoles'
        WHEN 3 THEN 'jueves'
        WHEN 4 THEN 'viernes'
        WHEN 5 THEN 'sábado'
        WHEN 6 THEN 'domingo'
    END,
    MAKE_TIME(FLOOR(RANDOM() * 24)::INT, FLOOR(RANDOM() * 60)::INT, 0),
    1
FROM GENERATE_SERIES(1, 100) AS i
WHERE EXISTS (SELECT 1 FROM usuarios LIMIT 1);