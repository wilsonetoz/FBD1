import psycopg2
from fastapi import HTTPException
from database import get_db_session

_db_user = None
_db_password = None

def set_db_credentials(user: str, password: str):
    global _db_user, _db_password
    _db_user = user
    _db_password = password

def get_db():
    if _db_user is None or _db_password is None:
        raise RuntimeError("Credenciais do banco de dados não foram definidas. "
                           "Certifique-se de chamar set_db_credentials() em main.py.")
    yield from get_db_session(user=_db_user, password=_db_password)