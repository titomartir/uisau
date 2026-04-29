-- SCRIPT COMPLETO PARA PGADMIN QUERY TOOL (POSTGRESQL 15.x)
-- Incluye: tipos, tablas, secuencias, constraints, indices y datos.
-- Recomendado: ejecutar en una base vacia llamada encuesta_satisfaccion.
-- Si ya existen objetos con el mismo nombre, puede fallar por duplicados.

--
-- PostgreSQL database dump
--


-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2026-04-23 15:38:16

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
-- TOC entry 874 (class 1247 OID 18052)
-- Name: enum_preguntas_tipo_respuesta; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_preguntas_tipo_respuesta AS ENUM (
    'likert_5',
    'texto',
    'si_no',
    'seleccion_unica',
    'fecha',
    'hora',
    'checkbox'
);


--
-- TOC entry 883 (class 1247 OID 18107)
-- Name: enum_respuestas_encabezado_servicio; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_respuestas_encabezado_servicio AS ENUM (
    'consulta_externa',
    'emergencia',
    'encamamiento'
);


--
-- TOC entry 865 (class 1247 OID 18017)
-- Name: enum_usuarios_rol; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_usuarios_rol AS ENUM (
    'admin',
    'viewer'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 18039)
-- Name: encuestas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.encuestas (
    id integer NOT NULL,
    nombre character varying(255) NOT NULL,
    descripcion text,
    version character varying(20) DEFAULT '1.0'::character varying,
    activa boolean DEFAULT true,
    fecha_creacion timestamp with time zone
);


--
-- TOC entry 223 (class 1259 OID 18038)
-- Name: encuestas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.encuestas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 223
-- Name: encuestas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.encuestas_id_seq OWNED BY public.encuestas.id;


--
-- TOC entry 228 (class 1259 OID 18091)
-- Name: opciones_respuesta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.opciones_respuesta (
    id integer NOT NULL,
    pregunta_id integer NOT NULL,
    valor_texto character varying(255) NOT NULL,
    puntaje integer,
    orden integer
);


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN opciones_respuesta.puntaje; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.opciones_respuesta.puntaje IS 'Para opciones Likert: 1-5';


--
-- TOC entry 227 (class 1259 OID 18090)
-- Name: opciones_respuesta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.opciones_respuesta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 227
-- Name: opciones_respuesta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.opciones_respuesta_id_seq OWNED BY public.opciones_respuesta.id;


--
-- TOC entry 226 (class 1259 OID 18068)
-- Name: preguntas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.preguntas (
    id integer NOT NULL,
    encuesta_id integer NOT NULL,
    texto_pregunta text NOT NULL,
    tipo_respuesta public.enum_preguntas_tipo_respuesta NOT NULL,
    categoria character varying(100),
    orden integer NOT NULL,
    dependencia jsonb,
    requerido boolean DEFAULT true
);


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN preguntas.categoria; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.preguntas.categoria IS 'Agrupa las preguntas: trato_atencion, servicios_apoyo, comunicacion, tiempo_condiciones, encamamiento, satisfaccion_global, preguntas_abiertas';


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN preguntas.dependencia; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.preguntas.dependencia IS 'Ej: {"campo":"servicio","valor":"encamamiento"} o {"campo":"servicio_seleccionado","valor":"psicologia"}';


--
-- TOC entry 225 (class 1259 OID 18067)
-- Name: preguntas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.preguntas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 225
-- Name: preguntas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.preguntas_id_seq OWNED BY public.preguntas.id;


--
-- TOC entry 232 (class 1259 OID 18138)
-- Name: respuestas_detalle; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.respuestas_detalle (
    id integer NOT NULL,
    respuesta_encabezado_id integer NOT NULL,
    pregunta_id integer NOT NULL,
    opcion_id integer,
    respuesta_texto text,
    created_at timestamp with time zone NOT NULL
);


--
-- TOC entry 231 (class 1259 OID 18137)
-- Name: respuestas_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.respuestas_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 231
-- Name: respuestas_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.respuestas_detalle_id_seq OWNED BY public.respuestas_detalle.id;


