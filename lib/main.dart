import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'views/catalogo_view.dart';

void main() {
  runApp(const CatalogoApp());
}

class CatalogoApp extends StatelessWidget {
  const CatalogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Produtos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      home: const CatalogoView(),
    );
  }
}
