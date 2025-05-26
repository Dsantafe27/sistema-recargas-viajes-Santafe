-- 1. Auditoría del estado de las tarjetas
CREATE TABLE IF NOT EXISTS auditoria_estado_tarjeta (
    id_auditoria SERIAL PRIMARY KEY,
    id_tarjeta INT NOT NULL,
    estado_anterior VARCHAR(50),
    estado_nuevo VARCHAR(50) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_que_cambia VARCHAR(100),
    FOREIGN KEY (id_tarjeta) REFERENCES tarjetas(tarjeta_id)
);

-- Índices para auditoría
CREATE INDEX IF NOT EXISTS idx_fecha_cambio ON auditoria_estado_tarjeta(fecha_cambio);
CREATE INDEX IF NOT EXISTS idx_id_tarjeta ON auditoria_estado_tarjeta(id_tarjeta);

-- 2. Tabla promocion
CREATE TABLE IF NOT EXISTS promocion (
    id_promocion SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE
);

-- 3. Tabla intermedia recarga_promocion
CREATE TABLE IF NOT EXISTS recarga_promocion (
    id_recarga INT NOT NULL,
    id_promocion INT NOT NULL,
    PRIMARY KEY (id_recarga, id_promocion),
    FOREIGN KEY (id_recarga) REFERENCES recargas(recarga_id),
    FOREIGN KEY (id_promocion) REFERENCES promocion(id_promocion)
);

-- 4. Tabla dispositivo_validador
CREATE TABLE IF NOT EXISTS dispositivo_validador (
    id_dispositivo SERIAL PRIMARY KEY,
    tipo_dispositivo VARCHAR(50) CHECK (tipo_dispositivo IN ('torniquete', 'validador movil', 'app')),
    ubicacion VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'activo',
    fecha_instalacion DATE
);

-- 5. Mejora adicional: viaje_frecuente
CREATE TABLE IF NOT EXISTS viaje_frecuente (
    id_usuario INT NOT NULL,
    dia_semana VARCHAR(10),
    hora TIME,
    cantidad INT DEFAULT 1,
    PRIMARY KEY (id_usuario, dia_semana, hora),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(usuario_id)
);