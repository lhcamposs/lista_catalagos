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
- O cadastro usa o widget `Form`. Cada campo tem seu conjunto de regras (veja [Validação do formulário](#validação-do-formulário)). Se alguma regra não for satisfeita, o campo mostra a mensagem de erro em vermelho, um `SnackBar` avisa que o cadastro não foi feito e o usuário continua na tela de cadastro.
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

## Validação do formulário

A tela **Cadastrar Produto** usa o widget `Form` com uma `GlobalKey<FormState>`. Ao tocar em **Cadastrar**, `validate()` roda o `validator` de cada campo. As regras ficam no `CadastroProdutoViewModel`, e a View só as conecta aos campos.

| Campo | Regras |
|-------|--------|
| **Nome** (`TextFormField`) | 1. Obrigatório.<br>2. Mínimo de 3 caracteres.<br>3. Máximo de 40 caracteres.<br>4. Só aceita letras, números, espaços e `- . , ( ) / & '`.<br>5. Deve conter pelo menos uma letra.<br>6. Não pode repetir o nome de um produto do catálogo (sem diferenciar maiúsculas e minúsculas). |
| **Preço** (`TextFormField`) | 1. Obrigatório.<br>2. Deve ser um número válido (`49,90`, `49.90` ou `1.299,90`).<br>3. No máximo 2 casas decimais.<br>4. Maior que zero.<br>5. No máximo R$ 100.000,00. |
| **Categoria** (`DropdownButton` dentro de um `FormField`) | 1. Obrigatória.<br>2. Deve ser uma das categorias disponíveis. |

Quando alguma regra falha:
- o campo mostra a mensagem da regra que falhou, em vermelho;
- um `SnackBar` vermelho avisa que o cadastro não foi feito;
- a partir daí os campos são validados enquanto o usuário digita (`AutovalidateMode.onUserInteraction`), e a mensagem some assim que o valor fica correto.

Quando todas as regras são satisfeitas, o app volta à tela principal com `Navigator.pop`. O produto entra no final da lista e um `SnackBar` confirma o cadastro.

O `DropdownButton` não é um campo de formulário por si só. Por isso ele fica dentro de um `FormField<Categoria>`, que faz o `Form` validar a categoria junto com os outros campos.

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
2. O usuário preenche o `Form`. O `validate()` aplica as regras do `CadastroProdutoViewModel` a cada campo e, se tudo estiver certo, o ViewModel cria o `Produto`.
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

- `test/viewmodels_test.dart`: testes unitários dos ViewModels, sem interface gráfica. Cobrem cada regra de validação de nome, preço e categoria, a adição de produtos e a mensagem de compra.
- `test/widget_test.dart`: testes de widget da tela principal, do `SnackBar`, das mensagens de erro do `Form` e do fluxo completo de cadastro.

## Autor

Luan Henrique Campos Soares. Bacharelado em Sistemas de Informação, IF Goiano, Campus Urutaí.
