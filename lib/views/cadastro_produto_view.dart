import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/produto.dart';
import '../theme/app_theme.dart';
import '../viewmodels/cadastro_produto_viewmodel.dart';

class CadastroProdutoView extends StatefulWidget {
  const CadastroProdutoView({super.key, this.nomesExistentes = const []});

  final List<String> nomesExistentes;

  @override
  State<CadastroProdutoView> createState() => _CadastroProdutoViewState();
}

class _CadastroProdutoViewState extends State<CadastroProdutoView> {
  late final CadastroProdutoViewModel _viewModel =
      CadastroProdutoViewModel(nomesExistentes: widget.nomesExistentes);
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();

  AutovalidateMode _modoValidacao = AutovalidateMode.disabled;

  @override
  void dispose() {
    _viewModel.dispose();
    _nomeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  void _salvar() {
    FocusScope.of(context).unfocus();

    final formularioValido = _formKey.currentState!.validate();

    if (!formularioValido) {
      setState(() => _modoValidacao = AutovalidateMode.onUserInteraction);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFC62828),
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Não foi possível cadastrar. Corrija os campos destacados em vermelho.',
                  ),
                ),
              ],
            ),
          ),
        );
      return;
    }

    final produto = _viewModel.criarProduto(
      nome: _nomeController.text,
      preco: _precoController.text,
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
        autovalidateMode: _modoValidacao,
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _preVisualizacao(),
              const SizedBox(height: 24),

              // ---------------- NOME ----------------
              _rotulo('Nome do produto *'),
              TextFormField(
                controller: _nomeController,
                maxLength: CadastroProdutoViewModel.nomeMaximo,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Ex.: Fone de ouvido',
                  helperText: 'De 3 a 40 caracteres, sem repetir um produto existente',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                validator: _viewModel.validarNome,
              ),
              const SizedBox(height: 10),

              // ---------------- PREÇO ----------------
              _rotulo('Preço *'),
              TextFormField(
                controller: _precoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: const InputDecoration(
                  hintText: 'Ex.: 49,90',
                  helperText: 'Maior que zero, até R\$ 100.000,00 e 2 casas decimais',
                  prefixText: 'R\$ ',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                validator: _viewModel.validarPreco,
              ),
              const SizedBox(height: 18),

              _rotulo('Categoria *'),
              FormField<Categoria>(
                initialValue: _viewModel.categoria,
                validator: _viewModel.validarCategoria,
                builder: (campo) => InputDecorator(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      campo.value?.icone ?? Icons.category_outlined,
                      color: campo.value?.cor ?? AppTheme.primaria,
                    ),
                    helperText: campo.hasError ? null : 'Define o ícone do produto no catálogo',
                    errorText: campo.errorText,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Categoria>(
                      value: campo.value,
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
                      onChanged: (valor) {
                        campo.didChange(valor); // avisa o Form
                        _viewModel.selecionarCategoria(valor); // avisa o ViewModel
                      },
                    ),
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
