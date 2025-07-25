from fastapi import APIRouter, HTTPException, Depends, status
from typing import List
import psycopg2

from schemas import Produto, ProdutoCreate, ProdutoUpdate
from dependencies import get_db

router = APIRouter(
    prefix="/produtos",
    tags=["Produtos"]
)

@router.post("/", response_model=Produto, status_code=status.HTTP_201_CREATED)
async def create_produto(produto: ProdutoCreate, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        query = """
        INSERT INTO Produto (Nome, Descricao, Preco, Estoque, ID_Categoria)
        VALUES (%s, %s, %s, %s, %s) RETURNING ID_Produto, Nome, Descricao, Preco, Estoque, ID_Categoria;
        """
        cursor.execute(query, (produto.Nome, produto.Descricao, produto.Preco, produto.Estoque, produto.ID_Categoria))
        new_produto_data = cursor.fetchone()
        db.commit()
        if new_produto_data:
            return Produto(
                ID_Produto=new_produto_data[0],
                Nome=new_produto_data[1],
                Descricao=new_produto_data[2],
                Preco=new_produto_data[3],
                Estoque=new_produto_data[4],
                ID_Categoria=new_produto_data[5]
            )
        raise HTTPException(status_code=500, detail="Produto não criado")
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@router.get("/", response_model=List[Produto])
async def get_produtos(db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Produto, Nome, Descricao, Preco, Estoque, ID_Categoria FROM Produto;")
        results = []
        for row in cursor.fetchall():
            results.append(Produto(
                ID_Produto=row[0],
                Nome=row[1],
                Descricao=row[2],
                Preco=row[3],
                Estoque=row[4],
                ID_Categoria=row[5]
            ))
        return results
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@router.get("/{produto_id}", response_model=Produto)
async def get_produto(produto_id: int, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Produto, Nome, Descricao, Preco, Estoque, ID_Categoria FROM Produto WHERE ID_Produto = %s;", (produto_id,))
        produto_data = cursor.fetchone()
        if produto_data:
            return Produto(
                ID_Produto=produto_data[0],
                Nome=produto_data[1],
                Descricao=produto_data[2],
                Preco=produto_data[3],
                Estoque=produto_data[4],
                ID_Categoria=produto_data[5]
            )
        raise HTTPException(status_code=404, detail="Produto não encontrado")
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@router.patch("/{produto_id}", response_model=Produto)
async def update_produto(produto_id: int, produto: ProdutoUpdate, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Produto FROM Produto WHERE ID_Produto = %s;", (produto_id,))
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="Produto não encontrado")

        update_fields = []
        update_values = []

        for field, value in produto.dict(exclude_unset=True).items():
            update_fields.append(f"{field} = %s")
            update_values.append(value)

        if not update_fields:
            raise HTTPException(status_code=400, detail="Nenhum campo para atualizar fornecido.")

        query = f"UPDATE Produto SET {', '.join(update_fields)} WHERE ID_Produto = %s RETURNING ID_Produto, Nome, Descricao, Preco, Estoque, ID_Categoria;"
        update_values.append(produto_id)

        cursor.execute(query, tuple(update_values))
        updated_produto_data = cursor.fetchone()
        db.commit()

        if updated_produto_data:
            return Produto(
                ID_Produto=updated_produto_data[0],
                Nome=updated_produto_data[1],
                Descricao=updated_produto_data[2],
                Preco=updated_produto_data[3],
                Estoque=updated_produto_data[4],
                ID_Categoria=updated_produto_data[5]
            )
        raise HTTPException(status_code=500, detail="Erro desconhecido ao atualizar produto.")
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@router.delete("/{produto_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_produto(produto_id: int, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("DELETE FROM Produto WHERE ID_Produto = %s RETURNING ID_Produto;", (produto_id,))
        deleted_id = cursor.fetchone()
        db.commit()
        if not deleted_id:
            raise HTTPException(status_code=404, detail="Produto não encontrado")
        return {}
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()