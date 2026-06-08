from pathlib import Path
import csv

PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "data"


def dump_ingresos_evento(ingresos):

    file_path = DATA_DIR / "ingresos_evento.csv"

    with open(file_path, "w", newline="", encoding="utf-8") as f:

        writer = csv.writer(f)

        writer.writerow([
            "id",
            "evento_id",
            "tipo_ingreso",
            "monto"
        ])

        for i in ingresos:

            writer.writerow([
                i["id"],
                i["evento_id"],
                i["tipo_ingreso"],
                i["monto"]
            ])

    print(
        f"[DUMP] OK ingresos_evento ({len(ingresos)} filas)"
    )