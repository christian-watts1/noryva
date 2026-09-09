-- Immutable once applied. Executed as noryva_migrator, never by the API.
-- No identity verification, sync protocol, analytics or privacy side effects here.
CREATE FUNCTION public.current_account_id() RETURNS uuid
LANGUAGE sql STABLE SECURITY INVOKER SET search_path = pg_catalog
AS $$ SELECT NULLIF(current_setting('app.account_id', true), '')::uuid $$;
REVOKE ALL ON FUNCTION public.current_account_id() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.current_account_id() TO noryva_api;

CREATE TABLE public.accounts (
  id uuid PRIMARY KEY,
  provider_issuer text NOT NULL CHECK (length(provider_issuer) BETWEEN 1 AND 500),
  provider_subject text NOT NULL CHECK (length(provider_subject) BETWEEN 1 AND 200),
  status text NOT NULL DEFAULT 'active' CHECK (status IN ('active','deleting','deleted')),
  created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), deleted_at timestamptz,
  UNIQUE(provider_issuer, provider_subject),
  CHECK ((status = 'deleted') = (deleted_at IS NOT NULL))
);
CREATE TABLE public.devices (
  id uuid NOT NULL, account_id uuid NOT NULL REFERENCES public.accounts(id), device_public_id uuid NOT NULL,
  platform text NOT NULL CHECK (platform IN ('android','ios')),
  os_major integer NOT NULL CHECK (os_major BETWEEN 1 AND 999), app_version text NOT NULL CHECK (app_version ~ '^\d{1,3}\.\d{1,3}\.\d{1,3}$'),
  created_at timestamptz NOT NULL DEFAULT now(), last_seen_at timestamptz NOT NULL DEFAULT now(), revoked_at timestamptz,
  PRIMARY KEY(account_id,id), UNIQUE(account_id,device_public_id)
);
CREATE TABLE public.sync_state (
  account_id uuid PRIMARY KEY REFERENCES public.accounts(id),
  epoch bigint NOT NULL DEFAULT 1 CHECK (epoch BETWEEN 1 AND 9007199254740991),
  revision bigint NOT NULL DEFAULT 0 CHECK (revision BETWEEN 0 AND 9007199254740991),
  retention_floor bigint NOT NULL DEFAULT 0 CHECK (retention_floor BETWEEN 0 AND revision),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE public.fitness_profiles (
  id uuid NOT NULL, account_id uuid NOT NULL UNIQUE REFERENCES public.accounts(id),
  epoch bigint NOT NULL DEFAULT 1 CHECK (epoch BETWEEN 1 AND 9007199254740991),
  version bigint NOT NULL DEFAULT 1 CHECK (version BETWEEN 1 AND 9007199254740991),
  created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), deleted_at timestamptz,
  calculation_sex text CHECK (calculation_sex IN ('male','female')),
  height_cm numeric CHECK (height_cm BETWEEN 120 AND 230), weight_kg numeric CHECK (weight_kg BETWEEN 35 AND 350),
  activity text CHECK (activity IN ('low','light','moderate','high')),
  goal text CHECK (goal IN ('loseWeight','maintainWeight','gainWeight','buildMuscle','improveFitness','trackNutrition')),
  goal_weight_kg numeric CHECK (goal_weight_kg BETWEEN 35 AND 350), rate_kg_per_week numeric CHECK (rate_kg_per_week IN (0.25,0.5,0.75)),
  bmr numeric CHECK (bmr BETWEEN 0 AND 100000), maintenance_calories numeric CHECK (maintenance_calories BETWEEN 0 AND 100000),
  daily_calories numeric CHECK (daily_calories BETWEEN 0 AND 100000), goal_adjustment numeric CHECK (goal_adjustment BETWEEN -10000 AND 10000),
  protein_g numeric CHECK (protein_g BETWEEN 0 AND 100000), carbohydrate_g numeric CHECK (carbohydrate_g BETWEEN 0 AND 100000), fat_g numeric CHECK (fat_g BETWEEN 0 AND 100000),
  was_clamped boolean, algorithm_version text CHECK (algorithm_version = 'mifflin-st-jeor-v1'),
  height_unit text CHECK (height_unit IN ('cm','ftIn')), weight_unit text CHECK (weight_unit IN ('kg','lb','stLb')),
  PRIMARY KEY(account_id,id),
  CHECK (deleted_at IS NOT NULL OR num_nonnulls(calculation_sex,height_cm,weight_kg,activity,goal,bmr,maintenance_calories,daily_calories,goal_adjustment,protein_g,carbohydrate_g,fat_g,was_clamped,algorithm_version,height_unit,weight_unit) = 16),
  CHECK (deleted_at IS NOT NULL OR goal NOT IN ('loseWeight','gainWeight') OR rate_kg_per_week IS NOT NULL)
);
CREATE TABLE public.diary_entries (
  id uuid NOT NULL, account_id uuid NOT NULL REFERENCES public.accounts(id), device_id uuid NOT NULL,
  epoch bigint NOT NULL DEFAULT 1 CHECK (epoch BETWEEN 1 AND 9007199254740991),
  version bigint NOT NULL DEFAULT 1 CHECK (version BETWEEN 1 AND 9007199254740991),
  created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), deleted_at timestamptz,
  meal text CHECK (meal IN ('breakfast','lunch','dinner','snack')), logged_at timestamptz,
  quantity numeric CHECK (quantity > 0 AND quantity <= 100000), serving_description text CHECK (length(serving_description) BETWEEN 1 AND 200),
  basis_unit text CHECK (basis_unit IN ('g','ml','serving')), food_name text CHECK (length(food_name) BETWEEN 1 AND 200), brand text CHECK (length(brand) <= 200),
  calories numeric CHECK (calories BETWEEN 0 AND 100000), protein_g numeric CHECK (protein_g BETWEEN 0 AND 100000),
  carbohydrate_g numeric CHECK (carbohydrate_g BETWEEN 0 AND 100000), fat_g numeric CHECK (fat_g BETWEEN 0 AND 100000),
  fibre_g numeric CHECK (fibre_g BETWEEN 0 AND 100000), sugar_g numeric CHECK (sugar_g BETWEEN 0 AND 100000), salt_g numeric CHECK (salt_g BETWEEN 0 AND 100000),
  PRIMARY KEY(account_id,id), FOREIGN KEY(account_id,device_id) REFERENCES public.devices(account_id,id),
  CHECK (deleted_at IS NOT NULL OR num_nonnulls(meal,logged_at,quantity,serving_description,basis_unit,food_name,calories,protein_g,carbohydrate_g,fat_g,fibre_g,sugar_g,salt_g) = 13)
);
CREATE INDEX diary_live_time ON public.diary_entries(account_id,logged_at,id) WHERE deleted_at IS NULL;
CREATE TABLE public.jobs (
  id uuid NOT NULL, account_id uuid NOT NULL REFERENCES public.accounts(id),
  job_type text NOT NULL CHECK (job_type IN ('export','cloud_delete','account_delete')),
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','running','succeeded','failed')),
  attempts integer NOT NULL DEFAULT 0 CHECK (attempts >= 0), max_attempts integer NOT NULL DEFAULT 3 CHECK (max_attempts BETWEEN 1 AND 10 AND attempts <= max_attempts),
  available_at timestamptz NOT NULL DEFAULT now(), locked_at timestamptz, locked_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), completed_at timestamptz,
  last_error_code text CHECK (last_error_code IN ('transient_failure','dependency_unavailable','attempts_exhausted')),
  PRIMARY KEY(account_id,id),
  CHECK ((status = 'running') = (locked_at IS NOT NULL AND locked_by IS NOT NULL)),
  CHECK ((locked_at IS NULL) = (locked_by IS NULL)),
  CHECK ((status IN ('succeeded','failed')) = (completed_at IS NOT NULL)),
  CHECK (status <> 'running' OR attempts > 0)
);
CREATE INDEX jobs_pending ON public.jobs(account_id,available_at,created_at,id) WHERE status = 'pending';

