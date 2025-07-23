-- ARQUIVO SQL - ENTREGA 3: Sistema de E-commerce (Loja Virtual)

-- TABELA: Cliente
CREATE TABLE Cliente (
    ID_Cliente SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefone VARCHAR(20),
    Senha VARCHAR(100) NOT NULL
);

-- TABELA: Endereco
CREATE TABLE Endereco (
    ID_Endereco SERIAL PRIMARY KEY,
    Rua VARCHAR(100),
    Numero VARCHAR(10),
    Bairro VARCHAR(50),
    Cidade VARCHAR(50),
    Estado CHAR(2),
    Cep CHAR(9),
    Complemento VARCHAR(100)
);

-- TABELA: EnderecoCliente (Associação)
CREATE TABLE EnderecoCliente (
    ID_Cliente INT,
    ID_Endereco INT,
    PRIMARY KEY (ID_Cliente, ID_Endereco),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    FOREIGN KEY (ID_Endereco) REFERENCES Endereco(ID_Endereco)
);

-- TABELA: Categoria
CREATE TABLE Categoria (
    ID_Categoria SERIAL PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL
);

-- TABELA: Promocao
CREATE TABLE Promocao (
    ID_Promocao SERIAL PRIMARY KEY,
    Descricao VARCHAR(100),
    Valor DECIMAL(10,2),
    Data_Inicio DATE,
    Data_Fim DATE
);

-- TABELA: Produto
CREATE TABLE Produto (
    ID_Produto SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao TEXT,
    Preco DECIMAL(10,2) NOT NULL,
    Estoque INT NOT NULL,
    ID_Categoria INT,
    FOREIGN KEY (ID_Categoria) REFERENCES Categoria(ID_Categoria)
);
-- Criar tabela ProdutoPromocao (Relacionamento N:N)
CREATE TABLE ProdutoPromocao (
    ID_Produto INT,
    ID_Promocao INT,
    PRIMARY KEY (ID_Produto, ID_Promocao),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto),
    FOREIGN KEY (ID_Promocao) REFERENCES Promocao(ID_Promocao)
);

-- TABELA: Pedido
CREATE TABLE Pedido (
    ID_Pedido SERIAL PRIMARY KEY,
    ID_Cliente INT,
    Data_Pedido DATE NOT NULL,
        Estatus_Pedido VARCHAR(20) CHECK (Estatus_Pedido IN ('em_preparo', 'enviado', 'entregue')) NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);

-- TABELA: ItemPedido (Associação entre Pedido e Produto)
CREATE TABLE ItemPedido (
    ID_Item SERIAL PRIMARY KEY,
    ID_Pedido INT,
    ID_Produto INT,
    Quantidade INT,
    Preco_Unitario DECIMAL(10,2),
    Preco_Total DECIMAL(10,2),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);
-- TABELA: NotaFiscal (Relacionamento 1:1 com Pedido)
CREATE TABLE NotaFiscal (
    ID_Pedido INT PRIMARY KEY,
    Numero_Nota VARCHAR(30) UNIQUE NOT NULL,
    Data_Emissao DATE NOT NULL,
    Valor_Total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido)
);

-- TABELA: Avaliacao (Associação entre Cliente e Produto)
CREATE TABLE Avaliacao (
    ID_Avaliacao SERIAL PRIMARY KEY,
    ID_Cliente INT,
    ID_Produto INT,
    Data_Avaliacao DATE,
    Nota INT CHECK (Nota BETWEEN 1 AND 5),
    Comentario TEXT,
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);

-- INSERÇÃO DE DADOS (DML)
-- Categorias diversas
INSERT INTO Categoria (Nome) VALUES
('Eletrônicos'),
('Roupas'),
('Alimentos'),
('Livros'),
('Beleza'),
('Esportes'),
('Casa'),
('Brinquedos'),
('Automotivo'),
('Petshop');

-- Promoções
INSERT INTO Promocao (Descricao, Valor, Data_Inicio, Data_Fim) VALUES
('Desconto de Inverno', 10.00, '2025-06-01', '2025-06-30'),
('Liquidação Verão', 15.00, '2025-07-01', '2025-07-31'),
('Natal Antecipado', 20.00, '2025-12-01', '2025-12-25'),
('Black Friday', 30.00, '2025-11-25', '2025-11-30'),
('Ano Novo', 5.00, '2025-12-30', '2026-01-02'),
('Volta às Aulas', 12.00, '2025-01-15', '2025-02-15'),
('Semana do Consumidor', 8.00, '2025-03-10', '2025-03-20'),
('Feriado Local', 6.00, '2025-04-15', '2025-04-17'),
('Carnaval', 18.00, '2025-02-01', '2025-02-15'),
('Dia das Mães', 25.00, '2025-05-01', '2025-05-12');

