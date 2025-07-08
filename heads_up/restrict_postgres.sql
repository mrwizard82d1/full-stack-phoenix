-- Step 1: Revoke global privileges from the `postgres` user
ALTER USER postgres WITH
  NOSUPERUSER
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  NOLOGIN;

-- (Optionally re-enable login if needed)
ALTER USER postgres WITH LOGIN;

-- Step 2: Grant access to `heads_up_dev` database
GRANT ALL PRIVILEGES ON DATABASE heads_up_dev TO postgres;

-- Step 3: Connect to the heads_up_dev database
\c heads_up_dev

-- Step 4: Grant privileges on all current objects
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO postgres;

-- Step 5: Set default privileges for future objects
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL ON TABLES TO postgres;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL ON SEQUENCES TO postgres;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL ON FUNCTIONS TO postgres;
