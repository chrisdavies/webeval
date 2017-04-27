
-- Table: public.users

-- DROP TABLE public.users;

CREATE TABLE public.users
(
    id integer NOT NULL DEFAULT nextval('users_id_seq'::regclass),
    name character varying(255) COLLATE pg_catalog."default",
    email character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT users_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.users
    OWNER to postgres;

-- Index: users_email_index

-- DROP INDEX public.users_email_index;

CREATE UNIQUE INDEX users_email_index
    ON public.users USING btree
    (email COLLATE pg_catalog."default")
    TABLESPACE pg_default;