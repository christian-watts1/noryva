-- Preserve immutable 0001. Only the fixed identity functions get owner authority.
ALTER TABLE public.accounts ADD COLUMN auth_valid_after bigint NOT NULL DEFAULT 0 CHECK (auth_valid_after >= 0);
CREATE POLICY identity_mapping_owner ON public.accounts TO noryva_migrator USING (true) WITH CHECK (true);
CREATE FUNCTION public.map_identity(p_issuer text, p_subject text) RETURNS uuid
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public AS $$
DECLARE result uuid;
BEGIN
 IF length(p_issuer) NOT BETWEEN 1 AND 500 OR length(p_subject) NOT BETWEEN 1 AND 200 OR p_issuer IS NULL OR p_subject IS NULL THEN
   RAISE EXCEPTION 'identity unavailable';
 END IF;
 PERFORM pg_advisory_xact_lock(hashtextextended(jsonb_build_array(p_issuer,p_subject)::text,0));
 SELECT id INTO result FROM public.accounts WHERE provider_issuer=p_issuer AND provider_subject=p_subject;
 IF result IS NULL THEN
   result := gen_random_uuid();
   INSERT INTO public.accounts(id,provider_issuer,provider_subject) VALUES(result,p_issuer,p_subject);
   PERFORM set_config('app.account_id',result::text,true);
   INSERT INTO public.sync_state(account_id) VALUES(result);
 END IF;
 RETURN result;
END $$;
REVOKE ALL ON FUNCTION public.map_identity(text,text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.map_identity(text,text) TO noryva_api;

CREATE FUNCTION public.revoke_owned_device(p_device uuid) RETURNS boolean
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public AS $$
BEGIN
 -- Caller must hold the account sync gate; acquire it again defensively.
 PERFORM 1 FROM public.sync_state WHERE account_id=public.current_account_id() FOR UPDATE;
 UPDATE public.devices SET revoked_at=clock_timestamp()
 WHERE account_id=public.current_account_id() AND id=p_device AND revoked_at IS NULL;
 IF NOT FOUND THEN RETURN false; END IF;
 -- Invalidate all authentication predating this revocation, including refreshes.
 -- This deliberately requires fresh mailbox authentication on other devices too.
 UPDATE public.accounts SET auth_valid_after=GREATEST(auth_valid_after,floor(extract(epoch FROM clock_timestamp()))::bigint),updated_at=clock_timestamp()
 WHERE id=public.current_account_id();
 RETURN true;
END $$;
REVOKE ALL ON FUNCTION public.revoke_owned_device(uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.revoke_owned_device(uuid) TO noryva_api;
-- Identity bindings and revoked flags cannot be reassigned/unrevoked with API DML.
REVOKE INSERT, UPDATE ON public.devices FROM noryva_api;
CREATE FUNCTION public.register_owned_device(p_public uuid,p_platform text,p_os integer,p_version text) RETURNS uuid
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public AS $$
DECLARE result uuid; revoked timestamptz;
BEGIN
 PERFORM 1 FROM public.sync_state WHERE account_id=public.current_account_id() FOR UPDATE;
 SELECT id,revoked_at INTO result,revoked FROM public.devices WHERE account_id=public.current_account_id() AND device_public_id=p_public;
 IF revoked IS NOT NULL THEN
   -- A fresh authentication (enforced by service) creates a NEW internal device.
   -- Keep the revoked identity for any historical references; never un-revoke it.
   UPDATE public.devices SET device_public_id=gen_random_uuid()
    WHERE account_id=public.current_account_id() AND id=result;
   result := NULL;
 END IF;
 IF result IS NOT NULL THEN RETURN result; END IF;
 IF (SELECT count(*) FROM public.devices WHERE account_id=public.current_account_id()) >= 100
 OR (SELECT count(*) FROM public.devices WHERE account_id=public.current_account_id() AND revoked_at IS NULL) >= 10 THEN RAISE EXCEPTION 'identity unavailable'; END IF;
 result := gen_random_uuid();
 INSERT INTO public.devices(id,account_id,device_public_id,platform,os_major,app_version)
 VALUES(result,public.current_account_id(),p_public,p_platform,p_os,p_version);
 RETURN result;
END $$;
REVOKE ALL ON FUNCTION public.register_owned_device(uuid,text,integer,text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.register_owned_device(uuid,text,integer,text) TO noryva_api;
