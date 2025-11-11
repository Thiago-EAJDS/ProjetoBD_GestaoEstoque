#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
=====================================================
EXTENSÃO TECNOLÓGICA - PYTHON + SQLITE
Sistema de Gestão de Estoque - Supermercado
Data: Novembro 2024
=====================================================
Objetivo: Demonstrar conexão ao banco de dados SQLite
usando Python e visualização de dados
=====================================================
"""

import sqlite3
import os
from datetime import datetime

# Biblioteca para formatação de tabelas (instalar: pip3 install tabulate)
try:
    from tabulate import tabulate
except ImportError:
    print("⚠️  Biblioteca 'tabulate' não encontrada!")
    print("📦 Instale com: pip3 install tabulate")
    exit(1)

# =====================================================
# CONFIGURAÇÕES
# =====================================================

# Caminho do banco de dados
DB_PATH = "../database/gestao_estoque.db"

# =====================================================
# FUNÇÕES AUXILIARES
# =====================================================

def conectar_banco():
    """
    Estabelece conexão com o banco de dados SQLite
    Retorna: objeto de conexão
    """
    try:
        # Verificar se o arquivo do banco existe
        if not os.path.exists(DB_PATH):
            print(f"❌ Erro: Banco de dados não encontrado em {DB_PATH}")
            print("📁 Certifique-se de que o arquivo gestao_estoque.db existe")
            return None
        
        # Conectar ao banco
        conexao = sqlite3.connect(DB_PATH)
        print(f"✅ Conexão estabelecida com sucesso!")
        print(f"📂 Banco: {os.path.abspath(DB_PATH)}\n")
        return conexao
    
    except sqlite3.Error as e:
        print(f"❌ Erro ao conectar ao banco: {e}")
        return None


def executar_consulta(conexao, sql, titulo="Resultado da Consulta"):
    """
    Executa uma consulta SQL e exibe os resultados formatados
    
    Args:
        conexao: objeto de conexão do SQLite
        sql: string com a consulta SQL
        titulo: título para exibir acima dos resultados
    """
    try:
        cursor = conexao.cursor()
        cursor.execute(sql)
        
        # Obter resultados
        resultados = cursor.fetchall()
        colunas = [descricao[0] for descricao in cursor.description]
        
        # Exibir resultados
        print("=" * 80)
        print(f"📊 {titulo}")
        print("=" * 80)
        
        if resultados:
            # Formatar como tabela
            tabela = tabulate(resultados, headers=colunas, tablefmt="grid")
            print(tabela)
            print(f"\n📈 Total de registros: {len(resultados)}\n")
        else:
            print("⚠️  Nenhum registro encontrado.\n")
        
        cursor.close()
        return resultados
    
    except sqlite3.Error as e:
        print(f"❌ Erro ao executar consulta: {e}\n")
        return None


def listar_tabelas(conexao):
    """
    Lista todas as tabelas do banco de dados
    """
    sql = "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;"
    return executar_consulta(conexao, sql, "Tabelas do Banco de Dados")


def estatisticas_gerais(conexao):
    """
    Exibe estatísticas gerais do banco de dados
    """
    print("\n" + "=" * 80)
    print("📊 ESTATÍSTICAS GERAIS DO BANCO DE DADOS")
    print("=" * 80 + "\n")
    
    # Contagem de registros por tabela
    tabelas = [
        'CATEGORIA', 'FORNECEDOR', 'SETOR', 'FUNCIONARIO', 
        'PRODUTO', 'VENDA', 'COMPRA', 'MOVIMENTACAO',
        'PRODUTO_FORNECEDOR', 'ITEM_VENDA', 'ITEM_COMPRA'
    ]
    
    dados = []
    total_geral = 0
    
    for tabela in tabelas:
        try:
            cursor = conexao.cursor()
            cursor.execute(f"SELECT COUNT(*) FROM {tabela}")
            count = cursor.fetchone()[0]
            dados.append([tabela, count])
            total_geral += count
            cursor.close()
        except sqlite3.Error:
            dados.append([tabela, "Erro"])
    
    # Adicionar total
    dados.append(["─" * 20, "─" * 10])
    dados.append(["TOTAL GERAL", total_geral])
    
    print(tabulate(dados, headers=["Tabela", "Registros"], tablefmt="grid"))
    print()


# =====================================================
# CONSULTAS ESPECÍFICAS
# =====================================================

def consulta_produtos_estoque_baixo(conexao):
    """
    Consulta 1: Produtos com estoque abaixo do mínimo
    """
    sql = """
    SELECT 
        p.nome_produto AS Produto,
        c.nome_categoria AS Categoria,
        p.quantidade_estoque AS 'Estoque Atual',
        p.estoque_minimo AS 'Estoque Mínimo',
        (p.estoque_minimo - p.quantidade_estoque) AS 'Qtd. Repor'
    FROM PRODUTO p
    INNER JOIN CATEGORIA c ON p.id_categoria = c.id_categoria
    WHERE p.quantidade_estoque < p.estoque_minimo
    ORDER BY (p.estoque_minimo - p.quantidade_estoque) DESC;
    """
    return executar_consulta(conexao, sql, "Produtos com Estoque Crítico")


def consulta_vendas_por_pagamento(conexao):
    """
    Consulta 2: Total de vendas por forma de pagamento
    """
    sql = """
    SELECT 
        forma_pagamento AS 'Forma Pagamento',
        COUNT(*) AS 'Total Vendas',
        PRINTF('R$ %.2f', SUM(valor_total)) AS 'Valor Total',
        PRINTF('R$ %.2f', AVG(valor_total)) AS 'Ticket Médio'
    FROM VENDA
    GROUP BY forma_pagamento
    ORDER BY SUM(valor_total) DESC;
    """
    return executar_consulta(conexao, sql, "Vendas por Forma de Pagamento")


def consulta_top_produtos(conexao, limite=5):
    """
    Consulta 3: Top N produtos mais vendidos
    """
    sql = f"""
    SELECT 
        p.nome_produto AS Produto,
        c.nome_categoria AS Categoria,
        SUM(iv.quantidade) AS 'Qtd. Vendida',
        COUNT(DISTINCT iv.id_venda) AS 'Nº Vendas',
        PRINTF('R$ %.2f', SUM(iv.subtotal)) AS 'Faturamento'
    FROM ITEM_VENDA iv
    INNER JOIN PRODUTO p ON iv.id_produto = p.id_produto
    INNER JOIN CATEGORIA c ON p.id_categoria = c.id_categoria
    GROUP BY p.id_produto, p.nome_produto, c.nome_categoria
    ORDER BY SUM(iv.quantidade) DESC
    LIMIT {limite};
    """
    return executar_consulta(conexao, sql, f"Top {limite} Produtos Mais Vendidos")


def consulta_funcionarios_vendas(conexao):
    """
    Consulta 4: Desempenho de vendas por funcionário
    """
    sql = """
    SELECT 
        f.nome AS Funcionário,
        s.nome_setor AS Setor,
        COUNT(v.id_venda) AS 'Total Vendas',
        PRINTF('R$ %.2f', COALESCE(SUM(v.valor_total), 0)) AS 'Valor Vendido'
    FROM FUNCIONARIO f
    INNER JOIN SETOR s ON f.id_setor = s.id_setor
    LEFT JOIN VENDA v ON f.id_funcionario = v.id_funcionario
    WHERE s.nome_setor = 'Caixa'
    GROUP BY f.id_funcionario, f.nome, s.nome_setor
    ORDER BY COALESCE(SUM(v.valor_total), 0) DESC;
    """
    return executar_consulta(conexao, sql, "Desempenho de Vendas - Funcionários do Caixa")


def consulta_estatisticas_categorias(conexao):
    """
    Consulta 5: Estatísticas de produtos por categoria
    """
    sql = """
    SELECT 
        c.nome_categoria AS Categoria,
        COUNT(p.id_produto) AS 'Qtd. Produtos',
        PRINTF('R$ %.2f', MIN(p.preco_venda)) AS 'Menor Preço',
        PRINTF('R$ %.2f', MAX(p.preco_venda)) AS 'Maior Preço',
        PRINTF('R$ %.2f', AVG(p.preco_venda)) AS 'Preço Médio',
        SUM(p.quantidade_estoque) AS 'Estoque Total'
    FROM CATEGORIA c
    INNER JOIN PRODUTO p ON c.id_categoria = p.id_categoria
    GROUP BY c.id_categoria, c.nome_categoria
    ORDER BY SUM(p.quantidade_estoque) DESC;
    """
    return executar_consulta(conexao, sql, "Estatísticas por Categoria")


# =====================================================
# MENU INTERATIVO
# =====================================================

def exibir_menu():
    """
    Exibe menu de opções
    """
    print("\n" + "=" * 80)
    print("🏪 SISTEMA DE GESTÃO DE ESTOQUE - MENU PRINCIPAL")
    print("=" * 80)
    print("1. Listar todas as tabelas")
    print("2. Estatísticas gerais do banco")
    print("3. Produtos com estoque crítico")
    print("4. Vendas por forma de pagamento")
    print("5. Top 5 produtos mais vendidos")
    print("6. Desempenho de vendas dos funcionários")
    print("7. Estatísticas por categoria")
    print("8. Executar todas as consultas")
    print("0. Sair")
    print("=" * 80)


def menu_principal(conexao):
    """
    Menu interativo principal
    """
    while True:
        exibir_menu()
        
        try:
            opcao = input("\n👉 Escolha uma opção: ").strip()
            
            if opcao == "1":
                listar_tabelas(conexao)
            
            elif opcao == "2":
                estatisticas_gerais(conexao)
            
            elif opcao == "3":
                consulta_produtos_estoque_baixo(conexao)
            
            elif opcao == "4":
                consulta_vendas_por_pagamento(conexao)
            
            elif opcao == "5":
                consulta_top_produtos(conexao, 5)
            
            elif opcao == "6":
                consulta_funcionarios_vendas(conexao)
            
            elif opcao == "7":
                consulta_estatisticas_categorias(conexao)
            
            elif opcao == "8":
                print("\n🚀 Executando todas as consultas...\n")
                listar_tabelas(conexao)
                estatisticas_gerais(conexao)
                consulta_produtos_estoque_baixo(conexao)
                consulta_vendas_por_pagamento(conexao)
                consulta_top_produtos(conexao, 5)
                consulta_funcionarios_vendas(conexao)
                consulta_estatisticas_categorias(conexao)
            
            elif opcao == "0":
                print("\n👋 Encerrando o sistema...")
                break
            
            else:
                print("\n⚠️  Opção inválida! Tente novamente.")
        
        except KeyboardInterrupt:
            print("\n\n👋 Programa interrompido pelo usuário.")
            break
        except Exception as e:
            print(f"\n❌ Erro: {e}")


# =====================================================
# FUNÇÃO PRINCIPAL
# =====================================================

def main():
    """
    Função principal do programa
    """
    print("\n" + "=" * 80)
    print("🐍 PYTHON + SQLITE - GESTÃO DE ESTOQUE")
    print("=" * 80)
    print(f"📅 Data/Hora: {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}")
    print("=" * 80 + "\n")
    
    # Conectar ao banco
    conexao = conectar_banco()
    
    if conexao:
        try:
            # Iniciar menu interativo
            menu_principal(conexao)
        
        finally:
            # Fechar conexão
            conexao.close()
            print("✅ Conexão fechada com sucesso!")
            print("\n" + "=" * 80)
            print("📊 Fim da execução")
            print("=" * 80 + "\n")
    else:
        print("❌ Não foi possível estabelecer conexão com o banco de dados.")
        exit(1)


# =====================================================
# EXECUÇÃO DO PROGRAMA
# =====================================================

if __name__ == "__main__":
    main()
