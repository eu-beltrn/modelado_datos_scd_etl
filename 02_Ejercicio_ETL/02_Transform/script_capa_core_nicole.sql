-- ============================================================================
-- CAPA DIMENSIONAL / CORE (Ingeniero de Transformación)
-- ============================================================================
USE enterprise_datawarehouse;

DROP TABLE IF EXISTS fact_ventas;
DROP TABLE IF EXISTS dim_clientes;
DROP TABLE IF EXISTS dim_productos;
DROP TABLE IF EXISTS dim_empleados;
DROP TABLE IF EXISTS dim_tiempo;

-- Dimensión Clientes (SCD Tipo 1)
CREATE TABLE dim_clientes (
    cliente_key INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    ciudad VARCHAR(150) NOT NULL,
    edad INT NOT NULL,
    etl_batch_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY idx_cliente_id_unique (cliente_id)
) ENGINE=InnoDB;

-- Dimensión Productos (SCD Tipo 2 preparatorio)
CREATE TABLE dim_productos (
    producto_key INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    producto VARCHAR(150) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    precio INT NOT NULL, 
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    registro_activo TINYINT(1) DEFAULT 1, 
    etl_batch_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_scd_productos (producto_id, registro_activo)
) ENGINE=InnoDB;

-- Dimensión Empleados (SCD Tipo 2 preparatorio)
CREATE TABLE dim_empleados (
    empleado_key INT AUTO_INCREMENT PRIMARY KEY,
    empleado_id INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    departamento VARCHAR(100) NOT NULL,
    salario INT NOT NULL, 
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    registro_activo TINYINT(1) DEFAULT 1,
    etl_batch_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_scd_empleados (empleado_id, registro_activo)
) ENGINE=InnoDB;

-- Dimensión Tiempo
CREATE TABLE dim_tiempo (
    tiempo_key INT PRIMARY KEY, 
    fecha DATE NOT NULL,
    dia INT NOT NULL,
    mes INT NOT NULL,
    mes_nombre VARCHAR(20) NOT NULL,
    anio INT NOT NULL,
    trimestre INT NOT NULL,
    semestre INT NOT NULL,
    UNIQUE KEY idx_fecha_unique (fecha)
) ENGINE=InnoDB;

-- Tabla de Hechos (Fact Table)
CREATE TABLE fact_ventas (
    venta_id INT NOT NULL,
    cliente_key INT NOT NULL,
    producto_key INT NOT NULL,
    empleado_key INT NOT NULL,
    tiempo_key INT NOT NULL,
    cantidad INT NOT NULL,
    precio INT NOT NULL,        
    descuento INT NOT NULL,     
    total INT NOT NULL,         
    etl_batch_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (venta_id),
    CONSTRAINT fk_fact_clientes FOREIGN KEY (cliente_key) REFERENCES dim_clientes (cliente_key),
    CONSTRAINT fk_fact_productos FOREIGN KEY (producto_key) REFERENCES dim_productos (producto_key),
    CONSTRAINT fk_fact_empleados FOREIGN KEY (empleado_key) REFERENCES dim_empleados (empleado_key),
    CONSTRAINT fk_fact_tiempo FOREIGN KEY (tiempo_key) REFERENCES dim_tiempo (tiempo_key)
) ENGINE=InnoDB;

-- Índices de Alta Eficiencia
CREATE INDEX idx_fact_query_performance 
ON fact_ventas (tiempo_key, producto_key, empleado_key, cliente_key);