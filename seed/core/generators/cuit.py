import random

_used_cuits = set()


def generate_cuit(rng):

    while True:
        cuit = f"{rng.randint(20, 34)}-{rng.randint(10000000, 99999999)}-{rng.randint(0, 9)}"

        if cuit not in _used_cuits:
            _used_cuits.add(cuit)
            return cuit