-- Inserções na tabela Cliente
INSERT INTO Cliente (Nome, Email, Telefone, Senha) VALUES
('Ana Clara', 'ana.clara@email.com', '11111111', '76yhKs'),
('João Pedro', 'joao.pedro@email.com', '22222222', 'R4HSKsS'),
('Marina Lopes', 'marina@email.com', '33333333', '&HSLJNv'),
('Lucas Souza', 'lucas@email.com', '44444444', 's_)IFS'),
('Fernanda Dias', 'fernanda@email.com', '55555555', '7H9iJ'),
('Carlos Lima', 'carlos@email.com', '66666666', '@iaus'),
('Patrícia Ramos', 'patricia@email.com', '77777777', '.-acsf'),
('Ricardo Mendes', 'ricardo@email.com', '88888888', '18guid'),
('Juliana Alves', 'juliana@email.com', '99999999', 'an97vh'),
('Mateus Castro', 'mateus@email.com', '00000000', 'noasu'),
('Pedro Souza', 'pedro.souza@email.com', '111111110', 'senha123'),
('Mariana Costa', 'mariana.costa@email.com', '111111111', 'segura456'),
('Gabriel Santos', 'gabriel.santos@email.com', '111111112', 'nova789'),
('Isabela Pereira', 'isabela.pereira@email.com', '111111113', 'acesso101'),
('Rafael Oliveira', 'rafael.oliveira@email.com', '111111114', 'abcxyz'),
('Laura Rodrigues', 'laura.rodrigues@email.com', '111111115', 'qazwsx'),
('Daniel Lima', 'daniel.lima@email.com', '111111116', 'edcrfv'),
('Julia Fernandes', 'julia.fernandes@email.com', '111111117', 'tgbyhn'),
('Thiago Almeida', 'thiago.almeida@email.com', '111111118', 'ujmikl'),
('Beatriz Gomes', 'beatriz.gomes@email.com', '111111119', 'opasdf'),
('Vitor Barbosa', 'vitor.barbosa@email.com', '111111120', 'ghjklp'),
('Luiza Carvalho', 'luiza.carvalho@email.com', '111111121', 'zxcvbn'),
('Felipe Martins', 'felipe.martins@email.com', '111111122', 'mlkjhg'),
('Sofia Rocha', 'sofia.rocha@email.com', '111111123', 'fdsaqp'),
('Bruno Mendes', 'bruno.mendes@email.com', '111111124', 'oiuytr'),
('Helena Dias', 'helena.dias@email.com', '111111125', 'ewqazx'),
('Guilherme Pires', 'guilherme.pires@email.com', '111111126', 'mnbvcx'),
('Larissa Farias', 'larissa.farias@email.com', '111111127', 'lkjhgf'),
('Eduardo Santos', 'eduardo.santos2@email.com', '111111128', 'poiuas'),
('Giovanna Costa', 'giovanna.costa2@email.com', '111111129', 'dfgyuh'),
('Artur Oliveira', 'artur.oliveira2@email.com', '111111130', 'vbnmkl'),
('Clara Rodrigues', 'clara.rodrigues2@email.com', '111111131', 'rtyuio'),
('Diego Lima', 'diego.lima2@email.com', '111111132', 'fghjkl'),
('Manuela Fernandes', 'manuela.fernandes2@email.com', '111111133', 'cvbnmk'),
('Cauã Almeida', 'caua.almeida2@email.com', '111111134', 'xdfghj'),
('Lívia Gomes', 'livia.gomes2@email.com', '111111135', 'wqerty'),
('Miguel Barbosa', 'miguel.barbosa2@email.com', '111111136', 'plmjhg'),
('Cecília Carvalho', 'cecilia.carvalho2@email.com', '111111137', 'nbvcxz'),
('João Miguel', 'joao.miguel@email.com', '111111138', 'uytres'),
('Sophia Rocha', 'sophia.rocha2@email.com', '111111139', 'qawsed'),
('Enzo Mendes', 'enzo.mendes2@email.com', '111111140', 'rfgtbh'),
('Valentina Dias', 'valentina.dias2@email.com', '111111141', 'yhnmju'),
('Heitor Pires', 'heitor.pires2@email.com', '111111142', 'ikolmj'),
('Maria Eduarda', 'maria.eduarda@email.com', '111111143', 'zaqwsx'),
('Bernardo Farias', 'bernardo.farias2@email.com', '111111144', 'cderfv'),
('Heloísa Santos', 'heloisa.santos3@email.com', '111111145', 'tgbnhy'),
('Theo Costa', 'theo.costa3@email.com', '111111146', 'ujmnik'),
('Alice Oliveira', 'alice.oliveira3@email.com', '111111147', 'plokij'),
('Davi Rodrigues', 'davi.rodrigues3@email.com', '111111148', 'qazwsx'),
('Melissa Lima', 'melissa.lima3@email.com', '111111149', 'edcrfv');
-- Inserções na tabela Endereco
INSERT INTO Endereco (Rua, Numero, Bairro, Cidade, Estado, Cep, Complemento) VALUES
('Rua das Flores', '101', 'Centro', 'São Paulo', 'SP', '01000-000', 'Casa'),
('Rua dos Lírios', '202', 'Jardim', 'Campinas', 'SP', '13000-000', 'Apto 1'),
('Rua A', '10', 'Bela Vista', 'Rio de Janeiro', 'RJ', '20000-000', 'Cobertura'),
('Rua B', '20', 'Copacabana', 'Rio de Janeiro', 'RJ', '22000-000', 'Casa'),
('Av. Brasil', '1000', 'Industrial', 'Belo Horizonte', 'MG', '30000-000', NULL),
('Av. Amazonas', '999', 'Savassi', 'Belo Horizonte', 'MG', '30100-000', NULL),
('Rua C', '123', 'Boa Viagem', 'Recife', 'PE', '51000-000', 'Fundos'),
('Rua D', '321', 'Pina', 'Recife', 'PE', '51100-000', NULL),
('Av. Paulista', '1500', 'Paulista', 'São Paulo', 'SP', '01310-000', 'Sala 200'),
('Rua E', '456', 'Centro', 'Curitiba', 'PR', '80000-000', 'Apto 302'),
('Rua da Paz', '11', 'Vila Nova', 'Fortaleza', 'CE', '60000-011', 'Apto 11'),
('Avenida do Sol', '22', 'Centro', 'Natal', 'RN', '59000-022', NULL),
('Travessa da Lua', '33', 'Piedade', 'Jaboatão', 'PE', '54000-033', 'Casa 3'),
('Estrada do Mar', '44', 'Boa Esperança', 'Salvador', 'BA', '40000-044', 'Fundos'),
('Alameda dos Ipês', '55', 'Parque da Cidade', 'Brasília', 'DF', '70000-055', 'Bloco A'),
('Rua dos Cedros', '66', 'Jardim Botânico', 'Curitiba', 'PR', '80000-066', 'Andar 6'),
('Avenida das Palmeiras', '77', 'Campina', 'Recife', 'PE', '50000-077', NULL),
('Rua das Acácias', '88', 'Alto da Sé', 'Olinda', 'PE', '53000-088', 'Galpão'),
('Travessa das Gaivotas', '99', 'Ponta Negra', 'Natal', 'RN', '59000-099', 'Loja 9'),
('Estrada das Dunas', '100', 'Barra da Tijuca', 'Rio de Janeiro', 'RJ', '22000-100', 'Apartamento'),
('Rua das Montanhas', '101', 'Urca', 'Rio de Janeiro', 'RJ', '22000-101', NULL),
('Avenida dos Vales', '102', 'Centro', 'São Paulo', 'SP', '01000-102', 'Conjunto'),
('Travessa dos Lagos', '103', 'Liberdade', 'São Paulo', 'SP', '01000-103', 'Apto 103'),
('Estrada dos Campos', '104', 'Lapa', 'São Paulo', 'SP', '05000-104', 'Casa 104'),
('Alameda das Estrelas', '105', 'Itaim Bibi', 'São Paulo', 'SP', '04000-105', NULL),
('Rua das Pedras', '106', 'Pinheiros', 'São Paulo', 'SP', '05400-106', 'Edifício'),
('Avenida dos Ventos', '107', 'Copacabana', 'Rio de Janeiro', 'RJ', '22000-107', 'Flat'),
('Travessa das Cores', '108', 'Ipanema', 'Rio de Janeiro', 'RJ', '22000-108', NULL),
('Estrada do Céu', '109', 'Leblon', 'Rio de Janeiro', 'RJ', '22000-109', 'Duplex'),
('Alameda das Nuvens', '110', 'Botafogo', 'Rio de Janeiro', 'RJ', '22000-110', 'Studio'),
('Rua do Porto', '111', 'Centro', 'Santos', 'SP', '11000-111', 'Escritório'),
('Avenida da Praia', '112', 'Gonzaga', 'Santos', 'SP', '11000-112', NULL),
('Travessa da Ilha', '113', 'Boqueirão', 'Santos', 'SP', '11000-113', 'Apto 113'),
('Estrada da Floresta', '114', 'Morro do Elefante', 'Campos do Jordão', 'SP', '12000-114', 'Chalé'),
('Alameda das Cataratas', '115', 'Centro', 'Foz do Iguaçu', 'PR', '85000-115', NULL),
('Rua do Ouro', '116', 'Centro Histórico', 'Ouro Preto', 'MG', '35000-116', 'Pousada'),
('Avenida da Prata', '117', 'Centro', 'Gramado', 'RS', '95000-117', 'Hotel'),
('Travessa do Bronze', '118', 'Centro', 'Canela', 'RS', '95000-118', NULL),
('Estrada da Ferro', '119', 'Pelourinho', 'Salvador', 'BA', '40000-119', 'Casa Colonial'),
('Alameda do Diamante', '120', 'Rio Vermelho', 'Salvador', 'BA', '40000-120', NULL),
('Rua dos Peixes', '121', 'Mercado', 'Belém', 'PA', '66000-121', 'Box 12'),
('Avenida dos Pássaros', '122', 'Centro', 'Manaus', 'AM', '69000-122', 'Loja 20'),
('Travessa dos Ratos', '123', 'Vila Madalena', 'São Paulo', 'SP', '05400-123', 'Atelier'),
('Estrada dos Gatos', '124', 'Lapa', 'Rio de Janeiro', 'RJ', '20000-124', NULL),
('Alameda dos Cães', '125', 'Centro', 'Porto Alegre', 'RS', '90000-125', 'Sala 50'),
('Rua das Abelhas', '126', 'Moinhos de Vento', 'Porto Alegre', 'RS', '90000-126', NULL),
('Avenida das Formigas', '127', 'Floresta', 'Porto Alegre', 'RS', '90000-127', 'Galeria'),
('Travessa das Borboletas', '128', 'Centro', 'Florianópolis', 'SC', '88000-128', 'Cobertura'),
('Estrada das Joaninhas', '129', 'Lagoa da Conceição', 'Florianópolis', 'SC', '88000-129', NULL),
('Alameda dos Grilos', '130', 'Jurerê Internacional', 'Florianópolis', 'SC', '88000-130', 'Residencial');

