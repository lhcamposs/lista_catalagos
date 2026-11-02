# Catálogo de Produtos

Aplicativo Flutter para visualizar um catálogo de produtos e cadastrar novos itens. A lista na tela principal é atualizada na hora. O projeto segue a arquitetura **MVVM (Model–View–ViewModel)**.

## Funcionalidades

- Lista de produtos na tela principal, montada com `List` e `ListView.builder`.
- Cada produto aparece em um `Card` com:
  - ícone correspondente à categoria;
  - nome;
  - preço no formato brasileiro (ex.: `R$ 1.899,90`);
  - botão **Comprar**.
- O `FloatingActionButton` abre a tela **Cadastrar Produto**.
- No cadastro, o usuário informa nome, preço e categoria. A categoria é escolhida em um `DropdownButton`.
- O formulário é validado: nome obrigatório, preço numérico maior que zero e categoria obrigatória. O preço aceita `49,90`, `49.90` ou `1.299,90`.
- Ao confirmar, o app volta à tela principal e o novo produto entra no final da lista. Os produtos que já existiam continuam lá.
- O ícone de cada produto depende da categoria escolhida.
- Tocar em um produto ou no botão **Comprar** mostra um `SnackBar` avisando que o produto foi adicionado ao carrinho.

### Categorias

| Categoria   | Ícone (`Icons`)  | Cor     |
|-------------|------------------|---------|
| Eletrônicos | `devices`        | Azul    |
| Roupas      | `checkroom`      | Rosa    |
| Alimentos   | `restaurant`     | Laranja |
| Livros      | `menu_book`      | Verde-água |
| Esportes    | `sports_soccer`  | Verde   |
| Casa        | `chair`          | Roxo    |

## Arquitetura MVVM

```
lib/
├── main.dart                              # Ponto de entrada (MaterialApp)
├── models/                                # MODEL: dados da aplicação
│   ├── categoria.dart                     # Enum Categoria (rótulo, ícone e cor)
│   └── produto.dart                       # Classe Produto (nome, preço, categoria)
├── viewmodels/                            # VIEWMODEL: estado e regras de negócio
│   ├── catalogo_viewmodel.dart            # Lista de produtos, adicionar e comprar
│   └── cadastro_produto_viewmodel.dart    # Validações, categoria escolhida, criação do produto
├── theme/
│   └── app_theme.dart                     # Cores, gradiente e tema visual
└── views/                                 # VIEW: interface com o usuário
    ├── catalogo_view.dart                 # Tela principal (ListView.builder + FAB)
    ├── cadastro_produto_view.dart         # Tela Cadastrar Produto (formulário + DropdownButton)
    └── widgets/
        └── produto_card.dart              # Card de um produto
```

### Responsabilidade de cada camada

- **Model**: representa os dados (`Produto`, `Categoria`). Não conhece a interface.
- **ViewModel**: guarda o estado da tela e as regras de negócio. Estende `ChangeNotifier` e chama `notifyListeners()` sempre que o estado muda. A lista de produtos sai do ViewModel somente para leitura (`List.unmodifiable`), então só ele pode alterá-la.
- **View**: só desenha a interface e repassa as ações do usuário ao ViewModel. Usa `ListenableBuilder` para se redesenhar quando o ViewModel avisa que algo mudou.

### Fluxo de cadastro

1. O usuário toca no `FloatingActionButton` e a `CatalogoView` abre a `CadastroProdutoView` com `Navigator.push`.
2. A `CadastroProdutoView` passa os dados digitados ao `CadastroProdutoViewModel`, que valida tudo e cria o `Produto`.
3. A tela de cadastro devolve o produto com `Navigator.pop(context, produto)`.
4. A `CatalogoView` recebe o produto e chama `CatalogoViewModel.adicionarProduto()`.
5. O ViewModel inclui o produto na lista e chama `notifyListeners()`, e o `ListenableBuilder` redesenha a lista.

O projeto não usa pacotes externos de gerenciamento de estado, só `ChangeNotifier` e `ListenableBuilder`, que já vêm no Flutter.

## Como executar

Pré-requisito: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (Dart `^3.13.7`).

```bash
# Instalar as dependências
flutter pub get

# Executar o aplicativo (emulador, dispositivo ou navegador)
flutter run
```

## Testes

```bash
flutter test
```

- `test/viewmodels_test.dart`: testes unitários dos ViewModels (adição de produtos, mensagem de compra, validações e criação do produto), sem interface gráfica.
- `test/widget_test.dart`: testes de widget da tela principal, do `SnackBar` e do fluxo completo de cadastro.

## Autor

Luan Henrique Campos Soares. Bacharelado em Sistemas de Informação, IF Goiano, Campus Urutaí.
