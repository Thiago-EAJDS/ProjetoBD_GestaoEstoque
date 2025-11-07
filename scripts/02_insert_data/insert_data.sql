-- =====================================================
-- POVOAMENTO DO BANCO DE DADOS - SUPERMERCADO
-- Total: 110+ registros (10 por tabela mínimo)
-- =====================================================

-- =====================================================
-- 1. INSERIR CATEGORIAS (10 registros)
-- =====================================================
INSERT INTO CATEGORIA (nome_categoria, descricao) VALUES
('Alimentos', 'Produtos alimentícios em geral'),
('Bebidas', 'Bebidas alcoólicas e não alcoólicas'),
('Higiene Pessoal', 'Produtos de higiene e cuidados pessoais'),
('Limpeza', 'Produtos de limpeza doméstica'),
('Frios e Laticínios', 'Queijos, presuntos, iogurtes e derivados'),
('Hortifruti', 'Frutas, verduras e legumes'),
('Padaria', 'Pães, bolos e confeitaria'),
('Açougue', 'Carnes, aves e peixes'),
('Mercearia', 'Grãos, massas e enlatados'),
('Congelados', 'Produtos congelados e sorvetes');

-- =====================================================
-- 2. INSERIR FORNECEDORES (10 registros)
-- =====================================================
INSERT INTO FORNECEDOR (razao_social, cnpj, telefone, email, endereco, cidade, estado) VALUES
('Distribuidora Alimentos Ltda', '12345678000190', '86912345678', 'contato@alimentos.com', 'Rua das Flores, 100', 'Teresina', 'PI'),
('Bebidas Norte Comércio', '23456789000191', '86923456789', 'vendas@bebidasnorte.com', 'Av. Frei Serafim, 200', 'Teresina', 'PI'),
('Higienorte Distribuidora', '34567890000192', '86934567890', 'comercial@higienorte.com', 'Rua Paissandu, 300', 'Teresina', 'PI'),
('Limpeza Total Ltda', '45678901000193', '86945678901', 'sac@limpezatotal.com', 'Av. Miguel Rosa, 400', 'Teresina', 'PI'),
('Laticínios Piauí SA', '56789012000194', '86956789012', 'vendas@laticiniospiaui.com', 'BR 343, Km 5', 'Teresina', 'PI'),
('Hortifruti Atacado', '67890123000195', '86967890123', 'contato@hortifrutipi.com', 'CEASA, Box 15', 'Teresina', 'PI'),
('Panificadora Central', '78901234000196', '86978901234', 'comercial@panicentral.com', 'Rua Coelho Rodrigues, 500', 'Teresina', 'PI'),
('Frigorífico Nordeste', '89012345000197', '86989012345', 'vendas@frigonordeste.com', 'Distrito Industrial', 'Teresina', 'PI'),
('Cereais Piauí Ltda', '90123456000198', '86990123456', 'sac@cereaispi.com', 'Av. Joaquim Ribeiro, 600', 'Teresina', 'PI'),
('Gelados do Norte SA', '01234567000199', '86901234567', 'comercial@geladosnorte.com', 'Rua Desembargador Pires, 700', 'Teresina', 'PI');

-- =====================================================
-- 3. INSERIR SETORES (10 registros)
-- =====================================================
INSERT INTO SETOR (nome_setor, descricao) VALUES
('Caixa', 'Setor de operação de caixas e atendimento'),
('Estoque', 'Controle e organização do estoque'),
('Açougue', 'Preparação e venda de carnes'),
('Padaria', 'Produção de pães e confeitaria'),
('Hortifruti', 'Seleção e exposição de frutas e verduras'),
('Gerência', 'Administração e gestão do supermercado'),
('Limpeza', 'Manutenção e limpeza do estabelecimento'),
('Segurança', 'Segurança patrimonial e pessoal'),
('Empacotamento', 'Empacotamento de compras'),
('Repositor', 'Reposição de produtos nas prateleiras');