--
-- TOC entry 230 (class 1259 OID 18114)
-- Name: respuestas_encabezado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.respuestas_encabezado (
    id integer NOT NULL,
    encuesta_id integer NOT NULL,
    fecha_inicio timestamp with time zone,
    fecha_fin timestamp with time zone,
    origen_etnico character varying(100),
    edad integer,
    sexo character varying(30),
    departamento character varying(100),
    municipio character varying(100),
    hospital character varying(200),
    servicio public.enum_respuestas_encabezado_servicio NOT NULL,
    telefono_encriptado text,
    email_contacto character varying(255),
    acepta_contacto boolean DEFAULT false,
    ip_address character varying(45),
    user_agent text,
    revisada boolean DEFAULT false,
    created_at timestamp with time zone NOT NULL
);


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN respuestas_encabezado.revisada; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.respuestas_encabezado.revisada IS 'Marcada como revisada por el administrador';


--
-- TOC entry 229 (class 1259 OID 18113)
-- Name: respuestas_encabezado_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.respuestas_encabezado_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 229
-- Name: respuestas_encabezado_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.respuestas_encabezado_id_seq OWNED BY public.respuestas_encabezado.id;


--
-- TOC entry 222 (class 1259 OID 18022)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    rol public.enum_usuarios_rol DEFAULT 'admin'::public.enum_usuarios_rol NOT NULL,
    last_login timestamp with time zone,
    created_at timestamp with time zone NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 18021)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 221
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 4894 (class 2604 OID 18042)
-- Name: encuestas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encuestas ALTER COLUMN id SET DEFAULT nextval('public.encuestas_id_seq'::regclass);


--
-- TOC entry 4899 (class 2604 OID 18094)
-- Name: opciones_respuesta id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opciones_respuesta ALTER COLUMN id SET DEFAULT nextval('public.opciones_respuesta_id_seq'::regclass);


--
-- TOC entry 4897 (class 2604 OID 18071)
-- Name: preguntas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.preguntas ALTER COLUMN id SET DEFAULT nextval('public.preguntas_id_seq'::regclass);


--
-- TOC entry 4903 (class 2604 OID 18141)
-- Name: respuestas_detalle id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.respuestas_detalle ALTER COLUMN id SET DEFAULT nextval('public.respuestas_detalle_id_seq'::regclass);


--
-- TOC entry 4900 (class 2604 OID 18117)
-- Name: respuestas_encabezado id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.respuestas_encabezado ALTER COLUMN id SET DEFAULT nextval('public.respuestas_encabezado_id_seq'::regclass);


--
-- TOC entry 4892 (class 2604 OID 18025)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 5088 (class 0 OID 18039)
-- Dependencies: 224
-- Data for Name: encuestas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.encuestas (id, nombre, descripcion, version, activa, fecha_creacion) FROM stdin;
1	Encuesta de SatisfacciÃ³n UISAU - Hospitales Nacionales	Encuesta oficial de satisfacciÃ³n del usuario en la Red de Hospitales Nacionales de Guatemala. Su opiniÃ³n nos ayuda a mejorar la calidad de los servicios de salud brindados.	2024.1	t	2026-04-14 21:57:37.393+00
\.


