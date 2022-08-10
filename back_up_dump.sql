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
-- Name: resume; Type: VIEW; Schema: public; Owner: disnovo
--

CREATE VIEW public.resume AS
 SELECT t.transaction_id,
    c.trade_name AS nombre_contacto,
    t.transaction_value AS valor_transacciones,
    t.transaction_total AS total_transacciones,
    tt.transaction_type_name AS venta,
    to_char(t.start_date_full, 'DAY, DD MON YYYY - HH:MM'::text) AS fecha
   FROM public.transaction t,
    public.contacts c,
    public.transaction_type tt
  WHERE ((c.contact_id = t.contact_id) AND (tt.transaction_type_id = t.transaction_type_id) AND (t.start_date_full > '2022-01-01 00:00:00'::timestamp without time zone))
  ORDER BY c.trade_name DESC, t.start_date_full DESC;


ALTER TABLE public.resume OWNER TO disnovo;

--
-- Name: transaction_detail; Type: TABLE; Schema: public; Owner: disnovo
--

CREATE TABLE public.transaction_detail (
    transaction_dateil_id integer NOT NULL,
    nickname_owner_transaction character varying(64),
    product_id integer NOT NULL,
    nickname_owner_product character varying(64),
    item_id smallint,
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
1	Loralee	Trunyx	ARMY AND AIR FORCE EXCHANGE SERVICE	Brigid	Grinval	Pharmacist	Meningococcal infect NEC	Occlude aorta NEC	Fluoroscopy of R Temporomand Jt using H Osm Contrast	2022-08-09 00:00:00	t	f
2	Pippy	Ailane	Swabplus Inc.	Peder	Indruch	Payment Adjustment Coordinator	Parox tachycardia NOS	Cde for obstruction NEC	Insertion of Ext Fix into L Maxilla, Open Approach	2022-01-28 00:00:00	f	t
3	Melicent	Vimbo	Sandoz Inc	Lyndsey	Pales	Occupational Therapist	Malig neo main bronchus	Limb shorten-metacar/car	Restrict R Ant Tib Art w Extralum Dev, Perc Endo	2022-06-08 00:00:00	f	f
4	Nikoletta	Mybuzz	Lake Erie Medical & Surgical Supply DBA Quality Care Products LLC	Horatia	Steel	Operator	Acquired night blindness	Micro exam-integumen NEC	Dilate L Subclav Art, Bifurc, w 4+ Intralum Dev, Open	2022-01-29 00:00:00	f	f
5	Tresa	Digitube	Antigen Laboratories, Inc.	Anastasie	Romagnosi	Structural Analysis Engineer	Early onset delivery-del	Gum operation NEC	Revise Autol Sub in L Temporomandib Jt, Perc Endo	2022-05-09 00:00:00	t	t
6	Winnifred	Dabshots	MATERNAL SCIENCE, LLC	Marjory	Candish	Chief Design Engineer	Impair ren funct dis NEC	Dx procedure thorax NEC	Excision of Spinal Meninges, Open Approach, Diagnostic	2022-01-16 00:00:00	f	f
7	Jessey	Zoovu	Kroger Company	Mar	Isenor	Environmental Tech	Mal neo bladder-lateral	Ovarian aspirat biopsy	Excision of Upper Back, External Approach, Diagnostic	2021-09-14 00:00:00	t	f
8	Nicholas	Topdrive	China Ningbo Shangge Cosmetic Technology Corp	Chucho	Leyfield	Computer Systems Analyst IV	Cestode infection NEC	Resrf hip,part-fem head	Replace of R Glenoid Cav with Synth Sub, Perc Endo Approach	2021-08-29 00:00:00	t	t
9	Linnie	Livetube	Topco Associates LLC	Raffaello	Zannuto	Technical Writer	Syphilis of tendon/bursa	Ureteral dx procedur NEC	Revision of Int Fix in R Carpal, Open Approach	2022-05-28 00:00:00	t	f
10	Maddalena	Tagtune	JUBILANT CADISTA PHARMACEUTICALS, INC.	Rogers	Kinde	Human Resources Manager	3rd deg burn toe	Symbleph rep w free grft	Occlusion of Low Art with Extralum Dev, Perc Endo Approach	2021-11-09 00:00:00	f	t
11	Eustacia	DabZ	Baxter Healthcare Corporation	Shelli	Mallabon	VP Product Management	Osteomyelit NOS-forearm	Tot brch extrac w forcep	Insert of Radioact Elem into Retroperitoneum, Perc Approach	2022-07-25 00:00:00	f	f
12	Amerigo	Babbleopia	Sunovion Pharmaceuticals Inc.	Jerri	Dimitresco	Paralegal	Lordosis in oth dis	Unilat lung transplant	Computerized Tomography (CT Scan) of Right Ankle	2021-08-17 00:00:00	t	t
13	Tasia	Feedfire	Arbonne International, LLC	Thomasine	Dowzell	Physical Therapy Assistant	Hypocalcemia	Other bone dx proc NEC	Drainage of Nasal Septum with Drainage Device, Open Approach	2021-11-25 00:00:00	t	f
14	Flss	Kaymbo	Kroger Company	Colene	Kingzeth	Administrative Assistant II	Glaucoma of childhood	Arthrodesis of shoulder	Excision of Anal Sphincter, Percutaneous Approach	2022-04-13 00:00:00	t	f
15	Pru	Cogilith	Bryant Ranch Prepack	Elvyn	Droghan	Desktop Support Technician	Hx sudden cardiac arrest	Cholera vaccination	Extirpation of Matter from R Palatine Bone, Open Approach	2022-02-25 00:00:00	f	f
16	Ransom	Edgeclub	Rebel Distributors Corp	Linnet	Kubicka	Mechanical Systems Engineer	Anom iris & cil body NEC	Exc of accessory spleen	LDR Brachytherapy of Mediastinum using Cesium 137	2021-08-27 00:00:00	t	t
17	Milli	Topicstorm	Valeant Pharmaceuticals North America LLC	Sybilla	Callis	Data Coordiator	Congen CV dis-antepartum	Complete sialoadenectomy	Extirpate matter from Tongue/Palate/Phar Muscle, Perc	2022-06-24 00:00:00	t	t
18	Leena	Zazio	Upsher-Smith Laboratories, Inc.	Temple	Berryann	Account Executive	Malposition NOS-unspec	Eyelid repair NEC	Repair Left Toe Phalanx, Percutaneous Endoscopic Approach	2021-08-17 00:00:00	f	f
19	Thane	Gigaclub	Medimetriks Pharmaceuticals, Inc.	Tally	Loudiane	Compensation Analyst	Drug persist amnestc dis	Typhoid/paratyphoid vacc	Reposition Left Femoral Shaft, Perc Endo Approach	2022-03-29 00:00:00	t	f
20	Gay	Meevee	MAKEUP ART COSMETICS	Michel	Southwell	Design Engineer	31-32 comp wks gestation	Limb lengthen proc NEC	Traction of Left Hand	2022-01-04 00:00:00	t	t
21	Dallas	Izio	Physicians Total Care, Inc.	Hermy	Lemasney	Operator	Polyarthritis NOS-l/leg	Culture-lymph system	Restrict L Ext Jugular Vein w Intralum Dev, Perc Endo	2021-09-28 00:00:00	f	f
22	Abagail	Dabvine	Nelco Laboratories, Inc.	Bradney	Birtles	Web Designer II	Maxillary hyperplasia	Open liver biopsy	Fusion Thor Jt w Nonaut Sub, Post Appr A Col, Open	2022-06-10 00:00:00	f	f
23	Dulciana	Oyoyo	Rebel Distributors Corp	Mellicent	Bradie	Human Resources Manager	Postmeasles otitis media	Music therapy	HDR Brachytherapy of Abd Lymph using Cesium 137	2021-09-11 00:00:00	f	f
24	Mordecai	Brainverse	PD-Rx Pharmaceuticals, Inc.	Idette	Marchment	Programmer Analyst III	Inflam postproc bleb, 1	Plethysmogram	Supplement Anus with Autologous Tissue Substitute, Endo	2022-01-08 00:00:00	t	t
25	Bar	Centimia	CHAIN DRUG MARKETING ASSOCIATION INC	Midge	Peasby	Health Coach III	Budd-chiari syndrome	Culture-op wound	Destruction of Right Ventricle, Perc Endo Approach	2022-06-20 00:00:00	f	t
26	Lennie	Topicstorm	Medac Pharma, Inc	Judd	Heine	Desktop Support Technician	Prolapsed arm-unspec	Orbit exent w bone remov	Revision of Autol Sub in Periph Nrv, Open Approach	2021-12-04 00:00:00	t	f
27	Dorey	Topiclounge	Dolgencorp, Inc. (DOLLAR GENERAL & REXALL)	Sigismond	Ellard	Structural Engineer	Abrasion finger	Excision of wrist NEC	Restrict of R Verteb Vein with Intralum Dev, Open Approach	2021-10-22 00:00:00	t	t
28	Hammad	Skyvu	Jiangxi Sencen Hygienic Products Co., Ltd.	Patrica	Alvares	VP Marketing	Tripl gest-plac/sac und	High-dose infusion IL-2	Beam Radiation of Salivary Glands using Electrons, Intraop	2021-10-06 00:00:00	t	f
29	Waite	Mudo	BJWC	Dick	Basilio	Programmer Analyst IV	Polyuria	Other femoral incision	Reposition L Metacarpocarp Jt with Int Fix, Perc Approach	2021-08-23 00:00:00	f	f
30	Elli	Minyx	Linde Gas Puerto Rico, Inc	Violette	Thom	Senior Cost Accountant	Muscle/ligament dis NOS	External ear biopsy	Fragmentation in Left Fallopian Tube, Endo	2022-01-07 00:00:00	f	t
31	Katee	Oyoba	Cardinal Health	Mabel	Samweyes	Physical Therapy Assistant	Aspergillosis	Toe reattachment	Drainage of Left Trunk Tendon, Open Approach	2022-03-28 00:00:00	t	f
32	Aurelea	Ailane	Ionx Holdings d/b/a HelloLife Inc.	Lauren	Zavattero	Programmer IV	Conjunctiva disorder NOS	Consultation NOS	Introduction of Local Anesthetic into Nose, Perc Approach	2021-09-23 00:00:00	t	f
33	Nanette	Riffpath	SUPERVALU INC.	Jorrie	Kundt	Financial Advisor	Traffic acc NOS-driver	Endosc destruc lung les	Supplement L Pulm Art with Autol Sub, Perc Approach	2021-10-16 00:00:00	f	t
34	Tiffy	Jayo	Heel Inc	Sharai	Barwis	Engineer III	Abn serum enzy level NEC	Myringotomy w intubation	Supplement L Up Arm Muscle w Nonaut Sub, Perc Endo	2022-04-02 00:00:00	f	f
35	Dode	Flashset	Physicians Total Care, Inc.	Crysta	Sendley	Geologist III	Colstmy/enteros comp NEC	Other suprapu cystostomy	Extirpation of Matter from Left Ear Skin, External Approach	2022-01-13 00:00:00	f	t
36	Tine	Fadeo	NATURE REPUBLIC CO., LTD.	Ibby	Janman	Environmental Tech	Oth con d/t chrm anm NEC	Non-coronary IFVA	Plain Radiography of Bi Ext Carotid using H Osm Contrast	2022-04-08 00:00:00	t	f
37	Dierdre	Chatterpoint	Personal Care Products	Karita	Bedburrow	Chief Design Engineer	Conjunctival xerosis	Repair of rectum NEC	Supplement R Ant Tib Art with Autol Sub, Perc Approach	2022-01-20 00:00:00	t	f
38	Duffie	Babbleset	Professional Disposables International, Inc.	Brooke	LLelweln	Senior Quality Engineer	Idiopathic cysts	Anal anastomosis	Restriction of Gastric Artery, Percutaneous Approach	2022-06-27 00:00:00	f	f
39	Standford	Voonte	Omorovicza Kozmetikai Kft.	Torrie	Iacovides	Occupational Therapist	TB of organ NEC-oth test	Hemorrhoid ligation	Excision of Cecum, Open Approach, Diagnostic	2022-01-01 00:00:00	f	f
40	Maurise	Zooveo	TOPCO ASSOCIATES, LLC	Trudey	Patriskson	Electrical Engineer	DMII ophth uncntrld	Play psychotherapy	Introduction of Analg/Hypnot/Sedat into Up GI, Perc Approach	2021-12-06 00:00:00	f	t
41	Stacia	Kwinu	NSE Products, Inc.	Vilhelmina	McCall	Sales Representative	Smell and taste problem	Remov fallop tube prosth	Restrict of Inf Mesent Vein with Intralum Dev, Open Approach	2021-10-01 00:00:00	t	f
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
1	Averyl	rwallice0	Low Beardtongue	25	Philbert	17	Templeton	2022-05-16 00:00:00	2022-06-07	2021	8	12	28	9	77990.58	6658.56	93547.23	37969.52	27860.06	23	8809.52	76893.26	19362.54	49162b4c-8df9-481a-9078-54df113b0a64	Breast inf preg NEC-unsp	Lid retraction or lag	Squam cell ca lid/canth	Lymph structure op NEC	Cholinergic urticaria	Ring	2022-02-24 00:00:00	f	t
2	Dukey	kmillership1	Bertero's Tufted Airplant	26	Jacklin	34	Elroy	2021-11-18 00:00:00	2022-07-30	2022	6	50	2	11	63978.71	61542.47	5786.54	95657.2	93351.09	5	49717.99	33247.05	22506.72	89896671-6977-4844-8523-093831b9db6e	Stiff-man syndrome	Unstable lie-antepartum	Schizophren dis-chronic	Rhinoscopy	Fx low end femur NOS-opn	Kendal	2021-12-10 00:00:00	f	f
3	Maurizio	bvannah2	Bush-violet	31	Worden	6	Giusto	2021-12-29 00:00:00	2022-02-01	2022	8	1	11	3	65112.61	29479.52	80308.09	89409.13	73692.03	41	18378.29	43817.9	92644.09	bdddafb1-7795-4f7d-bb3d-b6ad5c7139ce	Fx distal ulna-closed	Antidepress abuse-remiss	Trigem autonmc cephl NEC	Rectocele repair	Opn skull/oth fx-concuss	Bradney	2021-10-26 00:00:00	t	t
4	Yetta	jarundel3	Mexican Gumweed	21	Mildrid	38	Talbot	2022-06-13 00:00:00	2022-06-27	2022	7	26	16	21	96113.52	10911.37	21716.65	85070.0	24003.21	28	78225.6	63464.51	53623.83	a9da7793-7754-4de7-bd3e-e1b8ec22abc0	Neutropenia NEC	Ill-defined hrt dis NEC	Heat syncope	Unilat simple mastectomy	Water aerobics/exercise	Junia	2021-11-03 00:00:00	f	f
5	Thorndike	cropcke4	Shameplant	29	Rhetta	6	Foss	2022-01-21 00:00:00	2021-11-29	2021	6	50	16	17	92352.97	19192.67	71005.17	69897.73	33739.78	18	14081.99	57410.67	35548.33	a76e2caa-94f9-48b4-b654-feca641238f9	Alpha thalassemia	Fx mandible body NEC-cl	Bursitis NEC	Toxicology-lower GI	Oval window fistula	Clarke	2021-10-17 00:00:00	t	f
\.


--
-- Data for Name: transaction_detail; Type: TABLE DATA; Schema: public; Owner: disnovo
--

COPY public.transaction_detail (transaction_dateil_id, nickname_owner_transaction, product_id, nickname_owner_product, item_id, price, quantity, transactiondetail_discount, transactiondetail_discountpercentage, transactiondetail_charge, transactiondetail_chargepercentage, transactiondetail_taxpercentage, transactiondetail_tax, transactiondetail_balance, description, commentary, state, erased) FROM stdin;
\.


--
-- Data for Name: transaction_type; Type: TABLE DATA; Schema: public; Owner: disnovo
--

COPY public.transaction_type (transaction_type_id, nickname_owner, transaction_type_name, transaction_type_title, is_sub_type, description, external_id, nickname_creator, creation_date) FROM stdin;
1	Amalle	zschimke0	Macoun's Cinquefoil	t	Unspecified instrumental delivery	98c9b33d-3ca4-4417-b849-7eeb8e7fe94c	Zackariah	2021-11-12 00:00:00
2	Tobie	jcastelyn1	Glenwood Springs Rockcress	t	Root canal therapy with irrigation	92963f71-5db8-4272-94d3-3dc0eea836c5	Jennette	2022-02-11 00:00:00
3	Letti	aburcombe2	Wasatch Beardtongue	f	Elevation of skull fracture fragments	e27819b1-1963-4df6-a74c-6db0d6e22077	Alvy	2022-06-24 00:00:00
4	Brok	blodemann3	Pubescent Western Needlegrass	f	Transverse rectus abdominis myocutaneous (TRAM) flap, free	73c95cb2-b998-4a7d-8821-2e065b7a6361	Berkeley	2021-12-12 00:00:00
5	Boothe	lharvey4	Rough Bugleweed	f	Other repair of urinary stress incontinence	64331367-3542-4e6d-901f-6ab30b3e9231	Lauritz	2021-10-04 00:00:00
6	Kerstin	dslipper5	Palmer's Phacelia	f	Microscopic examination of specimen from other site, other microscopic examination	388882bf-e041-4a6d-8e80-7199ce2a6832	Danna	2022-01-10 00:00:00
7	Bertrand	spaggitt6	Hybrid Oak	t	Artificial insemination	6c15303c-8886-4c29-bb9c-a6c5361c1b91	Shara	2021-11-07 00:00:00
8	Amandi	rferon7	Clustered Dodder	f	Lower eyelid rhytidectomy	20a8e145-a524-49e6-9dba-dd82eb12cd7c	Riannon	2022-04-08 00:00:00
9	Rudolfo	bfasse8	Japanese Poplar	f	Vacuum extraction with episiotomy	b59226c8-fc72-4e49-b50e-5f6da5ec5b2a	Berne	2022-06-01 00:00:00
10	Shannon	mstarford9	Lurid Fishscale Lichen	t	Injection of therapeutic substance into joint or ligament	38fd815e-c589-4947-b0a8-7b18df1c2cf2	Mike	2021-10-06 00:00:00
11	La verne	dbaudouina	Aleutian Saxifrage	t	Other excision of lung	3b549dd7-bc7a-4820-b2d1-b536f03ecdaf	Dacie	2022-06-10 00:00:00
12	Tori	dcouvertb	Dwarf Snapdragon	f	Revision of cleft palate repair	1509978d-2b31-41d9-af76-62af00822fcd	Dagmar	2021-11-30 00:00:00
14	Stanton	eewend	Shining Bedstraw	f	Aspiration of other soft tissue	cf518dae-8e0f-4f90-99a1-29f39e9c0cf9	Eleonora	2022-03-04 00:00:00
15	Chevy	bholcrofte	Thickleaf Monardella	f	Implantation of total internal biventricular heart replacement system	cd1bcc15-67a7-4341-b68f-067d039b7c48	Bree	2021-08-17 00:00:00
16	Galvan	phehlf	Broadleaf Hawthorn	t	Removal of ventricular shunt	e7e762c5-5b6e-4790-935f-7448e73b8224	Pris	2022-07-22 00:00:00
17	Claire	khinkseng	Cotoneaster	f	Microscopic examination of specimen from female genital tract, parasitology	3cdef778-a02d-4da1-9d98-6804675e67df	Kathi	2022-02-13 00:00:00
18	Luce	fmuckianh	Bear Valley Milkvetch	t	Other operations on thyroid glands	b962da49-e8d5-456d-b9b9-c7f5b8275540	Fraser	2021-10-13 00:00:00
19	Thacher	gonolani	Steeplebush	f	Other arthrotomy, hand and finger	f8a8fb2f-6bf0-495f-8499-3f17a72c5956	Gamaliel	2021-12-16 00:00:00
20	Abbe	sfulhamj	Common Ragwort	f	Other muscle transposition	2cc3c320-df70-42b5-94db-0be1f9184203	Stanislas	2021-08-29 00:00:00
21	Winn	alockiek	Paraguayan Windmill Grass	t	Implantation of electromagnetic hearing device	12b63a5d-1225-4618-a35b-3ada82e0f552	Anet	2022-05-20 00:00:00
22	Kaia	achannerl	Bullatina Lichen	f	Transpleural thoracoscopy	19133af1-123b-4730-b5a6-f5298d99947e	Ange	2022-03-27 00:00:00
23	Hastie	jlyfieldm	Hoja Menuda	t	Lower leg or ankle reattachment	e541c755-9464-40bb-a98e-1aef2e24a4b3	Joete	2022-05-13 00:00:00
25	Cristen	zraggitto	Sedge	f	Biopsy of lip	6ed5f350-02e5-468b-bda1-491141c1b457	Zorine	2022-07-07 00:00:00
26	Pammy	sdrynanp	Sagebrush Fleabane	t	Resection of vessel with replacement, abdominal arteries	fb8710df-4669-4cc0-bc2d-995c2277b7d9	Sonnie	2021-10-16 00:00:00
27	Mamie	rmckerleyq	Wallrue	f	Laparoscopic lysis of peritoneal adhesions	e1d60e4b-46cf-41f3-9d17-f71586e69c25	Ruddie	2021-08-22 00:00:00
28	Leigha	bfurmager	Huachuca Xanthoparmelia Lichen	f	Other high forceps operation	095c8b70-603d-4226-8434-8c46e4250b28	Blair	2021-11-23 00:00:00
29	Cordy	vcastelains	Desert Moonpod	t	Excision or destruction of other lesion or tissue of heart, open approach	af09a6d0-baab-4d5f-8b8a-9defb82aff8e	Vernon	2022-01-22 00:00:00
30	Jennica	ipembert	Fayodia Lichen	f	Repair of hypospadias or epispadias	0386b1e8-f3dd-40fb-ad79-4ac1b2865697	Izaak	2021-08-28 00:00:00
31	Alford	cdurransu	Florida Orangegrass	f	Other genitourinary instillation	1d31126a-c8f4-49c8-b84e-5ff357688b5a	Carver	2022-08-07 00:00:00
32	Elizabeth	atimmesv	New Brunswick Blackberry	t	Replacement of electronic bladder stimulator	f9b98580-7dba-438f-8875-ce917ef47346	Arte	2021-11-12 00:00:00
33	Jordana	badlardw	Cypress Peperomia	f	Sequestrectomy of facial bone	1b5c4f6b-a34c-489d-8457-426b94b712b8	Bryce	2021-10-14 00:00:00
34	Bryn	mwhitefootx	Wild Sweetwilliam	f	Injection of larynx	9a5c5088-16d3-4bb3-9cb0-17e1f1e4ab76	Michal	2021-10-05 00:00:00
36	Ulric	kmellhuishz	Slenderleaf False Foxglove	f	Vaccination against pertussis	f7f5b2c9-462b-4a4f-ab08-7ca871290aee	Kris	2022-01-23 00:00:00
37	Abbie	vdewilde10	Resin Sarea Lichen	t	Exploration of thymus field	f5101e54-5f96-4204-9052-7a9f096440e8	Verene	2022-07-11 00:00:00
38	Jacob	lspindler11	Charming Centaury	f	Microscopic examination of specimen from skin and other integument, culture	2cf47176-5088-45b2-b92f-1b706c1c2fe9	Levey	2022-05-30 00:00:00
39	Heida	cgauthorpp12	Guadalupe Cryptantha	t	Division of joint capsule, ligament, or cartilage, hip	2d5e2c13-141f-479b-83a2-6be466af9ed1	Candace	2022-01-23 00:00:00
40	Luelle	pbogies13	Psorotichia Lichen	t	Closed [endoscopic] biopsy of bronchus	3239f5c7-5adf-46aa-94e7-6fd2ff615dfa	Pietro	2021-08-15 00:00:00
41	Mychal	galeksankin14	Harp Onefruit	f	Local excision of lesion or tissue of bone, scapula, clavicle, and thorax [ribs and sternum]	7145b19d-7da6-4257-99d9-36c5826faae9	Gates	2022-07-24 00:00:00
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
-- Name: transaction_detail transaction_detail_item_id_key; Type: CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction_detail
    ADD CONSTRAINT transaction_detail_item_id_key UNIQUE (item_id);


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
-- Name: transaction fk_ci; Type: FK CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT fk_ci FOREIGN KEY (contact_id) REFERENCES public.contacts(contact_id);


--
-- Name: transaction_detail fk_pi; Type: FK CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction_detail
    ADD CONSTRAINT fk_pi FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: products fk_pti; Type: FK CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_pti FOREIGN KEY (product_type_id) REFERENCES public.product_type(product_type_id);


--
-- Name: transaction fk_tti; Type: FK CONSTRAINT; Schema: public; Owner: disnovo
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT fk_tti FOREIGN KEY (transaction_type_id) REFERENCES public.transaction_type(transaction_type_id);


--
-- PostgreSQL database dump complete
--

