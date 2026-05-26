-- ============================================================================
-- CAPA DE PRESENTACIÓN (Ingeniero de Presentación / QA)
-- ============================================================================
USE enterprise_datawarehouse;

CREATE OR REPLACE VIEW v_kpi_rendimiento_negocio AS
SELECT 
    t.anio AS Anio,
    t.mes_nombre AS Mes,
    p.categoria AS Categoria_Producto,
    e.departamento AS Departamento_Vendedor,
    SUM(f.cantidad) AS Unidades_Vendidas,
    SUM(f.total) AS Ingresos_Totales_Enteros, 
    SUM(f.descuento) AS Descuentos_Concedidos_Enteros,
    COUNT(DISTINCT f.venta_id) AS Volumen_Transacciones
FROM fact_ventas f
INNER JOIN dim_tiempo t ON f.tiempo_key = t.tiempo_key
INNER JOIN dim_productos p ON f.producto_key = p.producto_key
INNER JOIN dim_empleados e ON f.empleado_key = e.empleado_key
INNER JOIN dim_clientes c ON f.cliente_key = c.cliente_key
GROUP BY t.anio, t.mes, t.mes_nombre, p.categoria, e.departamento;

CREATE OR REPLACE VIEW v_ranking_top_vendedores AS
SELECT 
    e.nombre AS Nombre_Empleado,
    e.departamento AS Departamento,
    SUM(f.total) AS Venta_Acumulada_Entera,
    RANK() OVER (PARTITION BY e.departamento ORDER BY SUM(f.total) DESC) AS Ranking_En_Departamento
FROM fact_ventas f
INNER JOIN dim_empleados e ON f.empleado_key = e.empleado_key
WHERE e.registro_activo = 1 
GROUP BY e.empleado_id, e.nombre, e.departamento;