--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 13.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: contacts; Type: TABLE; Schema: public; Owner: disnovo
--

CREATE TABLE public.contacts (
    contact_id integer NOT NULL,
    nickname_owner character varying(64) NOT NULL,
    busines_name character varying(100) NOT NULL,
    trade_name character varying(100) NOT NULL,
    firstname character varying(100) NOT NULL,
    lastname character varying(100) NOT NULL,
    type_user character varying(100) NOT NULL,
    description character varying(255),
    observation character varying(255),
    objetive character varying(100),
    creation_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    state boolean DEFAULT true,
    erased boolean DEFAULT false
);


ALTER TABLE public.contacts OWNER TO disnovo;

--
-- Name: contacts_contact_id_seq; Type: SEQUENCE; Schema: public; Owner: disnovo
--

CREATE SEQUENCE public.contacts_contact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contacts_contact_id_seq OWNER TO disnovo;

--
-- Name: contacts_contact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: disnovo
--

ALTER SEQUENCE public.contacts_contact_id_seq OWNED BY public.contacts.contact_id;


--
-- Name: product_type; Type: TABLE; Schema: public; Owner: disnovo
--

CREATE TABLE public.product_type (
    product_type_id integer NOT NULL,
    nickname_owner character varying(64),
    product_type_name character varying(64) NOT NULL,
    product_type_title character varying(64) NOT NULL,
    external_id character varying(64),
    nickname_creator character varying(64) NOT NULL,
    creation_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_public boolean NOT NULL,
    state boolean NOT NULL,
    erased boolean NOT NULL
);


ALTER TABLE public.product_type OWNER TO disnovo;

--
-- Name: product_type_product_type_id_seq; Type: SEQUENCE; Schema: public; Owner: disnovo
--

CREATE SEQUENCE public.product_type_product_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_type_product_type_id_seq OWNER TO disnovo;

--
-- Name: product_type_product_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: disnovo
--

ALTER SEQUENCE public.product_type_product_type_id_seq OWNED BY public.product_type.product_type_id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: disnovo
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    nickname_owner character varying(64),
    product_name character varying(100) NOT NULL,
    product_title character varying(100) NOT NULL,
    description character varying(255),
    observation character varying(255),
    stock_min numeric NOT NULL,
    stock_max numeric NOT NULL,
    price numeric NOT NULL,
    product_type_id integer NOT NULL,
    nickname_owner_type character varying(100) NOT NULL,
    nickname_creator character varying(100) NOT NULL,
    creation_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    state boolean DEFAULT true,
    erased boolean DEFAULT false
);


ALTER TABLE public.products OWNER TO disnovo;

--
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: disnovo
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_product_id_seq OWNER TO disnovo;

--
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: disnovo
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- Name: transaction; Type: TABLE; Schema: public; Owner: disnovo
--

CREATE TABLE public.transaction (
    transaction_id integer NOT NULL,
    nickname_owner character varying(100),
    transaction_name character varying(100) NOT NULL,
    transaction_title character varying(100) NOT NULL,
    transaction_type_id integer NOT NULL,
    nickname_owner_type character varying(64) NOT NULL,
    contact_id integer NOT NULL,
    nickname_owner_contact character varying(64) NOT NULL,
    start_date_full timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    start_date character varying(32) NOT NULL,
    start_year smallint NOT NULL,
    start_month smallint NOT NULL,
    start_week smallint NOT NULL,
    start_day smallint NOT NULL,
    start_time smallint NOT NULL,
    transaction_probability numeric NOT NULL,
    transaction_prevalue numeric NOT NULL,
    transaction_discount numeric NOT NULL,
    transaction_charge numeric NOT NULL,
    transaction_value numeric NOT NULL,
    transaction_taxpercentage numeric NOT NULL,
    transaction_tax numeric NOT NULL,
    transaction_total numeric NOT NULL,
    transaction_balance numeric NOT NULL,
    external_id character varying(64),
    commentary character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    observation character varying(255) NOT NULL,
    objective character varying(100) NOT NULL,
    objective_completed character varying(255) NOT NULL,
    nickname_creator character varying(64) NOT NULL,
    creation_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    state boolean DEFAULT true,
    erased boolean DEFAULT false
);


ALTER TABLE public.transaction OWNER TO disnovo;

--
-- Name: transaction_detail; Type: TABLE; Schema: public; Owner: disnovo
--

