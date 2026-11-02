import 'package:flutter/material.dart';

import '../models/produto.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Produto'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do produto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: _viewModel.validarNome,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _precoController,
              decoration: const InputDecoration(
                labelText: 'Preço',
                hintText: 'Ex.: 49,90',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: _viewModel.validarPreco,
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) => InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(_viewModel.categoria?.icone ?? Icons.category),
                  errorText: _viewModel.erroCategoria,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Categoria>(
                    value: _viewModel.categoria,
                    isExpanded: true,
                    hint: const Text('Selecione'),
                    items: _viewModel.categorias
                        .map(
                          (c) => DropdownMenuItem<Categoria>(
                            value: c,
                            child: Row(
                              children: [
                                Icon(c.icone, size: 20),
                                const SizedBox(width: 8),
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
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _salvar,
              icon: const Icon(Icons.check),
              label: const Text('Cadastrar'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
