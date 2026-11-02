import 'package:flutter/material.dart';

import '../../models/produto.dart';

/// VIEW (componente): Card de um produto com ícone, nome, preço e botão Comprar.
class ProdutoCard extends StatelessWidget {
  const ProdutoCard({
    super.key,
    required this.produto,
    required this.onComprar,
  });

  final Produto produto;
  final VoidCallback onComprar;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: ListTile(
        onTap: onComprar,
        leading: CircleAvatar(
          backgroundColor: cores.secondaryContainer,
          child: Icon(produto.icone, color: cores.onSecondaryContainer),
        ),
        title: Text(
          produto.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${produto.precoFormatado} • ${produto.categoria.rotulo}'),
        trailing: ElevatedButton.icon(
          onPressed: onComprar,
          icon: const Icon(Icons.shopping_cart),
          label: const Text('Comprar'),
        ),
      ),
    );
  }
}
