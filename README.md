# Flujo de compra

Aplicacion movil hecha con Flutter para simular un carrito de compras.

**Integrantes del Equipo 7:**
- José Alexander Alas Leiva
- Jade Nicole Cárcamo Vasquez
- Eliezer Alexander Martínez Chámul
- Nehemías Emanuel Rivas Umañana
- Armando José Salgado Rosa
- Luz Giselle Salomón Zandoval

## Que tiene

- Catalogo de productos.
- Seleccion de hasta 3 productos.
- Contador de productos seleccionados.
- Resumen de compra con productos elegidos y total.
- Confirmacion de compra.
- Estado del carrito compartido entre las pantallas mediante Provider.

## Estructura principal

- `lib/main.dart`: inicia la aplicacion y configura Provider.
- `lib/data/`: catalogo de productos.
- `lib/models/`: modelo `Product`.
- `lib/screens/`: pantallas de catalogo y resumen.
- `lib/state/`: estado del carrito (`CartNotifier`).
- `lib/widgets/`: componentes reutilizables, como cada producto.
- `lib/images/`: imagenes usadas por los productos.

## Como ejecutar

1. Tener Flutter instalado.
2. Ejecutar `flutter pub get`.
3. Ejecutar `flutter run`.

## Tecnologias

- Flutter y Dart.
- Provider para manejar el estado del carrito.
