CREATE VIEW contract_list AS SELECT
    (SELECT name FROM document_type dt WHERE dt.id = c.document_type_id) AS contract_type,
    c.number as contract_number,
    c.date as contract_date,
    (SELECT name FROM partner p WHERE p.id = c.seller) AS seller,
    (SELECT round(sum(s.sum), 2) FROM stage s WHERE s.contract_id = c.id) AS contract_sum,
    (SELECT round(sum(f.sum), 2) FROM facture f
        LEFT JOIN stage s ON f.stage_id = s.id
        WHERE s.contract_id = c.id) AS payment_sum
FROM contract c;