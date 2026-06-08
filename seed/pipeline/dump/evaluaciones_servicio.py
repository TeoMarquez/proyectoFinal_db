from pathlib import Path
import csv

PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "data"


def dump_evaluaciones_servicio(evaluaciones):

    file_path = DATA_DIR / "evaluaciones_servicio.csv"

    with open(
        file_path,
        "w",
        newline="",
        encoding="utf-8"
    ) as f:

        writer = csv.writer(f)

        writer.writerow([
            "id",
            "subcontrato_id",
            "calificacion_rendimiento",
            "calificacion_costo",
            "comentario"
        ])

        for e in evaluaciones:

            writer.writerow([
                e["id"],
                e["subcontrato_id"],
                e["calificacion_rendimiento"],
                e["calificacion_costo"],
                e["comentario"]
            ])

    print(
        f"[DUMP] OK evaluaciones ({len(evaluaciones)} filas)"
    )