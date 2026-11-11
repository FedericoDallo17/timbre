# Remax: recuperar cocheras desde el detalle

## Problema verificado

El aviso `venta-apartamento-2-dormitorios-gge-la-blanqueada` (external_id 28050, Listing 40696) tiene `parkingSpaces: 1` en la API de detalle de Remax, pero `parking_spaces: null` en producción. Los 809 avisos de Remax consultados el 11 de noviembre tenían el campo vacío. El adaptador lo fijaba en nil; el índice público no incluye esa característica.

Endpoint verificado con HTTP 200: `https://api-ar.redremax.com/remaxweb-uy/api/listings/findBySlug/venta-apartamento-2-dormitorios-gge-la-blanqueada`. Datos públicos contrastados: slug exacto, entidad `178281f2-4110-4de0-8737-59de9223039e`, MLS `940141005-59`, parkingSpaces 1. No se infiere una cantidad del título ni de abreviaturas.

## Diseño e implementación

1. Añadir consulta de detalle con host fijo, validación de URL/slug, timeouts existentes, contador de llamadas y pausa de 0,5 segundos por petición. Aceptar solamente un entero no negativo explícito; cero es conocido, ausente es desconocido. Errores de red, HTTP o datos no cambian registros.
2. El índice omite parking_spaces cuando no tiene un valor válido, para conservar el dato ya enriquecido en futuras ingestas.
3. Completar datos ausentes en un trabajo separado, con 50 avisos por ejecución (máximo 100), priorizando los nuevos. Una sola ejecución simultánea mediante Solid Queue. El scraper principal conserva su número de consultas de listado.
4. Ejecutar cada hora al minuto 10. Recuperación histórica mediante IDs explícitos repartidos en lotes espaciados de 50.
5. Actualizar condicionalmente solamente garajes desconocidos y el mismo dato faltante en snapshots vinculados. Preservar favoritos, notas, fechas y el resto de cada snapshot. No tocar updated_at: corregir un dato no equivale a volver a ver el aviso en la fuente y no debe prolongar su retención.
6. Verificar con HTTP simulado errores, ceros, payload inválido, slug incorrecto, contadores y conservación tras reingesta. Verificar alcance, límites, snapshots y antigüedad con base de pruebas.

## Fuera de alcance

Estado reservado del aviso, enriquecimiento de otras fuentes y actualización de atributos privados aportados por los usuarios. No se ejecuta una adquisición completa para corregir las cocheras.
