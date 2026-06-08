import random


MOTIVOS_INTERNOS = [
    "Proveedor no disponible",
    "Falla logística",
    "Problemas técnicos",
    "Incumplimiento contractual",
    "Falta de personal"
]

MOTIVOS_EXTERNOS = [
    "Condiciones climáticas",
    "Decisión del cliente",
    "Emergencia sanitaria"
]


def create_cancelaciones(
    eventos,
    subcontratos,
    seed=None
):

    rng = random.Random(seed)

    cancelaciones = []
    next_id = 1

    for evento in eventos:

        if evento["estado"] != "Cancelado":
            continue

        subs_del_contrato = [
            s for s in subcontratos
            if s["contrato_id"] == evento["contrato_id"]
        ]

        interna = rng.random() < 0.7

        if interna and subs_del_contrato:

            culpable = rng.choice(subs_del_contrato)

            cancelaciones.append({
                "id": next_id,
                "subcontrato_id": culpable["id"],
                "evento_id": evento["id"],
                "detalle": rng.choice(MOTIVOS_INTERNOS)
            })

        else:

            cancelaciones.append({
                "id": next_id,
                "subcontrato_id": None,
                "evento_id": evento["id"],
                "detalle": rng.choice(MOTIVOS_EXTERNOS)
            })

        next_id += 1

    return cancelaciones