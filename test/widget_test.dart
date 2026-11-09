import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lista_catalagos/main.dart';
import 'package:lista_catalagos/models/produto.dart';

void main() {
  testWidgets('Exibe o catálogo inicial', (tester) async {
    await tester.pumpWidget(const CatalogoApp());

    expect(find.text('Catálogo de Produtos'), findsOneWidget);
    expect(find.text('Smartphone'), findsOneWidget);
    expect(find.text('Comprar'), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Tocar no produto mostra SnackBar', (tester) async {
    await tester.pumpWidget(const CatalogoApp());

    await tester.tap(find.text('Smartphone'));
    await tester.pump();

    expect(find.text('Smartphone foi adicionado ao carrinho!'), findsOneWidget);
  });

  testWidgets('Cadastra novo produto sem remover os existentes', (tester) async {
    await tester.pumpWidget(const CatalogoApp());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Cadastrar Produto'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Notebook');
    await tester.enterText(find.byType(TextFormField).at(1), '3.499,90');

    await tester.ensureVisible(find.byType(DropdownButton<Categoria>));
    await tester.tap(find.byType(DropdownButton<Categoria>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eletrônicos').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Cadastrar'));
    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();

    expect(find.text('Catálogo de Produtos'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Notebook'), 200);
    expect(find.text('Notebook'), findsOneWidget);
    expect(find.text('Smartphone', skipOffstage: false), findsOneWidget);
  });

  testWidgets('Form mostra os erros e não sai da tela com campos inválidos',
      (tester) async {
    await tester.pumpWidget(const CatalogoApp());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Cadastrar'));
    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();

    expect(find.text('Cadastrar Produto'), findsOneWidget);
    expect(find.text('Informe o nome do produto', skipOffstage: false), findsOneWidget);
    expect(find.text('Informe o preço', skipOffstage: false), findsOneWidget);
    expect(find.text('Selecione uma categoria', skipOffstage: false), findsOneWidget);
    expect(find.textContaining('Corrija os campos'), findsOneWidget);
  });

  testWidgets('Não permite cadastrar nome que já existe', (tester) async {
    await tester.pumpWidget(const CatalogoApp());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Smartphone');
    await tester.enterText(find.byType(TextFormField).at(1), '10');
    await tester.ensureVisible(find.text('Cadastrar'));
    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();

    expect(find.text('Já existe um produto com esse nome', skipOffstage: false), findsOneWidget);
  });

  test('Formata preço no padrão brasileiro', () {
    const p = Produto(nome: 'X', preco: 1299.9, categoria: Categoria.casa);
    expect(p.precoFormatado, 'R\$ 1.299,90');
    expect(p.icone, Icons.chair);
  });
}
