import 'package:flutter/material.dart';

enum Categoria {
  eletronicos('Eletrônicos', Icons.devices, Color(0xFF1E88E5)),
  roupas('Roupas', Icons.checkroom, Color(0xFFD81B60)),
  alimentos('Alimentos', Icons.restaurant, Color(0xFFFB8C00)),
  livros('Livros', Icons.menu_book, Color(0xFF00897B)),
  esportes('Esportes', Icons.sports_soccer, Color(0xFF43A047)),
  casa('Casa', Icons.chair, Color(0xFF8E24AA));

  const Categoria(this.rotulo, this.icone, this.cor);

  final String rotulo;
  final IconData icone;
  final Color cor;
}
