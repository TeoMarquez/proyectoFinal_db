from factories.create_provincias import create_provincias
from factories.load_ciudades import load_ciudades
from factories.create_zonas import create_zonas
from factories.create_clientes import create_clientes
from factories.create_proveedores import create_proveedores
from factories.create_servicios import create_servicios
from factories.create_recintos import create_recintos

from pipeline.dump.provincias import dump_provincias
# from pipeline.dump.ciudades import dump_ciudades (ya existente)
from pipeline.dump.zonas import dump_zonas
from pipeline.dump.clientes import dump_clientes
from pipeline.dump.proveedores import dump_proveedores
from pipeline.dump.servicios import dump_servicios
from pipeline.dump.recintos import dump_recintos

SEED = 42
TARGET_ROWS = 100_000


def print_stats(stats):

    total = sum(stats.values())

    print()
    print("=" * 50)
    print("SEED STATISTICS")
    print("=" * 50)

    for table, rows in stats.items():
        print(f"{table:<15} {rows:>10,}")

    print("-" * 50)
    print(f"{'TOTAL':<15} {total:>10,}")
    print("=" * 50)

    print(f"Objetivo: {TARGET_ROWS:,}")
    print(f"Actual:   {total:,}")
    print(f"Progreso: {(total / TARGET_ROWS) * 100:.2f}%")
    print()


def main():

    stats = {}

    print("[SEED] Generando provincias...")
    provincias = create_provincias()
    dump_provincias(provincias)
    stats["provincias"] = len(provincias)

    print("[SEED] Cargando ciudades...")
    ciudades = load_ciudades()
    stats["ciudades"] = len(ciudades)

    print("[SEED] Generando zonas...")
    zonas = create_zonas(ciudades, seed=SEED)
    dump_zonas(zonas)
    stats["zonas"] = len(zonas)

    print("[SEED] Generando proveedores...")
    proveedores = create_proveedores(SEED)
    dump_proveedores(proveedores)
    stats["proveedores"] = len(proveedores)

    print("[SEED] Generando clientes...")
    clientes = create_clientes(SEED + 1)
    dump_clientes(clientes)
    stats["clientes"] = len(clientes)

    print("[SEED] Generando servicios...")
    servicios = create_servicios(zonas, proveedores, SEED)
    dump_servicios(servicios)
    stats["servicios"] = len(servicios)

    print("[SEED] Generando recintos...")
    recintos = create_recintos(servicios, SEED)
    dump_recintos(recintos)
    stats["recintos"] = len(recintos)

    print_stats(stats)

    print("[SEED] DONE ✔")


if __name__ == "__main__":
    main()