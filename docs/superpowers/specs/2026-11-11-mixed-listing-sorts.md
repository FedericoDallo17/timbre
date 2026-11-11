# Timbre: ordenamientos combinados y superficie

## Pedido

Permitir combinar ordenamientos en el listado y ordenar por m². Inicializar primero el contexto de Impeccable siguiendo su documentación.

## Comportamiento

- Hasta tres prioridades explícitas: primero, luego y por último. Las últimas dos son opcionales.
- Cada criterio posterior desempata los anteriores; fecha descendente e ID descendente resuelven los empates restantes.
- Mantener los criterios existentes, incluyendo afinidad y precio por m². Agregar superficie ascendente y descendente.
- Superficie desconocida o cero queda al final en ambos sentidos.
- Ignorar criterios desconocidos y dimensiones repetidas o contradictorias; conservar la primera prioridad de cada dimensión.
- Deshabilitar las opciones de una dimensión utilizada en los otros selectores, tanto en el HTML inicial como al cambiar selecciones. Restaurarlas al liberar la dimensión.
- Aplicar el orden al conjunto filtrado completo antes de paginar. Conservarlo al cambiar de búsqueda o página.
- Mantener los enlaces existentes que usan un único parámetro `sort` y los criterios de comparación por moneda.
- Controles y explicaciones en español e inglés, agrupados en un fieldset; tres columnas en escritorio y una en móvil.

## Implementación

1. Registrar el contexto confirmado en PRODUCT.md y la preferencia `buildPath: comp` en `.impeccable/config.json`.
2. Normalizar `sort`, `then_sort` y `finally_sort` mediante una lista permitida.
3. Componer el ORDER BY sin desempates intermedios que anulen prioridades posteriores. Cuando se usa afinidad, calcular los puntajes existentes y ordenarlos con un CASE de IDs y puntajes enteros internos.
4. Incorporar los controles al formulario existente y sincronizar el espejo público del CSS.
5. Verificar combinaciones, nulos, afinidad como criterio principal/secundario, parámetros inválidos y navegación paginada.

## Contexto de producto

El usuario confirmó Timbre como nombre actual, el propósito de descubrir alquileres nuevos en Montevideo temprano y comp-first para futuras páginas de presentación. Las pantallas de la app siguen el flujo code-first de Impeccable. No se modifica la identidad visual en esta tarea.
