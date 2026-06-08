from faker import Faker
import random

from core.generators.cuit import generate_cuit


def create_clientes(seed=None):

    rng = random.Random(seed)

    fake = Faker("es_AR")
    Faker.seed(seed)

    clientes = []

    total = rng.randint(4000, 8000)

    for _ in range(total):

        clientes.append({
            "nombre": fake.company(),
            "cuit": generate_cuit(rng),
            "telefono": fake.phone_number(),
            "email": fake.company_email()
        })

    return clientes