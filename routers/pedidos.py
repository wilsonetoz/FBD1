from fastapi import APIRouter, HTTPException, Depends, status
from typing import List
import psycopg2

from schemas import Pedido, PedidoCreate, PedidoUpdate
from dependencies import get_db

router = APIRouter(
    prefix="/pedidos",
    tags=["Pedidos"]
)

@router.post("/", response_model=Pedido, status_code=status.HTTP_201_CREATED)
async def create_pedido(pedido: PedidoCreate, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        query = """
        INSERT INTO Pedido (ID_Cliente, Data_Pedido, Estatus_Pedido)
        VALUES (%s, %s, %s) RETURNING ID_Pedido, ID_Cliente, Data_Pedido, Estatus_Pedido;
        """
        cursor.execute(query, (pedido.ID_Cliente, pedido.Data_Pedido, pedido.Estatus_Pedido))
        new_pedido_data = cursor.fetchone()
        db.commit()
        if new_pedido_data:
            return Pedido(
                ID_Pedido=new_pedido_data[0],
                ID_Cliente=new_pedido_data[1],
                Data_Pedido=new_pedido_data[2],
                Estatus_Pedido=new_pedido_data[3]
            )
        raise HTTPException(status_code=500, detail="Pedido não criado")
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@router.get("/", response_model=List[Pedido])
async def get_pedidos(db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Pedido, ID_Cliente, Data_Pedido, Estatus_Pedido FROM Pedido;")
        results = []
        for row in cursor.fetchall():
            results.append(Pedido(
                ID_Pedido=row[0],
                ID_Cliente=row[1],
                Data_Pedido=row[2],
                Estatus_Pedido=row[3]
            ))
        return results
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@router.get("/{pedido_id}", response_model=Pedido)
async def get_pedido(pedido_id: int, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Pedido, ID_Cliente, Data_Pedido, Estatus_Pedido FROM Pedido WHERE ID_Pedido = %s;", (pedido_id,))
        pedido_data = cursor.fetchone()
        if pedido_data:
            return Pedido(
                ID_Pedido=pedido_data[0],
                ID_Cliente=pedido_data[1],
                Data_Pedido=pedido_data[2],
                Estatus_Pedido=pedido_data[3]
            )
        raise HTTPException(status_code=404, detail="Pedido não encontrado")
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@router.patch("/{pedido_id}", response_model=Pedido)
async def update_pedido(pedido_id: int, pedido: PedidoUpdate, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Pedido FROM Pedido WHERE ID_Pedido = %s;", (pedido_id,))
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="Pedido não encontrado")

        update_fields = []
        update_values = []

        for field, value in pedido.dict(exclude_unset=True).items():
            update_fields.append(f"{field} = %s")
            update_values.append(value)

        if not update_fields:
            raise HTTPException(status_code=400, detail="Nenhum campo para atualizar fornecido.")

        query = f"UPDATE Pedido SET {', '.join(update_fields)} WHERE ID_Pedido = %s RETURNING ID_Pedido, ID_Cliente, Data_Pedido, Estatus_Pedido;"
        update_values.append(pedido_id)

        cursor.execute(query, tuple(update_values))
        updated_pedido_data = cursor.fetchone()
        db.commit()

        if updated_pedido_data:
            return Pedido(
                ID_Pedido=updated_pedido_data[0],
                ID_Cliente=updated_pedido_data[1],
                Data_Pedido=updated_pedido_data[2],
                Estatus_Pedido=updated_pedido_data[3]
            )
        raise HTTPException(status_code=500, detail="Erro desconhecido ao atualizar pedido.")
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@router.delete("/{pedido_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_pedido(pedido_id: int, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("DELETE FROM Pedido WHERE ID_Pedido = %s RETURNING ID_Pedido;", (pedido_id,))
        deleted_id = cursor.fetchone()
        db.commit()
        if not deleted_id:
            raise HTTPException(status_code=404, detail="Pedido não encontrado")
        return {}
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()