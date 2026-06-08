from pathlib import Path
import csv

PROJECT_ROOT = Path(__file__).resolve().parents[2]
DATA_DIR = PROJECT_ROOT / "data"


def dump_tickets(tickets):

    file_path = DATA_DIR / "tickets.csv"

    with open(file_path, "w", newline="", encoding="utf-8") as f:

        writer = csv.writer(f)

        writer.writerow([
            "id",
            "evento_id",
            "tipo",
            "precio",
            "cantidad_vendida"
        ])

        for t in tickets:

            writer.writerow([
                t["id"],
                t["evento_id"],
                t["tipo"],
                t["precio"],
                t["cantidad_vendida"]
            ])

    print(f"[DUMP] OK tickets ({len(tickets)} filas)")