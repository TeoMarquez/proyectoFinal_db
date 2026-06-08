from pathlib import Path
import csv

PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "data"


def dump_cancelaciones(cancelaciones):

    file_path = DATA_DIR / "cancelaciones.csv"

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
            "evento_id",
            "detalle"
        ])

        for c in cancelaciones:

            writer.writerow([
                c["id"],
                c["subcontrato_id"],
                c["evento_id"],
                c["detalle"]
            ])

    print(
        f"[DUMP] OK cancelaciones ({len(cancelaciones)} filas)"
    )