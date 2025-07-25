from fastapi import FastAPI, HTTPException, Depends, status
from typing import List
from datetime import date
import psycopg2

from dependencies import set_db_credentials, get_db

USER = ""
PASSWORD = "Vagalinha"

print("Escolha o modo de acesso ao banco:")
print("1 - Admin (leitura e escrita)")
print("2 - Usuário (somente leitura)")
opcao = input("Digite 1 ou 2: ")

if opcao == "1":
    USER = "admin_user"
elif opcao == "2":
    USER = "readonly_user"
    PASSWORD = "Vagalinha"
else:
    print("Opção inválida! Saindo...")
    exit()

set_db_credentials(USER, PASSWORD)

app = FastAPI()

from routers import clientes
from routers import produtos
from routers import pedidos

app.include_router(clientes.router)
app.include_router(produtos.router)
app.include_router(pedidos.router)

from schemas import (
    DetalhesPedidoCliente, ProdutoEmPromocao, TotalVendasPorCategoria
)

@app.get("/view/detalhes-pedidos-com-cliente/", response_model=List[DetalhesPedidoCliente])
async def get_detalhes_pedidos_com_cliente(db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Pedido, Data_Pedido, Estatus_Pedido, Nome_Cliente, Email_Cliente, Telefone_Cliente FROM detalhes_pedidos_com_cliente;")
        results = []
        for row in cursor.fetchall():
            results.append(DetalhesPedidoCliente(
                ID_Pedido=row[0],
                Data_Pedido=row[1],
                Estatus_Pedido=row[2],
                Nome_Cliente=row[3],
                Email_Cliente=row[4],
                Telefone_Cliente=row[5]
            ))
        return results
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@app.get("/view/produtos-em-promocao-com-categoria/", response_model=List[ProdutoEmPromocao])
async def get_produtos_em_promocao_com_categoria(db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Produto, Nome_Produto, Preco_Original, Descricao_Promocao, Valor_Desconto, Preco_Com_Desconto, Data_Inicio, Data_Fim, Nome_Categoria FROM Produtos_Em_Promocao_Com_Categoria;")
        results = []
        for row in cursor.fetchall():
            results.append(ProdutoEmPromocao(
                ID_Produto=row[0],
                Nome_Produto=row[1],
                Preco_Original=row[2],
                Descricao_Promocao=row[3],
                Valor_Desconto=row[4],
                Preco_Com_Desconto=row[5],
                Data_Inicio=row[6],
                Data_Fim=row[7],
                Nome_Categoria=row[8]
            ))
        return results
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@app.get("/view/total-vendas-por-categoria/", response_model=List[TotalVendasPorCategoria])
async def get_total_vendas_por_categoria(db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT Nome_Categoria, Valor_Total_Vendas, Quantidade_Total_Vendida FROM Total_Vendas_Por_Categoria;")
        results = []
        for row in cursor.fetchall():
            results.append(TotalVendasPorCategoria(
                Nome_Categoria=row[0],
                Valor_Total_Vendas=row[1],
                Quantidade_Total_Vendida=row[2]
            ))
        return results
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()
