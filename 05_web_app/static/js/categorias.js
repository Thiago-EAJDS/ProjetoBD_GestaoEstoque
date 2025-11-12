function abrirModalAdicionar() {
  document.getElementById('modalAdicionar').classList.add('active');
}

function fecharModal() {
  document.getElementById('modalAdicionar').classList.remove('active');
}

async function adicionarCategoria(event) {
  event.preventDefault();
  const formData = new FormData(event.target);
  
  try {
    const response = await fetch('/api/categoria/adicionar', {
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

async function deletarCategoria(id, nome, totalProdutos) {
  let mensagem = `Tem certeza que deseja deletar a categoria "${nome}"?`;
  
  if (totalProdutos > 0) {
    mensagem += `\n\nAVISO: Esta categoria possui ${totalProdutos} produto(s).\nTodos os produtos desta categoria serão EXCLUÍDOS!`;
  }
  
  if (!confirm(mensagem)) return;
  
  try {
    const response = await fetch('/api/categoria/deletar/' + id, {
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