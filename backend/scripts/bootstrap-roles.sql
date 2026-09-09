-- Privileged operator-only bootstrap, after separately approved infrastructure creation.
-- Run against the noryva database as its RDS-managed administrator over verified TLS.
-- Not a domain migration and never invoked by the API or ordinary CI.
BEGIN;
REVOKE ALL ON DATABASE noryva FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
DO $$ BEGIN
 IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'noryva_api') THEN
  CREATE ROLE noryva_api LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS;
 END IF;
 IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'noryva_migrator') THEN
  CREATE ROLE noryva_migrator LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS;
 END IF;
END $$;
GRANT rds_iam TO noryva_api, noryva_migrator;
GRANT CONNECT ON DATABASE noryva TO noryva_api, noryva_migrator;
ALTER SCHEMA public OWNER TO noryva_migrator;
GRANT USAGE ON SCHEMA public TO noryva_api;
-- Migration 0001 grants explicit domain DML; API never owns schema/tables.
-- Verify pre-existing roles have these attributes and no privileged memberships.
COMMIT;
