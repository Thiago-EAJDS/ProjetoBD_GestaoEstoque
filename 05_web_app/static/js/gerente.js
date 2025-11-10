function abrirModalProduto() {
            document.getElementById('modalProduto').classList.add('active');
        }

        function fecharModal() {
            document.getElementById('modalProduto').classList.remove('active');
        }

        async function adicionarProduto(event) {
            event.preventDefault();
            
            const form = event.target;
            const formData = new FormData(form);
            
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
                alert('Erro ao adicionar produto: ' + error);
            }
        }