--
-- PostgreSQL database dump
--

\restrict 7CnkoGLAp9617YhUXnKI5fPBh1tPYceTlTf1qXQwj2ffMCXQWefRlGt6an5gOSk

-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

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
-- Name: dish_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.dish_types AS ENUM (
    'Entrée',
    'Plat principal',
    'Accompagnement',
    'Dessert'
);


ALTER TYPE public.dish_types OWNER TO db_admin;

--
-- Name: equipment; Type: TYPE; Schema: public; Owner: db_admin
--

CREATE TYPE public.equipment AS ENUM (
    'Inclus',
    'Non inclus',
    'Retourné'
);


ALTER TYPE public.equipment OWNER TO db_admin;

--
-- Name: notes; Type: TYPE; Schema: public; Owner: db_admin
--

CREATE TYPE public.notes AS ENUM (
    'Critique',
    'À améliorer',
    'Correct',
    'Bien',
    'Excellent'
);


ALTER TYPE public.notes OWNER TO db_admin;

--
-- Name: order_status; Type: TYPE; Schema: public; Owner: db_admin
--

CREATE TYPE public.order_status AS ENUM (
    'En attente de validation',
    'Acceptée',
    'Annulée',
    'En préparation',
    'En cours de livraison',
    'Livrée',
    'Terminée'
);


ALTER TYPE public.order_status OWNER TO db_admin;

--
-- Name: payment_status; Type: TYPE; Schema: public; Owner: db_admin
--

CREATE TYPE public.payment_status AS ENUM (
    'En attente de règlement',
    'Annulée',
    'Réglée'
);


ALTER TYPE public.payment_status OWNER TO db_admin;

--
-- Name: review_status; Type: TYPE; Schema: public; Owner: db_admin
--

CREATE TYPE public.review_status AS ENUM (
    'En attente',
    'Approuvé',
    'Répondu',
    'Rejeté'
);


ALTER TYPE public.review_status OWNER TO db_admin;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: db_admin
--

CREATE TYPE public.user_role AS ENUM (
    'Administrateur',
    'Chef',
    'Empoyé',
    'Client'
);


ALTER TYPE public.user_role OWNER TO db_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: allergenes; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.allergenes (
    allergene_id integer NOT NULL,
    libelle character varying(50) NOT NULL
);


ALTER TABLE public.allergenes OWNER TO db_admin;

--
-- Name: allergenes_allergene_id_seq; Type: SEQUENCE; Schema: public; Owner: db_admin
--

CREATE SEQUENCE public.allergenes_allergene_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.allergenes_allergene_id_seq OWNER TO db_admin;

--
-- Name: allergenes_allergene_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: db_admin
--

ALTER SEQUENCE public.allergenes_allergene_id_seq OWNED BY public.allergenes.allergene_id;


--
-- Name: avis; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.avis (
    avis_id integer NOT NULL,
    description text NOT NULL,
    user_id integer,
    menu_id integer,
    statut public.review_status DEFAULT 'En attente'::public.review_status,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    is_deleted boolean DEFAULT false,
    qualite public.notes,
    service public.notes,
    prix public.notes
);


ALTER TABLE public.avis OWNER TO db_admin;

--
-- Name: avis_id_seq; Type: SEQUENCE; Schema: public; Owner: db_admin
--

CREATE SEQUENCE public.avis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.avis_id_seq OWNER TO db_admin;

--
-- Name: avis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: db_admin
--

ALTER SEQUENCE public.avis_id_seq OWNED BY public.avis.avis_id;


--
-- Name: commande_details; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.commande_details (
    detail_id integer NOT NULL,
    commande_id integer NOT NULL,
    menu_id integer NOT NULL,
    quantite integer NOT NULL,
    prix_applique double precision NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    is_deleted boolean DEFAULT false
);


ALTER TABLE public.commande_details OWNER TO db_admin;

--
-- Name: commande_details_id_seq; Type: SEQUENCE; Schema: public; Owner: db_admin
--

CREATE SEQUENCE public.commande_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.commande_details_id_seq OWNER TO db_admin;

