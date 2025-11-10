// Atualizar contador do carrinho
function atualizarContador() {
    const carrinho = JSON.parse(localStorage.getItem('carrinho') || '[]');
    document.getElementById('cartCount').textContent = carrinho.length;
}

function diminuir(id) {
    const input = document.getElementById('qty-' + id);  // ✅ CORRIGIDO
    if (input.value > 1) {
        input.value = parseInt(input.value) - 1;
    }
}

function aumentar(id, max) {
    const input = document.getElementById('qty-' + id);  // ✅ CORRIGIDO
    if (input.value < max) {
        input.value = parseInt(input.value) + 1;
    }
}

// Atualizar contador sem reload
async function adicionarCarrinho(id, nome, preco) {
    const quantidade = parseInt(document.getElementById('qty-' + id).value);  // ✅ CORRIGIDO
    
    try {
        const response = await fetch('/api/carrinho/adicionar', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({ id, nome, preco, quantidade })
        });
        
        const result = await response.json();
        
        if (result.success) {
            // Atualizar contador dinamicamente
            document.getElementById('cartCount').textContent = result.total_itens;
            
            // Animação de feedback
            const cartBtn = document.querySelector('.cart-btn');
            cartBtn.style.transform = 'scale(1.2)';
            setTimeout(() => {
                cartBtn.style.transform = 'scale(1)';
            }, 200);
            
            alert('✅ ' + nome + ' adicionado ao carrinho!');  // ✅ CORRIGIDO
        } else {
            alert('❌ Erro ao adicionar ao carrinho');
        }
    } catch (error) {
        alert('❌ Erro: ' + error);
    }
}

// Carregar contador ao iniciar
atualizarContador();