-- Cada cliente com um endereço correspondente
INSERT INTO EnderecoCliente (ID_Cliente, ID_Endereco) VALUES
(1, 1),(2, 2),(3, 3),(4, 4),(5, 5),(6, 6),(7, 7),(8, 8),(9, 9),(10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20),
(21, 21), (22, 22), (23, 23), (24, 24), (25, 25), (26, 26), (27, 27), (28, 28), (29, 29), (30, 30),
(31, 31), (32, 32), (33, 33), (34, 34), (35, 35), (36, 36), (37, 37), (38, 38), (39, 39), (40, 40),
(41, 41), (42, 42), (43, 43), (44, 44), (45, 45), (46, 46), (47, 47), (48, 48), (49, 49), (50, 50);

-- Produtos variados com categorias e promoções
INSERT INTO Produto (Nome, Descricao, Preco, Estoque, ID_Categoria, ID_Promocao) VALUES
('Celular', 'Smartphone moderno', 1200.00, 30, 1, 1),
('Camisa Polo', 'Camisa básica', 80.00, 50, 2, 2),
('Arroz', 'Arroz branco', 25.00, 100, 3, 3),
('Livro Redes', 'Livro sobre redes de computadores', 50.00, 40, 4, 4),
('Creme Facial', 'Creme para rosto 100ml', 35.00, 20, 5, 5),
('Tênis Corrida', 'Tênis para prática esportiva', 200.00, 15, 6, 6),
('Sofá', 'Sofá 3 lugares', 899.00, 5, 7, 7),
('Quebra-Cabeça', 'Brinquedo educativo', 45.00, 25, 8, 8),
('Óleo de Motor', 'Lubrificante sintético', 70.00, 60, 9, 9),
('Ração Cães', 'Ração premium 15kg', 150.00, 30, 10, 10),
('Smart TV 50"', 'TV 4K com SmartV', 2500.00, 20, 1), -- Eletrônicos
('Calça Jeans Masculina', 'Jeans slim fit', 120.00, 40, 2), -- Roupas
('Feijão Carioca 1kg', 'Feijão tipo 1', 8.50, 150, 3), -- Alimentos
('O Poder do Hábito', 'Livro sobre formação de hábitos', 65.00, 30, 4), -- Livros
('Máscara Facial Hidratante', 'Com extrato de aloe vera', 45.00, 25, 5), -- Beleza
('Bola de Basquete', 'Tamanho oficial', 90.00, 10, 6), -- Esportes
('Mesa de Centro', 'Mesa de madeira maciça', 350.00, 8, 7), -- Casa
('Carrinho de Controle Remoto', 'Para crianças 5+', 180.00, 15, 8), -- Brinquedos
('Pneu Aro 15', 'Para carros de passeio', 280.00, 50, 9), -- Automotivo
('Coleira Anti-pulgas Cães', 'Para cães de pequeno porte', 55.00, 30, 10), -- Petshop
('Fone de Ouvido Bluetooth', 'Com cancelamento de ruído', 300.00, 35, 1),
('Blusa de Lã Feminina', 'Quente e confortável', 95.00, 50, 2),
('Macarrão Parafuso 500g', 'Massa de sêmola', 4.00, 200, 3),
('Clean Code', 'Manual para programadores', 80.00, 25, 4),
('Shampoo Anticaspa 400ml', 'Com piritionato de zinco', 28.00, 40, 5),
('Raquete de Tênis', 'Leve e resistente', 250.00, 12, 6),
('Luminária de Chão', 'Design moderno', 150.00, 10, 7),
('Boneca Interativa', 'Emite sons e frases', 110.00, 20, 8),
('Fluido de Freio DOT4', 'Alta performance', 30.00, 70, 9),
('Areia Higiênica Gatos 4kg', 'Com sílica gel', 38.00, 60, 10),
('Câmera Digital', '16MP, zoom óptico 5x', 700.00, 18, 1),
('Saia Plissada', 'Tecido leve, cintura alta', 85.00, 30, 2),
('Azeite Extra Virgem 500ml', 'Italiano, acidez 0.2%', 40.00, 90, 3),
('Pense e Enriqueça', 'Clássico da literatura de autoajuda', 48.00, 35, 4),
('Kit Maquiagem Completo', 'Com 10 pincéis e paleta', 190.00, 15, 5),
('Corda de Pular', 'Com rolamento', 25.00, 50, 6),
('Conjunto de Panelas 5PÇS', 'Antiaderente', 280.00, 7, 7),
('Jogo de Tabuleiro', 'Estratégia para adultos', 90.00, 12, 8),
('Capa de Carro', 'Proteção UV', 130.00, 20, 9),
('Comedouro Automático Pet', 'Para cães e gatos', 100.00, 15, 10),
('Monitor Gamer 27"', '144Hz, Full HD', 1400.00, 15, 1),
('Terno Masculino Slim', 'Tecido oxford', 450.00, 20, 2),
('Café Torrado e Moído 500g', 'Arábica, intenso', 18.00, 120, 3),
('1984', 'Distopia clássica', 30.00, 50, 4),
('Perfume Feminino 50ml', 'Floral amadeirado', 220.00, 10, 5),
('Halteres Ajustáveis', 'Até 20kg', 400.00, 5, 6),
('Aspirador de Pó Robô', 'Com mapeamento de ambientes', 900.00, 10, 7),
('Lego Castelo', 'Para montagem avançada', 380.00, 8, 8),
('Bateria Automotiva 60Ah', 'Livre de manutenção', 350.00, 25, 9),
('Aquário Pequeno 20L', 'Com filtro e iluminação', 180.00, 10, 10);