--
-- Name: commande_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: db_admin
--

ALTER SEQUENCE public.commande_details_id_seq OWNED BY public.commande_details.detail_id;


--
-- Name: commandes; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.commandes (
    commande_id integer NOT NULL,
    numero_commande character varying(50) NOT NULL,
    user_id integer NOT NULL,
    date_prestation date NOT NULL,
    heure_livraison timestamp with time zone NOT NULL,
    prix_total double precision NOT NULL,
    remise_appliquee double precision,
    statut public.order_status DEFAULT 'En attente de validation'::public.order_status,
    date_commande timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    statut_paiement public.payment_status DEFAULT 'En attente de règlement'::public.payment_status NOT NULL,
    statut_materiel public.equipment DEFAULT 'Inclus'::public.equipment NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    is_deleted boolean DEFAULT false
);


ALTER TABLE public.commandes OWNER TO db_admin;

--
-- Name: commandes_id_seq; Type: SEQUENCE; Schema: public; Owner: db_admin
--

CREATE SEQUENCE public.commandes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.commandes_id_seq OWNER TO db_admin;

--
-- Name: commandes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: db_admin
--

ALTER SEQUENCE public.commandes_id_seq OWNED BY public.commandes.commande_id;


--
-- Name: horaires; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.horaires (
    horaire_id integer NOT NULL,
    jour character varying(50) NOT NULL,
    heure_ouverture time without time zone NOT NULL,
    heure_fermeture time without time zone NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    is_deleted boolean DEFAULT false
);


ALTER TABLE public.horaires OWNER TO db_admin;

--
-- Name: horaires_horaire_id_seq; Type: SEQUENCE; Schema: public; Owner: db_admin
--

CREATE SEQUENCE public.horaires_horaire_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.horaires_horaire_id_seq OWNER TO db_admin;

--
-- Name: horaires_horaire_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: db_admin
--

ALTER SEQUENCE public.horaires_horaire_id_seq OWNED BY public.horaires.horaire_id;


--
-- Name: menus; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.menus (
    menu_id integer NOT NULL,
    titre character varying(50) NOT NULL,
    nombre_personnes_min integer NOT NULL,
    prix_par_personne double precision NOT NULL,
    description text NOT NULL,
    quantite_disponible integer NOT NULL,
    images_url character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    is_deleted boolean DEFAULT false
);


ALTER TABLE public.menus OWNER TO db_admin;

--
-- Name: menus_menu_id_seq; Type: SEQUENCE; Schema: public; Owner: db_admin
--

CREATE SEQUENCE public.menus_menu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menus_menu_id_seq OWNER TO db_admin;

--
-- Name: menus_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: db_admin
--

ALTER SEQUENCE public.menus_menu_id_seq OWNED BY public.menus.menu_id;


--
-- Name: menus_plats; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.menus_plats (
    menu_id integer NOT NULL,
    plat_id integer NOT NULL
);


ALTER TABLE public.menus_plats OWNER TO db_admin;

--
-- Name: menus_themes; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.menus_themes (
    menu_id integer NOT NULL,
    theme_id integer NOT NULL
);


ALTER TABLE public.menus_themes OWNER TO db_admin;

--
-- Name: plats; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.plats (
    plat_id integer NOT NULL,
    titre character varying(50) NOT NULL,
    type_de_plat public.dish_types NOT NULL,
    images_url character varying(255)
);


ALTER TABLE public.plats OWNER TO db_admin;

--
-- Name: plats_allergenes; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.plats_allergenes (
    plat_id integer NOT NULL,
    allergene_id integer NOT NULL
);


ALTER TABLE public.plats_allergenes OWNER TO db_admin;

--
-- Name: plats_plat_id_seq; Type: SEQUENCE; Schema: public; Owner: db_admin
--

CREATE SEQUENCE public.plats_plat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.plats_plat_id_seq OWNER TO db_admin;

--
-- Name: plats_plat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: db_admin
--

ALTER SEQUENCE public.plats_plat_id_seq OWNED BY public.plats.plat_id;


