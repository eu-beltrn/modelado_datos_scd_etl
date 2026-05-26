-- =========================================================
-- TÍTULO DEL NOTEBOOK:
-- 3. Implementación SCD Tipo 2 — Jonathan
-- =========================================================

-- RESPONSABLE: Jonathan

-- PROPÓSITO:
-- Mantener historial completo de cambios en los departamentos
-- de los empleados utilizando SCD Tipo 2.

-- PROCESO GENERAL:
-- - Cerrar registros anteriores
-- - Insertar nuevos registros históricos
-- - Mantener trazabilidad completa
-- - Conservar historial de departamentos

-- =========================================================
-- UPDATE DE REGISTRO ANTERIOR
-- =========================================================
-- Cerrar registro activo anterior del empleado

-- Seleccionar bd
use scd_db;
UPDATE historial_departamentos
SET fecha_fin = CURRENT_DATE,
    activo = FALSE
WHERE id_empleado = 1
AND activo = TRUE;

-- =========================================================
-- INSERT DE NUEVO REGISTRO HISTÓRICO
-- =========================================================
-- Insertar nuevo departamento del empleado

INSERT INTO historial_departamentos (
    id_empleado,
    departamento,
    fecha_inicio,
    fecha_fin,
    activo
)
VALUES (
    1,
    'IT',
    CURRENT_DATE,
    NULL,
    TRUE
);

-- =========================================================
-- CONSULTA DE VERIFICACIÓN HISTÓRICA
-- =========================================================
-- Mostrar historial completo del empleado

SELECT *
FROM historial_departamentos
WHERE id_empleado = 1;

-- =========================================================
-- RESULTADO ESPERADO:
-- - El registro anterior debe quedar inactivo
-- - El nuevo registro debe quedar activo
-- - Deben existir múltiples registros históricos
-- - Se debe conservar la trazabilidad de cambios
-- =========================================================        