-- Pedidos realizados por clientes
INSERT INTO Pedido (ID_Cliente, Data_Pedido, Estatus_Pedido) VALUES
(1, '2025-06-01', 'em_preparo'),
(2, '2025-06-02', 'enviado'),
(3, '2025-06-03', 'entregue'),
(4, '2025-06-04', 'em_preparo'),
(5, '2025-06-05', 'enviado'),
(6, '2025-06-06', 'entregue'),
(7, '2025-06-07', 'em_preparo'),
(8, '2025-06-08', 'enviado'),
(9, '2025-06-09', 'entregue'),
(10, '2025-06-10', 'entregue'),
(11, '2025-06-12', 'em_preparo'),
(12, '2025-06-13', 'enviado'),
(13, '2025-06-14', 'entregue'),
(14, '2025-06-15', 'em_preparo'),
(15, '2025-06-16', 'enviado'),
(16, '2025-06-17', 'entregue'),
(17, '2025-06-18', 'em_preparo'),
(18, '2025-06-19', 'enviado'),
(19, '2025-06-20', 'entregue'),
(20, '2025-06-21', 'em_preparo'),
(21, '2025-06-22', 'enviado'),
(22, '2025-06-23', 'entregue'),
(23, '2025-06-24', 'em_preparo'),
(24, '2025-06-25', 'enviado'),
(25, '2025-06-26', 'entregue'),
(26, '2025-06-27', 'em_preparo'),
(27, '2025-06-28', 'enviado'),
(28, '2025-06-29', 'entregue'),
(29, '2025-06-30', 'em_preparo'),
(30, '2025-07-01', 'enviado'),
(31, '2025-07-02', 'entregue'),
(32, '2025-07-03', 'em_preparo'),
(33, '2025-07-04', 'enviado'),
(34, '2025-07-05', 'entregue'),
(35, '2025-07-06', 'em_preparo'),
(36, '2025-07-07', 'enviado'),
(37, '2025-07-08', 'entregue'),
(38, '2025-07-09', 'em_preparo'),
(39, '2025-07-10', 'enviado'),
(40, '2025-07-11', 'entregue'),
(41, '2025-07-12', 'em_preparo'),
(42, '2025-07-13', 'enviado'),
(43, '2025-07-14', 'entregue'),
(44, '2025-07-15', 'em_preparo'),
(45, '2025-07-16', 'enviado'),
(46, '2025-07-17', 'entregue'),
(47, '2025-07-18', 'em_preparo'),
(48, '2025-07-19', 'enviado'),
(49, '2025-07-20', 'entregue'),
(50, '2025-07-21', 'em_preparo');

