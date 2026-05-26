# -*- coding: utf-8 -*-
"""
Created on Sun May 24 22:49:53 2026

@author: jrodr
"""

import os
import logging
import pandas as pd
from sqlalchemy import create_engine, text

logging.basicConfig(level=logging.INFO, format='%(asctime)s - QA_REPORTING - %(levelname)s - %(message)s')
DB_URI = os.getenv("DB_URI", "mysql+pymysql://root:root@localhost:3306/enterprise_datawarehouse")
engine = create_engine(DB_URI)

# Diccionario de pruebas de QA para automatización
QA_SUITE = {
    "Ventas Huerfanas": """
        SELECT f.venta_id 
        FROM fact_ventas f
        LEFT JOIN dim_clientes c ON f.cliente_key = c.cliente_key
        WHERE c.cliente_key IS NULL
    """,
    "Precios Negativos": """
        SELECT venta_id 
        FROM fact_ventas 
        WHERE total <= 0
    """
}

def run_qa_checks():
    logging.info("Ejecutando Suite de Calidad de Datos (QA)...")
    with engine.connect() as conn:
        for test_name, query in QA_SUITE.items():
            result = pd.read_sql(query, conn)
            if not result.empty:
                logging.error(f"Fallo en QA [{test_name}]: {len(result)} registros anómalos detectados.")
                # Dependiendo de la política, aquí se podría lanzar una excepción para detener el pipeline.
            else:
                logging.info(f"Test superado [{test_name}].")

def export_kpis():
    logging.info("Generando reportes analíticos...")
    with engine.connect() as conn:
        df_kpi = pd.read_sql("SELECT * FROM v_kpi_rendimiento_negocio", conn)
        df_ranking = pd.read_sql("SELECT * FROM v_ranking_top_vendedores", conn)
        
        # Simulación de capa de presentación: exportación a CSV/Excel o envío por correo
        df_kpi.to_csv("reporte_rendimiento.csv", index=False)
        df_ranking.to_csv("reporte_vendedores.csv", index=False)
        logging.info("Reportes exportados exitosamente a la capa de presentación local.")

if __name__ == "__main__":
    # Esta estructura permite que este script sirva como paso final en un orquestador (ej. Airflow)
    run_qa_checks()
    export_kpis()