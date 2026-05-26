-- =========================================================
-- TÍTULO DEL NOTEBOOK:
-- 8. Simulación de Cambios Organizacionales — Eunice
-- (Aumentos Salariales)
-- =========================================================

-- RESPONSABLE: Eunice

-- PROPÓSITO:
-- Simular incrementos salariales en empleados.

-- PROCESO GENERAL:
-- - Actualizar salario actual
-- - Guardar salario anterior
-- - Analizar evolución salarial

-- CONTENIDO A IMPLEMENTAR:
-- - UPDATE de salarios
-- - Registro de valores anteriores
-- - Aplicación de lógica SCD Tipo 3 o similar
-- Aumentar salario a la empleada Ana López a 1000
UPDATE historial_salarios
SET salario_anterior = salario_actual,
	salario_actual = 1000,
    fecha_cambio = CURRENT_DATE
WHERE id_empleado = 2;
    
-- Aumentar salario al empleado Luis Martinez a 2000
UPDATE historial_salarios
SET salario_anterior = salario_actual,
	salario_actual = 2000,
    fecha_cambio = CURRENT_DATE
WHERE id_empleado = 3;
-- VERIFICACIÓN:
-- - Consultar historial de salarios
SELECT * FROM historial_salarios;