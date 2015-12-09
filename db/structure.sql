--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admins (
    id integer NOT NULL,
    uid character varying,
    name character varying,
    email character varying DEFAULT ''::character varying NOT NULL,
    permission integer,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admins_id_seq OWNED BY admins.id;


--
-- Name: bank_accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bank_accounts (
    id integer NOT NULL,
    uid character varying,
    user_id integer,
    nickname character varying,
    stripe_account_id character varying,
    stripe_bank_account_id character varying,
    stripe_bank_account_last4 character varying,
    stripe_fingerprint character varying,
    country character varying,
    currency character varying,
    default_stripe_bank_account boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bank_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bank_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bank_accounts_id_seq OWNED BY bank_accounts.id;


--
-- Name: donations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE donations (
    id integer NOT NULL,
    uid character varying,
    recipient_id integer,
    donor_id integer,
    fund_id integer,
    designated_to integer,
    currency character varying(4),
    amount_in_cents integer,
    stripe_fee_in_cents integer,
    onedonation_fee_in_cents integer,
    aggregated_fee_in_cents integer,
    amount_in_cents_usd integer,
    stripe_fee_in_cents_usd integer,
    onedonation_fee_in_cents_usd integer,
    aggregated_fee_in_cents_usd integer,
    stripe_customer_id character varying,
    stripe_charge_id character varying,
    stripe_source_id character varying,
    stripe_destination character varying,
    stripe_amount_refunded character varying,
    stripe_application_fee_id character varying,
    stripe_balance_transaction jsonb DEFAULT '{}'::jsonb NOT NULL,
    stripe_captured character varying,
    stripe_created character varying,
    stripe_currency character varying,
    stripe_description text,
    stripe_dispute jsonb DEFAULT '{}'::jsonb,
    stripe_failure_code character varying,
    stripe_failure_message character varying,
    stripe_fraud_details jsonb DEFAULT '{}'::jsonb,
    stripe_metadata jsonb DEFAULT '{}'::jsonb,
    stripe_paid character varying,
    stripe_receipt_number character varying,
    stripe_refunded character varying,
    stripe_refunds jsonb DEFAULT '{}'::jsonb,
    stripe_source jsonb DEFAULT '{}'::jsonb NOT NULL,
    stripe_statement_descriptor character varying,
    stripe_status character varying,
    message text,
    anonymous boolean,
    remote_ip character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: donations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE donations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: donations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE donations_id_seq OWNED BY donations.id;


--
-- Name: funds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE funds (
    id integer NOT NULL,
    uid character varying,
    owner_id integer,
    group_fund boolean DEFAULT false,
    name character varying,
    url character varying,
    category integer DEFAULT 0 NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    ends_at date,
    goal integer,
    custom_statement_descriptor character varying,
    description text,
    website character varying,
    receipt_message text,
    thank_you_reply_to character varying,
    thank_you_header character varying,
    thank_you_body text,
    thumbnail character varying,
    header character varying,
    primary_color character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: funds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE funds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: funds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE funds_id_seq OWNED BY funds.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE memberships (
    id integer NOT NULL,
    user_id integer,
    fund_id integer,
    permission integer DEFAULT 1,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE memberships_id_seq OWNED BY memberships.id;


--
-- Name: metadata; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE metadata (
    id integer NOT NULL,
    uid character varying,
    account_id integer,
    user_id integer,
    name character varying,
    meta_type integer,
    meta_sub_type integer,
    custom character varying,
    date date,
    line1 character varying,
    line2 character varying,
    city character varying,
    state character varying,
    postal_code character varying,
    country character varying,
    email_address character varying,
    number character varying,
    username character varying,
    value character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE metadata_id_seq OWNED BY metadata.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    uid character varying,
    username character varying,
    email character varying DEFAULT ''::character varying NOT NULL,
    stripe_customer_id character varying,
    stripe_account_id character varying,
    stripe_default_source character varying,
    stripe_statement_descriptor character varying,
    stripe_tos_acceptance jsonb DEFAULT '{}'::jsonb NOT NULL,
    stripe_legal_entity jsonb DEFAULT '{}'::jsonb NOT NULL,
    stripe_verification jsonb DEFAULT '{}'::jsonb NOT NULL,
    stripe_verification_status integer,
    stripe_currency character varying,
    encrypted_stripe_secret_key character varying,
    encrypted_stripe_publishable_key character varying,
    status integer DEFAULT 0 NOT NULL,
    prefix character varying,
    first_name character varying,
    middle_name character varying,
    last_name character varying,
    suffix character varying,
    age integer,
    gender integer,
    entity_type integer,
    business_name character varying,
    business_url character varying,
    encrypted_business_tax_id character varying,
    encrypted_business_vat_id character varying,
    business_line1 character varying,
    business_line2 character varying,
    business_city character varying,
    business_state character varying,
    business_postal_code character varying,
    business_country character varying,
    user_phone character varying,
    user_line1 character varying,
    user_line2 character varying,
    user_city character varying,
    user_state character varying,
    user_postal_code character varying,
    user_country character varying,
    encrypted_ssn_last_4 character varying,
    dob_month character varying,
    dob_day character varying,
    dob_year character varying,
    timezone character varying,
    account_type integer DEFAULT 0,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admins ALTER COLUMN id SET DEFAULT nextval('admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_accounts ALTER COLUMN id SET DEFAULT nextval('bank_accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY donations ALTER COLUMN id SET DEFAULT nextval('donations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY funds ALTER COLUMN id SET DEFAULT nextval('funds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships ALTER COLUMN id SET DEFAULT nextval('memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY metadata ALTER COLUMN id SET DEFAULT nextval('metadata_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: bank_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_accounts
    ADD CONSTRAINT bank_accounts_pkey PRIMARY KEY (id);


--
-- Name: donations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY donations
    ADD CONSTRAINT donations_pkey PRIMARY KEY (id);


--
-- Name: funds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY funds
    ADD CONSTRAINT funds_pkey PRIMARY KEY (id);


--
-- Name: memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY metadata
    ADD CONSTRAINT metadata_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_admins_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_confirmation_token ON admins USING btree (confirmation_token);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_email ON admins USING btree (email);


--
-- Name: index_admins_on_permission; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_admins_on_permission ON admins USING btree (permission);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON admins USING btree (reset_password_token);


--
-- Name: index_admins_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_uid ON admins USING btree (uid);


--
-- Name: index_admins_on_unlock_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_unlock_token ON admins USING btree (unlock_token);


--
-- Name: index_bank_accounts_on_country; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bank_accounts_on_country ON bank_accounts USING btree (country);


--
-- Name: index_bank_accounts_on_currency; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bank_accounts_on_currency ON bank_accounts USING btree (currency);


--
-- Name: index_bank_accounts_on_default_stripe_bank_account; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bank_accounts_on_default_stripe_bank_account ON bank_accounts USING btree (default_stripe_bank_account);


--
-- Name: index_bank_accounts_on_stripe_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bank_accounts_on_stripe_account_id ON bank_accounts USING btree (stripe_account_id);


--
-- Name: index_bank_accounts_on_stripe_bank_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bank_accounts_on_stripe_bank_account_id ON bank_accounts USING btree (stripe_bank_account_id);


--
-- Name: index_bank_accounts_on_stripe_bank_account_last4; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bank_accounts_on_stripe_bank_account_last4 ON bank_accounts USING btree (stripe_bank_account_last4);


--
-- Name: index_bank_accounts_on_stripe_fingerprint; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bank_accounts_on_stripe_fingerprint ON bank_accounts USING btree (stripe_fingerprint);


--
-- Name: index_bank_accounts_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_bank_accounts_on_uid ON bank_accounts USING btree (uid);


--
-- Name: index_bank_accounts_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bank_accounts_on_user_id ON bank_accounts USING btree (user_id);


--
-- Name: index_donations_on_aggregated_fee_in_cents; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_aggregated_fee_in_cents ON donations USING btree (aggregated_fee_in_cents);


--
-- Name: index_donations_on_aggregated_fee_in_cents_usd; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_aggregated_fee_in_cents_usd ON donations USING btree (aggregated_fee_in_cents_usd);


--
-- Name: index_donations_on_amount_in_cents; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_amount_in_cents ON donations USING btree (amount_in_cents);


--
-- Name: index_donations_on_amount_in_cents_usd; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_amount_in_cents_usd ON donations USING btree (amount_in_cents_usd);


--
-- Name: index_donations_on_anonymous; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_anonymous ON donations USING btree (anonymous);


--
-- Name: index_donations_on_currency; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_currency ON donations USING btree (currency);


--
-- Name: index_donations_on_designated_to; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_designated_to ON donations USING btree (designated_to);


--
-- Name: index_donations_on_donor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_donor_id ON donations USING btree (donor_id);


--
-- Name: index_donations_on_fund_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_fund_id ON donations USING btree (fund_id);


--
-- Name: index_donations_on_onedonation_fee_in_cents; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_onedonation_fee_in_cents ON donations USING btree (onedonation_fee_in_cents);


--
-- Name: index_donations_on_onedonation_fee_in_cents_usd; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_onedonation_fee_in_cents_usd ON donations USING btree (onedonation_fee_in_cents_usd);


--
-- Name: index_donations_on_recipient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_recipient_id ON donations USING btree (recipient_id);


--
-- Name: index_donations_on_remote_ip; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_remote_ip ON donations USING btree (remote_ip);


--
-- Name: index_donations_on_stripe_amount_refunded; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_amount_refunded ON donations USING btree (stripe_amount_refunded);


--
-- Name: index_donations_on_stripe_application_fee_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_application_fee_id ON donations USING btree (stripe_application_fee_id);


--
-- Name: index_donations_on_stripe_balance_transaction; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_balance_transaction ON donations USING gin (stripe_balance_transaction);


--
-- Name: index_donations_on_stripe_captured; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_captured ON donations USING btree (stripe_captured);


--
-- Name: index_donations_on_stripe_charge_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_charge_id ON donations USING btree (stripe_charge_id);


--
-- Name: index_donations_on_stripe_created; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_created ON donations USING btree (stripe_created);


--
-- Name: index_donations_on_stripe_currency; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_currency ON donations USING btree (stripe_currency);


--
-- Name: index_donations_on_stripe_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_customer_id ON donations USING btree (stripe_customer_id);


--
-- Name: index_donations_on_stripe_destination; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_destination ON donations USING btree (stripe_destination);


--
-- Name: index_donations_on_stripe_dispute; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_dispute ON donations USING gin (stripe_dispute);


--
-- Name: index_donations_on_stripe_failure_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_failure_code ON donations USING btree (stripe_failure_code);


--
-- Name: index_donations_on_stripe_fee_in_cents; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_fee_in_cents ON donations USING btree (stripe_fee_in_cents);


--
-- Name: index_donations_on_stripe_fee_in_cents_usd; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_fee_in_cents_usd ON donations USING btree (stripe_fee_in_cents_usd);


--
-- Name: index_donations_on_stripe_fraud_details; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_fraud_details ON donations USING gin (stripe_fraud_details);


--
-- Name: index_donations_on_stripe_metadata; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_metadata ON donations USING gin (stripe_metadata);


--
-- Name: index_donations_on_stripe_paid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_paid ON donations USING btree (stripe_paid);


--
-- Name: index_donations_on_stripe_receipt_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_receipt_number ON donations USING btree (stripe_receipt_number);


--
-- Name: index_donations_on_stripe_refunded; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_refunded ON donations USING btree (stripe_refunded);


--
-- Name: index_donations_on_stripe_refunds; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_refunds ON donations USING gin (stripe_refunds);


--
-- Name: index_donations_on_stripe_source; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_source ON donations USING gin (stripe_source);


--
-- Name: index_donations_on_stripe_source_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_source_id ON donations USING btree (stripe_source_id);


--
-- Name: index_donations_on_stripe_statement_descriptor; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_statement_descriptor ON donations USING btree (stripe_statement_descriptor);


--
-- Name: index_donations_on_stripe_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_stripe_status ON donations USING btree (stripe_status);


--
-- Name: index_donations_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_donations_on_uid ON donations USING btree (uid);


--
-- Name: index_funds_on_owner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_funds_on_owner_id ON funds USING btree (owner_id);


--
-- Name: index_funds_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_funds_on_status ON funds USING btree (status);


--
-- Name: index_funds_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_funds_on_uid ON funds USING btree (uid);


--
-- Name: index_funds_on_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_funds_on_url ON funds USING btree (url);


--
-- Name: index_memberships_on_fund_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_memberships_on_fund_id ON memberships USING btree (fund_id);


--
-- Name: index_memberships_on_permission; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_memberships_on_permission ON memberships USING btree (permission);


--
-- Name: index_memberships_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_memberships_on_user_id ON memberships USING btree (user_id);


--
-- Name: index_metadata_on_email_address; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_metadata_on_email_address ON metadata USING btree (email_address);


--
-- Name: index_metadata_on_meta_sub_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_metadata_on_meta_sub_type ON metadata USING btree (meta_sub_type);


--
-- Name: index_metadata_on_meta_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_metadata_on_meta_type ON metadata USING btree (meta_type);


--
-- Name: index_metadata_on_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_metadata_on_number ON metadata USING btree (number);


--
-- Name: index_metadata_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_metadata_on_uid ON metadata USING btree (uid);


--
-- Name: index_metadata_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_metadata_on_username ON metadata USING btree (username);


--
-- Name: index_users_on_account_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_account_type ON users USING btree (account_type);


--
-- Name: index_users_on_age; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_age ON users USING btree (age);


--
-- Name: index_users_on_business_country; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_business_country ON users USING btree (business_country);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_gender; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_gender ON users USING btree (gender);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_status ON users USING btree (status);


--
-- Name: index_users_on_stripe_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_stripe_account_id ON users USING btree (stripe_account_id);


--
-- Name: index_users_on_stripe_currency; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_stripe_currency ON users USING btree (stripe_currency);


--
-- Name: index_users_on_stripe_legal_entity; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_stripe_legal_entity ON users USING gin (stripe_legal_entity);


--
-- Name: index_users_on_stripe_tos_acceptance; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_stripe_tos_acceptance ON users USING gin (stripe_tos_acceptance);


--
-- Name: index_users_on_stripe_verification; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_stripe_verification ON users USING gin (stripe_verification);


--
-- Name: index_users_on_stripe_verification_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_stripe_verification_status ON users USING btree (stripe_verification_status);


--
-- Name: index_users_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_uid ON users USING btree (uid);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: index_users_on_user_country; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_user_country ON users USING btree (user_country);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140619161053');

INSERT INTO schema_migrations (version) VALUES ('20140619184047');

INSERT INTO schema_migrations (version) VALUES ('20140619192648');

INSERT INTO schema_migrations (version) VALUES ('20140619201224');

INSERT INTO schema_migrations (version) VALUES ('20140626193722');

INSERT INTO schema_migrations (version) VALUES ('20140627192517');

INSERT INTO schema_migrations (version) VALUES ('20151205192835');

