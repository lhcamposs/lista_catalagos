import 'package:flutter/material.dart';

import '../models/produto.dart';
import '../theme/app_theme.dart';
import '../viewmodels/cadastro_produto_viewmodel.dart';

/// VIEW da tela Cadastrar Produto: monta o formulário e delega
/// validação e criação do produto ao CadastroProdutoViewModel.
class CadastroProdutoView extends StatefulWidget {
  const CadastroProdutoView({super.key});

  @override
  State<CadastroProdutoView> createState() => _CadastroProdutoViewState();
}

class _CadastroProdutoViewState extends State<CadastroProdutoView> {
  final _viewModel = CadastroProdutoViewModel();
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();

  @override
  void dispose() {
    _viewModel.dispose();
    _nomeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  void _salvar() {
    final produto = _viewModel.criarProduto(
      nome: _nomeController.text,
      preco: _precoController.text,
      camposValidos: _formKey.currentState!.validate(),
    );
    if (produto != null) {
      // Retorna à tela principal entregando o novo produto.
      Navigator.pop(context, produto);
    }
  }

  Widget _rotulo(String texto) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 6),
        child: Text(
          texto,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppTheme.primaria,
          ),
        ),
      );

  /// Pré-visualização do ícone conforme a categoria escolhida.
  Widget _preVisualizacao() {
    final categoria = _viewModel.categoria;
    final cor = categoria?.cor ?? AppTheme.primaria;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: categoria == null
            ? AppTheme.gradiente
            : LinearGradient(
                colors: [cor, cor.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cor.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Icon(
              categoria?.icone ?? Icons.inventory_2_outlined,
              size: 38,
              color: cor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            categoria == null ? 'Escolha uma categoria' : 'Categoria selecionada',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Produto'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppTheme.gradiente),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _preVisualizacao(),
              const SizedBox(height: 24),
              _rotulo('Nome do produto'),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  hintText: 'Ex.: Fone de ouvido',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: _viewModel.validarNome,
              ),
              const SizedBox(height: 18),
              _rotulo('Preço'),
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(
                  hintText: 'Ex.: 49,90',
                  prefixText: 'R\$ ',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _viewModel.validarPreco,
              ),
              const SizedBox(height: 18),
              _rotulo('Categoria'),
              InputDecorator(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    _viewModel.categoria?.icone ?? Icons.category_outlined,
                    color: _viewModel.categoria?.cor ?? AppTheme.primaria,
                  ),
                  errorText: _viewModel.erroCategoria,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Categoria>(
                    value: _viewModel.categoria,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(14),
                    hint: const Text('Selecione'),
                    items: _viewModel.categorias
                        .map(
                          (c) => DropdownMenuItem<Categoria>(
                            value: c,
                            child: Row(
                              children: [
                                Icon(c.icone, size: 20, color: c.cor),
                                const SizedBox(width: 10),
                                Text(c.rotulo),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: _viewModel.selecionarCategoria,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 54,
                child: FilledButton.icon(
                  onPressed: _salvar,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.secundaria,
                  ),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Cadastrar', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
