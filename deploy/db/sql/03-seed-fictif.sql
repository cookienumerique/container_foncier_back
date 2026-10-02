-- Jeu de données FICTIF pour la préproduction.
-- Aucune donnée réelle : noms, adresses, contacts et montants sont générés.
-- Téléphones dans la plage 01 99 00 xx xx (réservée à la fiction par l'ARCEP),
-- emails en .test (domaine réservé, aucun mail ne peut partir).
-- Déterministe : relancer le script produit exactement les mêmes données.

SET search_path = foncier, public;
SELECT setseed(0.42);

-- Recherche d'une valeur de liste par groupe + clef (les pk diffèrent selon les bases).
CREATE FUNCTION pg_temp.l(groupe text, clef text) RETURNS integer
    LANGUAGE sql STABLE AS
$$ SELECT pk_liste FROM foncier.liste WHERE s_groupe = groupe AND s_clef = clef $$;

-- Tire un élément au hasard dans un tableau.
CREATE FUNCTION pg_temp.pick(anyarray) RETURNS anyelement
    LANGUAGE sql VOLATILE AS
$$ SELECT $1[1 + floor(random() * array_length($1, 1))::int] $$;

CREATE TEMP TABLE noms AS SELECT ARRAY[
    'Martin','Bernard','Dubois','Thomas','Robert','Richard','Petit','Durand','Leroy','Moreau',
    'Simon','Laurent','Lefebvre','Michel','Garcia','David','Bertrand','Roux','Vincent','Fournier'
] AS n, ARRAY[
    'Camille','Louis','Léa','Hugo','Chloé','Jules','Manon','Arthur','Inès','Nathan','Sarah','Paul'
] AS p, ARRAY[
    'rue des Tilleuls','allée des Peupliers','avenue du Lac','chemin des Prés','rue de la Ferme',
    'boulevard de l''Europe','place du Marché','rue du Moulin','impasse des Vignes','cours des Roches'
] AS voies, ARRAY[
    '77186|Noisiel','77420|Champs-sur-Marne','93160|Noisy-le-Grand','77600|Bussy-Saint-Georges',
    '77700|Chessy','77200|Torcy','77185|Lognes','77144|Montévrain'
] AS villes;

-- ───────────── Utilisateurs (agents fictifs) ─────────────
INSERT INTO utilisateur (pk_utilisateur, s_nom, s_prenom, s_email, s_telephone, dt_creation)
SELECT i, n[i], p[i], lower(unaccent(p[i] || '.' || n[i])) || '@foncier-preprod.test',
       '01 99 00 10 ' || lpad(i::text, 2, '0'), timestamp '2024-01-01' + i * interval '3 days'
FROM noms, generate_series(1, 8) i;

INSERT INTO authentification (pk_authentification, fk_utilisateur, b_is_admin, s_login, fk_liste_profil)
SELECT pk_utilisateur, pk_utilisateur, pk_utilisateur <= 2, split_part(s_email, '@', 1),
       CASE WHEN pk_utilisateur <= 2 THEN pg_temp.l('user.profil', 'ADM') ELSE pg_temp.l('user.profil', 'LEC') END
FROM utilisateur;

-- ───────────── Contacts (notaires, géomètres, SPF, occupants) ─────────────
INSERT INTO contact (pk_contact, s_groupe, s_nom, s_adresse, s_code_postal, s_ville, s_telephone, s_email,
                     s_siret, fk_type_personne, dt_creation)
SELECT i, g.groupe,
       CASE g.groupe
           WHEN 'notaire' THEN 'Étude de Maître ' || pg_temp.pick(noms.n)
           WHEN 'geometre' THEN 'Cabinet ' || pg_temp.pick(noms.n) || ' Géomètres-Experts'
           WHEN 'service-publicite' THEN 'Service de publicité foncière fictif n°' || i
           ELSE pg_temp.pick(noms.p) || ' ' || pg_temp.pick(noms.n)
       END,
       (1 + floor(random() * 120))::int || ' ' || pg_temp.pick(noms.voies),
       split_part(noms.villes[1 + i % 8], '|', 1), split_part(noms.villes[1 + i % 8], '|', 2),
       '01 99 00 20 ' || lpad(i::text, 2, '0'),
       g.groupe || i || '@foncier-preprod.test',
       CASE WHEN g.groupe <> 'occupant' THEN '000' || lpad(i::text, 11, '0') END,
       CASE WHEN g.groupe = 'occupant' THEN pg_temp.l('contact.type_personne', 'contact.type_personne.physique')
            ELSE pg_temp.l('contact.type_personne', 'contact.type_personne.morale') END,
       timestamp '2023-06-01' + i * interval '5 days'
FROM noms,
     generate_series(1, 30) i,
     LATERAL (SELECT CASE WHEN i <= 12 THEN 'notaire' WHEN i <= 20 THEN 'geometre'
                          WHEN i <= 24 THEN 'service-publicite' ELSE 'occupant' END AS groupe) g;

-- ───────────── Biens : 400 parcelles + 80 lots/volumes ─────────────
CREATE TEMP TABLE ref AS SELECT
    (SELECT array_agg(s_code_insee ORDER BY pk_commune) FROM commune) AS insee,
    (SELECT array_agg(pk_operation ORDER BY pk_operation) FROM operation WHERE s_nom NOT LIKE 'zz%') AS operations,
    ARRAY[pg_temp.l('patrimoine', 'patrimoine.epamarne'), pg_temp.l('patrimoine', 'patrimoine.epafrance')] AS patrimoines,
    ARRAY[pg_temp.l('bien.statut', 'bien.statut.en.stock'), pg_temp.l('bien.statut', 'bien.statut.en.stock'),
          pg_temp.l('bien.statut', 'bien.statut.vendu'), pg_temp.l('bien.statut', 'bien.statut.modifié'),
          pg_temp.l('bien.statut', 'bien.statut.gestion'), pg_temp.l('bien.statut', 'bien.statut.location')] AS statuts;

INSERT INTO bien (pk_bien, fk_type_bien, fk_statut, fk_utilisateur, s_nom_bien, s_nom_bien_ini, s_voie, s_code_insee,
                  n_surface, b_stock, b_bati, d_demolition, fk_patrimoine, s_provenance, dt_creation)
SELECT s.i, pg_temp.l('bien.type', 'bien.type.parcelle'), s.statut, 1 + (s.i % 8), s.nom, s.nom,
       (1 + floor(random() * 80))::int || ' ' || pg_temp.pick(noms.voies), pg_temp.pick(ref.insee),
       (50 + floor(random() * 20000))::int, s.statut = pg_temp.l('bien.statut', 'bien.statut.en.stock'),
       false, CASE WHEN s.i % 40 = 0 THEN (date '2019-01-01' + (s.i * 7) % 2000) END,
       pg_temp.pick(ref.patrimoines), 'FONCIER',
       timestamp '2015-01-01' + random() * interval '10 years'
FROM noms, ref,
     (SELECT i, pg_temp.pick(ref.statuts) AS statut,
             chr(65 + (i % 26)) || chr(65 + (i / 26 % 26)) || ' ' || lpad((i * 37 % 2000)::text, 4, '0') AS nom
      FROM ref, generate_series(1, 400) i) s;

INSERT INTO bien (pk_bien, fk_bien_lie, fk_type_bien, fk_statut, fk_utilisateur, s_nom_bien, s_nom_bien_ini, s_voie,
                  s_code_insee, n_surface, b_stock, b_bati, d_demolition, fk_patrimoine, s_provenance, dt_creation)
SELECT 400 + i, parent.pk_bien,
       CASE WHEN i % 2 = 0 THEN pg_temp.l('bien.type', 'bien.type.lot') ELSE pg_temp.l('bien.type', 'bien.type.volume') END,
       pg_temp.l('bien.statut', 'bien.statut.en.stock'), parent.fk_utilisateur,
       parent.s_nom_bien || CASE WHEN i % 2 = 0 THEN ' - Lot ' ELSE ' - Vol ' END || i,
       parent.s_nom_bien || ' - ' || i, parent.s_voie, parent.s_code_insee,
       greatest(10, parent.n_surface / 5), true, false, NULL, parent.fk_patrimoine, 'FONCIER', parent.dt_creation + interval '1 year'
FROM generate_series(1, 80) i
JOIN bien parent ON parent.pk_bien = i * 5;

-- ───────────── Dossiers + actes (1 acte par dossier) ─────────────
CREATE TEMP TABLE d AS
SELECT id, clef, pg_temp.l('dossier.type', clef) AS fk_type, dt
FROM (SELECT id, timestamp '2018-01-01' + random() * interval '7 years' AS dt,
             CASE WHEN r < 0.40 THEN 'MPC' WHEN r < 0.70 THEN 'CES' WHEN r < 0.85 THEN 'ACQ'
                  WHEN r < 0.92 THEN 'MLV' WHEN r < 0.96 THEN 'MLC' ELSE 'LOC' END AS clef
      FROM (SELECT i AS id, random() AS r FROM generate_series(1, 250) i) x) t;

INSERT INTO acte (pk_acte, fk_service_publicitaire, fk_geometre, fk_occupant, dt_acte, dt_publication,
                  n_montant_initial, s_numero_acte, s_volume)
SELECT d.id, 21 + (d.id % 4), 13 + (d.id % 8), CASE WHEN d.clef = 'LOC' THEN 25 + (d.id % 6) END,
       d.dt + interval '30 days', d.dt + interval '75 days',
       CASE WHEN d.clef IN ('ACQ', 'CES') THEN round((5000 + random() * 2000000)::numeric, 2) END,
       'ACTE-' || to_char(d.dt, 'YYYY') || '-' || lpad(d.id::text, 4, '0'),
       (1000 + d.id)::text
FROM d;

INSERT INTO dossier (pk_dossier, fk_type, fk_patrimoine, fk_operation, fk_notaire, fk_mode_dmpc, fk_utilisateur, fk_acte,
                     fk_provenance_transaction, s_nom_dossier, s_code_insee, n_numero_dmpc, n_montant_transaction,
                     s_code_analytique, s_commentaire, dt_creation, dt_modification, s_provenance, n_depot_garantie)
SELECT d.id, d.fk_type, pg_temp.pick(ref.patrimoines), pg_temp.pick(ref.operations),
       CASE WHEN random() < 0.7 THEN 1 + (d.id % 12) END,
       CASE WHEN d.clef = 'MPC' THEN pg_temp.pick(ARRAY[pg_temp.l('mode_dmpc', 'mode_dmpc.dmpc.normal'),
                                                       pg_temp.l('mode_dmpc', 'mode_dmpc.requisition.de.division'),
                                                       pg_temp.l('mode_dmpc', 'mode_dmpc.pv.cadastral')]) END,
       1 + (d.id % 8), d.id,
       CASE WHEN d.clef = 'ACQ' THEN pg_temp.pick(ARRAY[pg_temp.l('provenance_transaction', 'provenance_transaction.issue.nego'),
                                                       pg_temp.l('provenance_transaction', 'provenance_transaction.offre')]) END,
       d.clef || '-' || to_char(d.dt, 'YYYY') || '-' || lpad(d.id::text, 4, '0'),
       pg_temp.pick(ref.insee),
       CASE WHEN d.clef = 'MPC' THEN 1000 + d.id END,
       CASE WHEN d.clef IN ('ACQ', 'CES') THEN round((5000 + random() * 2000000)::numeric, 2) END,
       'CA-' || lpad((d.id % 40)::text, 3, '0'),
       'Dossier fictif généré pour la préproduction.',
       d.dt, d.dt + interval '90 days', 'FONCIER',
       CASE WHEN d.clef = 'LOC' THEN (500 + floor(random() * 5000))::int END
FROM d, ref;

-- Acteurs : au plus un par dossier (la vue v_dto_dossier joint dossier_acteur sur fk_dossier),
-- environ un dossier sur deux, comme dans les données réelles.
INSERT INTO dossier_acteur (pk_dossier_acteur, fk_type, fk_categorie, s_nom, s_prenom, fk_dossier)
SELECT c.id, pg_temp.l('acteur.type', CASE WHEN c.clef = 'ACQ' THEN 'vendeur' ELSE 'acquéreur' END),
       c.cat,
       CASE WHEN c.cat = pg_temp.l('acteur.categorie', 'acteur.categorie.Particulier') THEN pg_temp.pick(noms.n)
            ELSE 'Société fictive ' || pg_temp.pick(noms.n) END,
       CASE WHEN c.cat = pg_temp.l('acteur.categorie', 'acteur.categorie.Particulier') THEN pg_temp.pick(noms.p) END,
       c.id
FROM noms,
     (SELECT d.id, d.clef, pg_temp.pick(ARRAY[pg_temp.l('acteur.categorie', 'acteur.categorie.Particulier'),
                                              pg_temp.l('acteur.categorie', 'acteur.categorie.Commune'),
                                              pg_temp.l('acteur.categorie', 'acteur.categorie.Personne Morale'),
                                              pg_temp.l('acteur.categorie', 'acteur.categorie.EPAMARNE')]) AS cat
      FROM d WHERE d.clef IN ('ACQ', 'CES', 'LOC') OR d.id % 4 = 0) c;

UPDATE dossier SET fk_acteur = pk_dossier
WHERE pk_dossier IN (SELECT fk_dossier FROM dossier_acteur);

-- Liens dossier ↔ biens (1 à 3 biens par dossier, mutation cohérente avec le type).
INSERT INTO dossier_bien (fk_dossier, fk_bien, fk_mutation_bien, fk_mutation_dossier, n_mutation)
SELECT d.id, 1 + ((d.id * 7 + k * 131) % 480),
       pg_temp.l('bien.mutation', CASE WHEN d.clef IN ('ACQ', 'MLV', 'MLC') OR (d.clef = 'MPC' AND k > 1)
                                       THEN 'bien.mutation.entrant' ELSE 'bien.mutation.sortant' END),
       pg_temp.l('libelle.mutation', 'libelle.mutation.' || CASE d.clef WHEN 'ACQ' THEN 'Acquisition' WHEN 'CES' THEN 'Cession'
                                                                        WHEN 'LOC' THEN 'Location' ELSE 'Division' END),
       1
FROM d, generate_series(1, 1 + d.id % 3) k;

-- Champs calculés : surface, références cadastrales, statut des biens cédés.
UPDATE dossier SET n_surface = s.surf, s_reference_cadastrale = s.refs
FROM (SELECT db.fk_dossier, sum(b.n_surface) AS surf, string_agg(b.s_nom_bien, ', ' ORDER BY b.pk_bien) AS refs
      FROM dossier_bien db JOIN bien b ON b.pk_bien = db.fk_bien GROUP BY db.fk_dossier) s
WHERE s.fk_dossier = dossier.pk_dossier;

UPDATE bien SET fk_statut = pg_temp.l('bien.statut', 'bien.statut.vendu'), b_stock = false
WHERE pk_bien IN (SELECT db.fk_bien FROM dossier_bien db JOIN d ON d.id = db.fk_dossier WHERE d.clef = 'CES');

-- Quelques favoris par utilisateur.
INSERT INTO favoris (fk_utilisateur, fk_bien, fk_dossier, dt_creation)
SELECT 1 + (i % 8), CASE WHEN i % 2 = 0 THEN 1 + (i * 11 % 400) END, CASE WHEN i % 2 = 1 THEN 1 + (i * 13 % 250) END,
       timestamp '2025-01-01' + i * interval '1 day'
FROM generate_series(1, 40) i;

-- Le back lit les dates au format 'Y-m-d H:i:s' : on supprime les fractions de seconde.
DO $$
DECLARE c record;
BEGIN
    FOR c IN SELECT table_name, column_name FROM information_schema.columns
             WHERE table_schema = 'foncier' AND data_type LIKE 'timestamp%'
               AND table_name IN (SELECT table_name FROM information_schema.tables
                                  WHERE table_schema = 'foncier' AND table_type = 'BASE TABLE') LOOP
        EXECUTE format('UPDATE foncier.%I SET %I = date_trunc(''second'', %I) WHERE %I IS NOT NULL',
                       c.table_name, c.column_name, c.column_name, c.column_name);
    END LOOP;
END $$;

-- Recale toutes les séquences d'identité sur le max des clés insérées.
DO $$
DECLARE c record;
BEGIN
    FOR c IN SELECT table_name, column_name FROM information_schema.columns
             WHERE table_schema = 'foncier' AND is_identity = 'YES' LOOP
        EXECUTE format('SELECT setval(pg_get_serial_sequence(%L, %L), greatest(1, (SELECT coalesce(max(%I), 0) FROM foncier.%I)))',
                       'foncier.' || c.table_name, c.column_name, c.column_name, c.table_name);
    END LOOP;
END $$;
