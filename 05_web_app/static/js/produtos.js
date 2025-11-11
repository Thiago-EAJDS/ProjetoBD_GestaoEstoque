    function abrirModalAdicionar() {
        document.getElementById('modalAdicionar').classList.add('active');
    }

    function fecharModal(id) {
        document.getElementById(id).classList.remove('active');
    }

    async function adicionarProduto(event) {
        event.preventDefault();
        const formData = new FormData(event.target);
        
        try {
            const response = await fetch('/api/produto/adicionar', {
                method: 'POST',
                body: formData
            });
            
            const result = await response.json();
            
            if (result.success) {
                alert(result.message);
                location.reload();
            } else {
                alert('Erro: ' + result.message);
            }
        } catch (error) {
            alert('Erro: ' + error);
        }
    }

    function editarProduto(id, nome, descricao, custo, venda, qtd, minimo, categoria) {
        document.getElementById('edit_id').value = id;
        document.getElementById('edit_nome').value = nome;
        document.getElementById('edit_descricao').value = descricao;
        document.getElementById('edit_preco_custo').value = custo;
        document.getElementById('edit_preco_venda').value = venda;
        document.getElementById('edit_quantidade').value = qtd;
        document.getElementById('edit_estoque_minimo').value = minimo;
        document.getElementById('edit_categoria').value = categoria;
        document.getElementById('modalEditar').classList.add('active');
    }

    async function salvarEdicao(event) {
        event.preventDefault();
        const formData = new FormData(event.target);
        const id = document.getElementById('edit_id').value;
        
        try {
            const response = await fetch('/api/produto/editar/' + id, {
                method: 'POST',
                body: formData
            });
            
            const result = await response.json();
            
            if (result.success) {
                alert(result.message);
                location.reload();
            } else {
                alert('Erro: ' + result.message);
            }
        } catch (error) {
            alert('Erro: ' + error);
        }
    }

    async function deletarProduto(id, nome) {
        if (!confirm('Tem certeza que deseja deletar "' + nome + '"?')) return;
        
        try {
            const response = await fetch('/api/produto/deletar/' + id, {
                method: 'POST'
            });
            
            const result = await response.json();
            
            if (result.success) {
                alert(result.message);
                location.reload();
            } else {
                alert('Erro: ' + result.message);
            }
        } catch (error) {
            alert('Erro: ' + error);
        }
    }