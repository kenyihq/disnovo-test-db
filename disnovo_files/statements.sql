-- 1.	Mostrar de las  transacciones id_transaction, nombre del contacto (tradename),
-- transaction_value, transaction_total , cuyo transaction_type_name=’VENTA’, fecha de
-- la transaction (start_date_full) hayan sido realizadas en el periodo desde enero 2022
-- hasta la fecha actual, ordenadas por tradename, fecha (start_date_full)  en forma
-- descendente. (los montos se deben mostrar utilizando el formato 999,999,999.99 y
-- las fecha formato: Lun, 21 Jul 2021 - 18:59

SELECT
    t.transaction_id AS TRANSACTION_ID,
    c.trade_name AS NOMBRE_CONTACTO,
    t.transaction_value AS VALOR_TRANSACCIONES,
    t.transaction_total AS TOTAL_TRANSACCIONES,
    tt.transaction_type_name AS VENTA,
    to_char(t.start_date_full, 'DAY, DD MON YYYY - HH:MM') AS FECHA
FROM transaction AS t,
     contacts AS c,
     transaction_type AS tt
WHERE c.contact_id = t.contact_id
    AND tt.transaction_type_id = t.transaction_type_id
    AND t.start_date_full > '2022-01-01'
ORDER BY c.trade_name DESC, t.start_date_full DESC;

-- Creamos una vista para simplificar esta consulta para este caso usaremos una vista volatil

CREATE OR REPLACE VIEW resume
AS
    SELECT
    t.transaction_id AS TRANSACTION_ID,
    c.trade_name AS NOMBRE_CONTACTO,
    t.transaction_value AS VALOR_TRANSACCIONES,
    t.transaction_total AS TOTAL_TRANSACCIONES,
    tt.transaction_type_name AS VENTA,
    to_char(t.start_date_full, 'DAY, DD MON YYYY - HH:MM') AS FECHA
    FROM transaction AS t,
         contacts AS c,
         transaction_type AS tt
    WHERE c.contact_id = t.contact_id
        AND tt.transaction_type_id = t.transaction_type_id
        AND t.start_date_full > '2022-01-01'
    ORDER BY c.trade_name DESC, t.start_date_full DESC;
ALTER TABLE resume
    OWNER TO disnovo;


-- Consultamos nuestra vista

SELECT * FROM resume;

-- 2.	Mostrar por cada cliente (contact): nombre del contacto (tradename),
-- cantidad de transacciones (tipo venta), monto total de las transacciones

SELECT
    c.trade_name AS Nombre,
    count(tt.transaction_type_id) AS Cantidad,
    t.transaction_total AS Total
FROM contacts AS C,
     transaction AS t,
     transaction_type AS tt
WHERE c.contact_id = t.contact_id
    AND t.transaction_type_id = tt.transaction_type_id
GROUP BY c.trade_name, t.transaction_total

-- Creamos una vista para simplificar esta consulta para este caso usaremos una vista volatil

CREATE OR REPLACE VIEW resume_total
AS
    SELECT
    c.trade_name AS Nombre,
    count(tt.transaction_type_id) AS Cantidad,
    t.transaction_total AS Total
    FROM contacts AS C,
         transaction AS t,
         transaction_type AS tt
    WHERE c.contact_id = t.contact_id
        AND t.transaction_type_id = tt.transaction_type_id
    GROUP BY c.trade_name, t.transaction_total;
ALTER TABLE resume_total
    OWNER TO disnovo;

-- Consultamos nuestra vista

SELECT * FROM resume_total;


--4.	Aumentar en un 15% el precio (price) de todos los productos
-- cuyo tipo de producto (product_type_name) sea ‘CARNE’


-- Como no tenemos 'CARNE' en nustra tabla sacamos el producto que mas se repite
-- en este caso es Mace Ground, lo hacemos con la siguiente consulta

SELECT count(product_type_name) cantidad, product_type_name
FROM product_type
GROUP BY product_type_name
ORDER BY cantidad DESC;

-- Construimos nuestra consulta, donde 'CARNE' será 'Mace Ground'

SELECT
    p.price AS precio_original,
    to_char((p.price * 1.15)::float8, 'FM99999999.00'),
    pt.product_type_name AS nombre
FROM products p,
     product_type pt
WHERE p.product_type_id = pt.product_type_id
AND pt.product_type_name = 'Mace Ground'
ORDER BY precio_original DESC;

--5.	 Eliminar todas las transacciones del cliente cuyo nombre (tradename) es: Juan Pérez


-- Como generamos datos random, consultamos las que coinciden, en este caso solo tenemo 4 coincidencias
-- en el cual 'MATERIAL SCIENCE, LCC' tiene 2 transacciones
-- tomaremos este dato, el cual remplazara a 'Juan Perez'

SELECT count(c.trade_name), c.trade_name
FROM contacts c,
     transaction t
WHERE c.contact_id = t.contact_id
GROUP BY c.trade_name

-- Como tenemos el campo 'eraded' en false, cambiare este estado a true el cual nos indicará
-- que esta borrado.

-- En esta consulta mostraremos solo los que cumplan con el estado en true, el cual será igual
-- a contactos activos con la siguientes vistas

-- Creamos un procedimiento almacenado para cambiar el esatado de una transaccion

CREATE OR REPLACE PROCEDURE sp_change_state(id INT)
LANGUAGE plpgsql
AS $$BEGIN

    IF (SELECT state FROM transaction WHERE transaction_id = id) THEN
        UPDATE transaction SET erased = true, state = false
        WHERE transaction_id = id;

    ELSE

    UPDATE transaction SET erased = false, state = true
    WHERE transaction_id = id;

    END IF;
    COMMIT;
end;
$$;

-- Ejecutamos nuesto procedimiento almacenado

CALL sp_change_state(1);

-- Comprobamos que nuestro procedimeinto almacenado funcione correctamente con la siguiente consulta:

SELECT erased, state FROM transaction;
-- Volvemos a ejecutar nuestro procedimeinto almacenado logrando cambiar su estado
CALL sp_change_state(1);
-- Compribamos que funcione correctamente
SELECT erased, state FROM transaction;
