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
-- Name: time_subtype_diff(time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.time_subtype_diff(x time without time zone, y time without time zone) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $$SELECT EXTRACT(EPOCH FROM (x - y))$$;


--
-- Name: timerange; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.timerange AS RANGE (
    subtype = time without time zone,
    multirange_type_name = public.timemultirange,
    subtype_diff = public.time_subtype_diff
);


--
-- Name: least_overlap_timerange(public.timerange, public.timerange); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.least_overlap_timerange(input_range public.timerange, range_column public.timerange) RETURNS interval
    LANGUAGE plpgsql
    AS $$
      BEGIN
        RETURN GREATEST(
          LEAST(upper(input_range), upper(range_column)) - GREATEST(lower(input_range), lower(range_column)),
          '0 seconds'::interval
        );
      END;
      $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: aulas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.aulas (
    id bigint NOT NULL,
    numero_aula integer,
    piso integer,
    tipo integer,
    capacidad integer,
    tipo_pizarron integer,
    habilitada boolean
);


--
-- Name: aulas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.aulas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aulas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.aulas_id_seq OWNED BY public.aulas.id;


--
-- Name: caracteristicas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.caracteristicas (
    id bigint NOT NULL,
    nombre character varying
);


--
-- Name: caracteristicas_aula; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.caracteristicas_aula (
    cantidad integer,
    caracteristica_id bigint NOT NULL,
    aula_id bigint NOT NULL
);


--
-- Name: caracteristicas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.caracteristicas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: caracteristicas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.caracteristicas_id_seq OWNED BY public.caracteristicas.id;


--
-- Name: periodos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.periodos (
    "año" integer NOT NULL,
    inicio_cuatrimestre_uno date,
    fin_cuatrimestre_uno date,
    inicio_cuatrimestre_dos date,
    fin_cuatrimestre_dos date
);


--
-- Name: renglones_reserva_esporadica; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.renglones_reserva_esporadica (
    id bigint NOT NULL,
    fecha date,
    reserva_id bigint,
    aula_id bigint,
    horario public.timerange
);


--
-- Name: renglones_reserva_esporadica_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.renglones_reserva_esporadica_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renglones_reserva_esporadica_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.renglones_reserva_esporadica_id_seq OWNED BY public.renglones_reserva_esporadica.id;


--
-- Name: renglones_reserva_periodica; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.renglones_reserva_periodica (
    id bigint NOT NULL,
    dia integer,
    reserva_id bigint,
    aula_id bigint,
    horario public.timerange
);


--
-- Name: renglones_reserva_periodica_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.renglones_reserva_periodica_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renglones_reserva_periodica_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.renglones_reserva_periodica_id_seq OWNED BY public.renglones_reserva_periodica.id;


--
-- Name: reservas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reservas (
    id bigint NOT NULL,
    id_docente character varying,
    nombre_docente character varying,
    apellido_docente character varying,
    correo_docente character varying,
    id_curso integer,
    nombre_curso character varying,
    "año" character varying,
    cantidad_alumnos integer,
    fecha_solicitud timestamp(6) without time zone,
    type character varying,
    periodicidad integer,
    bedel_id character varying
);


--
-- Name: reservas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reservas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reservas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reservas_id_seq OWNED BY public.reservas.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuarios (
    id character varying NOT NULL,
    turno integer,
    nombre character varying,
    apellido character varying,
    password_digest character varying,
    deleted_at timestamp(6) without time zone,
    type character varying
);


--
-- Name: aulas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aulas ALTER COLUMN id SET DEFAULT nextval('public.aulas_id_seq'::regclass);


--
-- Name: caracteristicas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caracteristicas ALTER COLUMN id SET DEFAULT nextval('public.caracteristicas_id_seq'::regclass);


--
-- Name: renglones_reserva_esporadica id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.renglones_reserva_esporadica ALTER COLUMN id SET DEFAULT nextval('public.renglones_reserva_esporadica_id_seq'::regclass);


--
-- Name: renglones_reserva_periodica id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.renglones_reserva_periodica ALTER COLUMN id SET DEFAULT nextval('public.renglones_reserva_periodica_id_seq'::regclass);


--
-- Name: reservas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservas ALTER COLUMN id SET DEFAULT nextval('public.reservas_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: aulas aulas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aulas
    ADD CONSTRAINT aulas_pkey PRIMARY KEY (id);


--
-- Name: caracteristicas_aula caracteristicas_aula_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caracteristicas_aula
    ADD CONSTRAINT caracteristicas_aula_pkey PRIMARY KEY (caracteristica_id, aula_id);


--
-- Name: caracteristicas caracteristicas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caracteristicas
    ADD CONSTRAINT caracteristicas_pkey PRIMARY KEY (id);


--
-- Name: renglones_reserva_esporadica renglones_reserva_esporadica_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.renglones_reserva_esporadica
    ADD CONSTRAINT renglones_reserva_esporadica_pkey PRIMARY KEY (id);


--
-- Name: renglones_reserva_periodica renglones_reserva_periodica_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.renglones_reserva_periodica
    ADD CONSTRAINT renglones_reserva_periodica_pkey PRIMARY KEY (id);


--
-- Name: reservas reservas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservas
    ADD CONSTRAINT reservas_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: index_caracteristicas_aula_on_aula_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_caracteristicas_aula_on_aula_id ON public.caracteristicas_aula USING btree (aula_id);


--
-- Name: index_caracteristicas_aula_on_caracteristica_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_caracteristicas_aula_on_caracteristica_id ON public.caracteristicas_aula USING btree (caracteristica_id);


--
-- Name: index_periodos_on_año; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "index_periodos_on_año" ON public.periodos USING btree ("año");


--
-- Name: index_renglones_reserva_esporadica_on_aula_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_renglones_reserva_esporadica_on_aula_id ON public.renglones_reserva_esporadica USING btree (aula_id);


--
-- Name: index_renglones_reserva_esporadica_on_reserva_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_renglones_reserva_esporadica_on_reserva_id ON public.renglones_reserva_esporadica USING btree (reserva_id);


--
-- Name: index_renglones_reserva_periodica_on_aula_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_renglones_reserva_periodica_on_aula_id ON public.renglones_reserva_periodica USING btree (aula_id);


--
-- Name: index_renglones_reserva_periodica_on_reserva_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_renglones_reserva_periodica_on_reserva_id ON public.renglones_reserva_periodica USING btree (reserva_id);


--
-- Name: index_reservas_on_bedel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reservas_on_bedel_id ON public.reservas USING btree (bedel_id);


--
-- Name: renglones_reserva_periodica fk_rails_1489918946; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.renglones_reserva_periodica
    ADD CONSTRAINT fk_rails_1489918946 FOREIGN KEY (reserva_id) REFERENCES public.reservas(id);


--
-- Name: caracteristicas_aula fk_rails_1c306eeb61; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caracteristicas_aula
    ADD CONSTRAINT fk_rails_1c306eeb61 FOREIGN KEY (caracteristica_id) REFERENCES public.caracteristicas(id);


--
-- Name: renglones_reserva_esporadica fk_rails_4e01ee0f08; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.renglones_reserva_esporadica
    ADD CONSTRAINT fk_rails_4e01ee0f08 FOREIGN KEY (aula_id) REFERENCES public.aulas(id);


--
-- Name: caracteristicas_aula fk_rails_64cd310ea3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caracteristicas_aula
    ADD CONSTRAINT fk_rails_64cd310ea3 FOREIGN KEY (aula_id) REFERENCES public.aulas(id);


--
-- Name: renglones_reserva_esporadica fk_rails_97673ced30; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.renglones_reserva_esporadica
    ADD CONSTRAINT fk_rails_97673ced30 FOREIGN KEY (reserva_id) REFERENCES public.reservas(id);


--
-- Name: renglones_reserva_periodica fk_rails_c910beb283; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.renglones_reserva_periodica
    ADD CONSTRAINT fk_rails_c910beb283 FOREIGN KEY (aula_id) REFERENCES public.aulas(id);


--
-- Name: reservas fk_rails_f5b1190871; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservas
    ADD CONSTRAINT fk_rails_f5b1190871 FOREIGN KEY (bedel_id) REFERENCES public.usuarios(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20240819024915'),
('20240818232231'),
('20240817011457'),
('20240817011456'),
('20240817011455'),
('20240816225313'),
('20240707210347'),
('20240707205752'),
('20240707173608'),
('20240707173158'),
('20240707044236'),
('20240707040917'),
('20240707034312'),
('20240704190930'),
('20240603184531');

