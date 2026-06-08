from pathlib import Path
import csv


PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "data"


def dump_recintos(recintos):

    DATA_DIR.mkdir(parents=True, exist_ok=True)

    file_path = DATA_DIR / "recintos.csv"

    with open(file_path, "w", newline="", encoding="utf-8") as f:

        writer = csv.writer(f)

        writer.writerow([
            "id",
            "servicio_id",
            "nombre",
            "capacidad",
            "direccion"
        ])

        for r in recintos:

            writer.writerow([
                r["id"],
                r["servicio_id"],
                r["nombre"],
                r["capacidad"],
                r["direccion"]
            ])

    print(f"[DUMP] OK recintos ({len(recintos)} filas)")