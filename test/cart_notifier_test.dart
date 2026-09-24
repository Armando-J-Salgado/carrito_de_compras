import 'package:flutter_test/flutter_test.dart';

import 'package:flujo_de_compra/models/product.dart';
import 'package:flujo_de_compra/state/cart_notifier.dart';

void main() {
  const headphones = Product(
    name: 'Audífonos',
    description: '',
    price: 10.50,
    imagePath: '',
  );
  const mouse = Product(
    name: 'Mouse',
    description: '',
    price: 20.25,
    imagePath: '',
  );
  const keyboard = Product(
    name: 'Teclado',
    description: '',
    price: 5.00,
    imagePath: '',
  );
  const charger = Product(
    name: 'Cargador',
    description: '',
    price: 99.99,
    imagePath: '',
  );

  late CartNotifier cart;

  setUp(() {
    cart = CartNotifier();
  });

  test('selecting 3 products allows proceeding', () {
    cart
      ..toggle(headphones)
      ..toggle(mouse)
      ..toggle(keyboard);

    expect(cart.count, 3);
    expect(cart.canProceed, isTrue);
  });

  test('a 4th product is ignored without notifying', () {
    cart
      ..toggle(headphones)
      ..toggle(mouse)
      ..toggle(keyboard);

    var notifications = 0;
    cart.addListener(() => notifications++);
    cart.toggle(charger);

    expect(cart.count, 3);
    expect(cart.isSelected(charger), isFalse);
    expect(notifications, 0);
  });

  test('toggling a selected product removes it', () {
    cart
      ..toggle(headphones)
      ..toggle(headphones);

    expect(cart.count, 0);
    expect(cart.isSelected(headphones), isFalse);
  });

  test('total is the exact sum of selected prices', () {
    cart
      ..toggle(headphones)
      ..toggle(mouse)
      ..toggle(keyboard);

    expect(cart.total, 35.75);
  });

  test('products are compared by name, not by instance', () {
    cart.toggle(headphones);

    const sameNameOtherInstance = Product(
      name: 'Audífonos',
      description: 'Otra descripción',
      price: 1,
      imagePath: '',
    );

    expect(cart.isSelected(sameNameOtherInstance), isTrue);
  });

  test('selected list cannot be modified from outside', () {
    cart.toggle(headphones);

    expect(() => cart.selected.add(mouse), throwsUnsupportedError);
  });
}
