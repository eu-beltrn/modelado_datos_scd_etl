-- ============================================================================
-- 8. Implementación SCD Tipo 1 (Cambio de Departamento) — Nicole
-- ============================================================================
USE scd_db;

-- 1. Aplicamos el cambio directo sobre el registro de Ana López
UPDATE dim_empleados
SET departamento = 'Operaciones'
WHERE id_empleado = 2;

-- 2. Consulta de verificación inmediata para validar el cambio realizado
SELECT id_empleado, nombre_empleado, departamento, sede 
FROM dim_empleados 
WHERE id_empleado = 2;