// Filtragem em tempo real por ID ou nome.
// Compatível com seu HTML: input id="filtroCliente" e table id="tabelaClientes"
function filtrarClientes() {
    const filtro = document.getElementById('filtroCliente').value.trim().toLowerCase();
    const linhas = document.querySelectorAll('#tabelaClientes tbody tr');

    let algumVisivel = false;

    linhas.forEach(linha => {
        // Pega ID e Nome (colunas na ordem do seu HTML)
        const id = linha.cells[0] ? linha.cells[0].textContent.trim().toLowerCase() : '';
        const nome = linha.cells[1] ? linha.cells[1].textContent.trim().toLowerCase() : '';

        // se o filtro for substring do id ou do nome, mostra; senão esconde
        if (id.includes(filtro) || nome.includes(filtro)) {
            linha.style.display = '';
            algumVisivel = true;
        } else {
            linha.style.display = 'none';
        }
    });

    // Opcional: mostrar mensagem quando nenhum cliente for encontrado.
    // Se quiser usar, adicione no HTML após a tabela:
    // <div id="noData" class="no-data" style="display:none">Nenhum cliente encontrado.</div>
    const noDataEl = document.getElementById('noData');
    if (noDataEl) {
        noDataEl.style.display = algumVisivel ? 'none' : '';
    }
}
