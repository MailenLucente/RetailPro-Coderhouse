USE Ventas_Tech_DB;
GO
SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

WITH ventas_por_mes AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
),
promedio_mensual AS (
    SELECT
        AVG(total_facturado) AS promedio_general
    FROM ventas_por_mes
)
SELECT
    v.mes,
    v.total_facturado,
    p.promedio_general,
    CASE
        WHEN v.total_facturado > p.promedio_general THEN 'Por encima'
        WHEN v.total_facturado < p.promedio_general THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion
FROM ventas_por_mes v
CROSS JOIN promedio_mensual p
ORDER BY v.mes;

-- HALLAZGOS
-- =========================================

-- 1. El producto 1 es el que genera mayor facturación,
--    con un total de 3600, aproximadamente el 56% de la facturación total.

-- 2. El producto 2 registra la mayor cantidad de unidades vendidas,
--    con un total de 13 unidades.

-- 3. Todos los clientes realizaron más de un pedido.
--    El cliente 1 registra el mayor gasto total, con 2640.