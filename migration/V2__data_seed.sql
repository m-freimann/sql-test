INSERT INTO counterparty (name) VALUES
  ('ООО "Рога и копыта"'),
  ('ЗАО "Куры лимитед"');

INSERT INTO unit (code, name) VALUES
  ('Рога', 'Рога'),
  ('Копыта', 'Копыта'),
  ('Куры', 'Куры'),
  ('Яйца', 'Яйца'),
  ('Болт', 'Болт');

INSERT INTO currency (code, name) VALUES
  ('RU', 'Рубль'),
  ('USD', 'Доллар');

INSERT INTO operation_type (name) VALUES
  ('Входящие договоры'),
  ('Расходные документы');

INSERT INTO document_type (operation_type_id, name) VALUES
  (1, 'Договор поставки'),
  (2, 'Договор выполнения');

INSERT INTO contract (operation_type_id, document_type_id, number, date, supplier_id, payer_id) VALUES
  (1, 1, 'Договор 1', '01.01.2016', 1, 1),
  (1, 2, 'Договор 2', '01.03.2016', 2, 2);

INSERT INTO document (operation_type_id, document_type_id, number, date, contract_id) VALUES
  (1, 1, '1', '01.01.2006', 1),
  (1, 2, 'Документ 2', '01.03.2016', 1),
  (2, 2, 'Документ 3', '01.03.2016', 2),
  (2, 2, 'Документ 4', '01.03.2016', 2);

INSERT INTO document_position (document_id, name, count, unit_id, price, currency_id) VALUES
  (1, 'Позиция 1', 10, 1, 100.00, 1),
  (1, 'Позиция 2', 10, 1, 100.00, 1),
  (2, 'Позиция 3', 20, 2, 100.00, 2),
  (2, 'Позиция 4', 20, 2, 100.00, 2),
  (3, 'Позиция 5', 10, 2, 100.00, 2);