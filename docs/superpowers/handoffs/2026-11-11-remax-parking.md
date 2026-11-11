# Corrección de cocheras de Remax

Ver el diseño en `docs/superpowers/specs/2026-11-11-remax-parking.md`.

## Evidencia

- Producción: Listing 40696 / external_id 28050 con parking_spaces vacío; 809 avisos de Remax sin el dato en la consulta inicial.
- API real de detalle: HTTP 200 y parkingSpaces 1 para el slug reportado.
- Adaptador corregido verificado contra esa API: parking_spaces 1 con exactamente una petición.
- Suite completa, incluyendo control de concurrencia: 353 pruebas, 2248 aserciones, sin fallos ni errores. Zeitwerk pasó.

## Cambios

Adaptador con consulta de detalle validada; ingesta que conserva el dato cuando el índice lo omite; servicio y job de recuperación limitados; planificación horaria; actualización de snapshots sin alterar historial ni antigüedad del inventario. No hay migraciones.

## Producción

Desplegado por main: commit `0ca83165da71269d8734ed09f456d0963f803be0`, workflow `https://github.com/FedericoDallo17/timbre/actions/runs/43094269120` completado correctamente. Health público `/up`: HTTP 200.

La recuperación puntual de external_id 28050 actualizó Listing 40696 a parking_spaces 1. Se verificó que updated_at sigue en `2026-11-08 03:34:50 UTC`.

Los 808 IDs restantes se encolaron en 17 lotes de 50, separados dos minutos, con Solid Queue serializando ejecuciones. Primer lote finalizado sin fallos. Checkpoint: 51 registros con dato explícito (21 con una cochera, 2 con dos, 28 con cero), 758 aún desconocidos; 17 trabajos registrados, uno finalizado y cero fallidos. La recuperación histórica continúa en segundo plano; no afirmar que todos quedaron completados sin volver a consultar.

## Seguimiento

Se guardan ceros explícitos y se dejan desconocidos los errores/ausencias. La planificación horaria mantiene el enriquecimiento de avisos nuevos. Consultar Listing de fuente remax agrupado por parking_spaces y SolidQueue::Job / SolidQueue::FailedExecution filtrados por BackfillRemaxParkingJob para verificar el final. Los jobs registran contadores seen/updated, sin datos personales.
