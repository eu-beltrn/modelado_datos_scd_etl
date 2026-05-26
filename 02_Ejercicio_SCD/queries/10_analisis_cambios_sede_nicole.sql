-- ============================================================================
-- 9. Simulación de Cambios de Sede Organizacionales — Nicole (SCD Tipo 1)
-- ============================================================================
USE scd_db;

-- 1. Actualizamos la sede directa en el registro de Juan Pérez
UPDATE dim_empleados
SET sede = 'San Miguel'
WHERE id_empleado = 1;

-- 2. Consulta de auditoría general para verificar el estado final de toda la tabla
SELECT id_empleado, nombre_empleado, departamento, sede 
FROM dim_empleados;