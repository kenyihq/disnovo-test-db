-- Create database
CREATE DATABASE IF NOT EXISTS db_disnovo OWBER disnovo;

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
    external_id INT NOT NULL,
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
    external_id INT NOT NULL,
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

