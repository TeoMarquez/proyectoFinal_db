import random
from datetime import date, timedelta


TIPOS_EVENTO = [
    "Casamiento",
    "Cumpleaños",
    "Congreso",
    "Conferencia",
    "Recital",
    "Festival",
    "Evento Corporativo",
    "Feria",
    "Graduacion"
]

ESTADOS = [
    "Cumplido",
    "Pendiente",
    "Cancelado"
]


def create_contratos(clientes, seed=None):

    rng = random.Random(seed)

    contratos = []
    next_id = 1

    for cliente in clientes:

        cantidad = rng.randint(1, 5)

        for _ in range(cantidad):

            fecha_firma = date(
                rng.randint(2021, 2026),
                rng.randint(1, 12),
                rng.randint(1, 28)
            )

            fecha_programada = fecha_firma + timedelta(
                days=rng.randint(15, 365)
            )

            contratos.append({
                "id": next_id,
                "cliente_id": cliente["id"],
                "fecha_firma": fecha_firma.isoformat(),
                "fecha_programada": fecha_programada.isoformat(),
                "presupuesto_acordado": round(
                    rng.uniform(100_000, 15_000_000),
                    2
                ),
                "informacion": f"Contrato para {rng.choice(TIPOS_EVENTO)}",
                "tipo_evento": rng.choice(TIPOS_EVENTO),
                "estado": rng.choices(
                    ESTADOS,
                    weights=[70, 20, 10]
                )[0]
            })

            next_id += 1

    return contratos