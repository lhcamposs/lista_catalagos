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
    final cor = produto.categoria.cor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onComprar,
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: cor, width: 6)),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Ícone da categoria em um quadrado colorido.
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cor, cor.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: cor.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(produto.icone, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produto.nome,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: cor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        produto.categoria.rotulo,
                        style: TextStyle(
                          color: cor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      produto.precoFormatado,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: onComprar,
                style: FilledButton.styleFrom(
                  backgroundColor: cor,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text('Comprar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
