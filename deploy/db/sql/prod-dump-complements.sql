-- Complète un dump de prod restauré en local (restore-prod-dump.sh).
--
-- Le dump de prod ne contient que le schéma foncier :
--   - les triggers de foncier.bien y sont, mais pas leurs fonctions ;
--   - cinq vues lisent des schémas SIG absents en local (api_si, cadastre) et PostGIS.
-- On recrée les fonctions et les triggers, puis des vues vides aux mêmes colonnes.
-- Les colonnes de géométrie sont en text (pas de PostGIS en local).
-- Relançable : une vue déjà présente n'est pas touchée.

CREATE OR REPLACE FUNCTION foncier.maj_dossier_nsurface()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    WITH dossiers AS (
SELECT d.n_surface, d.pk_dossier
FROM foncier.dossier d
INNER JOIN foncier.dossier_bien db ON (db.fk_dossier = d.pk_dossier)
WHERE db.fk_bien = NEW.pk_bien
AND d.fk_type in (613, 619)
),
somme AS (
SELECT d.n_surface, db.fk_dossier, sum(b.n_surface) AS surf 
FROM foncier.bien b
INNER JOIN foncier.dossier_bien db ON (db.fk_bien = b.pk_bien)
INNER JOIN dossiers d ON (db.fk_dossier = d.pk_dossier)
GROUP BY db.fk_dossier, d.n_surface
)
UPDATE foncier.dossier d
SET n_surface = somme.surf
FROM somme 
WHERE somme.fk_dossier = d.pk_dossier;
 
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION foncier.maj_erreur_cadastrale()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN

WITH entrant AS (
SELECT fk_dossier, fk_mutation_bien, sum(b.n_surface) s
FROM foncier.dossier_bien db
LEFT JOIN foncier.dossier d ON (db.fk_dossier= d.pk_dossier)
LEFT JOIN foncier.bien b ON (db.fk_bien= b.pk_bien)
WHERE d.fk_type = 615 AND fk_mutation_bien = 644
GROUP BY fk_dossier, fk_mutation_bien),
sortant  AS (
SELECT fk_dossier, fk_mutation_bien, sum(b.n_surface) s 
FROM foncier.dossier_bien db
LEFT JOIN foncier.dossier d ON (db.fk_dossier= d.pk_dossier)
LEFT JOIN foncier.bien b ON (db.fk_bien= b.pk_bien)
WHERE d.fk_type = 615 AND fk_mutation_bien = 645
GROUP BY fk_dossier, fk_mutation_bien)

UPDATE foncier.dossier d
SET n_erreur_cadastrale = sortant.s-entrant.s
FROM entrant INNER JOIN sortant using(fk_dossier)
WHERE entrant.fk_dossier = d.pk_dossier;
 
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE TRIGGER update_maj_dossier_nsurface AFTER UPDATE OF n_surface ON foncier.bien
    FOR EACH ROW EXECUTE FUNCTION foncier.maj_dossier_nsurface();
CREATE OR REPLACE TRIGGER update_maj_erreur_cadastrale AFTER UPDATE OF n_surface ON foncier.bien
    FOR EACH ROW EXECUTE FUNCTION foncier.maj_erreur_cadastrale();

DO $$
BEGIN
    IF to_regclass('foncier.v_dossier_lot_etablissement') IS NULL THEN
        CREATE VIEW foncier.v_dossier_lot_etablissement AS
        SELECT d.pk_dossier, d.fk_lot, NULL::varchar AS cod_lot, a.dt_acte,
               da.s_siren, da.s_nom, e.denomination_unitelegale, e.siret,
               NULL::text AS adresse1, e.complementadresse_etablissement AS adresse2, NULL::text AS adresse3
          FROM foncier.dossier d
          JOIN foncier.acte a ON a.pk_acte = d.fk_acte
          JOIN foncier.dossier_acteur da ON da.fk_dossier = d.pk_dossier
          JOIN foncier.etablissement e ON e.siren = da.s_siren
         WHERE false;
    END IF;
END $$;

CREATE MATERIALIZED VIEW IF NOT EXISTS foncier.cadastre_parcelles_historique_ini AS
SELECT b.pk_bien, b.s_nom_bien, NULL::text AS geojson, NULL::double precision AS x, NULL::double precision AS y
  FROM foncier.bien b WHERE false;

CREATE MATERIALIZED VIEW IF NOT EXISTS foncier.vm_bien_cadastre_parcelles_historique AS
SELECT b.pk_bien, NULL::text AS geom, b.s_statut, b.s_nom_bien AS id_parcelle, b.s_code_insee, b.s_commune,
       b.n_surface, b.b_stock, b.s_commentaire, NULL::date AS date_ini_historique, NULL::date AS date_fin_historique
  FROM foncier.v_dto_bien b WHERE false;

CREATE MATERIALIZED VIEW IF NOT EXISTS foncier.vm_parcelles_stock AS
SELECT f.pk_bien, f.dt_creation, f.s_patrimoine, f.s_type_bien, f.s_nom_bien, f.s_code_insee, f.s_commune,
       f.n_surface, NULL::text AS geom, f.s_statut
  FROM foncier.v_dto_bien f WHERE false;

CREATE MATERIALIZED VIEW IF NOT EXISTS foncier.vm_parcelles_stock_ok AS
SELECT f.pk_bien, f.dt_creation, f.dt_modification, f.s_patrimoine, f.s_type_bien, f.s_nom_bien, f.s_code_insee,
       f.s_commune, f.n_surface, f.b_stock, NULL::text AS pgeom, f.s_statut
  FROM foncier.v_dto_bien f WHERE false;
