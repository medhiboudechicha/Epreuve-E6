-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- HÃ´te : localhost:3306
-- GÃ©nÃ©rÃ© le : mer. 20 mai 2026 Ã  20:13
-- Version du serveur : 8.4.3
-- Version de PHP : 8.3.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de donnÃ©es : `gestion_produits`
--

DELIMITER $$
--
-- ProcÃ©dures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_historique_par_mot_cle` (IN `p_texte` VARCHAR(100))   BEGIN
    SELECT id_historique, date_action, action
    FROM historique
    WHERE action LIKE CONCAT('%', p_texte, '%')
    ORDER BY date_action DESC, id_historique DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_liste_historique` ()   BEGIN
    SELECT id_historique, date_action, action
    FROM historique
    ORDER BY date_action DESC, id_historique DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_nb_commandes_utilisateur` (IN `p_id_utilisateur` INT, OUT `p_nb_commandes` INT)   BEGIN
    SELECT COUNT(*)
    INTO p_nb_commandes
    FROM commande
    WHERE id_utilisateur = p_id_utilisateur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_produit` (IN `p_id_produit` VARCHAR(50), IN `p_nom` VARCHAR(100), IN `p_description` VARCHAR(255), IN `p_prix` VARCHAR(50), IN `p_stock` VARCHAR(50), IN `p_image` VARCHAR(255))   BEGIN
 INSERT INTO produit (id_produit, nom, description, prix, stock, image)
 VALUES (p_id_produit, p_nom, p_description, p_prix, p_stock, p_image);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_produit` (IN `p_id_produit` VARCHAR(50))   BEGIN
 DELETE FROM produit
 WHERE id_produit = p_id_produit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_produits` ()   BEGIN
 SELECT 
    p.id_produit,
    p.nom,
    p.prix,
    p.stock,
    a.nom AS nom_auteur
 FROM produit p
 LEFT JOIN produit_livre pl ON pl.id_produit = p.id_produit
 LEFT JOIN auteur a ON a.id_auteur = pl.id_auteur
 ORDER BY p.id_produit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_produit` (IN `p_id_produit` VARCHAR(50))   BEGIN
 SELECT 
    p.id_produit,
    p.nom,
    p.description,
    p.prix,
    p.stock,
    p.image,
    a.nom AS nom_auteur
 FROM produit p
 LEFT JOIN produit_livre pl ON pl.id_produit = p.id_produit
 LEFT JOIN auteur a ON a.id_auteur = pl.id_auteur
 WHERE p.id_produit = p_id_produit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_produit` (IN `p_id_produit` VARCHAR(50), IN `p_nom` VARCHAR(100), IN `p_description` VARCHAR(255), IN `p_prix` VARCHAR(50), IN `p_stock` VARCHAR(50), IN `p_image` VARCHAR(255))   BEGIN
 UPDATE produit
 SET nom = p_nom,
     description = p_description,
     prix = p_prix,
     stock = p_stock,
     image = p_image
 WHERE id_produit = p_id_produit;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `appartenir`
--