--
-- Name: plats_regimes; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.plats_regimes (
    plat_id integer NOT NULL,
    regime_id integer NOT NULL
);


ALTER TABLE public.plats_regimes OWNER TO db_admin;

--
-- Name: plats_themes; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.plats_themes (
    plat_id integer NOT NULL,
    theme_id integer NOT NULL
);


ALTER TABLE public.plats_themes OWNER TO db_admin;

--
-- Name: regimes; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.regimes (
    regime_id integer NOT NULL,
    libelle character varying(50) NOT NULL
);


ALTER TABLE public.regimes OWNER TO db_admin;

--
-- Name: regimes_regime_id_seq; Type: SEQUENCE; Schema: public; Owner: db_admin
--

CREATE SEQUENCE public.regimes_regime_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.regimes_regime_id_seq OWNER TO db_admin;

--
-- Name: regimes_regime_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: db_admin
--

ALTER SEQUENCE public.regimes_regime_id_seq OWNED BY public.regimes.regime_id;


--
-- Name: themes; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.themes (
    theme_id integer NOT NULL,
    libelle character varying(50) NOT NULL
);


ALTER TABLE public.themes OWNER TO db_admin;

--
-- Name: themes_theme_id_seq; Type: SEQUENCE; Schema: public; Owner: db_admin
--

CREATE SEQUENCE public.themes_theme_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.themes_theme_id_seq OWNER TO db_admin;

--
-- Name: themes_theme_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: db_admin
--

ALTER SEQUENCE public.themes_theme_id_seq OWNED BY public.themes.theme_id;


--
-- Name: utilisateurs; Type: TABLE; Schema: public; Owner: db_admin
--

CREATE TABLE public.utilisateurs (
    user_id integer NOT NULL,
    email character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    prenom character varying(50) NOT NULL,
    nom character varying(50) NOT NULL,
    telephone character varying(50),
    adresse character varying(255),
    code_postal character varying(50),
    ville character varying(50),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    is_deleted boolean,
    pays character varying(50),
    role public.user_role DEFAULT 'Client'::public.user_role NOT NULL
);


ALTER TABLE public.utilisateurs OWNER TO db_admin;

--
-- Name: utilisateurs_id_seq; Type: SEQUENCE; Schema: public; Owner: db_admin
--

CREATE SEQUENCE public.utilisateurs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.utilisateurs_id_seq OWNER TO db_admin;

--
-- Name: utilisateurs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: db_admin
--

ALTER SEQUENCE public.utilisateurs_id_seq OWNED BY public.utilisateurs.user_id;


--
-- Name: allergenes allergene_id; Type: DEFAULT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.allergenes ALTER COLUMN allergene_id SET DEFAULT nextval('public.allergenes_allergene_id_seq'::regclass);


--
-- Name: avis avis_id; Type: DEFAULT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.avis ALTER COLUMN avis_id SET DEFAULT nextval('public.avis_id_seq'::regclass);


--
-- Name: commande_details detail_id; Type: DEFAULT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.commande_details ALTER COLUMN detail_id SET DEFAULT nextval('public.commande_details_id_seq'::regclass);


--
-- Name: commandes commande_id; Type: DEFAULT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.commandes ALTER COLUMN commande_id SET DEFAULT nextval('public.commandes_id_seq'::regclass);


--
-- Name: horaires horaire_id; Type: DEFAULT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.horaires ALTER COLUMN horaire_id SET DEFAULT nextval('public.horaires_horaire_id_seq'::regclass);


--
-- Name: menus menu_id; Type: DEFAULT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.menus ALTER COLUMN menu_id SET DEFAULT nextval('public.menus_menu_id_seq'::regclass);


--
-- Name: plats plat_id; Type: DEFAULT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.plats ALTER COLUMN plat_id SET DEFAULT nextval('public.plats_plat_id_seq'::regclass);


--
-- Name: regimes regime_id; Type: DEFAULT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.regimes ALTER COLUMN regime_id SET DEFAULT nextval('public.regimes_regime_id_seq'::regclass);


