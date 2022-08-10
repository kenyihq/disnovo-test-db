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



