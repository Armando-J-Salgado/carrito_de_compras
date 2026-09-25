# Actividad 3 — Evaluación crítica con IA (Persona 6)

**Propuesta de la IA:** reemplazar `CartNotifier extends ChangeNotifier` (con
campos mutables + `toggle(p)` + `notifyListeners()`) por un
`ValueNotifier<CartState>`, donde `CartState` es un objeto inmutable que se
reconstruye completo en cada cambio.

## Comparación contra los 5 criterios del proyecto

| Criterio | Con ChangeNotifier (versión oficial) | Con ValueNotifier |
|---|---|---|
| 01 – ChangeNotifier completo | Un método por acción (`toggle`, `isSelected`) sobre estado mutable | Los mismos métodos, pero viven en `CartState` y cada uno **devuelve una copia nueva** en vez de mutar |
| 02 – Uso correcto de context | `context.watch` / `Consumer` para leer, `context.read` en callbacks | Igual, pero hay que leer `.value` dos veces: `context.watch<ValueNotifier<CartState>>().value` |
| 03 – Restricción de selección | `canProceed` como getter sobre el notifier | Igual, como getter de `CartState` |
| 04 – Total como estado derivado | Se calcula dentro del notifier, una sola fuente de verdad | Igual — se recalcula al construir el nuevo `CartState`, sigue habiendo una sola fuente de verdad |
| 05 – Diálogo de compra exitosa | Sin cambios | Sin cambios |

## Sobre la restricción obligatoria de usar Provider

`ValueNotifier` **extiende `ChangeNotifier`**, así que técnicamente sí se
puede envolver con `ChangeNotifierProvider<ValueNotifier<CartState>>.value(...)`
y seguir usando `context.watch` / `context.read`. No la viola.

## Veredicto: **se descarta** para este caso

Razones:

1. **Doble indirección innecesaria.** Cada lectura queda como
   `context.watch<ValueNotifier<CartState>>().value.algo`, y cada escritura
   como `notifier.value = notifier.value.toggle(p)`. El `CartNotifier`
   original permite `context.watch<CartNotifier>().algo` directo.
2. **Multiples listeners no es un diferenciador real.** `ValueNotifier`
   notifica a *todos* los listeners ante cualquier cambio de `.value`,
   exactamente igual que el `ChangeNotifier` de la versión oficial (ambos
   son "todo o nada", sin granularidad por campo).
3. **Pierde encapsulamiento.** La lógica de negocio (`toggle`, `isSelected`,
   `canProceed`) ya no vive "dentro" del objeto que expone Provider, sino
   repartida entre `CartState` (datos) y funciones sueltas que arman el
   nuevo estado. Para un carrito con reglas de negocio (como este, con la
   restricción de exactamente 3 productos) el `ChangeNotifier` clásico es
   más legible.

**Cuándo sí valdría la pena:** para estado primitivo sin lógica adjunta —
por ejemplo un contador simple (`ValueNotifier<int>`) — donde
`ValueListenableBuilder` es más liviano que armar un `ChangeNotifier`
completo. No es el caso de este carrito, que tiene reglas de negocio
(exactamente 3 productos, total derivado, validación de navegación).