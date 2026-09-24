import 'package:flujo_de_compra/models/product.dart';
import 'package:flutter/material.dart';

///Manages state for Inherited Widgets
class CartNotifier extends ChangeNotifier {
  final int _maxSelection = 3;
  final List<Product> _catalog = [];
  List<Product> _selected = [];

  //Maximum amount of product selectable
  int get maxSelection => _maxSelection;

  //List of products available
  List<Product> get catalog => List.unmodifiable(_catalog);

  //List of current selected products
  List<Product> get selected => List.unmodifiable(_selected);

  /// Get the current amount of products
  int get count => _selected.length;

  /// Get the current total value of the order
  double get total => _selected.fold(0, (total, product) => product.price + total);

 /// Check if order amount is valid
  bool get canProceed => count == maxSelection;

  /// Check if a product is selected
  /// 
  /// params: [Product]
  bool isSelected(Product product) {
    return _selected.any((p) => p.name == product.name);
  }

  /// Add a product to the order
  /// 
  /// params: [Product]
  void toggle(Product product) {
    
    if (isSelected(product)) {
      
      _selected = _selected.where((p) => p.name != product.name).toList();
      notifyListeners();
      return;

    } else {
      
      if (canProceed) {
        return;
      }

      _selected.add(product);
      notifyListeners();
      
      return;
    }
  }
}