-- =====================================================
-- 4. INSERIR FUNCIONÁRIOS (12 registros)
-- =====================================================
INSERT INTO FUNCIONARIO (nome, cpf, cargo, salario, data_admissao, telefone, id_setor) VALUES
('Maria Silva Santos', '12345678901', 'Gerente Geral', 5500.00, '2020-01-15', '86991234567', 6),
('João Pedro Oliveira', '23456789012', 'Supervisor de Estoque', 3200.00, '2020-03-10', '86992345678', 2),
('Ana Carolina Costa', '34567890123', 'Operadora de Caixa', 1800.00, '2021-06-20', '86993456789', 1),
('Carlos Eduardo Lima', '45678901234', 'Açougueiro', 2500.00, '2021-02-05', '86994567890', 3),
('Francisca Dias Sousa', '56789012345', 'Padeira', 2200.00, '2021-08-12', '86995678901', 4),
('José Roberto Alves', '67890123456', 'Operador de Caixa', 1800.00, '2022-01-15', '86996789012', 1),
('Mariana Ferreira', '78901234567', 'Repositora', 1650.00, '2022-04-20', '86997890123', 10),
('Paulo Henrique Santos', '89012345678', 'Auxiliar de Limpeza', 1500.00, '2022-07-10', '86998901234', 7),
('Juliana Mendes', '90123456789', 'Operadora de Caixa', 1800.00, '2023-02-01', '86999012345', 1),
('Ricardo Souza Silva', '01234567890', 'Repositor', 1650.00, '2023-05-15', '86990123456', 10),
('Fernanda Lima Costa', '11234567891', 'Atendente Hortifruti', 1700.00, '2023-08-20', '86991234568', 5),
('Lucas Martins Rocha', '22234567892', 'Empacotador', 1550.00, '2024-01-10', '86992234569', 9);

-- =====================================================
-- 5. INSERIR PRODUTOS (30 registros - 3 por categoria)
-- =====================================================
-- Categoria 1: Alimentos
INSERT INTO PRODUTO (nome_produto, descricao, preco_custo, preco_venda, quantidade_estoque, estoque_minimo, data_validade, codigo_barras, id_categoria) VALUES
('Arroz Tipo 1 5kg', 'Arroz branco tipo 1 pacote 5kg', 15.50, 22.90, 150, 30, '2025-12-31', '7891234567801', 1),
('Feijão Preto 1kg', 'Feijão preto tipo 1 pacote 1kg', 6.00, 9.50, 200, 40, '2025-10-31', '7891234567802', 1),
('Macarrão Espaguete 500g', 'Macarrão espaguete com ovos', 3.20, 5.90, 180, 35, '2026-03-31', '7891234567803', 1),

-- Categoria 2: Bebidas
('Refrigerante Cola 2L', 'Refrigerante sabor cola 2 litros', 4.50, 7.99, 120, 25, '2025-06-30', '7891234567804', 2),
('Suco Laranja 1L', 'Suco natural de laranja 1 litro', 6.00, 10.50, 90, 20, '2025-05-15', '7891234567805', 2),
('Água Mineral 500ml', 'Água mineral sem gás 500ml', 1.00, 2.50, 300, 60, '2026-12-31', '7891234567806', 2),

-- Categoria 3: Higiene Pessoal
('Sabonete Líquido 250ml', 'Sabonete líquido hidratante', 8.00, 14.90, 80, 15, '2026-08-31', '7891234567807', 3),
('Shampoo 400ml', 'Shampoo para todos os tipos de cabelo', 12.00, 19.90, 70, 15, '2026-09-30', '7891234567808', 3),
('Creme Dental 90g', 'Creme dental com flúor', 4.50, 7.90, 150, 30, '2026-07-31', '7891234567809', 3),

-- Categoria 4: Limpeza
('Detergente Líquido 500ml', 'Detergente líquido neutro', 2.50, 4.50, 200, 40, '2026-12-31', '7891234567810', 4),
('Água Sanitária 1L', 'Água sanitária para limpeza', 3.00, 5.50, 150, 30, '2026-06-30', '7891234567811', 4),
('Sabão em Pó 1kg', 'Sabão em pó para roupas', 8.00, 14.50, 100, 20, '2026-11-30', '7891234567812', 4),

