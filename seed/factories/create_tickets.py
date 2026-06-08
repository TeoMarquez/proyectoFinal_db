import random

TIPOS_TICKET = [
    "General",
    "VIP",
    "Premium",
    "Backstage"
]


def create_tickets(eventos, seed=None):

    rng = random.Random(seed)

    tickets = []
    next_id = 1

    for evento in eventos:

        cantidad_tipos = rng.randint(1, 4)

        tipos = rng.sample(
            TIPOS_TICKET,
            cantidad_tipos
        )

        for tipo in tipos:

            tickets.append({
                "id": next_id,
                "evento_id": evento["id"],
                "tipo": tipo,
                "precio": round(
                    rng.uniform(5000, 150000),
                    2
                ),
                "cantidad_vendida": rng.randint(
                    0,
                    evento["cantidad_asistentes"]
                )
            })

            next_id += 1

    return tickets