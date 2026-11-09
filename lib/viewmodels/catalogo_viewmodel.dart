import 'package:flutter/foundation.dart';

import '../models/produto.dart';

class CatalogoViewModel extends ChangeNotifier {
  final List<Produto> _produtos = [
    const Produto(nome: 'Smartphone', preco: 1899.90, categoria: Categoria.eletronicos),
    const Produto(nome: 'Camiseta Básica', preco: 49.90, categoria: Categoria.roupas),
    const Produto(nome: 'Café Especial 500g', preco: 32.50, categoria: Categoria.alimentos),
    const Produto(nome: 'Dom Casmurro', preco: 29.90, categoria: Categoria.livros),
    const Produto(nome: 'Bola de Futebol', preco: 89.00, categoria: Categoria.esportes),
  ];

  final List<Produto> _carrinho = [];

  List<Produto> get produtos => List.unmodifiable(_produtos);

  int get quantidadeNoCarrinho => _carrinho.length;

  void adicionarProduto(Produto produto) {
    _produtos.add(produto);
    notifyListeners();
  }

  String comprar(Produto produto) {
    _carrinho.add(produto);
    notifyListeners();
    return '${produto.nome} foi adicionado ao carrinho!';
  }
}