-- Categoria 5: Frios e Laticínios
('Queijo Mussarela 500g', 'Queijo mussarela fatiado', 18.00, 29.90, 60, 12, '2025-02-28', '7891234567813', 5),
('Presunto Fatiado 200g', 'Presunto cozido fatiado', 10.00, 16.90, 50, 10, '2025-02-15', '7891234567814', 5),
('Iogurte Natural 170g', 'Iogurte natural integral', 2.50, 4.50, 100, 20, '2025-01-31', '7891234567815', 5),

-- Categoria 6: Hortifruti
('Tomate kg', 'Tomate fresco por kg', 4.00, 7.50, 80, 15, '2024-11-15', '7891234567816', 6),
('Alface Unidade', 'Alface crespa unidade', 2.00, 3.50, 50, 10, '2024-11-10', '7891234567817', 6),
('Banana kg', 'Banana prata por kg', 3.50, 6.00, 100, 20, '2024-11-20', '7891234567818', 6),

-- Categoria 7: Padaria
('Pão Francês kg', 'Pão francês fresquinho', 8.00, 14.00, 40, 10, '2024-11-01', '7891234567819', 7),
('Bolo de Chocolate Fatia', 'Fatia de bolo de chocolate', 5.00, 9.00, 30, 5, '2024-11-03', '7891234567820', 7),
('Croissant Unidade', 'Croissant de manteiga', 3.00, 6.50, 35, 8, '2024-11-02', '7891234567821', 7),

-- Categoria 8: Açougue
('Picanha kg', 'Carne bovina picanha por kg', 45.00, 75.00, 30, 5, '2024-11-05', '7891234567822', 8),
('Frango Inteiro kg', 'Frango inteiro resfriado', 8.00, 14.00, 50, 10, '2024-11-08', '7891234567823', 8),
('Linguiça Toscana kg', 'Linguiça toscana artesanal', 18.00, 29.90, 40, 8, '2024-11-06', '7891234567824', 8),

-- Categoria 9: Mercearia
('Óleo de Soja 900ml', 'Óleo de soja refinado', 6.00, 10.50, 120, 25, '2026-04-30', '7891234567825', 9),
('Café Torrado 500g', 'Café torrado e moído', 12.00, 19.90, 80, 15, '2025-12-31', '7891234567826', 9),
('Açúcar Cristal 1kg', 'Açúcar cristal branco', 3.00, 5.50, 150, 30, '2026-08-31', '7891234567827', 9),

-- Categoria 10: Congelados
('Pizza Congelada 460g', 'Pizza congelada sabor mussarela', 12.00, 19.90, 45, 10, '2025-08-31', '7891234567828', 10),
('Sorvete 2L', 'Sorvete sabor napolitano 2 litros', 18.00, 29.90, 40, 8, '2025-06-30', '7891234567829', 10),
('Lasanha Congelada 600g', 'Lasanha à bolonhesa congelada', 15.00, 24.90, 35, 7, '2025-07-31', '7891234567830', 10);

-- =====================================================
-- 6. INSERIR VENDAS (12 registros)
-- =====================================================
INSERT INTO VENDA (data_hora, valor_total, forma_pagamento, id_funcionario) VALUES
('2024-10-20 09:15:00', 156.80, 'Débito', 3),
('2024-10-20 10:30:00', 89.50, 'Crédito', 3),
('2024-10-20 14:20:00', 245.90, 'Pix', 6),
('2024-10-21 08:45:00', 67.30, 'Dinheiro', 6),
('2024-10-21 11:10:00', 178.40, 'Crédito', 9),
('2024-10-21 16:30:00', 92.70, 'Débito', 9),
('2024-10-22 09:00:00', 315.60, 'Crédito', 3),
('2024-10-22 12:45:00', 128.90, 'Pix', 6),
('2024-10-23 10:20:00', 201.50, 'Débito', 9),
('2024-10-23 15:15:00', 56.80, 'Dinheiro', 3),
('2024-10-24 09:30:00', 412.30, 'Crédito', 6),
('2024-10-24 14:00:00', 189.20, 'Pix', 9);