-- Soft deletion immediately removes payload; only owner-visible tombstone metadata
-- remains. Payload cannot be resurrected under the same ID. No history table yet.
CREATE FUNCTION public.guard_snapshot() RETURNS trigger LANGUAGE plpgsql SECURITY INVOKER SET search_path = pg_catalog AS $$
DECLARE field text;
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF NEW.id <> OLD.id OR NEW.account_id <> OLD.account_id OR NEW.created_at <> OLD.created_at OR NEW.epoch <> OLD.epoch
       OR NEW.version <> OLD.version + 1 OR OLD.deleted_at IS NOT NULL THEN
      RAISE EXCEPTION 'invalid snapshot transition' USING ERRCODE = '23514';
    END IF;
    NEW.updated_at := clock_timestamp();
  END IF;
  IF NEW.deleted_at IS NOT NULL THEN
    FOREACH field IN ARRAY TG_ARGV LOOP
      NEW := jsonb_populate_record(NEW, jsonb_build_object(field, NULL));
    END LOOP;
  END IF;
  RETURN NEW;
END $$;
REVOKE ALL ON FUNCTION public.guard_snapshot() FROM PUBLIC;
CREATE TRIGGER profile_snapshot BEFORE INSERT OR UPDATE ON public.fitness_profiles FOR EACH ROW EXECUTE FUNCTION public.guard_snapshot(
 'calculation_sex','height_cm','weight_kg','activity','goal','goal_weight_kg','rate_kg_per_week','bmr','maintenance_calories','daily_calories','goal_adjustment','protein_g','carbohydrate_g','fat_g','was_clamped','algorithm_version','height_unit','weight_unit');
CREATE TRIGGER diary_snapshot BEFORE INSERT OR UPDATE ON public.diary_entries FOR EACH ROW EXECUTE FUNCTION public.guard_snapshot(
 'meal','logged_at','quantity','serving_description','basis_unit','food_name','brand','calories','protein_g','carbohydrate_g','fat_g','fibre_g','sugar_g','salt_g');

ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.accounts FORCE ROW LEVEL SECURITY;
CREATE POLICY account_owner ON public.accounts USING (id = public.current_account_id()) WITH CHECK (id = public.current_account_id());
DO $$ DECLARE t text; BEGIN
 FOREACH t IN ARRAY ARRAY['devices','fitness_profiles','diary_entries','sync_state','jobs'] LOOP
  EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t);
  EXECUTE format('ALTER TABLE public.%I FORCE ROW LEVEL SECURITY', t);
  EXECUTE format('CREATE POLICY account_owner ON public.%I USING (account_id = public.current_account_id()) WITH CHECK (account_id = public.current_account_id())', t);
 END LOOP;
END $$;
GRANT SELECT ON public.accounts TO noryva_api;
GRANT SELECT, INSERT, UPDATE ON public.devices, public.jobs TO noryva_api;
GRANT SELECT, UPDATE ON public.sync_state TO noryva_api;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.fitness_profiles, public.diary_entries TO noryva_api;
-- No sequence, schema, ledger, TRUNCATE, REFERENCES, policy or role privileges.