--
-- TOC entry 5092 (class 0 OID 18091)
-- Dependencies: 228
-- Data for Name: opciones_respuesta; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.opciones_respuesta (id, pregunta_id, valor_texto, puntaje, orden) FROM stdin;
1	1	Muy Satisfecho	5	1
2	1	Satisfecho	4	2
3	1	Neutral	3	3
4	1	Insatisfecho	2	4
5	1	Muy Insatisfecho	1	5
6	2	Muy Satisfecho	5	1
7	2	Satisfecho	4	2
8	2	Neutral	3	3
9	2	Insatisfecho	2	4
10	2	Muy Insatisfecho	1	5
11	3	Muy Satisfecho	5	1
12	3	Satisfecho	4	2
13	3	Neutral	3	3
14	3	Insatisfecho	2	4
15	3	Muy Insatisfecho	1	5
16	4	Muy Satisfecho	5	1
17	4	Satisfecho	4	2
18	4	Neutral	3	3
19	4	Insatisfecho	2	4
20	4	Muy Insatisfecho	1	5
21	5	Muy Satisfecho	5	1
22	5	Satisfecho	4	2
23	5	Neutral	3	3
24	5	Insatisfecho	2	4
25	5	Muy Insatisfecho	1	5
26	6	PsicologÃ­a	\N	1
27	6	NutriciÃ³n	\N	2
28	6	Trabajo Social	\N	3
29	6	Laboratorio ClÃ­nico	\N	4
30	6	ImÃ¡genes DiagnÃ³sticas	\N	5
31	6	UISAU	\N	6
32	7	Muy Satisfecho	5	1
33	7	Satisfecho	4	2
34	7	Neutral	3	3
35	7	Insatisfecho	2	4
36	7	Muy Insatisfecho	1	5
37	8	Muy Satisfecho	5	1
38	8	Satisfecho	4	2
39	8	Neutral	3	3
40	8	Insatisfecho	2	4
41	8	Muy Insatisfecho	1	5
42	9	Muy Satisfecho	5	1
43	9	Satisfecho	4	2
44	9	Neutral	3	3
45	9	Insatisfecho	2	4
46	9	Muy Insatisfecho	1	5
47	10	Muy Satisfecho	5	1
48	10	Satisfecho	4	2
49	10	Neutral	3	3
50	10	Insatisfecho	2	4
51	10	Muy Insatisfecho	1	5
52	11	Muy Satisfecho	5	1
53	11	Satisfecho	4	2
54	11	Neutral	3	3
55	11	Insatisfecho	2	4
56	11	Muy Insatisfecho	1	5
57	12	Muy Satisfecho	5	1
58	12	Satisfecho	4	2
59	12	Neutral	3	3
60	12	Insatisfecho	2	4
61	12	Muy Insatisfecho	1	5
62	13	Muy Satisfecho	5	1
63	13	Satisfecho	4	2
64	13	Neutral	3	3
65	13	Insatisfecho	2	4
66	13	Muy Insatisfecho	1	5
67	14	Muy Satisfecho	5	1
68	14	Satisfecho	4	2
69	14	Neutral	3	3
70	14	Insatisfecho	2	4
71	14	Muy Insatisfecho	1	5
72	15	Muy Satisfecho	5	1
73	15	Satisfecho	4	2
74	15	Neutral	3	3
75	15	Insatisfecho	2	4
76	15	Muy Insatisfecho	1	5
77	16	Muy Satisfecho	5	1
78	16	Satisfecho	4	2
79	16	Neutral	3	3
80	16	Insatisfecho	2	4
81	16	Muy Insatisfecho	1	5
82	17	Muy Satisfecho	5	1
83	17	Satisfecho	4	2
84	17	Neutral	3	3
85	17	Insatisfecho	2	4
86	17	Muy Insatisfecho	1	5
87	18	Muy Satisfecho	5	1
88	18	Satisfecho	4	2
89	18	Neutral	3	3
90	18	Insatisfecho	2	4
91	18	Muy Insatisfecho	1	5
92	19	Muy Satisfecho	5	1
93	19	Satisfecho	4	2
94	19	Neutral	3	3
95	19	Insatisfecho	2	4
96	19	Muy Insatisfecho	1	5
97	20	Muy Satisfecho	5	1
98	20	Satisfecho	4	2
99	20	Neutral	3	3
100	20	Insatisfecho	2	4
101	20	Muy Insatisfecho	1	5
102	21	Muy Satisfecho	5	1
103	21	Satisfecho	4	2
104	21	Neutral	3	3
105	21	Insatisfecho	2	4
106	21	Muy Insatisfecho	1	5
107	22	Muy Satisfecho	5	1
108	22	Satisfecho	4	2
109	22	Neutral	3	3
110	22	Insatisfecho	2	4
111	22	Muy Insatisfecho	1	5
112	25	Muy Satisfecho	5	1
113	25	Satisfecho	4	2
114	25	Neutral	3	3
115	25	Insatisfecho	2	4
116	25	Muy Insatisfecho	1	5
117	26	Muy Satisfecho	5	1
118	26	Satisfecho	4	2
119	26	Neutral	3	3
120	26	Insatisfecho	2	4
121	26	Muy Insatisfecho	1	5
122	27	Muy Satisfecho	5	1
123	27	Satisfecho	4	2
124	27	Neutral	3	3
125	27	Insatisfecho	2	4
126	27	Muy Insatisfecho	1	5
127	28	SÃ­	1	1
128	28	Neutral	0	2
129	28	No	-1	3
\.


