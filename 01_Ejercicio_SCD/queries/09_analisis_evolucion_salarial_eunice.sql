-- =========================================================
-- TÍTULO DEL NOTEBOOK:
-- 9. Análisis de Resultados — Eunice
-- (Evolución Salarial)
-- =========================================================

-- RESPONSABLE: Eunice

-- PROPÓSITO:
-- Analizar cambios en la evolución salarial.

-- PROCESO GENERAL:
-- - Consultar historial salarial
-- - Comparar valores antiguos y actuales
-- - Generar análisis de evolución

-- CONTENIDO A IMPLEMENTAR:
-- - Consultas SELECT de análisis
-- - Comparación de registros

-- VERIFICACIÓN:
-- - Visualización de evolución salarial

SELECT 
    nombre_empleado,
    salario_anterior,
    salario_actual,
    (salario_actual - salario_anterior) AS aumento
FROM historial_salarios
WHERE salario_anterior IS NOT NULL;