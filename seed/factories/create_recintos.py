from faker import Faker
import random


def create_recintos(servicios, seed=None):

    rng = random.Random(seed)

    fake = Faker("es_AR")
    Faker.seed(seed)

    recintos = []
    next_id = 1

    for servicio in servicios:

        if servicio["categoria"] != "Recinto":
            continue

        recintos.append({
            "id": next_id,
            "servicio_id": servicio["id"],
            "nombre": f"{servicio['nombre']} {next_id}",
            "capacidad": rng.randint(50, 5000),
            "direccion": fake.street_address()
        })

        next_id += 1

    return recintos