--
-- TOC entry 5090 (class 0 OID 18068)
-- Dependencies: 226
-- Data for Name: preguntas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.preguntas (id, encuesta_id, texto_pregunta, tipo_respuesta, categoria, orden, dependencia, requerido) FROM stdin;
1	1	Â¿CÃ³mo califica el trato y la atenciÃ³n recibida por el personal mÃ©dico durante su visita?	likert_5	trato_atencion	1	\N	t
2	1	Â¿CÃ³mo califica el trato recibido por el personal de enfermerÃ­a?	likert_5	trato_atencion	2	\N	t
3	1	Â¿CÃ³mo califica la atenciÃ³n brindada en el Ã¡rea de recepciÃ³n o admisiÃ³n del hospital?	likert_5	trato_atencion	3	\N	t
4	1	Â¿Fue tratado con cortesÃ­a, respeto y dignidad por el personal del hospital?	likert_5	trato_atencion	4	\N	t
5	1	Â¿El personal del hospital lo llamÃ³ por su nombre durante la atenciÃ³n?	likert_5	trato_atencion	5	\N	t
6	1	Â¿CuÃ¡les de los siguientes servicios de apoyo recibiÃ³ durante su visita? (Seleccione todos los que apliquen)	checkbox	servicios_apoyo	6	\N	f
7	1	Â¿CÃ³mo califica la atenciÃ³n recibida por el servicio de PsicologÃ­a?	likert_5	servicios_apoyo	7	{"campo": "servicio_seleccionado", "valor": "psicologia"}	f
8	1	Â¿CÃ³mo califica la atenciÃ³n recibida por el servicio de NutriciÃ³n?	likert_5	servicios_apoyo	8	{"campo": "servicio_seleccionado", "valor": "nutricion"}	f
9	1	Â¿CÃ³mo califica la atenciÃ³n recibida por el servicio de Trabajo Social?	likert_5	servicios_apoyo	9	{"campo": "servicio_seleccionado", "valor": "trabajo_social"}	f
10	1	Â¿CÃ³mo califica la atenciÃ³n recibida por el servicio de Laboratorio ClÃ­nico?	likert_5	servicios_apoyo	10	{"campo": "servicio_seleccionado", "valor": "laboratorio"}	f
11	1	Â¿CÃ³mo califica la atenciÃ³n recibida por el servicio de ImÃ¡genes DiagnÃ³sticas?	likert_5	servicios_apoyo	11	{"campo": "servicio_seleccionado", "valor": "imagenes"}	f
12	1	Â¿CÃ³mo califica la atenciÃ³n recibida por UISAU (Unidad de InformaciÃ³n en Salud)?	likert_5	servicios_apoyo	12	{"campo": "servicio_seleccionado", "valor": "uisau"}	f
13	1	Â¿La informaciÃ³n sobre su estado de salud fue explicada de manera clara y comprensible?	likert_5	comunicacion	13	\N	t
14	1	Â¿La informaciÃ³n le fue brindada en un idioma o lenguaje que usted comprende?	likert_5	comunicacion	14	\N	t
15	1	Â¿Le explicaron claramente su diagnÃ³stico, el tratamiento a seguir y los medicamentos recetados?	likert_5	comunicacion	15	\N	t
16	1	Â¿CÃ³mo califica el tiempo de espera para ser atendido por el mÃ©dico o personal de salud?	likert_5	tiempo_condiciones	16	\N	t
17	1	Â¿CÃ³mo califica la comodidad y el mobiliario en la sala de espera?	likert_5	tiempo_condiciones	17	\N	t
18	1	Â¿CÃ³mo califica la limpieza y el orden del Ã¡rea donde fue atendido?	likert_5	tiempo_condiciones	18	\N	t
19	1	Â¿CÃ³mo califica la limpieza de los servicios sanitarios del hospital?	likert_5	tiempo_condiciones	19	\N	t
20	1	Â¿CÃ³mo califica la ventilaciÃ³n e iluminaciÃ³n en el Ã¡rea de espera?	likert_5	tiempo_condiciones	20	\N	t
21	1	Â¿CÃ³mo califica la ventilaciÃ³n e iluminaciÃ³n en el Ã¡rea donde fue atendido?	likert_5	tiempo_condiciones	21	\N	t
22	1	Â¿Se respetÃ³ su privacidad y seguridad personal durante su atenciÃ³n en el hospital?	likert_5	tiempo_condiciones	22	\N	t
23	1	Â¿A quÃ© hora ingresÃ³ al establecimiento de salud?	hora	tiempo_condiciones	23	\N	f
24	1	Â¿A quÃ© hora egresÃ³ del establecimiento de salud?	hora	tiempo_condiciones	24	\N	f
25	1	Â¿CÃ³mo califica el estado, limpieza e higiene de la ropa de cama que se le asignÃ³?	likert_5	encamamiento	25	{"campo": "servicio", "valor": "encamamiento"}	t
26	1	Â¿CÃ³mo califica la calidad, cantidad y puntualidad de los alimentos proporcionados durante su estancia?	likert_5	encamamiento	26	{"campo": "servicio", "valor": "encamamiento"}	t
27	1	En general, Â¿cuÃ¡l es su nivel de satisfacciÃ³n con la atenciÃ³n y los servicios recibidos en este hospital?	likert_5	satisfaccion_global	27	\N	t
28	1	Â¿RecomendarÃ­a este hospital a un familiar, amigo o conocido que necesite atenciÃ³n mÃ©dica?	seleccion_unica	satisfaccion_global	28	\N	t
29	1	Si tuvo alguna experiencia negativa o problema durante su visita, por favor descrÃ­bala (opcional):	texto	preguntas_abiertas	29	\N	f
30	1	Si tuvo alguna experiencia positiva o algo que le gustÃ³ especialmente, por favor descrÃ­bala (opcional):	texto	preguntas_abiertas	30	\N	f
31	1	Â¿QuÃ© recomendaciones o sugerencias tiene para mejorar la calidad del servicio en este hospital? (opcional):	texto	preguntas_abiertas	31	\N	f
\.


