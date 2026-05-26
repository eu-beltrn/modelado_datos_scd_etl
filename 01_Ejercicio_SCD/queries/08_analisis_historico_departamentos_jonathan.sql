-- =========================================================
-- TÍTULO DEL NOTEBOOK:
-- 9. Análisis de Resultados — Jonathan
-- (Diferencias Históricas)
-- =========================================================

-- RESPONSABLE: Jonathan

-- PROPÓSITO:
-- Analizar cambios históricos de departamentos utilizando
-- SCD Tipo 2.

-- PROCESO GENERAL:
-- - Consultar historial de cambios
-- - Comparar registros por fechas
-- - Identificar evolución organizacional
-- - Verificar conservación histórica

-- =========================================================
-- CONSULTA DE ANÁLISIS HISTÓRICO
-- =========================================================
-- Mostrar historial completo de departamentos

SELECT
    id_empleado,
    departamento,
    fecha_inicio,
    fecha_fin,
    activo
FROM historial_departamentos
ORDER BY id_empleado, fecha_inicio;

-- =========================================================
-- CONSULTA DE REGISTROS ACTIVOS
-- =========================================================
-- Mostrar departamentos actuales

SELECT
    id_empleado,
    departamento,
    fecha_inicio
FROM historial_departamentos
WHERE activo = TRUE;

-- =========================================================
-- CONSULTA DE REGISTROS HISTÓRICOS
-- =========================================================
-- Mostrar departamentos anteriores

SELECT
    id_empleado,
    departamento,
    fecha_inicio,
    fecha_fin
FROM historial_departamentos
WHERE activo = FALSE;

-- =========================================================
-- RESULTADO ESPERADO:
-- - Visualizar historial completo
-- - Identificar departamentos anteriores y actuales
-- - Comparar cambios organizacionales
-- - Verificar trazabilidad histórica
-- =========================================================