CREATE TABLE `appartenir` (
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `id_commande` int NOT NULL,
  `quantite` int DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `appartenir`
--

INSERT INTO `appartenir` (`id_produit`, `id_commande`, `quantite`) VALUES
('P001', 1, 1),
('P001', 8, 1),
('P001', 9, 1),
('P001', 14, 3),
('P002', 14, 1),
('P004', 1, 1),
('P6926afa423f43', 10, 1);

--
-- DÃ©clencheurs `appartenir`
--
DELIMITER $$
CREATE TRIGGER `sync_commande_quantite_after_delete` AFTER DELETE ON `appartenir` FOR EACH ROW UPDATE commande
             SET quantite = (
                 SELECT COALESCE(SUM(quantite), 0)
                 FROM appartenir
                 WHERE id_commande = OLD.id_commande
             )
             WHERE id_commande = OLD.id_commande
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `sync_commande_quantite_after_insert` AFTER INSERT ON `appartenir` FOR EACH ROW UPDATE commande
             SET quantite = (
                 SELECT COALESCE(SUM(quantite), 0)
                 FROM appartenir
                 WHERE id_commande = NEW.id_commande
             )
             WHERE id_commande = NEW.id_commande
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `sync_commande_quantite_after_update` AFTER UPDATE ON `appartenir` FOR EACH ROW UPDATE commande
             SET quantite = (
                 SELECT COALESCE(SUM(a.quantite), 0)
                 FROM appartenir a
                 WHERE a.id_commande = commande.id_commande
             )
             WHERE id_commande IN (OLD.id_commande, NEW.id_commande)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `auteur`
--

CREATE TABLE `auteur` (
  `id_auteur` int NOT NULL,
  `nom` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `auteur`
--

INSERT INTO `auteur` (`id_auteur`, `nom`, `description`) VALUES
(1, 'J.k. rowling', 'auteure britannique cÃ©lÃ¨bre pour harry potter'),
(2, 'George orwell', 'romancier et essayiste anglais'),
(3, 'Victor hugo', 'Ã©crivain franÃ§ais du xixe siÃ¨cle');

--
-- DÃ©clencheurs `auteur`
--
DELIMITER $$
CREATE TRIGGER `format_auteur` BEFORE INSERT ON `auteur` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `format_auteur_update` BEFORE UPDATE ON `auteur` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `classer`
--

CREATE TABLE `classer` (
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `id_genre` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `classer`
--

INSERT INTO `classer` (`id_produit`, `id_genre`) VALUES
('P001', 1),
('P002', 2),
('P003', 3);

-- --------------------------------------------------------

--
-- Structure de la table `commande`
--

CREATE TABLE `commande` (
  `id_commande` int NOT NULL,
  `date_commande` datetime DEFAULT NULL,
  `quantite` int DEFAULT NULL,
  `id_utilisateur` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `commande`
--

INSERT INTO `commande` (`id_commande`, `date_commande`, `quantite`, `id_utilisateur`) VALUES
(1, '2025-10-05 10:00:00', 2, 1),
(8, '2025-12-10 07:36:43', 1, 9),
(9, '2025-12-10 07:37:17', 1, 9),
(10, '2026-04-08 08:27:50', 1, 0),
(14, '2026-04-08 09:18:24', 4, 0);

--
-- DÃ©clencheurs `commande`
--
DELIMITER $$
CREATE TRIGGER `hist_commande_delete` AFTER DELETE ON `commande` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT(
            'Suppression commande ', OLD.id_commande,
            ' pour utilisateur ', OLD.id_utilisateur
        )
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `hist_commande_insert` AFTER INSERT ON `commande` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT(
            'CrÃ©ation commande ', NEW.id_commande,
            ' pour utilisateur ', NEW.id_utilisateur
        )
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `consulter`
--

CREATE TABLE `consulter` (
  `id_utilisateur` int NOT NULL,
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `consulter`
--

INSERT INTO `consulter` (`id_utilisateur`, `id_produit`) VALUES
(1, 'P001'),
(2, 'P004'),
(3, 'P005'),
(4, 'P006');

-- --------------------------------------------------------

--
-- Structure de la table `fournir`
--

CREATE TABLE `fournir` (
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `id_fournisseur` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `fournir`
--

INSERT INTO `fournir` (`id_produit`, `id_fournisseur`) VALUES
('P001', 1),
('P002', 1),
('P003', 1),
('P004', 2),
('P005', 2),
('P006', 3);

-- --------------------------------------------------------

--
-- Structure de la table `fournisseur`
--

CREATE TABLE `fournisseur` (
  `id_fournisseur` int NOT NULL,
  `nom` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `adresse` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telephone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `fournisseur`
--

INSERT INTO `fournisseur` (`id_fournisseur`, `nom`, `adresse`, `email`, `telephone`) VALUES
(1, 'Livreplus', '12 rue du savoir, paris', 'contact@livreplus.fr', '0123456789'),
(2, 'Textilpro', '8 avenue du style, lyon', 'contact@textilpro.fr', '0987654321'),
(3, 'Technoworld', '25 rue des circuits, marseille', 'contact@technoworld.fr', '0567891234');

--
-- DÃ©clencheurs `fournisseur`
--
DELIMITER $$
CREATE TRIGGER `format_fournisseur` BEFORE INSERT ON `fournisseur` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `format_fournisseur_update` BEFORE UPDATE ON `fournisseur` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `genre`
--

CREATE TABLE `genre` (
  `id_genre` int NOT NULL,
  `nom` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `genre`
--

INSERT INTO `genre` (`id_genre`, `nom`) VALUES
(1, 'Fantastique'),
(2, 'Dystopie'),
(3, 'Classique');

--
-- DÃ©clencheurs `genre`
--
DELIMITER $$
CREATE TRIGGER `format_genre` BEFORE INSERT ON `genre` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `format_genre_update` BEFORE UPDATE ON `genre` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `historique`
--

CREATE TABLE `historique` (
  `id_historique` int NOT NULL,
  `date_action` datetime DEFAULT CURRENT_TIMESTAMP,
  `action` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `historique`
--

INSERT INTO `historique` (`id_historique`, `date_action`, `action`) VALUES
(1, '2025-10-05 11:00:00', 'Ajout du produit P001'),
(2, '2025-10-06 15:00:00', 'Modification du stock du produit P004'),
(3, '2025-10-07 16:00:00', 'Suppression d\'un utilisateur test'),
(4, '2026-01-07 08:47:06', 'Suppression utilisateur 8 (Admin Test, rÃ´le=admin)'),
(5, '2026-01-07 08:48:24', 'CrÃ©ation utilisateur 10 (Admin Test, rÃ´le=utilisateur)'),
(6, '2026-01-07 08:49:29', 'Suppression utilisateur 7 (User Test, rÃ´le=admin)'),
(7, '2026-01-07 11:11:56', 'CrÃ©ation produit  (Test)'),
(8, '2026-01-07 11:21:59', 'CrÃ©ation produit P100 (Test2)'),
(9, '2026-01-07 11:31:12', 'Modification produit P100 (Test2)'),
(10, '2026-01-07 11:31:33', 'Suppression produit P100 (Test2)'),
(11, '2026-04-08 10:27:50', 'CrÃ©ation commande 10 pour utilisateur 0'),
(12, '2026-04-08 10:27:51', 'Modification produit P6926afa423f43 (Izuku midoriya)'),
(13, '2026-04-08 11:03:25', 'CrÃ©ation utilisateur 11 (Test Codex, rÃ´le=utilisateur)'),
(14, '2026-04-08 11:04:16', 'Suppression utilisateur 11 (Test Codex, rÃ´le=utilisateur)'),
(15, '2026-04-08 11:04:16', 'CrÃ©ation utilisateur 12 (Test Codex, rÃ´le=utilisateur)'),
(20, '2026-04-08 11:09:41', 'CrÃ©ation commande 13 pour utilisateur 12'),
(21, '2026-04-08 11:09:41', 'Modification produit P004 (T-shirt coton)'),
(22, '2026-04-08 11:10:22', 'Modification produit P004 (T-shirt coton)'),
(23, '2026-04-08 11:10:22', 'Suppression commande 13 pour utilisateur 12'),
(24, '2026-04-08 11:10:22', 'Suppression utilisateur 12 (Test Codex, rÃ´le=utilisateur)'),
(25, '2026-04-08 11:15:51', 'CrÃ©ation utilisateur 13 (Test Codex, rÃ´le=utilisateur)'),
(26, '2026-04-08 11:16:51', 'Suppression utilisateur 13 (Test Codex, rÃ´le=utilisateur)'),
(27, '2026-04-08 11:18:24', 'CrÃ©ation commande 14 pour utilisateur 0'),
(28, '2026-04-08 11:18:24', 'Modification produit P001 (Harry potter Ã  l\'Ã©cole des sorciers)'),
(29, '2026-04-08 11:18:24', 'Modification produit P002 (1984)'),
(30, '2026-04-08 11:24:26', 'CrÃ©ation utilisateur 14 (Test Codex, rÃ´le=utilisateur)'),
(31, '2026-04-08 11:24:55', 'Suppression utilisateur 14 (Test Codex, rÃ´le=utilisateur)'),
(32, '2026-04-15 10:51:39', 'Modification produit P001 (Harry potter Ã  l\'Ã©cole des sorciers)'),
(33, '2026-04-15 10:53:24', 'CrÃ©ation utilisateur 15 (User Quinze, rÃ´le=utilisateur)'),
(34, '2026-05-13 22:32:16', 'Suppression produit  (Test)'),
(35, '2026-05-13 22:41:21', 'CrÃ©ation commande 15 pour utilisateur 2'),
(36, '2026-05-13 22:41:21', 'Modification produit P001 (Harry potter Ã  l\'Ã©cole des sorciers)'),
(37, '2026-05-13 22:43:49', 'Modification produit P001 (Harry potter Ã  l\'Ã©cole des sorciers)'),
(38, '2026-05-13 22:43:49', 'Suppression commande 15 pour utilisateur 2'),
(39, '2026-05-13 22:47:12', 'CrÃ©ation produit P1778705228268 (Pro)'),
(40, '2026-05-13 22:49:09', 'Suppression produit P1778705228268 (Pro)'),
(41, '2026-05-13 23:06:30', 'CrÃ©ation produit P007 (Casque audio nomade)'),
(42, '2026-05-13 23:06:30', 'CrÃ©ation produit P008 (Lampe de bureau noire)'),
(43, '2026-05-13 23:06:30', 'CrÃ©ation produit P009 (Sac a dos urbain 22l)'),
(44, '2026-05-13 23:06:30', 'CrÃ©ation produit P010 (Sweat a capuche gris)'),
(45, '2026-05-13 23:06:30', 'CrÃ©ation produit P011 (Gourde rigide 750 ml)'),
(46, '2026-05-13 23:06:30', 'CrÃ©ation produit P012 (Clavier compact sans fil)'),
(47, '2026-05-13 23:06:30', 'CrÃ©ation produit P013 (Bouilloire electrique inox 1.7 l)'),
(48, '2026-05-13 23:06:30', 'CrÃ©ation produit P014 (Ordinateur portable 13 pouces)'),
(49, '2026-05-13 23:24:38', 'Modification produit P007 (Casque audio nomade)'),
(50, '2026-05-13 23:24:38', 'Modification produit P008 (Lampe de bureau noire)'),
(51, '2026-05-13 23:24:38', 'Modification produit P009 (Sac a dos urbain 22l)'),
(52, '2026-05-13 23:24:38', 'Modification produit P010 (Sweat a capuche gris)'),
(53, '2026-05-13 23:24:38', 'Modification produit P011 (Gourde rigide 750 ml)'),
(54, '2026-05-13 23:24:38', 'Modification produit P012 (Clavier compact sans fil)'),
(55, '2026-05-13 23:24:38', 'Modification produit P013 (Bouilloire electrique inox 1.7 l)'),
(56, '2026-05-13 23:24:38', 'Modification produit P014 (Ordinateur portable 13 pouces)'),
(57, '2026-05-13 23:24:38', 'CrÃ©ation produit P015 (Souris optique usb)'),
(58, '2026-05-13 23:24:38', 'CrÃ©ation produit P016 (Cle usb 64 go)'),
(59, '2026-05-13 23:24:38', 'CrÃ©ation produit P017 (Tapis de yoga antiderapant)'),
(60, '2026-05-13 23:24:38', 'CrÃ©ation produit P018 (Mug cafe ceramique)'),
(61, '2026-05-13 23:24:38', 'CrÃ©ation produit P019 (Stylo bille bleu)'),
(62, '2026-05-13 23:24:38', 'CrÃ©ation produit P020 (Poele en fonte 26 cm)'),
(63, '2026-05-13 23:24:38', 'CrÃ©ation produit P021 (Ballon de basket indoor)'),
(64, '2026-05-13 23:24:38', 'CrÃ©ation produit P022 (Chaussures de running legeres)'),
(65, '2026-05-13 23:24:38', 'CrÃ©ation produit P023 (Appareil photo compact)'),
(66, '2026-05-13 23:24:38', 'CrÃ©ation produit P024 (Plante verte en pot)');

-- --------------------------------------------------------

--
-- Structure de la table `marque`
--

CREATE TABLE `marque` (
  `id_marque` int NOT NULL,
  `nom` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `marque`
--

INSERT INTO `marque` (`id_marque`, `nom`) VALUES
(1, 'Nike'),
(2, 'Adidas'),
(3, 'Apple');

--
-- DÃ©clencheurs `marque`
--
DELIMITER $$
CREATE TRIGGER `format_marque` BEFORE INSERT ON `marque` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `format_marque_update` BEFORE UPDATE ON `marque` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `migrations`
--

CREATE TABLE `migrations` (
  `id` bigint UNSIGNED NOT NULL,
  `version` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `class` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `group` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `namespace` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `time` int NOT NULL,
  `batch` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `migrations`
--

INSERT INTO `migrations` (`id`, `version`, `class`, `group`, `namespace`, `time`, `batch`) VALUES
(1, '2026-04-08-120000', 'App\\Database\\Migrations\\CreatePanierItemTable', 'default', 'App', 1775638937, 1),
(2, '2026-04-08-121000', 'App\\Database\\Migrations\\AddQuantiteToAppartenir', 'default', 'App', 1775639358, 2),
(3, '2026-05-13-220000', 'App\\Database\\Migrations\\HardenCommerceData', 'default', 'App', 1778704336, 3);

-- --------------------------------------------------------

--
-- Structure de la table `panier_item`
--

CREATE TABLE `panier_item` (
  `id_panier_item` int NOT NULL,
  `id_utilisateur` int NOT NULL,
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `quantite` int NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `produit`
--

CREATE TABLE `produit` (
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `nom` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `prix` decimal(10,2) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ;

--
-- DÃ©chargement des donnÃ©es de la table `produit`
--

INSERT INTO `produit` (`id_produit`, `nom`, `description`, `prix`, `stock`, `image`) VALUES
('P001', 'Harry potter Ã  l\'Ã©cole des sorciers', 'Roman fantastique pour enfants', 19.99, 44, 'no_image.jpg'),
('P002', '1984', 'Roman dystopique et politique', 14.50, 29, 'no_image.jpg'),
('P003', 'Les misÃ©rables', 'Roman classique franÃ§ais', 18.90, 25, 'no_image.jpg'),
('P004', 'T-shirt coton', 'VÃªtement doux et respirant', 24.99, 100, 'no_image.jpg'),
('P005', 'Pantalon de sport', 'VÃªtement confortable pour le sport', 39.99, 80, 'no_image.jpg'),
('P006', 'Iphone 15', 'Smartphone derniÃ¨re gÃ©nÃ©ration', 999.00, 15, 'iphone_15.jpg'),
('P007', 'Casque audio nomade', 'Casque confortable pour ecoute quotidienne avec arceau souple et son equilibre.', 79.90, 18, 'kaitlin_headphones.jpg'),
('P008', 'Lampe de bureau noire', 'Lampe orientable pour poste de travail, lecture ou table de chevet.', 34.90, 24, 'black_desk_lamp.jpg'),
('P009', 'Sac a dos urbain 22l', 'Sac polyvalent avec poche frontale, bretelles rembourrees et grand compartiment.', 49.90, 28, 'backpack.jpg'),
('P010', 'Sweat a capuche gris', 'Sweat molletonne coupe reguliere pour sorties, confort et mi-saison.', 54.90, 16, 'hoodie_man.jpg'),
('P011', 'Gourde rigide 750 ml', 'Gourde reutilisable legere pour sport, bureau ou transport quotidien.', 17.90, 35, 'polycarbonate_water_bottle.jpg'),
('P012', 'Clavier compact sans fil', 'Clavier compact pour bureau mobile avec frappe souple et connexion sans fil.', 69.90, 20, 'keyboard_compact.jpg'),
('P013', 'Bouilloire electrique inox 1.7 l', 'Bouilloire rapide avec corps inox et bec verseur large pour cuisine ou bureau.', 34.90, 14, 'electric_kettle.jpg'),
('P014', 'Ordinateur portable 13 pouces', 'Portable leger pour bureautique, navigation et cours a distance.', 899.00, 9, 'laptop_image.jpg'),
('P015', 'Souris optique usb', 'Souris filaire simple et precise pour ordinateur portable ou poste fixe.', 19.90, 32, 'computer_mice.jpg'),
('P016', 'Cle usb 64 go', 'Cle compacte pour sauvegarder documents, photos et fichiers de cours.', 12.90, 50, 'usb_flash_drive.jpg'),
('P017', 'Tapis de yoga antiderapant', 'Tapis epais et stable pour yoga, stretching ou exercices au sol.', 29.90, 21, 'yoga_mats.jpg'),
('P018', 'Mug cafe ceramique', 'Mug colore en ceramique pour cafe, the ou boisson chaude.', 9.90, 45, 'multicolored_coffee_mug.jpg'),
('P019', 'Stylo bille bleu', 'Stylo bille classique pour prise de notes, bureau ou trousse scolaire.', 2.50, 100, 'typical_ballpoint_pen.jpg'),
('P020', 'Poele en fonte 26 cm', 'Poele robuste pour cuisson quotidienne, saisie de viandes et plats maison.', 39.90, 17, 'cast_iron_pan.jpg'),
('P021', 'Ballon de basket indoor', 'Ballon de basket pour entrainement en salle et loisirs sportifs.', 24.90, 26, 'basketball_ball.jpg'),
('P022', 'Chaussures de running legeres', 'Chaussures respirantes pour course, marche active et entrainement.', 89.90, 13, 'running_shoes_display.jpg'),
('P023', 'Appareil photo compact', 'Appareil photo numerique compact pour voyages, souvenirs et sorties.', 149.90, 8, 'compact_camera.jpg'),
('P024', 'Plante verte en pot', 'Plante decorative en pot pour bureau, salon ou chambre.', 16.90, 30, 'potted_plant.jpg'),
('P6926afa423f43', 'Izuku midoriya', 'ThÃ¨me	animÃ©\r\nmarque	bandai\r\ncouleur	izuku midoriya\r\nstyle	moderne\r\nmatÃ©riau	pvc acrylonitrile butadiÃ¨ne styrÃ¨ne\r\ndimensions du produit', 124.00, 62, '1764143012_ac703ce80ec77a605a90.webp');

--
-- DÃ©clencheurs `produit`
--
DELIMITER $$
CREATE TRIGGER `format_produit` BEFORE INSERT ON `produit` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
    SET NEW.description = CONCAT(UPPER(LEFT(NEW.description, 1)), LOWER(SUBSTRING(NEW.description, 2)));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `format_produit_update` BEFORE UPDATE ON `produit` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
    SET NEW.description = CONCAT(UPPER(LEFT(NEW.description, 1)), LOWER(SUBSTRING(NEW.description, 2)));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `hist_produit_delete` AFTER DELETE ON `produit` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT('Suppression produit ', OLD.id_produit, ' (', OLD.nom, ')')
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `hist_produit_insert` AFTER INSERT ON `produit` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT('CrÃ©ation produit ', NEW.id_produit, ' (', NEW.nom, ')')
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `hist_produit_update` AFTER UPDATE ON `produit` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT('Modification produit ', NEW.id_produit, ' (', NEW.nom, ')')
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `produit_livre`
--

CREATE TABLE `produit_livre` (
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `nb_pages` int DEFAULT NULL,
  `id_auteur` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `produit_livre`
--

INSERT INTO `produit_livre` (`id_produit`, `nb_pages`, `id_auteur`) VALUES
('P001', 340, 1),
('P002', 328, 2),
('P003', 520, 3);

-- --------------------------------------------------------

--
-- Structure de la table `produit_vetement`
--

CREATE TABLE `produit_vetement` (
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `taille` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `couleur` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `matiere` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_marque` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `produit_vetement`
--

INSERT INTO `produit_vetement` (`id_produit`, `taille`, `couleur`, `matiere`, `id_marque`) VALUES
('P004', 'M', 'blanc', 'coton', 1),
('P005', 'L', 'noir', 'polyester', 2),
('P010', 'M', 'gris', 'coton melange', 2),
('P022', '42', 'bleu', 'mesh synthetique', 1);

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id_utilisateur` int NOT NULL,
  `nom` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `prenom` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mot_de_passe` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `role` enum('admin','utilisateur','superadmin','') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- DÃ©chargement des donnÃ©es de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id_utilisateur`, `nom`, `prenom`, `email`, `mot_de_passe`, `role`) VALUES
(0, 'Admin', 'Test', 'admin.test@example.com', '$2y$10$L0iqsKVWXCiXnK8J1uhA6et7QT5MLloYaWnA1DtsEJOAY44zZYEXe', 'admin'),
(1, 'Dupont', 'Jean', 'jean.dupont@example.com', '$2y$10$ejO0js/vtIfHaMcuzUqpG.scqF6P7GT3Cba10vH1.KsyLx14BvCRK', 'admin'),
(2, 'Durand', 'Marie', 'marie.durand@example.com', '$2y$10$/R7C2ShcGYBBh6u8eJ8eNO2qpHAubbeiygncWWkYl7w/pA2qkR8JO', 'utilisateur'),
(3, 'Martin', 'Lucas', 'lucas.martin@example.com', '$2y$10$i69kY5RIsw9u/184btcHl.9xKXFegtUU2gtGQSkFSb2y1lVp.kZn6', 'utilisateur'),
(4, 'Bernard', 'Lea', 'lea.bernard@example.com', '$2y$10$.m/Z8L.918/xtqA47teqbefxD0STv5..ucGxG74n2QTfJohEf9uv6', 'utilisateur'),
(9, 'User', 'Neuf', 'user9@example.com', '$2y$10$DHW2VcHD6pG519hx1naU1efvxN8cdUa5EKQ2tc4KHYp16tyJGmbrG', 'utilisateur'),
(15, 'User', 'Quinze', 'user15@example.com', '$2y$10$eGwg50ey2B/RSQ3foZoS9OdUAmhl6ftwpgKPB2mWy1kPhjET2H8g6', 'utilisateur');

--
-- DÃ©clencheurs `utilisateur`
--
DELIMITER $$
CREATE TRIGGER `format_utilisateur` BEFORE INSERT ON `utilisateur` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
    SET NEW.prenom = CONCAT(UPPER(LEFT(NEW.prenom, 1)), LOWER(SUBSTRING(NEW.prenom, 2)));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `format_utilisateur_update` BEFORE UPDATE ON `utilisateur` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
    SET NEW.prenom = CONCAT(UPPER(LEFT(NEW.prenom, 1)), LOWER(SUBSTRING(NEW.prenom, 2)));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `hist_utilisateur_delete` AFTER DELETE ON `utilisateur` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT(
            'Suppression utilisateur ', OLD.id_utilisateur,
            ' (', OLD.prenom, ' ', OLD.nom, ', rÃ´le=', OLD.role, ')'
        )
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `hist_utilisateur_insert` AFTER INSERT ON `utilisateur` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT(
            'CrÃ©ation utilisateur ', NEW.id_utilisateur,
            ' (', NEW.prenom, ' ', NEW.nom, ', rÃ´le=', NEW.role, ')'
        )
    );
END
$$
DELIMITER ;

--
-- Index pour les tables dÃ©chargÃ©es
--

--
-- Index pour la table `appartenir`
--
ALTER TABLE `appartenir`
  ADD PRIMARY KEY (`id_produit`,`id_commande`),
  ADD KEY `id_commande` (`id_commande`);

--
-- Index pour la table `auteur`
--
ALTER TABLE `auteur`
  ADD PRIMARY KEY (`id_auteur`);

--
-- Index pour la table `classer`
--
ALTER TABLE `classer`
  ADD PRIMARY KEY (`id_produit`,`id_genre`),
  ADD KEY `id_genre` (`id_genre`);

--
-- Index pour la table `commande`
--
ALTER TABLE `commande`
  ADD PRIMARY KEY (`id_commande`),
  ADD KEY `id_utilisateur` (`id_utilisateur`);

--
-- Index pour la table `consulter`
--
ALTER TABLE `consulter`
  ADD PRIMARY KEY (`id_utilisateur`,`id_produit`),
  ADD KEY `id_produit` (`id_produit`);

--
-- Index pour la table `fournir`
--
ALTER TABLE `fournir`
  ADD PRIMARY KEY (`id_produit`,`id_fournisseur`),
  ADD KEY `id_fournisseur` (`id_fournisseur`);

--
-- Index pour la table `fournisseur`
--
ALTER TABLE `fournisseur`
  ADD PRIMARY KEY (`id_fournisseur`);

--
-- Index pour la table `genre`
--
ALTER TABLE `genre`
  ADD PRIMARY KEY (`id_genre`);

--
-- Index pour la table `historique`
--
ALTER TABLE `historique`
  ADD PRIMARY KEY (`id_historique`);

--
-- Index pour la table `marque`
--
ALTER TABLE `marque`
  ADD PRIMARY KEY (`id_marque`);

--
-- Index pour la table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `panier_item`
--
ALTER TABLE `panier_item`
  ADD PRIMARY KEY (`id_panier_item`),
  ADD UNIQUE KEY `uniq_panier_utilisateur_produit` (`id_utilisateur`,`id_produit`),
  ADD KEY `id_utilisateur` (`id_utilisateur`),
  ADD KEY `id_produit` (`id_produit`);

--
-- Index pour la table `produit`
--
ALTER TABLE `produit`
  ADD PRIMARY KEY (`id_produit`);

--
-- Index pour la table `produit_livre`
--
ALTER TABLE `produit_livre`
  ADD PRIMARY KEY (`id_produit`),
  ADD KEY `id_auteur` (`id_auteur`);

--
-- Index pour la table `produit_vetement`
--
ALTER TABLE `produit_vetement`
  ADD PRIMARY KEY (`id_produit`),
  ADD KEY `id_marque` (`id_marque`);

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`id_utilisateur`);

--
-- AUTO_INCREMENT pour les tables dÃ©chargÃ©es
--

--
-- AUTO_INCREMENT pour la table `auteur`
--
ALTER TABLE `auteur`
  MODIFY `id_auteur` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `commande`
--
ALTER TABLE `commande`
  MODIFY `id_commande` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT pour la table `fournisseur`
--
ALTER TABLE `fournisseur`
  MODIFY `id_fournisseur` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `genre`
--
ALTER TABLE `genre`
  MODIFY `id_genre` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `historique`
--
ALTER TABLE `historique`
  MODIFY `id_historique` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT pour la table `marque`
--
ALTER TABLE `marque`
  MODIFY `id_marque` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `panier_item`
--
ALTER TABLE `panier_item`
  MODIFY `id_panier_item` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id_utilisateur` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Contraintes pour les tables dÃ©chargÃ©es
--

--
-- Contraintes pour la table `appartenir`
--
ALTER TABLE `appartenir`
  ADD CONSTRAINT `appartenir_ibfk_1` FOREIGN KEY (`id_produit`) REFERENCES `produit` (`id_produit`),
  ADD CONSTRAINT `appartenir_ibfk_2` FOREIGN KEY (`id_commande`) REFERENCES `commande` (`id_commande`);

--
-- Contraintes pour la table `classer`
--
ALTER TABLE `classer`
  ADD CONSTRAINT `classer_ibfk_1` FOREIGN KEY (`id_produit`) REFERENCES `produit_livre` (`id_produit`),
  ADD CONSTRAINT `classer_ibfk_2` FOREIGN KEY (`id_genre`) REFERENCES `genre` (`id_genre`);

--
-- Contraintes pour la table `commande`
--
ALTER TABLE `commande`
  ADD CONSTRAINT `commande_ibfk_1` FOREIGN KEY (`id_utilisateur`) REFERENCES `utilisateur` (`id_utilisateur`);

--
-- Contraintes pour la table `consulter`
--
ALTER TABLE `consulter`
  ADD CONSTRAINT `consulter_ibfk_1` FOREIGN KEY (`id_utilisateur`) REFERENCES `utilisateur` (`id_utilisateur`),
  ADD CONSTRAINT `consulter_ibfk_2` FOREIGN KEY (`id_produit`) REFERENCES `produit` (`id_produit`);

--
-- Contraintes pour la table `fournir`
--
ALTER TABLE `fournir`
  ADD CONSTRAINT `fournir_ibfk_1` FOREIGN KEY (`id_produit`) REFERENCES `produit` (`id_produit`),
  ADD CONSTRAINT `fournir_ibfk_2` FOREIGN KEY (`id_fournisseur`) REFERENCES `fournisseur` (`id_fournisseur`);

--
-- Contraintes pour la table `panier_item`
--
ALTER TABLE `panier_item`
  ADD CONSTRAINT `fk_panier_item_produit` FOREIGN KEY (`id_produit`) REFERENCES `produit` (`id_produit`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_panier_item_utilisateur` FOREIGN KEY (`id_utilisateur`) REFERENCES `utilisateur` (`id_utilisateur`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `produit_livre`
--
ALTER TABLE `produit_livre`
  ADD CONSTRAINT `produit_livre_ibfk_1` FOREIGN KEY (`id_produit`) REFERENCES `produit` (`id_produit`),
  ADD CONSTRAINT `produit_livre_ibfk_2` FOREIGN KEY (`id_auteur`) REFERENCES `auteur` (`id_auteur`);

--
-- Contraintes pour la table `produit_vetement`
--
ALTER TABLE `produit_vetement`
  ADD CONSTRAINT `produit_vetement_ibfk_1` FOREIGN KEY (`id_produit`) REFERENCES `produit` (`id_produit`),
  ADD CONSTRAINT `produit_vetement_ibfk_2` FOREIGN KEY (`id_marque`) REFERENCES `marque` (`id_marque`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