-- Cada pedido com item relacionado a produto
INSERT INTO ItemPedido (ID_Pedido, ID_Produto, Quantidade, Preco_Unitario, Preco_Total) VALUES
(1, 1, 2, 1200.00, 2400.00),
(2, 2, 1, 80.00, 80.00),
(3, 3, 3, 25.00, 75.00),
(4, 4, 1, 50.00, 50.00),
(5, 5, 2, 35.00, 70.00),
(6, 6, 1, 200.00, 200.00),
(7, 7, 1, 899.00, 899.00),
(8, 8, 2, 45.00, 90.00),
(9, 9, 1, 70.00, 70.00),
(10, 10, 1, 150.00, 150.00),
(11, 11, 1, 2500.00, 2500.00), -- Smart TV 50"
(12, 12, 2, 120.00, 240.00),  -- Calça Jeans Masculina
(13, 13, 5, 8.50, 42.50),     -- Feijão Carioca 1kg
(14, 14, 1, 65.00, 65.00),    -- O Poder do Hábito
(15, 15, 1, 45.00, 45.00),    -- Máscara Facial Hidratante
(16, 16, 1, 90.00, 90.00),    -- Bola de Basquete
(17, 17, 1, 350.00, 350.00),  -- Mesa de Centro
(18, 18, 1, 180.00, 180.00),  -- Carrinho de Controle Remoto
(19, 19, 2, 280.00, 560.00),  -- Pneu Aro 15
(20, 20, 3, 55.00, 165.00),   -- Coleira Anti-pulgas Cães
(21, 21, 1, 300.00, 300.00),  -- Fone de Ouvido Bluetooth
(22, 22, 1, 95.00, 95.00),    -- Blusa de Lã Feminina
(23, 23, 4, 4.00, 16.00),     -- Macarrão Parafuso 500g
(24, 24, 1, 80.00, 80.00),    -- Clean Code
(25, 25, 2, 28.00, 56.00),    -- Shampoo Anticaspa 400ml
(26, 26, 1, 250.00, 250.00),  -- Raquete de Tênis
(27, 27, 1, 150.00, 150.00),  -- Luminária de Chão
(28, 28, 1, 110.00, 110.00),  -- Boneca Interativa
(29, 29, 1, 30.00, 30.00),    -- Fluido de Freio DOT4
(30, 30, 2, 38.00, 76.00),    -- Areia Higiênica Gatos 4kg
(31, 31, 1, 700.00, 700.00),  -- Câmera Digital
(32, 32, 1, 85.00, 85.00),    -- Saia Plissada
(33, 33, 2, 40.00, 80.00),    -- Azeite Extra Virgem 500ml
(34, 34, 1, 48.00, 48.00),    -- Pense e Enriqueça
(35, 35, 1, 190.00, 190.00),  -- Kit Maquiagem Completo
(36, 36, 3, 25.00, 75.00),    -- Corda de Pular
(37, 37, 1, 280.00, 280.00),  -- Conjunto de Panelas 5PÇS
(38, 38, 1, 90.00, 90.00),    -- Jogo de Tabuleiro
(39, 39, 1, 130.00, 130.00),  -- Capa de Carro
(40, 40, 1, 100.00, 100.00),  -- Comedouro Automático Pet
(41, 41, 1, 1400.00, 1400.00),-- Monitor Gamer 27"
(42, 42, 1, 450.00, 450.00),  -- Terno Masculino Slim
(43, 43, 2, 18.00, 36.00),    -- Café Torrado e Moído 500g
(44, 44, 1, 30.00, 30.00),    -- 1984
(45, 45, 1, 220.00, 220.00),  -- Perfume Feminino 50ml
(46, 46, 1, 400.00, 400.00),  -- Halteres Ajustáveis
(47, 47, 1, 900.00, 900.00),  -- Aspirador de Pó Robô
(48, 48, 1, 380.00, 380.00),  -- Lego Castelo
(49, 49, 1, 350.00, 350.00),  -- Bateria Automotiva 60Ah
(50, 50, 1, 180.00, 180.00);
-- Avaliações dos clientes aos produtos
INSERT INTO Avaliacao (ID_Cliente, ID_Produto, Data_Avaliacao, Nota, Comentario) VALUES
(1, 1, '2025-06-11', 5, 'Excelente celular!'),
(2, 2, '2025-06-11', 4, 'Camisa de boa qualidade.'),
(3, 3, '2025-06-11', 5, 'Ótimo arroz.'),
(4, 4, '2025-06-11', 3, 'Livro bom, mas antigo.'),
(5, 5, '2025-06-11', 4, 'Produto de beleza muito bom.'),
(6, 6, '2025-06-11', 5, 'Tênis confortável.'),
(7, 7, '2025-06-11', 4, 'Sofá excelente.'),
(8, 8, '2025-06-11', 3, 'Brinquedo simples.'),
(9, 9, '2025-06-11', 5, 'Óleo de qualidade.'),
(10, 10, '2025-06-11', 4, 'Meu cachorro adorou.'),
(11, 11, '2025-07-15', 5, 'Melhor TV que já tive!'),
(12, 12, '2025-07-16', 4, 'Jeans de qualidade razoável.'),
(13, 13, '2025-07-17', 5, 'Feijão fresco e saboroso.'),
(14, 14, '2025-07-18', 5, 'Livro inspirador.'),
(15, 15, '2025-07-19', 4, 'Máscara deixou a pele macia.'),
(16, 16, '2025-07-20', 5, 'Ótima bola para basquete.'),
(17, 17, '2025-07-21', 4, 'Mesa bonita, mas um pouco pesada.'),
(18, 18, '2025-07-22', 3, 'Carrinho ok, bateria dura pouco.'),
(19, 19, '2025-07-23', 5, 'Pneus de excelente aderência.'),
(20, 20, '2025-07-24', 4, 'Coleira funcionou bem.'),
(21, 21, '2025-07-15', 5, 'Qualidade de som incrível!'),
(22, 22, '2025-07-16', 4, 'Blusa super macia.'),
(23, 23, '2025-07-17', 5, 'Macarrão cozinha rápido.'),
(24, 24, '2025-07-18', 5, 'Livro essencial para devs.'),
(25, 25, '2025-07-19', 4, 'Shampoo realmente ajuda na caspa.'),
(26, 26, '2025-07-20', 5, 'Raquete leve e potente.'),
(27, 27, '2025-07-21', 4, 'Luminária bonita, luz agradável.'),
(28, 28, '2025-07-22', 3, 'Boneca não tem muitas frases.'),
(29, 29, '2025-07-23', 5, 'Fluido de freio eficiente.'),
(30, 30, '2025-07-24', 4, 'Areia absorve bem o odor.'),
(31, 31, '2025-07-15', 5, 'Câmera com ótima resolução.'),
(32, 32, '2025-07-16', 4, 'Saia elegante e confortável.'),
(33, 33, '2025-07-17', 5, 'Azeite saboroso.'),
(34, 34, '2025-07-18', 5, 'Livro que muda a perspectiva.'),
(35, 35, '2025-07-19', 4, 'Kit completo para maquiagem.'),
(36, 36, '2025-07-20', 5, 'Corda de boa qualidade.'),
(37, 37, '2025-07-21', 4, 'Panelas antiaderentes excelentes.'),
(38, 38, '2025-07-22', 3, 'Jogo um pouco complicado.'),
(39, 39, '2025-07-23', 5, 'Capa protege bem o carro.'),
(40, 40, '2025-07-24', 4, 'Comedouro funciona bem.'),
(41, 41, '2025-07-15', 5, 'Monitor com imagem perfeita!'),
(42, 42, '2025-07-16', 4, 'Terno veste bem.'),
(43, 43, '2025-07-17', 5, 'Café forte e saboroso.'),
(44, 44, '2025-07-18', 5, 'Leitura obrigatória.'),
(45, 45, '2025-07-19', 4, 'Perfume com boa fixação.'),
(46, 46, '2025-07-20', 5, 'Halteres muito práticos.'),
(47, 47, '2025-07-21', 4, 'Robô limpa bem.'),
(48, 48, '2025-07-22', 3, 'Lego desafiador.'),
(49, 49, '2025-07-23', 5, 'Bateria durável.'),
(50, 50, '2025-07-24', 4, 'Aquário bonito, fácil de montar.');

