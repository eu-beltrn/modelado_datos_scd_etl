-- =========================================================
-- TÍTULO DEL NOTEBOOK:
-- 3. Implementación SCD Tipo 2 — Jonathan
-- =========================================================

-- RESPONSABLE: Jonathan

-- PROPÓSITO:
-- Mantener historial completo de cambios en los datos.

-- PROCESO GENERAL:
-- - Cerrar registros anteriores
-- - Insertar nuevos registros históricos
-- - Mantener trazabilidad completa

-- CONTENIDO A IMPLEMENTAR:
-- - UPDATE para cerrar registros activos
-- - INSERT para nuevos estados históricos
-- - Manejo de fechas de vigencia
-- - Control de registros activos/inactivos

-- VERIFICACIÓN:
-- - Consultar historial completo
-- - Validar múltiples registros por entidad