CREATE TABLE public.transaction_detail (
    transaction_dateil_id integer NOT NULL,
    nickname_owner_transaction character varying(64),
    id_product integer NOT NULL,
    nickname_owner_product character varying(64),
    id_item smallint,
    price numeric NOT NULL,
    quantity numeric NOT NULL,
    transactiondetail_discount numeric NOT NULL,
    transactiondetail_discountpercentage numeric NOT NULL,
    transactiondetail_charge numeric NOT NULL,
    transactiondetail_chargepercentage numeric NOT NULL,
    transactiondetail_taxpercentage numeric NOT NULL,
    transactiondetail_tax numeric NOT NULL,
    transactiondetail_balance numeric NOT NULL,
    description character varying(255),
    commentary character varying(255),
    state boolean DEFAULT true,
    erased boolean DEFAULT false
);


ALTER TABLE public.transaction_detail OWNER TO disnovo;

--
-- Name: transaction_detail_transaction_dateil_id_seq; Type: SEQUENCE; Schema: public; Owner: disnovo
--

CREATE SEQUENCE public.transaction_detail_transaction_dateil_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_detail_transaction_dateil_id_seq OWNER TO disnovo;

--
-- Name: transaction_detail_transaction_dateil_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: disnovo
--

ALTER SEQUENCE public.transaction_detail_transaction_dateil_id_seq OWNED BY public.transaction_detail.transaction_dateil_id;


--
-- Name: transaction_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: disnovo
--

CREATE SEQUENCE public.transaction_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_transaction_id_seq OWNER TO disnovo;

--
-- Name: transaction_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: disnovo
--

ALTER SEQUENCE public.transaction_transaction_id_seq OWNED BY public.transaction.transaction_id;


--
-- Name: transaction_type; Type: TABLE; Schema: public; Owner: disnovo
--

