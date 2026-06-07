from pathlib import Path
import csv

BASE_DIR = Path(__file__).resolve().parents[1]
PATH = BASE_DIR / "data" / "ciudades.csv"

def load_ciudades():
    ciudades = []

    with open(PATH, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f, skipinitialspace=True)

        for row in reader:
            ciudades.append({
                "id": int(row["id"]),
                "provincia_id": int(row["provincia_id"]),
                "nombre": row["nombre"].strip()
            })

    return ciudades