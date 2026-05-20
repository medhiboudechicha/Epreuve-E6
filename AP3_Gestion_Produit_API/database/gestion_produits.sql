-- MySQL dump 10.13  Distrib 8.4.3, for Win64 (x86_64)
--
-- Host: localhost    Database: gestion_produits
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `gestion_produits`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `gestion_produits` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `gestion_produits`;

--
-- Table structure for table `appartenir`
--

DROP TABLE IF EXISTS `appartenir`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appartenir` (
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `id_commande` int NOT NULL,
  `quantite` int DEFAULT '1',
  PRIMARY KEY (`id_produit`,`id_commande`),
  KEY `id_commande` (`id_commande`),
  CONSTRAINT `appartenir_ibfk_1` FOREIGN KEY (`id_produit`) REFERENCES `produit` (`id_produit`),
  CONSTRAINT `appartenir_ibfk_2` FOREIGN KEY (`id_commande`) REFERENCES `commande` (`id_commande`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appartenir`
--

LOCK TABLES `appartenir` WRITE;
/*!40000 ALTER TABLE `appartenir` DISABLE KEYS */;
INSERT INTO `appartenir` VALUES ('P001',1,1),('P001',8,1),('P001',9,1),('P001',14,3),('P002',14,1),('P004',1,1),('P6926afa423f43',10,1);
/*!40000 ALTER TABLE `appartenir` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sync_commande_quantite_after_insert` AFTER INSERT ON `appartenir` FOR EACH ROW UPDATE commande
             SET quantite = (
                 SELECT COALESCE(SUM(quantite), 0)
                 FROM appartenir
                 WHERE id_commande = NEW.id_commande
             )
             WHERE id_commande = NEW.id_commande */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sync_commande_quantite_after_update` AFTER UPDATE ON `appartenir` FOR EACH ROW UPDATE commande
             SET quantite = (
                 SELECT COALESCE(SUM(a.quantite), 0)
                 FROM appartenir a
                 WHERE a.id_commande = commande.id_commande
             )
             WHERE id_commande IN (OLD.id_commande, NEW.id_commande) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `sync_commande_quantite_after_delete` AFTER DELETE ON `appartenir` FOR EACH ROW UPDATE commande
             SET quantite = (
                 SELECT COALESCE(SUM(quantite), 0)
                 FROM appartenir
                 WHERE id_commande = OLD.id_commande
             )
             WHERE id_commande = OLD.id_commande */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `auteur`
--

DROP TABLE IF EXISTS `auteur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auteur` (
  `id_auteur` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_auteur`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auteur`
--

LOCK TABLES `auteur` WRITE;
/*!40000 ALTER TABLE `auteur` DISABLE KEYS */;
INSERT INTO `auteur` VALUES (1,'J.k. rowling','auteure britannique cÃ©lÃ¨bre pour harry potter'),(2,'George orwell','romancier et essayiste anglais'),(3,'Victor hugo','Ã©crivain franÃ§ais du xixe siÃ¨cle');
/*!40000 ALTER TABLE `auteur` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `format_auteur` BEFORE INSERT ON `auteur` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `format_auteur_update` BEFORE UPDATE ON `auteur` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `classer`
--

DROP TABLE IF EXISTS `classer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `classer` (
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `id_genre` int NOT NULL,
  PRIMARY KEY (`id_produit`,`id_genre`),
  KEY `id_genre` (`id_genre`),
  CONSTRAINT `classer_ibfk_1` FOREIGN KEY (`id_produit`) REFERENCES `produit_livre` (`id_produit`),
  CONSTRAINT `classer_ibfk_2` FOREIGN KEY (`id_genre`) REFERENCES `genre` (`id_genre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classer`
--

LOCK TABLES `classer` WRITE;
/*!40000 ALTER TABLE `classer` DISABLE KEYS */;
INSERT INTO `classer` VALUES ('P001',1),('P002',2),('P003',3);
/*!40000 ALTER TABLE `classer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commande`
--

DROP TABLE IF EXISTS `commande`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commande` (
  `id_commande` int NOT NULL AUTO_INCREMENT,
  `date_commande` datetime DEFAULT NULL,
  `quantite` int DEFAULT NULL,
  `id_utilisateur` int NOT NULL,
  PRIMARY KEY (`id_commande`),
  KEY `id_utilisateur` (`id_utilisateur`),
  CONSTRAINT `commande_ibfk_1` FOREIGN KEY (`id_utilisateur`) REFERENCES `utilisateur` (`id_utilisateur`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commande`
--

LOCK TABLES `commande` WRITE;
/*!40000 ALTER TABLE `commande` DISABLE KEYS */;
INSERT INTO `commande` VALUES (1,'2025-10-05 10:00:00',2,1),(8,'2025-12-10 07:36:43',1,9),(9,'2025-12-10 07:37:17',1,9),(10,'2026-04-08 08:27:50',1,0),(14,'2026-04-08 09:18:24',4,0);
/*!40000 ALTER TABLE `commande` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `hist_commande_insert` AFTER INSERT ON `commande` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT(
            'CrÃ©ation commande ', NEW.id_commande,
            ' pour utilisateur ', NEW.id_utilisateur
        )
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `hist_commande_delete` AFTER DELETE ON `commande` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT(
            'Suppression commande ', OLD.id_commande,
            ' pour utilisateur ', OLD.id_utilisateur
        )
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `consulter`
--

DROP TABLE IF EXISTS `consulter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consulter` (
  `id_utilisateur` int NOT NULL,
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_utilisateur`,`id_produit`),
  KEY `id_produit` (`id_produit`),
  CONSTRAINT `consulter_ibfk_1` FOREIGN KEY (`id_utilisateur`) REFERENCES `utilisateur` (`id_utilisateur`),
  CONSTRAINT `consulter_ibfk_2` FOREIGN KEY (`id_produit`) REFERENCES `produit` (`id_produit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consulter`
--

LOCK TABLES `consulter` WRITE;
/*!40000 ALTER TABLE `consulter` DISABLE KEYS */;
INSERT INTO `consulter` VALUES (1,'P001'),(2,'P004'),(3,'P005'),(4,'P006');
/*!40000 ALTER TABLE `consulter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fournir`
--

DROP TABLE IF EXISTS `fournir`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fournir` (
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `id_fournisseur` int NOT NULL,
  PRIMARY KEY (`id_produit`,`id_fournisseur`),
  KEY `id_fournisseur` (`id_fournisseur`),
  CONSTRAINT `fournir_ibfk_1` FOREIGN KEY (`id_produit`) REFERENCES `produit` (`id_produit`),
  CONSTRAINT `fournir_ibfk_2` FOREIGN KEY (`id_fournisseur`) REFERENCES `fournisseur` (`id_fournisseur`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fournir`
--

LOCK TABLES `fournir` WRITE;
/*!40000 ALTER TABLE `fournir` DISABLE KEYS */;
INSERT INTO `fournir` VALUES ('P001',1),('P002',1),('P003',1),('P004',2),('P005',2),('P006',3);
/*!40000 ALTER TABLE `fournir` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fournisseur`
--

DROP TABLE IF EXISTS `fournisseur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fournisseur` (
  `id_fournisseur` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `adresse` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telephone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_fournisseur`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fournisseur`
--

LOCK TABLES `fournisseur` WRITE;
/*!40000 ALTER TABLE `fournisseur` DISABLE KEYS */;
INSERT INTO `fournisseur` VALUES (1,'Livreplus','12 rue du savoir, paris','contact@livreplus.fr','0123456789'),(2,'Textilpro','8 avenue du style, lyon','contact@textilpro.fr','0987654321'),(3,'Technoworld','25 rue des circuits, marseille','contact@technoworld.fr','0567891234');
/*!40000 ALTER TABLE `fournisseur` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `format_fournisseur` BEFORE INSERT ON `fournisseur` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `format_fournisseur_update` BEFORE UPDATE ON `fournisseur` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `id_genre` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_genre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES (1,'Fantastique'),(2,'Dystopie'),(3,'Classique');
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `format_genre` BEFORE INSERT ON `genre` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `format_genre_update` BEFORE UPDATE ON `genre` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `historique`
--

DROP TABLE IF EXISTS `historique`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historique` (
  `id_historique` int NOT NULL AUTO_INCREMENT,
  `date_action` datetime DEFAULT CURRENT_TIMESTAMP,
  `action` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_historique`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historique`
--

LOCK TABLES `historique` WRITE;
/*!40000 ALTER TABLE `historique` DISABLE KEYS */;
INSERT INTO `historique` VALUES (1,'2025-10-05 11:00:00','Ajout du produit P001'),(2,'2025-10-06 15:00:00','Modification du stock du produit P004'),(3,'2025-10-07 16:00:00','Suppression d\'un utilisateur test'),(4,'2026-01-07 08:47:06','Suppression utilisateur 8 (Admin Test, rÃ´le=admin)'),(5,'2026-01-07 08:48:24','CrÃ©ation utilisateur 10 (Admin Test, rÃ´le=utilisateur)'),(6,'2026-01-07 08:49:29','Suppression utilisateur 7 (User Test, rÃ´le=admin)'),(7,'2026-01-07 11:11:56','CrÃ©ation produit  (Test)'),(8,'2026-01-07 11:21:59','CrÃ©ation produit P100 (Test2)'),(9,'2026-01-07 11:31:12','Modification produit P100 (Test2)'),(10,'2026-01-07 11:31:33','Suppression produit P100 (Test2)'),(11,'2026-04-08 10:27:50','CrÃ©ation commande 10 pour utilisateur 0'),(12,'2026-04-08 10:27:51','Modification produit P6926afa423f43 (Izuku midoriya)'),(13,'2026-04-08 11:03:25','CrÃ©ation utilisateur 11 (Test Codex, rÃ´le=utilisateur)'),(14,'2026-04-08 11:04:16','Suppression utilisateur 11 (Test Codex, rÃ´le=utilisateur)'),(15,'2026-04-08 11:04:16','CrÃ©ation utilisateur 12 (Test Codex, rÃ´le=utilisateur)'),(20,'2026-04-08 11:09:41','CrÃ©ation commande 13 pour utilisateur 12'),(21,'2026-04-08 11:09:41','Modification produit P004 (T-shirt coton)'),(22,'2026-04-08 11:10:22','Modification produit P004 (T-shirt coton)'),(23,'2026-04-08 11:10:22','Suppression commande 13 pour utilisateur 12'),(24,'2026-04-08 11:10:22','Suppression utilisateur 12 (Test Codex, rÃ´le=utilisateur)'),(25,'2026-04-08 11:15:51','CrÃ©ation utilisateur 13 (Test Codex, rÃ´le=utilisateur)'),(26,'2026-04-08 11:16:51','Suppression utilisateur 13 (Test Codex, rÃ´le=utilisateur)'),(27,'2026-04-08 11:18:24','CrÃ©ation commande 14 pour utilisateur 0'),(28,'2026-04-08 11:18:24','Modification produit P001 (Harry potter Ã  l\'Ã©cole des sorciers)'),(29,'2026-04-08 11:18:24','Modification produit P002 (1984)'),(30,'2026-04-08 11:24:26','CrÃ©ation utilisateur 14 (Test Codex, rÃ´le=utilisateur)'),(31,'2026-04-08 11:24:55','Suppression utilisateur 14 (Test Codex, rÃ´le=utilisateur)'),(32,'2026-04-15 10:51:39','Modification produit P001 (Harry potter Ã  l\'Ã©cole des sorciers)'),(33,'2026-04-15 10:53:24','CrÃ©ation utilisateur 15 (User Quinze, rÃ´le=utilisateur)'),(34,'2026-05-13 22:32:16','Suppression produit  (Test)'),(35,'2026-05-13 22:41:21','CrÃ©ation commande 15 pour utilisateur 2'),(36,'2026-05-13 22:41:21','Modification produit P001 (Harry potter Ã  l\'Ã©cole des sorciers)'),(37,'2026-05-13 22:43:49','Modification produit P001 (Harry potter Ã  l\'Ã©cole des sorciers)'),(38,'2026-05-13 22:43:49','Suppression commande 15 pour utilisateur 2'),(39,'2026-05-13 22:47:12','CrÃ©ation produit P1778705228268 (Pro)'),(40,'2026-05-13 22:49:09','Suppression produit P1778705228268 (Pro)'),(41,'2026-05-13 23:06:30','CrÃ©ation produit P007 (Casque audio nomade)'),(42,'2026-05-13 23:06:30','CrÃ©ation produit P008 (Lampe de bureau noire)'),(43,'2026-05-13 23:06:30','CrÃ©ation produit P009 (Sac a dos urbain 22l)'),(44,'2026-05-13 23:06:30','CrÃ©ation produit P010 (Sweat a capuche gris)'),(45,'2026-05-13 23:06:30','CrÃ©ation produit P011 (Gourde rigide 750 ml)'),(46,'2026-05-13 23:06:30','CrÃ©ation produit P012 (Clavier compact sans fil)'),(47,'2026-05-13 23:06:30','CrÃ©ation produit P013 (Bouilloire electrique inox 1.7 l)'),(48,'2026-05-13 23:06:30','CrÃ©ation produit P014 (Ordinateur portable 13 pouces)'),(49,'2026-05-13 23:24:38','Modification produit P007 (Casque audio nomade)'),(50,'2026-05-13 23:24:38','Modification produit P008 (Lampe de bureau noire)'),(51,'2026-05-13 23:24:38','Modification produit P009 (Sac a dos urbain 22l)'),(52,'2026-05-13 23:24:38','Modification produit P010 (Sweat a capuche gris)'),(53,'2026-05-13 23:24:38','Modification produit P011 (Gourde rigide 750 ml)'),(54,'2026-05-13 23:24:38','Modification produit P012 (Clavier compact sans fil)'),(55,'2026-05-13 23:24:38','Modification produit P013 (Bouilloire electrique inox 1.7 l)'),(56,'2026-05-13 23:24:38','Modification produit P014 (Ordinateur portable 13 pouces)'),(57,'2026-05-13 23:24:38','CrÃ©ation produit P015 (Souris optique usb)'),(58,'2026-05-13 23:24:38','CrÃ©ation produit P016 (Cle usb 64 go)'),(59,'2026-05-13 23:24:38','CrÃ©ation produit P017 (Tapis de yoga antiderapant)'),(60,'2026-05-13 23:24:38','CrÃ©ation produit P018 (Mug cafe ceramique)'),(61,'2026-05-13 23:24:38','CrÃ©ation produit P019 (Stylo bille bleu)'),(62,'2026-05-13 23:24:38','CrÃ©ation produit P020 (Poele en fonte 26 cm)'),(63,'2026-05-13 23:24:38','CrÃ©ation produit P021 (Ballon de basket indoor)'),(64,'2026-05-13 23:24:38','CrÃ©ation produit P022 (Chaussures de running legeres)'),(65,'2026-05-13 23:24:38','CrÃ©ation produit P023 (Appareil photo compact)'),(66,'2026-05-13 23:24:38','CrÃ©ation produit P024 (Plante verte en pot)');
/*!40000 ALTER TABLE `historique` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marque`
--

DROP TABLE IF EXISTS `marque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marque` (
  `id_marque` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_marque`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marque`
--

LOCK TABLES `marque` WRITE;
/*!40000 ALTER TABLE `marque` DISABLE KEYS */;
INSERT INTO `marque` VALUES (1,'Nike'),(2,'Adidas'),(3,'Apple');
/*!40000 ALTER TABLE `marque` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `format_marque` BEFORE INSERT ON `marque` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `format_marque_update` BEFORE UPDATE ON `marque` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `version` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `class` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `group` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `namespace` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `time` int NOT NULL,
  `batch` int unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2026-04-08-120000','App\\Database\\Migrations\\CreatePanierItemTable','default','App',1775638937,1),(2,'2026-04-08-121000','App\\Database\\Migrations\\AddQuantiteToAppartenir','default','App',1775639358,2),(3,'2026-05-13-220000','App\\Database\\Migrations\\HardenCommerceData','default','App',1778704336,3);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `panier_item`
--

DROP TABLE IF EXISTS `panier_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `panier_item` (
  `id_panier_item` int NOT NULL AUTO_INCREMENT,
  `id_utilisateur` int NOT NULL,
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `quantite` int NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id_panier_item`),
  UNIQUE KEY `uniq_panier_utilisateur_produit` (`id_utilisateur`,`id_produit`),
  KEY `id_utilisateur` (`id_utilisateur`),
  KEY `id_produit` (`id_produit`),
  CONSTRAINT `fk_panier_item_produit` FOREIGN KEY (`id_produit`) REFERENCES `produit` (`id_produit`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_panier_item_utilisateur` FOREIGN KEY (`id_utilisateur`) REFERENCES `utilisateur` (`id_utilisateur`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `panier_item`
--

LOCK TABLES `panier_item` WRITE;
/*!40000 ALTER TABLE `panier_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `panier_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produit`
--

DROP TABLE IF EXISTS `produit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produit` (
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `nom` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `prix` decimal(10,2) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_produit`),
  CONSTRAINT `chk_produit_id_non_vide` CHECK ((char_length(trim(`id_produit`)) > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produit`
--

LOCK TABLES `produit` WRITE;
/*!40000 ALTER TABLE `produit` DISABLE KEYS */;
INSERT INTO `produit` VALUES ('P001','Harry potter Ã  l\'Ã©cole des sorciers','Roman fantastique pour enfants',19.99,44,'no_image.jpg'),('P002','1984','Roman dystopique et politique',14.50,29,'no_image.jpg'),('P003','Les misÃ©rables','Roman classique franÃ§ais',18.90,25,'no_image.jpg'),('P004','T-shirt coton','VÃªtement doux et respirant',24.99,100,'no_image.jpg'),('P005','Pantalon de sport','VÃªtement confortable pour le sport',39.99,80,'no_image.jpg'),('P006','Iphone 15','Smartphone derniÃ¨re gÃ©nÃ©ration',999.00,15,'iphone_15.jpg'),('P007','Casque audio nomade','Casque confortable pour ecoute quotidienne avec arceau souple et son equilibre.',79.90,18,'kaitlin_headphones.jpg'),('P008','Lampe de bureau noire','Lampe orientable pour poste de travail, lecture ou table de chevet.',34.90,24,'black_desk_lamp.jpg'),('P009','Sac a dos urbain 22l','Sac polyvalent avec poche frontale, bretelles rembourrees et grand compartiment.',49.90,28,'backpack.jpg'),('P010','Sweat a capuche gris','Sweat molletonne coupe reguliere pour sorties, confort et mi-saison.',54.90,16,'hoodie_man.jpg'),('P011','Gourde rigide 750 ml','Gourde reutilisable legere pour sport, bureau ou transport quotidien.',17.90,35,'polycarbonate_water_bottle.jpg'),('P012','Clavier compact sans fil','Clavier compact pour bureau mobile avec frappe souple et connexion sans fil.',69.90,20,'keyboard_compact.jpg'),('P013','Bouilloire electrique inox 1.7 l','Bouilloire rapide avec corps inox et bec verseur large pour cuisine ou bureau.',34.90,14,'electric_kettle.jpg'),('P014','Ordinateur portable 13 pouces','Portable leger pour bureautique, navigation et cours a distance.',899.00,9,'laptop_image.jpg'),('P015','Souris optique usb','Souris filaire simple et precise pour ordinateur portable ou poste fixe.',19.90,32,'computer_mice.jpg'),('P016','Cle usb 64 go','Cle compacte pour sauvegarder documents, photos et fichiers de cours.',12.90,50,'usb_flash_drive.jpg'),('P017','Tapis de yoga antiderapant','Tapis epais et stable pour yoga, stretching ou exercices au sol.',29.90,21,'yoga_mats.jpg'),('P018','Mug cafe ceramique','Mug colore en ceramique pour cafe, the ou boisson chaude.',9.90,45,'multicolored_coffee_mug.jpg'),('P019','Stylo bille bleu','Stylo bille classique pour prise de notes, bureau ou trousse scolaire.',2.50,100,'typical_ballpoint_pen.jpg'),('P020','Poele en fonte 26 cm','Poele robuste pour cuisson quotidienne, saisie de viandes et plats maison.',39.90,17,'cast_iron_pan.jpg'),('P021','Ballon de basket indoor','Ballon de basket pour entrainement en salle et loisirs sportifs.',24.90,26,'basketball_ball.jpg'),('P022','Chaussures de running legeres','Chaussures respirantes pour course, marche active et entrainement.',89.90,13,'running_shoes_display.jpg'),('P023','Appareil photo compact','Appareil photo numerique compact pour voyages, souvenirs et sorties.',149.90,8,'compact_camera.jpg'),('P024','Plante verte en pot','Plante decorative en pot pour bureau, salon ou chambre.',16.90,30,'potted_plant.jpg'),('P6926afa423f43','Izuku midoriya','ThÃ¨me	animÃ©\r\nmarque	bandai\r\ncouleur	izuku midoriya\r\nstyle	moderne\r\nmatÃ©riau	pvc acrylonitrile butadiÃ¨ne styrÃ¨ne\r\ndimensions du produit',124.00,62,'1764143012_ac703ce80ec77a605a90.webp');
/*!40000 ALTER TABLE `produit` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `format_produit` BEFORE INSERT ON `produit` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
    SET NEW.description = CONCAT(UPPER(LEFT(NEW.description, 1)), LOWER(SUBSTRING(NEW.description, 2)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `hist_produit_insert` AFTER INSERT ON `produit` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT('CrÃ©ation produit ', NEW.id_produit, ' (', NEW.nom, ')')
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `format_produit_update` BEFORE UPDATE ON `produit` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
    SET NEW.description = CONCAT(UPPER(LEFT(NEW.description, 1)), LOWER(SUBSTRING(NEW.description, 2)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `hist_produit_update` AFTER UPDATE ON `produit` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT('Modification produit ', NEW.id_produit, ' (', NEW.nom, ')')
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `hist_produit_delete` AFTER DELETE ON `produit` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT('Suppression produit ', OLD.id_produit, ' (', OLD.nom, ')')
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `produit_livre`
--

DROP TABLE IF EXISTS `produit_livre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produit_livre` (
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `nb_pages` int DEFAULT NULL,
  `id_auteur` int DEFAULT NULL,
  PRIMARY KEY (`id_produit`),
  KEY `id_auteur` (`id_auteur`),
  CONSTRAINT `produit_livre_ibfk_1` FOREIGN KEY (`id_produit`) REFERENCES `produit` (`id_produit`),
  CONSTRAINT `produit_livre_ibfk_2` FOREIGN KEY (`id_auteur`) REFERENCES `auteur` (`id_auteur`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produit_livre`
--

LOCK TABLES `produit_livre` WRITE;
/*!40000 ALTER TABLE `produit_livre` DISABLE KEYS */;
INSERT INTO `produit_livre` VALUES ('P001',340,1),('P002',328,2),('P003',520,3);
/*!40000 ALTER TABLE `produit_livre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produit_vetement`
--

DROP TABLE IF EXISTS `produit_vetement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produit_vetement` (
  `id_produit` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `taille` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `couleur` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `matiere` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_marque` int DEFAULT NULL,
  PRIMARY KEY (`id_produit`),
  KEY `id_marque` (`id_marque`),
  CONSTRAINT `produit_vetement_ibfk_1` FOREIGN KEY (`id_produit`) REFERENCES `produit` (`id_produit`),
  CONSTRAINT `produit_vetement_ibfk_2` FOREIGN KEY (`id_marque`) REFERENCES `marque` (`id_marque`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produit_vetement`
--

LOCK TABLES `produit_vetement` WRITE;
/*!40000 ALTER TABLE `produit_vetement` DISABLE KEYS */;
INSERT INTO `produit_vetement` VALUES ('P004','M','blanc','coton',1),('P005','L','noir','polyester',2),('P010','M','gris','coton melange',2),('P022','42','bleu','mesh synthetique',1);
/*!40000 ALTER TABLE `produit_vetement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilisateur`
--

DROP TABLE IF EXISTS `utilisateur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilisateur` (
  `id_utilisateur` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `prenom` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mot_de_passe` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `role` enum('admin','utilisateur','superadmin','') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_utilisateur`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilisateur`
--

LOCK TABLES `utilisateur` WRITE;
/*!40000 ALTER TABLE `utilisateur` DISABLE KEYS */;
INSERT INTO `utilisateur` VALUES (0,'Admin','Test','admin.test@example.com','$2y$10$L0iqsKVWXCiXnK8J1uhA6et7QT5MLloYaWnA1DtsEJOAY44zZYEXe','admin'),(1,'Dupont','Jean','jean.dupont@example.com','$2y$10$ejO0js/vtIfHaMcuzUqpG.scqF6P7GT3Cba10vH1.KsyLx14BvCRK','admin'),(2,'Durand','Marie','marie.durand@example.com','$2y$10$/R7C2ShcGYBBh6u8eJ8eNO2qpHAubbeiygncWWkYl7w/pA2qkR8JO','utilisateur'),(3,'Martin','Lucas','lucas.martin@example.com','$2y$10$i69kY5RIsw9u/184btcHl.9xKXFegtUU2gtGQSkFSb2y1lVp.kZn6','utilisateur'),(4,'Bernard','Lea','lea.bernard@example.com','$2y$10$.m/Z8L.918/xtqA47teqbefxD0STv5..ucGxG74n2QTfJohEf9uv6','utilisateur'),(9,'User','Neuf','user9@example.com','$2y$10$DHW2VcHD6pG519hx1naU1efvxN8cdUa5EKQ2tc4KHYp16tyJGmbrG','utilisateur'),(15,'User','Quinze','user15@example.com','$2y$10$eGwg50ey2B/RSQ3foZoS9OdUAmhl6ftwpgKPB2mWy1kPhjET2H8g6','utilisateur');
/*!40000 ALTER TABLE `utilisateur` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `format_utilisateur` BEFORE INSERT ON `utilisateur` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
    SET NEW.prenom = CONCAT(UPPER(LEFT(NEW.prenom, 1)), LOWER(SUBSTRING(NEW.prenom, 2)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `hist_utilisateur_insert` AFTER INSERT ON `utilisateur` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT(
            'CrÃ©ation utilisateur ', NEW.id_utilisateur,
            ' (', NEW.prenom, ' ', NEW.nom, ', rÃ´le=', NEW.role, ')'
        )
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `format_utilisateur_update` BEFORE UPDATE ON `utilisateur` FOR EACH ROW BEGIN
    SET NEW.nom = CONCAT(UPPER(LEFT(NEW.nom, 1)), LOWER(SUBSTRING(NEW.nom, 2)));
    SET NEW.prenom = CONCAT(UPPER(LEFT(NEW.prenom, 1)), LOWER(SUBSTRING(NEW.prenom, 2)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `hist_utilisateur_delete` AFTER DELETE ON `utilisateur` FOR EACH ROW BEGIN
    INSERT INTO historique(date_action, action)
    VALUES (
        NOW(),
        CONCAT(
            'Suppression utilisateur ', OLD.id_utilisateur,
            ' (', OLD.prenom, ' ', OLD.nom, ', rÃ´le=', OLD.role, ')'
        )
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'gestion_produits'
--

--
-- Dumping routines for database 'gestion_produits'
--
/*!50003 DROP PROCEDURE IF EXISTS `ps_historique_par_mot_cle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_historique_par_mot_cle`(IN `p_texte` VARCHAR(100))
BEGIN
    SELECT id_historique, date_action, action
    FROM historique
    WHERE action LIKE CONCAT('%', p_texte, '%')
    ORDER BY date_action DESC, id_historique DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_liste_historique` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_liste_historique`()
BEGIN
    SELECT id_historique, date_action, action
    FROM historique
    ORDER BY date_action DESC, id_historique DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ps_nb_commandes_utilisateur` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps_nb_commandes_utilisateur`(
    IN  p_id_utilisateur INT,
    OUT p_nb_commandes   INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_nb_commandes
    FROM commande
    WHERE id_utilisateur = p_id_utilisateur;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_produit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_produit`(
 IN p_id_produit VARCHAR(50),
 IN p_nom VARCHAR(100),
 IN p_description VARCHAR(255),
 IN p_prix VARCHAR(50),
 IN p_stock VARCHAR(50),
 IN p_image VARCHAR(255)
)
BEGIN
 INSERT INTO produit (id_produit, nom, description, prix, stock, image)
 VALUES (p_id_produit, p_nom, p_description, p_prix, p_stock, p_image);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_produit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_produit`(
 IN p_id_produit VARCHAR(50)
)
BEGIN
 DELETE FROM produit
 WHERE id_produit = p_id_produit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_all_produits` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_produits`()
BEGIN
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_produit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_produit`(
 IN p_id_produit VARCHAR(50)
)
BEGIN
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_produit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_produit`(
 IN p_id_produit VARCHAR(50),
 IN p_nom VARCHAR(100),
 IN p_description VARCHAR(255),
 IN p_prix VARCHAR(50),
 IN p_stock VARCHAR(50),
 IN p_image VARCHAR(255)
)
BEGIN
 UPDATE produit
 SET nom = p_nom,
     description = p_description,
     prix = p_prix,
     stock = p_stock,
     image = p_image
 WHERE id_produit = p_id_produit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-20 22:13:16

