import random
from faker import Faker

fake = Faker()

def create_zonas(ciudades, seed=None):

    rng = random.Random(seed)
    Faker.seed(seed)

    zonas = []

    for ciudad in ciudades:
        ciudad_id = ciudad["id"]

        cantidad = rng.randint(1, 5)

        for i in range(cantidad):
            zonas.append({
                "ciudad_id": ciudad_id,
                "nombre_zona": f"Zona {i+1}",
                "codigo_postal": fake.postcode(),
                "descripcion": fake.sentence(nb_words=8)
            })

    return zonas