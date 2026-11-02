import 'package:flutter/material.dart';

import '../models/produto.dart';
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
          content: Text(mensagem),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      // Reconstrói a lista sempre que o ViewModel chama notifyListeners().
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          final produtos = _viewModel.produtos;
          if (produtos.isEmpty) {
            return const Center(child: Text('Nenhum produto cadastrado.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              return ProdutoCard(
                produto: produto,
                onComprar: () => _comprar(produto),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCadastro,
        tooltip: 'Cadastrar produto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
