# sql-test

## Запуск

`docker-compose up migrations`

## Ответы

### Вывести перечень контрагентов

```sql
SELECT "name" from counterparty;
```

### Вывести реестр договоров в виде:
| Тип договора  | № договора    | Дата подписания | Поставщик | Плательщик |
| ------------- | ------------- | --------------- | --------- | ---------- |

```sql
SELECT
    (SELECT "name" FROM document_type dt WHERE dt.id = c.document_type_id) AS "type",
    c.number as "number",
    c.date as "date",
    (SELECT "name" FROM counterparty cp WHERE cp.id = c.supplier_id) AS "supplier",
    (SELECT "name" FROM counterparty cp WHERE cp.id = c.payer_id) AS "payer"
FROM contract c;
```

### Вывести реестр документов, тип операции у которых "Расходные документы", в виде:
| Тип документа | № документа   | Дата | Сумма по документу | № договора | Поставщик | Плательщик |
| ------------- | ------------- | ---- | ------------------ | ---------- | --------- |----------- | 

```sql
SELECT
    (SELECT "name" FROM document_type dt WHERE dt.id = d.document_type_id) AS "type",
    d.number as "number",
    d.date as "date",
    (SELECT sum(count * price) as sum_by_unit
            FROM document_position dp
            WHERE dp.document_id = d.id
            GROUP BY dp.document_id
    ) as "sum",
    (SELECT "number" FROM contract c WHERE c.id = d.contract_id) AS "contract_number",
    (SELECT "name" FROM counterparty cp
        LEFT JOIN contract c ON c.supplier_id = cp.id
        WHERE d.contract_id = c.id
    ) AS "supplier",
    (SELECT "name" FROM counterparty cp
        LEFT JOIN contract c ON c.payer_id = cp.id
        WHERE d.contract_id = c.id
    ) AS "payer"
FROM document d
WHERE d.operation_type_id = (SELECT "id" FROM operation_type op WHERE op.name = 'Расходные документы');
```

### Вывести реестр документов в виде:
| Дата | Количество документов |
| ---- | --------------------- |
```sql
SELECT
  d.date as "date",
  count(d.date) as "count"
FROM document d
GROUP BY d.date;
```

### Вывести дату с максимальным количеством внесенных документов
```sql
SELECT "date" 
FROM (SELECT
    d.date as "date",
    count(d.date) as "count"
    FROM document d
    GROUP BY d.date
    ORDER BY d.date DESC
    LIMIT 1
) AS q;
```

### В документ №1 от 01.01.06 добавить позицию: Болт 10 штук, цена 3 руб.
```sql
INSERT INTO document_position
  (document_id, unit_id, currency_id, name, count, price)
VALUES(
  (SELECT "id" FROM document d WHERE d.number = '№1' AND d.date = '01.01.2006'),
  (SELECT "id" FROM unit u WHERE u.name = 'Болт'),
  (SELECT "id" FROM currency c WHERE c.code = 'RU'),
  'Болт', 10, 3.00
);
```

### Создать документ:
- №3
- от 01.02.06
- остальные реквизиты совпадают с документом, имеющим ID_документа = 101020
- Позициями документа являются позиции всех документов данного типа за январь 2006 г. с ценой более 10 рублей.

```sql
WITH rows AS (
  INSERT INTO document (number, date, contract_id, document_type_id, operation_type_id) 
  (SELECT '№3', '01.02.06', contract_id, document_type_id, operation_type_id FROM document WHERE id = 101020)
  RETURNING id, document_type_id
)

INSERT INTO document_position (document_id, name, count, unit_id, price, currency_id)
  SELECT (SELECT id FROM rows), dp.name, dp.count, dp.unit_id, dp.price, dp.currency_id
  FROM document_position dp
  LEFT JOIN document d ON d.id = dp.document_id
      WHERE d.date >= '01.01.2006' AND d.date < '01.02.2006'
      AND dp.count > 10
      AND dp.currency_id = (SELECT "id" FROM currency c WHERE c.code = 'RU');
```

### Проставить дату подписания (01.01.06) входящего договора поставки №123. Тип операции: Входящие договоры и Тип документа: Договор поставки

```sql
UPDATE contract SET date = '01.01.06'
  WHERE number = '№123'
  AND operation_type_id = (SELECT "id" FROM operation_type op WHERE op.name = 'Входящие договоры')
  AND document_type_id = (SELECT "id" FROM document_type dt WHERE dt.name = 'Входящие договоры');
```
