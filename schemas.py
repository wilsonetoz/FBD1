from pydantic import BaseModel
from typing import Optional
from datetime import date

class ClienteBase(BaseModel):
    Nome: str
    Email: str
    Telefone: Optional[str] = None
    Senha: str

class ClienteCreate(ClienteBase):
    pass

class Cliente(ClienteBase):
    ID_Cliente: int

    class Config:
        orm_mode = True

class ProdutoBase(BaseModel):
    Nome: str
    Descricao: Optional[str] = None
    Preco: float
    Estoque: int
    ID_Categoria: Optional[int] = None

class ProdutoCreate(ProdutoBase):
    pass

class Produto(ProdutoBase):
    ID_Produto: int

    class Config:
        orm_mode = True

class PedidoBase(BaseModel):
    ID_Cliente: int
    Data_Pedido: date
    Estatus_Pedido: str

class PedidoCreate(PedidoBase):
    pass

class Pedido(PedidoBase):
    ID_Pedido: int

    class Config:
        orm_mode = True

class DetalhesPedidoCliente(BaseModel):
    ID_Pedido: int
    Data_Pedido: date
    Estatus_Pedido: str
    Nome_Cliente: str
    Email_Cliente: str
    Telefone_Cliente: Optional[str]

    class Config:
        orm_mode = True

class ProdutoEmPromocao(BaseModel):
    ID_Produto: int
    Nome_Produto: str
    Preco_Original: float
    Descricao_Promocao: str
    Valor_Desconto: float
    Preco_Com_Desconto: float
    Data_Inicio: date
    Data_Fim: date
    Nome_Categoria: str

    class Config:
        orm_mode = True

class TotalVendasPorCategoria(BaseModel):
    Nome_Categoria: str
    Valor_Total_Vendas: float
    Quantidade_Total_Vendida: int # Adicione esta linha

    class Config:
        orm_mode = True