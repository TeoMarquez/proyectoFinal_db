from pathlib import Path
import csv


PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "data"


def dump_eventos(eventos):

    DATA_DIR.mkdir(parents=True, exist_ok=True)

    file_path = DATA_DIR / "eventos.csv"

    with open(file_path, "w", newline="", encoding="utf-8") as f:

        writer = csv.writer(f)

        writer.writerow([
            "id",
            "contrato_id",
            "nombre",
            "fecha_real",
            "estado",
            "cantidad_asistentes"
        ])

        for e in eventos:

            writer.writerow([
                e["id"],
                e["contrato_id"],
                e["nombre"],
                e["fecha_real"],
                e["estado"],
                e["cantidad_asistentes"]
            ])

    print(f"[DUMP] OK eventos ({len(eventos)} filas)")

    return file_path