-- ============================================================================
-- CAPA DE STAGING / RAW
-- ============================================================================
CREATE DATABASE IF NOT EXISTS enterprise_datawarehouse;
USE enterprise_datawarehouse;

DROP TABLE IF EXISTS raw_ventas;
DROP TABLE IF EXISTS raw_clientes;
DROP TABLE IF EXISTS raw_productos;
DROP TABLE IF EXISTS raw_empleados;

CREATE TABLE raw_clientes (
    cliente_id INT NOT NULL,
    nombre_enmascarado VARCHAR(255) NOT NULL,
    ciudad VARCHAR(150) NOT NULL,
    edad INT NOT NULL,
    fecha_extraccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (cliente_id, fecha_extraccion)
) ENGINE=InnoDB;

CREATE TABLE raw_productos (
    producto_id INT NOT NULL,
    producto VARCHAR(150) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    precio_entero INT NOT NULL,
    fecha_extraccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (producto_id, fecha_extraccion)
) ENGINE=InnoDB;

CREATE TABLE raw_empleados (
    empleado_id INT NOT NULL,
    nombre_enmascarado VARCHAR(255) NOT NULL,
    departamento VARCHAR(100) NOT NULL,
    salario_entero INT NOT NULL,
    fecha_extraccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (empleado_id, fecha_extraccion)
) ENGINE=InnoDB;

CREATE TABLE raw_ventas (
    venta_id INT NOT NULL,
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    empleado_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_aplicado INT NOT NULL,
    descuento_aplicado INT NOT NULL,
    total_entero INT NOT NULL,
    fecha_venta DATE NOT NULL,
    fecha_extraccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (venta_id)
) ENGINE=InnoDB;