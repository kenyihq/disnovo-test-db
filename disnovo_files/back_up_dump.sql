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

--
-- Name: sp_change_state(integer); Type: PROCEDURE; Schema: public; Owner: disnovo
--

CREATE PROCEDURE public.sp_change_state(id integer)
    LANGUAGE plpgsql
    AS $$BEGIN

    IF (SELECT state FROM transaction WHERE transaction_id = id) THEN
        UPDATE transaction SET erased = true, state = false
        WHERE transaction_id = id;

    ELSE

    UPDATE transaction SET erased = false, state = true
    WHERE transaction_id = id;

    END IF;
    COMMIT;
end;
$$;


ALTER PROCEDURE public.sp_change_state(id integer) OWNER TO disnovo;

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
-- Name: resume_total; Type: VIEW; Schema: public; Owner: disnovo
--

CREATE VIEW public.resume_total AS
 SELECT c.trade_name AS nombre,
    count(tt.transaction_type_id) AS cantidad,
    t.transaction_total AS total
   FROM public.contacts c,
    public.transaction t,
    public.transaction_type tt
  WHERE ((c.contact_id = t.contact_id) AND (t.transaction_type_id = tt.transaction_type_id))
  GROUP BY c.trade_name, t.transaction_total;


ALTER TABLE public.resume_total OWNER TO disnovo;

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
1	Amity	Mace Ground	Bread - Roll, Italian	8c387426-2f15-49f5-afe2-50dcc71f184f	Shea	2022-03-12 00:00:00	f	t	t
2	Dalenna	Pie Shells 10	Pastry - French Mini Assorted	4a5037d2-450f-489c-8da7-e1d0dc80bd94	Cam	2022-02-19 00:00:00	f	f	f
3	Graig	Artichokes - Knobless, White	Soup - Verve - Chipotle Chicken	a13413f1-0ca9-4249-a1f5-b92b7985baa8	Parke	2021-11-06 00:00:00	t	f	t
4	Cairistiona	Island Oasis - Sweet And Sour Mix	Pork - Ham Hocks - Smoked	f9f47768-dac8-4cbb-bc09-92410994d496	Taffy	2021-08-17 00:00:00	f	t	f
5	Levon	Tomatoes	Sea Bass - Fillets	59406a48-4350-43c2-85a6-d8c5c5019d33	Cilka	2022-03-31 00:00:00	f	t	t
6	Albert	Container - Foam Dixie 12 Oz	Pork - Backfat	586a102b-dfbd-4019-9ef4-f37c0a1e3995	Ammamaria	2022-02-03 00:00:00	t	f	f
7	Gwynne	Shrimp - Tiger 21/25	Goldschalger	808c2181-33ee-4297-ba3e-87b9c068ca07	Alonso	2022-06-21 00:00:00	t	f	t
8	Ammamaria	Tomato - Plum With Basil	Remy Red	ae2fdeab-8f65-4741-8281-4baa06176756	Granthem	2022-02-02 00:00:00	f	f	f
9	Pippa	Cheese - Le Cru Du Clocher	Beef - Ox Tongue	a3c1106e-09ec-4f13-84b9-b5a30e5b15c1	Brunhilde	2022-05-25 00:00:00	t	f	f
10	Ronica	Honey - Comb	Cheese - Mascarpone	2db0fc37-116a-447c-8b7b-8667e6fe5e41	Toni	2022-01-21 00:00:00	t	t	t
11	Lian	Lamb Leg - Bone - In Nz	Shrimp - Black Tiger 26/30	cbf81bb1-177a-45bf-a2e0-f1e4b2838e1e	Terry	2022-07-21 00:00:00	t	t	f
12	Devi	Quail - Jumbo	Bread - Roll, Calabrese	62f895c2-85db-4ee1-92a6-7ece0170c161	Juana	2022-01-04 00:00:00	t	f	f
13	Stanley	Island Oasis - Peach Daiquiri	Island Oasis - Mango Daiquiri	d03b0fb2-c422-4f82-96d9-a2e36737d062	Sawyere	2022-05-13 00:00:00	t	t	t
14	Frasco	Wine - Sake	Straw - Regular	7811aea1-3e75-4feb-b867-3f71649076a7	Rosalia	2022-03-11 00:00:00	f	f	f
15	Corty	Container - Hngd Cll Blk 7x7x3	Neckerchief Blck	47354d81-4215-4f13-8cf8-8c1101b148fc	Bondy	2022-04-24 00:00:00	t	t	t
16	Lisa	Lettuce - Romaine, Heart	Cheese - St. Paulin	d266cf65-a2be-4c74-96a9-26d6bef19016	Larry	2022-01-12 00:00:00	f	f	t
17	Skell	Nantucket - Pomegranate Pear	Appetizer - Shrimp Puff	132f1dd3-2107-4774-b933-e4b7c5e2e45a	Mair	2022-02-23 00:00:00	f	t	t
18	Sandro	Coriander - Ground	Bag - Regular Kraft 20 Lb	d33b4962-792a-47f3-844f-a2f60212d45f	Temple	2021-09-27 00:00:00	t	f	t
19	Glyn	Wine - Alsace Riesling Reserve	Bread Ww Cluster	b9480175-65ab-435e-9dfc-2f2f5f022fba	Roi	2021-09-13 00:00:00	t	f	t
20	Katya	Juice - Grape, White	Broom - Corn	5dcf6212-c75d-4b9d-b7a2-5e6501c3e3a1	Sullivan	2022-02-14 00:00:00	t	t	t
21	Carmencita	Gelatine Leaves - Bulk	Gherkin - Sour	10a49f26-079b-4b57-a3b5-4426047e69eb	Cecilio	2022-07-01 00:00:00	f	f	f
22	Ignazio	Chicken - Ground	Nut - Walnut, Pieces	e240e38e-c3b9-443e-8849-dd25a702b7dc	Saxe	2022-07-09 00:00:00	t	f	f
23	Mabel	Pastry - Apple Muffins - Mini	Noodles - Cellophane, Thin	e48bf531-20e4-4772-a4a5-194756ddd348	Demetri	2021-09-07 00:00:00	t	f	f
24	Karoline	Shrimp - 100 / 200 Cold Water	Container - Clear 16 Oz	cefc435d-6bf8-4a4e-9500-ae71c9fff959	Collin	2021-12-15 00:00:00	f	f	t
25	Rooney	Cheese - Mascarpone	Beer - Paulaner Hefeweisse	abd1715c-bb58-415e-b6be-60f10d88aa4a	Ram	2022-06-14 00:00:00	t	f	t
26	Gauthier	Longos - Grilled Chicken With	Sole - Dover, Whole, Fresh	670b9b82-db4d-4785-a567-a1b04fd537ab	Natale	2022-02-06 00:00:00	t	t	t
27	Kippy	Wine - White, Gewurtzraminer	Pepperoni Slices	27480838-29b1-4523-b39c-f6de8c1003d9	Vidovic	2021-08-20 00:00:00	t	t	t
28	Gasparo	Crackers - Melba Toast	Lid - High Heat, Super Clear	736590a9-af4f-47ef-9d91-957302e656d3	Pattie	2022-03-31 00:00:00	t	t	f
29	Jocelyn	Pepper - Red, Finger Hot	Instant Coffee	07ca8fbb-95fe-4567-84c7-e0d8f37b2068	Curr	2021-10-19 00:00:00	t	t	t
30	Gwendolin	Mushrooms - Black, Dried	Cheese - Mozzarella, Shredded	d55da2cc-293f-460e-a486-0e07b2c90b47	Berky	2021-12-12 00:00:00	f	t	f
31	Patty	Salt - Sea	Pepper - Gypsy Pepper	e286c377-e302-43b8-9cec-2eb2760f82c5	Egor	2022-04-19 00:00:00	f	f	f
32	Evey	Mace Ground	Butter - Pod	868f1908-bbbe-45dc-a2f9-3ec14c313ee9	Didi	2022-02-06 00:00:00	t	f	t
33	Farly	Bagel - Ched Chs Presliced	Tortillas - Flour, 12	2b0402ba-63f1-4267-8c96-c32a00c306d6	Laurice	2022-05-21 00:00:00	f	f	t
34	Louella	Flour - Corn, Fine	Creme De Cacao Mcguines	9ae0b80a-fd82-4db7-9c5f-a90e6abd68f6	Marin	2021-12-03 00:00:00	f	f	t
35	Sol	Spring Roll Veg Mini	Wine - Chateau Timberlay	a5268791-f9c5-4a03-94e7-048552990f8b	Debee	2022-03-11 00:00:00	t	t	t
36	Annissa	Pasta - Fusili Tri - Coloured	Chicken - White Meat With Tender	ecf6c292-3342-4fdd-92d3-d9c2b7b0fd70	Auguste	2021-08-20 00:00:00	f	t	t
37	Edwina	Eggs - Extra Large	Sobe - Orange Carrot	125d792f-bd7c-4862-a327-5ca0c7f58702	Wolfie	2021-12-01 00:00:00	f	t	f
38	Shane	V8 - Vegetable Cocktail	Sauce - Apple, Unsweetened	fd1e9585-71bb-4b33-a5f4-e4c0656cc976	Jo-ann	2022-07-07 00:00:00	t	f	f
39	Madeline	Sole - Iqf	Nut - Pistachio, Shelled	eef17865-42bb-4d30-a0da-8731ed3ce394	Sara	2022-03-12 00:00:00	t	t	t
40	Mallorie	Yeast Dry - Fleischman	Crackers - Graham	49fb1f99-14e5-405a-8e28-88b38bda4996	Jennilee	2022-01-30 00:00:00	f	f	f
41	Kiele	Broom - Corn	Croissant, Raw - Mini	c7f8404b-3656-4197-b84d-46cd482e6581	Bili	2022-01-18 00:00:00	t	f	t
42	Ruben	Mushroom - Crimini	Lentils - Red, Dry	b382e0c0-93bb-4502-8a59-ce944114d955	Ranice	2021-09-27 00:00:00	f	t	t
43	Cecilla	Wine - Zinfandel Rosenblum	Dawn Professionl Pot And Pan	3002d3d2-96ff-4043-ace1-3671c9f212c2	Lucinda	2022-07-03 00:00:00	f	f	f
44	Megan	Ice Cream Bar - Oreo Cone	Container - Clear 16 Oz	c027124b-2fe2-45c8-9cbb-d3581dea9877	Petronilla	2022-03-20 00:00:00	t	f	t
45	Esra	Halibut - Steaks	Avocado	8d2e3b83-8e2b-4adc-969e-e3d2a222d380	Kirby	2022-05-19 00:00:00	t	f	f
46	Nadiya	Taro Root	Cod - Salted, Boneless	1938980c-8fe6-494e-86e8-2795a99cde7b	Alessandra	2022-03-17 00:00:00	f	t	t
47	Marshal	Liquid Aminios Acid - Braggs	Beer - Sleemans Cream Ale	8bfa200c-212a-4a7d-96f4-7c99d7f20f58	Niles	2022-03-14 00:00:00	f	t	t
48	Alonso	Wine - Bourgogne 2002, La	Cream - 10%	0435e5f5-61bd-4625-bd66-416d576ad977	Michaeline	2021-11-01 00:00:00	t	f	f
49	Claiborn	Beans - Black Bean, Dry	Quail - Jumbo Boneless	811a2e77-98cf-4373-b58b-da3204852347	Tod	2021-11-09 00:00:00	f	f	t
50	Orin	Cheese - Cheddar, Mild	Muffin Batt - Blueberry Passion	4d5aee53-e8e3-4ac1-ada3-82b36af022a0	Callida	2021-11-20 00:00:00	f	t	f
51	Derwin	Nantucket - Orange Mango Cktl	Wine - Barossa Valley Estate	e7f84e07-c89e-4586-9fa1-be9633cc9e00	Hyatt	2022-04-25 00:00:00	f	f	f
52	Whitman	Tea - Herbal Orange Spice	Sherry - Dry	b9aa8197-b09a-42ff-8ae7-644fd2973a42	Mandi	2022-01-25 00:00:00	t	f	t
53	Maryjane	Lid - High Heat, Super Clear	Appetizer - Sausage Rolls	2a1b4e09-e804-4cc2-a092-951bd5098b23	Nannette	2022-03-05 00:00:00	t	t	t
54	Erna	Coffee Cup 12oz 5342cd	Sauce - Mint	a14f26d7-993d-470d-bb90-0a114224523a	Baryram	2021-12-15 00:00:00	t	t	t
55	Gay	Basil - Primerba, Paste	Pasta - Penne Primavera, Single	0b9f5445-5dbf-43f5-9b88-5f39a8d44d68	Genovera	2022-04-06 00:00:00	t	f	f
56	Oberon	Beef Tenderloin Aaa	Scallops - 10/20	30cf891f-96eb-4ccc-969e-69a931a9b722	Domenic	2022-03-13 00:00:00	f	f	f
57	Suzann	Venison - Liver	Arizona - Green Tea	baa87387-a0f9-46dd-b149-2c88ed64a69c	Kirbie	2022-03-03 00:00:00	f	f	f
58	Keslie	Bar Nature Valley	Soup Campbells Turkey Veg.	4f98882d-d3b5-44b7-a399-4fe4d0211cfd	Ina	2021-09-20 00:00:00	f	t	t
59	Wendell	Cheese - Parmigiano Reggiano	Juice - Tomato, 48 Oz	2a6ec7b4-edc8-4afe-9b54-5cc765397bd0	Mort	2021-12-21 00:00:00	t	f	t
60	Basilius	Pork - Ham, Virginia	Sprouts - China Rose	89c299ee-397d-4ae6-a0d4-9f54a36e40a0	Janaye	2022-04-15 00:00:00	t	f	t
61	Archy	Shopper Bag - S - 4	Sauce - Caesar Dressing	9f888a08-911c-4638-ac1d-ebcd8ea841d6	Kaylee	2022-07-01 00:00:00	f	t	f
62	Daveen	Syrup - Pancake	Ecolab Digiclean Mild Fm	c3725804-01ee-4399-8d7e-476c87056fcc	Ozzie	2021-08-24 00:00:00	t	f	f
63	Bronnie	Potatoes - Fingerling 4 Oz	Muffin - Blueberry Individual	e6b9bf25-dcf4-4415-859f-a539a60e579f	Gabey	2022-06-26 00:00:00	f	f	t
64	Kelcey	Cucumber - English	Phyllo Dough	1a67357b-51da-423e-855f-a1a3293d8ddc	Betta	2022-07-25 00:00:00	f	t	t
65	Brandy	Bread - Olive Dinner Roll	Cheese - Mascarpone	5bc3106f-022e-4013-86c3-fe01e19bfb5d	Jessamyn	2022-04-21 00:00:00	t	f	f
66	Herschel	Ham - Cooked Italian	Dry Ice	069c43ac-92b6-4e79-abe1-6532626a6a21	Nancee	2022-02-09 00:00:00	f	t	t
67	Valli	Cherries - Maraschino,jar	Lettuce - Spring Mix	727d0a92-e94b-4b33-813a-6b149e44f778	Laurence	2022-01-13 00:00:00	f	t	f
68	Rachel	Appetizer - Crab And Brie	Chives - Fresh	8cadec19-db11-4e44-91e8-c5a7ecf741ad	Giordano	2022-04-04 00:00:00	t	f	t
69	Cristy	Lemon Pepper	Icecream Bar - Del Monte	917c39e7-689d-431a-95e6-72bcfb38d077	Deny	2021-09-20 00:00:00	f	f	f
70	Kati	Pork Loin Bine - In Frenched	Celery Root	c9212818-8c37-4aa9-83c2-e73bd15bd703	Alison	2021-12-09 00:00:00	f	t	t
71	Aarika	Napkin - Cocktail,beige 2 - Ply	Shortbread - Cookie Crumbs	c73525af-1dd9-4c1d-aa4c-3346df7fdfda	Wilone	2022-07-08 00:00:00	t	f	t
72	Ranna	Oil - Macadamia	Wine - Delicato Merlot	747da2a7-e0df-4bc5-8854-8bec00efee6f	Darb	2021-09-15 00:00:00	t	f	t
73	Reginald	Eggplant - Asian	Soup - Cream Of Broccoli	bb8aa5b3-6bad-4a9c-b31e-89b92960a88a	Stacey	2022-05-04 00:00:00	t	t	t
74	Saidee	Bagel - Ched Chs Presliced	Papadam	6d6436f2-9003-4e52-8c67-033948b57b94	Kari	2021-12-24 00:00:00	t	f	t
75	Tera	Cheese - Ricotta	Turnip - Mini	e6b05a0a-565f-47d5-becf-d43e0ea5127d	Rob	2021-12-14 00:00:00	f	t	f
76	Fredi	Orange - Canned, Mandarin	Truffle Shells - White Chocolate	8eb66f99-cc55-4f62-93bc-5f281bdf3ea2	Caitlin	2022-05-20 00:00:00	t	f	f
77	Odilia	Butter - Unsalted	Bread - Roll, Italian	5a9e194f-70b3-43ee-9e75-b9e019d53436	Kelbee	2021-12-03 00:00:00	t	t	t
78	Paulette	Dill - Primerba, Paste	Ice Cream Bar - Hagen Daz	c581c409-1314-40a6-a41b-35983f80050d	Kristyn	2022-08-06 00:00:00	f	f	f
79	Nata	Pork - Bacon Cooked Slcd	Island Oasis - Cappucino Mix	6b874be8-2d0d-4a44-bed7-300710a5919a	Erin	2021-11-23 00:00:00	f	f	f
80	Gilberto	Eggplant - Baby	Wine - Fume Blanc Fetzer	08592172-608f-4f8f-b73d-9e40a098a72c	Karoly	2021-10-22 00:00:00	t	t	f
81	Ruby	Onion Powder	Shrimp - 150 - 250	084ac115-4c67-484c-9222-7b9a9ad00a0e	Darby	2021-10-01 00:00:00	t	t	t
82	Granthem	Squash - Butternut	Sugar - Monocystal / Rock	7007d653-446b-4c96-8628-b3e8352a5d2b	Zita	2022-04-19 00:00:00	f	f	t
83	Alejoa	Otomegusa Dashi Konbu	Milk - Skim	b720cd82-e5f2-4d1d-9a5a-44f56a548a01	Domeniga	2022-07-11 00:00:00	f	f	f
84	Annetta	Sherbet - Raspberry	Flavouring - Orange	2313cf33-a0bb-42ed-b83d-a33fa9491c1b	Johnathon	2022-05-03 00:00:00	f	t	t
85	Marcos	Cup Translucent 9 Oz	Pork - Loin, Boneless	2239d68f-f570-48e3-b95f-f5ff6d2b7264	Angelo	2021-12-06 00:00:00	f	f	f
86	Yoshiko	Lemonade - Island Tea, 591 Ml	Bagel - Everything	81311102-2d3e-4bfc-9cfe-832c193fbe42	Selinda	2022-02-18 00:00:00	f	f	t
87	Jeni	V8 - Berry Blend	Flax Seed	664e5990-2969-4fd0-a0ba-381ea76160d5	Cyndia	2022-05-20 00:00:00	t	t	t
88	Roma	Cheese - Brie	Bread Fig And Almond	8d4932e0-ec21-4514-89bb-56ed1f15ad6e	Felecia	2022-02-08 00:00:00	t	t	f
89	Cahra	Asparagus - Mexican	Coffee - Dark Roast	8fb2189f-f5d4-441c-bee9-3013ad93c1c8	Franciskus	2022-01-04 00:00:00	f	t	f
90	Tannie	Pasta - Spaghetti, Dry	Compound - Raspberry	6b53fdb9-0736-4e96-9b98-f3d15754e527	Brittni	2022-01-31 00:00:00	f	f	t
91	Titus	Beef - Montreal Smoked Brisket	Pasta - Ravioli	5e0b2734-0e96-4dd4-9041-894926bd1add	Hamlen	2021-11-15 00:00:00	f	t	t
92	Justinn	Oil - Food, Lacquer Spray	Poppy Seed	18d6c370-13f0-4d77-87a3-a55ac58f5218	Minny	2022-03-03 00:00:00	t	t	f
93	Jacquelin	Salmon - Atlantic, No Skin	Glass Clear 8 Oz	6e5e517d-8f2e-438a-bab1-caf86c498023	Alister	2021-10-17 00:00:00	f	f	t
94	Kevon	Wine - Cava Aria Estate Brut	Sauce - Soya, Light	a934b66e-aacd-43df-9a2a-4ada82d757f6	Thomas	2022-02-26 00:00:00	f	t	f
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: disnovo
--

