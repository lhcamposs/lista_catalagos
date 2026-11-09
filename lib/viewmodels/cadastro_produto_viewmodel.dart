import 'package:flutter/foundation.dart';

import '../models/produto.dart';

class CadastroProdutoViewModel extends ChangeNotifier {
  CadastroProdutoViewModel({List<String> nomesExistentes = const []})
      : _nomesExistentes =
            nomesExistentes.map((n) => n.trim().toLowerCase()).toSet();

  static const int nomeMinimo = 3;
  static const int nomeMaximo = 40;
  static const double precoMaximo = 100000;

  final Set<String> _nomesExistentes;

  Categoria? _categoria;

  Categoria? get categoria => _categoria;
  List<Categoria> get categorias => Categoria.values;

  void selecionarCategoria(Categoria? categoria) {
    _categoria = categoria;
    notifyListeners();
  }

  String? validarNome(String? valor) {
    final nome = (valor ?? '').trim();

    if (nome.isEmpty) {
      return 'Informe o nome do produto';
    }
    if (nome.length < nomeMinimo) {
      return 'O nome deve ter pelo menos $nomeMinimo caracteres';
    }
    if (nome.length > nomeMaximo) {
      return 'O nome deve ter no máximo $nomeMaximo caracteres';
    }
    if (!RegExp(r"^[A-Za-zÀ-ÿ0-9\s\-.,()/&']+$").hasMatch(nome)) {
      return 'Use apenas letras, números, espaços e - . , ( ) / & \'';
    }
    if (!RegExp(r'[A-Za-zÀ-ÿ]').hasMatch(nome)) {
      return 'O nome deve conter pelo menos uma letra';
    }
    if (_nomesExistentes.contains(nome.toLowerCase())) {
      return 'Já existe um produto com esse nome';
    }
    return null;
  }

  String? validarPreco(String? valor) {
    final texto = (valor ?? '').trim();

    if (texto.isEmpty) {
      return 'Informe o preço';
    }
    final normalizado = _normalizarPreco(texto);
    final preco = normalizado == null ? null : double.tryParse(normalizado);
    if (preco == null) {
      return 'Preço inválido. Use o formato 49,90';
    }
    final partes = normalizado!.split('.');
    if (partes.length == 2 && partes[1].length > 2) {
      return 'Use no máximo 2 casas decimais';
    }
    if (preco <= 0) {
      return 'O preço deve ser maior que zero';
    }
    if (preco > precoMaximo) {
      return 'O preço deve ser no máximo R\$ 100.000,00';
    }
    return null;
  }

  String? validarCategoria(Categoria? valor) {
    if (valor == null) {
      return 'Selecione uma categoria';
    }
    if (!Categoria.values.contains(valor)) {
      return 'Categoria inválida';
    }
    return null;
  }

  double? converterPreco(String texto) {
    final normalizado = _normalizarPreco(texto.trim());
    return normalizado == null ? null : double.tryParse(normalizado);
  }

  String? _normalizarPreco(String texto) {
    var valor = texto.replaceAll('R\$', '').replaceAll(' ', '');
    if (!RegExp(r'^[0-9.,]+$').hasMatch(valor)) return null;

    if (valor.contains(',')) {
      if (!RegExp(r'^(\d{1,3}(\.\d{3})*|\d+),\d+$').hasMatch(valor)) {
        return null;
      }
      valor = valor.replaceAll('.', '').replaceAll(',', '.');
    } else if (RegExp(r'^\d{1,3}(\.\d{3})+$').hasMatch(valor)) {
      valor = valor.replaceAll('.', '');
    } else if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(valor)) {
      return null;
    }
    return valor;
  }

  Produto? criarProduto({required String nome, required String preco}) {
    final valido = validarNome(nome) == null &&
        validarPreco(preco) == null &&
        validarCategoria(_categoria) == null;
    if (!valido) return null;

    return Produto(
      nome: nome.trim(),
      preco: converterPreco(preco)!,
      categoria: _categoria!,
    );
  }
}
