import 'package:flutter/material.dart';

/// MODEL: categorias disponíveis, cada uma com seu rótulo e ícone.
enum Categoria {
  eletronicos('Eletrônicos', Icons.devices),
  roupas('Roupas', Icons.checkroom),
  alimentos('Alimentos', Icons.restaurant),
  livros('Livros', Icons.menu_book),
  esportes('Esportes', Icons.sports_soccer),
  casa('Casa', Icons.chair);

  const Categoria(this.rotulo, this.icone);

  final String rotulo;
  final IconData icone;
}
