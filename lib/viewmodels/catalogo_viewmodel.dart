import 'package:flutter/foundation.dart';

import '../models/produto.dart';

/// VIEWMODEL do catálogo: guarda o estado da lista de produtos e as
/// regras de negócio. Avisa a View sobre mudanças via notifyListeners().
class CatalogoViewModel extends ChangeNotifier {
  final List<Produto> _produtos = [
    const Produto(nome: 'Smartphone', preco: 1899.90, categoria: Categoria.eletronicos),
    const Produto(nome: 'Camiseta Básica', preco: 49.90, categoria: Categoria.roupas),
    const Produto(nome: 'Café Especial 500g', preco: 32.50, categoria: Categoria.alimentos),
    const Produto(nome: 'Dom Casmurro', preco: 29.90, categoria: Categoria.livros),
    const Produto(nome: 'Bola de Futebol', preco: 89.00, categoria: Categoria.esportes),
  ];

  final List<Produto> _carrinho = [];

  /// A View só lê a lista; não pode alterá-la diretamente.
  List<Produto> get produtos => List.unmodifiable(_produtos);

  int get quantidadeNoCarrinho => _carrinho.length;

  /// Inclui o novo produto ao final, sem substituir os existentes.
  void adicionarProduto(Produto produto) {
    _produtos.add(produto);
    notifyListeners();
  }

  /// Adiciona ao carrinho e devolve a mensagem que a View exibirá no SnackBar.
  String comprar(Produto produto) {
    _carrinho.add(produto);
    notifyListeners();
    return '${produto.nome} foi adicionado ao carrinho!';
  }
}
