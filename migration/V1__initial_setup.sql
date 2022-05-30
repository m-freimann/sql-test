-- Контрагент --
CREATE TABLE counterparty (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL CHECK (name <> '')
);

-- Единица измерения --
CREATE TABLE unit (
  id SERIAL PRIMARY KEY,
  code VARCHAR(20) NOT NULL UNIQUE CHECK (name <> ''),
  name VARCHAR(50) NOT NULL UNIQUE CHECK (name <> '')
);

-- Валюта --
CREATE TABLE currency (
  id SERIAL PRIMARY KEY,
  code VARCHAR(20) NOT NULL UNIQUE CHECK (name <> ''),
  name VARCHAR(50) NOT NULL CHECK (name <> '')
);

-- Тип операции --
CREATE TABLE operation_type (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE CHECK (name <> '')
);

-- Тип документа --
CREATE TABLE document_type (
  id SERIAL PRIMARY KEY,
  operation_type_id INT REFERENCES operation_type(id) NOT NULL,
  name VARCHAR(50) NOT NULL CHECK (name <> '')
);

-- Договор --
CREATE TABLE contract (
  id SERIAL PRIMARY KEY,
  operation_type_id INT REFERENCES operation_type(id) NOT NULL,
  document_type_id INT REFERENCES document_type(id) NOT NULL,
  number VARCHAR(50) NOT NULL UNIQUE CHECK (number <> ''),
  date date NOT NULL,
  supplier_id INT REFERENCES counterparty(id) NOT NULL,
  payer_id INT REFERENCES counterparty(id) NOT NULL
);

-- Документ --
CREATE TABLE document (
  id SERIAL PRIMARY KEY,
  operation_type_id INT REFERENCES operation_type(id) NOT NULL,
  document_type_id INT REFERENCES document_type(id) NOT NULL,
  number VARCHAR(50) NOT NULL UNIQUE CHECK (number <> ''),
  date date NOT NULL,
  contract_id INT REFERENCES contract(id) NOT NULL
);

-- Позиция документа --
CREATE TABLE document_position (
  id SERIAL PRIMARY KEY,
  document_id INT REFERENCES document(id) NOT NULL,
  name VARCHAR(200) NOT NULL CHECK (name <> ''),
  count INT NOT NULL,
  unit_id INT REFERENCES unit(id) NOT NULL,
  price NUMERIC(13, 4) NOT NULL,
  currency_id INT REFERENCES currency(id) NOT NULL
);
