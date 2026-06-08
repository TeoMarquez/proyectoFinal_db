from db.connection import get_connection


def delete_db():
    conn = get_connection("master")
    cursor = conn.cursor()

    cursor.execute("""
    ALTER DATABASE EmpresaEventos SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EmpresaEventos;
    """)

    conn.commit()
    cursor.close()
    conn.close()

    print("[OK] Database dropped")