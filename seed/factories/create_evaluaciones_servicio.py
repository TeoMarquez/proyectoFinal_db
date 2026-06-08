import random


COMENTARIOS_POSITIVOS = [
    "Excelente servicio",
    "Muy recomendable",
    "Cumplió expectativas",
    "Gran profesionalismo",
    "Servicio satisfactorio"
]

COMENTARIOS_NEGATIVOS = [
    "Incumplimiento del servicio",
    "Problemas operativos",
    "Bajo rendimiento",
    "Demoras importantes",
    "Mala experiencia"
]


def create_evaluaciones_servicio(
    subcontratos,
    cancelaciones,
    seed=None
):

    rng = random.Random(seed)

    evaluaciones = []
    next_id = 1

    subcontratos_culpables = {
        c["subcontrato_id"]
        for c in cancelaciones
        if c["subcontrato_id"] is not None
    }

    for sub in subcontratos:

        if sub["id"] in subcontratos_culpables:

            evaluaciones.append({
                "id": next_id,
                "subcontrato_id": sub["id"],
                "calificacion_rendimiento": rng.randint(0, 3),
                "calificacion_costo": rng.randint(0, 10),
                "comentario": rng.choice(COMENTARIOS_NEGATIVOS)
            })

            next_id += 1

            continue

        if sub["estado"] != "Cumplido":
            continue

        evaluaciones.append({
            "id": next_id,
            "subcontrato_id": sub["id"],
            "calificacion_rendimiento": rng.randint(5, 10),
            "calificacion_costo": rng.randint(0, 10),
            "comentario": rng.choice(COMENTARIOS_POSITIVOS)
        })

        next_id += 1

    return evaluaciones