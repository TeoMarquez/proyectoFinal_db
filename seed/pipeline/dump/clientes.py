from pathlib import Path
import csv

PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "data"


def dump_clientes(clientes):

    DATA_DIR.mkdir(parents=True, exist_ok=True)

    file_path = DATA_DIR / "clientes.csv"

    with open(file_path, "w", newline="", encoding="utf-8") as f:

        writer = csv.writer(f)

        writer.writerow([
            "id",
            "nombre",
            "cuit",
            "telefono",
            "email"
        ])

        for c in clientes:

            writer.writerow([
                c["id"],
                c["nombre"],
                c["cuit"],
                c["telefono"],
                c["email"]
            ])

    print(f"[DUMP] OK clientes ({len(clientes)} filas)")