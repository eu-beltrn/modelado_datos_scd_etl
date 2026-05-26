import os
import logging
import pandas as pd
import plotly.express as px
import plotly.io as pio
from sqlalchemy import create_engine

# Configuración de Logging y Entorno
logging.basicConfig(level=logging.INFO, format='%(asctime)s - VISUALIZATION - %(levelname)s - %(message)s')
DB_URI = os.getenv("DB_URI", "mysql+pymysql://root:root@localhost:3306/enterprise_datawarehouse")
engine = create_engine(DB_URI)

def extraer_datos_analiticos():
    """Extrae la información ya procesada y agregada desde las Vistas Corporativas."""
    logging.info("Extrayendo datos de la capa semántica (Vistas)...")
    try:
        with engine.connect() as conn:
            df_kpi = pd.read_sql("SELECT * FROM v_kpi_rendimiento_negocio", conn)
            df_ranking = pd.read_sql("SELECT * FROM v_ranking_top_vendedores", conn)
        return df_kpi, df_ranking
    except Exception as e:
        logging.critical(f"Error conectando a la BD para extraer vistas: {e}")
        raise

def generar_dashboard(df_kpi, df_ranking):
    """Genera gráficas interactivas y las compila en un Dashboard HTML."""
    logging.info("Generando visualizaciones interactivas con Plotly...")

    # 1. Gráfica: Ingresos Totales por Categoría de Producto (Bar Chart)
    # Agrupamos en memoria por si la vista trae múltiples niveles
    df_cat = df_kpi.groupby('Categoria_Producto', as_index=False)['Ingresos_Totales_Enteros'].sum()
    fig_cat = px.bar(
        df_cat, 
        x='Categoria_Producto', 
        y='Ingresos_Totales_Enteros',
        title='Ingresos Totales por Categoría',
        labels={'Ingresos_Totales_Enteros': 'Ingresos ($)', 'Categoria_Producto': 'Categoría'},
        color='Ingresos_Totales_Enteros',
        color_continuous_scale='Blues'
    )
    fig_cat.update_layout(template='plotly_white')

    # 2. Gráfica: Distribución de Ventas por Departamento (Donut Chart)
    df_dep = df_kpi.groupby('Departamento_Vendedor', as_index=False)['Ingresos_Totales_Enteros'].sum()
    fig_dep = px.pie(
        df_dep, 
        names='Departamento_Vendedor', 
        values='Ingresos_Totales_Enteros',
        title='Contribución de Ingresos por Departamento',
        hole=0.4, # Convierte el Pie Chart en un Donut Chart (más elegante)
        color_discrete_sequence=px.colors.qualitative.Prism
    )

    # 3. Gráfica: Ranking de Top Vendedores (Horizontal Bar Chart)
    # Filtramos solo el Top 10 para no saturar la gráfica
    df_top = df_ranking.sort_values(by='Venta_Acumulada_Entera', ascending=False).head(10)
    fig_ranking = px.bar(
        df_top, 
        x='Venta_Acumulada_Entera', 
        y='Nombre_Empleado',
        title='Top 10 Vendedores a Nivel Global',
        orientation='h',
        labels={'Venta_Acumulada_Entera': 'Ventas Acumuladas ($)', 'Nombre_Empleado': 'Vendedor'},
        color='Departamento'
    )
    fig_ranking.update_layout(yaxis={'categoryorder':'total ascending'}, template='plotly_white')

    # Compilar todo en un solo archivo HTML empresarial
    logging.info("Compilando gráficas en Dashboard HTML estático...")
    
    html_content = f"""
    <html>
        <head>
            <title>Dashboard Analítico Empresarial</title>
            <style>
                body {{ font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }}
                h1 {{ color: #2c3e50; text-align: center; border-bottom: 2px solid #3498db; padding-bottom: 10px; }}
                .chart-container {{ background: white; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); margin-bottom: 30px; padding: 20px; }}
                .grid {{ display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }}
                .full-width {{ grid-column: span 2; }}
            </style>
        </head>
        <body>
            <h1>📊 Enterprise Data Warehouse - Resumen de Negocio</h1>
            
            <div class="grid">
                <div class="chart-container">
                    {fig_cat.to_html(full_html=False, include_plotlyjs='cdn')}
                </div>
                <div class="chart-container">
                    {fig_dep.to_html(full_html=False, include_plotlyjs=False)}
                </div>
                <div class="chart-container full-width">
                    {fig_ranking.to_html(full_html=False, include_plotlyjs=False)}
                </div>
            </div>
            
            <p style="text-align: center; color: #7f8c8d; font-size: 12px;">Generado automáticamente por Pipeline ETL (Capa de Presentación)</p>
        </body>
    </html>
    """

    with open("Dashboard_Empresarial.html", "w", encoding="utf-8") as f:
        f.write(html_content)

    logging.info("[SUCCESS] Dashboard interactivo generado: 'Dashboard_Empresarial.html'")

if __name__ == "__main__":
    df_kpis, df_rank = extraer_datos_analiticos()
    generar_dashboard(df_kpis, df_rank)