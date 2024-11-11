--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards (
    id uuid NOT NULL,
    user_id character varying(255),
    card_number character varying(16),
    status character varying(20),
    credit_limit numeric,
    available_balance numeric DEFAULT 0,
    last_transaction_at timestamp without time zone,
    expiry_date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    version integer DEFAULT 1
);


ALTER TABLE public.cards OWNER TO postgres;

--
-- Name: ledger_entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ledger_entries (
    id uuid NOT NULL,
    transaction_id uuid,
    account_id uuid,
    entry_type character varying(10),
    amount numeric,
    balance_after numeric,
    status character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    posted_at timestamp without time zone,
    version integer DEFAULT 1,
    CONSTRAINT valid_entry_type CHECK (((entry_type)::text = ANY (ARRAY[('DEBIT'::character varying)::text, ('CREDIT'::character varying)::text])))
);


ALTER TABLE public.ledger_entries OWNER TO postgres;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    event_type character varying(255) NOT NULL,
    event_data text NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    id uuid NOT NULL,
    card_id uuid,
    amount numeric(18,2) NOT NULL,
    currency character varying(3) NOT NULL,
    type character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying,
    reference_number character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    settled_at timestamp without time zone
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cards (id, user_id, card_number, status, credit_limit, available_balance, last_transaction_at, expiry_date, created_at, updated_at, version) FROM stdin;
1076ae65-8c49-4367-9144-945d7e28c2d5	2	6674221466475072	active	90000.00	90000.00	\N	2029-11-01	2024-11-01 16:01:30.026935	2024-11-01 16:01:30.026935	1
fb953fdb-24b4-4830-bb0c-73faf7355299	3	0316161531489110	active	100000.00	100000.00	\N	2029-11-01	2024-11-01 16:01:41.772988	2024-11-01 16:01:41.772988	1
ca8a907e-c483-4893-a5a3-ea3ff9298477	4	1242133954859883	active	120000.00	120000.00	\N	2029-11-01	2024-11-01 16:01:53.303906	2024-11-01 16:01:53.303906	1
0a82cfec-23a1-44c0-92ff-d21222acc525	5	8115897717298839	active	130000.00	130000.00	\N	2029-11-01	2024-11-01 16:02:01.696918	2024-11-01 16:02:01.696918	1
14582395-e7b9-4082-bd94-55fb6a69f0dd	6	2638179211989351	active	130000.00	130000.00	\N	2029-11-04	2024-11-04 16:48:37.759827	2024-11-04 16:48:37.759827	1
b8292248-910d-4447-80b7-c75ff7da804f	6	2638179211989351	active	130000.00	130000.00	\N	2029-11-04	2024-11-04 16:50:21.611132	2024-11-04 16:50:21.611132	1
afd974c8-5f81-43d4-a294-e099a4dbcf5f	6	2638179211989351	active	130000.00	130000.00	\N	2029-11-04	2024-11-04 16:51:08.216046	2024-11-04 16:51:08.216046	1
9d4c0251-ea6d-4637-a06f-40faa38a8114	6	2638179211989351	active	130000.00	130000.00	\N	2029-11-04	2024-11-04 17:06:17.565972	2024-11-04 17:06:17.565972	1
de5d68a4-c2cc-4e87-bb8c-dfcea747b461	6	2638179211989351	active	130000.00	130000.00	\N	2029-11-04	2024-11-04 17:19:53.242607	2024-11-04 17:19:53.242607	1
9ebd7a1a-78ee-4019-9b62-a1d7bc42448e	6	2638179211989351	active	130000.00	130000.00	\N	2029-11-04	2024-11-04 17:20:27.828876	2024-11-04 17:20:27.828876	1
a55529f8-1339-4173-a4c4-b9b6ca6a24de	6	2638179211989351	active	130000.00	130000.00	\N	2029-11-04	2024-11-04 17:21:34.561563	2024-11-04 17:21:34.561563	1
6beec0c5-6425-4b5e-84aa-c84a606e6a45	6	2638179211989351	active	130000.00	130000.00	\N	2029-11-04	2024-11-04 17:26:36.185809	2024-11-04 17:26:36.185809	1
98c7c7df-eda9-4ac6-be25-11a0c34e9eca	user-123	2638179211989351	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 13:52:45.676566	2024-11-05 13:52:45.676566	1
9c9f725e-ecc4-40fe-bfc4-5db7a1331cd6	user-123	0348978533091121	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 13:53:56.325529	2024-11-05 13:53:56.325529	1
40991345-9eba-4d9c-a4c2-a1049e281f88	user-123	6674221466475072	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 13:54:22.431444	2024-11-05 13:54:22.431444	1
92f73716-69d7-4f42-9b03-81f5247db899	user-123	2638179211989351	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 13:56:52.597112	2024-11-05 13:56:52.597112	1
4823db15-0c50-4699-baba-18e1ce95f299	user-123	0348978533091121	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 13:57:22.718721	2024-11-05 13:57:22.718721	1
764c9a04-8c3c-41c7-9101-45c6b18de48b	user-123	6674221466475072	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 13:58:33.170993	2024-11-05 13:58:33.170993	1
6f61c96a-f6bb-4db8-a939-705f16f173f3	user-123	2638179211989351	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 14:03:32.167978	2024-11-05 14:03:32.167978	1
73ab181a-c6b9-4ed5-bcb4-5390a32cb43f	user-123	0348978533091121	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 14:06:57.358954	2024-11-05 14:06:57.358954	1
ac50e289-e711-4534-88fc-cb4e2c9417d4	user-123	6674221466475072	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 14:08:18.451704	2024-11-05 14:08:18.451704	1
23b174c6-cc12-4115-89a0-16ac0be135ed	user-123	7649948573917593	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 14:08:57.304436	2024-11-05 14:08:57.304436	1
5957e468-8471-49a6-b0ad-11afc9cac1ca	user-123	0316161531489110	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 15:37:27.74789	2024-11-05 15:37:27.74789	1
d39b4ea9-1b3c-4ece-a759-df50f6a4246c	user-123	0049827648710176	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 15:38:17.601879	2024-11-05 15:38:17.601879	1
141827eb-f9e8-4c7e-aefa-6935647e56e2	user-123	1242133954859883	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 15:40:41.217198	2024-11-05 15:40:41.217198	1
00bb15ed-bf2b-4648-83b4-a7fa916a5ba1	user-123	6519965772129914	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 15:42:18.655777	2024-11-05 15:42:18.655777	1
6b35d75a-b895-48fb-8949-4965039a770f	user-124	2638179211989351	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 19:49:29.226855	2024-11-05 19:49:29.226855	1
442fbd78-36e9-4b62-b8ba-d96e87fdcc90	user-124	0348978533091121	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 20:12:02.65404	2024-11-05 20:12:02.65404	1
8e85d5a0-ee8c-4d84-a42e-c47810bdbf42	user-124	6674221466475072	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 20:12:37.126907	2024-11-05 20:12:37.126907	1
c3c98612-4eeb-4b36-8f05-5cdf575d16aa	user-124	7649948573917593	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 20:15:02.881561	2024-11-05 20:15:02.881561	1
497da0b6-0f7e-4d5e-8b8e-595be26ec951	user-124	2638179211989351	active	1000.00	1000.00	\N	2029-11-05	2024-11-05 20:18:55.895286	2024-11-05 20:18:55.895286	1
e03482b6-979a-41a2-afbe-752a3315f398	1	2638179211989351	active	80000.00	1000	\N	2029-11-01	2024-11-01 16:01:23.071266	2024-11-01 16:01:23.071266	1
1601bfcd-a1a1-45dd-b7bd-211f4da81a13	deepka	2638179211989351	active	500	500	\N	2029-11-07	2024-11-07 11:59:23.806495	2024-11-07 11:59:23.806495	1
62c95a3d-8f08-4062-ac07-912c46a20617	deepka	2638179211989351	active	5400	5400	\N	2029-11-07	2024-11-07 14:00:05.392659	2024-11-07 14:00:05.392659	1
ed82496a-8b6a-404c-86dc-975b0735690b	deepak-test	0348978533091121	active	500	500	\N	2029-11-07	2024-11-07 14:33:15.929766	2024-11-07 14:33:15.929766	1
00277d72-21b1-49e2-ad42-d64e948c4e8c	deepak-2--tets	0348978533091121	active	500	500	\N	2029-11-07	2024-11-07 14:33:38.762231	2024-11-07 14:33:38.762231	1
dab393f9-9bf2-416e-9f05-2c1baa811126	user123	6674221466475072	active	500	500	\N	2029-11-07	2024-11-07 15:04:16.461916	2024-11-07 15:04:16.461916	1
409dbfce-0abf-46c7-8199-75c688c97c49	user123	7649948573917593	active	500	500	\N	2029-11-07	2024-11-07 15:04:37.129941	2024-11-07 15:04:37.129941	1
b6b5f3b6-5a44-4cab-9fc7-3205e2c7ccec	user123	0316161531489110	active	500	500	\N	2029-11-07	2024-11-07 15:04:46.212005	2024-11-07 15:04:46.212005	1
75940f85-ef48-4042-b730-5c0bf2ad4cae	newUser	0049827648710176	active	500	500	\N	2029-11-07	2024-11-07 15:05:10.775083	2024-11-07 15:05:10.775083	1
085d2e93-0359-40a7-83e6-4a253b5fc4b9	newUser	6674221466475072	active	500	500	\N	2029-11-07	2024-11-07 15:28:48.663622	2024-11-07 15:28:48.663622	1
a273580b-6c51-462c-92e0-cb65c03c1896	newUser	1242133954859883	active	500	500	\N	2029-11-07	2024-11-07 15:35:21.383372	2024-11-07 15:35:21.383372	1
f0fc96cb-27f7-4995-a2de-60cec36991e3	newUser	6519965772129914	active	500	500	\N	2029-11-07	2024-11-07 15:39:28.387103	2024-11-07 15:39:28.387103	1
81e0356c-6575-4edd-bd9d-13bd9fe180c1	newUser	8115897717298839	active	500	500	\N	2029-11-07	2024-11-07 15:40:50.771853	2024-11-07 15:40:50.771853	1
de5a4959-836c-4de2-b3b5-43befbb73800	newUser	8705676071561897	active	500	500	\N	2029-11-07	2024-11-07 15:42:01.74663	2024-11-07 15:42:01.74663	1
e9a2595c-4b32-4321-ada5-45938667017e	newUser	9915565668951127	active	500	500	\N	2029-11-07	2024-11-07 15:42:24.28126	2024-11-07 15:42:24.28126	1
a3fea6a8-a27a-48d6-9543-1f4bda114402	newUser	6744881242059097	active	500	500	\N	2029-11-07	2024-11-07 15:44:23.187987	2024-11-07 15:44:23.187987	1
de67a02e-8386-48c2-b1bf-1ba34da2ab9b	newUser	6029175780683524	active	500	500	\N	2029-11-07	2024-11-07 16:50:03.450239	2024-11-07 16:50:03.450239	1
50765933-9d7d-4201-bef0-6b41b9a9c82d	newUser	0049827648710176	active	1000	988	\N	2029-11-08	2024-11-08 19:39:01.624462	2024-11-08 19:39:01.624462	1
feacd22a-427d-4bf3-a147-33273202a376	newUser	7649948573917593	active	500	5400	\N	2029-11-08	2024-11-08 19:33:06.253751	2024-11-08 19:33:06.253751	1
0dd465cf-acf9-4a60-9d7d-0c49f154487b	newUser	0316161531489110	active	500	500	\N	2029-11-08	2024-11-08 19:35:10.906082	2024-11-08 19:35:10.906082	1
ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	newUser	7649948573917593	active	500	1110000822	\N	2029-11-07	2024-11-07 15:48:10.448411	2024-11-07 15:48:10.448411	1
0cb6a8b2-b122-4145-8270-b6fa70f222a8	newUser	2638179211989351	active	500	600	\N	2029-11-08	2024-11-08 15:16:33.182727	2024-11-08 15:16:33.182727	1
2e255443-eb4e-4a1f-96cb-44737f76b05e	newUser	0348978533091121	active	500	816	\N	2029-11-08	2024-11-08 15:20:37.342024	2024-11-08 15:20:37.342024	1
a309117a-865c-4235-b232-8c7ee2ece241	newUser	0348978533091121	active	500	1500	\N	2029-11-08	2024-11-08 19:36:25.33437	2024-11-08 19:36:25.33437	1
b6be27c4-f0ec-4640-9f79-096600c81ba4	newUser	2638179211989351	active	500	15277	\N	2029-11-08	2024-11-08 14:41:34.099336	2024-11-08 14:41:34.099336	1
0715cd47-19fb-42de-bdb5-0e1bdc8789e5	newUser	6674221466475072	active	500	800	\N	2029-11-08	2024-11-08 19:32:24.654236	2024-11-08 19:32:24.654236	1
f129090c-9780-430c-93c1-63b9eb26e9b0	newUser	1242133954859883	active	1000	900	\N	2029-11-08	2024-11-08 20:01:06.220287	2024-11-08 20:01:06.220287	1
12ffeb59-653d-4f35-b904-fcb5ad6cda6f	newUser	6519965772129914	active	1000	8800	\N	2029-11-08	2024-11-08 23:19:07.561874	2024-11-08 23:19:07.561874	1
\.


