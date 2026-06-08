import random
from datetime import date, timedelta


ESTADOS = [
    "Cumplido",
    "Pendiente",
    "Cancelado"
]


def create_subcontratos(
    contratos,
    servicios,
    zonas,
    seed=None
):

    rng = random.Random(seed)

    servicios_por_zona = {}

    for servicio in servicios:

        zona_id = servicio["zona_id"]

        if zona_id not in servicios_por_zona:
            servicios_por_zona[zona_id] = []

        servicios_por_zona[zona_id].append(servicio)

    subcontratos = []
    next_id = 1

    for contrato in contratos:

        zona_elegida = rng.choice(zonas)["id"]

        disponibles = servicios_por_zona.get(
            zona_elegida,
            []
        )

        if len(disponibles) < 2:
            continue

        cantidad = min(
            rng.randint(2, 6),
            len(disponibles)
        )

        servicios_elegidos = rng.sample(
            disponibles,
            cantidad
        )

        fecha_contrato = date.fromisoformat(
            contrato["fecha_firma"]
        )

        for servicio in servicios_elegidos:

            fecha_subcontrato = (
                fecha_contrato +
                timedelta(days=rng.randint(0, 30))
            )

            subcontratos.append({
                "id": next_id,
                "contrato_id": contrato["id"],
                "servicio_id": servicio["id"],
                "costo": round(
                    rng.uniform(
                        50_000,
                        5_000_000
                    ),
                    2
                ),
                "fecha_firma": fecha_subcontrato.isoformat(),
                "estado": rng.choices(
                    ESTADOS,
                    weights=[70, 20, 10]
                )[0]
            })

            next_id += 1

    return subcontratos