INSERT INTO NotaFiscal (ID_Pedido, Numero_Nota, Data_Emissao, Valor_Total) VALUES
(2, 'NF-0002', CURRENT_DATE, 200.00),(3, 'NF-0003', CURRENT_DATE, 300.00),(4, 'NF-0004', CURRENT_DATE, 120.00),
(5, 'NF-0005', CURRENT_DATE, 80.00),(6, 'NF-0006', CURRENT_DATE, 220.00),(7, 'NF-0007', CURRENT_DATE, 450.00),
(8, 'NF-0008', CURRENT_DATE, 99.90),(9, 'NF-0009', CURRENT_DATE, 175.00),(10, 'NF-0010', CURRENT_DATE, 500.00),
(11, 'NF-0011', '2025-06-12', 2500.00),
(12, 'NF-0012', '2025-06-13', 240.00),
(13, 'NF-0013', '2025-06-14', 42.50),
(14, 'NF-0014', '2025-06-15', 65.00),
(15, 'NF-0015', '2025-06-16', 45.00),
(16, 'NF-0016', '2025-06-17', 90.00),
(17, 'NF-0017', '2025-06-18', 350.00),
(18, 'NF-0018', '2025-06-19', 180.00),
(19, 'NF-0019', '2025-06-20', 560.00),
(20, 'NF-0020', '2025-06-21', 165.00),
(21, 'NF-0021', '2025-06-22', 300.00),
(22, 'NF-0022', '2025-06-23', 95.00),
(23, 'NF-0023', '2025-06-24', 16.00),
(24, 'NF-0024', '2025-06-25', 80.00),
(25, 'NF-0025', '2025-06-26', 56.00),
(26, 'NF-0026', '2025-06-27', 250.00),
(27, 'NF-0027', '2025-06-28', 150.00),
(28, 'NF-0028', '2025-06-29', 110.00),
(29, 'NF-0029', '2025-06-30', 30.00),
(30, 'NF-0030', '2025-07-01', 76.00),
(31, 'NF-0031', '2025-07-02', 700.00),
(32, 'NF-0032', '2025-07-03', 85.00),
(33, 'NF-0033', '2025-07-04', 80.00),
(34, 'NF-0034', '2025-07-05', 48.00),
(35, 'NF-0035', '2025-07-06', 190.00),
(36, 'NF-0036', '2025-07-07', 75.00),
(37, 'NF-0037', '2025-07-08', 280.00),
(38, 'NF-0038', '2025-07-09', 90.00),
(39, 'NF-0039', '2025-07-10', 130.00),
(40, 'NF-0040', '2025-07-11', 100.00),
(41, 'NF-0041', '2025-07-12', 1400.00),
(42, 'NF-0042', '2025-07-13', 450.00),
(43, 'NF-0043', '2025-07-14', 36.00),
(44, 'NF-0044', '2025-07-15', 30.00),
(45, 'NF-0045', '2025-07-16', 220.00),
(46, 'NF-0046', '2025-07-17', 400.00),
(47, 'NF-0047', '2025-07-18', 900.00),
(48, 'NF-0048', '2025-07-19', 380.00),
(49, 'NF-0049', '2025-07-20', 350.00),
(50, 'NF-0050', '2025-07-21', 180.00);

