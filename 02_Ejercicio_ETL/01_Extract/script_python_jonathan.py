import os
import logging
import pandas as pd
import random
from faker import Faker
from sqlalchemy import create_engine, text

# Configuración
logging.basicConfig(level=logging.INFO, format='%(asctime)s - INGESTION - %(levelname)s - %(message)s')
DB_URI = os.getenv("DB_URI", "mysql+pymysql://root:@localhost:3306/enterprise_datawarehouse")
engine = create_engine(DB_URI)
fake = Faker()

def extract_and_load_raw():
    logging.info("1. Generando datos simulados (Extracción)...")
    
    # Generar Clientes
    clientes = [{"cliente_id": i, "nombre_enmascarado": f"MASK_{fake.first_name()}", "ciudad": fake.city(), "edad": random.randint(18, 70)} for i in range(1, 21)]
    df_clientes = pd.DataFrame(clientes)

    # Generar Productos
    productos = [{"producto_id": i, "producto": fake.word(), "categoria": random.choice(["Laptops", "Monitores", "Mouse", "Teclados"]), "precio_entero": random.randint(10000, 500000)} for i in range(1, 16)]
    df_productos = pd.DataFrame(productos)

    # Generar Empleados
    empleados = [{"empleado_id": i, "nombre_enmascarado": f"MASK_{fake.last_name()}", "departamento": random.choice(["Ventas", "IT", "HR", "Logistica"]), "salario_entero": random.randint(2000000, 8000000)} for i in range(1, 6)]
    df_empleados = pd.DataFrame(empleados)

    # Generar Ventas
    ventas = []
    for i in range(1, 501):
        cant = random.randint(1, 5)
        precio = random.randint(10000, 500000)
        ventas.append({
            "venta_id": i, 
            "cliente_id": random.randint(1, 20), 
            "producto_id": random.randint(1, 15),
            "empleado_id": random.randint(1, 5), 
            "cantidad": cant, 
            "precio_aplicado": precio,
            "descuento_aplicado": 0, 
            "total_entero": cant * precio, 
            "fecha_venta": f"2026-05-{random.randint(1,30):02d}"
        })
    df_ventas = pd.DataFrame(ventas)

    # Carga a BD (Capa RAW)
    logging.info("2. Cargando datos a la capa RAW...")
    with engine.begin() as conn:
        # Limpieza previa para idempotencia en el entorno de pruebas
        conn.execute(text("TRUNCATE TABLE raw_ventas;"))
        conn.execute(text("TRUNCATE TABLE raw_clientes;"))
        conn.execute(text("TRUNCATE TABLE raw_productos;"))
        conn.execute(text("TRUNCATE TABLE raw_empleados;"))

        # Inserción directa
        df_clientes.to_sql("raw_clientes", conn, if_exists="append", index=False)
        df_productos.to_sql("raw_productos", conn, if_exists="append", index=False)
        df_empleados.to_sql("raw_empleados", conn, if_exists="append", index=False)
        df_ventas.to_sql("raw_ventas", conn, if_exists="append", index=False)
        
    logging.info("Ingesta RAW finalizada con éxito.")

if __name__ == "__main__":
    extract_and_load_raw()