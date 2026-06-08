from pathlib import Path
import csv


PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "data"


def dump_subcontratos(subcontratos):

    DATA_DIR.mkdir(parents=True, exist_ok=True)

    file_path = DATA_DIR / "subcontratos.csv"

    with open(
        file_path,
        "w",
        newline="",
        encoding="utf-8"
    ) as f:

        writer = csv.writer(f)

        writer.writerow([
            "id",
            "contrato_id",
            "servicio_id",
            "costo",
            "fecha_firma",
            "estado"
        ])

        for s in subcontratos:

            writer.writerow([
                s["id"],
                s["contrato_id"],
                s["servicio_id"],
                s["costo"],
                s["fecha_firma"],
                s["estado"]
            ])

    print(
        f"[DUMP] OK subcontratos ({len(subcontratos)} filas)"
    )

    return file_path