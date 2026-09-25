import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flujo_de_compra/data/catalog.dart';
import 'package:flujo_de_compra/screens/summary_screen.dart';
import 'package:flujo_de_compra/state/cart_notifier.dart';
import 'package:flujo_de_compra/widgets/product_tile.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  void _goToSummary(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SummaryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartNotifier>();

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${cart.count} de ${CartNotifier.maxSelection} seleccionados',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: kCatalog.length,
              itemBuilder: (_, index) => ProductTile(product: kCatalog[index]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: cart.canProceed ? () => _goToSummary(context) : null,
            child: const Text('Continuar'),
          ),
        ),
      ),
    );
  }
}
