import psycopg2
from psycopg2 import Error

def get_db_connection(user, password, db_name="ecomerce", host="localhost", port="5432"):
    """Establishes and returns a database connection."""
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