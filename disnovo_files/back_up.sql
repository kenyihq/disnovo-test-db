-- Create database
CREATE DATABASE db_disnovo OWNER disnovo;

DROP DATABASE db_disnovo;
-- Create tables
CREATE TABLE contacts(
    contact_id SERIAL PRIMARY KEY,
    nickname_owner VARCHAR(64) UNIQUE NOT NULL,
    busines_name VARCHAR(100) NOT NULL,
    trade_name VARCHAR(100) NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL,
    type_user VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    observation VARCHAR(255),
    objetive VARCHAR(100),
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    state BOOLEAN DEFAULT true,
    erased BOOLEAN DEFAULT false
);

CREATE TABLE products(
    product_id SERIAL PRIMARY KEY,
    nickname_owner VARCHAR(64) UNIQUE,
    product_name VARCHAR(100) NOT NULL,
    product_title VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    observation VARCHAR(255),
    stock_min NUMERIC NOT NULL,
    stock_max NUMERIC NOT NULL,
    price NUMERIC NOT NULL,
    product_type_id INT NOT NULL,
    nickname_owner_type VARCHAR(100) NOT NULL,
    nickname_creator VARCHAR(100) NOT NULL,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    state BOOLEAN DEFAULT true,
    erased BOOLEAN DEFAULT false
);

CREATE TABLE transaction_type(
    transaction_type_id SERIAL PRIMARY KEY,
    nickname_owner VARCHAR(100) UNIQUE,
    transaction_type_name VARCHAR(100) NOT NULL,
    transaction_type_title VARCHAR(100) NOT NULL,
    is_sub_type BOOLEAN NOT NULL,
    description VARCHAR(100),
    external_id VARCHAR(64) UNIQUE,
    nickname_creator VARCHAR(100) NOT NULL,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transaction(
    transaction_id SERIAL PRIMARY KEY,
    nickname_owner VARCHAR(100) UNIQUE,
    transaction_name VARCHAR(100) NOT NULL,
    transaction_title VARCHAR(100) NOT NULL,
    transaction_type_id INT NOT NULL,
    nickname_owner_type VARCHAR(64) NOT NULL,
    contact_id INT NOT NULL,
    nickname_owner_contact VARCHAR(64) NOT NULL,
    start_date_full TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    start_date VARCHAR(32) NOT NULL,
    start_year SMALLINT NOT NULL,
    start_month SMALLINT NOT NULL,
    start_week SMALLINT NOT NULL,
    start_day SMALLINT NOT NULL,
    start_time SMALLINT NOT NULL,
    transaction_probability NUMERIC NOT NULL,
    transaction_prevalue NUMERIC NOT NULL,
    transaction_discount NUMERIC NOT NULL,
    transaction_charge NUMERIC NOT NULL,
    transaction_value NUMERIC NOT NULL,
    transaction_taxpercentage NUMERIC NOT NULL,
    transaction_tax NUMERIC NOT NULL,
    transaction_total NUMERIC NOT NULL,
    transaction_balance NUMERIC NOT NULL,
    external_id VARCHAR(64) UNIQUE,
    commentary VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    observation VARCHAR(255) NOT NULL,
    objective VARCHAR(100) NOT NULL,
    objective_completed VARCHAR(255) NOT NULL,
    nickname_creator VARCHAR(64) NOT NULL,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    state BOOLEAN DEFAULT true,
    erased BOOLEAN DEFAULT false
);

CREATE TABLE transaction_detail(
    transaction_dateil_id SERIAL PRIMARY KEY,
    nickname_owner_transaction VARCHAR(64) UNIQUE,
    product_id INT NOT NULL,
    nickname_owner_product VARCHAR(64) UNIQUE,
    item_id SMALLINT UNIQUE,
    price NUMERIC NOT NULL,
    quantity NUMERIC NOT NULL,
    transactiondetail_discount NUMERIC NOT NULL,
    transactiondetail_discountpercentage NUMERIC NOT NULL,
    transactiondetail_charge NUMERIC NOT NULL,
    transactiondetail_chargepercentage NUMERIC NOT NULL,
    transactiondetail_taxpercentage NUMERIC NOT NULL,
    transactiondetail_tax NUMERIC NOT NULL,
    transactiondetail_balance NUMERIC NOT NULL,
    description VARCHAR(255),
    commentary VARCHAR(255),
    state BOOLEAN DEFAULT true,
    erased BOOLEAN DEFAULT false
);

CREATE TABLE product_type(
    product_type_id SERIAL PRIMARY KEY,
    nickname_owner VARCHAR(64) UNIQUE,
    product_type_name VARCHAR(64) NOT NULL,
    product_type_title  VARCHAR(64) NOT NULL,
	external_id VARCHAR(64) UNIQUE ,
	nickname_creator VARCHAR(64) NOT NULL,
	creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	is_public BOOLEAN NOT NULL,
	state BOOLEAN NOT NULL,
	erased BOOLEAN NOT NULL
);

-- Added Foreign keys

ALTER TABLE products ADD CONSTRAINT fk_pti
    FOREIGN KEY (product_type_id)
    REFERENCES product_type(product_type_id);

ALTER TABLE transaction ADD CONSTRAINT fk_tti
    FOREIGN KEY (transaction_type_id)
    REFERENCES transaction_type(transaction_type_id);

ALTER TABLE transaction ADD CONSTRAINT fk_ci
    FOREIGN KEY (contact_id)
    REFERENCES contacts(contact_id);

ALTER TABLE transaction_detail ADD CONSTRAINT fk_pi
    FOREIGN KEY (product_id)
    REFERENCES products(product_id);