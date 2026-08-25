Use Ventas_Tech_DB
Go
Select top 5 * from categorias
Select top 5 * from clientes
Select top 5 * from productos
Select top 5 * from ventas

CREATE TABLE territorios (
    id_territorio INT PRIMARY KEY,
    region VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    zona VARCHAR(50)
);


INSERT INTO territorios VALUES
(1, 'Centro', 'Argentina', 'Buenos Aires');

INSERT INTO territorios VALUES
(2, 'Centro', 'Argentina', 'Córdoba');

INSERT INTO territorios VALUES
(3, 'Litoral', 'Argentina', 'Rosario');

INSERT INTO territorios VALUES
(4, 'Cuyo', 'Argentina', 'Mendoza');

INSERT INTO territorios VALUES
(5, 'NOA', 'Argentina', 'Tucumán');

SELECT * FROM territorios;

UPDATE clientes
SET segmento =
    CASE
        WHEN id_cliente = 1 THEN 'Empresa'
        WHEN id_cliente = 2 THEN 'Minorista'
        WHEN id_cliente = 3 THEN 'Minorista'
        WHEN id_cliente = 4 THEN 'Empresa'
        WHEN id_cliente = 5 THEN 'Mayorista'
    END;

    SELECT * FROM clientes;

    ALTER TABLE ventas
ADD id_territorio INT,
    canal VARCHAR(20);



    UPDATE ventas
SET id_territorio =
    CASE
        WHEN id_cliente = 1 THEN 1
        WHEN id_cliente = 2 THEN 2
        WHEN id_cliente = 3 THEN 3
        WHEN id_cliente = 4 THEN 4
        WHEN id_cliente = 5 THEN 5
    END;

    UPDATE ventas
SET canal =
    CASE
        WHEN id_venta IN (1, 3, 5, 7, 9) THEN 'Online'
        ELSE 'Presencial'
    END;

    SELECT * FROM ventas;

    ALTER TABLE ventas
ADD CONSTRAINT FK_ventas_territorios
FOREIGN KEY (id_territorio)
REFERENCES territorios(id_territorio);

SELECT * FROM ventas;

-- =========================================
-- CONSULTA 1 - VISTA BASE DEL PROYECTO
-- INNER JOIN
-- =========================================

SELECT
    v.fecha_venta AS fecha,
    c.nombre AS nombre_cliente,
    c.segmento,
    t.region,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta,
    v.canal
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
INNER JOIN territorios t
    ON v.id_territorio = t.id_territorio
ORDER BY v.fecha_venta;

-- =========================================
-- CONSULTA 2 - CLIENTES SIN VENTAS
-- LEFT JOIN
-- =========================================

SELECT
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- =========================================
-- CONSULTA 3 - PRODUCTOS SIN VENTAS
-- LEFT JOIN
-- =========================================

SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;

-- =========================================
-- CONSULTA 4 - CONSOLIDADO POR CANAL
-- UNION ALL
-- =========================================

SELECT
    canal,
    SUM(total_venta) AS total_facturado
FROM (
    SELECT
        'Online' AS canal,
        cantidad * precio_unitario AS total_venta
    FROM ventas
    WHERE canal = 'Online'

    UNION ALL

    SELECT
        'Presencial' AS canal,
        cantidad * precio_unitario AS total_venta
    FROM ventas
    WHERE canal = 'Presencial'
) AS ventas_por_canal
GROUP BY canal
ORDER BY total_facturado DESC;

-- =========================================
-- HALLAZGOS Y CONCLUSIONES
-- =========================================

-- 1. El canal Online genera una facturación de 4560.00,
--    superior a los 1884.00 generados por el canal Presencial.
--    Esto sugiere que el canal Online tiene mayor peso en la facturación
--    y debería ser considerado prioritario en el análisis comercial.

-- 2. No se encontraron clientes registrados sin ventas,
--    lo que indica que todos los clientes de la base realizaron
--    al menos una compra.

-- 3. No se encontraron productos sin ventas,
--    por lo que todo el catálogo actual presenta movimiento comercial.