INSERT INTO ProdutoPromocao (ID_Produto, ID_Promocao) VALUES
(1, 1),(1, 2),(2, 1),(2, 3),(3, 2),(3, 3),(4, 1),(4, 3),(5, 1),(5, 2).
(11, 1), (12, 2), (13, 3), (14, 4), (15, 5),
(16, 6), (17, 7), (18, 8), (19, 9), (20, 10),
(21, 1), (22, 2), (23, 3), (24, 4), (25, 5),
(26, 6), (27, 7), (28, 8), (29, 9), (30, 10),
(31, 1), (32, 2), (33, 3), (34, 4), (35, 5),
(36, 6), (37, 7), (38, 8), (39, 9), (40, 10),
(41, 1), (42, 2), (43, 3), (44, 4), (45, 5),
(46, 6), (47, 7), (48, 8), (49, 9), (50, 10);

CREATE VIEW detalhes_pedidos_com_cliente AS
SELECT p.ID_Pedido,p.Data_Pedido,p.Estatus_Pedido,c.Nome AS Nome_Cliente,
	c.Email AS Email_Cliente,c.Telefone AS Telefone_Cliente
FROM Pedido p
JOIN Cliente c ON p.ID_Cliente = c.ID_Cliente;

CREATE VIEW Produtos_Em_Promocao_Com_Categoria AS
SELECT prod.ID_Produto,prod.Nome AS Nome_Produto,prod.Preco AS Preco_Original,
    prom.Descricao AS Descricao_Promocao,prom.Valor AS Valor_Desconto,
    ROUND((prod.Preco - (prod.Preco * (prom.Valor / 100))), 2) AS Preco_Com_Desconto,prom.Data_Inicio,
    prom.Data_Fim,cat.Nome AS Nome_Categoria
