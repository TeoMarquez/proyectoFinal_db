from faker import Faker
import random

from seed.pipeline.generators.cuit import generate_cuit


def create_proveedores(seed=None):

    rng = random.Random(seed)

    fake = Faker("es_AR")
    Faker.seed(seed)

    proveedores = []

    total = rng.randint(2000, 4000)

    for i in range(total):

        proveedores.append({
            "id": i + 1,
            "nombre": fake.company(),
            "cuit": generate_cuit(rng),
            "telefono": fake.phone_number(),
            "email": fake.company_email()
        })

    return proveedores