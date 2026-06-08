from pathlib import Path
import csv


PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "data"


def dump_servicios(servicios):

    DATA_DIR.mkdir(parents=True, exist_ok=True)

    file_path = DATA_DIR / "servicios.csv"

    with open(file_path, "w", newline="", encoding="utf-8") as f:

        writer = csv.writer(f)

        writer.writerow([
            "id",
            "zona_id",
            "proveedor_id",
            "categoria",
            "nombre",
            "descripcion"
        ])

        for s in servicios:

            writer.writerow([
                s["id"],
                s["zona_id"],
                s["proveedor_id"],
                s["categoria"],
                s["nombre"],
                s["descripcion"]
            ])

    print(f"[DUMP] OK servicios ({len(servicios)} filas)")