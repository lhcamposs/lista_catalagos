import 'package:flutter/material.dart';

import '../models/produto.dart';
import '../theme/app_theme.dart';
import '../viewmodels/catalogo_viewmodel.dart';
import 'cadastro_produto_view.dart';
import 'widgets/produto_card.dart';

/// VIEW da tela principal: apenas desenha o estado do CatalogoViewModel
/// e repassa as ações do usuário para ele.
class CatalogoView extends StatefulWidget {
  const CatalogoView({super.key, this.viewModel});

  /// Permite injetar o ViewModel (útil em testes).
  final CatalogoViewModel? viewModel;

  @override
  State<CatalogoView> createState() => _CatalogoViewState();
}

class _CatalogoViewState extends State<CatalogoView> {
  late final CatalogoViewModel _viewModel = widget.viewModel ?? CatalogoViewModel();

  @override
  void dispose() {
    if (widget.viewModel == null) _viewModel.dispose();
    super.dispose();
  }

  Future<void> _abrirCadastro() async {
    final novoProduto = await Navigator.push<Produto>(
      context,
      MaterialPageRoute(builder: (_) => const CadastroProdutoView()),
    );
    if (novoProduto != null) {
      _viewModel.adicionarProduto(novoProduto);
    }
  }

  void _comprar(Produto produto) {
    final mensagem = _viewModel.comprar(produto);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(mensagem)),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppTheme.gradiente),
        ),
        actions: [
          // Ícone do carrinho com a quantidade de itens comprados.
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Badge(
                isLabelVisible: _viewModel.quantidadeNoCarrinho > 0,
                label: Text('${_viewModel.quantidadeNoCarrinho}'),
                backgroundColor: Colors.amber,
                textColor: Colors.black,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
        ],
      ),
      // Reconstrói a lista sempre que o ViewModel chama notifyListeners().
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          final produtos = _viewModel.produtos;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
                child: Row(
                  children: [
                    const Icon(Icons.storefront, color: AppTheme.primaria),
                    const SizedBox(width: 8),
                    Text(
                      '${produtos.length} produtos disponíveis',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaria,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: produtos.isEmpty
                    ? const Center(child: Text('Nenhum produto cadastrado.'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 4, bottom: 96),
                        itemCount: produtos.length,
                        itemBuilder: (context, index) {
                          final produto = produtos[index];
                          return ProdutoCard(
                            produto: produto,
                            onComprar: () => _comprar(produto),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        tooltip: 'Cadastrar produto',
        icon: const Icon(Icons.add),
        label: const Text('Novo produto'),
      ),
    );
  }
}
