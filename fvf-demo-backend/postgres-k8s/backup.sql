--
-- PostgreSQL database dump
--

-- Dumped from database version 12.20
-- Dumped by pg_dump version 16.4

-- Started on 2025-01-15 23:15:29

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
-- TOC entry 6 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 16586)
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
    version integer DEFAULT 1,
    cvv character varying(3)
);


ALTER TABLE public.cards OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16649)
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
    CONSTRAINT valid_entry_type CHECK (((entry_type)::text = ANY ((ARRAY['DEBIT'::character varying, 'CREDIT'::character varying])::text[])))
);


ALTER TABLE public.ledger_entries OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 16679)
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
-- TOC entry 205 (class 1259 OID 16677)
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
-- TOC entry 2870 (class 0 OID 0)
-- Dependencies: 205
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- TOC entry 203 (class 1259 OID 16600)
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
-- TOC entry 2711 (class 2604 OID 16682)
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- TOC entry 2859 (class 0 OID 16586)
-- Dependencies: 202
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cards (id, user_id, card_number, status, credit_limit, available_balance, last_transaction_at, expiry_date, created_at, updated_at, version, cvv) FROM stdin;
1076ae65-8c49-4367-9144-945d7e28c249	user_12345	1234567812345678	active	10000.00	5000.00	2025-01-01 12:00:00	2028-12-31	2025-01-15 23:13:12.992848	2025-01-15 23:13:12.992848	1	289
1076ae65-8c49-4367-9144-945d7e28c949	user_12349	1234567812345678	active	10000.00	5000.00	2025-01-01 12:00:00	2028-12-31	2025-01-15 23:14:44.562783	2025-01-15 23:14:44.562783	1	299
\.


--
-- TOC entry 2861 (class 0 OID 16649)
-- Dependencies: 204
-- Data for Name: ledger_entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ledger_entries (id, transaction_id, account_id, entry_type, amount, balance_after, status, created_at, posted_at, version) FROM stdin;
\.


--
-- TOC entry 2863 (class 0 OID 16679)
-- Dependencies: 206
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, event_type, event_data, "timestamp") FROM stdin;
\.


--
-- TOC entry 2860 (class 0 OID 16600)
-- Dependencies: 203
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (id, card_id, amount, currency, type, status, reference_number, created_at, updated_at, settled_at) FROM stdin;
\.


--
-- TOC entry 2871 (class 0 OID 0)
-- Dependencies: 205
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 87678, true);


--
-- TOC entry 2715 (class 2606 OID 16598)
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- TOC entry 2728 (class 2606 OID 16659)
-- Name: ledger_entries ledger_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledger_entries
    ADD CONSTRAINT ledger_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 2730 (class 2606 OID 16688)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 2721 (class 2606 OID 16608)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 2723 (class 2606 OID 16610)
-- Name: transactions transactions_reference_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_reference_number_key UNIQUE (reference_number);


--
-- TOC entry 2716 (class 1259 OID 16599)
-- Name: idx_cards_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cards_status ON public.cards USING btree (status);


--
-- TOC entry 2724 (class 1259 OID 16666)
-- Name: idx_ledger_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ledger_account ON public.ledger_entries USING btree (account_id);


--
-- TOC entry 2725 (class 1259 OID 16667)
-- Name: idx_ledger_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ledger_created ON public.ledger_entries USING btree (created_at);


--
-- TOC entry 2726 (class 1259 OID 16665)
-- Name: idx_ledger_transaction; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ledger_transaction ON public.ledger_entries USING btree (transaction_id);


--
-- TOC entry 2717 (class 1259 OID 16616)
-- Name: idx_transactions_card; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transactions_card ON public.transactions USING btree (card_id);


--
-- TOC entry 2718 (class 1259 OID 16618)
-- Name: idx_transactions_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transactions_created ON public.transactions USING btree (created_at);


--
-- TOC entry 2719 (class 1259 OID 16617)
-- Name: idx_transactions_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transactions_status ON public.transactions USING btree (status);


--
-- TOC entry 2732 (class 2606 OID 16660)
-- Name: ledger_entries ledger_entries_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ledger_entries
    ADD CONSTRAINT ledger_entries_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(id);


--
-- TOC entry 2731 (class 2606 OID 16611)
-- Name: transactions transactions_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.cards(id) ON DELETE CASCADE;


--
-- TOC entry 2869 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2025-01-15 23:15:29

--
-- PostgreSQL database dump complete
--

