# Corrección de cocheras de Remax

Ver el diseño en `docs/superpowers/specs/2026-11-11-remax-parking.md`.

## Evidencia

- Producción: Listing 40696 / external_id 28050 con parking_spaces vacío; 809 avisos de Remax sin el dato en la consulta inicial.
- API real de detalle: HTTP 200 y parkingSpaces 1 para el slug reportado.
- Adaptador corregido verificado contra esa API: parking_spaces 1 con exactamente una petición.
- Suite antes del control de concurrencia: 353 pruebas, 2248 aserciones, sin fallos ni errores.

## Cambios

Adaptador con consulta de detalle validada; ingesta que conserva el dato cuando el índice lo omite; servicio y job de recuperación limitados; planificación horaria; actualización de snapshots sin alterar historial ni antigüedad del inventario. No hay migraciones.

## Operación prevista

Desplegar por main. Ejecutar primero la recuperación de external_id 28050 y verificar parking_spaces 1. Después encolar IDs restantes en lotes de 50 espaciados dos minutos; Solid Queue serializa este tipo de trabajo. Se guardan ceros explícitos y se dejan desconocidos los errores/ausencias. La planificación horaria mantiene el enriquecimiento de avisos nuevos. Consultar el resultado de cada lote y los errores de la cola antes de afirmar que todos los avisos quedaron corregidos.
