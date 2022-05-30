-- Валюта --
CREATE TABLE currency (
  code VARCHAR(20) PRIMARY KEY,
  name VARCHAR(50) NOT NULL CHECK (name <> '')
);

-- Тип документа --
CREATE TABLE document_type (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL CHECK (name <> '')
);


-- Поставщик \ Плательщик --
CREATE TABLE partner (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL CHECK (name <> '')
);

-- Единица измерения --
CREATE TABLE unit (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL CHECK (name <> '')
);

-- Договор --
CREATE TABLE contract (
	id SERIAL PRIMARY KEY,
  document_type_id INT REFERENCES document_type(id),
  seller INT REFERENCES partner(id),
  sub INT REFERENCES partner(id),
  currency_code VARCHAR(20) REFERENCES currency(code),
	number VARCHAR(50) NOT NULL UNIQUE CHECK (number <> ''),
  date date NOT NULL
);

-- Этап договора --
CREATE TABLE stage (
  id SERIAL PRIMARY KEY,
  contract_id INT REFERENCES contract(id),
  number VARCHAR(50) NOT NULL CHECK (number <> ''),
  begin_date date,
  end_date date,
  unit_id INT REFERENCES unit(id),
  sum NUMERIC(13, 4) NOT NULL,
  count INT NOT NULL
);

-- Документ выполнения --
CREATE TABLE act (
  id SERIAL PRIMARY KEY,
  document_type_id INT REFERENCES document_type(id),
  number VARCHAR(50) NOT NULL UNIQUE CHECK (number <> ''),
  currency_code VARCHAR(20) REFERENCES currency(code)
);

-- Фактура --
CREATE TABLE facture (
  id SERIAL PRIMARY KEY,
  act_id INT REFERENCES act(id),
  stage_id INT REFERENCES stage(id),
  position INT NOT NULL,
  date date,
  sum NUMERIC(13, 4) NOT NULL,
  count INT NOT NULL
);