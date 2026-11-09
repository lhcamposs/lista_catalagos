import 'package:flutter/material.dart';

import 'categoria.dart';

export 'categoria.dart';

class Produto {
  const Produto({
    required this.nome,
    required this.preco,
    required this.categoria,
  });

  final String nome;
  final double preco;
  final Categoria categoria;

  /// Ícone definido de acordo com a categoria do produto.
  IconData get icone => categoria.icone;

  /// Preço no formato brasileiro, ex.: R$ 1.299,90
  String get precoFormatado {
    final partes = preco.toStringAsFixed(2).split('.');
    final inteiro = partes[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'R\$ $inteiro,${partes[1]}';
  }
}
