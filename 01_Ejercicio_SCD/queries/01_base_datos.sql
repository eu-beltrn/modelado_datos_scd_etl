-- =========================================================
-- TÍTULO DEL NOTEBOOK:
-- 1. Creación de la Base de Datos — Todos los integrantes
-- =========================================================

-- RESPONSABLE: Todos

-- PROPÓSITO:
-- Crear la base de datos principal del sistema SCD y seleccionar su uso.

-- PROCESO GENERAL:
-- - Crear base de datos
-- - Seleccionar base de datos activa
-- - Base para todas las tablas del proyecto

-- CONTENIDO A IMPLEMENTAR:
-- - CREATE DATABASE
-- - USE DATABASE
-- - Preparación general del entorno

-- CREACION DE LA BASE DE DATOS:
CREATE DATABASE IF NOT EXISTS scd_db;

-- SELECCIÓN DE LA BASE DE DATOS:
USE scd_db;

-- Preparación general del entorno
-- DIMENSION EMPLEADOS - NICOLE
-- SCD tipo 1

-- Creacion de tabla
CREATE TABLE IF NOT EXISTS dim_empleados (
    id_empleado INT PRIMARY KEY,
    nombre_empleado VARCHAR(100),
    departamento VARCHAR(100),
    sede VARCHAR(100)
);

-- Inserción de los 5 registros iniciales 
INSERT INTO dim_empleados (id_empleado, nombre_empleado, departamento, sede)
VALUES
(1, 'Juan Pérez', 'Ventas', 'San Salvador'),
(2, 'Ana López', 'Recursos Humanos', 'Santa Ana'),
(3, 'Luis Martínez', 'Finanzas', 'Sonsonate'),
(4, 'María Gómez', 'Marketing', 'La Libertad'),
(5, 'Carlos Rivera', 'IT', 'San Miguel')
ON DUPLICATE KEY UPDATE id_empleado = id_empleado;

-- Muestra los datos en pantalla al ejecutar el archivo general
SELECT * FROM dim_empleados;


-- HISTORIAL DEPARTAMENTOS -JONATHAN
-- SCD tipo 2

-- creación de la tabla
CREATE TABLE historial_departamentos (
    id_historial_departamento INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT,
    departamento VARCHAR(100),
    fecha_inicio DATE,
    fecha_fin DATE,
    activo BOOLEAN,
    
    FOREIGN KEY (id_empleado)
    REFERENCES dim_empleados(id_empleado)
);

-- Inserts de 5 Registros iniciales de departamentos
INSERT INTO historial_departamentos (
    id_empleado,
    departamento,
    fecha_inicio,
    fecha_fin,
    activo
)
VALUES
(1, 'Ventas', '2025-01-01', NULL, TRUE),
(2, 'Recursos Humanos', '2025-01-01', NULL, TRUE),
(3, 'Finanzas', '2025-01-01', NULL, TRUE),
(4, 'Marketing', '2025-01-01', NULL, TRUE),
(5, 'IT', '2025-01-01', NULL, TRUE);

-- HISTORIAL SALARIOS - EUNICE
-- SCD tipo 3
-- Crear tabla
CREATE TABLE historial_salarios (
    id_empleado INT PRIMARY KEY,
    nombre_empleado VARCHAR(100),
    salario_anterior DECIMAL(10,2),
    salario_actual DECIMAL(10,2),
    fecha_cambio DATE
);

-- Inserts de 5 Registros
INSERT INTO historial_salarios (
    id_empleado,
    nombre_empleado,
    salario_anterior,
    salario_actual,
    fecha_cambio
)
VALUES
(1, 'Juan Pérez', NULL, 800.00, '2025-01-01'),
(2, 'Ana López', NULL, 950.00, '2025-01-01'),
(3, 'Luis Martínez', NULL, 1100.00, '2025-01-01'),
(4, 'María Gómez', NULL, 1000.00, '2025-01-01'),
(5, 'Carlos Rivera', NULL, 1200.00, '2025-01-01');


-- CONSULTA DE VERIFICACIÓN:
-- - Validar que la base de datos fue creada correctamente

-- DIMENSION EMPLEADOS - NICOLE
SELECT * FROM dim_empleados;

-- HISTORIAL DEPARTAMENTOS -JONATHAN
SELECT * FROM historial_departamentos;

-- HISTORIAL SALARIOS - EUNICE
SELECT * FROM historial_salarios;