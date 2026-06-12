from seed.factories.create_provincias import create_provincias
from seed.factories.load_ciudades import load_ciudades
from seed.factories.create_zonas import create_zonas
from seed.factories.create_clientes import create_clientes
from seed.factories.create_proveedores import create_proveedores
from seed.factories.create_servicios import create_servicios
from seed.factories.create_recintos import create_recintos
from seed.factories.create_contratos import create_contratos
from seed.factories.create_subcontratos import create_subcontratos
from seed.factories.create_eventos import create_eventos
from seed.factories.create_ingresos_evento import create_ingresos_evento
from seed.factories.create_tickets import create_tickets
from seed.factories.create_cancelaciones import create_cancelaciones
from seed.factories.create_evaluaciones_servicio import create_evaluaciones_servicio

from seed.pipeline.dump.provincias import dump_provincias
from seed.pipeline.dump.zonas import dump_zonas
from seed.pipeline.dump.clientes import dump_clientes
from seed.pipeline.dump.proveedores import dump_proveedores
from seed.pipeline.dump.servicios import dump_servicios
from seed.pipeline.dump.recintos import dump_recintos
from seed.pipeline.dump.contratos import dump_contratos
from seed.pipeline.dump.subcontratos import dump_subcontratos
from seed.pipeline.dump.eventos import dump_eventos
from seed.pipeline.dump.ingresos_eventos import dump_ingresos_evento
from seed.pipeline.dump.tickets import dump_tickets
from seed.pipeline.dump.cancelaciones import dump_cancelaciones
from seed.pipeline.dump.evaluaciones_servicio import dump_evaluaciones_servicio

import argparse

TARGET_ROWS = 100_000


def run_seed(seed: int = 42):

    stats = {}

    print(f"[SEED] Usando seed={seed}")

    print("[SEED] Generando provincias...")
    provincias = create_provincias()
    dump_provincias(provincias)
    stats["provincias"] = len(provincias)

    print("[SEED] Cargando ciudades...")
    ciudades = load_ciudades()
    stats["ciudades"] = len(ciudades)

    print("[SEED] Generando zonas...")
    zonas = create_zonas(ciudades, seed=seed)
    dump_zonas(zonas)
    stats["zonas"] = len(zonas)

    print("[SEED] Generando proveedores...")
    proveedores = create_proveedores(seed)
    dump_proveedores(proveedores)
    stats["proveedores"] = len(proveedores)

    print("[SEED] Generando clientes...")
    clientes = create_clientes(seed + 1)
    dump_clientes(clientes)
    stats["clientes"] = len(clientes)

    print("[SEED] Generando servicios...")
    servicios = create_servicios(zonas, proveedores, seed)
    dump_servicios(servicios)
    stats["servicios"] = len(servicios)

    print("[SEED] Generando recintos...")
    recintos = create_recintos(servicios, seed)
    dump_recintos(recintos)
    stats["recintos"] = len(recintos)

    print("[SEED] Generando contratos...")
    contratos = create_contratos(clientes, seed)
    dump_contratos(contratos)
    stats["contratos"] = len(contratos)

    print("[SEED] Generando subcontratos...")
    subcontratos = create_subcontratos(contratos, servicios, zonas, seed)
    dump_subcontratos(subcontratos)
    stats["subcontratos"] = len(subcontratos)

    print("[SEED] Generando eventos...")
    eventos = create_eventos(contratos, seed)
    dump_eventos(eventos)
    stats["eventos"] = len(eventos)

    print("[SEED] Generando tickets...")
    tickets = create_tickets(eventos, seed)
    dump_tickets(tickets)
    stats["tickets"] = len(tickets)

    print("[SEED] Generando ingresos_evento...")
    ingresos = create_ingresos_evento(eventos, seed)
    dump_ingresos_evento(ingresos)
    stats["ingresos_evento"] = len(ingresos)

    print("[SEED] Generando cancelaciones...")
    cancelaciones = create_cancelaciones(eventos, subcontratos, seed)
    dump_cancelaciones(cancelaciones)
    stats["cancelaciones"] = len(cancelaciones)

    print("[SEED] Generando evaluaciones...")
    evaluaciones = create_evaluaciones_servicio(subcontratos, cancelaciones, seed)
    dump_evaluaciones_servicio(evaluaciones)
    stats["evaluaciones"] = len(evaluaciones)

    print_stats(stats, seed)
    print("[SEED] DONE")


def parse_args():
    parser = argparse.ArgumentParser(description="Seed generator")
    parser.add_argument("--seed", type=int, default=42)
    return parser.parse_args()


def print_stats(stats, seed):
    total = sum(stats.values())

    print("\n" + "=" * 50)
    print("SEED STATISTICS")
    print("=" * 50)
    print(f"Seed: {seed}\n")

    for k, v in stats.items():
        print(f"{k:<15} {v:>10,}")

    print("-" * 50)
    print(f"{'TOTAL':<15} {total:>10,}")
    print("=" * 50)

    print(f"Objetivo: {TARGET_ROWS:,}")
    print(f"Actual:   {total:,}")
    print(f"Progreso: {(total / TARGET_ROWS) * 100:.2f}%\n")


if __name__ == "__main__":
    args = parse_args()
    run_seed(args.seed)