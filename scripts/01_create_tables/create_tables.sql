-- =====================================================
-- SISTEMA DE GESTÃO DE ESTOQUE - SUPERMERCADO
-- Banco de Dados: SQLite
-- SCRIPT CORRIGIDO - Versão 2.0
-- =====================================================

-- =====================================================
-- DELETAR TABELAS EXISTENTES (na ordem correta)
-- =====================================================
DROP TABLE IF EXISTS ITEM_COMPRA;
DROP TABLE IF EXISTS ITEM_VENDA;
DROP TABLE IF EXISTS PRODUTO_FORNECEDOR;
DROP TABLE IF EXISTS MOVIMENTACAO;
DROP TABLE IF EXISTS COMPRA;
DROP TABLE IF EXISTS VENDA;
DROP TABLE IF EXISTS PRODUTO;
DROP TABLE IF EXISTS FUNCIONARIO;
DROP TABLE IF EXISTS FORNECEDOR;
DROP TABLE IF EXISTS SETOR;
DROP TABLE IF EXISTS CATEGORIA;
DROP TABLE IF EXISTS CLIENTE;

-- =====================================================
-- 1. TABELA CATEGORIA
-- =====================================================
CREATE TABLE CATEGORIA (
    id_categoria INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_categoria VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(200)
);

-- =====================================================
-- 2. TABELA PRODUTO
-- =====================================================
CREATE TABLE PRODUTO (
    id_produto INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_produto VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    preco_custo DECIMAL(10,2) NOT NULL,
    preco_venda DECIMAL(10,2) NOT NULL,
    quantidade_estoque INTEGER NOT NULL DEFAULT 0,
    estoque_minimo INTEGER NOT NULL,
    data_validade DATE,
    codigo_barras VARCHAR(13) UNIQUE,
    id_categoria INTEGER NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIA(id_categoria)
);

-- =====================================================
-- 3. TABELA FORNECEDOR
-- =====================================================
CREATE TABLE FORNECEDOR (
    id_fornecedor INTEGER PRIMARY KEY AUTOINCREMENT,
    razao_social VARCHAR(150) NOT NULL,
    cnpj VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    endereco VARCHAR(255),
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL
);

-- =====================================================
-- 4. TABELA SETOR
-- =====================================================
CREATE TABLE SETOR (
    id_setor INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_setor VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(200)
);

-- =====================================================
-- 5. TABELA FUNCIONARIO
-- =====================================================
CREATE TABLE FUNCIONARIO (
    id_funcionario INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    cargo VARCHAR(50) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    data_admissao DATE NOT NULL,
    telefone VARCHAR(15),
    id_setor INTEGER NOT NULL,
    FOREIGN KEY (id_setor) REFERENCES SETOR(id_setor)
);

-- =====================================================
-- 6. TABELA VENDA
-- =====================================================
CREATE TABLE VENDA (
    id_venda INTEGER PRIMARY KEY AUTOINCREMENT,
    data_hora DATETIME NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    forma_pagamento VARCHAR(20) NOT NULL,
    id_funcionario INTEGER NOT NULL,
    id_cliente INTEGER,
    FOREIGN KEY (id_funcionario) REFERENCES FUNCIONARIO(id_funcionario),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);

-- =====================================================
-- 7. TABELA MOVIMENTACAO
-- =====================================================
CREATE TABLE MOVIMENTACAO (
    id_movimentacao INTEGER PRIMARY KEY AUTOINCREMENT,
    data_hora DATETIME NOT NULL,
    tipo_movimentacao VARCHAR(10) NOT NULL CHECK(tipo_movimentacao IN ('ENTRADA', 'SAIDA')),
    quantidade INTEGER NOT NULL,
    motivo VARCHAR(200),
    id_produto INTEGER NOT NULL,
    id_funcionario INTEGER NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES PRODUTO(id_produto),
    FOREIGN KEY (id_funcionario) REFERENCES FUNCIONARIO(id_funcionario)
);

-- =====================================================
-- 8. TABELA COMPRA
-- =====================================================
CREATE TABLE COMPRA (
    id_compra INTEGER PRIMARY KEY AUTOINCREMENT,
    data_compra DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    numero_nota_fiscal VARCHAR(20) NOT NULL UNIQUE,
    id_fornecedor INTEGER NOT NULL,
    FOREIGN KEY (id_fornecedor) REFERENCES FORNECEDOR(id_fornecedor)
);

-- =====================================================
-- 9. TABELA PRODUTO_FORNECEDOR (Relacionamento N:N)
-- =====================================================
CREATE TABLE PRODUTO_FORNECEDOR (
    id_produto INTEGER NOT NULL,
    id_fornecedor INTEGER NOT NULL,
    preco_fornecimento DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_produto, id_fornecedor),
    FOREIGN KEY (id_produto) REFERENCES PRODUTO(id_produto),
    FOREIGN KEY (id_fornecedor) REFERENCES FORNECEDOR(id_fornecedor)
);

-- =====================================================
-- 10. TABELA ITEM_VENDA (Relacionamento N:N)
-- =====================================================
CREATE TABLE ITEM_VENDA (
    id_venda INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_venda, id_produto),
    FOREIGN KEY (id_venda) REFERENCES VENDA(id_venda),
    FOREIGN KEY (id_produto) REFERENCES PRODUTO(id_produto)
);

-- =====================================================
-- 11. TABELA ITEM_COMPRA (Relacionamento N:N)
-- =====================================================
CREATE TABLE ITEM_COMPRA (
    id_compra INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_compra, id_produto),
    FOREIGN KEY (id_compra) REFERENCES COMPRA(id_compra),
    FOREIGN KEY (id_produto) REFERENCES PRODUTO(id_produto)
);

-- =====================================================
-- 12. TABELA CLIENTE
-- =====================================================
CREATE TABLE CLIENTE (
    id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_cliente TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- ÍNDICES PARA MELHOR PERFORMANCE
-- =====================================================
CREATE INDEX idx_produto_categoria ON PRODUTO(id_categoria);
CREATE INDEX idx_produto_codigo ON PRODUTO(codigo_barras);
CREATE INDEX idx_funcionario_setor ON FUNCIONARIO(id_setor);
CREATE INDEX idx_venda_funcionario ON VENDA(id_funcionario);
CREATE INDEX idx_venda_data ON VENDA(data_hora);
CREATE INDEX idx_movimentacao_produto ON MOVIMENTACAO(id_produto);
CREATE INDEX idx_movimentacao_data ON MOVIMENTACAO(data_hora);
CREATE INDEX idx_compra_fornecedor ON COMPRA(id_fornecedor);

-- =====================================================
-- VERIFICAÇÃO - Listar todas as tabelas criadas
-- =====================================================
SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;

-- =====================================================
-- FIM DOS SCRIPTS DE CRIAÇÃO
-- =====================================================



