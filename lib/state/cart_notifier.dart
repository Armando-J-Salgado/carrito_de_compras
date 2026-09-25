import 'package:flutter/foundation.dart';

import 'package:flujo_de_compra/models/product.dart';

class CartNotifier extends ChangeNotifier {
  static const int maxSelection = 3;

  final List<Product> _selected = [];

  List<Product> get selected => List.unmodifiable(_selected);

  int get count => _selected.length;

  double get total => _selected.fold(0, (sum, product) => sum + product.price);

  bool get canProceed => count == maxSelection;

  bool get isFull => count >= maxSelection;

  bool isSelected(Product product) =>
      _selected.any((selectedProduct) => selectedProduct.name == product.name);

  void toggle(Product product) {
    if (isSelected(product)) {
      _selected.removeWhere(
        (selectedProduct) => selectedProduct.name == product.name,
      );
    } else if (isFull) {
      return;
    } else {
      _selected.add(product);
    }
    notifyListeners();
  }
}
