import pyodbc
import os
from dotenv import load_dotenv

load_dotenv()

def get_connection(database="master"):
    server = os.getenv("DB_SERVER")
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    trusted = os.getenv("DB_TRUSTED", "yes")

    print("\n[DB] Intentando conectar...")
    print(f"[DB] Server: {server}")
    print(f"[DB] Database: {database}")
    print(f"[DB] Auth mode: {'SQL Auth' if user else 'Windows Auth'}")

    conn_str = (
        "DRIVER={ODBC Driver 18 for SQL Server};"
        f"SERVER={server};"
        f"DATABASE={database};"
    )

    if user and password:
        conn_str += f"UID={user};PWD={password};"
    else:
        conn_str += "Trusted_Connection=yes;"

    conn_str += "TrustServerCertificate=yes;"

    try:
        conn = pyodbc.connect(conn_str, autocommit=True)
        print("[DB] Conexión exitosa")
        return conn
    except Exception as e:
        print("[DB] ERROR al conectar")
        print("[DB] Connection string (sin password):")
        print(conn_str.replace(password or "", "***"))
        print("\n[DB] Error:")
        print(e)
        raise