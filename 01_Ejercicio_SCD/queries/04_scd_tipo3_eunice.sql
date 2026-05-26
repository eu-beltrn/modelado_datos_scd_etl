-- =========================================================
-- TÍTULO DEL NOTEBOOK:
-- 4. Implementación SCD Tipo 3 — Eunice
-- =========================================================

-- RESPONSABLE: Eunice

-- PROPÓSITO:
-- Guardar el valor actual y un valor histórico limitado.

-- PROCESO GENERAL:
-- - Actualizar valor actual
-- - Guardar valor anterior en columna adicional
-- - Mantener historial parcial

-- CONTENIDO A IMPLEMENTAR:
-- - UPDATE de valores actuales
-- - Almacenamiento de valores anteriores
-- - Manejo de columnas históricas limitadas

-- Actualizando salario al empleado id=1
UPDATE historial_salarios
SET salario_anterior = salario_actual,
    salario_actual = 1200.00,
    fecha_cambio = CURRENT_DATE
WHERE id_empleado = 1;

-- VERIFICACIÓN:
-- - Consultar valores actuales y anteriores
select * from historial_salarios;