--
-- Name: themes theme_id; Type: DEFAULT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.themes ALTER COLUMN theme_id SET DEFAULT nextval('public.themes_theme_id_seq'::regclass);


--
-- Name: utilisateurs user_id; Type: DEFAULT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.utilisateurs ALTER COLUMN user_id SET DEFAULT nextval('public.utilisateurs_id_seq'::regclass);


--
-- Name: allergenes allergenes_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.allergenes
    ADD CONSTRAINT allergenes_pkey PRIMARY KEY (allergene_id);


--
-- Name: avis avis_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.avis
    ADD CONSTRAINT avis_pkey PRIMARY KEY (avis_id);


--
-- Name: commande_details commande_details_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.commande_details
    ADD CONSTRAINT commande_details_pkey PRIMARY KEY (detail_id);


--
-- Name: commandes commandes_numero_commande_key; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.commandes
    ADD CONSTRAINT commandes_numero_commande_key UNIQUE (numero_commande);


--
-- Name: commandes commandes_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.commandes
    ADD CONSTRAINT commandes_pkey PRIMARY KEY (commande_id);


--
-- Name: horaires horaires_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.horaires
    ADD CONSTRAINT horaires_pkey PRIMARY KEY (horaire_id);


--
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (menu_id);


--
-- Name: menus_plats menus_plats_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.menus_plats
    ADD CONSTRAINT menus_plats_pkey PRIMARY KEY (menu_id, plat_id);


--
-- Name: menus_themes menus_themes_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.menus_themes
    ADD CONSTRAINT menus_themes_pkey PRIMARY KEY (menu_id, theme_id);


--
-- Name: plats_allergenes plats_allergenes_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.plats_allergenes
    ADD CONSTRAINT plats_allergenes_pkey PRIMARY KEY (plat_id, allergene_id);


--
-- Name: plats plats_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.plats
    ADD CONSTRAINT plats_pkey PRIMARY KEY (plat_id);


--
-- Name: plats_regimes plats_regimes_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.plats_regimes
    ADD CONSTRAINT plats_regimes_pkey PRIMARY KEY (plat_id, regime_id);


--
-- Name: plats_themes plats_themes_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.plats_themes
    ADD CONSTRAINT plats_themes_pkey PRIMARY KEY (plat_id, theme_id);


--
-- Name: regimes regimes_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.regimes
    ADD CONSTRAINT regimes_pkey PRIMARY KEY (regime_id);


--
-- Name: themes themes_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.themes
    ADD CONSTRAINT themes_pkey PRIMARY KEY (theme_id);


--
-- Name: utilisateurs utilisateurs_pkey; Type: CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_pkey PRIMARY KEY (user_id);


--
-- Name: ix_avis_id; Type: INDEX; Schema: public; Owner: db_admin
--

CREATE INDEX ix_avis_id ON public.avis USING btree (avis_id);


--
-- Name: ix_commande_details_id; Type: INDEX; Schema: public; Owner: db_admin
--

CREATE INDEX ix_commande_details_id ON public.commande_details USING btree (detail_id);


--
-- Name: ix_commandes_id; Type: INDEX; Schema: public; Owner: db_admin
--

CREATE INDEX ix_commandes_id ON public.commandes USING btree (commande_id);


--
-- Name: ix_menus_menu_id; Type: INDEX; Schema: public; Owner: db_admin
--

CREATE INDEX ix_menus_menu_id ON public.menus USING btree (menu_id);


--
-- Name: ix_plats_plat_id; Type: INDEX; Schema: public; Owner: db_admin
--

CREATE INDEX ix_plats_plat_id ON public.plats USING btree (plat_id);


--
-- Name: ix_utilisateurs_email; Type: INDEX; Schema: public; Owner: db_admin
--

CREATE UNIQUE INDEX ix_utilisateurs_email ON public.utilisateurs USING btree (email);


--
-- Name: ix_utilisateurs_id; Type: INDEX; Schema: public; Owner: db_admin
--

