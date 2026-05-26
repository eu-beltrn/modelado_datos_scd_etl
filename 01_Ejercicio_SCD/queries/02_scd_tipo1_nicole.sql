-- =========================================================
-- TÍTULO DEL NOTEBOOK:
-- 2. Implementación SCD Tipo 1 — Nicole
-- =========================================================

-- RESPONSABLE: Nicole

-- PROPÓSITO:
-- Implementar sobrescritura de datos sin mantener historial.

-- PROCESO GENERAL:
-- - Actualizar registros existentes
-- - Sobrescribir información anterior
-- - No conservar versiones históricas

-- CONTENIDO A IMPLEMENTAR:
-- - UPDATE de datos existentes
-- - Modificación directa de atributos

-- VERIFICACIÓN:
-- - Consultar tabla completa
-- - Validar cambios realizados

USE scd_db;

-- Validamos que los 5 empleados oficiales existan en la tabla original
SELECT id_empleado, nombre_empleado, departamento, sede 
FROM dim_empleados;
