from pathlib import Path
import csv


PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "data"


def dump_contratos(contratos):

    DATA_DIR.mkdir(parents=True, exist_ok=True)

    file_path = DATA_DIR / "contratos.csv"

    with open(file_path, "w", newline="", encoding="utf-8") as f:

        writer = csv.writer(f)

        writer.writerow([
            "id",
            "cliente_id",
            "fecha_firma",
            "fecha_programada",
            "presupuesto_acordado",
            "informacion",
            "tipo_evento",
            "estado"
        ])

        for c in contratos:

            writer.writerow([
                c["id"],
                c["cliente_id"],
                c["fecha_firma"],
                c["fecha_programada"],
                c["presupuesto_acordado"],
                c["informacion"],
                c["tipo_evento"],
                c["estado"]
            ])

    print(f"[DUMP] OK contratos ({len(contratos)} filas)")