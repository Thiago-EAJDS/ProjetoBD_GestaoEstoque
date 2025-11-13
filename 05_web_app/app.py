#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
=====================================================
SISTEMA WEB DE GESTÃO DE ESTOQUE
Backend Flask - Python - VERSÃO CORRIGIDA
=====================================================
"""

from flask import Flask, render_template, request, redirect, url_for, session, jsonify, flash
import sqlite3
import os
from datetime import datetime
from functools import wraps

app = Flask(__name__)
app.secret_key = 'chave-super-secreta-gestao-estoque-2024'

# Configurações
DB_PATH = os.path.join(os.path.dirname(__file__), '../database/gestao_estoque.db')

# Lista de emails de gerentes
GERENTES = [
    'gerente@supermercado.com',
    'admin@supermercado.com',
    'gestor@supermercado.com'
]

# =====================================================
# FUNÇÕES AUXILIARES
# =====================================================

def conectar_bd():
    """Conecta ao banco de dados"""
    try:
        conn = sqlite3.connect(DB_PATH)
        conn.row_factory = sqlite3.Row
        return conn
    except Exception as e:
        print(f"Erro ao conectar ao banco: {e}")
        return None

def login_required(f):
    """Decorator para verificar se usuário está logado"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'email' not in session:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

def gerente_required(f):
    """Decorator para verificar se é gerente"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'email' not in session or session.get('tipo') != 'gerente':
            flash('Acesso negado! Apenas gerentes podem acessar esta área.', 'error')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

# =====================================================
# ROTAS DE AUTENTICAÇÃO
# =====================================================

@app.route('/')
def index():
    """Redireciona para login ou dashboard apropriado"""
    if 'email' in session:
        if session['tipo'] == 'gerente':
            return redirect(url_for('dashboard_gerente'))
        else:
            return redirect(url_for('dashboard_cliente'))
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    """Tela de login"""
    if request.method == 'POST':
        email = request.form.get('email', '').strip().lower()
        nome = request.form.get('nome', '').strip()
        
        if not email or not nome:
            return render_template('login.html', erro='Preencha nome e email')
        
        # Verificar se é gerente
        if email in GERENTES:
            session['email'] = email
            session['nome'] = nome
            session['tipo'] = 'gerente'
            return redirect(url_for('dashboard_gerente'))
        else:
            # É cliente - verificar/criar no banco
            conn = conectar_bd()
            if not conn:
                return render_template('login.html', erro='Erro ao conectar ao banco')
            
            cliente = conn.execute(
                'SELECT * FROM CLIENTE WHERE email = ?', (email,)
            ).fetchone()
            
            if cliente:
                # Cliente existente
                session['id_cliente'] = cliente['id_cliente']
                session['nome'] = cliente['nome_cliente']
                session['email'] = email
            else:
                # Novo cliente
                cursor = conn.cursor()
                cursor.execute(
                    'INSERT INTO CLIENTE (nome_cliente, email) VALUES (?, ?)',
                    (nome, email)
                )
                conn.commit()
                session['id_cliente'] = cursor.lastrowid
                session['nome'] = nome
                session['email'] = email
            
            conn.close()
            session['tipo'] = 'cliente'
            session['carrinho'] = []
            return redirect(url_for('dashboard_cliente'))
    
    return render_template('login.html')

@app.route('/logout')
def logout():
    """Logout do sistema"""
    session.clear()
    return redirect(url_for('login'))

# =====================================================
# DASHBOARD DO GERENTE
# =====================================================

@app.route('/gerente')
@gerente_required
def dashboard_gerente():
    """Dashboard principal do gerente"""
    conn = conectar_bd()
    if not conn:
        return "Erro ao conectar ao banco de dados", 500
    
    try:
        # Estatísticas gerais
        stats = {
            'total_produtos': conn.execute('SELECT COUNT(*) FROM PRODUTO').fetchone()[0],
            'total_vendas': conn.execute('SELECT COUNT(*) FROM VENDA').fetchone()[0],
            'total_funcionarios': conn.execute('SELECT COUNT(*) FROM FUNCIONARIO').fetchone()[0],
            'valor_total_vendas': conn.execute('SELECT COALESCE(SUM(valor_total), 0) FROM VENDA').fetchone()[0]
        }
        
        # Produtos com estoque baixo
        produtos_criticos = conn.execute('''
            SELECT p.nome_produto, c.nome_categoria, 
                   p.quantidade_estoque, p.estoque_minimo
            FROM PRODUTO p
            JOIN CATEGORIA c ON p.id_categoria = c.id_categoria
            WHERE p.quantidade_estoque < p.estoque_minimo
            ORDER BY p.quantidade_estoque ASC
            LIMIT 5
        ''').fetchall()
        
        # Produtos mais vendidos
        top_produtos = conn.execute('''
            SELECT p.nome_produto, SUM(iv.quantidade) as total_vendido
            FROM ITEM_VENDA iv
            JOIN PRODUTO p ON iv.id_produto = p.id_produto
            GROUP BY p.id_produto, p.nome_produto
            ORDER BY total_vendido DESC
            LIMIT 5
        ''').fetchall()
        
        return render_template('gerente.html', 
                             stats=stats, 
                             produtos_criticos=produtos_criticos,
                             top_produtos=top_produtos)
    finally:
        conn.close()

@app.route('/gerente/produtos')
@gerente_required
def listar_produtos():
    """Lista todos os produtos com total vendido"""
    conn = conectar_bd()
    if not conn:
        return "Erro ao conectar ao banco de dados", 500

    try:
        produtos = conn.execute('''
            SELECT 
                p.id_produto,
                p.nome_produto,
                p.descricao,
                p.preco_custo,
                p.preco_venda,
                p.quantidade_estoque,
                p.estoque_minimo,
                c.nome_categoria,
                IFNULL(SUM(iv.quantidade), 0) AS vendidos
            FROM PRODUTO p
            JOIN CATEGORIA c ON p.id_categoria = c.id_categoria
            LEFT JOIN ITEM_VENDA iv ON p.id_produto = iv.id_produto
            GROUP BY p.id_produto
            ORDER BY p.nome_produto;
        ''').fetchall()

        categorias = conn.execute('SELECT * FROM CATEGORIA ORDER BY nome_categoria').fetchall()

        return render_template('produtos.html', produtos=produtos, categorias=categorias)
    finally:
        conn.close()

@app.route('/gerente/categorias')
@gerente_required
def listar_categorias():
    """Lista todas as categorias"""
    conn = conectar_bd()
    if not conn:
        return "Erro ao conectar ao banco de dados", 500
    
    try:
        categorias = conn.execute('''
            SELECT c.*, COUNT(p.id_produto) as total_produtos
            FROM CATEGORIA c
            LEFT JOIN PRODUTO p ON c.id_categoria = p.id_categoria
            GROUP BY c.id_categoria
            ORDER BY c.nome_categoria
        ''').fetchall()
        
        return render_template('categorias.html', categorias=categorias)
    finally:
        conn.close()

@app.route('/gerente/vendas')
@gerente_required
def listar_vendas():
    """Lista todas as vendas"""
    conn = conectar_bd()
    if not conn:
        return "Erro ao conectar ao banco de dados", 500

    try:
        vendas = conn.execute('''
            SELECT v.id_venda,
                   v.data_hora,
                   f.nome AS nome_funcionario,
                   c.nome_cliente AS nome_cliente,
                   v.valor_total,
                   v.forma_pagamento
            FROM VENDA v
            JOIN FUNCIONARIO f ON v.id_funcionario = f.id_funcionario
            LEFT JOIN CLIENTE c ON v.id_cliente = c.id_cliente
            ORDER BY v.data_hora DESC
            LIMIT 50
        ''').fetchall()

        return render_template('vendas.html', vendas=vendas)
    finally:
        conn.close()

@app.route('/gerente/clientes')
@gerente_required
def listar_clientes():
    """Lista todos os clientes cadastrados"""
    conn = conectar_bd()
    if not conn:
        return "Erro ao conectar ao banco de dados", 500

    try:
        clientes = conn.execute('''
            SELECT id_cliente, nome_cliente, email, data_cadastro
            FROM CLIENTE
            ORDER BY id_cliente ASC
        ''').fetchall()
        
        return render_template('clientes.html', clientes=clientes)
    finally:
        conn.close()

# =====================================================
# API - CRUD DE CATEGORIAS
# =====================================================

@app.route('/api/categoria/adicionar', methods=['POST'])
@gerente_required
def adicionar_categoria():
    """Adiciona nova categoria"""
    try:
        conn = conectar_bd()
        if not conn:
            return jsonify({'success': False, 'message': 'Erro ao conectar ao banco'}), 500
        
        conn.execute('''
            INSERT INTO CATEGORIA (nome_categoria, descricao)
            VALUES (?, ?)
        ''', (request.form['nome'], request.form.get('descricao', '')))
        
        conn.commit()
        conn.close()
        
        return jsonify({'success': True, 'message': 'Categoria adicionada com sucesso!'})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@app.route('/api/categoria/deletar/<int:id>', methods=['POST'])
@gerente_required
def deletar_categoria(id):
    """Deleta categoria e todos seus produtos"""
    try:
        conn = conectar_bd()
        if not conn:
            return jsonify({'success': False, 'message': 'Erro ao conectar ao banco'}), 500
        
        # Deleta produtos da categoria
        conn.execute('DELETE FROM PRODUTO WHERE id_categoria = ?', (id,))
        # Deleta a categoria
        conn.execute('DELETE FROM CATEGORIA WHERE id_categoria = ?', (id,))
        
        conn.commit()
        conn.close()
        
        return jsonify({'success': True, 'message': 'Categoria e produtos deletados com sucesso!'})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

# =====================================================
# API - CRUD DE PRODUTOS
# =====================================================

@app.route('/api/produto/adicionar', methods=['POST'])
@gerente_required
def adicionar_produto():
    """Adiciona novo produto"""
    try:
        dados = request.form
        conn = conectar_bd()
        if not conn:
            return jsonify({'success': False, 'message': 'Erro ao conectar ao banco'}), 500
        
        conn.execute('''
            INSERT INTO PRODUTO 
            (nome_produto, descricao, preco_custo, preco_venda, 
             quantidade_estoque, estoque_minimo, id_categoria)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (
            dados['nome'],
            dados.get('descricao', ''),
            float(dados['preco_custo']),
            float(dados['preco_venda']),
            int(dados['quantidade']),
            int(dados['estoque_minimo']),
            int(dados['id_categoria'])
        ))
        
        conn.commit()
        conn.close()
        
        return jsonify({'success': True, 'message': 'Produto adicionado com sucesso!'})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@app.route('/api/produto/editar/<int:id>', methods=['POST'])
@gerente_required
def editar_produto(id):
    """Edita produto existente"""
    try:
        dados = request.form
        conn = conectar_bd()
        if not conn:
            return jsonify({'success': False, 'message': 'Erro ao conectar ao banco'}), 500
        
        conn.execute('''
            UPDATE PRODUTO 
            SET nome_produto = ?, descricao = ?, preco_custo = ?, 
                preco_venda = ?, quantidade_estoque = ?, estoque_minimo = ?,
                id_categoria = ?
            WHERE id_produto = ?
        ''', (
            dados['nome'],
            dados.get('descricao', ''),
            float(dados['preco_custo']),
            float(dados['preco_venda']),
            int(dados['quantidade']),
            int(dados['estoque_minimo']),
            int(dados['id_categoria']),
            id
        ))
        
        conn.commit()
        conn.close()
        
        return jsonify({'success': True, 'message': 'Produto atualizado com sucesso!'})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

@app.route('/api/produto/deletar/<int:id>', methods=['POST'])
@gerente_required
def deletar_produto(id):
    """Deleta produto"""
    try:
        conn = conectar_bd()
        if not conn:
            return jsonify({'success': False, 'message': 'Erro ao conectar ao banco'}), 500
        
        conn.execute('DELETE FROM PRODUTO WHERE id_produto = ?', (id,))
        conn.commit()
        conn.close()
        
        return jsonify({'success': True, 'message': 'Produto deletado com sucesso!'})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400
    
@app.route('/api/produto/reestocar/<int:id>', methods=['POST'])
@gerente_required
def reestocar_produto(id):
    """Adiciona quantidade ao estoque"""
    try:
        quantidade = int(request.form['quantidade'])
        conn = conectar_bd()
        if not conn:
            return jsonify({'success': False, 'message': 'Erro ao conectar ao banco'}), 500
        
        conn.execute('''
            UPDATE PRODUTO 
            SET quantidade_estoque = quantidade_estoque + ?
            WHERE id_produto = ?
        ''', (quantidade, id))
        
        conn.commit()
        conn.close()
        
        return jsonify({'success': True, 'message': f'{quantidade} unidades adicionadas ao estoque!'})
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 400

# =====================================================
# DASHBOARD DO CLIENTE
# =====================================================

@app.route('/cliente')
@login_required
def dashboard_cliente():
    """Dashboard do cliente (área de compras)"""
    conn = conectar_bd()
    if not conn:
        return "Erro ao conectar ao banco de dados", 500
    
    try:
        # Produtos disponíveis por categoria
        categorias = conn.execute('''
            SELECT c.id_categoria, c.nome_categoria, COUNT(p.id_produto) as qtd_produtos
            FROM CATEGORIA c
            LEFT JOIN PRODUTO p ON c.id_categoria = p.id_categoria
            WHERE p.quantidade_estoque > 0
            GROUP BY c.id_categoria, c.nome_categoria
            ORDER BY c.nome_categoria
        ''').fetchall()
        
        # Produtos em destaque (mais vendidos ou maior estoque)
        produtos_destaque = conn.execute('''
            SELECT p.*, c.nome_categoria
            FROM PRODUTO p
            JOIN CATEGORIA c ON p.id_categoria = c.id_categoria
            WHERE p.quantidade_estoque > 0
            ORDER BY p.quantidade_estoque DESC
            LIMIT 8
        ''').fetchall()
        
        # Contador do carrinho
        total_itens = len(session.get('carrinho', []))
        
        return render_template('cliente.html', 
                             categorias=categorias,
                             produtos=produtos_destaque,
                             total_itens=total_itens)
    finally:
        conn.close()

@app.route('/cliente/categoria/<int:id>')
@login_required
def produtos_categoria(id):
    """Lista produtos de uma categoria"""
    conn = conectar_bd()
    if not conn:
        return "Erro ao conectar ao banco de dados", 500
    
    try:
        categoria = conn.execute(
            'SELECT * FROM CATEGORIA WHERE id_categoria = ?', (id,)
        ).fetchone()
        
        if not categoria:
            return "Categoria não encontrada", 404
        
        produtos = conn.execute('''
            SELECT * FROM PRODUTO 
            WHERE id_categoria = ? AND quantidade_estoque > 0
            ORDER BY nome_produto
        ''', (id,)).fetchall()
        
        total_itens = len(session.get('carrinho', []))
        
        return render_template('produtos_cliente.html', 
                             categoria=categoria,
                             produtos=produtos,
                             total_itens=total_itens)
    finally:
        conn.close()

# =====================================================
# ROTAS DO CARRINHO 
# =====================================================

@app.route('/api/carrinho/adicionar', methods=['POST'])
@login_required
def adicionar_carrinho():
    """Adiciona produto ao carrinho"""
    try:
        dados = request.json
        
        if 'carrinho' not in session:
            session['carrinho'] = []
        
        carrinho = session['carrinho']
        
        produto_existente = False
        for item in carrinho:
            if item['id'] == dados['id']:
                item['quantidade'] += int(dados['quantidade'])
                produto_existente = True
                break
        
        if not produto_existente:
            carrinho.append({
                'id': dados['id'],
                'nome': dados['nome'],
                'preco': float(dados['preco']),
                'quantidade': int(dados['quantidade'])
            })
        
        session['carrinho'] = carrinho
        session.modified = True
        
        return jsonify({'success': True, 'total_itens': len(carrinho)})
    except Exception as e:
        print(f"Erro adicionar carrinho: {e}")
        return jsonify({'success': False, 'message': str(e)}), 400


@app.route('/cliente/carrinho')
@login_required
def ver_carrinho():
    """Visualiza carrinho"""
    carrinho = session.get('carrinho', [])
    total = sum(item['preco'] * item['quantidade'] for item in carrinho)
    total_itens = len(carrinho)
    return render_template('carrinho.html', carrinho=carrinho, total=total, total_itens=total_itens)


@app.route('/api/carrinho/remover/<int:id>', methods=['POST'])
@login_required
def remover_carrinho(id):
    """Remove item do carrinho"""
    try:
        print(f"DEBUG: Removendo produto ID {id}")
        
        carrinho = session.get('carrinho', [])
        print(f"DEBUG: Carrinho antes: {carrinho}")
        
        carrinho_novo = [item for item in carrinho if item['id'] != id]
        print(f"DEBUG: Carrinho depois: {carrinho_novo}")
        
        session['carrinho'] = carrinho_novo
        session.modified = True
        
        return jsonify({'success': True, 'total_itens': len(carrinho_novo)})
    except Exception as e:
        print(f"ERRO remover: {e}")
        return jsonify({'success': False, 'message': str(e)}), 500


@app.route('/api/carrinho/limpar', methods=['POST'])
@login_required
def limpar_carrinho():
    """Limpa carrinho"""
    try:
        session['carrinho'] = []
        session.modified = True
        return jsonify({'success': True})
    except Exception as e:
        print(f"ERRO limpar: {e}")
        return jsonify({'success': False, 'message': str(e)}), 500


@app.route('/api/carrinho/finalizar', methods=['POST'])
@login_required
def finalizar_compra():
    """Finaliza compra"""
    try:
        carrinho = session.get('carrinho', [])
        
        if not carrinho:
            return jsonify({'success': False, 'message': 'Carrinho vazio'}), 400
        
        conn = conectar_bd()
        if not conn:
            return jsonify({'success': False, 'message': 'Erro ao conectar ao banco'}), 500
        
        total = sum(item['preco'] * item['quantidade'] for item in carrinho)
        
        funcionario = conn.execute('''
            SELECT id_funcionario FROM FUNCIONARIO 
            WHERE id_setor = (SELECT id_setor FROM SETOR WHERE nome_setor = 'Caixa' LIMIT 1)
            LIMIT 1
        ''').fetchone()
        
        if not funcionario:
            conn.close()
            return jsonify({'success': False, 'message': 'Nenhum funcionário disponível'}), 400
        
        cursor = conn.cursor()
        cursor.execute('''
        INSERT INTO VENDA (data_hora, valor_total, forma_pagamento, id_funcionario, id_cliente)
        VALUES (?, ?, ?, ?, ?)
    ''', (datetime.now().strftime('%Y-%m-%d %H:%M:%S'), total, 'Online', funcionario[0], session.get('id_cliente')))
        id_venda = cursor.lastrowid
        
        for item in carrinho:
            subtotal = item['preco'] * item['quantidade']
            cursor.execute('''
                INSERT INTO ITEM_VENDA (id_venda, id_produto, quantidade, preco_unitario, subtotal)
                VALUES (?, ?, ?, ?, ?)
            ''', (id_venda, item['id'], item['quantidade'], item['preco'], subtotal))
            
            cursor.execute('''
                UPDATE PRODUTO 
                SET quantidade_estoque = quantidade_estoque - ?
                WHERE id_produto = ?
            ''', (item['quantidade'], item['id']))
        
        conn.commit()
        conn.close()
        
        session['carrinho'] = []
        session.modified = True
        
        return jsonify({
            'success': True, 
            'message': f'Compra #{id_venda} realizada com sucesso!',
            'redirect': url_for('dashboard_cliente')
        })
    except Exception as e:
        print(f"ERRO finalizar: {e}")
        return jsonify({'success': False, 'message': str(e)}), 500

# =====================================================
# INICIALIZAÇÃO
# =====================================================

if __name__ == '__main__':
    print("=" * 60)
    print("🏪 SISTEMA DE GESTÃO DE ESTOQUE - WEB")
    print("=" * 60)
    print(f"🚀 Servidor iniciando...")
    print(f"📂 Banco de dados: {os.path.abspath(DB_PATH)}")
    print(f"🌐 Acesse: http://localhost:5000")
    print(f"👨‍💼 Gerentes: {', '.join(GERENTES)}")
    print("❗ Deus não ajuda quem cedo madruga :(")
    print("=" * 60)
    
    app.run(debug=True, host='0.0.0.0', port=5000)