-- Extensions requises par le schéma foncier (les vues utilisent public.unaccent).
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS "unaccent" WITH SCHEMA public;
