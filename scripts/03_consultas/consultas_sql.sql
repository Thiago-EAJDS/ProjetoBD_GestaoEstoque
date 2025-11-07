-- =====================================================
-- 10 CONSULTAS SQL OBRIGATÓRIAS
-- Sistema de Gestão de Estoque - Supermercado
-- =====================================================
-- Requisitos atendidos:
-- IN, NOT IN, BETWEEN, >=, <=, AND, OR, LIMIT
-- COUNT, SUM, MIN, MAX
-- GROUP BY, ORDER BY
-- INNER JOIN, LEFT JOIN
-- UNION, UNION ALL
-- =====================================================

-- =====================================================
-- CONSULTA 1: Produtos de categorias específicas
-- Operadores: IN, ORDER BY
-- =====================================================
-- Descrição: Listar produtos das categorias 'Alimentos', 'Bebidas' e 'Frios e Laticínios'
-- ordenados por preço de venda decrescente

SELECT 
    p.nome_produto,
    c.nome_categoria,
    p.preco_venda,
    p.quantidade_estoque
FROM PRODUTO p
INNER JOIN CATEGORIA c ON p.id_categoria = c.id_categoria
WHERE c.nome_categoria IN ('Alimentos', 'Bebidas', 'Frios e Laticínios')
ORDER BY p.preco_venda DESC;

-- Resultado esperado: Produtos dessas 3 categorias do mais caro ao mais barato


-- =====================================================
-- CONSULTA 2: Funcionários com salário em uma faixa
-- Operadores: BETWEEN, AND, ORDER BY
-- =====================================================
-- Descrição: Listar funcionários com salário entre R$ 1.500 e R$ 3.000

SELECT 
    f.nome,
    f.cargo,
    f.salario,
    s.nome_setor
FROM FUNCIONARIO f
INNER JOIN SETOR s ON f.id_setor = s.id_setor
WHERE f.salario BETWEEN 1500.00 AND 3000.00
ORDER BY f.salario DESC;

-- Resultado esperado: Funcionários nessa faixa salarial ordenados por salário


-- =====================================================
-- CONSULTA 3: Produtos com estoque crítico
-- Operadores: <=, AND, ORDER BY, LIMIT
-- =====================================================
-- Descrição: Top 5 produtos com menor estoque (abaixo ou igual ao mínimo)

SELECT 
    p.nome_produto,
    c.nome_categoria,
    p.quantidade_estoque,
    p.estoque_minimo,
    (p.estoque_minimo - p.quantidade_estoque) AS quantidade_repor
FROM PRODUTO p
INNER JOIN CATEGORIA c ON p.id_categoria = c.id_categoria
WHERE p.quantidade_estoque <= p.estoque_minimo
ORDER BY p.quantidade_estoque ASC
LIMIT 5;

-- Resultado esperado: 5 produtos com estoque mais crítico


-- =====================================================
-- CONSULTA 4: Vendas por forma de pagamento
-- Operadores: COUNT, SUM, GROUP BY, ORDER BY
-- =====================================================
-- Descrição: Total de vendas e valor arrecadado por forma de pagamento

SELECT 
    forma_pagamento,
    COUNT(*) AS total_vendas,
    SUM(valor_total) AS valor_arrecadado,
    ROUND(AVG(valor_total), 2) AS ticket_medio
FROM VENDA
GROUP BY forma_pagamento
ORDER BY valor_arrecadado DESC;

-- Resultado esperado: Estatísticas de vendas agrupadas por forma de pagamento


-- =====================================================
-- CONSULTA 5: Produtos mais vendidos
-- Operadores: SUM, COUNT, INNER JOIN, GROUP BY, ORDER BY, LIMIT
-- =====================================================
-- Descrição: Top 10 produtos mais vendidos em quantidade

SELECT 
    p.nome_produto,
    c.nome_categoria,
    SUM(iv.quantidade) AS total_vendido,
    COUNT(DISTINCT iv.id_venda) AS numero_vendas,
    ROUND(SUM(iv.subtotal), 2) AS faturamento_total
FROM ITEM_VENDA iv
INNER JOIN PRODUTO p ON iv.id_produto = p.id_produto
INNER JOIN CATEGORIA c ON p.id_categoria = c.id_categoria
GROUP BY p.id_produto, p.nome_produto, c.nome_categoria
ORDER BY total_vendido DESC
LIMIT 10;

-- Resultado esperado: 10 produtos que mais venderam em quantidade


-- =====================================================
-- CONSULTA 6: Funcionários e suas vendas
-- Operadores: LEFT JOIN, COUNT, SUM, GROUP BY, ORDER BY
-- =====================================================
-- Descrição: Listar TODOS os funcionários do setor Caixa e suas vendas
-- (mesmo quem não fez vendas aparece com NULL/0)

SELECT 
    f.nome AS funcionario,
    s.nome_setor,
    COUNT(v.id_venda) AS total_vendas,
    COALESCE(SUM(v.valor_total), 0) AS valor_total_vendido
FROM FUNCIONARIO f
INNER JOIN SETOR s ON f.id_setor = s.id_setor
LEFT JOIN VENDA v ON f.id_funcionario = v.id_funcionario
WHERE s.nome_setor = 'Caixa'
GROUP BY f.id_funcionario, f.nome, s.nome_setor
ORDER BY valor_total_vendido DESC;

-- Resultado esperado: Todos os funcionários do Caixa com contagem de vendas


