import 'package:flutter/foundation.dart';

import '../models/produto.dart';

/// VIEWMODEL do cadastro: guarda a categoria escolhida, valida os campos
/// e monta o objeto Produto. A View apenas exibe e repassa as ações.
class CadastroProdutoViewModel extends ChangeNotifier {
  Categoria? _categoria;
  String? _erroCategoria;

  Categoria? get categoria => _categoria;
  String? get erroCategoria => _erroCategoria;
  List<Categoria> get categorias => Categoria.values;

  void selecionarCategoria(Categoria? categoria) {
    _categoria = categoria;
    _erroCategoria = null;
    notifyListeners();
  }

  String? validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o nome do produto';
    }
    return null;
  }

  String? validarPreco(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o preço';
    }
    final preco = converterPreco(valor);
    if (preco == null || preco <= 0) {
      return 'Informe um preço válido';
    }
    return null;
  }

  /// Aceita "10,50", "10.50" e "1.299,90".
  double? converterPreco(String texto) {
    var valor = texto.trim().replaceAll('R\$', '').trim();
    if (valor.contains(',')) {
      valor = valor.replaceAll('.', '').replaceAll(',', '.');
    }
    return double.tryParse(valor);
  }

  /// Valida a categoria e cria o produto.
  /// Retorna null se algum dado estiver inválido.
  Produto? criarProduto({
    required String nome,
    required String preco,
    required bool camposValidos,
  }) {
    if (_categoria == null) {
      _erroCategoria = 'Selecione uma categoria';
      notifyListeners();
    }
    if (!camposValidos || _categoria == null) return null;

    return Produto(
      nome: nome.trim(),
      preco: converterPreco(preco)!,
      categoria: _categoria!,
    );
  }
}