--
-- TOC entry 5096 (class 0 OID 18138)
-- Dependencies: 232
-- Data for Name: respuestas_detalle; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.respuestas_detalle (id, respuesta_encabezado_id, pregunta_id, opcion_id, respuesta_texto, created_at) FROM stdin;
1	1	1	3	\N	2026-04-14 22:34:25.648+00
2	1	2	7	\N	2026-04-14 22:34:25.648+00
3	1	3	14	\N	2026-04-14 22:34:25.648+00
4	1	4	19	\N	2026-04-14 22:34:25.648+00
5	1	5	22	\N	2026-04-14 22:34:25.648+00
6	1	6	29	[31]	2026-04-14 22:34:25.648+00
7	1	10	48	\N	2026-04-14 22:34:25.648+00
8	1	12	57	\N	2026-04-14 22:34:25.648+00
9	1	13	63	\N	2026-04-14 22:34:25.648+00
10	1	14	68	\N	2026-04-14 22:34:25.648+00
11	1	15	75	\N	2026-04-14 22:34:25.648+00
12	1	16	81	\N	2026-04-14 22:34:25.648+00
13	1	17	86	\N	2026-04-14 22:34:25.648+00
14	1	18	90	\N	2026-04-14 22:34:25.648+00
15	1	19	96	\N	2026-04-14 22:34:25.648+00
16	1	20	99	\N	2026-04-14 22:34:25.648+00
17	1	21	103	\N	2026-04-14 22:34:25.648+00
18	1	22	108	\N	2026-04-14 22:34:25.648+00
19	1	23	\N	08:32	2026-04-14 22:34:25.648+00
20	1	24	\N	20:33	2026-04-14 22:34:25.648+00
21	1	27	123	\N	2026-04-14 22:34:25.648+00
22	1	28	127	\N	2026-04-14 22:34:25.648+00
\.