COPY public.products (product_id, nickname_owner, product_name, product_title, description, observation, stock_min, stock_max, price, product_type_id, nickname_owner_type, nickname_creator, creation_date, state, erased) FROM stdin;
1	Maris	Lotus Root	Rootbeer	Ear anom NOS/impair hear	Male infertility NOS	89	940	61883.17	89	Theo	Rebeca	2022-05-29 00:00:00	f	f
2	Weidar	Nut - Chestnuts, Whole	Nantucket Pine Orangebanana	Cryptophthalmos	Mal neo mediastinum NOS	74	979	71331.75	94	Dallas	Konstantine	2021-11-17 00:00:00	t	f
3	Hendrika	Beer - Guiness	Red Currants	Org or tissue donor NEC	Fx up femur epiphy-clos	85	445	1930.88	66	Gaylene	Ardine	2022-05-04 00:00:00	t	t
4	Nickola	Ecolab Crystal Fusion	Glucose	Foundling health care	Abn cervix NEC preg-unsp	24	218	4006.71	57	Renae	Prentiss	2022-05-24 00:00:00	f	f
5	Ludovika	Wine - George Duboeuf Rose	Tortillas - Flour, 12	TB skin/subcut-micro dx	Altered mental status	63	547	69576.52	42	Herbert	Odille	2021-09-19 00:00:00	t	t
6	Selena	Rabbit - Frozen	Veal - Kidney	Aftrcare traum fx up arm	Amputat arm, bilat-compl	27	454	30417.63	80	Hendrik	Maire	2021-09-01 00:00:00	f	t
7	Fran	Oil - Margarine	Water - Spring 1.5lit	Oth multiple sb-nonhosp	Ath ext ntv art ulcrtion	57	370	85454.0	4	Brinn	Shanda	2022-03-14 00:00:00	t	t
8	Glori	Coffee - Dark Roast	Appetizer - Escargot Puff	Mal neo breast low-inner	Letterer-siwe dis spleen	11	523	25472.14	73	Moina	Laverne	2021-08-12 00:00:00	f	f
9	Aldo	Sea Bass - Whole	Wine - Gewurztraminer Pierre	Reticulosarcoma abdom	Oth viral dis-postpartum	33	241	91960.5	26	Jeralee	Martie	2021-12-11 00:00:00	f	f
10	Ilysa	Couscous	Beef - Ground, Extra Lean, Fresh	TB periph lymph-micro dx	Hodgkins paragran pelvic	37	590	43607.11	30	Cazzie	Tamara	2022-04-15 00:00:00	t	f
11	Irving	Cheese - Wine	Haggis	Breast inf NOS-del w p/p	NB intravn hem,grade iii	84	538	90843.84	34	Deena	Franky	2021-12-14 00:00:00	t	t
12	Hammad	Soup - Campbells	Versatainer Nc - 9388	Basal cell ca skin ear	Chromosome anomaly NOS	4	685	16697.25	77	Margarethe	Ange	2022-04-09 00:00:00	t	f
13	Paul	Garam Masala Powder	Salmon - Whole, 4 - 6 Pounds	Scrn mal neo-small intes	Pois-ganglion block agt	35	160	88215.11	30	Roseline	Warren	2021-12-23 00:00:00	t	f
14	Nolly	Pear - Packum	Orange - Tangerine	Acariasis NEC	Protrusio acetabuli NOS	95	617	68739.48	5	Clara	Jacob	2022-04-10 00:00:00	t	t
15	Federico	Soup - Campbells, Classic Chix	Tray - Foam, Square 4 - S	Oth abn fet disprop-unsp	Central cord synd/c1-c4	16	922	8230.75	32	Uriah	Gibb	2021-12-05 00:00:00	t	f
16	Ranna	Duck - Fat	Flour - Strong	Borderline personality	Attem abort w hemorrhage	72	901	92432.16	5	Cesar	Flora	2021-11-22 00:00:00	t	f
17	Bennett	Browning Caramel Glace	Salt And Pepper Mix - Black	Opn skull/oth fx-concuss	Cervical agenesis	37	818	57802.46	19	Jakie	Kaitlynn	2021-12-21 00:00:00	t	f
18	Jenda	Extract - Lemon	Peppercorns - Green	Infertil-cervical orig	Malig carcinoid stomach	55	929	14805.38	1	Jason	Stacey	2022-03-23 00:00:00	t	t
19	Georgie	Gooseberry	Pails With Lids	Disorder of pinna NOS	Intest helminthiasis NOS	81	747	13078.77	5	Caitrin	Maxy	2022-05-03 00:00:00	f	f
20	Lisle	Asparagus - Frozen	Vinegar - Raspberry	Ventral hernia NOS	Bone infect NEC-mult	83	740	8351.96	3	Mead	Valaree	2022-02-19 00:00:00	f	f
21	Lem	Cheese - Mix	Cheese - Mix	Peritonitis in infec dis	Gram-neg septicemia NOS	84	241	69938.47	37	Tan	Betti	2022-01-26 00:00:00	t	t
22	Marlena	Sprouts - Pea	Soup - Campbells, Beef Barley	Mv-oth veh coll-driver	Volvulus of intestine	69	170	39421.37	20	Germana	Vanni	2021-10-06 00:00:00	t	f
23	Buiron	Soup - Beef, Base Mix	Silicone Parch. 16.3x24.3	Oth spf leuk w remsion	Hodg lymph deplet axilla	88	131	81001.38	38	Cherida	Gilburt	2022-06-19 00:00:00	t	t
24	Dwayne	Cup - 3.5oz, Foam	Longos - Chicken Wings	Opn skl base fx-mod coma	Deliver-single liveborn	36	790	2437.8	79	Malvina	Cornie	2022-06-22 00:00:00	t	f
25	Gregoire	Sugar - Palm	Sauce - Hp	Boat submers-pers NOS	Miliary TB NOS-exam unkn	73	347	84459.58	70	Fabe	Callie	2021-11-29 00:00:00	f	t
26	Binky	Pork - Liver	Cheese - Bakers Cream Cheese	Ben hy ht/kd I-IV w/o hf	Hx of schizophrenia	71	531	97731.17	49	Bennett	Herman	2021-08-28 00:00:00	f	t
27	David	Sun - Dried Tomatoes	Soho Lychee Liqueur	TB of adrenal-micro dx	Neonatal conjunctivitis	75	700	40831.75	31	Leshia	Deck	2022-01-06 00:00:00	t	t
28	Tamarah	Potatoes - Yukon Gold 5 Oz	Bread - White Epi Baguette	Adenovirus infect NOS	Land maintain/cnstrt NEC	29	225	7728.36	12	Brandice	Clarabelle	2021-08-24 00:00:00	t	f
29	Windham	Flavouring - Rum	Jam - Marmalade, Orange	Reason for consult NEC	Primary CNS lymph pelvic	48	246	44626.75	58	Pamela	Jennette	2022-04-28 00:00:00	f	f
30	Cos	Crush - Grape, 355 Ml	Jolt Cola	Sbac lym leuk w rmsion	Open wound vagina-compl	6	342	50425.68	86	Regan	Dimitri	2022-03-23 00:00:00	f	t
31	Jessey	Creamers - 10%	Mix - Cappucino Cocktail	Integument anomaly NOS	Mal neo pancreas head	39	882	75591.21	52	Geoff	Bent	2021-09-05 00:00:00	f	t
32	Herrick	Paper Towel Touchless	Truffle Cups Green	Breast engorge-del w p/p	Ob air embol-deliv w p/p	52	439	10589.69	36	Giana	Zonnya	2022-07-24 00:00:00	f	f
33	Federica	Tomatoes Tear Drop	Cheese - Mozzarella	Moderate impair-both eye	Femoral epiphysiolysis	92	363	8336.4	46	Virgilio	Magdaia	2022-07-19 00:00:00	f	t
34	La verne	Bread - Italian Roll With Herbs	Steampan - Half Size Shallow	High head at term-deliv	Behav insomnia-childhood	9	507	66374.84	63	Cece	Lorin	2022-07-21 00:00:00	t	f
35	Devlen	Pear - Prickly	Cheese - Cheddar With Claret	Pyogen arthritis NEC	Fam hx-bladder malig	48	964	39600.68	82	Bryn	Zebedee	2021-11-13 00:00:00	t	f
36	Reynolds	Pail - 4l White, With Handle	Rolled Oats	Barrett's esophagus	RR acc NOS-person NOS	9	258	42899.16	38	Nicolette	Codi	2022-03-22 00:00:00	f	f
37	Rickey	Garbage Bags - Clear	Beans - Black Bean, Canned	Bipolar disorder NOS	Artif open status NOS	79	556	86293.23	16	Thebault	Donaugh	2021-11-19 00:00:00	t	t
38	Bethany	Lettuce - Curly Endive	Coriander - Ground	Preg w hx-trophoblas dis	Chronic bronchitis NEC	10	856	34207.35	2	Jennica	Addy	2021-10-06 00:00:00	t	t
39	Evered	Daikon Radish	Beans - Fava, Canned	Liver hematoma/contusion	Loss labyrn react unilat	57	662	68420.34	61	Gardie	Ashbey	2022-04-09 00:00:00	f	t
40	Darin	Blouse / Shirt / Sweater	Flour - Corn, Fine	Sbac lym leu wo ach rmsn	Pseudomonas enteritis	9	128	84570.72	90	Conney	Filberto	2022-01-14 00:00:00	t	f
41	Gus	Pepper - Black, Whole	Dooleys Toffee	Cl skul/oth fx-deep coma	Flccd hmiplga unspf side	10	907	66520.06	12	Anthe	Kelsey	2021-12-14 00:00:00	t	t
42	Towny	Bread Cranberry Foccacia	Mussels - Frozen	Opn wnd genital NEC-comp	Sec DM neuro nt st uncn	77	311	38709.94	69	Lynsey	Davy	2022-06-04 00:00:00	f	f
43	Dorothea	Cocoa Powder - Natural	Browning Caramel Glace	Old myocardial infarct	Echinococc multiloc NOS	32	225	18033.26	83	Matti	Sammy	2021-09-22 00:00:00	f	f
44	Tanya	Onions - Red Pearl	Cookies - Englishbay Wht	Cicatricial entropion	Non-abo incomp/delay HTR	71	896	21358.66	31	Gard	Lise	2021-09-15 00:00:00	f	t
45	Maud	Flour - Strong Pizza	Chef Hat 25cm	Spcfd anom jaw cranl bse	Acute kidney failure NEC	50	503	18310.94	89	Annabel	Vincenz	2022-06-02 00:00:00	f	t
46	Jorry	Cookies Oatmeal Raisin	Haggis	Watercraft explos-crew	Tox eff berry/plant NEC	84	362	10983.62	51	Gradeigh	Vivian	2022-01-18 00:00:00	t	t
47	Merrill	Soup - Campbells Tomato Ravioli	Banana - Leaves	Narcolepsy w/o cataplexy	Trochanteric fx NOS-clos	98	588	42239.54	18	Janos	Donnie	2022-02-19 00:00:00	f	t
48	Liz	Flour Pastry Super Fine	Quail - Eggs, Fresh	Contract pelv NOS-deliv	Uterine inertia NEC-unsp	83	421	81076.83	71	Pacorro	Bondie	2022-04-17 00:00:00	t	t
49	Wilfrid	Soho Lychee Liqueur	Seedlings - Mix, Organic	Varicella complicat NEC	Late effect CV dis NOS	22	668	37528.82	67	Augustine	Wendie	2021-09-12 00:00:00	t	f
50	Laurel	Carrots - Purple, Organic	Soup Campbells Mexicali Tortilla	Acute nephritis NEC	Adv eff enzymes NEC	71	160	5273.96	64	Chloette	Elyn	2022-04-22 00:00:00	t	t
51	Michel	Sweet Pea Sprouts	Wine - Ruffino Chianti Classico	Congenital eyelid deform	Erythem nodos tb-no exam	50	119	60927.81	44	Thaxter	Talbert	2022-04-03 00:00:00	t	f
52	Farrell	Lamb - Shanks	Cookie - Dough Variety	Cl skull vlt fx-brf coma	Sprain cruciate lig knee	71	207	48500.7	14	Winston	Vidovic	2022-07-06 00:00:00	t	f
53	Esther	Cardamon Seed / Pod	Flour - Chickpea	Rh isoimmunizat-deliver	Prem rupt memb-antepart	97	650	49033.55	28	Kingston	Tove	2022-07-03 00:00:00	t	f
54	Delly	Flax Seed	Bread Base - Italian	Family disruption NEC	Sylvatic yellow fever	84	316	56936.28	68	Jilli	Fionna	2021-09-26 00:00:00	t	f
55	Wallie	Persimmons	Pomegranates	Late eff accidental fall	Contract pelv NOS-unspec	63	760	68172.41	75	Trace	Godfrey	2021-12-11 00:00:00	f	f
56	Adore	Mustard - Pommery	Pears - Bartlett	Opn wnd anterior abdomen	Unc behav neo liver	37	443	74205.32	74	Agnella	Brett	2021-10-09 00:00:00	f	t
57	Barbe	French Kiss Vanilla	Beef - Tenderloin	Periostitis-pelvis	Aftrce traum fx bone NEC	25	325	56916.06	40	Gilda	Gladys	2021-12-05 00:00:00	f	t
58	Gareth	Lemonade - Kiwi, 591 Ml	Bread - Petit Baguette	Schizophr dis resid-chr	Mal neo bladder-lateral	59	523	86578.44	55	Chelsey	Benedick	2022-04-24 00:00:00	f	f
59	Vaclav	Nantucket - Orange Mango Cktl	Water - San Pellegrino	Fx condyl proc mandib-cl	Conjunctivochalasis	29	955	58815.26	63	Ali	Jephthah	2022-05-06 00:00:00	f	f
60	Jeremias	Salmon - Atlantic, Fresh, Whole	Lamb - Loin Chops	TB of hip-exam unkn	Abrasion-dentine	83	295	13769.1	77	Dill	Oliver	2021-12-14 00:00:00	t	f
61	Agosto	Vodka - Hot, Lnferno	Bread - Raisin Walnut Pull	Heat cramps	Atrophy tongue papillae	37	413	92392.95	19	Bayard	Shermy	2021-09-17 00:00:00	t	f
62	Emanuele	Soup Campbells Turkey Veg.	Basil - Thai	Intra-abdom inj NOS-open	Post MI syndrome	44	652	48853.45	72	Felice	Margaret	2022-04-17 00:00:00	t	t
63	Manuel	Syrup - Monin - Blue Curacao	Rolled Oats	Fx facial bone NEC-close	Surg comp - hypertension	31	267	73393.16	93	Velma	Julita	2022-01-07 00:00:00	t	f
64	Denny	Russian Prince	Wine - Red, Gamay Noir	Liver hematoma/contusion	Cns dysfunction syn NB	36	760	4419.42	60	Ignacio	Morrie	2021-08-23 00:00:00	f	f
65	Gussi	Cheese - Pont Couvert	Iced Tea Concentrate	Dvrtclo colon w/o hmrhg	Ac bulbar polio-type 1	40	469	68991.99	21	Sherilyn	Dom	2021-12-23 00:00:00	f	f
66	Gretal	Beef - Tenderloin Tails	Beets - Golden	Loc 2nd osteoarth-shlder	Malignant neopl thymus	95	901	32075.91	71	Flemming	Chrysa	2022-04-18 00:00:00	f	t
67	Emelina	Bay Leaf	Beer - Sleeman Fine Porter	Malign neopl thyroid	Deliver-single liveborn	63	725	93232.74	34	Mirabella	Madlin	2021-10-29 00:00:00	t	f
68	Anthiathia	Cake - Pancake	Sauce - Roasted Red Pepper	TB skin/subcut-cult dx	Nonrupt cerebral aneurym	45	492	9651.24	15	Gray	Marlee	2022-03-27 00:00:00	t	f
69	Yul	Artichokes - Jerusalem	Grenadine	Blind hypertensive eye	Hypertens encephalopathy	33	884	28198.49	18	Jolene	Lucia	2022-05-01 00:00:00	t	t
70	Dare	Beans - Black Bean, Canned	Extract - Lemon	Coxsackie carditis NOS	Extreme immat 2500+g	94	348	91422.6	42	Jarib	Richy	2021-12-14 00:00:00	f	f
71	Fayre	Mangostein	Appetizer - Mushroom Tart	Probl w special func NEC	Chr sup otitis media NOS	22	903	66901.07	71	Millicent	Odie	2021-11-19 00:00:00	f	f
72	Hilliard	Flour - So Mix Cake White	Milk - 1%	Anorexia nervosa	Prim spont pneumothorax	81	359	14292.85	79	Stefanie	Nate	2022-06-30 00:00:00	t	f
73	Mirilla	Shrimp - Tiger 21/25	Tea - English Breakfast	Joint pain-hand	Recur unilat inguin hern	3	298	96113.43	21	Prudi	Rosalie	2021-09-26 00:00:00	t	f
74	Murry	Pastry - Cheese Baked Scones	Veal - Tenderloin, Untrimmed	Descemetocele	Chr iridocyl in oth dis	21	827	35183.62	16	Halsy	Griffie	2022-04-09 00:00:00	f	f
75	Dionne	Couscous	Turnip - Mini	Hernia, site NEC w gangr	Fx clavic, stern end-opn	31	243	10547.33	1	Stanislas	Evonne	2022-08-01 00:00:00	t	t
76	Glennie	Appetizer - Assorted Box	Wine - Fontanafredda Barolo	T1-t6 fx-op/cen cord syn	Mv brd/alight-ped cycl	69	874	70495.1	74	Juline	Patten	2021-11-05 00:00:00	f	f
77	Skylar	Wine - White, Pelee Island	Thyme - Fresh	Vitamin b deficiency NOS	CHF NOS	77	255	30047.85	61	Douglass	Denni	2021-10-04 00:00:00	f	f
78	Jada	Muffin Hinge - 211n	Hot Chocolate - Individual	Fx pisiform-open	Malign neopl thorax	22	401	65658.7	69	Dieter	Andria	2022-01-05 00:00:00	t	t
79	Ardelis	Veal - Heart	Sausage - Liver	Gonococcal bursitis	Subclavian steal syndrom	26	606	66140.11	38	Kelcey	Pepito	2022-03-21 00:00:00	f	f
80	Rasla	Vodka - Moskovskaya	Wine - Casablanca Valley	Pressure ulcer, stage IV	Fet growth ret 2500+g	19	438	54666.79	29	Libbi	Carita	2022-05-22 00:00:00	f	f
81	Tabbatha	Turkey - Ground. Lean	Lamb - Ground	Adv eff psychotropic NOS	Abdmnal rgdt generalized	15	860	10276.39	28	Kirbie	Emelina	2022-06-09 00:00:00	t	t
82	Annabela	Cheese - Bakers Cream Cheese	Olives - Black, Pitted	H simplex complicat NEC	Mal neo lymph-head/neck	35	387	3179.02	16	Shanan	Valerye	2022-07-24 00:00:00	t	f
83	Leonardo	Butter Sweet	White Fish - Filets	Arthropod-borne dis NOS	Prim angle clos w/o dmg	99	205	38093.55	58	Lutero	Scotti	2021-11-13 00:00:00	f	t
84	Karoly	Couscous	Iced Tea Concentrate	RR coll NOS-passenger	Babesiosis	27	750	28507.56	17	Llewellyn	Salmon	2022-06-16 00:00:00	f	f
85	Susanna	Swiss Chard - Red	Rice - Sushi	Keratin ridge muc-excess	Hodg lymph-histio thorax	49	488	17313.49	60	Karon	Wilbur	2021-08-14 00:00:00	f	t
86	Lorianne	Longos - Cheese Tortellini	Cookie - Oreo 100x2	Primary CNS lymph xtrndl	1st deg burn hand NOS	59	948	50918.87	24	Raeann	Alden	2022-04-21 00:00:00	t	f
87	Dahlia	Bread Base - Toscano	Beef - Tenderloin - Aa	Ac inf fol trans,inf bld	Gonococcal infec pharynx	60	137	71614.71	55	Adorne	Sax	2022-06-24 00:00:00	t	t
88	Jared	Beer - Upper Canada Lager	Coke - Classic, 355 Ml	Syst sclerosis lung dis	Mv-oth veh coll-ped cycl	96	137	66311.74	32	Donavon	Clifford	2022-04-30 00:00:00	f	t
89	Adams	Thermometer Digital	Glass Clear 7 Oz Xl	Syphilis of lung	Multiple contusion trunk	52	620	43216.63	29	Justis	Joell	2021-11-17 00:00:00	t	t
90	Orlan	Knife Plastic - White	Veal - Inside	TPA adm status 24 hr pta	Persn w feared complaint	75	180	98224.18	62	Germayne	Gaspard	2022-02-03 00:00:00	f	t
91	Gabby	Pork - Chop, Frenched	Table Cloth 144x90 White	Tetanus	Puerp comp NEC-del w p/p	41	858	61169.38	57	Franni	Aylmar	2022-01-15 00:00:00	t	t
92	Barbette	Wine - Valpolicella Masi	Danishes - Mini Raspberry	Nodular lymphoma thorax	Salivary gland absence	36	952	23793.2	17	Johnna	Annette	2022-02-11 00:00:00	f	f
93	Kelsy	Nantuket Peach Orange	Bread - Dark Rye	Hebephrenia-unspec	Myopathy NOS	7	743	12028.79	49	Neala	Gareth	2022-01-20 00:00:00	f	t
94	Miof mela	Onion Powder	Table Cloth 81x81 Colour	Fx legs w arm/rib-open	Mixed incontinence	59	169	10140.17	60	Loreen	Guthrie	2022-06-20 00:00:00	f	f
95	Brendis	Piping - Bags Quizna	Onions - Red Pearl	Nontox multinodul goiter	Complete les cord/c1-c4	11	757	51349.42	89	Lester	Bastien	2022-05-26 00:00:00	f	t
96	Lexie	Salt - Celery	Bread - Roll, Calabrese	Infc free-liv amebae NEC	Reg enteritis, lg intest	22	394	49249.79	39	Briny	Hayley	2022-05-17 00:00:00	t	f
97	Myranda	Chicken - Whole	Soup - French Can Pea	Inf dis in preg NEC-unsp	Periostitis NEC	68	467	30256.62	79	Austin	Paige	2021-11-03 00:00:00	f	f
98	Joelie	Soup - Knorr, Classic Can. Chili	Chicken - Whole Fryers	Allergic rhinitis NEC	Fet damg d/t virus-deliv	24	778	28204.46	7	Kelby	Tabatha	2021-11-03 00:00:00	f	t
99	Shandra	Bread Ww Cluster	General Purpose Trigger	Mantle cell lymph spleen	Phlbts sprfc vn up extrm	2	702	13078.43	15	Elset	Yoshi	2021-12-28 00:00:00	t	t
100	Allianora	Roe - White Fish	Chicken - White Meat, No Tender	Tetanus neonatorum	Op skl base fx-prol coma	55	966	98258.57	89	Hobart	Catherin	2021-12-10 00:00:00	t	t
\.


