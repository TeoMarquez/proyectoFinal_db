from factories.create_provincias import create_provincias
from factories.cargar_ciudades import load_ciudades
from factories.create_zonas import create_zonas

from pipeline.dump.provincias import dump_provincias
# from pipeline.dump.ciudades import dump_ciudades (ya existente)
from pipeline.dump.zonas import dump_zonas


SEED = 42


def main():

    print("[SEED] Generando provincias...")
    provincias = create_provincias()
    dump_provincias(provincias)

    print("[SEED] Cargando ciudades...")
    ciudades = load_ciudades()
#   dump_ciudades(ciudades) (ya existente)

    print("[SEED] Generando zonas...")
    zonas = create_zonas(ciudades, seed=SEED)
    dump_zonas(zonas)

    print("[SEED] DONE ✔")


if __name__ == "__main__":
    main()