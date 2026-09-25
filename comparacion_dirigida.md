# Actividad 1: Comparación dirigida

## Decisión

Para este proyecto, conviene usar Provider, porque el carrito debe ser compartido por `CatalogScreen` y `SummaryScreen` y ambas pantallas ya pueden acceder al mismo estado sin recibirlo por constructores.

## Justificación basada en el código

En `main.dart`, `CartNotifier` se registra con `ChangeNotifierProvider` por encima de `MyApp`. El notifier mantiene la lista privada `_selected` y expone `selected`, `count` y `total`; cuando `toggle()` agrega o elimina un producto, llama a `notifyListeners()`.

Ese estado se consume directamente en los puntos que lo necesitan:

- `CatalogScreen` usa `context.watch<CartNotifier>()` para mostrar el contador y habilitar `Continuar`.
- Cada `ProductTile` consulta `isSelected(product)` y ejecuta `toggle(product)` con `context.read<CartNotifier>()`.
- `SummaryScreen` usa el mismo notifier para leer `selected` y calcular/mostrar `total`.

Este mecanismo encaja mejor con Provider porque las dos pantallas comparten una única fuente de verdad aunque estén separadas por la navegación. No hace falta copiar `selected` ni `total`, ni pasarlos manualmente al abrir el resumen.

## Criterios de escalabilidad

### Prop drilling

Con lifting state up, el estado tendría que vivir en un ancestro común y pasarse a las pantallas mediante parámetros. En el catálogo, además, `CatalogScreen` tendría que reenviar al menos el estado necesario y la operación de cambio a cada `ProductTile`: hay un nivel de reenvío hacia la pantalla y otro hacia el widget de producto. Para el resumen también habría que conectar explícitamente `selected` y `total` desde ese ancestro hasta `SummaryScreen`.

Con Provider, esos niveles de reenvío son cero: `CatalogScreen`, `ProductTile` y `SummaryScreen` obtienen el notifier desde el contexto.

### Rebuilds

Con el código actual, un `toggle()` notifica al notifier. Se reconstruyen los widgets que escuchan con `watch`: el `CatalogScreen` para actualizar el contador y el botón, los `ProductTile` para actualizar su selección y el `SummaryScreen` si está montado en la navegación. Los widgets que solo usan `read` para ejecutar `toggle()` no escuchan cambios.

Con lifting state up, un `setState` en el ancestro común puede reconstruir su subárbol completo, incluyendo partes de `MyApp` y de las pantallas que no necesitan cambiar. Habría que separar más widgets o usar callbacks y estado local para evitar esos rebuilds. Provider deja la escucha ubicada en los widgets que consumen el carrito, aunque en este código `CatalogScreen` y cada `ProductTile` escuchan el notifier completo.

### Número de pantallas

Si mañana se agrega `Historial de compras`, con Provider la nueva pantalla podría leer el estado o un notifier específico desde el contexto; el cambio principal sería registrar la ruta y consumir el estado donde corresponda. No habría que modificar la firma de las pantallas existentes para transportar el carrito.

Con lifting state up, habría que añadir nuevos parámetros a la pantalla, actualizar la creación de la ruta y mantener el paso de `selected`, `total` y las acciones desde el ancestro común. A medida que aumentan las pantallas y widgets intermedios, también aumenta el código de conexión.S

## Conclusión

Provider es la opción correcta para este caso puntual porque el proyecto ya centraliza el carrito en `CartNotifier` y las dos pantallas lo consumen desde el contexto. Así, `selected` y `total` permanecen sincronizados sin prop drilling, y una nueva pantalla puede conectarse sin modificar toda la cadena de navegación.