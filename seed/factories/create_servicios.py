import random


CATEGORIAS = {
    "Recinto": [
        "Salon",
        "Centro de Convenciones",
        "Auditorio"
    ],
    "Catering": [
        "Catering Premium",
        "Servicio Gastronomico"
    ],
    "Sonido": [
        "Audio Profesional",
        "DJ"
    ],
    "Iluminacion": [
        "Iluminacion Escenica",
        "Luces LED"
    ],
    "Seguridad": [
        "Seguridad Privada",
        "Control de Accesos"
    ],
    "Fotografia": [
        "Fotografia Profesional",
        "Cobertura Multimedia"
    ],
    "Decoracion": [
        "Ambientacion",
        "Decoracion Tematica"
    ],
    "Transporte": [
        "Traslado Ejecutivo",
        "Logistica"
    ],
    "Streaming": [
        "Streaming HD",
        "Produccion Audiovisual"
    ]
}


def create_servicios(zonas, proveedores, seed=None):

    rng = random.Random(seed)

    servicios = []
    next_id = 1

    for proveedor in proveedores:

        cantidad = rng.randint(2, 8)

        for _ in range(cantidad):

            categoria = rng.choice(list(CATEGORIAS.keys()))

            servicios.append({
                "id": next_id,
                "zona_id": rng.choice(zonas)["id"],
                "proveedor_id": proveedor["id"],
                "categoria": categoria,
                "nombre": rng.choice(CATEGORIAS[categoria]),
                "descripcion": f"Servicio de {categoria}"
            })

            next_id += 1

    return servicios