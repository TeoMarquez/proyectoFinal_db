from pathlib import Path
import csv

PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "data"


def dump_proveedores(proveedores):

    DATA_DIR.mkdir(parents=True, exist_ok=True)

    file_path = DATA_DIR / "proveedores.csv"

    with open(file_path, "w", newline="", encoding="utf-8") as f:

        writer = csv.writer(f)

        writer.writerow([
            "id",
            "nombre",
            "cuit",
            "telefono",
            "email"
        ])

        for p in proveedores:

            writer.writerow([
                p["id"],
                p["nombre"],
                p["cuit"],
                p["telefono"],
                p["email"]
            ])

    print(f"[DUMP] OK proveedores ({len(proveedores)} filas)")