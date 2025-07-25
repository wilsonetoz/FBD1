import psycopg2
from psycopg2 import Error
from fastapi import HTTPException

def get_db_connection(user, password, db_name="ecomerce", host="localhost", port="5432"):
    conn = None
    try:
        conn = psycopg2.connect(
            user=user,
            password=password,
            host=host,
            port=port,
            database=db_name
        )
        return conn
    except Error as e:
        print(f"Error connecting to PostgreSQL database: {e}")
        return None

def get_db_session(user: str, password: str):
    conn = get_db_connection(user=user, password=password)
    if not conn:
        raise HTTPException(status_code=500, detail="Não foi possível conectar ao banco de dados.")
    try:
        yield conn
    finally:
        conn.close()