-- =====================================================
-- 7. INSERIR COMPRAS (10 registros)
-- =====================================================
INSERT INTO COMPRA (data_compra, valor_total, numero_nota_fiscal, id_fornecedor) VALUES
('2024-10-01', 5800.00, 'NF-2024-0001', 1),
('2024-10-03', 3200.00, 'NF-2024-0002', 2),
('2024-10-05', 2900.00, 'NF-2024-0003', 3),
('2024-10-07', 1800.00, 'NF-2024-0004', 4),
('2024-10-10', 4500.00, 'NF-2024-0005', 5),
('2024-10-12', 2100.00, 'NF-2024-0006', 6),
('2024-10-15', 3700.00, 'NF-2024-0007', 7),
('2024-10-18', 6200.00, 'NF-2024-0008', 8),
('2024-10-20', 2800.00, 'NF-2024-0009', 9),
('2024-10-22', 3400.00, 'NF-2024-0010', 10);

-- =====================================================
-- 8. INSERIR MOVIMENTAÇÕES (15 registros)
-- =====================================================
INSERT INTO MOVIMENTACAO (data_hora, tipo_movimentacao, quantidade, motivo, id_produto, id_funcionario) VALUES
('2024-10-01 08:00:00', 'ENTRADA', 100, 'Compra de fornecedor', 1, 2),
('2024-10-01 08:15:00', 'ENTRADA', 150, 'Compra de fornecedor', 2, 2),
('2024-10-02 09:00:00', 'ENTRADA', 80, 'Compra de fornecedor', 13, 2),
('2024-10-15 14:30:00', 'SAIDA', 5, 'Produto vencido', 16, 2),
('2024-10-16 10:00:00', 'ENTRADA', 50, 'Reposição de estoque', 4, 7),
('2024-10-17 11:20:00', 'SAIDA', 3, 'Produto danificado', 10, 2),
('2024-10-18 08:30:00', 'ENTRADA', 120, 'Compra de fornecedor', 7, 2),
('2024-10-19 15:00:00', 'ENTRADA', 200, 'Compra de fornecedor', 11, 2),
('2024-10-20 09:00:00', 'SAIDA', 10, 'Promoção - perda', 22, 2),
('2024-10-21 10:30:00', 'ENTRADA', 60, 'Devolução fornecedor', 19, 2),
('2024-10-22 14:00:00', 'ENTRADA', 90, 'Compra de fornecedor', 25, 2),
('2024-10-23 08:45:00', 'SAIDA', 8, 'Avaria no transporte', 28, 2),
('2024-10-24 11:00:00', 'ENTRADA', 45, 'Reposição urgente', 29, 7),
('2024-10-25 09:30:00', 'ENTRADA', 70, 'Compra de fornecedor', 14, 2),
('2024-10-26 16:00:00', 'SAIDA', 4, 'Produto danificado', 20, 2);

-- =====================================================
-- 9. INSERIR PRODUTO_FORNECEDOR (20 registros)
-- =====================================================
INSERT INTO PRODUTO_FORNECEDOR (id_produto, id_fornecedor, preco_fornecimento) VALUES
(1, 1, 15.50), (2, 1, 6.00), (3, 9, 3.20),
(4, 2, 4.50), (5, 2, 6.00), (6, 2, 1.00),
(7, 3, 8.00), (8, 3, 12.00), (9, 3, 4.50),
(10, 4, 2.50), (11, 4, 3.00), (12, 4, 8.00),
(13, 5, 18.00), (14, 5, 10.00), (15, 5, 2.50),
(16, 6, 4.00), (17, 6, 2.00), (18, 6, 3.50),
(19, 7, 8.00), (20, 7, 5.00);

