# README.md

## EmpresaEventos

Proyecto académico de Base de Datos para la gestión de eventos, contratos, servicios y proveedores.

---

## Requisitos

* Python 3.12+
* SQL Server 2022 (o compatible)
* ODBC Driver 18 for SQL Server
* Git

---

## Clonar repositorio

```bash
git clone <repo>
cd proyectoFinal_db
```

---

## Crear entorno virtual

Windows:

```bash
python -m venv venv
venv\Scripts\activate
```

Linux/Mac:

```bash
python -m venv venv
source venv/bin/activate
```

---

## Instalar dependencias

```bash
pip install -r requirements.txt
```

---

## Archivo de configuración

Crear un archivo `.env` en la carpeta /db del proyecto.

Ejemplo:

```env
DB_SERVER=localhost
DB_USER=
DB_PASSWORD=
DB_TRUSTED=yes
```

> [!IMPORTANT]
> Añadir "DB_NAME=EmpresaEventos" al .env una vez creada la db (se puede añadir desde antes de crearla)
---

## Crear base de datos

Desde la carpeta `db`:

```bash
cd db
python create_db.py
```

---

## Generar dataset

Desde la carpeta `seed`:

```bash
python run_seed.py
```

Los CSV generados quedarán en:

```text
seed/data/
```

---

## Configurar semilla global

La semilla se encuentra en:

```python
seed/run_seed.py
```

Modificar:

```python
SEED = 42
```

para generar un dataset distinto.

Mientras la semilla sea la misma, los datos generados serán reproducibles.

---

## Estructura principal

```text
db/
    create_db.py

seed/
    factories/
    pipeline/
    core/
    data/

scripts_sql/
```
