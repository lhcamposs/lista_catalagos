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

  group('CadastroProdutoViewModel - regras do nome', () {
    final vm = CadastroProdutoViewModel(nomesExistentes: ['Smartphone']);

    test('obrigatório', () {
      expect(vm.validarNome(''), 'Informe o nome do produto');
      expect(vm.validarNome('   '), 'Informe o nome do produto');
    });
    test('mínimo e máximo de caracteres', () {
      expect(vm.validarNome('TV'), contains('pelo menos 3'));
      expect(vm.validarNome('A' * 41), contains('no máximo 40'));
    });
    test('caracteres permitidos e pelo menos uma letra', () {
      expect(vm.validarNome('Caneca @#!'), contains('Use apenas'));
      expect(vm.validarNome('12345'), 'O nome deve conter pelo menos uma letra');
    });
    test('não aceita nome duplicado (ignora maiúsculas)', () {
      expect(vm.validarNome('smartphone'), 'Já existe um produto com esse nome');
    });
    test('nome válido', () {
      expect(vm.validarNome('Fone de Ouvido (Bluetooth)'), isNull);
      expect(vm.validarNome('Café 500g'), isNull);
    });
  });

  group('CadastroProdutoViewModel - regras do preço', () {
    final vm = CadastroProdutoViewModel();

    test('obrigatório', () {
      expect(vm.validarPreco(''), 'Informe o preço');
    });
    test('formato inválido', () {
      expect(vm.validarPreco('abc'), contains('Preço inválido'));
      expect(vm.validarPreco('1,2,3'), contains('Preço inválido'));
      expect(vm.validarPreco('12.34.5'), contains('Preço inválido'));
    });
    test('no máximo 2 casas decimais', () {
      expect(vm.validarPreco('10,999'), 'Use no máximo 2 casas decimais');
    });
    test('maior que zero e até 100 mil', () {
      expect(vm.validarPreco('0'), 'O preço deve ser maior que zero');
      expect(vm.validarPreco('0,00'), 'O preço deve ser maior que zero');
      expect(vm.validarPreco('100.000,01'), contains('no máximo'));
    });
    test('formatos aceitos', () {
      expect(vm.validarPreco('49,90'), isNull);
      expect(vm.validarPreco('49.90'), isNull);
      expect(vm.validarPreco('1.299,90'), isNull);
      expect(vm.converterPreco('1.299,90'), 1299.90);
      expect(vm.converterPreco('1.299'), 1299);
      expect(vm.converterPreco('10.5'), 10.5);
    });
  });

  group('CadastroProdutoViewModel - categoria e criação', () {
    test('categoria obrigatória', () {
      final vm = CadastroProdutoViewModel();
      expect(vm.validarCategoria(null), 'Selecione uma categoria');
      expect(vm.validarCategoria(Categoria.livros), isNull);
    });

    test('só cria o produto quando todas as regras são satisfeitas', () {
      final vm = CadastroProdutoViewModel();

      expect(vm.criarProduto(nome: 'Caneca', preco: '25'), isNull); // sem categoria

      vm.selecionarCategoria(Categoria.casa);
      expect(vm.criarProduto(nome: 'Ca', preco: '25'), isNull); // nome curto
      expect(vm.criarProduto(nome: 'Caneca', preco: '-1'), isNull); // preço inválido

      final produto = vm.criarProduto(nome: '  Caneca  ', preco: '25,50');
      expect(produto!.nome, 'Caneca');
      expect(produto.preco, 25.5);
      expect(produto.icone, Categoria.casa.icone);
    });
  });
}
