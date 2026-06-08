from pathlib import Path
import csv


PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "data"


def dump_zonas(zonas, filename="zonas.csv"):

    DATA_DIR.mkdir(parents=True, exist_ok=True)
    file_path = DATA_DIR / filename

    print(f"[DUMP] Guardando zonas en: {file_path}")

    with open(file_path, mode="w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)

        writer.writerow([
            "id",
            "ciudad_id",
            "nombre_zona",
            "codigo_postal",
            "descripcion"
        ])

        for z in zonas:
            writer.writerow([
                z["id"],
                z["ciudad_id"],
                z["nombre_zona"],
                z["codigo_postal"],
                z["descripcion"]
            ])

    print(f"[DUMP] OK zonas ({len(zonas)} filas)")

    return file_path