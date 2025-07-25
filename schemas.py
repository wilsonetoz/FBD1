from pydantic import BaseModel
from typing import Optional
from datetime import date

class ClienteBase(BaseModel):
    Nome: str
    Email: str
    Telefone: Optional[str] = None
    Senha: str

class ClienteCreate(ClienteBase):
    ...

class Cliente(ClienteBase):
    ID_Cliente: int

class ClienteUpdate(BaseModel):
    Nome: Optional[str] = None
    Email: Optional[str] = None
    Telefone: Optional[str] = None
    Senha: Optional[str] = None

class EnderecoBase(BaseModel):
    Rua: Optional[str] = None
    Numero: Optional[str] = None
    Bairro: Optional[str] = None
    Cidade: Optional[str] = None
    Estado: Optional[str] = None
    Cep: Optional[str] = None
    Complemento: Optional[str] = None

class EnderecoCreate(EnderecoBase):
    ...

class Endereco(EnderecoBase):
    ID_Endereco: int

class EnderecoClienteBase(BaseModel):
    ID_Cliente: int
    ID_Endereco: int

class EnderecoClienteCreate(EnderecoClienteBase):
    ...

class EnderecoCliente(EnderecoClienteBase):
    ...

class CategoriaBase(BaseModel):
    Nome: str

class CategoriaCreate(CategoriaBase):
    ...

class Categoria(CategoriaBase):
    ID_Categoria: int

class PromocaoBase(BaseModel):
    Descricao: Optional[str] = None
    Valor: Optional[float] = None
    Data_Inicio: Optional[date] = None
    Data_Fim: Optional[date] = None

class PromocaoCreate(PromocaoBase):
    ...

class Promocao(PromocaoBase):
    ID_Promocao: int

class ProdutoBase(BaseModel):
    Nome: str
    Descricao: Optional[str] = None
    Preco: float
    Estoque: int
    ID_Categoria: Optional[int] = None

class ProdutoCreate(ProdutoBase):
    ...

class Produto(ProdutoBase):
    ID_Produto: int

class ProdutoUpdate(BaseModel):
    Nome: Optional[str] = None
    Descricao: Optional[str] = None
    Preco: Optional[float] = None
    Estoque: Optional[int] = None
    ID_Categoria: Optional[int] = None

class ProdutoPromocaoBase(BaseModel):
    ID_Produto: int
    ID_Promocao: int

class ProdutoPromocaoCreate(ProdutoPromocaoBase):
    ...

class ProdutoPromocao(ProdutoPromocaoBase):
    ...

class PedidoBase(BaseModel):
    ID_Cliente: int
    Data_Pedido: date
    Estatus_Pedido: str

class PedidoCreate(PedidoBase):
    ...

class Pedido(PedidoBase):
    ID_Pedido: int

class PedidoUpdate(BaseModel):
    ID_Cliente: Optional[int] = None
    Data_Pedido: Optional[date] = None
    Estatus_Pedido: Optional[str] = None

class ItemPedidoBase(BaseModel):
    ID_Pedido: int
    ID_Produto: int
    Quantidade: int
    Preco_Unitario: float
    Preco_Total: float

class ItemPedidoCreate(ItemPedidoBase):
    ...

class ItemPedido(ItemPedidoBase):
    ID_Item: int

class AvaliacaoBase(BaseModel):
    ID_Cliente: int
    ID_Produto: int
    Data_Avaliacao: date
    Nota: int
    Comentario: Optional[str] = None

class AvaliacaoCreate(AvaliacaoBase):
    ...

class Avaliacao(AvaliacaoBase):
    ID_Avaliacao: int


class DetalhesPedidoCliente(BaseModel):
    ID_Pedido: int
    Data_Pedido: date
    Estatus_Pedido: str
    Nome_Cliente: str
    Email_Cliente: str
    Telefone_Cliente: Optional[str]

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

class TotalVendasPorCategoria(BaseModel):
    Nome_Categoria: str
    Valor_Total_Vendas: float
    Quantidade_Total_Vendida: int
