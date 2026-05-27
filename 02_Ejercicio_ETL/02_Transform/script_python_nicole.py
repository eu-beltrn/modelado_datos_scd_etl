import os
import logging
import pandas as pd
from datetime import datetime
from sqlalchemy import create_engine, text

logging.basicConfig(level=logging.INFO, format='%(asctime)s - TRANSFORMATION - %(levelname)s - %(message)s')
DB_URI = os.getenv("DB_URI", "mysql+pymysql://root:@localhost:3306/enterprise_datawarehouse")
engine = create_engine(DB_URI)

def transform_and_load_core():
    batch_id = int(datetime.now().strftime("%Y%m%d%H%M%S"))
    logging.info(f"Iniciando Transformación - Lote: {batch_id}")

    with engine.begin() as conn:
        logging.info("1. Preparando entorno Dimensional...")
        conn.execute(text("SET FOREIGN_KEY_CHECKS = 0;"))
        tablas = ["fact_ventas", "dim_clientes", "dim_productos", "dim_empleados", "dim_tiempo"]
        for t in tablas:
            conn.execute(text(f"TRUNCATE TABLE {t};"))

        # ---------------------------------------------------------
        # DIMENSIÓN TIEMPO
        # ---------------------------------------------------------
        tiempo = [{"tiempo_key": 20260500 + i, "fecha": f"2026-05-{i:02d}", "dia": i, "mes": 5, "mes_nombre": "Mayo", "anio": 2026, "trimestre": 2, "semestre": 1} for i in range(1, 31)]
        pd.DataFrame(tiempo).to_sql("dim_tiempo", conn, if_exists="append", index=False)

        # ---------------------------------------------------------
        # DIMENSIONES DEL NEGOCIO (Extracción desde RAW y carga)
        # ---------------------------------------------------------
        logging.info("2. Transformando y cargando Dimensiones (SCD)...")
        
        # Clientes
        raw_cli = pd.read_sql("SELECT * FROM raw_clientes", conn)
        dim_cli = pd.DataFrame({"cliente_id": raw_cli["cliente_id"], "nombre": raw_cli["nombre_enmascarado"], "ciudad": raw_cli["ciudad"], "edad": raw_cli["edad"], "etl_batch_id": batch_id})
        dim_cli.to_sql("dim_clientes", conn, if_exists="append", index=False)
        # Recuperar llaves subrogadas generadas
        keys_cli = pd.read_sql("SELECT cliente_key, cliente_id FROM dim_clientes", conn)

        # Productos
        raw_prod = pd.read_sql("SELECT * FROM raw_productos", conn)
        dim_prod = pd.DataFrame({"producto_id": raw_prod["producto_id"], "producto": raw_prod["producto"], "categoria": raw_prod["categoria"], "precio": raw_prod["precio_entero"], "fecha_inicio": "2026-01-01", "registro_activo": 1, "etl_batch_id": batch_id})
        dim_prod.to_sql("dim_productos", conn, if_exists="append", index=False)
        keys_prod = pd.read_sql("SELECT producto_key, producto_id FROM dim_productos", conn)

        # Empleados
        raw_emp = pd.read_sql("SELECT * FROM raw_empleados", conn)
        dim_emp = pd.DataFrame({"empleado_id": raw_emp["empleado_id"], "nombre": raw_emp["nombre_enmascarado"], "departamento": raw_emp["departamento"], "salario": raw_emp["salario_entero"], "fecha_inicio": "2026-01-01", "registro_activo": 1, "etl_batch_id": batch_id})
        dim_emp.to_sql("dim_empleados", conn, if_exists="append", index=False)
        keys_emp = pd.read_sql("SELECT empleado_key, empleado_id FROM dim_empleados", conn)

        # ---------------------------------------------------------
        # FACT TABLE (Cruces analíticos)
        # ---------------------------------------------------------
        logging.info("3. Procesando cruces para Tabla de Hechos...")
        raw_ventas = pd.read_sql("SELECT * FROM raw_ventas", conn)
        
        # Merge para reemplazar ID natural por Surrogate Key
        df_fact = raw_ventas.merge(keys_cli, on="cliente_id").merge(keys_prod, on="producto_id").merge(keys_emp, on="empleado_id")
        
        # Generar tiempo_key a partir de fecha_venta
        df_fact["tiempo_key"] = pd.to_datetime(df_fact["fecha_venta"]).dt.strftime("%Y%m%d").astype(int)
        
        # Seleccionar y renombrar para insertar
        fact_final = pd.DataFrame({
            "venta_id": df_fact["venta_id"], "cliente_key": df_fact["cliente_key"],
            "producto_key": df_fact["producto_key"], "empleado_key": df_fact["empleado_key"],
            "tiempo_key": df_fact["tiempo_key"], "cantidad": df_fact["cantidad"],
            "precio": df_fact["precio_aplicado"], "descuento": df_fact["descuento_aplicado"],
            "total": df_fact["total_entero"], "etl_batch_id": batch_id
        })
        
        fact_final.to_sql("fact_ventas", conn, if_exists="append", index=False)
        
        # Restaurar FK
        conn.execute(text("SET FOREIGN_KEY_CHECKS = 1;"))
        logging.info("Transformación y Carga CORE finalizada con éxito.")

if __name__ == "__main__":
    transform_and_load_core()