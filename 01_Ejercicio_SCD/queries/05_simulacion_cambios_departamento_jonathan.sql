-- =========================================================
-- TÍTULO DEL NOTEBOOK:
-- 8. Simulación de Cambios Organizacionales — Jonathan
-- (Cambios de Departamento)
-- =========================================================

-- RESPONSABLE: Jonathan

-- PROPÓSITO:
-- Simular cambios reales de departamento en empleados
-- utilizando SCD Tipo 2.

-- PROCESO GENERAL:
-- - Ejecutar cambios de departamento
-- - Activar comportamiento SCD Tipo 2
-- - Generar nuevos registros históricos
-- - Mantener trazabilidad organizacional

-- =========================================================
-- SIMULACIÓN DE CAMBIO DE DEPARTAMENTO
-- =========================================================
-- El empleado cambia del departamento Ventas al departamento IT

-- =========================================================
-- UPDATE DEL REGISTRO ANTERIOR
-- =========================================================
-- Se cierra el registro activo anterior

UPDATE historial_departamentos
SET fecha_fin = CURRENT_DATE,
    activo = FALSE
WHERE id_empleado = 1
AND activo = TRUE;

-- =========================================================
-- INSERT DEL NUEVO REGISTRO HISTÓRICO
-- =========================================================
-- Se registra el nuevo departamento del empleado

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
-- CONSULTA DE VERIFICACIÓN
-- =========================================================
-- Mostrar historial completo del empleado

SELECT *
FROM historial_departamentos
WHERE id_empleado = 1;

-- =========================================================
-- RESULTADO ESPERADO:
-- - El registro anterior queda inactivo
-- - El nuevo departamento queda activo
-- - Se conserva el historial completo
-- - El empleado posee múltiples registros históricos
-- =========================================================