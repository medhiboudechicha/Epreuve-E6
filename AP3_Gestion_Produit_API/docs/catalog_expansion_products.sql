USE gestion_produits;

-- Premiere vague d'articles ajoutes pour enrichir le catalogue generique.
-- ON DUPLICATE KEY UPDATE rend ce script relancable sans creer de doublons.
INSERT INTO produit (id_produit, nom, description, prix, stock, image) VALUES
('P007', 'Casque audio nomade', 'Casque confortable pour ecoute quotidienne avec arceau souple et son equilibre.', 79.90, 18, 'kaitlin_headphones.jpg'),
('P008', 'Lampe de bureau noire', 'Lampe orientable pour poste de travail, lecture ou table de chevet.', 34.90, 24, 'black_desk_lamp.jpg'),
('P009', 'Sac a dos urbain 22L', 'Sac polyvalent avec poche frontale, bretelles rembourrees et grand compartiment.', 49.90, 28, 'backpack.jpg'),
('P010', 'Sweat a capuche gris', 'Sweat molletonne coupe reguliere pour sorties, confort et mi-saison.', 54.90, 16, 'hoodie_man.jpg'),
('P011', 'Gourde rigide 750 ml', 'Gourde reutilisable legere pour sport, bureau ou transport quotidien.', 17.90, 35, 'polycarbonate_water_bottle.jpg'),
('P012', 'Clavier compact sans fil', 'Clavier compact pour bureau mobile avec frappe souple et connexion sans fil.', 69.90, 20, 'keyboard_compact.jpg'),
('P013', 'Bouilloire electrique inox 1.7 L', 'Bouilloire rapide avec corps inox et bec verseur large pour cuisine ou bureau.', 34.90, 14, 'electric_kettle.jpg'),
('P014', 'Ordinateur portable 13 pouces', 'Portable leger pour bureautique, navigation et cours a distance.', 899.00, 9, 'laptop_image.jpg')
ON DUPLICATE KEY UPDATE
nom = VALUES(nom),
description = VALUES(description),
prix = VALUES(prix),
stock = VALUES(stock),
image = VALUES(image);

-- Donnees specifiques vetement pour le sweat. Le site et l'app affichent le
-- produit generique, mais la table de specialisation reste coherente.
INSERT INTO produit_vetement (id_produit, taille, couleur, matiere, id_marque) VALUES
('P010', 'M', 'gris', 'coton melange', 2)
ON DUPLICATE KEY UPDATE
taille = VALUES(taille),
couleur = VALUES(couleur),
matiere = VALUES(matiere),
id_marque = VALUES(id_marque);

-- Deuxieme vague: informatique, sport, cuisine, bureau et decoration.
INSERT INTO produit (id_produit, nom, description, prix, stock, image) VALUES
('P015', 'Souris optique USB', 'Souris filaire simple et precise pour ordinateur portable ou poste fixe.', 19.90, 32, 'computer_mice.jpg'),
('P016', 'Cle USB 64 Go', 'Cle compacte pour sauvegarder documents, photos et fichiers de cours.', 12.90, 50, 'usb_flash_drive.jpg'),
('P017', 'Tapis de yoga antiderapant', 'Tapis epais et stable pour yoga, stretching ou exercices au sol.', 29.90, 21, 'yoga_mats.jpg'),
('P018', 'Mug cafe ceramique', 'Mug colore en ceramique pour cafe, the ou boisson chaude.', 9.90, 45, 'multicolored_coffee_mug.jpg'),
('P019', 'Stylo bille bleu', 'Stylo bille classique pour prise de notes, bureau ou trousse scolaire.', 2.50, 100, 'typical_ballpoint_pen.jpg'),
('P020', 'Poele en fonte 26 cm', 'Poele robuste pour cuisson quotidienne, saisie de viandes et plats maison.', 39.90, 17, 'cast_iron_pan.jpg'),
('P021', 'Ballon de basket indoor', 'Ballon de basket pour entrainement en salle et loisirs sportifs.', 24.90, 26, 'basketball_ball.jpg'),
('P022', 'Chaussures de running legeres', 'Chaussures respirantes pour course, marche active et entrainement.', 89.90, 13, 'running_shoes_display.jpg'),
('P023', 'Appareil photo compact', 'Appareil photo numerique compact pour voyages, souvenirs et sorties.', 149.90, 8, 'compact_camera.jpg'),
('P024', 'Plante verte en pot', 'Plante decorative en pot pour bureau, salon ou chambre.', 16.90, 30, 'potted_plant.jpg')
ON DUPLICATE KEY UPDATE
nom = VALUES(nom),
description = VALUES(description),
prix = VALUES(prix),
stock = VALUES(stock),
image = VALUES(image);

-- Les chaussures de running sont rattachees a la table vetement pour garder
-- le modele relationnel exploitable si l'app affiche plus tard les sous-types.
INSERT INTO produit_vetement (id_produit, taille, couleur, matiere, id_marque) VALUES
('P022', '42', 'bleu', 'mesh synthetique', 1)
ON DUPLICATE KEY UPDATE
taille = VALUES(taille),
couleur = VALUES(couleur),
matiere = VALUES(matiere),
id_marque = VALUES(id_marque);
