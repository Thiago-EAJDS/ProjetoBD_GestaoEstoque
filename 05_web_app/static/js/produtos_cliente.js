        async function adicionar(id, nome, preco) {
    const qtd = parseInt(document.getElementById(`qty-${id}`).value);
    try {
        const res = await fetch('/api/carrinho/adicionar', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({id, nome, preco, quantidade: qtd})
        });
        const result = await res.json();
        if (result.success) {
            alert('✅ Produto adicionado! Total de itens: ' + result.total_itens);
            // Recarregar página para atualizar contador
            location.reload();
        }
    } catch (error) {
        alert('Erro: ' + error);
    }
}