
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ---------------------------------------------------------------------
// 1) Modelo inmutable. Con ValueNotifier no hay campos mutables internos:
//    cada cambio genera un CartState NUEVO y se asigna a .value.
// ---------------------------------------------------------------------
@immutable
class Product {
  final String name;
  final double price;
  const Product(this.name, this.price);
}

@immutable
class CartState {
  final Set<Product> selected;
  final double total;

  const CartState({required this.selected, required this.total});

  bool isSelected(Product p) => selected.contains(p);
  int get count => selected.length;
  bool get canProceed => selected.length == 3;

  // Total como estado derivado: se recalcula al construir el nuevo estado,
  // no vive aparte ni se recalcula de nuevo en cada pantalla.
  CartState toggle(Product p) {
    final next = Set<Product>.from(selected);
    next.contains(p) ? next.remove(p) : next.add(p);
    final newTotal = next.fold<double>(0, (sum, item) => sum + item.price);
    return CartState(selected: next, total: newTotal);
  }

  static const empty = CartState(selected: {}, total: 0);
}

const catalog = <Product>[
  Product('Mochila Urbana', 45000),
  Product('Auriculares Pro', 65000),
  Product('Reloj Fit Track', 89000),
  Product('Termo de Acero', 22500),
  Product('Lentes Polarizados', 34000),
];

// ---------------------------------------------------------------------
// 2) El notifier en sí. ValueNotifier EXTIENDE ChangeNotifier, así que
//    técnicamente sí se puede envolver con ChangeNotifierProvider.
// ---------------------------------------------------------------------
final cartNotifier = ValueNotifier<CartState>(CartState.empty);

// main.dart
void main() => runApp(
      ChangeNotifierProvider<ValueNotifier<CartState>>.value(
        value: cartNotifier,
        child: const MaterialApp(home: PantallaCatalogo()),
      ),
    );

// ---------------------------------------------------------------------
// 3) Pantalla 1 — Catálogo
//    Nótese el doble ".value.value": el de Provider (la instancia) y el
//    de ValueNotifier (el CartState actual).
// ---------------------------------------------------------------------
class PantallaCatalogo extends StatelessWidget {
  const PantallaCatalogo({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ValueNotifier<CartState>>().value;

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: Column(
        children: [
          Text('${state.count} de 3 seleccionados'),
          ...catalog.map(
            (p) => CheckboxListTile(
              title: Text('${p.name} — \$${p.price}'),
              value: state.isSelected(p),
              onChanged: (_) {
                final notifier = context.read<ValueNotifier<CartState>>();
                notifier.value = notifier.value.toggle(p);
              },
            ),
          ),
          ElevatedButton(
            onPressed: state.canProceed
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PantallaResumen()),
                    )
                : null,
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// 4) Pantalla 2 — Resumen (lee el mismo notifier, sin recibirlo por
//    constructor ni por ruta).
// ---------------------------------------------------------------------
class PantallaResumen extends StatelessWidget {
  const PantallaResumen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ValueNotifier<CartState>>().value;

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen de compra')),
      body: Column(
        children: [
          ...state.selected.map((p) => Text('${p.name} — \$${p.price}')),
          Text('Total: \$${state.total}'),
          ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('¡Compra exitosa!'),
                content: Text('Total pagado: \$${state.total}'),
              ),
            ),
            child: const Text('Proceder a pagar'),
          ),
        ],
      ),
    );
  }
}