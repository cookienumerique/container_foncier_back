--
-- PostgreSQL database dump
--

-- Dumped from database version 15.12
-- Dumped by pg_dump version 15.12

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
-- Data for Name: liste; Type: TABLE DATA; Schema: foncier; Owner: -
--

INSERT INTO foncier.liste VALUES (1, 'user.profil', 'ADM', 'user.profil.adm', 1);
INSERT INTO foncier.liste VALUES (613, 'dossier.type', 'ACQ', 'Acquisition', 1);
INSERT INTO foncier.liste VALUES (614, 'dossier.type', 'MLV', 'Modification de volumes', 4);
INSERT INTO foncier.liste VALUES (615, 'dossier.type', 'MPC', 'Modification parcellaire cadastrale', 2);
INSERT INTO foncier.liste VALUES (619, 'dossier.type', 'CES', 'Cession', 5);
INSERT INTO foncier.liste VALUES (620, 'dossier.type', 'MLC', 'Modification de lots de copropriété', 3);
INSERT INTO foncier.liste VALUES (621, 'patrimoine', 'patrimoine.epafrance', 'EpaFrance', NULL);
INSERT INTO foncier.liste VALUES (622, 'patrimoine', 'patrimoine.epamarne', 'EpaMarne', NULL);
INSERT INTO foncier.liste VALUES (623, 'patrimoine', 'patrimoine.etat_vp', 'Etat VP', NULL);
INSERT INTO foncier.liste VALUES (630, 'entite', 'entite.dossier', 'DOSSIER', NULL);
INSERT INTO foncier.liste VALUES (631, 'entite', 'entite.bien', 'BIEN', NULL);
INSERT INTO foncier.liste VALUES (632, 'bien.type', 'bien.type.parcelle', 'Parcelle', NULL);
INSERT INTO foncier.liste VALUES (633, 'patrimoine', 'patrimoine.gpa', 'GPA (EX-AFTRP)', NULL);
INSERT INTO foncier.liste VALUES (644, 'bien.mutation', 'bien.mutation.sortant', 'sortant', NULL);
INSERT INTO foncier.liste VALUES (645, 'bien.mutation', 'bien.mutation.entrant', 'entrant', NULL);
INSERT INTO foncier.liste VALUES (646, 'bien.type', 'bien.type.volume', 'Volume', NULL);
INSERT INTO foncier.liste VALUES (647, 'bien.type', 'bien.type.lot', 'Lot', NULL);
INSERT INTO foncier.liste VALUES (648, 'type.contact', 'type.contact.geometre', 'geometre', 1);
INSERT INTO foncier.liste VALUES (649, 'type.contact', 'type.contact.notaire', 'notaire', 2);
INSERT INTO foncier.liste VALUES (651, 'type.contact', 'type.contact.service.publicite', 'service-publicite', 4);
INSERT INTO foncier.liste VALUES (683, 'acteur.type', 'vendeur', 'propriétaire', NULL);
INSERT INTO foncier.liste VALUES (684, 'acteur.type', 'acquéreur', 'acquéreur', NULL);
INSERT INTO foncier.liste VALUES (652, 'libelle.mutation', 'libelle.mutation.Fusion/Division', 'Fusion/Division', NULL);
INSERT INTO foncier.liste VALUES (653, 'libelle.mutation', 'libelle.mutation.Réunion/Division', 'Réunion/Division', NULL);
INSERT INTO foncier.liste VALUES (654, 'libelle.mutation', 'libelle.mutation.Transfert', 'Transfert', NULL);
INSERT INTO foncier.liste VALUES (655, 'libelle.mutation', 'libelle.mutation.Cession', 'Cession', NULL);
INSERT INTO foncier.liste VALUES (656, 'libelle.mutation', 'libelle.mutation.Réunion', 'Réunion', NULL);
INSERT INTO foncier.liste VALUES (657, 'libelle.mutation', 'libelle.mutation.Création', 'Création', NULL);
INSERT INTO foncier.liste VALUES (658, 'libelle.mutation', 'libelle.mutation.Acquisition', 'Acquisition', NULL);
INSERT INTO foncier.liste VALUES (659, 'libelle.mutation', 'libelle.mutation.Division', 'Division', NULL);
INSERT INTO foncier.liste VALUES (660, 'libelle.mutation', 'libelle.mutation.Fusion', 'Fusion', NULL);
INSERT INTO foncier.liste VALUES (639, 'bien.statut', 'bien.statut.en.stock', 'En stock', NULL);
INSERT INTO foncier.liste VALUES (640, 'bien.statut', 'bien.statut.vendu', 'Vendu', NULL);
INSERT INTO foncier.liste VALUES (641, 'bien.statut', 'bien.statut.modifié', 'Modifié', NULL);
INSERT INTO foncier.liste VALUES (642, 'bien.statut', 'bien.statut.divisé.en.lots', 'Divisé en lots', NULL);
INSERT INTO foncier.liste VALUES (643, 'bien.statut', 'bien.statut.divisé.en.volumes', 'Divisé en volumes', NULL);
INSERT INTO foncier.liste VALUES (666, 'acteur.categorie', 'acteur.categorie.Consorts', 'Consorts', NULL);
INSERT INTO foncier.liste VALUES (667, 'acteur.categorie', 'acteur.categorie.Commune', 'Commune', NULL);
INSERT INTO foncier.liste VALUES (670, 'acteur.categorie', 'acteur.categorie.Département', 'Département', NULL);
INSERT INTO foncier.liste VALUES (671, 'acteur.categorie', 'acteur.categorie.Particulier', 'Particulier', NULL);
INSERT INTO foncier.liste VALUES (673, 'acteur.categorie', 'acteur.categorie.AFTRP', 'AFTRP', NULL);
INSERT INTO foncier.liste VALUES (680, 'acteur.categorie', 'acteur.categorie.Collectivité locale', 'Collectivité locale', NULL);
INSERT INTO foncier.liste VALUES (682, 'acteur.categorie', 'acteur.categorie.Personne Morale', 'Personne Morale', NULL);
INSERT INTO foncier.liste VALUES (691, 'acteur.categorie', 'acteur.categorie.Eurodisney', 'Eurodisney', NULL);
INSERT INTO foncier.liste VALUES (672, 'acteur.categorie', 'acteur.categorie.EPAFRANCE', 'EpaFrance', NULL);
INSERT INTO foncier.liste VALUES (677, 'acteur.categorie', 'acteur.categorie.REGION', 'Région', NULL);
INSERT INTO foncier.liste VALUES (679, 'acteur.categorie', 'acteur.categorie.EPAMARNE', 'EpaFrance', NULL);
INSERT INTO foncier.liste VALUES (681, 'acteur.categorie', 'acteur.categorie.ETAT', 'Etat', NULL);
INSERT INTO foncier.liste VALUES (92, 'user.profil', 'LEC', 'user.profil.lecture', NULL);
INSERT INTO foncier.liste VALUES (616, 'dossier.type0', 'DIA', 'Déclaration d''Intention d''Aliéner', 8);
INSERT INTO foncier.liste VALUES (618, 'dossier.type0', 'ECH', 'Echange', 6);
INSERT INTO foncier.liste VALUES (692, 'libelle.mutation', 'libelle.mutation.Location', 'Location', NULL);
INSERT INTO foncier.liste VALUES (2, 'contact.type_personne', 'contact.type_personne.morale', 'Personne morale', 1);
INSERT INTO foncier.liste VALUES (3, 'contact.type_personne', 'contact.type_personne.physique', 'Personne physique', 2);
INSERT INTO foncier.liste VALUES (694, 'patrimoine', 'patrimoine.m2ca', 'M2CA', NULL);
INSERT INTO foncier.liste VALUES (696, 'bien.statut', 'bien.statut.gestion', 'En gestion', NULL);
INSERT INTO foncier.liste VALUES (697, 'bien.statut', 'bien.statut.transfere', 'Transféré à EpaMarne', NULL);
INSERT INTO foncier.liste VALUES (698, 'patrimoine', 'patrimoine.transfere', 'Etat gestion EpaMarne', NULL);
INSERT INTO foncier.liste VALUES (693, 'bien.statut', 'bien.statut.location', 'En location', NULL);
INSERT INTO foncier.liste VALUES (4, 'dossier.type', 'LOC', 'Location', 6);
INSERT INTO foncier.liste VALUES (5, 'acteur.type', 'locataire', 'locataire', NULL);
INSERT INTO foncier.liste VALUES (627, 'mode_acquisition', 'mode_acquisition.amiable', 'Amiable', NULL);
INSERT INTO foncier.liste VALUES (629, 'mode_acquisition', 'mode_acquisition.expropriation', 'Expropriation', NULL);
INSERT INTO foncier.liste VALUES (624, 'mode_dmpc', 'mode_dmpc.requisition.de.division', 'Réquisition de division', NULL);
INSERT INTO foncier.liste VALUES (625, 'mode_dmpc', 'mode_dmpc.dmpc.normal', 'DMPC Normal', NULL);
INSERT INTO foncier.liste VALUES (628, 'mode_dmpc', 'mode_dmpc.conservation.cadastrale', 'Conservation cadastrale', NULL);
INSERT INTO foncier.liste VALUES (687, 'provenance_transaction', 'provenance_transaction.issue.nego', 'Issu de la négociation', 1);
INSERT INTO foncier.liste VALUES (688, 'provenance_transaction', 'provenance_transaction.jugement', 'Issu du jugement', 2);
INSERT INTO foncier.liste VALUES (695, 'mode_dmpc', 'mode_dmpc.pv.cadastral', 'PV cadastral', NULL);
INSERT INTO foncier.liste VALUES (689, 'provenance_transaction', 'provenance_transaction.jugement.appel', 'Issu du jugement en appel', 3);
INSERT INTO foncier.liste VALUES (690, 'provenance_transaction', 'provenance_transaction.offre', 'Issu de l''offre', 4);