-- =====================================================
-- 10. INSERIR ITENS_VENDA (35 registros)
-- =====================================================
INSERT INTO ITEM_VENDA (id_venda, id_produto, quantidade, preco_unitario, subtotal) VALUES
-- Venda 1
(1, 1, 2, 22.90, 45.80),
(1, 4, 3, 7.99, 23.97),
(1, 13, 1, 29.90, 29.90),
(1, 19, 2, 14.00, 28.00),
(1, 25, 1, 10.50, 10.50),
-- Venda 2
(2, 2, 1, 9.50, 9.50),
(2, 7, 2, 14.90, 29.80),
(2, 10, 3, 4.50, 13.50),
(2, 16, 2, 7.50, 15.00),
-- Venda 3
(3, 22, 2, 75.00, 150.00),
(3, 23, 1, 14.00, 14.00),
(3, 26, 2, 19.90, 39.80),
(3, 1, 1, 22.90, 22.90),
-- Venda 4
(4, 3, 2, 5.90, 11.80),
(4, 6, 4, 2.50, 10.00),
(4, 17, 3, 3.50, 10.50),
(4, 20, 2, 9.00, 18.00),
-- Venda 5
(5, 13, 2, 29.90, 59.80),
(5, 14, 2, 16.90, 33.80),
(5, 15, 4, 4.50, 18.00),
(5, 5, 3, 10.50, 31.50),
-- Venda 6
(6, 8, 1, 19.90, 19.90),
(6, 11, 2, 5.50, 11.00),
(6, 18, 3, 6.00, 18.00),
(6, 27, 2, 5.50, 11.00),
-- Venda 7
(7, 22, 3, 75.00, 225.00),
(7, 24, 2, 29.90, 59.80),
(7, 9, 1, 7.90, 7.90),
-- Venda 8
(8, 28, 2, 19.90, 39.80),
(8, 29, 1, 29.90, 29.90),
(8, 30, 1, 24.90, 24.90),
(8, 12, 1, 14.50, 14.50),
-- Venda 9
(9, 1, 3, 22.90, 68.70),
(9, 2, 2, 9.50, 19.00),
(9, 25, 4, 10.50, 42.00),
-- Venda 10
(10, 19, 2, 14.00, 28.00),
(10, 21, 3, 6.50, 19.50);

-- =====================================================
-- 11. INSERIR ITENS_COMPRA (25 registros)
-- =====================================================
INSERT INTO ITEM_COMPRA (id_compra, id_produto, quantidade, preco_unitario) VALUES
-- Compra 1
(1, 1, 100, 15.50), (1, 2, 150, 6.00), (1, 3, 80, 3.20),
-- Compra 2
(2, 4, 120, 4.50), (2, 5, 90, 6.00), (2, 6, 300, 1.00),
-- Compra 3
(3, 7, 80, 8.00), (3, 8, 70, 12.00), (3, 9, 150, 4.50),
-- Compra 4
(4, 10, 200, 2.50), (4, 11, 150, 3.00), (4, 12, 100, 8.00),
-- Compra 5
(5, 13, 60, 18.00), (5, 14, 50, 10.00), (5, 15, 100, 2.50),
-- Compra 6
(6, 16, 80, 4.00), (6, 17, 50, 2.00), (6, 18, 100, 3.50),
-- Compra 7
(7, 19, 40, 8.00), (7, 20, 30, 5.00), (7, 21, 35, 3.00),
-- Compra 8
(8, 22, 30, 45.00), (8, 23, 50, 8.00), (8, 24, 40, 18.00),
-- Compra 9
(9, 25, 120, 6.00), (9, 26, 80, 12.00);

-- =====================================================
-- VERIFICAÇÃO DOS DADOS INSERIDOS
-- =====================================================
SELECT 'CATEGORIA' as Tabela, COUNT(*) as Total FROM CATEGORIA
UNION ALL
SELECT 'FORNECEDOR', COUNT(*) FROM FORNECEDOR
UNION ALL
SELECT 'SETOR', COUNT(*) FROM SETOR
UNION ALL
SELECT 'FUNCIONARIO', COUNT(*) FROM FUNCIONARIO
UNION ALL
SELECT 'PRODUTO', COUNT(*) FROM PRODUTO
UNION ALL
SELECT 'VENDA', COUNT(*) FROM VENDA
UNION ALL
SELECT 'COMPRA', COUNT(*) FROM COMPRA
UNION ALL
SELECT 'MOVIMENTACAO', COUNT(*) FROM MOVIMENTACAO
UNION ALL
SELECT 'PRODUTO_FORNECEDOR', COUNT(*) FROM PRODUTO_FORNECEDOR
UNION ALL
SELECT 'ITEM_VENDA', COUNT(*) FROM ITEM_VENDA
UNION ALL
SELECT 'ITEM_COMPRA', COUNT(*) FROM ITEM_COMPRA;

-- =====================================================
-- FIM DO POVOAMENTO
-- =====================================================
