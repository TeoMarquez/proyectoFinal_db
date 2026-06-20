from pathlib import Path
from datetime import datetime
import traceback

from db.connection import get_connection

PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "seed" / "data"
LOGS_DIR = PROJECT_ROOT / "logs"

TABLES = [
    ("Clientes",              "clientes.csv"),
    ("Proveedores",            "proveedores.csv"),
    ("Provincias",           "provincias.csv"),
    ("Ciudades",               "ciudades.csv"),
    ("Zonas",                 "zonas.csv"),
    ("Servicios",             "servicios.csv"),
    ("Recintos",              "recintos.csv"),
    ("Contratos",             "contratos.csv"),
    ("Subcontratos",          "subcontratos.csv"),
    ("Eventos",               "eventos.csv"),
    ("Tickets",               "tickets.csv"),
    ("IngresosEventos",      "ingresos_evento.csv"),
    ("Cancelaciones",          "cancelaciones.csv"),
    ("EvaluacionesServicios",  "evaluaciones_servicio.csv"),
]


def create_log_file():
    LOGS_DIR.mkdir(exist_ok=True)

    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    log_path = LOGS_DIR / f"load_{timestamp}.log"

    with open(log_path, "w", encoding="utf-8") as f:
        f.write("=" * 80 + "\n")
        f.write("EMPRESA EVENTOS - LOAD LOG\n")
        f.write(f"Timestamp: {datetime.now()}\n")
        f.write("=" * 80 + "\n\n")

    return log_path


def write_log(log_path, message):
    with open(log_path, "a", encoding="utf-8") as f:
        f.write(message + "\n")


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

    log_path = create_log_file()
    loaded_tables = 0

    write_log(log_path, "[START] LOAD PROCESS")

    try:
        for table_name, filename in TABLES:
            csv_path = (DATA_DIR / filename).resolve()

            print(f"[LOAD] {table_name}")

            try:
                bulk_insert(cursor, table_name, csv_path)
                conn.commit()

                loaded_tables += 1

                print(f"[OK]  {table_name}")

                write_log(
                    log_path,
                    f"[OK] table={table_name} csv={csv_path}"
                )

            except Exception as e:
                conn.rollback()

                error_msg = repr(e)
                trace = traceback.format_exc()

                print(f"[ERROR] {table_name}")
                print(f"[ERROR] Ver detalles en: {log_path}")

                if "IID_IColumnsInfo" in error_msg:
                    print("[WARN] BULK INSERT no pudo acceder al archivo.")
                    print("[WARN] Revisar permisos, OneDrive o ubicación de los CSV.")

                elif "Bulk load data conversion error" in error_msg:
                    print("[WARN] El CSV contiene datos incompatibles con el esquema SQL.")

                write_log(
                    log_path,
                    (
                        f"\n{'=' * 80}\n"
                        f"[ERROR]\n"
                        f"timestamp={datetime.now()}\n"
                        f"table={table_name}\n"
                        f"csv={csv_path}\n\n"
                        f"Exception:\n"
                        f"{error_msg}\n\n"
                        f"Traceback:\n"
                        f"{trace}\n"
                        f"{'=' * 80}\n"
                    )
                )

                write_log(
                    log_path,
                    (
                        f"\n[SUMMARY]\n"
                        f"Loaded tables: {loaded_tables}/{len(TABLES)}"
                    )
                )

                raise

    finally:
        cursor.close()
        conn.close()

    write_log(
        log_path,
        (
            f"\n[SUMMARY]\n"
            f"Loaded tables: {loaded_tables}/{len(TABLES)}"
        )
    )

    write_log(log_path, "\n[END] LOAD PROCESS SUCCESS")

    print("\n[LOAD] DONE")
    print(f"[LOG] {log_path}")


if __name__ == "__main__":
    main()