CREATE TABLE public.transaction_type (
    transaction_type_id integer NOT NULL,
    nickname_owner character varying(100),
    transaction_type_name character varying(100) NOT NULL,
    transaction_type_title character varying(100) NOT NULL,
    is_sub_type boolean NOT NULL,
    description character varying(100),
    external_id character varying(64),
    nickname_creator character varying(100) NOT NULL,
    creation_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.transaction_type OWNER TO disnovo;

--
-- Name: transaction_type_transaction_type_id_seq; Type: SEQUENCE; Schema: public; Owner: disnovo
--

CREATE SEQUENCE public.transaction_type_transaction_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_type_transaction_type_id_seq OWNER TO disnovo;

--
-- Name: transaction_type_transaction_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: disnovo
--

ALTER SEQUENCE public.transaction_type_transaction_type_id_seq OWNED BY public.transaction_type.transaction_type_id;


--
-- Name: contacts contact_id; Type: DEFAULT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.contacts ALTER COLUMN contact_id SET DEFAULT nextval('public.contacts_contact_id_seq'::regclass);


--
-- Name: product_type product_type_id; Type: DEFAULT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.product_type ALTER COLUMN product_type_id SET DEFAULT nextval('public.product_type_product_type_id_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- Name: transaction transaction_id; Type: DEFAULT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction ALTER COLUMN transaction_id SET DEFAULT nextval('public.transaction_transaction_id_seq'::regclass);


--
-- Name: transaction_detail transaction_dateil_id; Type: DEFAULT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction_detail ALTER COLUMN transaction_dateil_id SET DEFAULT nextval('public.transaction_detail_transaction_dateil_id_seq'::regclass);


--
-- Name: transaction_type transaction_type_id; Type: DEFAULT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction_type ALTER COLUMN transaction_type_id SET DEFAULT nextval('public.transaction_type_transaction_type_id_seq'::regclass);


--
-- Data for Name: contacts; Type: TABLE DATA; Schema: public; Owner: disnovo
--

COPY public.contacts (contact_id, nickname_owner, busines_name, trade_name, firstname, lastname, type_user, description, observation, objetive, creation_date, state, erased) FROM stdin;
\.


--
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: disnovo
--

COPY public.product_type (product_type_id, nickname_owner, product_type_name, product_type_title, external_id, nickname_creator, creation_date, is_public, state, erased) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: disnovo
--

COPY public.products (product_id, nickname_owner, product_name, product_title, description, observation, stock_min, stock_max, price, product_type_id, nickname_owner_type, nickname_creator, creation_date, state, erased) FROM stdin;
\.


--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: disnovo
--

COPY public.transaction (transaction_id, nickname_owner, transaction_name, transaction_title, transaction_type_id, nickname_owner_type, contact_id, nickname_owner_contact, start_date_full, start_date, start_year, start_month, start_week, start_day, start_time, transaction_probability, transaction_prevalue, transaction_discount, transaction_charge, transaction_value, transaction_taxpercentage, transaction_tax, transaction_total, transaction_balance, external_id, commentary, description, observation, objective, objective_completed, nickname_creator, creation_date, state, erased) FROM stdin;
\.


--
-- Data for Name: transaction_detail; Type: TABLE DATA; Schema: public; Owner: disnovo
--

COPY public.transaction_detail (transaction_dateil_id, nickname_owner_transaction, id_product, nickname_owner_product, id_item, price, quantity, transactiondetail_discount, transactiondetail_discountpercentage, transactiondetail_charge, transactiondetail_chargepercentage, transactiondetail_taxpercentage, transactiondetail_tax, transactiondetail_balance, description, commentary, state, erased) FROM stdin;
\.


--
-- Data for Name: transaction_type; Type: TABLE DATA; Schema: public; Owner: disnovo
--

COPY public.transaction_type (transaction_type_id, nickname_owner, transaction_type_name, transaction_type_title, is_sub_type, description, external_id, nickname_creator, creation_date) FROM stdin;
\.


--
-- Name: contacts_contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: disnovo
--

SELECT pg_catalog.setval('public.contacts_contact_id_seq', 1, false);


--
-- Name: product_type_product_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: disnovo
--

SELECT pg_catalog.setval('public.product_type_product_type_id_seq', 1, false);


--
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: disnovo
--

SELECT pg_catalog.setval('public.products_product_id_seq', 1, false);


--
-- Name: transaction_detail_transaction_dateil_id_seq; Type: SEQUENCE SET; Schema: public; Owner: disnovo
--

SELECT pg_catalog.setval('public.transaction_detail_transaction_dateil_id_seq', 1, false);


--
-- Name: transaction_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: disnovo
--

SELECT pg_catalog.setval('public.transaction_transaction_id_seq', 1, false);


--
-- Name: transaction_type_transaction_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: disnovo
--

SELECT pg_catalog.setval('public.transaction_type_transaction_type_id_seq', 1, false);


--
-- Name: contacts contacts_nickname_owner_key; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_nickname_owner_key UNIQUE (nickname_owner);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (contact_id);


--
-- Name: product_type product_type_external_id_key; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_external_id_key UNIQUE (external_id);


--
-- Name: product_type product_type_nickname_owner_key; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_nickname_owner_key UNIQUE (nickname_owner);


--
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (product_type_id);


--
-- Name: products products_nickname_owner_key; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_nickname_owner_key UNIQUE (nickname_owner);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: transaction_detail transaction_detail_id_item_key; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction_detail
    ADD CONSTRAINT transaction_detail_id_item_key UNIQUE (id_item);


--
-- Name: transaction_detail transaction_detail_nickname_owner_product_key; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction_detail
    ADD CONSTRAINT transaction_detail_nickname_owner_product_key UNIQUE (nickname_owner_product);


--
-- Name: transaction_detail transaction_detail_nickname_owner_transaction_key; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction_detail
    ADD CONSTRAINT transaction_detail_nickname_owner_transaction_key UNIQUE (nickname_owner_transaction);


--
-- Name: transaction_detail transaction_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction_detail
    ADD CONSTRAINT transaction_detail_pkey PRIMARY KEY (transaction_dateil_id);


--
-- Name: transaction transaction_external_id_key; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_external_id_key UNIQUE (external_id);


--
-- Name: transaction transaction_nickname_owner_key; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_nickname_owner_key UNIQUE (nickname_owner);


--
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (transaction_id);


--
-- Name: transaction_type transaction_type_external_id_key; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction_type
    ADD CONSTRAINT transaction_type_external_id_key UNIQUE (external_id);


--
-- Name: transaction_type transaction_type_nickname_owner_key; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction_type
    ADD CONSTRAINT transaction_type_nickname_owner_key UNIQUE (nickname_owner);


--
-- Name: transaction_type transaction_type_pkey; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction_type
    ADD CONSTRAINT transaction_type_pkey PRIMARY KEY (transaction_type_id);


--
-- PostgreSQL database dump complete
--

