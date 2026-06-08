import random


def create_eventos(contratos, seed=None):

    rng = random.Random(seed)

    eventos = []

    for contrato in contratos:

        estado_contrato = contrato["estado"]

        if estado_contrato == "Cumplido":
            estado_evento = "Exitoso"

        elif estado_contrato == "Cancelado":
            estado_evento = "Cancelado"

        else:
            estado_evento = "Pendiente"

        eventos.append({
            "id": contrato["id"],
            "contrato_id": contrato["id"],
            "nombre": f"{contrato['tipo_evento']} #{contrato['id']}",
            "fecha_real": contrato["fecha_programada"],
            "estado": estado_evento,
            "cantidad_asistentes": rng.randint(20, 5000)
        })

    return eventos