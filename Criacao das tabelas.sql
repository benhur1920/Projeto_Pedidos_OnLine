create database Pedidos_online;
use Pedidos_online;

-- Criacao das tabelas 
-- Tabela Cliente
CREATE TABLE IF NOT EXISTS Cliente (
    Id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CPF CHAR(14) NOT NULL,
    E_mail VARCHAR(100) NOT NULL,
    Telefone VARCHAR(20) -- Pode ser NULL
);

-- Tabela Fornecedor
CREATE TABLE IF NOT EXISTS Fornecedor (
    Id_Fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    Nome_fornecedor VARCHAR(100) NOT NULL,
    CNPJ CHAR(18) NOT NULL,
    Telefone VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL
);

-- Tabela Produto
CREATE TABLE IF NOT EXISTS Produto (
    Id_Produto INT AUTO_INCREMENT PRIMARY KEY,
    Nome_produto VARCHAR(100) NOT NULL,
    Codigo_produto VARCHAR(50) NOT NULL,
    Descricao TEXT,
    Id_Fornecedor INT NOT NULL,
    FOREIGN KEY (Id_Fornecedor) REFERENCES Fornecedor(Id_Fornecedor) ON DELETE RESTRICT
);

-- Tabela Pagamento_Pedido
CREATE TABLE IF NOT EXISTS Pagamento_Pedido (
    Id_pagamento INT NOT NULL,
    Id_Pedido INT NOT NULL,
    Valor_pago DECIMAL(10,2) NOT NULL,
    Pagamento_efetuado BOOLEAN NOT NULL,
    Data_pagamento DATE,
    Data_pedido DATE,
    Nr_pedido VARCHAR(50) NOT NULL,
    Id_cliente INT NOT NULL,
    PRIMARY KEY (Id_pagamento, Id_Pedido),
    FOREIGN KEY (Id_cliente) REFERENCES Cliente(Id_cliente) ON DELETE RESTRICT
);

-- Tabela Itens_Pedido (associação Pedido–Produto)
CREATE TABLE IF NOT EXISTS Itens_Pedido (
    Id_pagamento INT NOT NULL,
    Id_Pedido INT NOT NULL,
    Id_Produto INT NOT NULL,
    Quantidade INT NOT NULL,
    Valor_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (Id_pagamento, Id_Pedido, Id_Produto),
    FOREIGN KEY (Id_pagamento, Id_Pedido) REFERENCES Pagamento_Pedido(Id_pagamento, Id_Pedido) ON DELETE CASCADE,
    FOREIGN KEY (Id_Produto) REFERENCES Produto(Id_Produto) ON DELETE RESTRICT
);


-- Tabela Entrega
CREATE TABLE IF NOT EXISTS Entrega (
    Id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    Data_envio DATE,
    Data_entrega DATE,
    Id_pagamento INT NOT NULL,
    Id_Pedido INT NOT NULL,
    FOREIGN KEY (Id_pagamento, Id_Pedido) REFERENCES Pagamento_Pedido(Id_pagamento, Id_Pedido) ON DELETE CASCADE
);

-- Tabela Forma_pagamento
CREATE TABLE IF NOT EXISTS Forma_pagamento (
    Id_Forma_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    Tipo_pagamento ENUM('Pix', 'Cartao', 'Debito', 'Boleto') NOT NULL,
    Id_pagamento INT NOT NULL,
    Id_Pedido INT NOT NULL,
    FOREIGN KEY (Id_pagamento, Id_Pedido) REFERENCES Pagamento_Pedido(Id_pagamento, Id_Pedido) ON DELETE RESTRICT
);

-- Mostrar as tabelas
show tables;
