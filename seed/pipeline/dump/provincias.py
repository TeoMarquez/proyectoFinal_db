# seed/pipeline/dump/provincias.py

from pathlib import Path
import csv


PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "data"


def dump_provincias(provincias, filename="provincias.csv"):

    DATA_DIR.mkdir(parents=True, exist_ok=True)

    file_path = DATA_DIR / filename
    
    with open(file_path, mode="w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)

        writer.writerow(["id", "nombre"])

        for prov in provincias:
            writer.writerow([prov["id"], prov["nombre"]])

    print(f"[DUMP] OK ({len(provincias)} filas)")

    return file_path