--
-- Data for Name: commune; Type: TABLE DATA; Schema: foncier; Owner: -
--

INSERT INTO foncier.commune VALUES (1, '94015', 'Bry-sur-Marne', 622);
INSERT INTO foncier.commune VALUES (2, '94017', 'Champigny-sur-Marne', 622);
INSERT INTO foncier.commune VALUES (3, '94019', 'Chennevières-sur-Marne', 622);
INSERT INTO foncier.commune VALUES (4, '93033', 'Gournay-sur-Marne', NULL);
INSERT INTO foncier.commune VALUES (5, '94060', 'La Queue-en-Brie', NULL);
INSERT INTO foncier.commune VALUES (6, '94059', 'Le Plessis-Trévise', NULL);
INSERT INTO foncier.commune VALUES (7, '94053', 'Noiseau', NULL);
INSERT INTO foncier.commune VALUES (8, '93051', 'Noisy-le-Grand', 622);
INSERT INTO foncier.commune VALUES (9, '94055', 'Ormesson-sur-Marne', 622);
INSERT INTO foncier.commune VALUES (10, '94071', 'Sucy-en-Brie', 622);
INSERT INTO foncier.commune VALUES (11, '94079', 'Villiers-sur-Marne', 622);
INSERT INTO foncier.commune VALUES (12, '77529', 'Voulangis', NULL);
INSERT INTO foncier.commune VALUES (13, '77055', 'Brou-sur-Chantereine', 622);
INSERT INTO foncier.commune VALUES (14, '77083', 'Champs-sur-Marne', 622);
INSERT INTO foncier.commune VALUES (15, '77108', 'Chelles', 622);
INSERT INTO foncier.commune VALUES (16, '77139', 'Courtry', 622);
INSERT INTO foncier.commune VALUES (17, '77146', 'Croissy-Beaubourg', 622);
INSERT INTO foncier.commune VALUES (18, '77169', 'Émerainville', 622);
INSERT INTO foncier.commune VALUES (19, '77258', 'Lognes', 622);
INSERT INTO foncier.commune VALUES (20, '77337', 'Noisiel', 622);
INSERT INTO foncier.commune VALUES (21, '77373', 'Pontault-Combault', 622);
INSERT INTO foncier.commune VALUES (22, '77390', 'Roissy-en-Brie', 622);
INSERT INTO foncier.commune VALUES (23, '77468', 'Torcy', 622);
INSERT INTO foncier.commune VALUES (24, '77479', 'Vaires-sur-Marne', 622);
INSERT INTO foncier.commune VALUES (25, '77058', 'Bussy-Saint-Georges', 622);
INSERT INTO foncier.commune VALUES (26, '77059', 'Bussy-Saint-Martin', 622);
INSERT INTO foncier.commune VALUES (27, '77062', 'Carnetin', 622);
INSERT INTO foncier.commune VALUES (28, '77075', 'Chalifert', 622);
INSERT INTO foncier.commune VALUES (29, '77085', 'Chanteloup-en-Brie', 622);
INSERT INTO foncier.commune VALUES (30, '77121', 'Collégien', 622);
INSERT INTO foncier.commune VALUES (31, '77124', 'Conches-sur-Gondoire', 622);
INSERT INTO foncier.commune VALUES (32, '77155', 'Dampmart', 622);
INSERT INTO foncier.commune VALUES (33, '77177', 'Favières', NULL);
INSERT INTO foncier.commune VALUES (34, '77181', 'Ferrières-en-Brie', 622);
INSERT INTO foncier.commune VALUES (35, '77209', 'Gouvernes', 622);
INSERT INTO foncier.commune VALUES (36, '77221', 'Guermantes', 622);
INSERT INTO foncier.commune VALUES (37, '77234', 'Jablines', 622);
INSERT INTO foncier.commune VALUES (38, '77237', 'Jos"user"ny', 622);
INSERT INTO foncier.commune VALUES (39, '77243', 'Lagny-sur-Marne', 622);
INSERT INTO foncier.commune VALUES (40, '77248', 'Lesches', 622);
INSERT INTO foncier.commune VALUES (41, '77307', 'Montévrain', 622);
INSERT INTO foncier.commune VALUES (42, '77372', 'Pomponne', 622);
INSERT INTO foncier.commune VALUES (43, '77374', 'Pontcarré', NULL);
INSERT INTO foncier.commune VALUES (44, '77438', 'Saint-Thibault-des-Vignes', 622);
INSERT INTO foncier.commune VALUES (45, '77464', 'Thorigny-sur-Marne', 622);
INSERT INTO foncier.commune VALUES (46, '77018', 'Bailly-Romainvilliers', 621);
INSERT INTO foncier.commune VALUES (47, '77111', 'Chessy', 621);
INSERT INTO foncier.commune VALUES (48, '77132', 'Coupvray', 621);
INSERT INTO foncier.commune VALUES (49, '77141', 'Coutevroult', NULL);
INSERT INTO foncier.commune VALUES (50, '77171', 'Esbly', NULL);
INSERT INTO foncier.commune VALUES (51, '77268', 'Magny-le-Hongre', 621);
INSERT INTO foncier.commune VALUES (52, '77315', 'Montry', NULL);
INSERT INTO foncier.commune VALUES (53, '77413', 'Saint-Germain-sur-Morin', NULL);
INSERT INTO foncier.commune VALUES (54, '77449', 'Serris', 621);
INSERT INTO foncier.commune VALUES (55, '77510', 'Villeneuve-Saint-Denis', NULL);
INSERT INTO foncier.commune VALUES (56, '77508', 'Villeneuve-le-Comte', 621);
INSERT INTO foncier.commune VALUES (57, '94004', 'Boissy-Saint-Léger', NULL);
INSERT INTO foncier.commune VALUES (58, '77521', 'Villiers-sur-Morin', NULL);
INSERT INTO foncier.commune VALUES (59, '93050', 'Neuilly-sur-Marne', NULL);
INSERT INTO foncier.commune VALUES (60, '77125', 'Conde-Sainte-Libiaire', NULL);
INSERT INTO foncier.commune VALUES (61, '77005', 'Annet-sur-Marne', NULL);
INSERT INTO foncier.commune VALUES (62, '77350', 'Ozoir-la-Ferrière', NULL);
INSERT INTO foncier.commune VALUES (63, '77336', 'Neufmoutiers-en-Brie', NULL);
INSERT INTO foncier.commune VALUES (64, '77318', 'Mortcerf', NULL);
INSERT INTO foncier.commune VALUES (65, '93049', 'Neuilly-Plaisance', NULL);
INSERT INTO foncier.commune VALUES (66, '77498', 'Vignely', NULL);
INSERT INTO foncier.commune VALUES (67, '77094', 'Charmentray', NULL);
INSERT INTO foncier.commune VALUES (68, '77376', 'Précy-sur-Marne', NULL);
INSERT INTO foncier.commune VALUES (69, '93064', 'Rosny-sous-Bois', NULL);
INSERT INTO foncier.commune VALUES (70, '77466', 'Tigeaux', NULL);
INSERT INTO foncier.commune VALUES (71, '77363', 'Le Pin', NULL);
INSERT INTO foncier.commune VALUES (72, '77232', 'Isles-lès-Villenoy', NULL);
INSERT INTO foncier.commune VALUES (73, '77196', 'Fresnes-sur-Marne', NULL);
INSERT INTO foncier.commune VALUES (74, '77474', 'Trilbardou', NULL);
INSERT INTO foncier.commune VALUES (75, '77154', 'Dammartin-sur-Tigeaux', NULL);
INSERT INTO foncier.commune VALUES (76, '77517', 'Villevaudé', NULL);
INSERT INTO foncier.commune VALUES (77, '77142', 'Crécy-la-Chapelle', NULL);


