import random

TIPOS_INGRESO = [
    "Entradas",
    "Patrocinio",
    "Merchandising",
    "Buffet"
]


def create_ingresos_evento(eventos, seed=None):

    rng = random.Random(seed)

    ingresos = []
    next_id = 1

    for evento in eventos:

        cantidad = rng.randint(1, 4)

        tipos = rng.sample(
            TIPOS_INGRESO,
            cantidad
        )

        for tipo in tipos:

            ingresos.append({
                "id": next_id,
                "evento_id": evento["id"],
                "tipo_ingreso": tipo,
                "monto": round(
                    rng.uniform(
                        50_000,
                        20_000_000
                    ),
                    2
                )
            })

            next_id += 1

    return ingresos