--
-- Data for Name: ledger_entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ledger_entries (id, transaction_id, account_id, entry_type, amount, balance_after, status, created_at, posted_at, version) FROM stdin;
1f0c00fc-e556-4029-9586-cac92c3a097c	\N	6f61c96a-f6bb-4db8-a939-705f16f173f3	CREDIT	1000.00	1000.00	pending	2024-11-05 08:33:32.180227	\N	1
5b3dc576-04aa-4e61-9cbc-2eea58f7abe0	\N	73ab181a-c6b9-4ed5-bcb4-5390a32cb43f	CREDIT	1000.00	1000.00	pending	2024-11-05 08:36:57.365692	\N	1
95c3620a-c2ea-42e6-b287-62fb78a101fd	\N	ac50e289-e711-4534-88fc-cb4e2c9417d4	CREDIT	1000.00	1000.00	pending	2024-11-05 08:38:18.457768	\N	1
d8c25bb5-f772-471c-a99e-310ad637f30e	\N	23b174c6-cc12-4115-89a0-16ac0be135ed	CREDIT	1000.00	1000.00	pending	2024-11-05 08:38:57.311354	\N	1
7ef94349-c536-4445-9c01-863e197c84ca	\N	5957e468-8471-49a6-b0ad-11afc9cac1ca	CREDIT	1000.00	1000.00	pending	2024-11-05 10:07:27.758046	\N	1
61c484cb-176a-4f20-a422-889f240e3601	\N	d39b4ea9-1b3c-4ece-a759-df50f6a4246c	CREDIT	1000.00	1000.00	pending	2024-11-05 10:08:17.602951	\N	1
495fb432-e08a-40d4-b654-08f5a5fc19a9	\N	141827eb-f9e8-4c7e-aefa-6935647e56e2	CREDIT	1000.00	1000.00	pending	2024-11-05 10:10:41.219571	\N	1
dd231d7e-a683-4e76-8f51-14a83e6c2802	\N	00bb15ed-bf2b-4648-83b4-a7fa916a5ba1	CREDIT	1000.00	1000.00	pending	2024-11-05 10:12:18.657302	\N	1
8e3cbc6f-2925-483c-8acc-256ca8a182c4	\N	e03482b6-979a-41a2-afbe-752a3315f398	CREDIT	80000.00	80000.00	pending	2024-11-05 13:03:25.696002	\N	1
1142d528-00f1-46de-8bf3-94e043685b98	\N	e03482b6-979a-41a2-afbe-752a3315f398	CREDIT	80000.00	80000.00	pending	2024-11-05 13:06:55.39827	\N	1
0c7fcf70-fe42-4f92-92a5-a39830133582	\N	e03482b6-979a-41a2-afbe-752a3315f398	CREDIT	80000.00	80000.00	pending	2024-11-05 14:14:29.357902	\N	1
2ba41019-979a-426f-aae9-1a098284704b	\N	e03482b6-979a-41a2-afbe-752a3315f398	CREDIT	80000.00	80000.00	pending	2024-11-05 14:17:53.020956	\N	1
284a9231-82e8-4784-bcb6-3ab8c0bc2ce2	\N	6b35d75a-b895-48fb-8949-4965039a770f	CREDIT	1000.00	1000.00	pending	2024-11-05 14:19:29.240034	\N	1
7c56b47f-b082-4891-a1d9-146a1b415771	\N	e03482b6-979a-41a2-afbe-752a3315f398	CREDIT	80000.00	80000.00	pending	2024-11-05 14:42:02.649085	\N	1
8037d570-0aed-4d70-a347-e04d4c7325af	\N	442fbd78-36e9-4b62-b8ba-d96e87fdcc90	CREDIT	1000.00	1000.00	pending	2024-11-05 14:42:02.654455	\N	1
ae8a0c4e-6f05-4297-bfb9-cb5261157098	\N	e03482b6-979a-41a2-afbe-752a3315f398	CREDIT	80000.00	80000.00	pending	2024-11-05 14:42:37.11545	\N	1
b1d2d9c4-b741-4a5a-9054-9b9f8c273116	\N	8e85d5a0-ee8c-4d84-a42e-c47810bdbf42	CREDIT	1000.00	1000.00	pending	2024-11-05 14:42:37.128243	\N	1
bb958bcf-4272-4096-b8cc-cd47eb128282	\N	e03482b6-979a-41a2-afbe-752a3315f398	CREDIT	80000.00	80000.00	pending	2024-11-05 14:45:02.874297	\N	1
e7d1556c-fbc3-4010-b1ae-5de0baa93a77	\N	c3c98612-4eeb-4b36-8f05-5cdf575d16aa	CREDIT	1000.00	1000.00	pending	2024-11-05 14:45:02.882204	\N	1
4a50d9e0-2ac8-4672-a4c2-636a1957ecf1	\N	497da0b6-0f7e-4d5e-8b8e-595be26ec951	CREDIT	1000.00	1000.00	success	2024-11-05 14:48:55.906551	\N	1
2bf4b860-b280-4e75-8e84-10dc522e4e5a	\N	e03482b6-979a-41a2-afbe-752a3315f398	CREDIT	500	0.00	success	2024-11-05 18:44:01.802136	\N	1
f659d0b8-5c3f-4e30-9b22-6030f3130e27	\N	e03482b6-979a-41a2-afbe-752a3315f398	CREDIT	500	500.00	success	2024-11-05 18:44:07.326029	\N	1
88bb08f3-d70b-4c72-a387-44c2a27b8dc4	\N	e03482b6-979a-41a2-afbe-752a3315f398	CREDIT	500	1000.00	success	2024-11-05 18:44:15.319085	\N	1
d00358c5-98a5-4839-bf37-f04a1edd25fb	\N	e03482b6-979a-41a2-afbe-752a3315f398	DEBIT	500	500.00	success	2024-11-05 18:44:22.921095	\N	1
846989cd-31c8-4c52-9f74-9206219234e0	\N	e03482b6-979a-41a2-afbe-752a3315f398	DEBIT	500	0.00	success	2024-11-06 09:05:52.471129	\N	1
c61df130-8693-4005-b237-975408bb9f5c	\N	e03482b6-979a-41a2-afbe-752a3315f398	CREDIT	500	500.00	success	2024-11-06 09:07:12.099648	\N	1
c9b9d76c-65f8-4926-8e3f-52569a78e3a7	\N	e03482b6-979a-41a2-afbe-752a3315f398	CREDIT	500	1000.00	success	2024-11-06 09:07:20.269764	\N	1
ce0ebed1-762c-4b94-950c-dd3a2efab463	\N	1601bfcd-a1a1-45dd-b7bd-211f4da81a13	CREDIT	500	500	success	2024-11-07 06:29:24.163293	\N	1
3e99f910-6c50-4edc-87bd-12b97faa5823	\N	62c95a3d-8f08-4062-ac07-912c46a20617	CREDIT	5400	5400	success	2024-11-07 08:30:05.801646	\N	1
7d652453-fe2e-44db-b1b0-58509a569a3d	\N	ed82496a-8b6a-404c-86dc-975b0735690b	CREDIT	500	500	success	2024-11-07 09:03:15.947919	\N	1
7275bca5-37ea-4a36-b526-0079c0b3dab4	\N	00277d72-21b1-49e2-ad42-d64e948c4e8c	CREDIT	500	500	success	2024-11-07 09:03:38.787799	\N	1
255f64bf-40af-429c-809a-0fda9ff49640	\N	dab393f9-9bf2-416e-9f05-2c1baa811126	CREDIT	500	500	success	2024-11-07 09:34:16.483104	\N	1
8fdf8e80-6583-4d1d-b1fa-9670ee6ff1cb	\N	409dbfce-0abf-46c7-8199-75c688c97c49	CREDIT	500	500	success	2024-11-07 09:34:37.13112	\N	1
ebd93ec7-6d7a-4653-92cf-46dd4bf588ab	\N	b6b5f3b6-5a44-4cab-9fc7-3205e2c7ccec	CREDIT	500	500	success	2024-11-07 09:34:46.214166	\N	1
81b335f2-87cb-4935-b6e1-00ab5981ed81	\N	75940f85-ef48-4042-b730-5c0bf2ad4cae	CREDIT	500	500	success	2024-11-07 09:35:10.777584	\N	1
97aa7ad3-4410-4176-877e-2794ab4662d5	\N	085d2e93-0359-40a7-83e6-4a253b5fc4b9	CREDIT	500	500	success	2024-11-07 09:58:49.126575	\N	1
4cba023a-f891-4aea-97e4-8d3579eecdf6	\N	a273580b-6c51-462c-92e0-cb65c03c1896	CREDIT	500	500	success	2024-11-07 10:05:21.407842	\N	1
db63aad6-7ce8-408b-9991-0edc3c99c2f2	\N	f0fc96cb-27f7-4995-a2de-60cec36991e3	CREDIT	500	500	success	2024-11-07 10:09:28.394318	\N	1
93c53f8e-034f-442d-bedf-4850020621a1	\N	81e0356c-6575-4edd-bd9d-13bd9fe180c1	CREDIT	500	500	success	2024-11-07 10:10:50.77495	\N	1
b58e41e6-07b1-499c-81e9-88a14444f134	\N	de5a4959-836c-4de2-b3b5-43befbb73800	CREDIT	500	500	success	2024-11-07 10:12:01.747678	\N	1
f2f0c664-b477-43ac-9354-7846739318d1	\N	e9a2595c-4b32-4321-ada5-45938667017e	CREDIT	500	500	success	2024-11-07 10:12:24.285629	\N	1
551e025f-7a6c-4899-82e3-fdeff4951de9	\N	a3fea6a8-a27a-48d6-9543-1f4bda114402	CREDIT	500	500	success	2024-11-07 10:14:23.197015	\N	1
c722c99c-3b9b-4f7f-9682-b9d555664b65	\N	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	CREDIT	500	500	success	2024-11-07 10:18:10.45261	\N	1
6d5fc4d2-fe1b-4f26-8127-c442765aaed0	\N	de67a02e-8386-48c2-b1bf-1ba34da2ab9b	CREDIT	500	500	success	2024-11-07 11:20:03.745804	\N	1
72c44aaf-611a-4056-8cf7-a8612416b472	\N	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	CREDIT	333	833.00	success	2024-11-07 12:45:15.398721	\N	1
0a88ace3-e55f-4cd4-9c1e-d0e891955da0	\N	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	CREDIT	1233455678	1233456511.00	success	2024-11-08 05:09:29.856312	\N	1
a7581ab3-f4d7-4318-a0f0-455056528999	\N	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	DEBIT	123456789	1109999722.00	success	2024-11-08 05:09:55.727805	\N	1
772cb6b6-947a-4c6e-a175-8b92026348ff	\N	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	CREDIT	1000	1110000722.00	success	2024-11-08 05:48:24.382905	\N	1
71bcc3e5-7afb-4392-8657-8f49595f48c6	\N	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	CREDIT	100	1110000822.00	success	2024-11-08 06:15:54.786062	\N	1
758cb00d-9531-4ec2-9dbd-1f064204b9a7	\N	b6be27c4-f0ec-4640-9f79-096600c81ba4	CREDIT	500	500	success	2024-11-08 09:11:34.273506	\N	1
bf635c5e-2195-4ca3-9279-e1cfffc63372	\N	b6be27c4-f0ec-4640-9f79-096600c81ba4	CREDIT	10089	10589.00	success	2024-11-08 09:12:47.619615	\N	1
3b54dbee-c7bd-4160-a2ce-ef0d90e7be37	\N	0cb6a8b2-b122-4145-8270-b6fa70f222a8	CREDIT	500	500	success	2024-11-08 09:46:33.202266	\N	1
e7888d98-60f3-4acb-984c-830bad261f81	\N	0cb6a8b2-b122-4145-8270-b6fa70f222a8	CREDIT	100	600.00	success	2024-11-08 09:46:37.804909	\N	1
1bb9ff4e-757e-455d-8fd5-3d978fe7230b	\N	2e255443-eb4e-4a1f-96cb-44737f76b05e	CREDIT	500	500	success	2024-11-08 09:50:37.364716	\N	1
568a06cc-082f-48af-a3ca-9b451f7fe66d	\N	2e255443-eb4e-4a1f-96cb-44737f76b05e	CREDIT	100	600.00	success	2024-11-08 09:50:42.142671	\N	1
063a6683-238f-4c09-be65-916c4440f13d	\N	2e255443-eb4e-4a1f-96cb-44737f76b05e	CREDIT	12	612.00	success	2024-11-08 09:56:05.838627	\N	1
c50f3eba-3dbc-443a-91d9-aea7722ad142	\N	2e255443-eb4e-4a1f-96cb-44737f76b05e	DEBIT	20	592.00	success	2024-11-08 09:58:20.419484	\N	1
a14baa2a-ad79-48a3-8c55-6cdc2310a1cd	\N	b6be27c4-f0ec-4640-9f79-096600c81ba4	CREDIT	10000	20589.00	success	2024-11-08 12:18:37.088296	\N	1
5a631822-5c5f-477c-a1d9-58381522df4e	\N	2e255443-eb4e-4a1f-96cb-44737f76b05e	CREDIT	200	792.00	success	2024-11-08 12:33:14.468815	\N	1
beddeb1c-4a83-4d5a-8421-e53b393218d5	\N	2e255443-eb4e-4a1f-96cb-44737f76b05e	CREDIT	12	804.00	success	2024-11-08 12:38:54.591206	\N	1
8fe1315d-8f80-4f0e-b69c-7d06b6dc2dd7	\N	2e255443-eb4e-4a1f-96cb-44737f76b05e	CREDIT	12	816.00	success	2024-11-08 12:38:58.854811	\N	1
659239a6-05ff-4d93-8117-8ae5240239eb	\N	b6be27c4-f0ec-4640-9f79-096600c81ba4	CREDIT	200	20789.00	success	2024-11-08 13:11:38.196198	\N	1
602901cb-3e81-4580-9a77-5bf9b8233d26	\N	b6be27c4-f0ec-4640-9f79-096600c81ba4	DEBIT	100	20689.00	success	2024-11-08 13:11:49.917169	\N	1
d3c07efe-31b3-4894-ade7-6719635df73b	\N	b6be27c4-f0ec-4640-9f79-096600c81ba4	CREDIT	100	20789.00	success	2024-11-08 13:12:46.875473	\N	1
20265190-e38f-4ef6-a935-d60a038db0aa	\N	b6be27c4-f0ec-4640-9f79-096600c81ba4	CREDIT	100	20889.00	success	2024-11-08 13:14:16.553538	\N	1
087eadc1-d82e-41a0-a2b6-fb29c8405d02	\N	b6be27c4-f0ec-4640-9f79-096600c81ba4	DEBIT	300	20589.00	success	2024-11-08 13:14:24.086498	\N	1
78e00429-be05-415c-954d-aedd705c27f7	\N	b6be27c4-f0ec-4640-9f79-096600c81ba4	DEBIT	200	20389.00	success	2024-11-08 13:29:04.52657	\N	1
86561bc1-a2f1-4670-b33a-0a8f395afafb	\N	b6be27c4-f0ec-4640-9f79-096600c81ba4	DEBIT	3000	17389.00	success	2024-11-08 13:30:04.934906	\N	1
a5adf3e2-6d30-4b85-b446-97a84d5fdb9f	\N	b6be27c4-f0ec-4640-9f79-096600c81ba4	DEBIT	2312	15077.00	success	2024-11-08 13:31:47.110355	\N	1
e616ef03-ead8-4ea1-a582-28016d0b395a	\N	0715cd47-19fb-42de-bdb5-0e1bdc8789e5	CREDIT	500	500	success	2024-11-08 14:02:24.708487	\N	1
9c79e09d-2e79-4010-a319-88b38af7d8ee	\N	0715cd47-19fb-42de-bdb5-0e1bdc8789e5	CREDIT	100	600.00	success	2024-11-08 14:02:33.051747	\N	1
c6890427-94e6-4661-9997-4f3577133157	\N	feacd22a-427d-4bf3-a147-33273202a376	DEBIT	100	400.00	success	2024-11-08 14:03:26.848236	\N	1
a300bc93-586a-4cf2-ad8c-e1afff28d5da	\N	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	DEBIT	100	900.00	success	2024-11-08 17:49:15.900293	\N	1
68d56388-de50-42b5-88e6-83ec45aeeca3	\N	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	CREDIT	100	1000.00	success	2024-11-08 17:49:27.766662	\N	1
72074067-82d1-4203-b524-3a662e3fdade	\N	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	DEBIT	100	900.00	success	2024-11-08 17:49:33.673725	\N	1
c0a216d5-8d6c-4e89-85b1-6a8944039e6c	\N	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	DEBIT	200	700.00	success	2024-11-08 17:49:45.014881	\N	1
a2e7fc1e-28fb-40ce-b6dd-8cf141ba3e23	\N	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	CREDIT	100	800.00	success	2024-11-08 17:49:54.850217	\N	1
51495bdf-f000-4c2f-a7bc-7b0ee0bd424a	\N	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	CREDIT	8000	8800.00	success	2024-11-08 17:50:28.057389	\N	1
60bf9b97-3855-4ee0-80b0-9e92e34f45ff	\N	feacd22a-427d-4bf3-a147-33273202a376	CREDIT	500	500	success	2024-11-08 14:03:06.25517	\N	1
1c1ce18c-1fae-4440-92d1-78b7102246ab	\N	feacd22a-427d-4bf3-a147-33273202a376	CREDIT	5000	5400.00	success	2024-11-08 14:03:46.030348	\N	1
c4400a16-038b-4be8-b469-64544700fec9	\N	0dd465cf-acf9-4a60-9d7d-0c49f154487b	CREDIT	500	500	success	2024-11-08 14:05:10.908767	\N	1
4f2ce9e3-ae07-4b81-8a50-c2bf92e5e570	\N	a309117a-865c-4235-b232-8c7ee2ece241	CREDIT	500	500	success	2024-11-08 14:06:25.35632	\N	1
61ec7ba0-47f4-46f5-8513-bf19be1f09a2	\N	0715cd47-19fb-42de-bdb5-0e1bdc8789e5	CREDIT	200	800.00	success	2024-11-08 14:08:21.63411	\N	1
e6cd758f-bb5f-4622-9b01-024b0eea4f09	\N	50765933-9d7d-4201-bef0-6b41b9a9c82d	CREDIT	1000	1000	success	2024-11-08 14:09:01.627582	\N	1
df85ec32-2805-421d-a019-6219c5d81a4d	\N	50765933-9d7d-4201-bef0-6b41b9a9c82d	DEBIT	12	988.00	success	2024-11-08 14:09:08.552718	\N	1
62b3ee4e-bb1c-46a6-b206-1c76ab2e8202	\N	a309117a-865c-4235-b232-8c7ee2ece241	CREDIT	1000	1500.00	success	2024-11-08 14:20:50.173739	\N	1
06878c9f-1c62-4df2-881c-d2b5b0a07035	\N	f129090c-9780-430c-93c1-63b9eb26e9b0	CREDIT	1000	1000	success	2024-11-08 14:31:06.224124	\N	1
637d900c-c88c-4f84-8931-2db66d0acb37	\N	0715cd47-19fb-42de-bdb5-0e1bdc8789e5	DEBIT	10000	-9200.00	success	2024-11-08 14:50:28.548386	\N	1
9c133ea9-4d27-46d0-8c40-2cb9c5ae7881	\N	0715cd47-19fb-42de-bdb5-0e1bdc8789e5	CREDIT	10000	800.00	success	2024-11-08 14:52:20.049591	\N	1
bf906dc5-dc93-4bc9-8a80-5a1c459aa712	\N	b6be27c4-f0ec-4640-9f79-096600c81ba4	CREDIT	100	15177.00	success	2024-11-08 14:57:54.726247	\N	1
22bfeef8-2d05-46a7-bbea-f67a6f26b7bc	\N	b6be27c4-f0ec-4640-9f79-096600c81ba4	CREDIT	100	15277.00	success	2024-11-08 14:58:04.130203	\N	1
6ba9f75e-443d-4d36-9798-41283e08b5f8	\N	f129090c-9780-430c-93c1-63b9eb26e9b0	DEBIT	100	900.00	success	2024-11-08 16:47:04.801355	\N	1
f6401d75-91bb-44b3-9869-b39da9d60abe	\N	f129090c-9780-430c-93c1-63b9eb26e9b0	DEBIT	100	800.00	success	2024-11-08 16:47:17.033964	\N	1
c3d1fe76-27ad-4a28-9a27-032616795d7f	\N	f129090c-9780-430c-93c1-63b9eb26e9b0	CREDIT	50	850.00	success	2024-11-08 16:50:33.737385	\N	1
7358acb9-2e59-4b2d-8b32-0025c6d6ccf5	\N	f129090c-9780-430c-93c1-63b9eb26e9b0	CREDIT	50	900.00	success	2024-11-08 16:51:09.286883	\N	1
e6d818db-fbbb-412c-a599-9d5c130fe547	\N	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	CREDIT	1000	1000	success	2024-11-08 17:49:07.58579	\N	1
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, event_type, event_data, "timestamp") FROM stdin;
1	card.issued	{"card_id":"1601bfcd-a1a1-45dd-b7bd-211f4da81a13","user_id":"deepka","credit_limit":"500","card_number":"2638179211989351","available_balance":"500"}	2024-11-07 11:59:23.840935
2	card.issued	{"card_id":"1601bfcd-a1a1-45dd-b7bd-211f4da81a13","user_id":"deepka","credit_limit":"500","card_number":"2638179211989351","available_balance":"500"}	2024-11-07 11:59:23.847243
3	ledger.entry.created	{"id":"ce0ebed1-762c-4b94-950c-dd3a2efab463","account_id":"1601bfcd-a1a1-45dd-b7bd-211f4da81a13","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1730960964,"nanos":163292620},"version":1}	2024-11-07 11:59:24.185423
4	ledger.entry.created	{"id":"ce0ebed1-762c-4b94-950c-dd3a2efab463","account_id":"1601bfcd-a1a1-45dd-b7bd-211f4da81a13","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1730960964,"nanos":163292620},"version":1}	2024-11-07 11:59:24.185424
5	card.issued	{"card_id":"00277d72-21b1-49e2-ad42-d64e948c4e8c","user_id":"deepak-2--tets","credit_limit":"500","card_number":"0348978533091121","available_balance":"500"}	2024-11-07 14:33:38.770818
6	ledger.entry.created	{"id":"7275bca5-37ea-4a36-b526-0079c0b3dab4","account_id":"00277d72-21b1-49e2-ad42-d64e948c4e8c","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1730970218,"nanos":787799183},"version":1}	2024-11-07 14:33:38.794376
7	card.issued	{"card_id":"dab393f9-9bf2-416e-9f05-2c1baa811126","user_id":"user123","credit_limit":"500","card_number":"6674221466475072","available_balance":"500"}	2024-11-07 15:04:16.468721
8	card.issued	{"card_id":"dab393f9-9bf2-416e-9f05-2c1baa811126","user_id":"user123","credit_limit":"500","card_number":"6674221466475072","available_balance":"500"}	2024-11-07 15:04:16.468818
9	ledger.entry.created	{"id":"255f64bf-40af-429c-809a-0fda9ff49640","account_id":"dab393f9-9bf2-416e-9f05-2c1baa811126","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1730972056,"nanos":483103665},"version":1}	2024-11-07 15:04:16.521903
10	ledger.entry.created	{"id":"255f64bf-40af-429c-809a-0fda9ff49640","account_id":"dab393f9-9bf2-416e-9f05-2c1baa811126","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1730972056,"nanos":483103665},"version":1}	2024-11-07 15:04:16.529469
11	card.issued	{"card_id":"409dbfce-0abf-46c7-8199-75c688c97c49","user_id":"user123","credit_limit":"500","card_number":"7649948573917593","available_balance":"500"}	2024-11-07 15:04:37.132876
12	ledger.entry.created	{"id":"8fdf8e80-6583-4d1d-b1fa-9670ee6ff1cb","account_id":"409dbfce-0abf-46c7-8199-75c688c97c49","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1730972077,"nanos":131119674},"version":1}	2024-11-07 15:04:37.134988
13	card.issued	{"card_id":"b6b5f3b6-5a44-4cab-9fc7-3205e2c7ccec","user_id":"user123","credit_limit":"500","card_number":"0316161531489110","available_balance":"500"}	2024-11-07 15:04:46.216812
14	ledger.entry.created	{"id":"ebd93ec7-6d7a-4653-92cf-46dd4bf588ab","account_id":"b6b5f3b6-5a44-4cab-9fc7-3205e2c7ccec","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1730972086,"nanos":214166149},"version":1}	2024-11-07 15:04:46.23169
15	card.issued	{"card_id":"f0fc96cb-27f7-4995-a2de-60cec36991e3","user_id":"newUser","credit_limit":"500","card_number":"6519965772129914","available_balance":"500"}	2024-11-07 15:39:28.404522
16	card.issued	{"card_id":"f0fc96cb-27f7-4995-a2de-60cec36991e3","user_id":"newUser","credit_limit":"500","card_number":"6519965772129914","available_balance":"500"}	2024-11-07 15:39:28.40437
17	ledger.entry.created	{"id":"db63aad6-7ce8-408b-9991-0edc3c99c2f2","account_id":"f0fc96cb-27f7-4995-a2de-60cec36991e3","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1730974168,"nanos":394317646},"version":1}	2024-11-07 15:39:28.729221
18	ledger.entry.created	{"id":"db63aad6-7ce8-408b-9991-0edc3c99c2f2","account_id":"f0fc96cb-27f7-4995-a2de-60cec36991e3","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1730974168,"nanos":394317646},"version":1}	2024-11-07 15:39:28.773117
19	card.issued	{"card_id":"81e0356c-6575-4edd-bd9d-13bd9fe180c1","user_id":"newUser","credit_limit":"500","card_number":"8115897717298839","available_balance":"500"}	2024-11-07 15:40:50.777927
20	ledger.entry.created	{"id":"93c53f8e-034f-442d-bedf-4850020621a1","account_id":"81e0356c-6575-4edd-bd9d-13bd9fe180c1","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1730974250,"nanos":774949674},"version":1}	2024-11-07 15:40:50.866604
21	card.issued	{"card_id":"ba56cc9b-47ec-4d85-aa53-87a0390cb6c2","user_id":"newUser","credit_limit":"500","card_number":"7649948573917593","available_balance":"500"}	2024-11-07 15:48:10.457897
22	ledger.entry.created	{"id":"c722c99c-3b9b-4f7f-9682-b9d555664b65","account_id":"ba56cc9b-47ec-4d85-aa53-87a0390cb6c2","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1730974690,"nanos":452610325},"version":1}	2024-11-07 15:48:10.474153
23	transaction.created	{"id":"01df8ce4-4034-4279-a5fd-671e8462a449","card_id":"ba56cc9b-47ec-4d85-aa53-87a0390cb6c2","amount":"677652","currency":"INR","type":"credit","status":"pending","reference_number":"REF20241107130503","created_at":{"seconds":1730984703,"nanos":223796052},"updated_at":{"seconds":1730984703,"nanos":223798553}}	2024-11-07 18:35:03.268573
24	transaction.created	{"id":"064eb9c2-3efe-4947-bf6f-3d728aaca471","card_id":"ba56cc9b-47ec-4d85-aa53-87a0390cb6c2","amount":"12234566321","currency":"INR","type":"debit","status":"success","reference_number":"REF20241108050139","created_at":{"seconds":1731042099,"nanos":705122159},"updated_at":{"seconds":1731042099,"nanos":705124060}}	2024-11-08 10:31:39.889929
25	transaction.created	{"id":"064eb9c2-3efe-4947-bf6f-3d728aaca471","card_id":"ba56cc9b-47ec-4d85-aa53-87a0390cb6c2","amount":"12234566321","currency":"INR","type":"debit","status":"success","reference_number":"REF20241108050139","created_at":{"seconds":1731042099,"nanos":705122159},"updated_at":{"seconds":1731042099,"nanos":705124060}}	2024-11-08 10:31:39.901128
26	transaction.created	{"id":"b0038577-109c-4580-87a5-8bbc16a65c39","card_id":"b6be27c4-f0ec-4640-9f79-096600c81ba4","amount":"10089","currency":"INR","type":"CREDIT","status":"success","reference_number":"REF20241108091247","created_at":{"seconds":1731057167,"nanos":489359244},"updated_at":{"seconds":1731057167,"nanos":489359544}}	2024-11-08 14:42:47.515716
27	transaction.created	{"id":"b0038577-109c-4580-87a5-8bbc16a65c39","card_id":"b6be27c4-f0ec-4640-9f79-096600c81ba4","amount":"10089","currency":"INR","type":"CREDIT","status":"success","reference_number":"REF20241108091247","created_at":{"seconds":1731057167,"nanos":489359244},"updated_at":{"seconds":1731057167,"nanos":489359544}}	2024-11-08 14:42:47.515741
28	ledger.entry.created	{"id":"bf635c5e-2195-4ca3-9279-e1cfffc63372","account_id":"b6be27c4-f0ec-4640-9f79-096600c81ba4","entry_type":"CREDIT","amount":"10089","balance_after":"10589.00","status":"success","created_at":{"seconds":1731057167,"nanos":619614808},"version":1}	2024-11-08 14:42:47.626037
29	ledger.entry.created	{"id":"bf635c5e-2195-4ca3-9279-e1cfffc63372","account_id":"b6be27c4-f0ec-4640-9f79-096600c81ba4","entry_type":"CREDIT","amount":"10089","balance_after":"10589.00","status":"success","created_at":{"seconds":1731057167,"nanos":619614808},"version":1}	2024-11-08 14:42:47.626123
30	card.issued	{"card_id":"2e255443-eb4e-4a1f-96cb-44737f76b05e","user_id":"newUser","credit_limit":"500","card_number":"0348978533091121","available_balance":"500"}	2024-11-08 15:20:37.34813
31	ledger.entry.created	{"id":"1bb9ff4e-757e-455d-8fd5-3d978fe7230b","account_id":"2e255443-eb4e-4a1f-96cb-44737f76b05e","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1731059437,"nanos":364716062},"version":1}	2024-11-08 15:20:37.373131
32	transaction.created	{"id":"3f9fd955-aec4-4f99-ba15-b06cc867464b","card_id":"2e255443-eb4e-4a1f-96cb-44737f76b05e","amount":"100","currency":"INR","type":"CREDIT","status":"success","reference_number":"REF20241108095042","created_at":{"seconds":1731059442,"nanos":126754399},"updated_at":{"seconds":1731059442,"nanos":126754999}}	2024-11-08 15:20:42.139314
33	ledger.entry.created	{"id":"568a06cc-082f-48af-a3ca-9b451f7fe66d","account_id":"2e255443-eb4e-4a1f-96cb-44737f76b05e","entry_type":"CREDIT","amount":"100","balance_after":"600.00","status":"success","created_at":{"seconds":1731059442,"nanos":142670505},"version":1}	2024-11-08 15:20:42.145808
34	transaction.created	{"id":"8bba0a08-6f77-4e52-9a2c-58d29a64489a","card_id":"2e255443-eb4e-4a1f-96cb-44737f76b05e","amount":"12","currency":"INR","type":"CREDIT","status":"success","reference_number":"REF20241108095605","created_at":{"seconds":1731059765,"nanos":829542560},"updated_at":{"seconds":1731059765,"nanos":829542860}}	2024-11-08 15:26:05.834417
35	ledger.entry.created	{"id":"063a6683-238f-4c09-be65-916c4440f13d","account_id":"2e255443-eb4e-4a1f-96cb-44737f76b05e","entry_type":"CREDIT","amount":"12","balance_after":"612.00","status":"success","created_at":{"seconds":1731059765,"nanos":838627087},"version":1}	2024-11-08 15:26:05.8426
37	transaction.created	{"id":"14802114-c571-464c-bcdb-1e124cdb0e5b","card_id":"b6be27c4-f0ec-4640-9f79-096600c81ba4","amount":"100","currency":"INR","type":"CREDIT","status":"success","reference_number":"REF20241108131246","created_at":{"seconds":1731071566,"nanos":863268674},"updated_at":{"seconds":1731071566,"nanos":863269274}}	2024-11-08 18:42:46.871393
36	transaction.created	{"id":"14802114-c571-464c-bcdb-1e124cdb0e5b","card_id":"b6be27c4-f0ec-4640-9f79-096600c81ba4","amount":"100","currency":"INR","type":"CREDIT","status":"success","reference_number":"REF20241108131246","created_at":{"seconds":1731071566,"nanos":863268674},"updated_at":{"seconds":1731071566,"nanos":863269274}}	2024-11-08 18:42:46.87138
38	ledger.entry.created	{"id":"d3c07efe-31b3-4894-ade7-6719635df73b","account_id":"b6be27c4-f0ec-4640-9f79-096600c81ba4","entry_type":"CREDIT","amount":"100","balance_after":"20789.00","status":"success","created_at":{"seconds":1731071566,"nanos":875473129},"version":1}	2024-11-08 18:42:46.880653
39	ledger.entry.created	{"id":"d3c07efe-31b3-4894-ade7-6719635df73b","account_id":"b6be27c4-f0ec-4640-9f79-096600c81ba4","entry_type":"CREDIT","amount":"100","balance_after":"20789.00","status":"success","created_at":{"seconds":1731071566,"nanos":875473129},"version":1}	2024-11-08 18:42:46.880657
41	card.issued	{"card_id":"0715cd47-19fb-42de-bdb5-0e1bdc8789e5","user_id":"newUser","credit_limit":"500","card_number":"6674221466475072","available_balance":"500"}	2024-11-08 19:32:24.672637
40	card.issued	{"card_id":"0715cd47-19fb-42de-bdb5-0e1bdc8789e5","user_id":"newUser","credit_limit":"500","card_number":"6674221466475072","available_balance":"500"}	2024-11-08 19:32:24.672916
42	ledger.entry.created	{"id":"e616ef03-ead8-4ea1-a582-28016d0b395a","account_id":"0715cd47-19fb-42de-bdb5-0e1bdc8789e5","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1731074544,"nanos":708487283},"version":1}	2024-11-08 19:32:24.726878
43	ledger.entry.created	{"id":"e616ef03-ead8-4ea1-a582-28016d0b395a","account_id":"0715cd47-19fb-42de-bdb5-0e1bdc8789e5","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1731074544,"nanos":708487283},"version":1}	2024-11-08 19:32:24.727225
44	transaction.created	{"id":"ab231a6c-c5c4-4dd0-9667-43defa86c3f0","card_id":"0715cd47-19fb-42de-bdb5-0e1bdc8789e5","amount":"100","currency":"INR","type":"CREDIT","status":"success","reference_number":"REF20241108140232","created_at":{"seconds":1731074552,"nanos":897789002},"updated_at":{"seconds":1731074552,"nanos":897790203}}	2024-11-08 19:32:32.954548
45	transaction.created	{"id":"ab231a6c-c5c4-4dd0-9667-43defa86c3f0","card_id":"0715cd47-19fb-42de-bdb5-0e1bdc8789e5","amount":"100","currency":"INR","type":"CREDIT","status":"success","reference_number":"REF20241108140232","created_at":{"seconds":1731074552,"nanos":897789002},"updated_at":{"seconds":1731074552,"nanos":897790203}}	2024-11-08 19:32:32.957573
46	ledger.entry.created	{"id":"9c79e09d-2e79-4010-a319-88b38af7d8ee","account_id":"0715cd47-19fb-42de-bdb5-0e1bdc8789e5","entry_type":"CREDIT","amount":"100","balance_after":"600.00","status":"success","created_at":{"seconds":1731074553,"nanos":51746564},"version":1}	2024-11-08 19:32:33.112929
47	ledger.entry.created	{"id":"9c79e09d-2e79-4010-a319-88b38af7d8ee","account_id":"0715cd47-19fb-42de-bdb5-0e1bdc8789e5","entry_type":"CREDIT","amount":"100","balance_after":"600.00","status":"success","created_at":{"seconds":1731074553,"nanos":51746564},"version":1}	2024-11-08 19:32:33.113569
48	card.issued	{"card_id":"feacd22a-427d-4bf3-a147-33273202a376","user_id":"newUser","credit_limit":"500","card_number":"7649948573917593","available_balance":"500"}	2024-11-08 19:33:06.25688
49	card.issued	{"card_id":"feacd22a-427d-4bf3-a147-33273202a376","user_id":"newUser","credit_limit":"500","card_number":"7649948573917593","available_balance":"500"}	2024-11-08 19:33:06.256914
50	ledger.entry.created	{"id":"60bf9b97-3855-4ee0-80b0-9e92e34f45ff","account_id":"feacd22a-427d-4bf3-a147-33273202a376","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1731074586,"nanos":255169616},"version":1}	2024-11-08 19:33:06.263147
51	ledger.entry.created	{"id":"60bf9b97-3855-4ee0-80b0-9e92e34f45ff","account_id":"feacd22a-427d-4bf3-a147-33273202a376","entry_type":"CREDIT","amount":"500","balance_after":"500","status":"success","created_at":{"seconds":1731074586,"nanos":255169616},"version":1}	2024-11-08 19:33:06.263171
52	transaction.created	{"id":"3a289e40-556d-4ac6-be1e-068db71c50a7","card_id":"feacd22a-427d-4bf3-a147-33273202a376","amount":"600","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108140322","created_at":{"seconds":1731074602,"nanos":133968225},"updated_at":{"seconds":1731074602,"nanos":133968625}}	2024-11-08 19:33:22.137928
53	transaction.created	{"id":"3a289e40-556d-4ac6-be1e-068db71c50a7","card_id":"feacd22a-427d-4bf3-a147-33273202a376","amount":"600","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108140322","created_at":{"seconds":1731074602,"nanos":133968225},"updated_at":{"seconds":1731074602,"nanos":133968625}}	2024-11-08 19:33:22.138019
54	transaction.created	{"id":"26cdd498-654b-4fd8-9463-a733b868efbd","card_id":"feacd22a-427d-4bf3-a147-33273202a376","amount":"100","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108140326","created_at":{"seconds":1731074606,"nanos":829360874},"updated_at":{"seconds":1731074606,"nanos":829361474}}	2024-11-08 19:33:26.843908
56	ledger.entry.created	{"id":"c6890427-94e6-4661-9997-4f3577133157","account_id":"feacd22a-427d-4bf3-a147-33273202a376","entry_type":"DEBIT","amount":"100","balance_after":"400.00","status":"success","created_at":{"seconds":1731074606,"nanos":848236215},"version":1}	2024-11-08 19:33:26.853145
55	transaction.created	{"id":"26cdd498-654b-4fd8-9463-a733b868efbd","card_id":"feacd22a-427d-4bf3-a147-33273202a376","amount":"100","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108140326","created_at":{"seconds":1731074606,"nanos":829360874},"updated_at":{"seconds":1731074606,"nanos":829361474}}	2024-11-08 19:33:26.843991
57	ledger.entry.created	{"id":"c6890427-94e6-4661-9997-4f3577133157","account_id":"feacd22a-427d-4bf3-a147-33273202a376","entry_type":"DEBIT","amount":"100","balance_after":"400.00","status":"success","created_at":{"seconds":1731074606,"nanos":848236215},"version":1}	2024-11-08 19:33:26.853133
58	card.issued	{"card_id":"50765933-9d7d-4201-bef0-6b41b9a9c82d","user_id":"newUser","credit_limit":"1000","card_number":"0049827648710176","available_balance":"1000"}	2024-11-08 19:39:01.63281
59	card.issued	{"card_id":"50765933-9d7d-4201-bef0-6b41b9a9c82d","user_id":"newUser","credit_limit":"1000","card_number":"0049827648710176","available_balance":"1000"}	2024-11-08 19:39:01.632671
60	ledger.entry.created	{"id":"e6cd758f-bb5f-4622-9b01-024b0eea4f09","account_id":"50765933-9d7d-4201-bef0-6b41b9a9c82d","entry_type":"CREDIT","amount":"1000","balance_after":"1000","status":"success","created_at":{"seconds":1731074941,"nanos":627582345},"version":1}	2024-11-08 19:39:01.79304
61	ledger.entry.created	{"id":"e6cd758f-bb5f-4622-9b01-024b0eea4f09","account_id":"50765933-9d7d-4201-bef0-6b41b9a9c82d","entry_type":"CREDIT","amount":"1000","balance_after":"1000","status":"success","created_at":{"seconds":1731074941,"nanos":627582345},"version":1}	2024-11-08 19:39:01.793068
62	transaction.created	{"id":"a0cf1cbe-b9be-45ee-9edc-c98be3eff74b","card_id":"50765933-9d7d-4201-bef0-6b41b9a9c82d","amount":"12","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108140908","created_at":{"seconds":1731074948,"nanos":545735025},"updated_at":{"seconds":1731074948,"nanos":545735225}}	2024-11-08 19:39:08.55002
63	transaction.created	{"id":"a0cf1cbe-b9be-45ee-9edc-c98be3eff74b","card_id":"50765933-9d7d-4201-bef0-6b41b9a9c82d","amount":"12","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108140908","created_at":{"seconds":1731074948,"nanos":545735025},"updated_at":{"seconds":1731074948,"nanos":545735225}}	2024-11-08 19:39:08.550415
64	ledger.entry.created	{"id":"df85ec32-2805-421d-a019-6219c5d81a4d","account_id":"50765933-9d7d-4201-bef0-6b41b9a9c82d","entry_type":"DEBIT","amount":"12","balance_after":"988.00","status":"success","created_at":{"seconds":1731074948,"nanos":552718102},"version":1}	2024-11-08 19:39:08.557076
65	ledger.entry.created	{"id":"df85ec32-2805-421d-a019-6219c5d81a4d","account_id":"50765933-9d7d-4201-bef0-6b41b9a9c82d","entry_type":"DEBIT","amount":"12","balance_after":"988.00","status":"success","created_at":{"seconds":1731074948,"nanos":552718102},"version":1}	2024-11-08 19:39:08.557054
66	transaction.created	{"id":"1f317c44-babe-4533-86b4-cabd8c161e25","card_id":"50765933-9d7d-4201-bef0-6b41b9a9c82d","amount":"2000","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108140917","created_at":{"seconds":1731074957,"nanos":605186713},"updated_at":{"seconds":1731074957,"nanos":605187013}}	2024-11-08 19:39:17.633766
67	transaction.created	{"id":"1f317c44-babe-4533-86b4-cabd8c161e25","card_id":"50765933-9d7d-4201-bef0-6b41b9a9c82d","amount":"2000","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108140917","created_at":{"seconds":1731074957,"nanos":605186713},"updated_at":{"seconds":1731074957,"nanos":605187013}}	2024-11-08 19:39:17.633761
68	card.issued	{"card_id":"f129090c-9780-430c-93c1-63b9eb26e9b0","user_id":"newUser","credit_limit":"1000","card_number":"1242133954859883","available_balance":"1000"}	2024-11-08 20:01:06.227729
69	card.issued	{"card_id":"f129090c-9780-430c-93c1-63b9eb26e9b0","user_id":"newUser","credit_limit":"1000","card_number":"1242133954859883","available_balance":"1000"}	2024-11-08 20:01:06.227629
70	ledger.entry.created	{"id":"06878c9f-1c62-4df2-881c-d2b5b0a07035","account_id":"f129090c-9780-430c-93c1-63b9eb26e9b0","entry_type":"CREDIT","amount":"1000","balance_after":"1000","status":"success","created_at":{"seconds":1731076266,"nanos":224123653},"version":1}	2024-11-08 20:01:06.333691
71	ledger.entry.created	{"id":"06878c9f-1c62-4df2-881c-d2b5b0a07035","account_id":"f129090c-9780-430c-93c1-63b9eb26e9b0","entry_type":"CREDIT","amount":"1000","balance_after":"1000","status":"success","created_at":{"seconds":1731076266,"nanos":224123653},"version":1}	2024-11-08 20:01:06.336703
72	transaction.created	{"id":"c04eca74-dfa4-492e-9e88-79d7733dad84","card_id":"f129090c-9780-430c-93c1-63b9eb26e9b0","amount":"2000","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108143111","created_at":{"seconds":1731076271,"nanos":41236664},"updated_at":{"seconds":1731076271,"nanos":41237264}}	2024-11-08 20:01:11.053288
73	transaction.created	{"id":"c04eca74-dfa4-492e-9e88-79d7733dad84","card_id":"f129090c-9780-430c-93c1-63b9eb26e9b0","amount":"2000","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108143111","created_at":{"seconds":1731076271,"nanos":41236664},"updated_at":{"seconds":1731076271,"nanos":41237264}}	2024-11-08 20:01:11.053976
74	transaction.created	{"id":"54ae38fe-0713-445a-97fb-213b8d1b6444","card_id":"f129090c-9780-430c-93c1-63b9eb26e9b0","amount":"2000","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108143112","created_at":{"seconds":1731076272,"nanos":101682006},"updated_at":{"seconds":1731076272,"nanos":101682806}}	2024-11-08 20:01:12.117398
75	transaction.created	{"id":"54ae38fe-0713-445a-97fb-213b8d1b6444","card_id":"f129090c-9780-430c-93c1-63b9eb26e9b0","amount":"2000","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108143112","created_at":{"seconds":1731076272,"nanos":101682006},"updated_at":{"seconds":1731076272,"nanos":101682806}}	2024-11-08 20:01:12.117419
76	transaction.created	{"id":"1fc3e95c-cf1a-4636-af8f-2119980029f6","card_id":"0715cd47-19fb-42de-bdb5-0e1bdc8789e5","amount":"10000","currency":"INR","type":"CREDIT","status":"success","reference_number":"REF20241108145219","created_at":{"seconds":1731077539,"nanos":998490596},"updated_at":{"seconds":1731077539,"nanos":998490997}}	2024-11-08 20:22:20.011533
77	transaction.created	{"id":"1fc3e95c-cf1a-4636-af8f-2119980029f6","card_id":"0715cd47-19fb-42de-bdb5-0e1bdc8789e5","amount":"10000","currency":"INR","type":"CREDIT","status":"success","reference_number":"REF20241108145219","created_at":{"seconds":1731077539,"nanos":998490596},"updated_at":{"seconds":1731077539,"nanos":998490997}}	2024-11-08 20:22:20.011501
78	ledger.entry.created	{"id":"9c133ea9-4d27-46d0-8c40-2cb9c5ae7881","account_id":"0715cd47-19fb-42de-bdb5-0e1bdc8789e5","entry_type":"CREDIT","amount":"10000","balance_after":"800.00","status":"success","created_at":{"seconds":1731077540,"nanos":49590554},"version":1}	2024-11-08 20:22:20.051962
79	ledger.entry.created	{"id":"9c133ea9-4d27-46d0-8c40-2cb9c5ae7881","account_id":"0715cd47-19fb-42de-bdb5-0e1bdc8789e5","entry_type":"CREDIT","amount":"10000","balance_after":"800.00","status":"success","created_at":{"seconds":1731077540,"nanos":49590554},"version":1}	2024-11-08 20:22:20.051995
80	transaction.created	{"id":"8c472e3e-2b48-4449-99b2-4357cee850fc","card_id":"f129090c-9780-430c-93c1-63b9eb26e9b0","amount":"100","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108164704","created_at":{"seconds":1731084424,"nanos":292906890},"updated_at":{"seconds":1731084424,"nanos":292907090}}	2024-11-08 22:17:04.305124
81	ledger.entry.created	{"id":"6ba9f75e-443d-4d36-9798-41283e08b5f8","account_id":"f129090c-9780-430c-93c1-63b9eb26e9b0","entry_type":"DEBIT","amount":"100","balance_after":"900.00","status":"success","created_at":{"seconds":1731084424,"nanos":801355078},"version":1}	2024-11-08 22:17:04.809632
82	transaction.created	{"id":"64d24cea-db9a-4e64-ba85-ee350c3c6db0","card_id":"f129090c-9780-430c-93c1-63b9eb26e9b0","amount":"100","currency":"INR","type":"DEBIT","status":"success","reference_number":"REF20241108164717","created_at":{"seconds":1731084437,"nanos":27635092},"updated_at":{"seconds":1731084437,"nanos":27635292}}	2024-11-08 22:17:17.030591
83	ledger.entry.created	{"id":"f6401d75-91bb-44b3-9869-b39da9d60abe","account_id":"f129090c-9780-430c-93c1-63b9eb26e9b0","entry_type":"DEBIT","amount":"100","balance_after":"800.00","status":"success","created_at":{"seconds":1731084437,"nanos":33963983},"version":1}	2024-11-08 22:17:17.036852
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (id, card_id, amount, currency, type, status, reference_number, created_at, updated_at, settled_at) FROM stdin;
3c9cec3c-6888-4952-9187-ab41fb051d7b	e03482b6-979a-41a2-afbe-752a3315f398	15000.00	INR	purchase	completed	REF20241102122650	2024-11-02 06:56:50.526764	2024-11-02 12:23:59.103634	2024-11-02 19:03:39.0782
dcf8a865-acc2-4125-ad81-ef7aec9f2f27	e03482b6-979a-41a2-afbe-752a3315f398	25000.00	INR	purchase	completed	REF20241102123708	2024-11-02 07:07:08.431953	2024-11-02 12:24:24.094793	2024-11-02 19:03:39.104938
9b68770b-9635-41e0-930c-6c7ac4dab7c7	e03482b6-979a-41a2-afbe-752a3315f398	10000.00	INR	purchase	success	REF20241102175935	2024-11-02 12:29:35.115567	2024-11-02 12:29:35.115567	2024-11-02 19:03:39.105711
5e91ffff-6b54-40cc-995a-c796ef4dbe73	e03482b6-979a-41a2-afbe-752a3315f398	10000.00	INR	purchase	completed	REF20241102175727	2024-11-02 12:27:27.863663	2024-11-02 13:03:54.142085	2024-11-02 19:07:49.80092
fe590ac8-3eff-48c2-9379-3c277fa8f040	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	success	REF20241105171956	2024-11-05 11:49:56.686799	2024-11-05 11:49:56.686799	\N
9a13d97e-1e37-4511-afd5-5efeb505faa4	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	success	REF20241105181919	2024-11-05 12:49:19.670396	2024-11-05 12:49:19.670396	\N
a8e6f340-b9db-4217-ac22-ef2d998c5fd7	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	success	REF20241105183325	2024-11-05 13:03:25.675495	2024-11-05 13:03:25.692595	2024-11-05 18:33:25.691386
b24ef712-2875-47ed-ad33-78463702e73a	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	success	REF20241105183655	2024-11-05 13:06:55.389937	2024-11-05 13:06:55.396701	2024-11-05 18:36:55.395446
c4a2303d-1aaf-40ce-bcf5-e549d5cbe12c	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	success	REF20241105194429	2024-11-05 14:14:29.324994	2024-11-05 14:14:29.352326	2024-11-05 19:44:29.351299
c8785d2a-cb1d-4fb2-bdda-17434b710d1a	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	success	REF20241105194752	2024-11-05 14:17:52.9955	2024-11-05 14:17:53.013753	2024-11-05 19:47:53.011333
e493a122-7e2a-435b-a8ea-b29cd5c84062	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	success	REF20241105201202	2024-11-05 14:42:02.629237	2024-11-05 14:42:02.646633	2024-11-05 20:12:02.644097
0ed105c6-afec-4439-b5a7-22dc7a1cd06e	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	success	REF20241105201237	2024-11-05 14:42:37.096731	2024-11-05 14:42:37.111645	2024-11-05 20:12:37.108516
d1e5e577-64a1-45aa-adf5-c955439b0add	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	success	REF20241105201502	2024-11-05 14:45:02.85361	2024-11-05 14:45:02.87095	2024-11-05 20:15:02.868041
b1e298e7-b5ff-4d97-9f41-9258f57af64a	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241105201855	2024-11-05 14:48:55.858443	2024-11-05 14:48:55.858443	\N
3a37e1a0-4d08-4131-a18b-5996b2837da6	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241105202051	2024-11-05 14:50:51.728627	2024-11-05 14:50:51.728627	\N
c9b4f9f5-4fb5-43e9-954f-95d62c5d0840	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241105202126	2024-11-05 14:51:26.667532	2024-11-05 14:51:26.667532	\N
47639a18-e92b-4ee5-8da3-8efb8f50b925	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241105202819	2024-11-05 14:58:19.787541	2024-11-05 14:58:19.787541	\N
37e92516-ce4d-4af5-b80e-76f1287d70a3	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241105233200	2024-11-05 18:02:00.723287	2024-11-05 18:02:00.723287	\N
13f54380-36a7-4ea6-b083-9a560c07d409	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241105233407	2024-11-05 18:04:07.57244	2024-11-05 18:04:07.57244	\N
676803f8-cd3f-4449-bc38-5c5d6fcddfdd	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241105234002	2024-11-05 18:10:02.568172	2024-11-05 18:10:02.568172	\N
fca6b758-bbf7-4832-8a87-be1b257e27c1	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241105234017	2024-11-05 18:10:17.702715	2024-11-05 18:10:17.702715	\N
6d3f277f-fa48-49e5-bd8f-a0cbf445427d	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241105234042	2024-11-05 18:10:42.777114	2024-11-05 18:10:42.777114	\N
1f5eaf35-77cb-4c19-b86a-0bd0087c0376	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241105235630	2024-11-05 18:26:30.744292	2024-11-05 18:26:30.744292	\N
291edfe0-124a-472b-b1fe-450462bcc7c9	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241106000637	2024-11-05 18:36:37.654348	2024-11-05 18:36:37.654348	\N
5e9012bb-fb6e-4136-b1b8-7ee5649a05d7	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241106000954	2024-11-05 18:39:54.939768	2024-11-05 18:39:54.939768	\N
693cc984-e8cb-4d13-8f77-60b10ca7156b	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241106001041	2024-11-05 18:40:41.996678	2024-11-05 18:40:41.996678	\N
8db6932d-6be6-4aaa-a190-4371c0fc85fc	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241106001339	2024-11-05 18:43:39.11167	2024-11-05 18:43:39.11167	\N
6c33a489-0152-4057-90d5-1dde29f89ab0	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	CREDIT	pending	REF20241106001401	2024-11-05 18:44:01.792829	2024-11-05 18:44:01.792829	\N
4db1cfce-783a-4f9d-a84b-98b49848f8ae	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	CREDIT	pending	REF20241106001407	2024-11-05 18:44:07.320825	2024-11-05 18:44:07.320825	\N
b4c48595-7ae9-45d1-98c6-eb18983d152c	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	CREDIT	pending	REF20241106001415	2024-11-05 18:44:15.314754	2024-11-05 18:44:15.314754	\N
f2bb4bd0-cbd7-4f84-93b9-9a60ece193a9	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241106001422	2024-11-05 18:44:22.915464	2024-11-05 18:44:22.915464	\N
5aa357bd-0cda-4ec3-a3c8-a453588679da	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241106143552	2024-11-06 09:05:52.430805	2024-11-06 09:05:52.430805	\N
7cbbc750-93cb-45b9-b11b-46b1ba270156	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	DEBIT	pending	REF20241106143615	2024-11-06 09:06:15.456064	2024-11-06 09:06:15.456064	\N
4bd7922f-fda7-4e69-87cb-370684fd991c	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	CREDIT	pending	REF20241106143712	2024-11-06 09:07:12.085797	2024-11-06 09:07:12.085797	\N
5d218833-8850-4d5d-98de-7442e11e3dff	e03482b6-979a-41a2-afbe-752a3315f398	500.00	INR	CREDIT	pending	REF20241106143720	2024-11-06 09:07:20.263763	2024-11-06 09:07:20.263763	\N
a16160ec-f91e-44ce-af23-a18f7b8a4e7f	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	333.00	INR	CREDIT	pending	REF20241107124514	2024-11-07 12:45:14.400332	2024-11-07 12:45:14.400333	\N
66e64f9c-5d78-42f7-8fb8-ea6f542b2134	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	120.00	INR	credit	pending	REF20241107125015	2024-11-07 12:50:15.031787	2024-11-07 12:50:15.031788	\N
e3d8e081-92e1-4d73-a853-92091ca48394	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	120.00	INR	debit	pending	REF20241107125152	2024-11-07 12:51:52.094362	2024-11-07 12:51:52.094363	\N
a82469cc-05d1-4efd-9cab-5d6459d08246	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	12345.00	INR	debit	pending	REF20241107125159	2024-11-07 12:51:59.433719	2024-11-07 12:51:59.433719	\N
e944b820-74bd-4808-be24-1025ba8f2766	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	12345.00	INR	debit	pending	REF20241107125210	2024-11-07 12:52:10.762293	2024-11-07 12:52:10.762294	\N
01df8ce4-4034-4279-a5fd-671e8462a449	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	677652.00	INR	credit	pending	REF20241107130503	2024-11-07 13:05:03.223796	2024-11-07 13:05:03.223799	\N
95266af6-cb3e-4463-8f8a-e7f824a0ebee	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	12.00	INR	debit	pending	REF20241107130909	2024-11-07 13:09:09.674298	2024-11-07 13:09:09.674299	\N
51f46617-9cef-4921-94be-77359816e8eb	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	89.00	INR	debit	success	REF20241107131518	2024-11-07 13:15:18.609649	2024-11-07 13:15:18.60965	\N
064eb9c2-3efe-4947-bf6f-3d728aaca471	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	12234566321.00	INR	debit	success	REF20241108050139	2024-11-08 05:01:39.705122	2024-11-08 05:01:39.705124	\N
1306f0d8-7ba4-4a64-b226-5563662fdefe	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	12234566321.00	INR	debit	success	REF20241108050202	2024-11-08 05:02:02.623793	2024-11-08 05:02:02.623794	\N
b3c7d2ef-a7ea-4cf2-9de7-b0d6d4db51bf	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	1233455678.00	INR	CREDIT	success	REF20241108050929	2024-11-08 05:09:29.056166	2024-11-08 05:09:29.056167	\N
0b9fe4a0-ac4c-4ecd-9778-e02cecd675b9	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	123456789.00	INR	DEBIT	success	REF20241108050955	2024-11-08 05:09:55.630293	2024-11-08 05:09:55.630295	\N
fcd2c28e-52ff-4b8d-ab7b-f107ae60f823	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	1000.00	INR	CREDIT	success	REF20241108054823	2024-11-08 05:48:23.990615	2024-11-08 05:48:23.990616	\N
e9eb8280-22fe-4868-ab8c-d4ac4f8cd8f8	ba56cc9b-47ec-4d85-aa53-87a0390cb6c2	100.00	INR	CREDIT	success	REF20241108061554	2024-11-08 06:15:54.680963	2024-11-08 06:15:54.680964	\N
b0038577-109c-4580-87a5-8bbc16a65c39	b6be27c4-f0ec-4640-9f79-096600c81ba4	10089.00	INR	CREDIT	success	REF20241108091247	2024-11-08 09:12:47.489359	2024-11-08 09:12:47.48936	\N
687090ab-6ad9-4ea5-b0e7-f66cd9322f88	0cb6a8b2-b122-4145-8270-b6fa70f222a8	100.00	INR	CREDIT	success	REF20241108094637	2024-11-08 09:46:37.765152	2024-11-08 09:46:37.765152	\N
3f9fd955-aec4-4f99-ba15-b06cc867464b	2e255443-eb4e-4a1f-96cb-44737f76b05e	100.00	INR	CREDIT	success	REF20241108095042	2024-11-08 09:50:42.126754	2024-11-08 09:50:42.126755	\N
8bba0a08-6f77-4e52-9a2c-58d29a64489a	2e255443-eb4e-4a1f-96cb-44737f76b05e	12.00	INR	CREDIT	success	REF20241108095605	2024-11-08 09:56:05.829543	2024-11-08 09:56:05.829543	\N
89b924ee-a9bb-49a0-bc25-8a35d51677df	2e255443-eb4e-4a1f-96cb-44737f76b05e	20.00	INR	DEBIT	success	REF20241108095820	2024-11-08 09:58:20.412699	2024-11-08 09:58:20.412699	\N
c1c3e23c-6a4c-4eaa-9a5a-8049781f7375	b6be27c4-f0ec-4640-9f79-096600c81ba4	10000.00	INR	CREDIT	success	REF20241108121836	2024-11-08 12:18:36.412059	2024-11-08 12:18:36.412059	\N
d47e8837-f0fa-427c-9caa-e5a635fb99f3	2e255443-eb4e-4a1f-96cb-44737f76b05e	200.00	INR	CREDIT	success	REF20241108123314	2024-11-08 12:33:14.459097	2024-11-08 12:33:14.459097	\N
96789496-cf64-4da4-bcc3-ded2bdfe84bd	2e255443-eb4e-4a1f-96cb-44737f76b05e	12.00	INR	CREDIT	success	REF20241108123854	2024-11-08 12:38:54.573209	2024-11-08 12:38:54.57321	\N
f9484a04-a9d0-468d-8130-60c04e0ce9d5	2e255443-eb4e-4a1f-96cb-44737f76b05e	12.00	INR	CREDIT	success	REF20241108123858	2024-11-08 12:38:58.743835	2024-11-08 12:38:58.743836	\N
844fcdd5-84a5-4e00-a223-2ec6d9b8877c	b6be27c4-f0ec-4640-9f79-096600c81ba4	200.00	INR	CREDIT	success	REF20241108131138	2024-11-08 13:11:38.174105	2024-11-08 13:11:38.174106	\N
907646bb-b48a-45c5-903b-d934305d1381	b6be27c4-f0ec-4640-9f79-096600c81ba4	100.00	INR	DEBIT	success	REF20241108131149	2024-11-08 13:11:49.897974	2024-11-08 13:11:49.897975	\N
14802114-c571-464c-bcdb-1e124cdb0e5b	b6be27c4-f0ec-4640-9f79-096600c81ba4	100.00	INR	CREDIT	success	REF20241108131246	2024-11-08 13:12:46.863269	2024-11-08 13:12:46.863269	\N
6a2e344a-49ad-4434-a705-56d564866bb4	b6be27c4-f0ec-4640-9f79-096600c81ba4	100.00	INR	CREDIT	success	REF20241108131415	2024-11-08 13:14:15.880977	2024-11-08 13:14:15.880978	\N
602a2de6-f1d2-4b94-9fe6-458f21c243e5	b6be27c4-f0ec-4640-9f79-096600c81ba4	300.00	INR	DEBIT	success	REF20241108131424	2024-11-08 13:14:24.079252	2024-11-08 13:14:24.079252	\N
eb5c6e90-aee7-44b5-98d4-9b93a68aa962	b6be27c4-f0ec-4640-9f79-096600c81ba4	200.00	INR	DEBIT	success	REF20241108132904	2024-11-08 13:29:04.509321	2024-11-08 13:29:04.509321	\N
30e9ff07-582c-4afd-bdc2-ab6b1fdfa48d	b6be27c4-f0ec-4640-9f79-096600c81ba4	3000.00	INR	DEBIT	success	REF20241108133004	2024-11-08 13:30:04.918909	2024-11-08 13:30:04.91891	\N
10f759ac-a0c5-4b2d-8ad7-6679b7eb685b	b6be27c4-f0ec-4640-9f79-096600c81ba4	2312.00	INR	DEBIT	success	REF20241108133147	2024-11-08 13:31:47.100567	2024-11-08 13:31:47.100567	\N
68d9681b-1d25-41c6-a4e9-ebe56c237c53	feacd22a-427d-4bf3-a147-33273202a376	5000.00	INR	CREDIT	success	REF20241108140345	2024-11-08 14:03:45.98371	2024-11-08 14:03:45.983711	\N
920e29ac-b369-418d-9878-06c43887a5ad	0715cd47-19fb-42de-bdb5-0e1bdc8789e5	200.00	INR	CREDIT	success	REF20241108140821	2024-11-08 14:08:21.61903	2024-11-08 14:08:21.619031	\N
a0cf1cbe-b9be-45ee-9edc-c98be3eff74b	50765933-9d7d-4201-bef0-6b41b9a9c82d	12.00	INR	DEBIT	success	REF20241108140908	2024-11-08 14:09:08.545735	2024-11-08 14:09:08.545735	\N
247f3b16-2ad5-4df5-8dc7-ddcb8fdab395	b6be27c4-f0ec-4640-9f79-096600c81ba4	22000.00	INR	DEBIT	success	REF20241108132920	2024-11-08 13:29:20.265086	2024-11-08 13:29:20.265086	\N
4b071560-3fdf-4a4c-b230-d13a10417c91	b6be27c4-f0ec-4640-9f79-096600c81ba4	22000.00	INR	DEBIT	success	REF20241108132924	2024-11-08 13:29:24.07866	2024-11-08 13:29:24.078661	\N
d2d51c5f-b03d-4227-8847-50aaff3810bc	b6be27c4-f0ec-4640-9f79-096600c81ba4	22000.00	INR	DEBIT	success	REF20241108132939	2024-11-08 13:29:39.60173	2024-11-08 13:29:39.60173	\N
5e7e9387-da87-4a10-a01c-e879cb1e1cec	2e255443-eb4e-4a1f-96cb-44737f76b05e	1000.00	INR	DEBIT	success	REF20241108133905	2024-11-08 13:39:05.130421	2024-11-08 13:39:05.130422	\N
e7315901-2fb6-4a0b-ae73-236e12a377c6	2e255443-eb4e-4a1f-96cb-44737f76b05e	1000.00	INR	DEBIT	success	REF20241108133908	2024-11-08 13:39:08.882229	2024-11-08 13:39:08.88223	\N
ab231a6c-c5c4-4dd0-9667-43defa86c3f0	0715cd47-19fb-42de-bdb5-0e1bdc8789e5	100.00	INR	CREDIT	success	REF20241108140232	2024-11-08 14:02:32.897789	2024-11-08 14:02:32.89779	\N
3a289e40-556d-4ac6-be1e-068db71c50a7	feacd22a-427d-4bf3-a147-33273202a376	600.00	INR	DEBIT	success	REF20241108140322	2024-11-08 14:03:22.133968	2024-11-08 14:03:22.133969	\N
26cdd498-654b-4fd8-9463-a733b868efbd	feacd22a-427d-4bf3-a147-33273202a376	100.00	INR	DEBIT	success	REF20241108140326	2024-11-08 14:03:26.829361	2024-11-08 14:03:26.829361	\N
1f317c44-babe-4533-86b4-cabd8c161e25	50765933-9d7d-4201-bef0-6b41b9a9c82d	2000.00	INR	DEBIT	success	REF20241108140917	2024-11-08 14:09:17.605187	2024-11-08 14:09:17.605187	\N
635adf99-1a22-416c-9deb-0a0a5e99a1fb	a309117a-865c-4235-b232-8c7ee2ece241	600.00	INR	DEBIT	success	REF20241108141942	2024-11-08 14:19:42.381101	2024-11-08 14:19:42.381101	\N
2305fc9a-9abb-4f54-adab-28cdee58b9aa	a309117a-865c-4235-b232-8c7ee2ece241	600.00	INR	DEBIT	success	REF20241108142002	2024-11-08 14:20:02.720037	2024-11-08 14:20:02.720037	\N
a53fbe37-78fe-43c0-bf92-489d8ecf3cb9	a309117a-865c-4235-b232-8c7ee2ece241	1000.00	INR	CREDIT	success	REF20241108142050	2024-11-08 14:20:50.143286	2024-11-08 14:20:50.143286	\N
c04eca74-dfa4-492e-9e88-79d7733dad84	f129090c-9780-430c-93c1-63b9eb26e9b0	2000.00	INR	DEBIT	failed	REF20241108143111	2024-11-08 14:31:11.041237	2024-11-08 14:31:11.041237	\N
54ae38fe-0713-445a-97fb-213b8d1b6444	f129090c-9780-430c-93c1-63b9eb26e9b0	2000.00	INR	DEBIT	failed	REF20241108143112	2024-11-08 14:31:12.101682	2024-11-08 14:31:12.101683	\N
ea4e617f-045b-4b1a-9330-8949470c1818	0715cd47-19fb-42de-bdb5-0e1bdc8789e5	1000.00	INR	DEBIT	failed	REF20241108143250	2024-11-08 14:32:50.959872	2024-11-08 14:32:50.959872	\N
72dbde87-d089-4585-adc9-22dfaffd722a	0715cd47-19fb-42de-bdb5-0e1bdc8789e5	10000.00	INR	DEBIT	failed	REF20241108145028	2024-11-08 14:50:28.489647	2024-11-08 14:50:28.489647	\N
1fc3e95c-cf1a-4636-af8f-2119980029f6	0715cd47-19fb-42de-bdb5-0e1bdc8789e5	10000.00	INR	CREDIT	success	REF20241108145219	2024-11-08 14:52:19.998491	2024-11-08 14:52:19.998491	\N
c756a024-e6cf-4bb7-985d-0027618d8944	b6be27c4-f0ec-4640-9f79-096600c81ba4	100.00	INR	CREDIT	success	REF20241108145754	2024-11-08 14:57:54.635545	2024-11-08 14:57:54.635545	\N
f52c5ae9-7666-431c-ae43-7217cca4b566	b6be27c4-f0ec-4640-9f79-096600c81ba4	100.00	INR	CREDIT	success	REF20241108145804	2024-11-08 14:58:04.118858	2024-11-08 14:58:04.118859	\N
8c472e3e-2b48-4449-99b2-4357cee850fc	f129090c-9780-430c-93c1-63b9eb26e9b0	100.00	INR	DEBIT	success	REF20241108164704	2024-11-08 16:47:04.292907	2024-11-08 16:47:04.292907	\N
64d24cea-db9a-4e64-ba85-ee350c3c6db0	f129090c-9780-430c-93c1-63b9eb26e9b0	100.00	INR	DEBIT	success	REF20241108164717	2024-11-08 16:47:17.027635	2024-11-08 16:47:17.027635	\N
6c1ea059-769b-4ddd-bc2c-eab1e168af3b	f129090c-9780-430c-93c1-63b9eb26e9b0	50.00	INR	CREDIT	success	REF20241108165033	2024-11-08 16:50:33.720614	2024-11-08 16:50:33.720614	\N
61707f21-5cf8-4278-a6ad-fe3b7091d477	f129090c-9780-430c-93c1-63b9eb26e9b0	50.00	INR	CREDIT	success	REF20241108165109	2024-11-08 16:51:09.278744	2024-11-08 16:51:09.278744	\N
ca6d0b72-5732-4a51-a0d6-eecdccbc11a3	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	100.00	INR	DEBIT	success	REF20241108174915	2024-11-08 17:49:15.802476	2024-11-08 17:49:15.802477	\N
a0963df6-c618-4e21-9d01-0c0f5385eddb	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	100.00	INR	CREDIT	success	REF20241108174927	2024-11-08 17:49:27.721755	2024-11-08 17:49:27.721756	\N
e2ea0aee-58df-47cb-b32a-4531545f7301	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	100.00	INR	DEBIT	success	REF20241108174933	2024-11-08 17:49:33.655007	2024-11-08 17:49:33.655007	\N
103b7cbd-1712-498d-834a-7be4ef8c2195	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	200.00	INR	DEBIT	success	REF20241108174944	2024-11-08 17:49:44.999786	2024-11-08 17:49:44.999787	\N
ea4d961e-6171-429a-b524-047ec45e2a60	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	100.00	INR	CREDIT	success	REF20241108174954	2024-11-08 17:49:54.84017	2024-11-08 17:49:54.840171	\N
4d56a61e-6481-424a-ae5b-054426ee3a98	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	900.00	INR	DEBIT	failed	REF20241108175007	2024-11-08 17:50:07.422052	2024-11-08 17:50:07.422052	\N
11c87a22-5aa2-4087-9a79-0f8c7e18affc	12ffeb59-653d-4f35-b904-fcb5ad6cda6f	8000.00	INR	CREDIT	success	REF20241108175028	2024-11-08 17:50:28.044479	2024-11-08 17:50:28.044479	\N
\.


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 83, true);


--
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: ledger_entries ledger_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledger_entries
    ADD CONSTRAINT ledger_entries_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_reference_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_reference_number_key UNIQUE (reference_number);


--
-- Name: idx_cards_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cards_status ON public.cards USING btree (status);


--
-- Name: idx_ledger_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ledger_account ON public.ledger_entries USING btree (account_id);


--
-- Name: idx_ledger_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ledger_created ON public.ledger_entries USING btree (created_at);


--
-- Name: idx_ledger_transaction; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ledger_transaction ON public.ledger_entries USING btree (transaction_id);


--
-- Name: idx_transactions_card; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transactions_card ON public.transactions USING btree (card_id);


--
-- Name: idx_transactions_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transactions_created ON public.transactions USING btree (created_at);


--
-- Name: idx_transactions_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transactions_status ON public.transactions USING btree (status);


--
-- Name: ledger_entries ledger_entries_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledger_entries
    ADD CONSTRAINT ledger_entries_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(id);


--
-- Name: transactions transactions_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.cards(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

