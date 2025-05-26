-- Asegúrate de que la tabla 'tarjetas' tenga una columna 'estado'
ALTER TABLE tarjetas ADD COLUMN IF NOT EXISTS estado VARCHAR(50) DEFAULT 'activa';

-- Asegúrate de que la tabla 'viajes' tenga un campo para identificar el dispositivo que lo validó
ALTER TABLE viajes ADD COLUMN IF NOT EXISTS id_dispositivo_validador INT;