FROM Produto prod
JOIN ProdutoPromocao pp ON prod.ID_Produto = pp.ID_Produto
JOIN Promocao prom ON pp.ID_Promocao = prom.ID_Promocao
JOIN Categoria cat ON prod.ID_Categoria = cat.ID_Categoria
WHERE CURRENT_DATE BETWEEN prom.Data_Inicio AND prom.Data_Fim;

CREATE VIEW Total_Vendas_Por_Categoria AS
SELECT c.Nome AS Nome_Categoria, SUM(ip.Preco_Total) AS Valor_Total_Vendas, SUM(ip.quantidade) AS Quantidade_Total_Vendida
FROM Categoria c
JOIN Produto p ON c.ID_Categoria = p.ID_Categoria
JOIN ItemPedido ip ON p.ID_Produto = ip.ID_Produto
GROUP BY c.Nome
ORDER BY Valor_Total_Vendas DESC;

-- Criação de Usuários e Controle de Acesso
-- 1. Criação do Usuário Admin
CREATE USER admin_user WITH PASSWORD 'Vagalinha';

GRANT ALL PRIVILEGES ON DATABASE ecomerce TO admin_user;

ALTER DEFAULT PRIVILEGES FOR USER admin_user IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO admin_user;
ALTER DEFAULT PRIVILEGES FOR USER admin_user IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO admin_user;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_user;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO admin_user;

-- 2. Criação do Usuário Somente Leitura
CREATE USER readonly_user WITH PASSWORD 'Vagalinha';

GRANT CONNECT ON DATABASE ecomerce TO readonly_user;

GRANT USAGE ON SCHEMA public TO readonly_user;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO readonly_user;

GRANT SELECT ON detalhes_pedidos_com_cliente TO readonly_user;
GRANT SELECT ON Produtos_Em_Promocao_Com_Categoria TO readonly_user;

ALTER DEFAULT PRIVILEGES FOR USER readonly_user IN SCHEMA public GRANT SELECT ON TABLES TO readonly_user;
ALTER DEFAULT PRIVILEGES FOR USER readonly_user IN SCHEMA public GRANT SELECT ON SEQUENCES TO readonly_user;
