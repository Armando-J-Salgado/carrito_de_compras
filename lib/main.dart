import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/catalog_screen.dart';
import 'state/cart_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrito de Compras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const CatalogScreen(),
    );
  }
}
