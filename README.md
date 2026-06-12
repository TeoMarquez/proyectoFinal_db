# EmpresaEventos

Proyecto académico de Base de Datos para la gestión de eventos, contratos, servicios y proveedores.

Pipeline completo de generación de datos + carga masiva en SQL Server.

---

## ⚙️ Requisitos

* Python 3.12+
* SQL Server 2022 (o compatible)
* ODBC Driver 18 for SQL Server
* Git

---

## 📥 Instalación

```bash
git clone <repo>
cd proyectoFinal_db
```

### 🧪 Entorno virtual

**Windows**

```bash
python -m venv venv
venv\Scripts\activate
```

**Linux / Mac**

```bash
python -m venv venv
source venv/bin/activate
```

### 📦 Dependencias

```bash
pip install -r requirements.txt
```

### ⚙️ Configuración (.env)

Crear archivo `.env` en `/db`:

```env
DB_SERVER=localhost
DB_USER=
DB_PASSWORD=
DB_TRUSTED=yes
DB_NAME=EmpresaEventos
```

---

## 🚀 Ejecución del pipeline

### ▶️ Ejecución completa (default)

```bash
python run.py
```

Ejecuta:

1. Create DB
2. Seed dataset
3. Load CSVs (BULK INSERT)

### 🧹 Reset completo (drop)

```bash
python run.py --del
```

Elimina la base de datos y finaliza el programa.

### 🌱 Seed con semilla personalizada

```bash
python run.py --seed 123
```

Si no se especifica:

```text
seed = 42
```

---

## 🧬 Pipeline interno

```text
run.py
 ├── delete_db (opcional)
 ├── create_db
 ├── seed generator (CSV)
 └── load bulk insert
```

---

## 📝 Logs de ejecución

Cada ejecución del proceso de carga genera automáticamente un archivo de log.

Ubicación:

```text
logs/
```

Formato:

```text
load_YYYY-MM-DD_HH-MM-SS.log
```

Los logs registran:

* Tablas cargadas correctamente
* Timestamp de ejecución
* Errores de SQL Server
* Tracebacks completos de Python
* Archivo CSV involucrado
* Resumen final de carga

Ejemplo:

```text
[OK] table=cliente
[OK] table=proveedor

[SUMMARY]
Loaded tables: 14/14

[END] LOAD PROCESS SUCCESS
```

Si ocurre un error durante la carga, revisar el archivo más reciente dentro de la carpeta `logs/`.

---

## 📁 Estructura del proyecto

```text
db/
    create_db.py
    connection.py
    tooling/
        delete_db.py

seed/
    factories/
    pipeline/
    data/              # CSV generados

load/
    load.py

logs/                  # Logs de ejecución

scripts_sql/
    01_schema.sql
    02_views.sql
    03_procedures.sql
    04_triggers.sql

run.py
```

---

## 📊 Dataset reproducible

* Misma seed → mismos datos
* Distinta seed → dataset diferente

---

## 🧠 Notas importantes

* Uso de `BULK INSERT` para carga masiva eficiente
* `KEEPIDENTITY` para mantener IDs del dataset generado
* El orden de carga es crítico por dependencias de claves foráneas
* Cada ejecución genera un log independiente para facilitar el diagnóstico de errores
* Los logs se almacenan en la carpeta `logs/`
