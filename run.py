import argparse

from db.create_db import main as create_db_main
from seed.run_seed import run_seed
from load.load import main as load_main
from db.tooling.delete_db import delete_db

def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--del", dest="drop", action="store_true")
    parser.add_argument("--seed", type=int, default=None)

    return parser.parse_args()

def main():
    args = parse_args()

    print("\n===================================")
    print(" EMPRESA EVENTOS RUNNER ")
    print("===================================\n")

    if args.drop:
        print("[STEP] Dropping database...")
        delete_db()

        print("[DONE] Database dropped. Exiting.")
        return
            

    print("[STEP] Creating database...")
    create_db_main()

    seed_value = args.seed if args.seed is not None else 42
    print(f"[STEP] Running seed with seed={seed_value}...")
    run_seed(seed_value)

    print("[STEP] Loading CSVs...")
    load_main()

    print("\n===================================")
    print(" DONE ✔ ")
    print("===================================\n")


if __name__ == "__main__":
    main()