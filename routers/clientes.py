from fastapi import APIRouter, HTTPException, Depends, status
from typing import List
import psycopg2

from schemas import Cliente, ClienteCreate, ClienteUpdate
from dependencies import get_db

router = APIRouter(
    prefix="/clientes",
    tags=["Clientes"]
)

@router.post("/", response_model=Cliente, status_code=status.HTTP_201_CREATED)
async def create_cliente(cliente: ClienteCreate, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        query = """
        INSERT INTO Cliente (Nome, Email, Telefone, Senha)
        VALUES (%s, %s, %s, %s) RETURNING ID_Cliente, Nome, Email, Telefone, Senha;
        """
        cursor.execute(query, (cliente.Nome, cliente.Email, cliente.Telefone, cliente.Senha))
        new_cliente_data = cursor.fetchone()
        db.commit()
        if new_cliente_data:
            return Cliente(
                ID_Cliente=new_cliente_data[0],
                Nome=new_cliente_data[1],
                Email=new_cliente_data[2],
                Telefone=new_cliente_data[3],
                Senha=new_cliente_data[4]
            )
        raise HTTPException(status_code=500, detail="Cliente não criado")
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@router.get("/", response_model=List[Cliente])
async def get_clientes(db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Cliente, Nome, Email, Telefone, Senha FROM Cliente;")
        results = []
        for row in cursor.fetchall():
            results.append(Cliente(
                ID_Cliente=row[0],
                Nome=row[1],
                Email=row[2],
                Telefone=row[3],
                Senha=row[4]
            ))
        return results
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@router.get("/{cliente_id}", response_model=Cliente)
async def get_cliente(cliente_id: int, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Cliente, Nome, Email, Telefone, Senha FROM Cliente WHERE ID_Cliente = %s;", (cliente_id,))
        cliente_data = cursor.fetchone()
        if cliente_data:
            return Cliente(
                ID_Cliente=cliente_data[0],
                Nome=cliente_data[1],
                Email=cliente_data[2],
                Telefone=cliente_data[3],
                Senha=cliente_data[4]
            )
        raise HTTPException(status_code=404, detail="Cliente não encontrado")
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@router.patch("/{cliente_id}", response_model=Cliente)
async def update_cliente(cliente_id: int, cliente: ClienteUpdate, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Cliente FROM Cliente WHERE ID_Cliente = %s;", (cliente_id,))
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="Cliente não encontrado")

        update_fields = []
        update_values = []


        for field, value in cliente.dict(exclude_unset=True).items():
            update_fields.append(f"{field} = %s")
            update_values.append(value)

        if not update_fields:
            raise HTTPException(status_code=400, detail="Nenhum campo para atualizar fornecido.")

        query = f"UPDATE Cliente SET {', '.join(update_fields)} WHERE ID_Cliente = %s RETURNING ID_Cliente, Nome, Email, Telefone, Senha;"
        update_values.append(cliente_id)

        cursor.execute(query, tuple(update_values))
        updated_cliente_data = cursor.fetchone()
        db.commit()

        if updated_cliente_data:
            return Cliente(
                ID_Cliente=updated_cliente_data[0],
                Nome=updated_cliente_data[1],
                Email=updated_cliente_data[2],
                Telefone=updated_cliente_data[3],
                Senha=updated_cliente_data[4]
            )
        raise HTTPException(status_code=500, detail="Erro desconhecido ao atualizar cliente.")
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@router.delete("/{cliente_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_cliente(cliente_id: int, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("DELETE FROM Cliente WHERE ID_Cliente = %s RETURNING ID_Cliente;", (cliente_id,))
        deleted_id = cursor.fetchone()
        db.commit()
        if not deleted_id:
            raise HTTPException(status_code=404, detail="Cliente não encontrado")
        return {}
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()