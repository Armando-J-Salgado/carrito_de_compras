import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flujo_de_compra/models/product.dart';
import 'package:flujo_de_compra/state/cart_notifier.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartNotifier>();
    final isSelected = cart.isSelected(product);
    final isBlocked = !isSelected && cart.isFull;

    return CheckboxListTile(
      secondary: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          product.imagePath,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(product.name),
      subtitle: Text(
        '${product.description}\n\$${product.price.toStringAsFixed(2)}',
      ),
      isThreeLine: true,
      value: isSelected,
      onChanged: isBlocked
          ? null
          : (_) => context.read<CartNotifier>().toggle(product),
    );
  }
}
