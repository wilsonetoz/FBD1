from fastapi import FastAPI, HTTPException, Depends, status
from typing import List
from datetime import date

from database import get_db_connection
from schemas import (
    Cliente, ClienteCreate, Produto, ProdutoCreate, Pedido, PedidoCreate,
    DetalhesPedidoCliente, ProdutoEmPromocao, TotalVendasPorCategoria
)
import psycopg2

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
else:
    print("Opção inválida! Saindo...")
    exit()

def get_db():
    conn = get_db_connection(user=USER, password=PASSWORD)
    if not conn:
        raise HTTPException(status_code=500, detail="Não foi possível conectar ao banco.")
    try:
        yield conn
    finally:
        conn.close()

app = FastAPI()

# --- Cliente Endpoints

@app.post("/clientes/", response_model=Cliente, status_code=status.HTTP_201_CREATED)
async def create_cliente(cliente: ClienteCreate, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        query = """
        INSERT INTO Cliente (Nome, Email, Telefone, Senha)
        VALUES (%s, %s, %s, %s) RETURNING ID_Cliente, Nome, Email, Telefone, Senha;
        """
        cursor.execute(query, (cliente.Nome, cliente.Email, cliente.Telefone, cliente.Senha))
        new_cliente = cursor.fetchone()
        db.commit()
        if new_cliente:
            return Cliente(
                ID_Cliente=new_cliente[0],
                Nome=new_cliente[1],
                Email=new_cliente[2],
                Telefone=new_cliente[3],
                Senha=new_cliente[4]
            )
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Database error: {e}")
    finally:
        cursor.close()
    raise HTTPException(status_code=500, detail="Failed to create client.")


@app.get("/clientes/", response_model=List[Cliente])
async def read_clientes(db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Cliente, Nome, Email, Telefone, Senha FROM Cliente;")
        clientes = []
        for row in cursor.fetchall():
            clientes.append(Cliente(ID_Cliente=row[0], Nome=row[1], Email=row[2], Telefone=row[3], Senha=row[4]))
        return clientes
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@app.get("/clientes/{cliente_id}", response_model=Cliente)
async def read_cliente(cliente_id: int, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Cliente, Nome, Email, Telefone, Senha FROM Cliente WHERE ID_Cliente = %s;", (cliente_id,))
        cliente = cursor.fetchone()
        if cliente:
            return Cliente(ID_Cliente=cliente[0], Nome=cliente[1], Email=cliente[2], Telefone=cliente[3], Senha=cliente[4])
        raise HTTPException(status_code=404, detail="Cliente not found.")
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@app.put("/clientes/{cliente_id}", response_model=Cliente)
async def update_cliente(cliente_id: int, cliente: ClienteCreate, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        query = """
        UPDATE Cliente SET Nome = %s, Email = %s, Telefone = %s, Senha = %s
        WHERE ID_Cliente = %s RETURNING ID_Cliente, Nome, Email, Telefone, Senha;
        """
        cursor.execute(query, (cliente.Nome, cliente.Email, cliente.Telefone, cliente.Senha, cliente_id))
        updated_cliente = cursor.fetchone()
        db.commit()
        if updated_cliente:
            return Cliente(
                ID_Cliente=updated_cliente[0],
                Nome=updated_cliente[1],
                Email=updated_cliente[2],
                Telefone=updated_cliente[3],
                Senha=updated_cliente[4]
            )
        raise HTTPException(status_code=404, detail="Cliente not found.")
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Database error: {e}")
    finally:
        cursor.close()

@app.delete("/clientes/{cliente_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_cliente(cliente_id: int, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("DELETE FROM Cliente WHERE ID_Cliente = %s;", (cliente_id,))
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Cliente not found.")
        db.commit()
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Database error: {e}")
    finally:
        cursor.close()

# --- Produto Endpoints
@app.post("/produtos/", response_model=Produto, status_code=status.HTTP_201_CREATED)
async def create_produto(produto: ProdutoCreate, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        query = """
        INSERT INTO Produto (Nome, Descricao, Preco, Estoque, ID_Categoria)
        VALUES (%s, %s, %s, %s, %s) RETURNING ID_Produto, Nome, Descricao, Preco, Estoque, ID_Categoria;
        """
        cursor.execute(query, (produto.Nome, produto.Descricao, produto.Preco, produto.Estoque, produto.ID_Categoria))
        new_produto = cursor.fetchone()
        db.commit()
        if new_produto:
            return Produto(
                ID_Produto=new_produto[0],
                Nome=new_produto[1],
                Descricao=new_produto[2],
                Preco=new_produto[3],
                Estoque=new_produto[4],
                ID_Categoria=new_produto[5]
            )
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Database error: {e}")
    finally:
        cursor.close()
    raise HTTPException(status_code=500, detail="Failed to create product.")

@app.get("/produtos/", response_model=List[Produto])
async def read_produtos(db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Produto, Nome, Descricao, Preco, Estoque, ID_Categoria FROM Produto;")
        produtos = []
        for row in cursor.fetchall():
            produtos.append(Produto(ID_Produto=row[0], Nome=row[1], Descricao=row[2], Preco=row[3], Estoque=row[4], ID_Categoria=row[5]))
        return produtos
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

@app.put("/produtos/{produto_id}", response_model=Produto)
async def update_produto(produto_id: int, produto: ProdutoCreate, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        query = """
        UPDATE Produto SET Nome = %s, Descricao = %s, Preco = %s, Estoque = %s, ID_Categoria = %s
        WHERE ID_Produto = %s RETURNING ID_Produto, Nome, Descricao, Preco, Estoque, ID_Categoria;
        """
        cursor.execute(query, (produto.Nome, produto.Descricao, produto.Preco, produto.Estoque, produto.ID_Categoria, produto_id))
        updated_produto = cursor.fetchone()
        db.commit()
        if updated_produto:
            return Produto(
                ID_Produto=updated_produto[0],
                Nome=updated_produto[1],
                Descricao=updated_produto[2],
                Preco=updated_produto[3],
                Estoque=updated_produto[4],
                ID_Categoria=updated_produto[5]
            )
        raise HTTPException(status_code=404, detail="Produto not found.")
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Database error: {e}")
    finally:
        cursor.close()

@app.delete("/produtos/{produto_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_produto(produto_id: int, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("DELETE FROM Produto WHERE ID_Produto = %s;", (produto_id,))
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Produto not found.")
        db.commit()
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Database error: {e}")
    finally:
        cursor.close()

# --- Pedido Endpoints
@app.post("/pedidos/", response_model=Pedido, status_code=status.HTTP_201_CREATED)
async def create_pedido(pedido: PedidoCreate, db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        query = """
        INSERT INTO Pedido (ID_Cliente, Data_Pedido, Estatus_Pedido)
        VALUES (%s, %s, %s) RETURNING ID_Pedido, ID_Cliente, Data_Pedido, Estatus_Pedido;
        """
        cursor.execute(query, (pedido.ID_Cliente, pedido.Data_Pedido, pedido.Estatus_Pedido))
        new_pedido = cursor.fetchone()
        db.commit()
        if new_pedido:
            return Pedido(
                ID_Pedido=new_pedido[0],
                ID_Cliente=new_pedido[1],
                Data_Pedido=new_pedido[2],
                Estatus_Pedido=new_pedido[3]
            )
    except psycopg2.Error as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Database error: {e}")
    finally:
        cursor.close()
    raise HTTPException(status_code=500, detail="Failed to create order.")

@app.get("/pedidos/", response_model=List[Pedido])
async def read_pedidos(db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Pedido, ID_Cliente, Data_Pedido, Estatus_Pedido FROM Pedido;")
        pedidos = []
        for row in cursor.fetchall():
            pedidos.append(Pedido(ID_Pedido=row[0], ID_Cliente=row[1], Data_Pedido=row[2], Estatus_Pedido=row[3]))
        return pedidos
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=f"Database error: {e}")
    finally:
        cursor.close()

# --- View Endpoints

@app.get("/view/detalhes-pedidos-clientes/", response_model=List[DetalhesPedidoCliente])
async def get_detalhes_pedidos_clientes(db: psycopg2.extensions.connection = Depends(get_db)):
    cursor = db.cursor()
    try:
        cursor.execute("SELECT ID_Pedido, Data_Pedido, Estatus_Pedido, Nome_Cliente, Email_Cliente, Telefone_Cliente FROM Detalhes_Pedidos_Com_Cliente;")
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

@app.get("/view/produtos-em-promocao/", response_model=List[ProdutoEmPromocao])
async def get_produtos_em_promocao(db: psycopg2.extensions.connection = Depends(get_db)):
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
        # Inclua Quantidade_Total_Vendida na sua consulta
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
