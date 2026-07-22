--
-- PostgreSQL database dump
--

\restrict SQrXrJaD0xF29ZLeePdeStuflkT2xh4jdcSgItSCEui0dZuhaZVbvd5O2YFOlWb

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

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
-- Name: customer_notes_category_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.customer_notes_category_enum AS ENUM (
    'General',
    'Follow-up',
    'Complaint',
    'Payment Issue'
);


ALTER TYPE public.customer_notes_category_enum OWNER TO postgres;

--
-- Name: customers_trust_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.customers_trust_status_enum AS ENUM (
    'Unverified',
    'Trusted',
    'Suspicious',
    'Flagged',
    'Blocked'
);


ALTER TYPE public.customers_trust_status_enum OWNER TO postgres;

--
-- Name: loans_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.loans_status_enum AS ENUM (
    'Active',
    'Paid',
    'Late',
    'Finished',
    'Deleted'
);


ALTER TYPE public.loans_status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: announcements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.announcements (
    id integer NOT NULL,
    text_ar text NOT NULL,
    text_en text NOT NULL,
    background_color character varying(20) DEFAULT '#3b82f6'::character varying NOT NULL,
    text_color character varying(20) DEFAULT '#ffffff'::character varying NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.announcements OWNER TO postgres;

--
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.announcements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.announcements_id_seq OWNER TO postgres;

--
-- Name: announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.announcements_id_seq OWNED BY public.announcements.id;


--
-- Name: branches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branches (
    branch_id integer NOT NULL,
    institution_id integer NOT NULL,
    name character varying(255) NOT NULL,
    phone_number character varying(50),
    email character varying(255),
    is_active boolean DEFAULT true NOT NULL,
    total_loans integer DEFAULT 0 NOT NULL,
    maximum_loans integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    expiration_date timestamp without time zone
);


ALTER TABLE public.branches OWNER TO postgres;

--
-- Name: branches_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.branches_branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.branches_branch_id_seq OWNER TO postgres;

--
-- Name: branches_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branches_branch_id_seq OWNED BY public.branches.branch_id;


--
-- Name: cash_box_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cash_box_transactions (
    id integer NOT NULL,
    cash_box_id integer NOT NULL,
    transaction_type character varying(30) NOT NULL,
    amount numeric(15,2) NOT NULL,
    balance_before numeric(15,2) NOT NULL,
    balance_after numeric(15,2) NOT NULL,
    description text,
    loan_id integer,
    installment_id integer,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cash_box_transactions OWNER TO postgres;

--
-- Name: cash_box_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cash_box_transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cash_box_transactions_id_seq OWNER TO postgres;

--
-- Name: cash_box_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cash_box_transactions_id_seq OWNED BY public.cash_box_transactions.id;


--
-- Name: cash_boxes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cash_boxes (
    cash_box_id integer NOT NULL,
    branch_id integer,
    institution_id integer,
    box_type character varying(20) DEFAULT 'Branch'::character varying NOT NULL,
    balance numeric(15,2) DEFAULT '0'::numeric NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cash_boxes OWNER TO postgres;

--
-- Name: cash_boxes_cash_box_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cash_boxes_cash_box_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cash_boxes_cash_box_id_seq OWNER TO postgres;

--
-- Name: cash_boxes_cash_box_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cash_boxes_cash_box_id_seq OWNED BY public.cash_boxes.cash_box_id;


--
-- Name: customer_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_notes (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    user_id integer NOT NULL,
    branch_id integer,
    note_text character varying(1400) NOT NULL,
    category public.customer_notes_category_enum DEFAULT 'General'::public.customer_notes_category_enum NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    last_edited_by integer,
    edited_at timestamp without time zone
);


ALTER TABLE public.customer_notes OWNER TO postgres;

--
-- Name: customer_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_notes_id_seq OWNER TO postgres;

--
-- Name: customer_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_notes_id_seq OWNED BY public.customer_notes.id;


--
-- Name: customer_relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_relations (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    institution_id integer NOT NULL,
    branch_id integer,
    is_active boolean DEFAULT true NOT NULL,
    deleted_at timestamp without time zone,
    deleted_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.customer_relations OWNER TO postgres;

--
-- Name: customer_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_relations_id_seq OWNER TO postgres;

--
-- Name: customer_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_relations_id_seq OWNED BY public.customer_relations.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    institution_id integer,
    created_by integer,
    name character varying(255) NOT NULL,
    national_id character varying(50) NOT NULL,
    phone_number character varying(50) NOT NULL,
    trust_status public.customers_trust_status_enum DEFAULT 'Unverified'::public.customers_trust_status_enum NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_customer_id_seq OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- Name: homepage_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.homepage_settings (
    id integer NOT NULL,
    hero_title_ar text DEFAULT 'منصة Q1Key لإدارة القروض'::text NOT NULL,
    hero_title_en text DEFAULT 'Q1Key Loan Management Platform'::text NOT NULL,
    hero_subtitle_ar text DEFAULT 'الحل الأمثل لإدارة مؤسستك المالية'::text NOT NULL,
    hero_subtitle_en text DEFAULT 'The Ultimate Solution for Managing Your Financial Institution'::text NOT NULL,
    hero_image_url text,
    hero_video_url text,
    hero_background_type character varying(20) DEFAULT 'gradient'::character varying NOT NULL,
    login_button_text_ar character varying(100) DEFAULT 'تسجيل الدخول'::character varying NOT NULL,
    login_button_text_en character varying(100) DEFAULT 'Login'::character varying NOT NULL,
    login_button_visible boolean DEFAULT true NOT NULL,
    register_button_text_ar character varying(100) DEFAULT 'اشترك معنا'::character varying NOT NULL,
    register_button_text_en character varying(100) DEFAULT 'Subscribe Now'::character varying NOT NULL,
    register_button_visible boolean DEFAULT true NOT NULL,
    features_section_visible boolean DEFAULT true NOT NULL,
    features_title_ar character varying(200) DEFAULT 'مميزات المنصة'::character varying NOT NULL,
    features_title_en character varying(200) DEFAULT 'Platform Features'::character varying NOT NULL,
    features_data text,
    plans_section_visible boolean DEFAULT true NOT NULL,
    plans_title_ar character varying(200) DEFAULT 'باقات الاشتراك'::character varying NOT NULL,
    plans_title_en character varying(200) DEFAULT 'Subscription Plans'::character varying NOT NULL,
    about_section_visible boolean DEFAULT true NOT NULL,
    about_title_ar character varying(200) DEFAULT 'من نحن'::character varying NOT NULL,
    about_title_en character varying(200) DEFAULT 'About Us'::character varying NOT NULL,
    about_content_ar text,
    about_content_en text,
    about_image_url text,
    contact_section_visible boolean DEFAULT true NOT NULL,
    contact_title_ar character varying(200) DEFAULT 'تواصل معنا'::character varying NOT NULL,
    contact_title_en character varying(200) DEFAULT 'Contact Us'::character varying NOT NULL,
    sections_order text DEFAULT '["hero","features","plans","about","contact"]'::text NOT NULL,
    footer_text_ar text,
    footer_text_en text,
    social_links text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    support_email character varying(150),
    quick_links text,
    whatsapp_number character varying(100)
);


ALTER TABLE public.homepage_settings OWNER TO postgres;

--
-- Name: homepage_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.homepage_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.homepage_settings_id_seq OWNER TO postgres;

--
-- Name: homepage_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.homepage_settings_id_seq OWNED BY public.homepage_settings.id;


--
-- Name: installments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.installments (
    id integer NOT NULL,
    loan_id integer NOT NULL,
    installment_number integer NOT NULL,
    due_date date NOT NULL,
    amount numeric(10,2) NOT NULL,
    status character varying(20) DEFAULT 'Pending'::character varying NOT NULL,
    payment_date date,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.installments OWNER TO postgres;

--
-- Name: installments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.installments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.installments_id_seq OWNER TO postgres;

--
-- Name: installments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.installments_id_seq OWNED BY public.installments.id;


--
-- Name: institutions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.institutions (
    institution_id integer NOT NULL,
    name character varying(255) NOT NULL,
    tax_id character varying(100),
    phone_number character varying(50),
    email character varying(255),
    max_users integer DEFAULT 5 NOT NULL,
    can_create_branches boolean DEFAULT true NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    expiration_date date,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    total_loans integer DEFAULT 0 NOT NULL,
    maximum_loans integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.institutions OWNER TO postgres;

--
-- Name: institutions_institution_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.institutions_institution_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.institutions_institution_id_seq OWNER TO postgres;

--
-- Name: institutions_institution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.institutions_institution_id_seq OWNED BY public.institutions.institution_id;


--
-- Name: loans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loans (
    loan_id integer NOT NULL,
    customer_id integer NOT NULL,
    branch_id integer,
    institution_id integer,
    product_id integer NOT NULL,
    principal_amount numeric(10,2) NOT NULL,
    created_by integer,
    status public.loans_status_enum DEFAULT 'Active'::public.loans_status_enum NOT NULL,
    payment_plan_months integer DEFAULT 1 NOT NULL,
    paid_amount numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    due_date date,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    profit_amount numeric(10,2) DEFAULT '0'::numeric NOT NULL
);


ALTER TABLE public.loans OWNER TO postgres;

--
-- Name: loans_loan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loans_loan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loans_loan_id_seq OWNER TO postgres;

--
-- Name: loans_loan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loans_loan_id_seq OWNED BY public.loans.loan_id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    institution_id integer,
    branch_id integer,
    name character varying(255) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    is_visible_to_branches boolean DEFAULT true NOT NULL
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_product_id_seq OWNER TO postgres;

--
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- Name: quick_links; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quick_links (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    url character varying(500) NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "sortOrder" integer DEFAULT 0 NOT NULL,
    icon character varying,
    color character varying,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.quick_links OWNER TO postgres;

--
-- Name: quick_links_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quick_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quick_links_id_seq OWNER TO postgres;

--
-- Name: quick_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quick_links_id_seq OWNED BY public.quick_links.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id integer NOT NULL,
    role_name character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_role_id_seq OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;


--
-- Name: search_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.search_logs (
    search_log_id integer NOT NULL,
    customer_id integer NOT NULL,
    user_id integer NOT NULL,
    search_query character varying(500) NOT NULL,
    search_type character varying(50) NOT NULL,
    ip_address character varying(50),
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.search_logs OWNER TO postgres;

--
-- Name: search_logs_search_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.search_logs_search_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.search_logs_search_log_id_seq OWNER TO postgres;

--
-- Name: search_logs_search_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.search_logs_search_log_id_seq OWNED BY public.search_logs.search_log_id;


--
-- Name: subscription_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscription_plans (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    name_en character varying(100),
    duration_months integer NOT NULL,
    price numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    is_free_trial boolean DEFAULT false NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.subscription_plans OWNER TO postgres;

--
-- Name: subscription_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subscription_plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subscription_plans_id_seq OWNER TO postgres;

--
-- Name: subscription_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subscription_plans_id_seq OWNED BY public.subscription_plans.id;


--
-- Name: subscription_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscription_requests (
    id integer NOT NULL,
    requester_type character varying(20) NOT NULL,
    institution_id integer,
    branch_id integer,
    plan_id integer,
    custom_duration_months integer,
    amount numeric(10,2) NOT NULL,
    status character varying(20) DEFAULT 'Pending'::character varying NOT NULL,
    is_free boolean DEFAULT false NOT NULL,
    free_reason text,
    requested_start_date date,
    requested_end_date date,
    notes text,
    admin_notes text,
    processed_by integer,
    processed_at timestamp without time zone,
    cash_box_transaction_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    pending_data text
);


ALTER TABLE public.subscription_requests OWNER TO postgres;

--
-- Name: subscription_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subscription_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subscription_requests_id_seq OWNER TO postgres;

--
-- Name: subscription_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subscription_requests_id_seq OWNED BY public.subscription_requests.id;


--
-- Name: system_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_settings (
    id integer NOT NULL,
    key character varying(100) NOT NULL,
    value text,
    description text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.system_settings OWNER TO postgres;

--
-- Name: system_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_settings_id_seq OWNER TO postgres;

--
-- Name: system_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_settings_id_seq OWNED BY public.system_settings.id;


--
-- Name: telegram_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telegram_settings (
    id integer NOT NULL,
    bot_token character varying(255),
    chat_id character varying(100),
    is_enabled boolean DEFAULT false NOT NULL,
    notify_new_requests boolean DEFAULT true NOT NULL,
    notify_renewals boolean DEFAULT true NOT NULL,
    last_test_at timestamp without time zone,
    last_test_success boolean DEFAULT false NOT NULL,
    last_test_error text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    allow_action_buttons boolean DEFAULT true NOT NULL
);


ALTER TABLE public.telegram_settings OWNER TO postgres;

--
-- Name: telegram_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.telegram_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.telegram_settings_id_seq OWNER TO postgres;

--
-- Name: telegram_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.telegram_settings_id_seq OWNED BY public.telegram_settings.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    role_id integer NOT NULL,
    institution_id integer,
    branch_id integer,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone_number character varying(50),
    password_hash character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    active_session_id character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_activity_at timestamp without time zone,
    national_id character varying(50)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: announcements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements ALTER COLUMN id SET DEFAULT nextval('public.announcements_id_seq'::regclass);


--
-- Name: branches branch_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branches ALTER COLUMN branch_id SET DEFAULT nextval('public.branches_branch_id_seq'::regclass);


--
-- Name: cash_box_transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cash_box_transactions ALTER COLUMN id SET DEFAULT nextval('public.cash_box_transactions_id_seq'::regclass);


--
-- Name: cash_boxes cash_box_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cash_boxes ALTER COLUMN cash_box_id SET DEFAULT nextval('public.cash_boxes_cash_box_id_seq'::regclass);


--
-- Name: customer_notes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_notes ALTER COLUMN id SET DEFAULT nextval('public.customer_notes_id_seq'::regclass);


--
-- Name: customer_relations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_relations ALTER COLUMN id SET DEFAULT nextval('public.customer_relations_id_seq'::regclass);


--
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- Name: homepage_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.homepage_settings ALTER COLUMN id SET DEFAULT nextval('public.homepage_settings_id_seq'::regclass);


--
-- Name: installments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.installments ALTER COLUMN id SET DEFAULT nextval('public.installments_id_seq'::regclass);


--
-- Name: institutions institution_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institutions ALTER COLUMN institution_id SET DEFAULT nextval('public.institutions_institution_id_seq'::regclass);


--
-- Name: loans loan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans ALTER COLUMN loan_id SET DEFAULT nextval('public.loans_loan_id_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- Name: quick_links id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quick_links ALTER COLUMN id SET DEFAULT nextval('public.quick_links_id_seq'::regclass);


--
-- Name: roles role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);


--
-- Name: search_logs search_log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.search_logs ALTER COLUMN search_log_id SET DEFAULT nextval('public.search_logs_search_log_id_seq'::regclass);


--
-- Name: subscription_plans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_plans ALTER COLUMN id SET DEFAULT nextval('public.subscription_plans_id_seq'::regclass);


--
-- Name: subscription_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_requests ALTER COLUMN id SET DEFAULT nextval('public.subscription_requests_id_seq'::regclass);


--
-- Name: system_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings ALTER COLUMN id SET DEFAULT nextval('public.system_settings_id_seq'::regclass);


--
-- Name: telegram_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telegram_settings ALTER COLUMN id SET DEFAULT nextval('public.telegram_settings_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcements (id, text_ar, text_en, background_color, text_color, is_active, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: branches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.branches (branch_id, institution_id, name, phone_number, email, is_active, total_loans, maximum_loans, created_at, updated_at, expiration_date) FROM stdin;
\.


--
-- Data for Name: cash_box_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cash_box_transactions (id, cash_box_id, transaction_type, amount, balance_before, balance_after, description, loan_id, installment_id, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: cash_boxes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cash_boxes (cash_box_id, branch_id, institution_id, box_type, balance, is_active, created_at, updated_at) FROM stdin;
1	\N	\N	Admin	0.00	t	2026-02-07 18:11:46.157688	2026-02-07 18:11:46.157688
\.


--
-- Data for Name: customer_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_notes (id, customer_id, user_id, branch_id, note_text, category, created_by, created_at, last_edited_by, edited_at) FROM stdin;
\.


--
-- Data for Name: customer_relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_relations (id, customer_id, institution_id, branch_id, is_active, deleted_at, deleted_by, created_at) FROM stdin;
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, institution_id, created_by, name, national_id, phone_number, trust_status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: homepage_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.homepage_settings (id, hero_title_ar, hero_title_en, hero_subtitle_ar, hero_subtitle_en, hero_image_url, hero_video_url, hero_background_type, login_button_text_ar, login_button_text_en, login_button_visible, register_button_text_ar, register_button_text_en, register_button_visible, features_section_visible, features_title_ar, features_title_en, features_data, plans_section_visible, plans_title_ar, plans_title_en, about_section_visible, about_title_ar, about_title_en, about_content_ar, about_content_en, about_image_url, contact_section_visible, contact_title_ar, contact_title_en, sections_order, footer_text_ar, footer_text_en, social_links, created_at, updated_at, support_email, quick_links, whatsapp_number) FROM stdin;
1	منصة Q1KEY لإدارة الحلول  المالية للمؤسسات والشركات	Q1KEY platform for managing financial solutions for institutions and companies	الحل الأمثل لإدارة مؤسستك المالية بكفاءة وأمان	The Ultimate Solution for Managing Your Financial Institution	\N	\N	gradient	تسجيل الدخول	Login	t	اشترك معنا	Subscribe Now	t	f	مميزات المنصة	Platform Features	[{"iconAr":"📊","iconEn":"📊","titleAr":"إدارة القروض","titleEn":"Loan Management","descAr":"إدارة شاملة لجميع القروض والأقساط","descEn":"Comprehensive management of all loans and installments"},{"iconAr":"👥","iconEn":"👥","titleAr":"إدارة العملاء","titleEn":"Customer Management","descAr":"نظام متكامل لإدارة بيانات العملاء","descEn":"Integrated system for customer data management"},{"iconAr":"🏢","iconEn":"🏢","titleAr":"إدارة الفروع","titleEn":"Branch Management","descAr":"تحكم كامل بجميع الفروع من مكان واحد","descEn":"Full control over all branches from one place"},{"iconAr":"📈","iconEn":"📈","titleAr":"تقارير متقدمة","titleEn":"Advanced Reports","descAr":"تقارير مالية وإحصائية شاملة","descEn":"Comprehensive financial and statistical reports"}]	f	باقات الاشتراك	Subscription Plans	t	من نحن	About Us	نحن منصة مبتكرة في عالم الحلول المالية، نمكّن المؤسسات من إدارة عملياتها المالية بذكاء عبر حلول تقنية متقدمة تدعم النمو والاستدامة.	We are an innovative platform in the world of financial solutions, empowering organizations to manage their financial operations intelligently through advanced technological solutions that support growth and sustainability.	\N	t	تواصل معنا	Contact Us	["hero","features","plans","about","contact"]			{}	2026-02-05 18:56:31.594973	2026-02-07 19:36:47.480715	Q1KEY@GMAIL.COM	[]	966580122205
\.


--
-- Data for Name: installments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.installments (id, loan_id, installment_number, due_date, amount, status, payment_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: institutions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.institutions (institution_id, name, tax_id, phone_number, email, max_users, can_create_branches, is_active, expiration_date, created_at, updated_at, total_loans, maximum_loans) FROM stdin;
\.


--
-- Data for Name: loans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loans (loan_id, customer_id, branch_id, institution_id, product_id, principal_amount, created_by, status, payment_plan_months, paid_amount, created_at, due_date, updated_at, profit_amount) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (product_id, institution_id, branch_id, name, description, is_active, created_at, updated_at, is_visible_to_branches) FROM stdin;
\.


--
-- Data for Name: quick_links; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quick_links (id, name, url, "isActive", "sortOrder", icon, color, "createdAt", "updatedAt") FROM stdin;
1	نفاذ	https://www.iam.gov.sa/authservice/userauthservice?lang=ar	t	1	\N	\N	2026-02-05 19:10:15.474807	2026-02-05 19:10:15.474807
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name, created_at) FROM stdin;
1	Super Admin	2026-01-06 09:42:44.373145
2	Institution	2026-01-06 09:42:44.373145
3	Branch	2026-01-06 09:42:44.373145
\.


--
-- Data for Name: search_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.search_logs (search_log_id, customer_id, user_id, search_query, search_type, ip_address, created_at) FROM stdin;
\.


--
-- Data for Name: subscription_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscription_plans (id, name, name_en, duration_months, price, is_active, is_free_trial, sort_order, description, created_at, updated_at) FROM stdin;
1	شهر واحد	1 Month	1	185.00	f	f	1	\N	2026-01-15 10:38:21.023647	2026-02-05 19:16:20.29152
2	3 أشهر	3 Months	3	480.00	f	f	2	\N	2026-01-15 10:38:21.087766	2026-02-05 19:16:20.695031
3	6 أشهر	6 Months	6	850.00	f	f	3	\N	2026-01-15 10:38:21.102378	2026-02-05 19:16:21.03639
4	سنة كاملة	1 Year	12	1500.00	f	f	4	\N	2026-01-15 10:38:21.128034	2026-02-05 19:16:21.351505
5	اشتراك مجاني	Free Subscription	1	0.00	t	f	5	\N	2026-02-05 19:16:03.765287	2026-02-05 19:16:21.71642
\.


--
-- Data for Name: subscription_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscription_requests (id, requester_type, institution_id, branch_id, plan_id, custom_duration_months, amount, status, is_free, free_reason, requested_start_date, requested_end_date, notes, admin_notes, processed_by, processed_at, cash_box_transaction_id, created_at, updated_at, pending_data) FROM stdin;
\.


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_settings (id, key, value, description, created_at, updated_at) FROM stdin;
2	support.email	skjfvghk@gmail.com	Support Email Address	2026-02-07 17:54:45.60795	2026-02-07 17:54:45.60795
1	support.whatsapp	5415	Support WhatsApp Number	2026-02-07 17:54:45.581669	2026-02-07 18:01:26.888664
\.


--
-- Data for Name: telegram_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.telegram_settings (id, bot_token, chat_id, is_enabled, notify_new_requests, notify_renewals, last_test_at, last_test_success, last_test_error, created_at, updated_at, allow_action_buttons) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, role_id, institution_id, branch_id, name, email, phone_number, password_hash, is_active, active_session_id, created_at, updated_at, last_activity_at, national_id) FROM stdin;
1	1	\N	\N	Admin	admin@q1key.com	\N	$2b$10$Nd/HNK/LENQxO9t84hLOyeVjvLNTqnBk5QuqZdY57OHmU24g/1kX2	t	28882edb-ed9c-479f-bcca-3d39e443ad65	2026-02-05 18:55:24.878438	2026-02-07 21:38:00.17368	2026-02-07 21:38:00.15	\N
\.


--
-- Name: announcements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.announcements_id_seq', 1, false);


--
-- Name: branches_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branches_branch_id_seq', 1, false);


--
-- Name: cash_box_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cash_box_transactions_id_seq', 1, false);


--
-- Name: cash_boxes_cash_box_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cash_boxes_cash_box_id_seq', 1, true);


--
-- Name: customer_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_notes_id_seq', 1, false);


--
-- Name: customer_relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_relations_id_seq', 1, false);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 1, false);


--
-- Name: homepage_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.homepage_settings_id_seq', 1, true);


--
-- Name: installments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.installments_id_seq', 1, false);


--
-- Name: institutions_institution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.institutions_institution_id_seq', 1, false);


--
-- Name: loans_loan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loans_loan_id_seq', 1, false);


--
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 1, false);


--
-- Name: quick_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quick_links_id_seq', 1, true);


--
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_role_id_seq', 1, false);


--
-- Name: search_logs_search_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.search_logs_search_log_id_seq', 1, false);


--
-- Name: subscription_plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subscription_plans_id_seq', 5, true);


--
-- Name: subscription_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subscription_requests_id_seq', 1, false);


--
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 2, true);


--
-- Name: telegram_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.telegram_settings_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, true);


--
-- Name: cash_boxes PK_04b0cff1d79d258285e7372c858; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cash_boxes
    ADD CONSTRAINT "PK_04b0cff1d79d258285e7372c858" PRIMARY KEY (cash_box_id);


--
-- Name: roles PK_09f4c8130b54f35925588a37b6a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT "PK_09f4c8130b54f35925588a37b6a" PRIMARY KEY (role_id);


--
-- Name: institutions PK_0b7c9b88f0f4a4428d17848d84c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institutions
    ADD CONSTRAINT "PK_0b7c9b88f0f4a4428d17848d84c" PRIMARY KEY (institution_id);


--
-- Name: search_logs PK_0c6a58696007dc38cc2eced5413; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.search_logs
    ADD CONSTRAINT "PK_0c6a58696007dc38cc2eced5413" PRIMARY KEY (search_log_id);


--
-- Name: customers PK_6c444ce6637f2c1d71c3cf136c1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT "PK_6c444ce6637f2c1d71c3cf136c1" PRIMARY KEY (customer_id);


--
-- Name: quick_links PK_73f8b821de42c0a6aba7e7cb303; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quick_links
    ADD CONSTRAINT "PK_73f8b821de42c0a6aba7e7cb303" PRIMARY KEY (id);


--
-- Name: subscription_requests PK_7f97babb1f4d7eeef9d5c2937be; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_requests
    ADD CONSTRAINT "PK_7f97babb1f4d7eeef9d5c2937be" PRIMARY KEY (id);


--
-- Name: system_settings PK_82521f08790d248b2a80cc85d40; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT "PK_82521f08790d248b2a80cc85d40" PRIMARY KEY (id);


--
-- Name: customer_notes PK_8a41bce1fe0094bd7a9c5266cc8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_notes
    ADD CONSTRAINT "PK_8a41bce1fe0094bd7a9c5266cc8" PRIMARY KEY (id);


--
-- Name: users PK_96aac72f1574b88752e9fb00089; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_96aac72f1574b88752e9fb00089" PRIMARY KEY (user_id);


--
-- Name: subscription_plans PK_9ab8fe6918451ab3d0a4fb6bb0c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_plans
    ADD CONSTRAINT "PK_9ab8fe6918451ab3d0a4fb6bb0c" PRIMARY KEY (id);


--
-- Name: products PK_a8940a4bf3b90bd7ac15c8f4dd9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "PK_a8940a4bf3b90bd7ac15c8f4dd9" PRIMARY KEY (product_id);


--
-- Name: announcements PK_b3ad760876ff2e19d58e05dc8b0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT "PK_b3ad760876ff2e19d58e05dc8b0" PRIMARY KEY (id);


--
-- Name: loans PK_b6d56a7d731f74ea2f0631ba870; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT "PK_b6d56a7d731f74ea2f0631ba870" PRIMARY KEY (loan_id);


--
-- Name: installments PK_c74e44aa06bdebef2af0a93da1b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.installments
    ADD CONSTRAINT "PK_c74e44aa06bdebef2af0a93da1b" PRIMARY KEY (id);


--
-- Name: homepage_settings PK_cbc4f822929b91e3479f9ff9b7e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.homepage_settings
    ADD CONSTRAINT "PK_cbc4f822929b91e3479f9ff9b7e" PRIMARY KEY (id);


--
-- Name: branches PK_cffb054eec523921707bd442bd9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT "PK_cffb054eec523921707bd442bd9" PRIMARY KEY (branch_id);


--
-- Name: cash_box_transactions PK_d58da81e8f88c63fa4c5dde7109; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cash_box_transactions
    ADD CONSTRAINT "PK_d58da81e8f88c63fa4c5dde7109" PRIMARY KEY (id);


--
-- Name: customer_relations PK_da7952b0f51ca8c2b46ce9edee3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_relations
    ADD CONSTRAINT "PK_da7952b0f51ca8c2b46ce9edee3" PRIMARY KEY (id);


--
-- Name: telegram_settings PK_f8e8f766f24321de5415d19ddb7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telegram_settings
    ADD CONSTRAINT "PK_f8e8f766f24321de5415d19ddb7" PRIMARY KEY (id);


--
-- Name: users UQ_17d1817f241f10a3dbafb169fd2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_17d1817f241f10a3dbafb169fd2" UNIQUE (phone_number);


--
-- Name: users UQ_232b9597ff9a89b2c2fc5d1b5e5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_232b9597ff9a89b2c2fc5d1b5e5" UNIQUE (national_id);


--
-- Name: customers UQ_46c5f573cb24bdc6e81b8ef2504; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT "UQ_46c5f573cb24bdc6e81b8ef2504" UNIQUE (phone_number);


--
-- Name: customers UQ_81cef023276a6e88202edaae642; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT "UQ_81cef023276a6e88202edaae642" UNIQUE (national_id);


--
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- Name: roles UQ_ac35f51a0f17e3e1fe121126039; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT "UQ_ac35f51a0f17e3e1fe121126039" UNIQUE (role_name);


--
-- Name: system_settings UQ_b1b5bc664526d375c94ce9ad43d; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT "UQ_b1b5bc664526d375c94ce9ad43d" UNIQUE (key);


--
-- Name: IDX_CUSTOMER_CREATOR; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_CUSTOMER_CREATOR" ON public.customers USING btree (created_by);


--
-- Name: IDX_CUSTOMER_INSTITUTION; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_CUSTOMER_INSTITUTION" ON public.customers USING btree (institution_id);


--
-- Name: IDX_CUSTOMER_NATIONAL_ID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_CUSTOMER_NATIONAL_ID" ON public.customers USING btree (national_id);


--
-- Name: IDX_CUSTOMER_PHONE; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_CUSTOMER_PHONE" ON public.customers USING btree (phone_number);


--
-- Name: IDX_INSTALLMENT_DUE_DATE; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_INSTALLMENT_DUE_DATE" ON public.installments USING btree (due_date);


--
-- Name: IDX_INSTALLMENT_LOAN; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_INSTALLMENT_LOAN" ON public.installments USING btree (loan_id);


--
-- Name: IDX_INSTALLMENT_STATUS; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_INSTALLMENT_STATUS" ON public.installments USING btree (status);


--
-- Name: IDX_LOAN_BRANCH; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_LOAN_BRANCH" ON public.loans USING btree (branch_id);


--
-- Name: IDX_LOAN_CREATOR; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_LOAN_CREATOR" ON public.loans USING btree (created_by);


--
-- Name: IDX_LOAN_CUSTOMER; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_LOAN_CUSTOMER" ON public.loans USING btree (customer_id);


--
-- Name: IDX_LOAN_INSTITUTION; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_LOAN_INSTITUTION" ON public.loans USING btree (institution_id);


--
-- Name: IDX_LOAN_PRODUCT; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_LOAN_PRODUCT" ON public.loans USING btree (product_id);


--
-- Name: IDX_LOAN_STATUS; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_LOAN_STATUS" ON public.loans USING btree (status);


--
-- Name: IDX_SUB_REQ_BRANCH; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_SUB_REQ_BRANCH" ON public.subscription_requests USING btree (branch_id);


--
-- Name: IDX_SUB_REQ_INSTITUTION; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_SUB_REQ_INSTITUTION" ON public.subscription_requests USING btree (institution_id);


--
-- Name: IDX_SUB_REQ_PLAN; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_SUB_REQ_PLAN" ON public.subscription_requests USING btree (plan_id);


--
-- Name: IDX_SUB_REQ_STATUS; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_SUB_REQ_STATUS" ON public.subscription_requests USING btree (status);


--
-- Name: IDX_SUB_REQ_TYPE; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_SUB_REQ_TYPE" ON public.subscription_requests USING btree (requester_type);


--
-- Name: IDX_TXN_CASHBOX; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_TXN_CASHBOX" ON public.cash_box_transactions USING btree (cash_box_id);


--
-- Name: IDX_TXN_CREATOR; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_TXN_CREATOR" ON public.cash_box_transactions USING btree (created_by);


--
-- Name: IDX_TXN_LOAN; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_TXN_LOAN" ON public.cash_box_transactions USING btree (loan_id);


--
-- Name: IDX_TXN_TYPE; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_TXN_TYPE" ON public.cash_box_transactions USING btree (transaction_type);


--
-- Name: subscription_requests FK_08a05533fac26a1133888c2c04a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_requests
    ADD CONSTRAINT "FK_08a05533fac26a1133888c2c04a" FOREIGN KEY (plan_id) REFERENCES public.subscription_plans(id);


--
-- Name: search_logs FK_0db1c3b0867f948374cde302e8e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.search_logs
    ADD CONSTRAINT "FK_0db1c3b0867f948374cde302e8e" FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: customer_relations FK_16270052ee5c2571dcdda07644a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_relations
    ADD CONSTRAINT "FK_16270052ee5c2571dcdda07644a" FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE CASCADE;


--
-- Name: subscription_requests FK_21c0ba8d0359fd94e3091a7906e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_requests
    ADD CONSTRAINT "FK_21c0ba8d0359fd94e3091a7906e" FOREIGN KEY (institution_id) REFERENCES public.institutions(institution_id);


--
-- Name: cash_boxes FK_2eba32215917a0de5b9f64c574d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cash_boxes
    ADD CONSTRAINT "FK_2eba32215917a0de5b9f64c574d" FOREIGN KEY (institution_id) REFERENCES public.institutions(institution_id);


--
-- Name: branches FK_319f0f63c7ef90bec51825bcd37; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT "FK_319f0f63c7ef90bec51825bcd37" FOREIGN KEY (institution_id) REFERENCES public.institutions(institution_id);


--
-- Name: loans FK_407d3207500ffa10289f908f0ef; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT "FK_407d3207500ffa10289f908f0ef" FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: announcements FK_40bd4946a00669c5fb7e6d972f0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT "FK_40bd4946a00669c5fb7e6d972f0" FOREIGN KEY (created_by) REFERENCES public.users(user_id);


--
-- Name: users FK_5a58f726a41264c8b3e86d4a1de; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_5a58f726a41264c8b3e86d4a1de" FOREIGN KEY (branch_id) REFERENCES public.branches(branch_id);


--
-- Name: loans FK_5e6b722e8af2418a89e2a6dc24f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT "FK_5e6b722e8af2418a89e2a6dc24f" FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: installments FK_6a0de085bb82a1e96164dc1b900; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.installments
    ADD CONSTRAINT "FK_6a0de085bb82a1e96164dc1b900" FOREIGN KEY (loan_id) REFERENCES public.loans(loan_id) ON DELETE CASCADE;


--
-- Name: cash_box_transactions FK_6b3b09955c22828e909153b1b86; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cash_box_transactions
    ADD CONSTRAINT "FK_6b3b09955c22828e909153b1b86" FOREIGN KEY (loan_id) REFERENCES public.loans(loan_id);


--
-- Name: cash_boxes FK_6f299041dad072fbd9398c5fd86; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cash_boxes
    ADD CONSTRAINT "FK_6f299041dad072fbd9398c5fd86" FOREIGN KEY (branch_id) REFERENCES public.branches(branch_id);


--
-- Name: customer_notes FK_77c1117a681d96e67e951540938; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_notes
    ADD CONSTRAINT "FK_77c1117a681d96e67e951540938" FOREIGN KEY (branch_id) REFERENCES public.branches(branch_id);


--
-- Name: users FK_822972ceea1fda0973b8acc7bbe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_822972ceea1fda0973b8acc7bbe" FOREIGN KEY (institution_id) REFERENCES public.institutions(institution_id);


--
-- Name: customers FK_8f138f284609b045dc64c91757a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT "FK_8f138f284609b045dc64c91757a" FOREIGN KEY (created_by) REFERENCES public.users(user_id);


--
-- Name: users FK_a2cecd1a3531c0b041e29ba46e1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_a2cecd1a3531c0b041e29ba46e1" FOREIGN KEY (role_id) REFERENCES public.roles(role_id);


--
-- Name: loans FK_a39c32cd845ebe3a93813c619a8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT "FK_a39c32cd845ebe3a93813c619a8" FOREIGN KEY (branch_id) REFERENCES public.branches(branch_id);


--
-- Name: subscription_requests FK_a900326ac818d03b0203ecebfb8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_requests
    ADD CONSTRAINT "FK_a900326ac818d03b0203ecebfb8" FOREIGN KEY (branch_id) REFERENCES public.branches(branch_id);


--
-- Name: customer_relations FK_a974cc1f018bf88fe8b97a92330; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_relations
    ADD CONSTRAINT "FK_a974cc1f018bf88fe8b97a92330" FOREIGN KEY (deleted_by) REFERENCES public.users(user_id);


--
-- Name: customers FK_b72bc825dc69f442826d2f5439c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT "FK_b72bc825dc69f442826d2f5439c" FOREIGN KEY (institution_id) REFERENCES public.institutions(institution_id);


--
-- Name: customer_notes FK_b77784184daa7589018ac4e8402; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_notes
    ADD CONSTRAINT "FK_b77784184daa7589018ac4e8402" FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: customer_relations FK_bcfc8a1b1f984c3184348e224b2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_relations
    ADD CONSTRAINT "FK_bcfc8a1b1f984c3184348e224b2" FOREIGN KEY (branch_id) REFERENCES public.branches(branch_id);


--
-- Name: loans FK_c381192f607f1e6e17f1bbb480a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT "FK_c381192f607f1e6e17f1bbb480a" FOREIGN KEY (institution_id) REFERENCES public.institutions(institution_id);


--
-- Name: loans FK_c3b93ceba889c7bb9319d0b9e41; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT "FK_c3b93ceba889c7bb9319d0b9e41" FOREIGN KEY (created_by) REFERENCES public.users(user_id);


--
-- Name: subscription_requests FK_cb11eeb061a49e11db6181ce2a8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_requests
    ADD CONSTRAINT "FK_cb11eeb061a49e11db6181ce2a8" FOREIGN KEY (processed_by) REFERENCES public.users(user_id);


--
-- Name: cash_box_transactions FK_ce5652be1ad77567c7f84365924; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cash_box_transactions
    ADD CONSTRAINT "FK_ce5652be1ad77567c7f84365924" FOREIGN KEY (installment_id) REFERENCES public.installments(id);


--
-- Name: customer_relations FK_ce57ed9ad3a932da71893e047a2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_relations
    ADD CONSTRAINT "FK_ce57ed9ad3a932da71893e047a2" FOREIGN KEY (institution_id) REFERENCES public.institutions(institution_id);


--
-- Name: search_logs FK_d1e8b5952de5ae8f5e67349568e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.search_logs
    ADD CONSTRAINT "FK_d1e8b5952de5ae8f5e67349568e" FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: cash_box_transactions FK_daa51243eeb5e7e202e3a9d97af; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cash_box_transactions
    ADD CONSTRAINT "FK_daa51243eeb5e7e202e3a9d97af" FOREIGN KEY (created_by) REFERENCES public.users(user_id);


--
-- Name: products FK_de720484cb95d8752861e507921; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "FK_de720484cb95d8752861e507921" FOREIGN KEY (branch_id) REFERENCES public.branches(branch_id);


--
-- Name: cash_box_transactions FK_e47a1c8a5d86d84eade8f100950; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cash_box_transactions
    ADD CONSTRAINT "FK_e47a1c8a5d86d84eade8f100950" FOREIGN KEY (cash_box_id) REFERENCES public.cash_boxes(cash_box_id);


--
-- Name: products FK_e85fef0a296f0c88c968a30ef16; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "FK_e85fef0a296f0c88c968a30ef16" FOREIGN KEY (institution_id) REFERENCES public.institutions(institution_id);


--
-- Name: customer_notes FK_ebd1aed1ce2a12987e1e80dd971; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_notes
    ADD CONSTRAINT "FK_ebd1aed1ce2a12987e1e80dd971" FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

\unrestrict SQrXrJaD0xF29ZLeePdeStuflkT2xh4jdcSgItSCEui0dZuhaZVbvd5O2YFOlWb

