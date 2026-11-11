# Timbre actual: init y ordenamientos

Base: FedericoDallo17/timbre, main bd31c93. Rama local: feat/mixed-listing-sorts.

## Contexto correcto

El primer intento de esta sesión se realizó sobre el worktree obsoleto `rental-scout-tracking`, con interfaz Rental Scout Lite. El usuario detectó el error. Se clonó el repositorio actual y se trasladaron únicamente los cambios de ordenamiento, preservando onboarding, navegación, alquiler/venta, identidad y recursos actuales. El repositorio vigente para continuar esta tarea es `timbre-current/` dentro del workspace anterior.

## Init

Se siguió `impeccable/reference/init.md`, conservando las respuestas confirmadas del usuario: contexto de descubrimiento temprano, nombre Timbre y comp-first para futuras páginas de presentación. Se contrastó PRODUCT.md con README.md, el estado actual, las vistas, la guía y los activos de marca. Se registró alquiler y venta, cuatro fuentes, Web Push/Pushover, tour y onboarding. La carga `impeccable context --target app/views/listings/index.html.erb` resolvió correctamente el proyecto y su PRODUCT.md. No se generó DESIGN.md ni se cambió la identidad.

## Cambios

- Hasta tres criterios por prioridad; parámetros compatibles con el antiguo `sort`.
- Superficie ascendente/descendente con datos desconocidos y cero al final.
- Deshabilitar ambas direcciones de una dimensión elegida en los otros selectores, en HTML inicial y al cambiar selecciones. Liberarlas al quitar el criterio.
- Integración con Turbo y restauración del formulario; validación de criterios repetidos también en el servidor.
- Orden global antes de paginar, con afinidad utilizable en cualquier prioridad.
- CSS y espejo público sincronizados; español e inglés.

## Validación

Suite completa: 345 pruebas / 2198 aserciones, sin fallos ni errores. La prueba de combinación verifica las opciones deshabilitadas en el HTML. El detector de Impeccable señaló tres advertencias de bordes decorativos preexistentes (líneas 2462, 2478 y 2495 del CSS); no pertenecen al cambio y no se modificaron.

Se regeneró la vista previa en `http://127.0.0.1:3107` usando las vistas y activos actuales y datos temporales dentro de una transacción revertida. La vista previa permite cambiar criterios con el JavaScript real de ordenamiento; no procesa Aplicar ni otros formularios.

QA visual actual pendiente: Chrome muestra el título Timbre y solicita correctamente el HTML, la fuente y el logo, pero la herramienta nativa devuelve el área de contenido vacía. No se verificó visualmente la nueva captura ni el estado dinámico de los selectores en el navegador. La suite comprueba el orden y los bloqueos iniciales del servidor.

## Entrega

Sin push ni despliegue. Versionar PRODUCT.md y `.impeccable/config.json` con los cambios. Si se incorporan después, versionar también DESIGN.md, `.impeccable/surfaces/`, `.impeccable/design.json`, `.impeccable/live/config.json` y `.impeccable/critique/ignore.md`; no ignorar `.impeccable/` entera. Los directorios temporales y config.local.json permanecen locales.