--
-- TOC entry 5094 (class 0 OID 18114)
-- Dependencies: 230
-- Data for Name: respuestas_encabezado; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.respuestas_encabezado (id, encuesta_id, fecha_inicio, fecha_fin, origen_etnico, edad, sexo, departamento, municipio, hospital, servicio, telefono_encriptado, email_contacto, acepta_contacto, ip_address, user_agent, revisada, created_at) FROM stdin;
1	1	2026-04-14 22:28:15.194+00	2026-04-14 22:34:25.607+00	Ladino	43	Masculino	El QuichÃ©	Santa Cruz del QuichÃ©	Hospital Regional de El QuichÃ©	emergencia	\N	\N	t	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	t	2026-04-14 22:34:25.61+00
\.


--
-- TOC entry 5086 (class 0 OID 18022)
-- Dependencies: 222
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usuarios (id, email, password_hash, rol, last_login, created_at) FROM stdin;
1	admin@uisau.gob.gt	$2a$12$dZrWuPdONdv9ZOrIjPTNB.uSkyOFxf.7/69sY0An0qAnA.yrjqfYe	admin	2026-04-21 16:48:48.913+00	2026-04-14 21:57:38.385+00
\.


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 223
-- Name: encuestas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.encuestas_id_seq', 1, true);


--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 227
-- Name: opciones_respuesta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.opciones_respuesta_id_seq', 129, true);


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 225
-- Name: preguntas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.preguntas_id_seq', 31, true);


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 231
-- Name: respuestas_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.respuestas_detalle_id_seq', 22, true);


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 229
-- Name: respuestas_encabezado_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.respuestas_encabezado_id_seq', 1, true);


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 221
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 1, true);


--
-- TOC entry 4913 (class 2606 OID 18050)
-- Name: encuestas encuestas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encuestas
    ADD CONSTRAINT encuestas_pkey PRIMARY KEY (id);


--
-- TOC entry 4920 (class 2606 OID 18099)
-- Name: opciones_respuesta opciones_respuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opciones_respuesta
    ADD CONSTRAINT opciones_respuesta_pkey PRIMARY KEY (id);


--
-- TOC entry 4918 (class 2606 OID 18081)
-- Name: preguntas preguntas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.preguntas
    ADD CONSTRAINT preguntas_pkey PRIMARY KEY (id);


--
-- TOC entry 4929 (class 2606 OID 18149)
-- Name: respuestas_detalle respuestas_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.respuestas_detalle
    ADD CONSTRAINT respuestas_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 4926 (class 2606 OID 18127)
-- Name: respuestas_encabezado respuestas_encabezado_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.respuestas_encabezado
    ADD CONSTRAINT respuestas_encabezado_pkey PRIMARY KEY (id);


--
-- TOC entry 4905 (class 2606 OID 18401)
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- TOC entry 4907 (class 2606 OID 18403)
-- Name: usuarios usuarios_email_key1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key1 UNIQUE (email);


--
-- TOC entry 4909 (class 2606 OID 18399)
-- Name: usuarios usuarios_email_key2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key2 UNIQUE (email);