--
-- Data for Name: operation; Type: TABLE DATA; Schema: foncier; Owner: -
--

INSERT INTO foncier.operation VALUES (1, 'zz Historique SommierCités MLC 93051');
INSERT INTO foncier.operation VALUES (2, 'zz Historique SommierCités ACQ 77307');
INSERT INTO foncier.operation VALUES (3, 'ZAC DU CHEMIN DE CROISSY (TORCY)');
INSERT INTO foncier.operation VALUES (4, 'zz Historique SommierCités MPC 77237');
INSERT INTO foncier.operation VALUES (5, 'zz Historique SommierCités CES 77141');
INSERT INTO foncier.operation VALUES (6, 'zz Historique SommierCités ACQ 77058');
INSERT INTO foncier.operation VALUES (7, 'zz Historique SommierCités CES 77337');
INSERT INTO foncier.operation VALUES (8, 'SUPPORT DE L''OPERATION VILLAGE');
INSERT INTO foncier.operation VALUES (9, 'zz Historique SommierCités ACQ 77169');
INSERT INTO foncier.operation VALUES (10, 'ZAC DE CHAMPS-NOISIEL-TORCY (CNT)');
INSERT INTO foncier.operation VALUES (11, 'zz Historique SommierCités ACQ 77142');
INSERT INTO foncier.operation VALUES (12, 'ZONE DES COURTOURIS');
INSERT INTO foncier.operation VALUES (13, 'zz Historique SommierCités CES 77142');
INSERT INTO foncier.operation VALUES (14, 'zz Historique SommierCités MPC 77111');
INSERT INTO foncier.operation VALUES (15, 'zz Historique SommierCités LOC 77181');
INSERT INTO foncier.operation VALUES (16, 'HORS ZONE SECTEUR EST');
INSERT INTO foncier.operation VALUES (17, 'HORS ZONE JOIS"user"NY');
INSERT INTO foncier.operation VALUES (18, 'zz Historique SommierCités MPC 77315');
INSERT INTO foncier.operation VALUES (19, 'zz Historique SommierCités ACQ 93051');
INSERT INTO foncier.operation VALUES (20, 'ZAC DES GASSETS');
INSERT INTO foncier.operation VALUES (21, 'zz Historique SommierCités CES 77258');
INSERT INTO foncier.operation VALUES (22, 'zz Historique SommierCités MPC 77059');
INSERT INTO foncier.operation VALUES (23, 'zz Historique SommierCités MLV 93051');
INSERT INTO foncier.operation VALUES (24, 'ZAC DES PORTES DE VILLIERS');
INSERT INTO foncier.operation VALUES (25, 'ZAC DES FONTAINES GIROUX');
INSERT INTO foncier.operation VALUES (26, 'ZAC CHAMPS NOISIEL-TORCY (CNT)');
INSERT INTO foncier.operation VALUES (27, 'VILLAGES NATURE');
INSERT INTO foncier.operation VALUES (28, 'zz Historique SommierCités LOC 93051');
INSERT INTO foncier.operation VALUES (29, 'ZAC DE LA HAUTE MAISON (CITE DESCARTES)');
INSERT INTO foncier.operation VALUES (30, 'HORS ZONE SECTEUR 2');
INSERT INTO foncier.operation VALUES (31, 'HORS ZONE VAL MAUBUEE');
INSERT INTO foncier.operation VALUES (32, 'ZAC DE CHAMPS-NOISIEL-TORCY (CNT) (TORCY)');
INSERT INTO foncier.operation VALUES (33, 'ZAC DE ROMAINVILLIERS');
INSERT INTO foncier.operation VALUES (34, 'zz Historique SommierCités LOC 77083');
INSERT INTO foncier.operation VALUES (35, 'zz Historique SommierCités LOC 77468');
INSERT INTO foncier.operation VALUES (36, 'Hors Zone Secteur 1');
INSERT INTO foncier.operation VALUES (37, 'ZAC DU CENTRE VILLE');
INSERT INTO foncier.operation VALUES (38, 'ZAC DU CHENE SAINT-FIACRE');
INSERT INTO foncier.operation VALUES (39, 'zz Historique SommierCités ACQ 77258');
INSERT INTO foncier.operation VALUES (40, 'zz Historique SommierCités LOC 77169');
INSERT INTO foncier.operation VALUES (41, 'zz Historique SommierCités CES 94015');
INSERT INTO foncier.operation VALUES (42, 'zz Historique SommierCités ACQ 77075');
INSERT INTO foncier.operation VALUES (43, 'zz Historique SommierCités ACQ 77141');
INSERT INTO foncier.operation VALUES (44, 'zz Historique SommierCités ACQ 77059');
INSERT INTO foncier.operation VALUES (45, 'zz Historique SommierCités MPC 77268');
INSERT INTO foncier.operation VALUES (46, ' ZAC DE VILLAGES NATURE');
INSERT INTO foncier.operation VALUES (47, 'zz Historique SommierCités CES 77449');
INSERT INTO foncier.operation VALUES (48, 'zz Historique SommierCités MLC 77258');
INSERT INTO foncier.operation VALUES (49, 'Ancienne ZAC DU CHEMAIN DE CROISSY');
INSERT INTO foncier.operation VALUES (50, 'ZAC DU COUTERNOIS');
INSERT INTO foncier.operation VALUES (51, 'ZAC DE CHESSY');
INSERT INTO foncier.operation VALUES (52, 'zz Historique SommierCités MPC 77510');
INSERT INTO foncier.operation VALUES (53, 'zz Historique SommierCités MPC 77058');
INSERT INTO foncier.operation VALUES (54, 'zz Historique SommierCités CES 77124');
INSERT INTO foncier.operation VALUES (55, 'zz Historique SommierCités CES 77221');
INSERT INTO foncier.operation VALUES (56, 'ZAC DE COUPVRAY');
INSERT INTO foncier.operation VALUES (57, 'ZAC DES STUDIOS ET DES CONGRES');
INSERT INTO foncier.operation VALUES (58, 'ZAC DES DEUX Golf');
INSERT INTO foncier.operation VALUES (59, 'zz Historique SommierCités MLC 77083');
INSERT INTO foncier.operation VALUES (60, 'zz Historique SommierCités MLV 94015');
INSERT INTO foncier.operation VALUES (61, 'ZAC DU PRE DE CLAYE');
INSERT INTO foncier.operation VALUES (62, 'zz Historique SommierCités MPC 94079');
INSERT INTO foncier.operation VALUES (63, 'zz Historique SommierCités MLV 77058');
INSERT INTO foncier.operation VALUES (64, 'zz Historique SommierCités MPC 77146');
INSERT INTO foncier.operation VALUES (65, 'zz Historique SommierCités MPC 77209');
INSERT INTO foncier.operation VALUES (66, 'ZAC DES COTEAUX DE MAUBUEE');
INSERT INTO foncier.operation VALUES (67, 'ZAC DE LA HAUTE MAISON (Cité Descartes)');
INSERT INTO foncier.operation VALUES (68, 'Hors Zone Secteur 2');
INSERT INTO foncier.operation VALUES (69, 'zz Historique SommierCités LOC 77108');
INSERT INTO foncier.operation VALUES (70, 'ZAC DU RU DE NESLES');
INSERT INTO foncier.operation VALUES (71, 'zz Historique SommierCités MPC 77141');
INSERT INTO foncier.operation VALUES (72, 'QUARTIER DE L''EST (ES) (ORTDASE)');
INSERT INTO foncier.operation VALUES (73, 'HORS ZONE BUSSY');
INSERT INTO foncier.operation VALUES (74, 'zz Historique SommierCités ACQ 77121');
INSERT INTO foncier.operation VALUES (75, 'zz Historique SommierCités ACQ 77124');
INSERT INTO foncier.operation VALUES (76, 'ZAC DU SEGRAIS');
INSERT INTO foncier.operation VALUES (77, 'zz Historique SommierCités CES 77413');
INSERT INTO foncier.operation VALUES (78, 'zz Historique SommierCités LOC 77221');
INSERT INTO foncier.operation VALUES (79, 'zz Historique SommierCités MPC 93051');
INSERT INTO foncier.operation VALUES (80, 'zz Historique SommierCités MPC 77085');
INSERT INTO foncier.operation VALUES (81, 'ZAC DE VILLAGES NATURE');
INSERT INTO foncier.operation VALUES (82, 'QUARTIER DE L''EST (ES) (ORT DASE)');
INSERT INTO foncier.operation VALUES (83, 'ZAI de Paris Est');
INSERT INTO foncier.operation VALUES (84, 'zz Historique SommierCités ACQ 77085');
INSERT INTO foncier.operation VALUES (85, 'zz Historique SommierCités ACQ 77083');
INSERT INTO foncier.operation VALUES (86, 'ZAC DE SAINT-THIBAULT');
INSERT INTO foncier.operation VALUES (87, 'zz Historique SommierCités MPC 77169');
INSERT INTO foncier.operation VALUES (88, 'zz Historique SommierCités CES 77373');
INSERT INTO foncier.operation VALUES (89, 'zz Historique SommierCités MPC 77438');
INSERT INTO foncier.operation VALUES (90, 'zz Historique SommierCités MPC 77449');
INSERT INTO foncier.operation VALUES (91, 'zz Historique SommierCités ACQ 77221');
INSERT INTO foncier.operation VALUES (92, 'zz Historique SommierCités CES 77468');
INSERT INTO foncier.operation VALUES (93, 'ZAC DU PRE AU CHENE');
INSERT INTO foncier.operation VALUES (94, 'zz Historique SommierCités CES 77083');
INSERT INTO foncier.operation VALUES (95, 'ZAC DE LA MOTTE');
INSERT INTO foncier.operation VALUES (96, 'zz Historique SommierCités MPC 77124');
INSERT INTO foncier.operation VALUES (97, 'ZAC LE PARC DU BEL AIR');
INSERT INTO foncier.operation VALUES (98, 'ZINE DES COURTOURIS');
INSERT INTO foncier.operation VALUES (99, 'zz Historique SommierCités CES 77121');
INSERT INTO foncier.operation VALUES (100, 'zz Historique SommierCités MPC 77018');
INSERT INTO foncier.operation VALUES (101, 'Hors zone secteur 2');
INSERT INTO foncier.operation VALUES (102, 'zz Historique SommierCités ACQ 77209');
INSERT INTO foncier.operation VALUES (103, 'zz Historique SommierCités ACQ 77146');
INSERT INTO foncier.operation VALUES (104, 'zz Historique SommierCités LOC 77258');
INSERT INTO foncier.operation VALUES (105, 'zz Historique SommierCités MLV 77258');
INSERT INTO foncier.operation VALUES (106, 'zz Historique SommierCités CES 77059');
INSERT INTO foncier.operation VALUES (107, 'zz Historique SommierCités CES 77510');
INSERT INTO foncier.operation VALUES (109, 'zz Historique SommierCités CES 77307');
INSERT INTO foncier.operation VALUES (110, 'zz Historique SommierCités MPC 77508');
INSERT INTO foncier.operation VALUES (111, 'ZAC de l''Extension du Cuir');
INSERT INTO foncier.operation VALUES (112, 'ZAC LE SYCOMORE');
INSERT INTO foncier.operation VALUES (113, 'ZAC DU MANDINET');
INSERT INTO foncier.operation VALUES (114, 'ZAC DES CENT ARPENTS ');
INSERT INTO foncier.operation VALUES (115, 'ZAC DE LA HAUTE-MAISON');
INSERT INTO foncier.operation VALUES (116, 'zz Historique SommierCités CES 77111');
INSERT INTO foncier.operation VALUES (117, 'zz Historique SommierCités MLV 77083');
INSERT INTO foncier.operation VALUES (118, 'ZAC MARNE-EUROPE');
INSERT INTO foncier.operation VALUES (119, 'zz Historique SommierCités MPC 77121');
INSERT INTO foncier.operation VALUES (120, 'ZONE DU SYCOMORE');
INSERT INTO foncier.operation VALUES (121, 'zz Historique SommierCités CES 77169');
INSERT INTO foncier.operation VALUES (122, 'zz Historique SommierCités LOC 77058');
INSERT INTO foncier.operation VALUES (123, 'zz Historique SommierCités ACQ 77337');
INSERT INTO foncier.operation VALUES (124, 'zz Historique SommierCités MLC 77468');
INSERT INTO foncier.operation VALUES (125, 'ZAC DU CLOS ROSE');
INSERT INTO foncier.operation VALUES (126, 'zz Historique SommierCités CES 77181');
INSERT INTO foncier.operation VALUES (127, 'ZAC DU CENTRE DE MAGNY');
INSERT INTO foncier.operation VALUES (128, 'zz Historique SommierCités CES 77315');
INSERT INTO foncier.operation VALUES (129, 'ZAC PORTES DE L''EUROPE');
INSERT INTO foncier.operation VALUES (130, 'zz Historique SommierCités CES 77237');
INSERT INTO foncier.operation VALUES (131, 'zz Historique SommierCités ACQ 77181');
INSERT INTO foncier.operation VALUES (132, 'ZAC DU VILLAGE');
INSERT INTO foncier.operation VALUES (133, 'ZAC CASTERMANT');
INSERT INTO foncier.operation VALUES (134, 'zz Historique SommierCités CES 77508');
INSERT INTO foncier.operation VALUES (135, 'ZAC DES DEUX CHATEAUX (SUPPRIMEE)');
INSERT INTO foncier.operation VALUES (136, 'zz Historique SommierCités MPC 77373');
INSERT INTO foncier.operation VALUES (137, 'zz Historique SommierCités MPC 77243');
INSERT INTO foncier.operation VALUES (138, '943470 - ILOT AF4-A 1,2,4,5,7 11-AVENAN');
INSERT INTO foncier.operation VALUES (139, 'zz Historique SommierCités ACQ 77315');
INSERT INTO foncier.operation VALUES (140, 'zz Historique SommierCités CES 77058');
INSERT INTO foncier.operation VALUES (141, 'ZAC DE MONTEVRAIN - VAL D''EUROPE');
INSERT INTO foncier.operation VALUES (142, 'zz Historique SommierCités CES 77243');
INSERT INTO foncier.operation VALUES (143, 'ZAC DES CHARMETTES');
INSERT INTO foncier.operation VALUES (144, 'HORS ZONE CHANTELOUP');
INSERT INTO foncier.operation VALUES (145, 'zz Historique SommierCités MLC 77337');
INSERT INTO foncier.operation VALUES (146, 'ZONE DE L''ERMITAGE');
INSERT INTO foncier.operation VALUES (147, 'zz Historique SommierCités CES 77209');
INSERT INTO foncier.operation VALUES (148, 'zz Historique SommierCités CES 77132');
INSERT INTO foncier.operation VALUES (149, 'zz Historique SommierCités ACQ 77268');
INSERT INTO foncier.operation VALUES (150, 'ORMESSON VDO');
INSERT INTO foncier.operation VALUES (151, 'zz Historique SommierCités CES 77146');
INSERT INTO foncier.operation VALUES (152, 'zz Historique SommierCités MPC 77258');
INSERT INTO foncier.operation VALUES (153, 'ZAC D''ACTIVITES DE LA CHARBONNIERE');
INSERT INTO foncier.operation VALUES (154, 'ZAC DES TROIS ORMES');
INSERT INTO foncier.operation VALUES (155, 'zz Historique SommierCités MLV 77169');
INSERT INTO foncier.operation VALUES (156, 'zz Historique SommierCités MPC 77181');
INSERT INTO foncier.operation VALUES (157, 'zz Historique SommierCités ACQ 77508');
INSERT INTO foncier.operation VALUES (158, 'zz Historique SommierCités ACQ 77468');
INSERT INTO foncier.operation VALUES (159, 'zz Historique SommierCités MLV 77018');
INSERT INTO foncier.operation VALUES (160, 'zz Historique SommierCités MPC 77132');
INSERT INTO foncier.operation VALUES (161, 'zz Historique SommierCités MLV 77132');
INSERT INTO foncier.operation VALUES (162, 'zz Historique SommierCités MLV 77468');
INSERT INTO foncier.operation VALUES (163, 'ZAC DU CENTRE URBAIN DU VAL D''EUROPE (CHESSY)');
INSERT INTO foncier.operation VALUES (164, 'ZAC des Vergers');
INSERT INTO foncier.operation VALUES (165, 'zz Historique SommierCités CES 77085');
INSERT INTO foncier.operation VALUES (166, 'ZAC GENITOY NORD');
INSERT INTO foncier.operation VALUES (167, 'ANCIENNE ZAC DES LUATS');
INSERT INTO foncier.operation VALUES (168, 'HORS ZONE SECTEUR 1 (9021)');
INSERT INTO foncier.operation VALUES (169, 'ZAC LE GUE LANGLOIS');
INSERT INTO foncier.operation VALUES (170, 'ZAC DE LA PLAINE DES COUTEAUX');
INSERT INTO foncier.operation VALUES (171, 'zz Historique SommierCités LOC 77146');
INSERT INTO foncier.operation VALUES (172, 'zz Historique SommierCités ACQ 77237');
INSERT INTO foncier.operation VALUES (173, 'ZAC DE NOISY EST');
INSERT INTO foncier.operation VALUES (174, 'ZAC DES HAUTS DE NESLES');
INSERT INTO foncier.operation VALUES (175, 'zz Historique SommierCités MPC 77083');
INSERT INTO foncier.operation VALUES (176, 'zz Historique SommierCités CES 77438');
INSERT INTO foncier.operation VALUES (177, 'zz Historique SommierCités MPC 77413');
INSERT INTO foncier.operation VALUES (178, 'zz Historique SommierCités MLV 77449');
INSERT INTO foncier.operation VALUES (179, 'zz Historique SommierCités ACQ 77449');
INSERT INTO foncier.operation VALUES (180, 'Hors Zone Montévrain');
INSERT INTO foncier.operation VALUES (181, 'zz Historique SommierCités ACQ 77111');
INSERT INTO foncier.operation VALUES (182, 'zz Historique SommierCités CES 77018');
INSERT INTO foncier.operation VALUES (183, 'ZAC MONTEVRAIN-UNIVERSITE');
INSERT INTO foncier.operation VALUES (184, 'zz Historique SommierCités MLV 77337');
INSERT INTO foncier.operation VALUES (185, 'HORS ZONE CROIX BLANCHE');
INSERT INTO foncier.operation VALUES (186, 'Ancienne ZAC DES COTEAUX DE MAUBUEE');
INSERT INTO foncier.operation VALUES (187, 'zz Historique SommierCités MPC 77221');
INSERT INTO foncier.operation VALUES (188, 'ZAC DU CENTRE URBAIN DU VAL D''EUROPE');
INSERT INTO foncier.operation VALUES (189, 'ZAC des chemin de Croissy Collégien (9392)');
INSERT INTO foncier.operation VALUES (190, 'zz Historique SommierCités MPC 77468');
INSERT INTO foncier.operation VALUES (191, 'ZAC DE COURTALIN');
INSERT INTO foncier.operation VALUES (192, 'zz Historique SommierCités CES 77075');
INSERT INTO foncier.operation VALUES (193, 'ZAC DE MAINOUE');
INSERT INTO foncier.operation VALUES (194, 'zz Historique SommierCités CES 94079');
INSERT INTO foncier.operation VALUES (195, 'zz Historique SommierCités ACQ 94015');
INSERT INTO foncier.operation VALUES (196, 'zz Historique SommierCités MPC 77075');
INSERT INTO foncier.operation VALUES (197, 'ZAC du Bourg de SERRIS');
INSERT INTO foncier.operation VALUES (198, 'ZAC DES FONTAINES Giroux');
INSERT INTO foncier.operation VALUES (199, 'ZAC DU PRIEURE OUEST');
INSERT INTO foncier.operation VALUES (200, 'ZAC DU PARC ET DU CENTRE TOURISTIQUE');
INSERT INTO foncier.operation VALUES (201, 'zz Historique SommierCités ACQ 94079');
INSERT INTO foncier.operation VALUES (202, 'zz Historique SommierCités ACQ 77243');
INSERT INTO foncier.operation VALUES (203, 'Vallée de la brosse à Bussy');
INSERT INTO foncier.operation VALUES (204, 'zz Historique SommierCités ACQ 77438');
INSERT INTO foncier.operation VALUES (205, 'zz Historique SommierCités CES 77108');
INSERT INTO foncier.operation VALUES (206, 'zz Historique SommierCités MPC 77307');
INSERT INTO foncier.operation VALUES (207, 'zz Historique SommierCités CES 93051');
INSERT INTO foncier.operation VALUES (208, 'ZAC DES COTEAUX DE LA MARNE');
INSERT INTO foncier.operation VALUES (209, 'zz Historique SommierCités MPC 94015');
INSERT INTO foncier.operation VALUES (210, 'ZONE DE LA COULOMMIERE');
INSERT INTO foncier.operation VALUES (211, 'ZAC DU PRIEURE EST');
INSERT INTO foncier.operation VALUES (212, 'zz Historique SommierCités ACQ 77510');
INSERT INTO foncier.operation VALUES (213, 'ZAI PARIS-EST');
INSERT INTO foncier.operation VALUES (214, 'ZAC LEONARD DE VINCI');
INSERT INTO foncier.operation VALUES (215, 'zz Historique SommierCités ACQ 77132');
INSERT INTO foncier.operation VALUES (216, 'zz Historique SommierCités MPC 77337');
INSERT INTO foncier.operation VALUES (217, 'zz Historique SommierCités ACQ 77413');
INSERT INTO foncier.operation VALUES (218, 'zz Historique SommierCités CES 77268');
INSERT INTO foncier.operation VALUES (219, 'ZAC DE LAMIRAULT (COLLEGIEN)');
INSERT INTO foncier.operation VALUES (220, 'zz Historique SommierCités ACQ 77018');
INSERT INTO foncier.operation VALUES (221, 'ZAC VILLAGES NATURE');
INSERT INTO foncier.operation VALUES (222, 'zz Historique SommierCités MLV 77111');
INSERT INTO foncier.operation VALUES (223, 'ZAC DE LA PLAINE DES CANTOUX');
INSERT INTO foncier.operation VALUES (108, 'ZAC DE LAMIRAULT (CROISSY-BEAUBOURG)');


--
-- Name: commune_pk_commune_seq; Type: SEQUENCE SET; Schema: foncier; Owner: -
--

SELECT pg_catalog.setval('foncier.commune_pk_commune_seq', 77, true);


--
-- Name: liste_pk_liste_seq; Type: SEQUENCE SET; Schema: foncier; Owner: -
--

SELECT pg_catalog.setval('foncier.liste_pk_liste_seq', 5, true);


--
-- Name: operation_pk_operation_seq; Type: SEQUENCE SET; Schema: foncier; Owner: -
--

SELECT pg_catalog.setval('foncier.operation_pk_operation_seq', 222, true);


--
-- PostgreSQL database dump complete
--

