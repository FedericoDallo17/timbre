# Timbre

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Personas que buscan alquiler o compra en Montevideo, Uruguay, y necesitan revisar oportunidades relevantes sin recorrer repetidamente varios portales.

## Product Purpose

Ayudar a enterarse temprano de nuevas propiedades en alquiler o venta que coinciden con las preferencias de cada persona. El usuario guarda búsquedas, revisa los avisos que reúnen esas búsquedas, recibe alertas y lleva un seguimiento privado de las propiedades que le interesan.

## Positioning

Timbre es un asistente de búsqueda personal centrado en novedades: reúne avisos recientes de varias fuentes y los cruza con búsquedas guardadas. La prioridad es descubrir oportunidades temprano; no promete un catálogo completo del mercado.

## Operating Context

- El usuario crea búsquedas persistentes por zonas de Montevideo y preferencias de precio, moneda, dormitorios y superficie.
- Cada búsqueda distingue alquiler y venta. No mezclar operaciones al evaluar coincidencias o describir resultados.
- La adquisición programada incorpora avisos de distintas fuentes a un inventario compartido; las búsquedas y los seguimientos pertenecen a cada usuario.
- El inicio reúne coincidencias de todas las búsquedas, con la posibilidad de seleccionar una búsqueda y ajustar filtros u ordenamientos temporales.
- Los enlaces de las propiedades llevan al portal de origen.
- El seguimiento privado permite guardar favoritos y registrar fechas de contacto, visita y rechazo.

## Capabilities and Constraints

- Aplicación existente en Rails 8 con vistas renderizadas en el servidor, Turbo y PostgreSQL/PostGIS.
- Búsquedas por zonas propias, normalización de datos de proveedores y deduplicación de avisos.
- Precios en UYU y USD; las comparaciones monetarias deben respetar la moneda. Los gastos comunes pueden estar expresados en una moneda distinta del alquiler.
- La superficie y otros datos del proveedor pueden faltar: la interfaz debe distinguir los valores desconocidos y respetar las opciones de inclusión de cada filtro.
- Afinidad calculada a partir de las preferencias activas, con explicaciones y completitud de datos presentadas por separado.
- Alertas de coincidencias y preferencias de notificación por usuario.
- Cuatro fuentes actuales: InfoCasas, Remax, Imperium y Housi. La disponibilidad de datos depende de cada proveedor; no prometer cobertura completa.
- Entrega de alertas mediante Web Push y Pushover opcional, con deduplicación de notificaciones.
- Onboarding para crear la primera búsqueda y configurar alertas; recorrido público bilingüe `/tour` con datos ficticios y sin efectos persistentes.
- Interfaz disponible en español e inglés.
- El inventario compartido elimina avisos no vistos durante siete días; el seguimiento privado conserva una copia de sus datos y sobrevive a esa limpieza.
- Las funciones administrativas y la observabilidad de las fuentes tienen acceso restringido.
- El listado permite combinar hasta tres criterios de ordenamiento por prioridad, incluida la superficie en m² en ambos sentidos. Los criterios posteriores resuelven empates; los valores de superficie desconocidos quedan al final.

## Brand Commitments

El nombre actual del producto es **Timbre**, confirmado por el usuario. La identidad vigente usa el wordmark de puerta redonda, verde Patio, marfil, acentos amarillos y Manrope local; sus archivos y guía están en `public/branding/`. **Rental Scout Lite** es el nombre anterior que todavía aparece en el repositorio. Registrar el nombre no implica renombrar archivos, servicios o textos fuera del alcance de cada tarea.

La voz usa voseo uruguayo natural y mensajes concretos sobre precio, ubicación y gastos. Búsquedas son los filtros guardados; Timbres identifica las coincidencias personales; Avisos configura su entrega. Preservar el significado de buscar, filtrar, guardar y contactar. La animación y el sonido existentes deben respetar movimiento reducido; el sonido requiere activación explícita.

## Evidence on Hand

- `.ai/product/brief.md`: público inicial y propósito original.
- `README.md`: capacidades vigentes de alquiler y venta, fuentes, tour y términos del producto; prevalece sobre el brief inicial cuando documenta ampliaciones posteriores.
- `public/branding/guia-de-marca.md`: identidad y voz aprobadas; preservar los activos existentes.
- `.ai/STATUS.md`: estado y capacidades implementadas; sus fechas deben tenerse en cuenta al consultarlo.
- `.ai/decisions/adr-freshness-first-inventory.md`: decisión de priorizar novedades y limitar la retención del inventario compartido.
- `.ai/decisions/adr-personal-apartment-tracking.md`: historial privado que sobrevive a la limpieza del inventario.
- `app/controllers/listings_controller.rb` y `app/views/listings/index.html.erb`: comportamiento actual del listado y sus controles.
- `config/locales/es.yml` y `config/locales/en.yml`: textos existentes de la interfaz.
- `docs/provider_samples/`: muestras de proveedores para desarrollo; no equivalen a evidencia de disponibilidad actual de las propiedades.

No se han confirmado en esta inicialización métricas comerciales, testimonios, precios del servicio ni garantías de cobertura o disponibilidad.

## Product Principles

1. Priorizar descubrir avisos relevantes temprano.
2. Mantener las búsquedas guardadas como contexto persistente del usuario.
3. Facilitar comparar propiedades con datos y monedas explícitos, sin inventar información faltante.
4. Preservar la privacidad y continuidad del seguimiento personal.
5. Mantener las operaciones de adquisición en segundo plano para que la experiencia principal se concentre en buscar y evaluar propiedades.

## Open Decisions

No se definieron requisitos de accesibilidad específicos del producto ni una política comercial durante esta inicialización.
