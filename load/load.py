from pathlib import Path
from db.connection import get_connection

PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "seed" / "data"

TABLES = [
    ("cliente",              "clientes.csv"),
    ("proveedor",            "proveedores.csv"),
    ("provincias",           "provincias.csv"),
    ("ciudad",               "ciudades.csv"),
    ("zona",                 "zonas.csv"),
    ("servicio",             "servicios.csv"),
    ("recinto",              "recintos.csv"),
    ("contrato",             "contratos.csv"),
    ("subcontrato",          "subcontratos.csv"),
    ("evento",               "eventos.csv"),
    ("ticket",               "tickets.csv"),
    ("ingresos_evento",      "ingresos_evento.csv"),
    ("cancelacion",          "cancelaciones.csv"),
    ("evaluacion_servicio",  "evaluaciones_servicio.csv"),
]

def bulk_insert(cursor, table_name, csv_path):
    sql_bulk = f"""
    BULK INSERT {table_name}
    FROM '{csv_path}'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        CODEPAGE = '65001',
        TABLOCK
    );
    """
    cursor.execute(sql_bulk)

def main():
    conn = get_connection("EmpresaEventos")
    cursor = conn.cursor()

    for table_name, filename in TABLES:
        csv_path = (DATA_DIR / filename).resolve()
        print(f"[LOAD] {table_name}")
        bulk_insert(cursor, table_name, csv_path)
        conn.commit()
        print(f"[OK]  {table_name}")

    cursor.close()
    conn.close()
    print("\n[LOAD] DONE ✔")

if __name__ == "__main__":
    main()