--
-- TOC entry 4911 (class 2606 OID 18035)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4921 (class 1259 OID 18105)
-- Name: opciones_respuesta_pregunta_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX opciones_respuesta_pregunta_id ON public.opciones_respuesta USING btree (pregunta_id);


--
-- TOC entry 4914 (class 1259 OID 18422)
-- Name: preguntas_categoria; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX preguntas_categoria ON public.preguntas USING btree (categoria);


--
-- TOC entry 4915 (class 1259 OID 18087)
-- Name: preguntas_encuesta_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX preguntas_encuesta_id ON public.preguntas USING btree (encuesta_id);


--
-- TOC entry 4916 (class 1259 OID 18423)
-- Name: preguntas_orden; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX preguntas_orden ON public.preguntas USING btree (orden);


--
-- TOC entry 4930 (class 1259 OID 18166)
-- Name: respuestas_detalle_pregunta_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX respuestas_detalle_pregunta_id ON public.respuestas_detalle USING btree (pregunta_id);


--
-- TOC entry 4931 (class 1259 OID 18165)
-- Name: respuestas_detalle_respuesta_encabezado_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX respuestas_detalle_respuesta_encabezado_id ON public.respuestas_detalle USING btree (respuesta_encabezado_id);


--
-- TOC entry 4922 (class 1259 OID 18445)
-- Name: respuestas_encabezado_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX respuestas_encabezado_created_at ON public.respuestas_encabezado USING btree (created_at);


--
-- TOC entry 4923 (class 1259 OID 18136)
-- Name: respuestas_encabezado_encuesta_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX respuestas_encabezado_encuesta_id ON public.respuestas_encabezado USING btree (encuesta_id);


--
-- TOC entry 4924 (class 1259 OID 18438)
-- Name: respuestas_encabezado_hospital; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX respuestas_encabezado_hospital ON public.respuestas_encabezado USING btree (hospital);


--
-- TOC entry 4927 (class 1259 OID 18439)
-- Name: respuestas_encabezado_servicio; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX respuestas_encabezado_servicio ON public.respuestas_encabezado USING btree (servicio);


--
-- TOC entry 4933 (class 2606 OID 18427)
-- Name: opciones_respuesta opciones_respuesta_pregunta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opciones_respuesta
    ADD CONSTRAINT opciones_respuesta_pregunta_id_fkey FOREIGN KEY (pregunta_id) REFERENCES public.preguntas(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4932 (class 2606 OID 18415)
-- Name: preguntas preguntas_encuesta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.preguntas
    ADD CONSTRAINT preguntas_encuesta_id_fkey FOREIGN KEY (encuesta_id) REFERENCES public.encuestas(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4935 (class 2606 OID 18457)
-- Name: respuestas_detalle respuestas_detalle_opcion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.respuestas_detalle
    ADD CONSTRAINT respuestas_detalle_opcion_id_fkey FOREIGN KEY (opcion_id) REFERENCES public.opciones_respuesta(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4936 (class 2606 OID 18452)
-- Name: respuestas_detalle respuestas_detalle_pregunta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.respuestas_detalle
    ADD CONSTRAINT respuestas_detalle_pregunta_id_fkey FOREIGN KEY (pregunta_id) REFERENCES public.preguntas(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4937 (class 2606 OID 18447)
-- Name: respuestas_detalle respuestas_detalle_respuesta_encabezado_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.respuestas_detalle
    ADD CONSTRAINT respuestas_detalle_respuesta_encabezado_id_fkey FOREIGN KEY (respuesta_encabezado_id) REFERENCES public.respuestas_encabezado(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4934 (class 2606 OID 18433)
-- Name: respuestas_encabezado respuestas_encabezado_encuesta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.respuestas_encabezado
    ADD CONSTRAINT respuestas_encabezado_encuesta_id_fkey FOREIGN KEY (encuesta_id) REFERENCES public.encuestas(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2026-04-23 15:38:17

--
-- PostgreSQL database dump complete
--