CREATE INDEX ix_utilisateurs_id ON public.utilisateurs USING btree (user_id);


--
-- Name: avis fk_avis_menus; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.avis
    ADD CONSTRAINT fk_avis_menus FOREIGN KEY (menu_id) REFERENCES public.menus(menu_id);


--
-- Name: avis fk_avis_utilisateurs; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.avis
    ADD CONSTRAINT fk_avis_utilisateurs FOREIGN KEY (user_id) REFERENCES public.utilisateurs(user_id);


--
-- Name: commande_details fk_commande_details_commandes; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.commande_details
    ADD CONSTRAINT fk_commande_details_commandes FOREIGN KEY (commande_id) REFERENCES public.commandes(commande_id);


--
-- Name: commande_details fk_commande_details_menus; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.commande_details
    ADD CONSTRAINT fk_commande_details_menus FOREIGN KEY (menu_id) REFERENCES public.menus(menu_id);


--
-- Name: commandes fk_commandes_utilisateurs; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.commandes
    ADD CONSTRAINT fk_commandes_utilisateurs FOREIGN KEY (user_id) REFERENCES public.utilisateurs(user_id);


--
-- Name: menus_plats fk_menus_plats_menus; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.menus_plats
    ADD CONSTRAINT fk_menus_plats_menus FOREIGN KEY (menu_id) REFERENCES public.menus(menu_id) ON DELETE CASCADE;


--
-- Name: menus_plats fk_menus_plats_plats; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.menus_plats
    ADD CONSTRAINT fk_menus_plats_plats FOREIGN KEY (plat_id) REFERENCES public.plats(plat_id) ON DELETE CASCADE;


--
-- Name: menus_themes fk_menus_themes_menus; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.menus_themes
    ADD CONSTRAINT fk_menus_themes_menus FOREIGN KEY (menu_id) REFERENCES public.menus(menu_id) ON DELETE CASCADE;


--
-- Name: menus_themes fk_menus_themes_themes; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.menus_themes
    ADD CONSTRAINT fk_menus_themes_themes FOREIGN KEY (theme_id) REFERENCES public.themes(theme_id) ON DELETE CASCADE;


--
-- Name: plats_allergenes fk_plats_allergenes_allergenes; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.plats_allergenes
    ADD CONSTRAINT fk_plats_allergenes_allergenes FOREIGN KEY (allergene_id) REFERENCES public.allergenes(allergene_id) ON DELETE CASCADE;


--
-- Name: plats_allergenes fk_plats_allergenes_plats; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.plats_allergenes
    ADD CONSTRAINT fk_plats_allergenes_plats FOREIGN KEY (plat_id) REFERENCES public.plats(plat_id) ON DELETE CASCADE;


--
-- Name: plats_regimes fk_plats_regimes_plats; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.plats_regimes
    ADD CONSTRAINT fk_plats_regimes_plats FOREIGN KEY (plat_id) REFERENCES public.plats(plat_id) ON DELETE CASCADE;


--
-- Name: plats_regimes fk_plats_regimes_regimes; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.plats_regimes
    ADD CONSTRAINT fk_plats_regimes_regimes FOREIGN KEY (regime_id) REFERENCES public.regimes(regime_id) ON DELETE CASCADE;


--
-- Name: plats_themes fk_plats_themes_plats; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.plats_themes
    ADD CONSTRAINT fk_plats_themes_plats FOREIGN KEY (plat_id) REFERENCES public.plats(plat_id) ON DELETE CASCADE;


--
-- Name: plats_themes fk_plats_themes_themes; Type: FK CONSTRAINT; Schema: public; Owner: db_admin
--

ALTER TABLE ONLY public.plats_themes
    ADD CONSTRAINT fk_plats_themes_themes FOREIGN KEY (theme_id) REFERENCES public.themes(theme_id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO db_admin;


--
-- PostgreSQL database dump complete
--

\unrestrict 7CnkoGLAp9617YhUXnKI5fPBh1tPYceTlTf1qXQwj2ffMCXQWefRlGt6an5gOSk

