import 'package:flutter_test/flutter_test.dart';

import 'package:lista_catalagos/models/produto.dart';
import 'package:lista_catalagos/viewmodels/cadastro_produto_viewmodel.dart';
import 'package:lista_catalagos/viewmodels/catalogo_viewmodel.dart';

void main() {
  group('CatalogoViewModel', () {
    test('adiciona produto sem remover os existentes e notifica a View', () {
      final vm = CatalogoViewModel();
      final quantidadeInicial = vm.produtos.length;
      var notificou = false;
      vm.addListener(() => notificou = true);

      vm.adicionarProduto(
        const Produto(nome: 'Notebook', preco: 3499.9, categoria: Categoria.eletronicos),
      );

      expect(vm.produtos.length, quantidadeInicial + 1);
      expect(vm.produtos.last.nome, 'Notebook');
      expect(vm.produtos.first.nome, 'Smartphone');
      expect(notificou, isTrue);
    });

    test('comprar adiciona ao carrinho e retorna a mensagem', () {
      final vm = CatalogoViewModel();
      final msg = vm.comprar(vm.produtos.first);

      expect(msg, 'Smartphone foi adicionado ao carrinho!');
      expect(vm.quantidadeNoCarrinho, 1);
    });
  });

  group('CadastroProdutoViewModel', () {
    test('valida nome e preço', () {
      final vm = CadastroProdutoViewModel();

      expect(vm.validarNome(''), isNotNull);
      expect(vm.validarNome('Caneca'), isNull);
      expect(vm.validarPreco('abc'), isNotNull);
      expect(vm.validarPreco('0'), isNotNull);
      expect(vm.validarPreco('1.299,90'), isNull);
      expect(vm.converterPreco('1.299,90'), 1299.90);
      expect(vm.converterPreco('10.5'), 10.5);
    });

    test('exige categoria antes de criar o produto', () {
      final vm = CadastroProdutoViewModel();

      expect(vm.criarProduto(nome: 'Caneca', preco: '25', camposValidos: true), isNull);
      expect(vm.erroCategoria, isNotNull);

      vm.selecionarCategoria(Categoria.casa);
      final produto = vm.criarProduto(nome: 'Caneca', preco: '25', camposValidos: true);

      expect(vm.erroCategoria, isNull);
      expect(produto!.categoria, Categoria.casa);
      expect(produto.icone, Categoria.casa.icone);
    });
  });
}
