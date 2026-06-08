from pathlib import Path
import re
from db.connection import get_connection

def main():
    conn = get_connection("master")
    cursor = conn.cursor()

    BASE_DIR = Path(__file__).resolve().parent

    scripts = [
        BASE_DIR / "scripts_sql" / "01_schema.sql",
        BASE_DIR / "scripts_sql" / "02_views.sql",
        BASE_DIR / "scripts_sql" / "03_procedures.sql",
        BASE_DIR / "scripts_sql" / "04_triggers.sql",
    ]

    print("\n[DB] Iniciando ejecución de scripts...\n")

    for script_path in scripts:

        print(f"\n[SCRIPT] Ejecutando archivo: {script_path.name}")

        try:
            sql_script = script_path.read_text(encoding="utf-8")
        except Exception as e:
            print(f"[SCRIPT] ERROR leyendo archivo {script_path}")
            print(e)
            raise

        statements = re.split(r'^\s*GO\s*$', sql_script, flags=re.MULTILINE)

        for i, stmt in enumerate(statements, start=1):
            stmt = stmt.strip()
            if stmt:
                try:
                    print(f"[SCRIPT] Ejecutando statement {i}...")
                    cursor.execute(stmt)
                except Exception as e:
                    print("\n[SCRIPT] ERROR en statement:")
                    print(stmt[:500], "..." if len(stmt) > 500 else "")
                    print("\n[SCRIPT] Error:", e)
                    raise

        print(f"[SCRIPT] {script_path.name} completado")

    print("\n[DB] Base de datos creada correctamente")

    cursor.close()
    conn.close()