--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: disnovo
--

COPY public.transaction (transaction_id, nickname_owner, transaction_name, transaction_title, transaction_type_id, nickname_owner_type, contact_id, nickname_owner_contact, start_date_full, start_date, start_year, start_month, start_week, start_day, start_time, transaction_probability, transaction_prevalue, transaction_discount, transaction_charge, transaction_value, transaction_taxpercentage, transaction_tax, transaction_total, transaction_balance, external_id, commentary, description, observation, objective, objective_completed, nickname_creator, creation_date, state, erased) FROM stdin;
1	Averyl	rwallice0	Low Beardtongue	25	Philbert	17	Templeton	2022-05-16 00:00:00	2022-06-07	2021	8	12	28	9	77990.58	6658.56	93547.23	37969.52	27860.06	23	8809.52	76893.26	19362.54	49162b4c-8df9-481a-9078-54df113b0a64	Breast inf preg NEC-unsp	Lid retraction or lag	Squam cell ca lid/canth	Lymph structure op NEC	Cholinergic urticaria	Ring	2022-02-24 00:00:00	f	t
2	Dukey	kmillership1	Bertero's Tufted Airplant	26	Jacklin	34	Elroy	2021-11-18 00:00:00	2022-07-30	2022	6	50	2	11	63978.71	61542.47	5786.54	95657.2	93351.09	5	49717.99	33247.05	22506.72	89896671-6977-4844-8523-093831b9db6e	Stiff-man syndrome	Unstable lie-antepartum	Schizophren dis-chronic	Rhinoscopy	Fx low end femur NOS-opn	Kendal	2021-12-10 00:00:00	t	f
3	Maurizio	bvannah2	Bush-violet	31	Worden	6	Giusto	2021-12-29 00:00:00	2022-02-01	2022	8	1	11	3	65112.61	29479.52	80308.09	89409.13	73692.03	41	18378.29	43817.9	92644.09	bdddafb1-7795-4f7d-bb3d-b6ad5c7139ce	Fx distal ulna-closed	Antidepress abuse-remiss	Trigem autonmc cephl NEC	Rectocele repair	Opn skull/oth fx-concuss	Bradney	2021-10-26 00:00:00	t	f
4	Yetta	jarundel3	Mexican Gumweed	21	Mildrid	38	Talbot	2022-06-13 00:00:00	2022-06-27	2022	7	26	16	21	96113.52	10911.37	21716.65	85070.0	24003.21	28	78225.6	63464.51	53623.83	a9da7793-7754-4de7-bd3e-e1b8ec22abc0	Neutropenia NEC	Ill-defined hrt dis NEC	Heat syncope	Unilat simple mastectomy	Water aerobics/exercise	Junia	2021-11-03 00:00:00	t	f
5	Thorndike	cropcke4	Shameplant	29	Rhetta	6	Foss	2022-01-21 00:00:00	2021-11-29	2021	6	50	16	17	92352.97	19192.67	71005.17	69897.73	33739.78	18	14081.99	57410.67	35548.33	a76e2caa-94f9-48b4-b654-feca641238f9	Alpha thalassemia	Fx mandible body NEC-cl	Bursitis NEC	Toxicology-lower GI	Oval window fistula	Clarke	2021-10-17 00:00:00	t	f
\.