-- =====================================================
-- CONSULTA 7: Movimentações de entrada e saída
-- Operadores: >=, OR, INNER JOIN, ORDER BY
-- =====================================================
-- Descrição: Movimentações de produtos da categoria 'Alimentos' 
-- com quantidade >= 50 ou tipo 'SAIDA'

SELECT 
    m.id_movimentacao,
    m.data_hora,
    m.tipo_movimentacao,
    m.quantidade,
    p.nome_produto,
    c.nome_categoria,
    f.nome AS responsavel
FROM MOVIMENTACAO m
INNER JOIN PRODUTO p ON m.id_produto = p.id_produto
INNER JOIN CATEGORIA c ON p.id_categoria = c.id_categoria
INNER JOIN FUNCIONARIO f ON m.id_funcionario = f.id_funcionario
WHERE (m.quantidade >= 50 OR m.tipo_movimentacao = 'SAIDA')
  AND c.nome_categoria = 'Alimentos'
ORDER BY m.data_hora DESC;

-- Resultado esperado: Movimentações de Alimentos com grande quantidade ou saídas


-- =====================================================
-- CONSULTA 8: Estatísticas de produtos por categoria
-- Operadores: COUNT, MIN, MAX, AVG, GROUP BY, ORDER BY
-- =====================================================
-- Descrição: Resumo estatístico de produtos por categoria

SELECT 
    c.nome_categoria,
    COUNT(p.id_produto) AS qtd_produtos,
    MIN(p.preco_venda) AS menor_preco,
    MAX(p.preco_venda) AS maior_preco,
    ROUND(AVG(p.preco_venda), 2) AS preco_medio,
    SUM(p.quantidade_estoque) AS estoque_total
FROM CATEGORIA c
INNER JOIN PRODUTO p ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria, c.nome_categoria
ORDER BY estoque_total DESC;

-- Resultado esperado: Análise estatística completa por categoria


-- =====================================================
-- CONSULTA 9: Fornecedores que não têm produtos cadastrados
-- Operadores: NOT IN (subconsulta)
-- =====================================================
-- Descrição: Listar fornecedores que não forneceram nenhum produto ainda

SELECT 
    f.razao_social,
    f.cnpj,
    f.telefone,
    f.cidade,
    f.estado
FROM FORNECEDOR f
WHERE f.id_fornecedor NOT IN (
    SELECT DISTINCT id_fornecedor 
    FROM PRODUTO_FORNECEDOR
)
ORDER BY f.razao_social;

-- Resultado esperado: Fornecedores sem produtos vinculados


-- =====================================================
-- CONSULTA 10: União de entradas e saídas recentes
-- Operadores: UNION ALL, LIMIT
-- =====================================================
-- Descrição: Listar as 10 últimas movimentações de entrada e saída
-- mostrando o tipo de operação

SELECT 
    'VENDA' AS tipo_operacao,
    v.id_venda AS id_operacao,
    v.data_hora,
    v.valor_total AS valor,
    f.nome AS responsavel
FROM VENDA v
INNER JOIN FUNCIONARIO f ON v.id_funcionario = f.id_funcionario

UNION ALL

SELECT 
    'COMPRA' AS tipo_operacao,
    c.id_compra AS id_operacao,
    datetime(c.data_compra) AS data_hora,
    c.valor_total AS valor,
    'Sistema' AS responsavel
FROM COMPRA c

ORDER BY data_hora DESC
LIMIT 10;

-- Resultado esperado: 10 operações mais recentes (vendas e compras juntas)


-- =====================================================
-- CONSULTA BÔNUS: Produtos com margem de lucro
-- Operadores: >=, ORDER BY, cálculo de margem
-- =====================================================
-- Descrição: Produtos com margem de lucro igual ou superior a 50%

SELECT 
    p.nome_produto,
    c.nome_categoria,
    p.preco_custo,
    p.preco_venda,
    ROUND((p.preco_venda - p.preco_custo), 2) AS lucro_unitario,
    ROUND(((p.preco_venda - p.preco_custo) / p.preco_custo * 100), 2) AS margem_percentual
FROM PRODUTO p
INNER JOIN CATEGORIA c ON p.id_categoria = c.id_categoria
WHERE ((p.preco_venda - p.preco_custo) / p.preco_custo * 100) >= 50
ORDER BY margem_percentual DESC;

-- Resultado esperado: Produtos com melhor margem de lucro


-- =====================================================
-- VERIFICAÇÃO: Executar todas as consultas de uma vez
-- =====================================================
-- 
-- Cada consulta deve retornar resultados válidos

-- =====================================================
-- RESUMO DOS REQUISITOS ATENDIDOS:
-- =====================================================
-- Parâmetros de seleção:
--   - IN (Consulta 1)
--   - NOT IN (Consulta 9)
--   - BETWEEN (Consulta 2)
--   - >= e <= (Consultas 3, 7)
--   - AND e OR (Consultas 2, 7)
--   - LIMIT (Consultas 3, 5, 10)
--
-- Funções de Agregação:
--   - COUNT (Consultas 4, 5, 6, 8)
--   - SUM (Consultas 4, 5, 6, 8)
--   - MIN (Consulta 8)
--   - MAX (Consulta 8)
--
-- Agrupamento e Ordenação:
--   - GROUP BY (Consultas 4, 5, 6, 8)
--   - ORDER BY (Todas as consultas)
--
-- Funções de Junção:
--   - INNER JOIN (Consultas 1-10)
--   - LEFT JOIN (Consulta 6)
--
-- 	Função de União:
--   - UNION ALL (Consulta 10)
-- =====================================================
-- FIM DAS CONSULTAS SQL
-- =====================================================