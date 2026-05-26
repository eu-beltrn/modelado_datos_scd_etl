
-- CREACIÓN DE LA BASE DE DATOS
-- =========================================================

CREATE DATABASE IF NOT EXISTS scd_db;
USE scd_db;

-- =========================================================
-- DIMENSIÓN EMPLEADOS (SCD TIPO 1) — NICOLE
-- =========================================================

CREATE TABLE IF NOT EXISTS dim_empleados (
    id_empleado INT PRIMARY KEY,
    nombre_empleado VARCHAR(100),
    departamento VARCHAR(100),
    sede VARCHAR(100)
);

INSERT INTO dim_empleados (
    id_empleado,
    nombre_empleado,
    departamento,
    sede
)
VALUES
(1, 'Juan Pérez', 'Ventas', 'San Salvador'),
(2, 'Ana López', 'Recursos Humanos', 'Santa Ana'),
(3, 'Luis Martínez', 'Finanzas', 'Sonsonate'),
(4, 'María Gómez', 'Marketing', 'La Libertad'),
(5, 'Carlos Rivera', 'IT', 'San Miguel')
ON DUPLICATE KEY UPDATE id_empleado = id_empleado;

SELECT * FROM dim_empleados;

-- =========================================================
-- HISTORIAL DEPARTAMENTOS (SCD TIPO 2) — JONATHAN
-- =========================================================

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

SELECT * FROM historial_departamentos;

-- =========================================================
-- HISTORIAL SALARIOS (SCD TIPO 3) — EUNICE
-- =========================================================

CREATE TABLE historial_salarios (
    id_empleado INT PRIMARY KEY,
    nombre_empleado VARCHAR(100),
    salario_anterior DECIMAL(10,2),
    salario_actual DECIMAL(10,2),
    fecha_cambio DATE,

    FOREIGN KEY (id_empleado)
    REFERENCES dim_empleados(id_empleado)
);

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

SELECT * FROM historial_salarios;

-- =========================================================
-- IMPLEMENTACIÓN SCD TIPO 1 — NICOLE
-- =========================================================

USE scd_db;

UPDATE dim_empleados
SET departamento = 'Operaciones'
WHERE id_empleado = 2;

SELECT
    id_empleado,
    nombre_empleado,
    departamento,
    sede
FROM dim_empleados
WHERE id_empleado = 2;

-- =========================================================
-- IMPLEMENTACIÓN SCD TIPO 2 — JONATHAN
-- =========================================================

USE scd_db;

UPDATE historial_departamentos
SET fecha_fin = CURRENT_DATE,
    activo = FALSE
WHERE id_empleado = 1
AND activo = TRUE;

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

SELECT *
FROM historial_departamentos
WHERE id_empleado = 1;

-- =========================================================
-- IMPLEMENTACIÓN SCD TIPO 3 — EUNICE
-- =========================================================

UPDATE historial_salarios
SET salario_anterior = salario_actual,
    salario_actual = 1200.00,
    fecha_cambio = CURRENT_DATE
WHERE id_empleado = 1;

SELECT * FROM historial_salarios;

-- =========================================================
-- SIMULACIÓN DE CAMBIOS DE DEPARTAMENTO — JONATHAN
-- =========================================================

UPDATE historial_departamentos
SET fecha_fin = CURRENT_DATE,
    activo = FALSE
WHERE id_empleado = 1
AND activo = TRUE;

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

SELECT *
FROM historial_departamentos
WHERE id_empleado = 1;

-- =========================================================
-- SIMULACIÓN DE AUMENTOS SALARIALES — EUNICE
-- =========================================================

UPDATE historial_salarios
SET salario_anterior = salario_actual,
    salario_actual = 1000,
    fecha_cambio = CURRENT_DATE
WHERE id_empleado = 2;

UPDATE historial_salarios
SET salario_anterior = salario_actual,
    salario_actual = 2000,
    fecha_cambio = CURRENT_DATE
WHERE id_empleado = 3;

SELECT * FROM historial_salarios;

-- =========================================================
-- SIMULACIÓN DE CAMBIOS DE SEDE — NICOLE
-- =========================================================

USE scd_db;

UPDATE dim_empleados
SET sede = 'San Miguel'
WHERE id_empleado = 1;

SELECT
    id_empleado,
    nombre_empleado,
    departamento,
    sede
FROM dim_empleados;

-- =========================================================
-- ANÁLISIS HISTÓRICO DE DEPARTAMENTOS — JONATHAN
-- =========================================================

SELECT
    id_empleado,
    departamento,
    fecha_inicio,
    fecha_fin,
    activo
FROM historial_departamentos
ORDER BY id_empleado, fecha_inicio;

SELECT
    id_empleado,
    departamento,
    fecha_inicio
FROM historial_departamentos
WHERE activo = TRUE;

SELECT
    id_empleado,
    departamento,
    fecha_inicio,
    fecha_fin
FROM historial_departamentos
WHERE activo = FALSE;

-- =========================================================
-- ANÁLISIS DE EVOLUCIÓN SALARIAL — EUNICE
-- =========================================================

SELECT
    nombre_empleado,
    salario_anterior,
    salario_actual,
    (salario_actual - salario_anterior) AS aumento
FROM historial_salarios
WHERE salario_anterior IS NOT NULL;

-- =========================================================
-- ANÁLISIS DE CAMBIOS DE SEDE — NICOLE
-- =========================================================

USE scd_db;

SELECT
    id_empleado,
    nombre_empleado,
    departamento,
    sede
FROM dim_empleados;