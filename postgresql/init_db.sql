CREATE SEQUENCE IF NOT EXISTS messages_id_seq;
CREATE TABLE IF NOT EXISTS "public"."messages" (
    "id" bigint DEFAULT nextval('messages_id_seq'::regclass),
    "name" character varying(255),
    "body" text,
    "inserted_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    PRIMARY KEY ("id")
) TABLESPACE "pg_default";