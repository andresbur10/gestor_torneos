# RFC - Gestor de Torneos Locales

## 1. Objetivo
Desarrollar una app móvil **offline** en Flutter que permita:
- Crear y administrar torneos de fútbol locales.
- Registrar partidos a través de eventos (goles, autogoles, tarjetas).
- Calcular automáticamente tabla de posiciones y ranking de goleadores.

## 2. Alcance inicial (MVP)
- Crear/editar torneos, equipos, jugadores y partidos.
- Registro de eventos básicos: gol, autogol, tarjeta amarilla/roja.
- Cálculo en tiempo real de tabla y goleadores.
- Persistencia local (JSON o base de datos ligera).
- Sin autenticación, backend ni tiempo real.

## 3. Usuarios y roles
- **Admin**: crea/edita torneos, equipos, jugadores, partidos y eventos.
- **Viewer**: consulta información (modo solo lectura).

## 4. Reglas de negocio
1. Puntuación: 3 pts victoria, 1 empate, 0 derrota.
2. Desempate: diferencia de gol → goles a favor → ID de equipo.
3. Autogol: suma goles al equipo contrario.
4. Tabla y goleadores calculados siempre desde eventos, no datos precalculados.

## 5. Fuera de alcance (por ahora)
- Conexión a internet o sincronización en la nube.
- Roles múltiples y autenticación.
- Streaming de video o VAR.
- Diseño visual avanzado.

## 6. Criterio de éxito del MVP
- Permitir registrar al menos un torneo con 4 equipos y 6 partidos.
- Generar correctamente tabla y ranking de goleadores.
- Los datos permanecen tras reiniciar la app (persistencia local).

## 7. Ideas para futuras iteraciones
- Sincronización con backend y API propia.
- Modo tiempo real con WebSockets.
- Analítica avanzada (xG, mapas de calor).
- Exportación a PDF o CSV.

---
**Última actualización:** _(15/08/2025)_