--
-- Data for Name: transaction_detail; Type: TABLE DATA; Schema: public; Owner: disnovo
--

COPY public.transaction_detail (transaction_dateil_id, nickname_owner_transaction, product_id, nickname_owner_product, item_id, price, quantity, transactiondetail_discount, transactiondetail_discountpercentage, transactiondetail_charge, transactiondetail_chargepercentage, transactiondetail_taxpercentage, transactiondetail_tax, transactiondetail_balance, description, commentary, state, erased) FROM stdin;
1	Dehlia	20	Mindy	78	69038.13	2142	1881.96	23	7777.85	2	77	4033.76	3574.35	Osteodystrophy NEC	\N	f	t
2	Dillie	99	Nanon	73	35490.78	6430	1802.65	54	7045.77	78	83	9305.74	688.0	Arthrop w endocr/met dis	\N	t	t
3	Filmore	62	Nonna	89	36944.72	4144	4753.62	47	9092.09	30	64	827.36	7319.75	Abnormal jaw closure	\N	f	f
4	Reinhard	20	Anastasie	86	6912.38	4664	2767.66	21	506.55	29	15	9730.85	2452.94	Malig neo intestine NOS	\N	t	f
5	Rozalie	61	Hans	100	57796.64	8353	8623.92	23	318.13	23	12	4153.46	6977.26	Recurrent iridocyclitis	\N	t	t
6	Karlyn	52	Shandeigh	39	14592.5	2917	2904.48	42	5124.79	81	63	2454.6	7945.71	Cracked nipple-postpart	\N	f	f
7	Claiborne	80	Harlie	54	39649.55	7327	435.68	76	6256.48	90	10	3559.01	9719.48	Flu w resp manifest NEC	\N	t	f
8	Randy	72	Leona	83	43398.74	2695	5414.54	84	7315.36	37	48	3487.56	3650.48	Antidepress abuse-remiss	\N	f	f
9	Putnem	99	Conant	17	78027.62	1712	5380.74	13	1912.72	56	2	8145.06	8919.56	Fail sterile endoscopy	\N	t	f
10	Saw	4	Art	61	24167.24	3795	5440.15	98	855.67	15	61	5403.62	4226.48	Embryon cyst fem gen NEC	\N	t	t
11	Nick	4	Fran	67	49922.28	6204	7436.37	60	3726.72	46	86	4265.87	1710.46	Fracture trunk bone-clos	\N	t	t
12	Terrell	24	Craggie	75	19953.16	1361	4257.2	77	5071.13	19	32	8396.58	1742.26	Partial loss ear ossicle	\N	f	f
13	Matthus	3	Ashely	25	90367.47	861	5067.17	7	226.86	22	61	5560.41	1883.26	Drug psy dis w hallucin	\N	f	f
14	Rochester	35	Tarra	77	53270.73	7210	2420.14	11	4612.33	75	87	1081.17	5761.55	Ot sp hmiplga domnt side	\N	t	t
15	Beverley	67	Lela	41	29723.79	6501	2206.65	64	8900.87	8	91	2268.11	9907.62	Hb-SS dis NEC w crisis	\N	t	t
16	Noel	4	Rockie	3	53569.75	5251	6836.31	31	1069.56	74	61	578.69	8023.13	Legal abort w embol-unsp	\N	t	t
17	Wainwright	34	Celestina	38	49341.12	8061	7211.03	97	62.33	24	5	1899.2	1275.64	Tox w old hyper-antepart	\N	t	t
18	Nevile	52	Simmonds	95	97197.62	4793	4437.57	41	2486.14	33	70	3869.78	1956.11	Cortex contus-brief coma	\N	t	t
19	Dana	85	Lalo	32	4324.12	1673	9106.2	34	5448.91	15	94	1186.15	9469.1	Opn wnd scapula w tendon	\N	f	f
20	Jed	2	Jillian	24	52546.28	4501	3745.35	60	1228.1	49	19	780.17	4954.41	Trypanosomiasis NOS	\N	f	f
21	Monti	21	Wallis	64	18367.98	2638	735.6	33	676.24	5	42	3802.74	6716.7	Tics of organic origin	\N	f	f
22	Jeramey	48	Evie	50	8323.65	3101	918.49	94	8227.53	75	78	4107.11	5752.8	Cl skl base fx-deep coma	\N	t	t
24	Elspeth	2	Jenna	36	44743.31	6681	8695.25	80	6614.97	12	74	2443.32	2729.88	Prim TB complex-cult dx	\N	f	t
25	Sandro	75	Mabelle	55	84732.04	720	8474.77	28	4707.61	14	41	47.6	8425.45	Amebic lung abscess	\N	f	f
26	Clarisse	93	Elnore	43	99349.49	1289	8685.08	55	913.99	87	71	9483.16	5869.7	Sprain of jaw	\N	f	f
27	Madeline	46	Cyndi	56	70376.96	1782	4664.12	34	4784.62	12	51	8816.66	2237.89	Lung transplant status	\N	t	t
28	Maryjo	51	Anallise	97	94675.86	7644	7936.64	42	2851.4	39	86	179.33	1336.3	Contusion abdominal wall	\N	t	f
29	Tulley	83	Danni	68	94100.13	9031	3831.88	99	7448.98	4	37	7330.75	2048.53	Obstruc/fet malpos-deliv	\N	f	f
31	Thia	72	Dillie	91	69246.14	4170	1190.4	16	9208.6	6	1	1021.47	5042.48	Solar retinopathy	\N	f	t
33	Garvy	69	Constantine	71	60277.44	7739	7261.11	17	6748.74	99	42	3776.29	9747.16	Deviated nasal septum	\N	f	t
35	Cori	95	Rosalie	31	18372.75	5314	180.88	94	4063.21	80	86	7863.43	9742.86	Leukocytopenia NOS	\N	t	t
36	Stefan	52	Amye	35	58091.23	7183	9585.99	86	7834.77	93	84	4852.95	8682.77	Sprain of wrist NOS	\N	f	f
37	Bridgette	55	Cecile	98	580.2	4294	1782.99	78	9596.09	72	99	2570.67	4728.15	Carbuncle of arm	\N	t	t
38	Nikki	19	Teddy	37	31013.74	1183	5186.31	82	6970.16	99	16	7156.71	5527.26	Chr salpingo-oophoritis	\N	t	t
39	Marwin	79	Dell	60	60703.01	8688	1475.24	64	5725.07	13	6	2035.81	4692.16	Anom digestive syst NOS	\N	t	f
40	Elysia	38	Madalena	62	98666.39	9509	8149.38	1	746.93	6	8	5385.01	8920.01	Urinary problems NEC	\N	f	t
41	Aundrea	69	Gerri	96	47348.76	3260	7942.24	47	5324.06	75	90	8487.33	8270.17	Undeterm circ-electrocut	\N	t	t
42	Ewen	5	Bret	69	83994.05	4997	6250.26	71	506.08	32	93	5630.56	5995.51	Fx upper forearm NOS-cl	\N	f	f
43	Marv	58	Mariska	51	42726.04	8281	2300.67	23	6122.44	49	1	4698.04	444.14	Polycystic ovaries	\N	t	t
44	Mariann	78	Rodolph	16	4406.38	8767	8516.6	85	5418.4	55	40	8481.2	3295.54	Hypothyroidism NOS	\N	t	f
46	Phedra	87	Kirbie	22	17386.95	680	8910.85	4	5087.21	66	51	5419.79	2247.01	Malig neo skin lip NEC	\N	f	f
47	Terri	74	Mignonne	63	84822.0	9411	5022.82	13	3618.12	12	93	5975.52	2232.32	Lt-date w/mal 500-749g	\N	f	f
48	Minerva	23	Quentin	93	97931.03	1434	1294.65	55	8578.67	2	7	1000.77	5541.43	Traum arthropathy-up/arm	\N	f	f
49	Dori	72	Mathilde	5	47633.11	9362	7013.2	44	8109.33	67	4	5720.76	3024.49	Spermatocele	\N	f	t
50	Griffin	11	Felicity	6	92100.76	8680	1299.08	20	5197.57	42	90	5711.85	7676.61	Somat dysfunc lower extr	\N	t	f
51	Gwyn	74	Byrle	81	93527.13	4031	1375.95	3	2798.27	21	24	8184.65	4893.94	Metrorrhagia	\N	t	t
52	Alasteir	78	Darby	12	6791.4	4007	5676.88	57	9511.2	46	43	7132.98	1089.46	Fracture patella-open	\N	f	t
53	Maddie	97	Roseanne	99	20748.44	1943	4473.74	17	1726.6	24	83	1940.17	7630.42	Lymphoid mal NEC inguin	\N	f	t
57	Dudley	67	Peadar	4	7644.35	7021	9618.95	41	7253.27	15	58	762.87	7909.25	Chagas disease NOS	\N	t	f
58	Zachary	90	Adina	80	22512.59	5945	5536.05	98	3941.43	51	57	9322.5	5862.35	Adv eff capillary-act	\N	f	f
59	Ethelred	59	Karlee	59	2252.8	3459	7211.94	78	1980.42	66	19	9498.11	6726.39	Mal neo stomach cardia	\N	t	t
62	Wells	78	Tam	20	59971.98	4879	9598.72	48	6549.28	91	94	4142.43	2583.47	Aneurysm of neck	\N	f	f
64	Benedikta	58	Josephina	57	95144.22	3444	9396.92	93	8110.96	53	61	6316.5	1727.72	C1-c4 fx-cl/com cord les	\N	t	f
69	Corene	7	Bliss	82	24694.26	5102	4125.93	91	3482.78	13	68	5296.01	2326.07	Loc osteoar NOS-site NEC	\N	f	f
70	Ashlan	43	Egor	7	37985.13	7912	6121.82	72	1407.48	75	66	2239.55	1273.15	Dis phosphorus metabol	\N	t	f
74	Hildy	80	Stephana	90	34120.6	2739	9167.35	92	3261.13	76	34	9919.11	1266.4	Lack post occlsl support	\N	f	t
75	Timoteo	61	Latrena	8	660.36	503	8819.02	64	7770.21	57	85	8875.96	7411.09	Resp brncio interst lung	\N	t	f
76	Marmaduke	72	Daloris	46	55837.95	5075	8461.61	83	1146.66	76	100	8141.88	1844.8	3rd deg brn w loss-scalp	\N	f	f
78	Teddy	61	Hedda	2	17569.96	6129	1454.91	49	4831.27	28	49	8043.76	4139.18	Cellulitis, site NEC	\N	t	f
84	Kennedy	77	Vito	34	86533.29	1945	1064.7	30	8290.76	30	86	5512.73	5316.88	Bronchopneumonia org NOS	\N	f	f
85	Stinky	69	Belle	1	32774.38	1203	8069.62	34	1999.24	84	55	4909.67	5917.98	Syph retrobulb neuritis	\N	f	f
89	Kerwinn	41	April	52	91756.61	2261	523.25	33	3466.44	11	79	5968.59	2229.15	3rd burn w loss-wrist	\N	f	f
90	Dallis	1	Tomkin	49	65431.51	3026	8181.86	73	7710.65	65	61	4842.28	9582.78	Gardening/landscaping	\N	f	t
96	Mead	89	Yoshiko	72	32445.08	4068	987.57	40	6963.34	29	24	2022.45	1410.3	Lacrim passge change NEC	\N	f	t
98	Gail	39	Rianon	79	77250.72	72	2176.79	72	3163.87	3	21	7235.12	6342.2	Progress coccidioid NEC	\N	t	t
99	Livvyy	11	Nonie	10	97973.71	1237	5417.81	95	574.9	52	81	9965.56	5885.14	Gu TB NOS-micro dx	\N	f	t
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

SELECT pg_catalog.setval('public.product_type_product_type_id_seq', 95, true);


--
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: disnovo
--

SELECT pg_catalog.setval('public.products_product_id_seq', 100, true);


--
-- Name: transaction_detail_transaction_dateil_id_seq; Type: SEQUENCE SET; Schema: public; Owner: disnovo
--

SELECT pg_catalog.setval('public.transaction_detail_transaction_dateil_id_seq', 100, true);


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

