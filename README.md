<div align="center">

# 🏪 Sistema de Gestão de Estoque

**Aplicação web completa para gerenciamento de supermercado, desenvolvida com Python, Flask e SQLite.**
**Projeto Acadêmico.**

---

## 📋 Sobre o Projeto

Sistema web de gestão de estoque desenvolvido como projeto de Banco de Dados. A aplicação simula o ambiente de um supermercado, com dois perfis de acesso distintos: **gerente** e **cliente**, cada um com funcionalidades específicas.

O projeto integra conceitos de banco de dados relacional, desenvolvimento web com Flask e consultas SQL avançadas.

---

## 🗄️ Banco de Dados

O banco possui **12 tabelas** com relacionamentos completos:

| Tabela | Descrição | Registros |
|---|---|---|
| CATEGORIA | Categorias de produtos | 10 |
| PRODUTO | Catálogo de produtos | 30 |
| FORNECEDOR | Fornecedores cadastrados | 10 |
| SETOR | Setores do supermercado | 10 |
| FUNCIONARIO | Funcionários | 12 |
| VENDA | Registro de vendas | 12 |
| COMPRA | Compras de fornecedores | 10 |
| MOVIMENTACAO | Entradas e saídas de estoque | 15 |
| CLIENTE | Clientes cadastrados | — |
| PRODUTO_FORNECEDOR | Relação produto/fornecedor (N:N) | 20 |
| ITEM_VENDA | Itens de cada venda (N:N) | 35+ |
| ITEM_COMPRA | Itens de cada compra (N:N) | 25 |

---

## 🚀 Como Executar

### Pré-requisitos
- Python 3.8+
- pip

### Instalação

**1. Clone o repositório**
```bash
git clone https://github.com/Thiago-EAJDS/ProjetoBD_GestaoEstoque.git
cd ProjetoBD_GestaoEstoque
```

**2. Instale as dependências**
```bash
pip install flask tabulate
```

### ▶️ Rodando a Aplicação Web

```bash
cd 05_web_app
python app.py
```

Acesse no navegador: **http://localhost:5000**

**Credenciais de gerente:**
| E-mail | Tipo |
|---|---|
| gerente@supermercado.com | Gerente |
| admin@supermercado.com | Gerente |
| gestor@supermercado.com | Gerente |

> Qualquer outro e-mail é tratado como cliente e cadastrado automaticamente.

### ▶️ Rodando o Script de Terminal

```bash
cd 04_python
python conexao_banco.py
```

Será exibido um menu interativo com 8 opções de consulta.

---

## 🧠 Consultas SQL Implementadas

O projeto cobre os principais recursos de SQL, organizados em 10 consultas + 1 bônus:

| # | Consulta | Recursos Utilizados |
|---|---|---|
| 1 | Produtos por categorias específicas | `IN`, `INNER JOIN`, `ORDER BY` |
| 2 | Funcionários por faixa salarial | `BETWEEN`, `AND`, `ORDER BY` |
| 3 | Top 5 produtos com estoque crítico | `<=`, `AND`, `LIMIT` |
| 4 | Vendas por forma de pagamento | `COUNT`, `SUM`, `GROUP BY` |
| 5 | Top 10 produtos mais vendidos | `SUM`, `COUNT`, `JOIN`, `LIMIT` |
| 6 | Desempenho de vendas por funcionário | `LEFT JOIN`, `COALESCE`, `GROUP BY` |
| 7 | Movimentações por critério | `>=`, `OR`, `INNER JOIN` |
| 8 | Estatísticas por categoria | `MIN`, `MAX`, `AVG`, `COUNT` |
| 9 | Fornecedores sem produtos | `NOT IN` (subconsulta) |
| 10 | Últimas operações (vendas + compras) | `UNION ALL`, `LIMIT` |
| 🎯 Bônus | Produtos com maior margem de lucro | `>=`, cálculo de percentual |

---

## 🛠️ Tecnologias

**Backend**
- Python 3 · Flask · SQLite3

**Frontend**
- HTML5 · CSS3 · JavaScript

**Bibliotecas**
- `tabulate` — formatação de tabelas no terminal
- `flask` — servidor web e roteamento
- `sqlite3` — conexão nativa com o banco de dados

---

## 👨‍💻 Autor

**Thiago Emanuel Araújo Jorge de Sá**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/thiago-araújo-2005ab369/)
[![Portfólio](https://img.shields.io/badge/Portfólio-7c5cbf?style=flat-square&logo=vercel&logoColor=white)](https://portifolio-thiagoaraujo.vercel.app/)
