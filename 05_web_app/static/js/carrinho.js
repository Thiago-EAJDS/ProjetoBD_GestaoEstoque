async function remover(id, nome) {
    console.log('Removendo produto ID:', id);
    
    if (!confirm(`Remover "${nome}" do carrinho?`)) return;
    
    try {
        console.log('Fazendo requisição para:', `/api/carrinho/remover/${id}`);
        
        const res = await fetch(`/api/carrinho/remover/${id}`, {
            method: 'POST'
        });
        
        console.log('Status da resposta:', res.status);
        
        const result = await res.json();
        console.log('Resultado:', result);
        
        if (result.success) {
            alert('✅ Produto removido!');
            location.reload();
        } else {
            alert('❌ Erro: ' + result.message);
        }
    } catch (error) {
        console.error('Erro completo:', error);
        alert('❌ Erro ao remover: ' + error);
    }
}

    async function limpar() {
        if (!confirm('Limpar todo o carrinho?')) return;
        
        try {
            const res = await fetch('/api/carrinho/limpar', {
                method: 'POST'
            });
            
            const result = await res.json();
            
            if (result.success) {
                alert('✅ Carrinho limpo!');
                location.reload();
            } else {
                alert('❌ Erro: ' + result.message);
            }
        } catch (error) {
            alert('❌ Erro ao limpar: ' + error);
            console.error('Erro:', error);
        }
    }

    async function finalizar() {
        if (!confirm('Confirmar a compra de R$ {{ "%.2f"|format(total) }}?')) return;
        
        try {
            const res = await fetch('/api/carrinho/finalizar', {
                method: 'POST'
            });
            
            const result = await res.json();
            
            if (result.success) {
                alert('✅ ' + result.message);
                window.location.href = result.redirect;
            } else {
                alert('❌ Erro: ' + result.message);
            }
        } catch (error) {
            alert('❌ Erro ao finalizar: ' + error);
            console.error('Erro:', error);
        }
    }