-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : ven. 11 déc. 2020 à 15:24
-- Version du serveur :  8.0.21
-- Version de PHP : 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `delivreouquentin`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `commandes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `commandes` ()  NO SQL
BEGIN
	SET @max = 60 + RAND() * 60;
    SET @i = 0;
    
    WHILE @i < @max DO
		
		SET @montantTemp = ROUND(8 + RAND() * 62,2);
		SET @consigneTemp = CONV(FLOOR(RAND() * 99999999999999), 20, 36);
		SET @dateCommandeTemp = NOW() - INTERVAL RAND() * 21780 MINUTE;
		SET @datePreparationTermineeTemp = @dateCommandeTemp + INTERVAL 5 + RAND() * 30 MINUTE;
		SET @dateLivraisonEstimeeTemp = @datePreparationTermineeTemp + INTERVAL 5 + RAND() * 20 MINUTE;
		SET @dateLivraisonReelleTemp = @dateLivraisonEstimeeTemp + INTERVAL 5 + RAND() * 20 MINUTE;
		SET @idIndividuCoursierTemp = (SELECT idIndividu FROM coursier ORDER BY RAND() LIMIT 1);
		SET @idIndividuClientTemp = (SELECT idIndividu FROM client ORDER BY RAND() LIMIT 1);
		SET @idRestaurantTemp = (SELECT idRestaurant FROM restaurant ORDER BY RAND() LIMIT 1);
		SET @idAdresseTemp = (SELECT idAdresse FROM adresse ORDER BY RAND() LIMIT 1);
		
		INSERT INTO commande (montant, consigne, dateCommande, datePreparationTerminee, dateLivraisonEstimee, dateLivraisonReelle,
							  idIndividuCoursier, idIndividuClient, idRestaurant, idAdresse)
		VALUES (@montantTemp, @consigneTemp, @dateCommandeTemp, @datePreparationTermineeTemp, @dateLivraisonEstimeeTemp, @dateLivraisonReelleTemp,
				@idIndividuCoursierTemp, @idIndividuClientTemp, @idRestaurantTemp, @idAdresseTemp);
		
		SET @i = @i + 1;
	END WHILE;
	
	SELECT CONCAT(@i, ' commandes ajoutées') AS Resultat;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `adresse`
--

DROP TABLE IF EXISTS `adresse`;
CREATE TABLE IF NOT EXISTS `adresse` (
  `idAdresse` int NOT NULL AUTO_INCREMENT,
  `ligne1` varchar(50) NOT NULL,
  `ligne2` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ligne3` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `codePostal` varchar(5) NOT NULL,
  `commune` varchar(45) NOT NULL,
  PRIMARY KEY (`idAdresse`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `adresse`
--

INSERT INTO `adresse` (`idAdresse`, `ligne1`, `ligne2`, `ligne3`, `codePostal`, `commune`) VALUES
(1, '3 Rue Pré-Gaudry', '', '', '69007', 'Lyon'),
(2, '4 Rue Professeur Pierre Marion', '', '', '69005', 'Lyon'),
(3, '106 Cours Gambetta', '', '', '69007', 'Lyon'),
(4, 'Maison de la Danse', '8 avenue Jean Mermoz', '', '69008', 'Lyon'),
(5, 'Les Chemins', '7 Avenue des Frères Lumière', '', '69120', 'Vaulx-en-Velin'),
(6, '103 Grande Rue de la Croix-Rousse', '', '', '69004', 'Lyon'),
(7, '50 Avenue du Loup Pendu', '', '', '69140', 'Rillieux-la-Pape'),
(8, '12 Place d\'Arménie', '', '', '01700', 'Saint-Maurice-de-Beynost'),
(9, '4 Rue du Plâtre', '', '', '69720', 'Saint-Bonnet-de-Mure'),
(10, '93 Avenue François Mitterrand', '', '', '69500', 'Bron'),
(11, 'Batiment B', '79 Rue Magenta', '', '69100', 'Villeurbanne'),
(12, '118 Rue Gabriel Péri', '', '', '69200', 'Vénissieux'),
(13, '5 Rue des Anciennes Tanneries', '', '', '69600', 'Oullins'),
(14, '58 Rue Sainte-Geneviève', '', '', '69006', 'Lyon'),
(15, 'Lotissement Grandpierre', '18 Route d\'Écully', '', '69570', 'Dardilly'),
(16, '18 Rue Paul Painlevé', '', '', '69300', 'Caluire-et-Cuire'),
(17, '12 Chemin de la Grange', '', '', '69680', 'Chassieu'),
(18, '23 Rue Jacques Reynaud', '', '', '69800', 'Saint-Priest'),
(19, '21 Impasse de la Pomme', '', '', '69160', 'Tassin-la-Demi-Lune'),
(20, 'Rue du Stade', '', '', '69450', 'Saint-Cyr-au-Mont-d\'Or'),
(21, '25 Rue Henri Pensier', '', '', '69008', 'Lyon'),
(22, '4Bis Cours Bayard', '', '', '69268', 'Lyon'),
(23, '37 Rue Vendôme', '', '', '69006', 'Lyon'),
(24, '23 Rue Président Krüger', '', '', '69008', 'Lyon'),
(25, '278 Rue Garibaldi', '', '', '69003', 'Lyon');

-- --------------------------------------------------------

--
-- Structure de la table `bloquer`
--

DROP TABLE IF EXISTS `bloquer`;
CREATE TABLE IF NOT EXISTS `bloquer` (
  `idIndividuClient` int NOT NULL,
  `idIndividuCoursier` int NOT NULL,
  `motif` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idIndividuClient`,`idIndividuCoursier`),
  KEY `Bloquer_Coursier_1_FK` (`idIndividuCoursier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `client`
--

DROP TABLE IF EXISTS `client`;
CREATE TABLE IF NOT EXISTS `client` (
  `idIndividu` int NOT NULL,
  PRIMARY KEY (`idIndividu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `client`
--

INSERT INTO `client` (`idIndividu`) VALUES
(2),
(4),
(5),
(6),
(8),
(10),
(12),
(14),
(15),
(16),
(18),
(20);

-- --------------------------------------------------------

--
-- Structure de la table `commande`
--

DROP TABLE IF EXISTS `commande`;
CREATE TABLE IF NOT EXISTS `commande` (
  `idCommande` int NOT NULL AUTO_INCREMENT,
  `consigne` varchar(200) NOT NULL,
  `dateCommande` datetime NOT NULL,
  `datePreparationTerminee` datetime NOT NULL,
  `dateLivraisonEstimee` datetime NOT NULL,
  `dateLivraisonReelle` datetime NOT NULL,
  `idIndividuCoursier` int NOT NULL,
  `idRestaurant` int NOT NULL,
  `idAdresse` int NOT NULL,
  `idIndividuClient` int NOT NULL,
  `montant` decimal(10,2) UNSIGNED NOT NULL,
  PRIMARY KEY (`idCommande`),
  KEY `Commande_Coursier_FK` (`idIndividuCoursier`),
  KEY `Commande_Restaurant_FK` (`idRestaurant`),
  KEY `Commande_Adresse_FK` (`idAdresse`),
  KEY `Commande_Client_1_FK` (`idIndividuClient`)
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `commande`
--

INSERT INTO `commande` (`idCommande`, `consigne`, `dateCommande`, `datePreparationTerminee`, `dateLivraisonEstimee`, `dateLivraisonReelle`, `idIndividuCoursier`, `idRestaurant`, `idAdresse`, `idIndividuClient`, `montant`) VALUES
(2, '369ZT0VBU0CU', '2020-12-04 12:55:27', '2020-12-04 13:23:27', '2020-12-04 13:38:27', '2020-12-04 13:30:27', 19, 7, 15, 8, '52.10'),
(3, '2IRJP0M8H208', '2020-12-09 18:29:27', '2020-12-09 18:45:27', '2020-12-09 19:00:27', '2020-12-09 18:59:27', 7, 12, 12, 14, '68.60'),
(4, '3DE9BMG5GHDL', '2020-12-10 09:39:27', '2020-12-10 10:03:27', '2020-12-10 10:27:27', '2020-12-10 10:25:27', 7, 7, 21, 16, '67.05'),
(6, '24NK5SEKZ5VS', '2020-12-04 13:14:27', '2020-12-04 13:24:27', '2020-12-04 13:38:27', '2020-12-04 13:43:27', 9, 7, 24, 10, '59.21'),
(7, '4GLO0T0YJF3K', '2020-12-04 20:11:27', '2020-12-04 20:17:27', '2020-12-04 20:38:27', '2020-12-04 20:39:27', 19, 11, 21, 10, '54.27'),
(8, '3482P693RDK3', '2020-12-05 16:43:27', '2020-12-05 17:01:27', '2020-12-05 17:07:27', '2020-12-05 17:24:27', 11, 7, 23, 20, '10.66'),
(9, '3B5F4M5T9PHN', '2020-12-05 07:24:27', '2020-12-05 07:40:27', '2020-12-05 07:58:27', '2020-12-05 07:48:27', 11, 12, 3, 15, '16.67'),
(10, '5V0RDWOSCKJT', '2020-12-06 12:32:27', '2020-12-06 12:59:27', '2020-12-06 13:16:27', '2020-12-06 13:20:27', 17, 10, 7, 6, '20.42'),
(11, '1VBXJE073MSP', '2020-12-01 05:19:27', '2020-12-01 05:40:27', '2020-12-01 05:57:27', '2020-12-01 05:51:27', 19, 9, 8, 12, '45.69'),
(12, '563RMU5HFG40', '2020-12-07 12:55:27', '2020-12-07 13:23:27', '2020-12-07 13:48:27', '2020-12-07 13:41:27', 11, 9, 25, 16, '50.26'),
(13, '4LEBRJ00ZHF', '2020-11-30 09:29:27', '2020-11-30 09:51:27', '2020-11-30 10:10:27', '2020-11-30 10:09:27', 19, 9, 21, 15, '59.02'),
(14, '4CYI1BKWB3FS', '2020-12-06 04:34:27', '2020-12-06 05:00:27', '2020-12-06 05:12:27', '2020-12-06 05:19:27', 3, 8, 19, 6, '31.82'),
(15, '203FKVKL39DA', '2020-12-07 03:10:27', '2020-12-07 03:28:27', '2020-12-07 03:39:27', '2020-12-07 03:38:27', 7, 11, 18, 18, '58.42'),
(16, '1C8HQ7RC28XF', '2020-12-04 01:58:27', '2020-12-04 02:27:27', '2020-12-04 02:42:27', '2020-12-04 02:33:27', 7, 10, 22, 2, '21.61'),
(17, 'SD3AS8LHN6F', '2020-12-10 14:57:27', '2020-12-10 15:28:27', '2020-12-10 15:35:27', '2020-12-10 15:50:27', 1, 10, 24, 6, '43.51'),
(18, '1DSX3T7MZQKE', '2020-11-30 18:18:27', '2020-11-30 18:48:27', '2020-11-30 18:54:27', '2020-11-30 19:07:27', 17, 11, 17, 5, '60.26'),
(19, '1YVC4G8Y85JB', '2020-11-29 01:55:27', '2020-11-29 02:04:27', '2020-11-29 02:13:27', '2020-11-29 02:21:27', 19, 9, 9, 20, '25.54'),
(20, '2M9YW1FLMHG6', '2020-11-30 16:30:27', '2020-11-30 16:43:27', '2020-11-30 16:53:27', '2020-11-30 16:55:27', 13, 10, 10, 2, '18.20'),
(21, '37OOHJ4X4UTJ', '2020-12-09 07:20:27', '2020-12-09 07:30:27', '2020-12-09 07:41:27', '2020-12-09 07:38:27', 7, 12, 14, 16, '60.19'),
(22, '3BY84CBT2WE2', '2020-12-10 09:47:27', '2020-12-10 10:12:27', '2020-12-10 10:20:27', '2020-12-10 10:34:27', 13, 11, 3, 6, '44.77'),
(23, '238U7HDTS18D', '2020-12-08 20:59:27', '2020-12-08 21:28:27', '2020-12-08 21:41:27', '2020-12-08 21:44:27', 3, 9, 16, 16, '42.87'),
(24, 'WUFI8UAWLBF', '2020-12-04 03:22:27', '2020-12-04 03:53:27', '2020-12-04 04:16:27', '2020-12-04 04:17:27', 3, 8, 20, 12, '18.12'),
(25, '4L7FIBJV1F5A', '2020-12-07 01:49:27', '2020-12-07 01:59:27', '2020-12-07 02:22:27', '2020-12-07 02:05:27', 3, 12, 22, 20, '41.04'),
(26, '3XA25IR9Q4H2', '2020-11-30 17:26:27', '2020-11-30 17:49:27', '2020-11-30 18:12:27', '2020-11-30 18:07:27', 11, 11, 12, 4, '20.24'),
(27, '1FW8EH691N84', '2020-12-06 11:16:27', '2020-12-06 11:48:27', '2020-12-06 12:03:27', '2020-12-06 12:07:27', 11, 9, 14, 8, '49.22'),
(28, 'A36NOT46NNW', '2020-12-02 19:22:27', '2020-12-02 19:46:27', '2020-12-02 20:00:27', '2020-12-02 19:58:27', 13, 9, 14, 18, '46.62'),
(29, 'PSJEAUWEX07', '2020-12-03 13:19:27', '2020-12-03 13:32:27', '2020-12-03 13:52:27', '2020-12-03 13:56:27', 9, 9, 21, 5, '31.19'),
(30, '2KE48W74FUTN', '2020-11-28 07:55:27', '2020-11-28 08:03:27', '2020-11-28 08:25:27', '2020-11-28 08:09:27', 11, 8, 19, 6, '13.61'),
(31, 'SB9OJILBMMK', '2020-11-28 02:20:28', '2020-11-28 02:55:28', '2020-11-28 03:06:28', '2020-11-28 03:12:28', 1, 7, 8, 2, '67.65'),
(32, '1J6JKDAQCZ55', '2020-12-09 19:21:28', '2020-12-09 19:47:28', '2020-12-09 19:56:28', '2020-12-09 20:09:28', 9, 8, 25, 10, '56.71'),
(33, 'VNCPUK80Y4A', '2020-12-05 19:23:28', '2020-12-05 19:39:28', '2020-12-05 19:57:28', '2020-12-05 19:49:28', 7, 11, 15, 8, '60.52'),
(34, '1YXKN3HTBH8B', '2020-12-04 06:45:28', '2020-12-04 07:02:28', '2020-12-04 07:19:28', '2020-12-04 07:23:28', 9, 11, 22, 4, '53.44'),
(35, '5RFI21IZQ6D8', '2020-11-28 07:43:28', '2020-11-28 08:04:28', '2020-11-28 08:10:28', '2020-11-28 08:20:28', 19, 12, 16, 10, '67.68'),
(36, '1J6PUQMRS0X8', '2020-12-02 19:40:28', '2020-12-02 19:46:28', '2020-12-02 19:58:28', '2020-12-02 20:05:28', 13, 9, 8, 15, '26.52'),
(38, 'OU67GNM27QG', '2020-12-01 20:46:28', '2020-12-01 21:17:28', '2020-12-01 21:28:28', '2020-12-01 21:23:28', 13, 8, 15, 20, '28.15'),
(39, 'NXEVI3JF853', '2020-12-10 06:10:28', '2020-12-10 06:18:28', '2020-12-10 06:27:28', '2020-12-10 06:38:28', 1, 9, 8, 16, '18.28'),
(40, '5SDXYCFZ3H7G', '2020-12-08 12:08:28', '2020-12-08 12:17:28', '2020-12-08 12:24:28', '2020-12-08 12:24:28', 3, 9, 24, 18, '41.00'),
(41, '215XZSSQYBDX', '2020-12-11 00:32:28', '2020-12-11 00:41:28', '2020-12-11 00:56:28', '2020-12-11 00:50:28', 19, 8, 14, 12, '44.02'),
(42, 'URWQJGZ5D3R', '2020-12-03 01:37:28', '2020-12-03 01:51:28', '2020-12-03 02:11:28', '2020-12-03 02:12:28', 11, 12, 19, 4, '56.24'),
(44, 'UBH8T1QAJ99', '2020-12-08 18:25:28', '2020-12-08 18:43:28', '2020-12-08 18:59:28', '2020-12-08 18:59:28', 1, 11, 22, 10, '42.51'),
(45, '25J09N7AEMHJ', '2020-12-07 12:00:28', '2020-12-07 12:10:28', '2020-12-07 12:16:28', '2020-12-07 12:31:28', 11, 8, 2, 15, '63.77'),
(46, '3YACNK3Z7EKU', '2020-12-02 15:49:28', '2020-12-02 16:22:28', '2020-12-02 16:46:28', '2020-12-02 16:47:28', 1, 10, 10, 8, '65.04'),
(47, '1ENOI7LDXPYJ', '2020-11-29 11:34:28', '2020-11-29 11:46:28', '2020-11-29 12:07:28', '2020-11-29 11:58:28', 13, 11, 20, 20, '38.42'),
(48, '2123VQUVU84L', '2020-12-01 13:47:28', '2020-12-01 14:00:28', '2020-12-01 14:11:28', '2020-12-01 14:18:28', 11, 12, 12, 8, '51.59'),
(49, '4F7TLOJT3ETN', '2020-11-30 01:18:28', '2020-11-30 01:43:28', '2020-11-30 02:07:28', '2020-11-30 02:06:28', 7, 8, 3, 15, '46.23'),
(50, '2PR2XAJKOIE2', '2020-12-05 06:35:28', '2020-12-05 07:00:28', '2020-12-05 07:07:28', '2020-12-05 07:14:28', 13, 12, 15, 18, '48.45'),
(51, '569R3038Y2BL', '2020-12-02 11:34:28', '2020-12-02 11:52:28', '2020-12-02 12:03:28', '2020-12-02 12:01:28', 11, 12, 22, 2, '22.99'),
(52, '53X8Y63KRKM4', '2020-12-03 04:58:28', '2020-12-03 05:10:28', '2020-12-03 05:26:28', '2020-12-03 05:17:28', 13, 10, 25, 2, '42.39'),
(53, '59EJD81WU5HW', '2020-12-08 00:46:28', '2020-12-08 01:06:28', '2020-12-08 01:28:28', '2020-12-08 01:24:28', 13, 11, 9, 15, '33.24'),
(54, '555AUBJZR6DX', '2020-12-07 14:43:28', '2020-12-07 15:11:28', '2020-12-07 15:36:28', '2020-12-07 15:29:28', 13, 7, 11, 15, '28.95'),
(55, 'WQIADZ3OEMW', '2020-12-04 21:06:28', '2020-12-04 21:30:28', '2020-12-04 21:52:28', '2020-12-04 21:44:28', 7, 11, 15, 10, '18.94'),
(56, '25DHV6YR7IHB', '2020-12-05 20:42:28', '2020-12-05 21:09:28', '2020-12-05 21:24:28', '2020-12-05 21:19:28', 17, 10, 20, 14, '61.29'),
(57, '58M17ZDRX3DG', '2020-11-28 14:14:28', '2020-11-28 14:38:28', '2020-11-28 14:56:28', '2020-11-28 14:47:28', 13, 7, 25, 5, '19.91'),
(59, '4JQYVU739N9', '2020-12-01 12:55:28', '2020-12-01 13:06:28', '2020-12-01 13:12:28', '2020-12-01 13:22:28', 7, 11, 21, 18, '39.85'),
(60, '3W9N3E733255', '2020-11-28 18:27:28', '2020-11-28 18:40:28', '2020-11-28 19:02:28', '2020-11-28 18:55:28', 7, 10, 2, 2, '58.06'),
(61, '234833139A0O', '2020-12-09 01:54:28', '2020-12-09 02:21:28', '2020-12-09 02:28:28', '2020-12-09 02:34:28', 9, 7, 12, 18, '42.88'),
(62, '2OU9VNSXMPX', '2020-12-04 19:52:28', '2020-12-04 20:02:28', '2020-12-04 20:16:28', '2020-12-04 20:22:28', 11, 7, 9, 12, '22.30'),
(63, '546Y060GR9BF', '2020-12-11 12:02:24', '2020-12-11 12:22:24', '2020-12-11 12:37:24', '2020-12-11 13:01:24', 17, 12, 23, 18, '33.48'),
(64, '3D3WW98QTF6O', '2020-12-01 16:07:24', '2020-12-01 16:29:24', '2020-12-01 16:50:24', '2020-12-01 17:00:24', 7, 8, 16, 20, '33.86'),
(65, '2L65I0AABUJH', '2020-11-30 18:13:24', '2020-11-30 18:27:24', '2020-11-30 18:39:24', '2020-11-30 19:00:24', 17, 9, 11, 8, '37.93'),
(66, '4KVHXOKDQ96H', '2020-12-03 05:05:24', '2020-12-03 05:24:24', '2020-12-03 05:42:24', '2020-12-03 06:06:24', 17, 9, 7, 5, '35.09'),
(67, '5TWWEER7RB3T', '2020-12-05 21:14:24', '2020-12-05 21:48:24', '2020-12-05 22:07:24', '2020-12-05 22:26:24', 17, 12, 7, 5, '18.50'),
(68, '3U3II7YJF469', '2020-12-05 10:38:24', '2020-12-05 10:47:24', '2020-12-05 11:02:24', '2020-12-05 11:08:24', 11, 10, 20, 10, '44.54'),
(69, '2S5TFKSA1WMA', '2020-12-08 01:48:24', '2020-12-08 02:14:24', '2020-12-08 02:34:24', '2020-12-08 02:51:24', 9, 9, 10, 5, '54.60'),
(70, '96UDYTS6VBE', '2020-11-29 07:55:24', '2020-11-29 08:25:24', '2020-11-29 08:43:24', '2020-11-29 09:05:24', 7, 10, 6, 8, '41.19'),
(71, '3DEDA2QA56GG', '2020-12-01 10:52:24', '2020-12-01 11:15:24', '2020-12-01 11:20:24', '2020-12-01 11:31:24', 1, 12, 4, 18, '34.11'),
(72, '4XI2A737JJ8', '2020-12-02 18:07:24', '2020-12-02 18:36:24', '2020-12-02 18:45:24', '2020-12-02 19:04:24', 3, 12, 25, 10, '42.15'),
(73, 'OZDM0AWK2AI', '2020-11-30 15:02:24', '2020-11-30 15:15:24', '2020-11-30 15:23:24', '2020-11-30 15:47:24', 7, 10, 12, 4, '47.29'),
(74, '3QG89081S7YR', '2020-11-28 08:10:24', '2020-11-28 08:33:24', '2020-11-28 08:45:24', '2020-11-28 09:09:24', 3, 11, 12, 15, '51.87'),
(75, '4JSE8LVWAZZ', '2020-12-08 03:04:24', '2020-12-08 03:10:24', '2020-12-08 03:25:24', '2020-12-08 03:38:24', 19, 7, 14, 16, '28.14'),
(76, '5OCO0JRO6OMB', '2020-12-06 10:23:24', '2020-12-06 10:56:24', '2020-12-06 11:14:24', '2020-12-06 11:29:24', 19, 9, 8, 8, '14.13'),
(77, '25RVP68OZQ0M', '2020-12-07 19:47:24', '2020-12-07 19:54:24', '2020-12-07 20:11:24', '2020-12-07 20:30:24', 11, 10, 9, 12, '23.33'),
(78, '64GDRN447JF', '2020-11-30 00:56:24', '2020-11-30 01:21:24', '2020-11-30 01:46:24', '2020-11-30 01:51:24', 1, 11, 17, 14, '39.63'),
(79, 'GKE6BLTO3H', '2020-12-02 18:22:24', '2020-12-02 18:54:24', '2020-12-02 19:15:24', '2020-12-02 19:25:24', 17, 11, 16, 18, '17.40'),
(80, '2QLUVXM3G63G', '2020-12-07 21:12:24', '2020-12-07 21:41:24', '2020-12-07 21:51:24', '2020-12-07 22:15:24', 11, 11, 2, 20, '11.20'),
(81, '203SMEO82SK6', '2020-12-01 16:22:24', '2020-12-01 16:35:24', '2020-12-01 16:46:24', '2020-12-01 17:05:24', 9, 12, 7, 8, '30.28'),
(82, '5PU0EJST76C', '2020-12-03 07:36:24', '2020-12-03 07:59:24', '2020-12-03 08:11:24', '2020-12-03 08:34:24', 7, 7, 12, 14, '22.67'),
(83, '3BYCHRRCBGT1', '2020-12-02 23:13:24', '2020-12-02 23:23:24', '2020-12-02 23:29:24', '2020-12-02 23:50:24', 17, 7, 19, 16, '13.90'),
(84, '647ZB525N4B', '2020-11-30 05:08:24', '2020-11-30 05:31:24', '2020-11-30 05:51:24', '2020-11-30 06:14:24', 3, 7, 25, 2, '39.85'),
(85, '2PX1E0ZLQ2VP', '2020-11-28 02:04:24', '2020-11-28 02:11:24', '2020-11-28 02:27:24', '2020-11-28 02:45:24', 17, 12, 16, 18, '38.87'),
(86, '1A4124TWJCQP', '2020-11-29 02:16:24', '2020-11-29 02:36:24', '2020-11-29 02:42:24', '2020-11-29 03:03:24', 13, 9, 14, 8, '54.23'),
(87, '2NQP2AKEYDYI', '2020-12-03 18:40:24', '2020-12-03 18:52:24', '2020-12-03 19:08:24', '2020-12-03 19:16:24', 17, 8, 9, 8, '44.72'),
(88, '3HY1BMVW0TK', '2020-12-04 21:51:24', '2020-12-04 22:00:24', '2020-12-04 22:11:24', '2020-12-04 22:19:24', 3, 7, 10, 10, '43.52'),
(89, 'UHQ6K7Q48YK', '2020-12-06 23:00:24', '2020-12-06 23:06:24', '2020-12-06 23:15:24', '2020-12-06 23:39:24', 1, 10, 4, 16, '40.31'),
(90, '59FZ9LVXE1YU', '2020-12-08 13:08:24', '2020-12-08 13:24:24', '2020-12-08 13:32:24', '2020-12-08 13:49:24', 13, 7, 4, 20, '33.94'),
(91, '3XIF0VX7FE1P', '2020-12-07 11:38:24', '2020-12-07 11:54:24', '2020-12-07 12:00:24', '2020-12-07 12:09:24', 11, 10, 2, 18, '9.19'),
(92, 'D163B4ACUK', '2020-12-10 08:27:24', '2020-12-10 08:44:24', '2020-12-10 09:05:24', '2020-12-10 09:24:24', 7, 7, 3, 20, '27.61'),
(93, '4ED79OYRZ9J9', '2020-12-09 00:14:24', '2020-12-09 00:41:24', '2020-12-09 00:48:24', '2020-12-09 00:58:24', 9, 7, 11, 20, '37.19'),
(94, '2LC2K381CT1V', '2020-11-27 20:33:24', '2020-11-27 20:46:24', '2020-11-27 21:01:24', '2020-11-27 21:23:24', 19, 12, 7, 12, '34.26'),
(95, '5PBCMCIGV40A', '2020-12-08 05:55:24', '2020-12-08 06:10:24', '2020-12-08 06:33:24', '2020-12-08 06:51:24', 13, 8, 25, 15, '38.04'),
(96, '3RQORY6C7KMD', '2020-12-10 04:15:24', '2020-12-10 04:39:24', '2020-12-10 05:03:24', '2020-12-10 05:23:24', 13, 10, 20, 5, '28.06'),
(97, '2RRWVLLZ7AIS', '2020-11-30 10:44:24', '2020-11-30 10:56:24', '2020-11-30 11:20:24', '2020-11-30 11:44:24', 11, 9, 18, 15, '22.81'),
(98, '36NVA4HVY4ZC', '2020-12-11 12:00:24', '2020-12-11 12:19:24', '2020-12-11 12:30:24', '2020-12-11 12:38:24', 3, 12, 15, 18, '20.92'),
(99, '1B2FOYO260WU', '2020-11-27 02:39:24', '2020-11-27 02:48:24', '2020-11-27 03:10:24', '2020-11-27 03:31:24', 19, 8, 25, 5, '10.92'),
(100, '5W4NKT781GP9', '2020-12-06 07:32:24', '2020-12-06 08:00:24', '2020-12-06 08:21:24', '2020-12-06 08:41:24', 1, 8, 24, 8, '21.06'),
(101, '5OEE401SBWI5', '2020-11-29 05:49:24', '2020-11-29 06:03:24', '2020-11-29 06:10:24', '2020-11-29 06:28:24', 7, 7, 14, 20, '25.05'),
(102, '4FBZD9TG5ETM', '2020-12-05 21:21:24', '2020-12-05 21:48:24', '2020-12-05 22:03:24', '2020-12-05 22:15:24', 3, 10, 15, 12, '54.37'),
(103, '50DT3WVWWIU4', '2020-12-06 12:04:24', '2020-12-06 12:17:24', '2020-12-06 12:29:24', '2020-12-06 12:51:24', 11, 12, 18, 8, '43.39'),
(104, '4MBC1PJW55KA', '2020-11-28 18:38:24', '2020-11-28 19:10:24', '2020-11-28 19:33:24', '2020-11-28 19:54:24', 19, 9, 22, 5, '30.63'),
(105, '5SRO6A4REJ2O', '2020-11-27 04:42:24', '2020-11-27 05:13:24', '2020-11-27 05:28:24', '2020-11-27 05:53:24', 19, 11, 3, 18, '67.51'),
(106, '1YX6PAV2IKJM', '2020-12-10 07:55:24', '2020-12-10 08:13:24', '2020-12-10 08:36:24', '2020-12-10 08:43:24', 19, 7, 25, 20, '40.94'),
(107, '544WHSWZ98IX', '2020-12-10 09:28:24', '2020-12-10 09:59:24', '2020-12-10 10:06:24', '2020-12-10 10:30:24', 11, 7, 11, 5, '31.86'),
(108, '2S8CJFFB8NPT', '2020-12-09 18:56:24', '2020-12-09 19:04:24', '2020-12-09 19:13:24', '2020-12-09 19:32:24', 11, 9, 1, 2, '15.77'),
(109, '3QQPR3J3XTKJ', '2020-12-09 03:36:24', '2020-12-09 03:41:24', '2020-12-09 03:57:24', '2020-12-09 04:16:24', 19, 8, 2, 8, '46.53'),
(110, '3B026TDWFQ0T', '2020-12-03 06:36:24', '2020-12-03 06:43:24', '2020-12-03 07:02:24', '2020-12-03 07:14:24', 9, 12, 14, 6, '54.93'),
(111, 'WOHEICBA1SZ', '2020-12-03 04:19:24', '2020-12-03 04:31:24', '2020-12-03 04:44:24', '2020-12-03 04:57:24', 7, 9, 17, 12, '16.46'),
(112, '2022XZDI66BW', '2020-11-26 23:00:24', '2020-11-26 23:30:24', '2020-11-26 23:38:24', '2020-11-26 23:51:24', 13, 11, 21, 5, '44.43'),
(113, 'Q1QG8UE7C42', '2020-12-01 11:59:24', '2020-12-01 12:33:24', '2020-12-01 12:53:24', '2020-12-01 13:15:24', 1, 9, 2, 8, '8.09'),
(114, '2PJ4WC36UQIC', '2020-12-08 05:54:24', '2020-12-08 06:20:24', '2020-12-08 06:43:24', '2020-12-08 06:54:24', 11, 9, 5, 10, '10.72'),
(115, '53YN320T55H7', '2020-12-10 16:08:24', '2020-12-10 16:37:24', '2020-12-10 16:57:24', '2020-12-10 17:11:24', 3, 10, 18, 6, '31.91'),
(116, 'R8VGDGFJ70B', '2020-11-29 08:00:24', '2020-11-29 08:24:24', '2020-11-29 08:43:24', '2020-11-29 09:02:24', 17, 8, 13, 18, '27.01'),
(117, '5RBKIJDMVRSC', '2020-11-28 18:17:24', '2020-11-28 18:34:24', '2020-11-28 18:49:24', '2020-11-28 18:57:24', 13, 9, 1, 8, '26.70'),
(118, '52S05RHUDVID', '2020-12-02 21:51:24', '2020-12-02 22:08:24', '2020-12-02 22:17:24', '2020-12-02 22:40:24', 3, 9, 16, 16, '20.14'),
(119, '2I2LNODQ7B72', '2020-12-08 05:38:24', '2020-12-08 06:10:24', '2020-12-08 06:32:24', '2020-12-08 06:48:24', 17, 11, 17, 8, '45.49'),
(120, '2PNHAELIITO6', '2020-11-26 23:23:24', '2020-11-26 23:41:24', '2020-11-26 23:51:24', '2020-11-27 00:15:24', 19, 9, 16, 18, '36.89'),
(121, '1AFTWX99DHJU', '2020-11-27 18:20:24', '2020-11-27 18:53:24', '2020-11-27 19:16:24', '2020-11-27 19:36:24', 1, 9, 6, 6, '11.67'),
(122, '1WV5BVZZBGR5', '2020-12-08 19:28:24', '2020-12-08 20:02:24', '2020-12-08 20:14:24', '2020-12-08 20:34:24', 9, 12, 24, 18, '57.83'),
(123, '2OOLFHI4CXXF', '2020-11-29 10:55:24', '2020-11-29 11:19:24', '2020-11-29 11:39:24', '2020-11-29 12:01:24', 7, 12, 6, 8, '60.16'),
(124, 'VS33W0M2OK4', '2020-11-30 13:07:24', '2020-11-30 13:15:24', '2020-11-30 13:27:24', '2020-11-30 13:39:24', 17, 12, 3, 16, '53.55'),
(125, '2HVGUF9AN809', '2020-12-05 01:26:24', '2020-12-05 02:00:24', '2020-12-05 02:15:24', '2020-12-05 02:34:24', 13, 8, 12, 20, '61.50'),
(126, '579TNUF0OQ9Y', '2020-12-07 02:31:24', '2020-12-07 03:02:24', '2020-12-07 03:17:24', '2020-12-07 03:40:24', 11, 9, 2, 18, '30.05'),
(127, '2QLC7N2RU79C', '2020-11-30 12:09:24', '2020-11-30 12:21:24', '2020-11-30 12:26:24', '2020-11-30 12:37:24', 7, 8, 23, 18, '42.40'),
(128, '5M4FAMQIR19P', '2020-11-27 10:46:24', '2020-11-27 11:20:24', '2020-11-27 11:26:24', '2020-11-27 11:36:24', 1, 10, 9, 8, '41.17'),
(129, '1IOMR3RGNIK', '2020-12-06 01:04:24', '2020-12-06 01:33:24', '2020-12-06 01:56:24', '2020-12-06 02:03:24', 13, 10, 9, 2, '64.12'),
(130, '3XE63AXYT5MX', '2020-12-02 07:44:24', '2020-12-02 07:52:24', '2020-12-02 08:09:24', '2020-12-02 08:29:24', 11, 8, 9, 2, '43.24'),
(131, '3YOGGIKY2EUU', '2020-11-27 11:21:24', '2020-11-27 11:46:24', '2020-11-27 12:00:24', '2020-11-27 12:12:24', 19, 8, 23, 15, '17.28'),
(132, '14U4WTRHQFR', '2020-11-29 06:10:24', '2020-11-29 06:17:24', '2020-11-29 06:39:24', '2020-11-29 06:47:24', 17, 8, 20, 5, '12.82'),
(133, '1EXSFN21K9CJ', '2020-11-30 16:28:24', '2020-11-30 16:58:24', '2020-11-30 17:04:24', '2020-11-30 17:24:24', 17, 7, 19, 10, '40.53'),
(134, '18TJOQAXAVPX', '2020-12-05 13:44:24', '2020-12-05 14:01:24', '2020-12-05 14:23:24', '2020-12-05 14:47:24', 11, 7, 4, 16, '20.39'),
(135, '2METHY3UK98D', '2020-12-11 04:45:24', '2020-12-11 05:14:24', '2020-12-11 05:38:24', '2020-12-11 05:51:24', 1, 7, 11, 14, '53.46'),
(136, 'MUR0MR8L0ZC', '2020-12-09 14:08:24', '2020-12-09 14:24:24', '2020-12-09 14:37:24', '2020-12-09 14:59:24', 11, 11, 20, 16, '16.34'),
(137, '1921K2HV3UEN', '2020-12-02 09:42:24', '2020-12-02 10:00:24', '2020-12-02 10:13:24', '2020-12-02 10:29:24', 13, 8, 14, 15, '16.52'),
(138, '52SAL1GKTBLK', '2020-11-29 10:16:24', '2020-11-29 10:37:24', '2020-11-29 10:48:24', '2020-11-29 11:09:24', 1, 10, 2, 16, '36.07'),
(139, '1J2OCG8326MK', '2020-12-11 10:48:24', '2020-12-11 10:59:24', '2020-12-11 11:22:24', '2020-12-11 11:45:24', 9, 12, 22, 4, '38.04'),
(140, '5M20IL8LQ0QG', '2020-12-06 20:40:24', '2020-12-06 21:11:24', '2020-12-06 21:23:24', '2020-12-06 21:32:24', 9, 8, 4, 15, '33.22'),
(141, '3YCC6POP4DJX', '2020-12-04 03:05:24', '2020-12-04 03:24:24', '2020-12-04 03:46:24', '2020-12-04 04:10:24', 1, 11, 23, 14, '46.42'),
(142, '21BZJLFOIVJU', '2020-11-27 01:51:24', '2020-11-27 02:18:24', '2020-11-27 02:39:24', '2020-11-27 03:01:24', 3, 10, 9, 16, '45.89'),
(143, '1EHESEI4NVYL', '2020-11-30 13:31:24', '2020-11-30 14:03:24', '2020-11-30 14:15:24', '2020-11-30 14:21:24', 13, 12, 14, 8, '39.50'),
(144, '1ETTFHWA6G7T', '2020-12-03 22:07:24', '2020-12-03 22:35:24', '2020-12-03 22:48:24', '2020-12-03 23:04:24', 3, 8, 2, 4, '44.74'),
(145, '152T2P14KYE', '2020-12-02 14:44:24', '2020-12-02 15:18:24', '2020-12-02 15:43:24', '2020-12-02 15:49:24', 1, 12, 14, 15, '38.10'),
(146, '52OH4JFW3MFZ', '2020-12-01 23:43:24', '2020-12-02 00:09:24', '2020-12-02 00:26:24', '2020-12-02 00:47:24', 11, 8, 15, 8, '18.72'),
(147, '3QMP3756WGBO', '2020-12-05 11:16:24', '2020-12-05 11:28:24', '2020-12-05 11:52:24', '2020-12-05 12:16:24', 1, 12, 19, 14, '20.63'),
(148, '3T50272X61Q3', '2020-12-05 04:23:24', '2020-12-05 04:36:24', '2020-12-05 05:01:24', '2020-12-05 05:09:24', 9, 8, 12, 10, '64.11'),
(149, '3ZWMBLFN9LPB', '2020-12-05 08:28:24', '2020-12-05 08:33:24', '2020-12-05 08:55:24', '2020-12-05 09:02:24', 19, 8, 1, 18, '8.60'),
(150, '5690KZWN7ZW0', '2020-12-09 08:56:24', '2020-12-09 09:06:24', '2020-12-09 09:18:24', '2020-12-09 09:28:24', 7, 8, 3, 5, '32.27'),
(151, '3X9TT7YUISWF', '2020-12-04 08:22:24', '2020-12-04 08:40:24', '2020-12-04 08:59:24', '2020-12-04 09:08:24', 11, 7, 17, 6, '25.11'),
(152, '1DP7URVSH3M1', '2020-12-06 05:31:24', '2020-12-06 05:37:24', '2020-12-06 05:45:24', '2020-12-06 06:04:24', 1, 8, 7, 2, '67.51'),
(153, '9FI0U8QETDU', '2020-12-04 01:54:24', '2020-12-04 02:06:24', '2020-12-04 02:25:24', '2020-12-04 02:44:24', 13, 12, 25, 20, '48.15'),
(154, '2EYJQUZ450J', '2020-12-03 23:47:24', '2020-12-04 00:06:24', '2020-12-04 00:27:24', '2020-12-04 00:44:24', 17, 7, 15, 2, '61.94'),
(155, 'S6D8N58VHKJ', '2020-11-30 01:56:24', '2020-11-30 02:12:24', '2020-11-30 02:28:24', '2020-11-30 02:45:24', 9, 7, 5, 14, '28.68'),
(156, '34JY15EMPFHP', '2020-11-28 06:03:24', '2020-11-28 06:35:24', '2020-11-28 06:57:24', '2020-11-28 07:12:24', 1, 9, 11, 16, '42.36'),
(157, '2L9R1N314MYH', '2020-12-07 09:49:25', '2020-12-07 09:57:25', '2020-12-07 10:15:25', '2020-12-07 10:38:25', 19, 9, 16, 15, '47.17'),
(158, '3AR3THWSLNYW', '2020-12-02 01:26:25', '2020-12-02 01:46:25', '2020-12-02 02:02:25', '2020-12-02 02:13:25', 17, 11, 4, 12, '11.43'),
(159, '193B5LE635H', '2020-12-09 22:07:25', '2020-12-09 22:28:25', '2020-12-09 22:40:25', '2020-12-09 22:46:25', 9, 12, 2, 8, '27.62'),
(160, 'VPRTY0RFGQP', '2020-12-04 18:17:25', '2020-12-04 18:44:25', '2020-12-04 18:54:25', '2020-12-04 19:18:25', 3, 10, 1, 4, '59.18'),
(161, 'WQEW7IROXOV', '2020-12-04 20:21:25', '2020-12-04 20:46:25', '2020-12-04 21:10:25', '2020-12-04 21:33:25', 9, 9, 22, 20, '18.83'),
(162, '6UKA83KAIHU', '2020-11-27 20:26:25', '2020-11-27 20:42:25', '2020-11-27 20:50:25', '2020-11-27 21:06:25', 3, 7, 18, 16, '57.61'),
(163, '193YPF3LELJ2', '2020-12-03 07:52:25', '2020-12-03 08:01:25', '2020-12-03 08:06:25', '2020-12-03 08:25:25', 9, 11, 3, 10, '38.55'),
(164, '23KD1G16DUYP', '2020-12-10 07:09:25', '2020-12-10 07:23:25', '2020-12-10 07:34:25', '2020-12-10 07:49:25', 13, 12, 24, 12, '24.66'),
(165, '2QXU2TCCF9OI', '2020-12-08 08:29:25', '2020-12-08 08:53:25', '2020-12-08 09:08:25', '2020-12-08 09:25:25', 13, 10, 7, 20, '12.44'),
(166, '3T13EBJGY0T2', '2020-12-10 05:12:25', '2020-12-10 05:35:25', '2020-12-10 05:54:25', '2020-12-10 06:12:25', 7, 11, 17, 18, '8.79'),
(167, '3C1WGAU5Y0ES', '2020-12-01 01:55:25', '2020-12-01 02:23:25', '2020-12-01 02:44:25', '2020-12-01 03:00:25', 17, 9, 22, 14, '52.82');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `comretard`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `comretard`;
CREATE TABLE IF NOT EXISTS `comretard` (
`Coursier` varchar(101)
,`dateCommande` datetime
,`dateLivraisonEstimee` datetime
,`dateLivraisonReelle` datetime
,`idCommande` int
,`Retard` varchar(2)
);

-- --------------------------------------------------------

--
-- Structure de la table `coursier`
--

DROP TABLE IF EXISTS `coursier`;
CREATE TABLE IF NOT EXISTS `coursier` (
  `idIndividu` int NOT NULL,
  `numeroSiret` varchar(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`idIndividu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `coursier`
--

INSERT INTO `coursier` (`idIndividu`, `numeroSiret`) VALUES
(1, '42865712300045'),
(3, '77532412900012'),
(7, '18963745600178'),
(9, '35004795600041'),
(11, '47398615800033'),
(13, '44297338300078'),
(17, '21750698100270'),
(19, '11796352100025');

--
-- Déclencheurs `coursier`
--
DROP TRIGGER IF EXISTS `siretInsert`;
DELIMITER $$
CREATE TRIGGER `siretInsert` BEFORE INSERT ON `coursier` FOR EACH ROW BEGIN
IF (LENGTH(new.numeroSiret) != 16)
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Numero de siret doit avoir 14 caractères';
END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `siretUpdate`;
DELIMITER $$
CREATE TRIGGER `siretUpdate` BEFORE UPDATE ON `coursier` FOR EACH ROW BEGIN
IF (LENGTH(new.numeroSiret) != 16)
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Numero de siret doit avoir 14 caractères';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `individu`
--

DROP TABLE IF EXISTS `individu`;
CREATE TABLE IF NOT EXISTS `individu` (
  `idIndividu` int NOT NULL AUTO_INCREMENT,
  `prenom` varchar(50) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `telephonePortable` varchar(10) NOT NULL,
  `adresseMail` varchar(50) NOT NULL,
  `motDePasse` varchar(64) NOT NULL,
  PRIMARY KEY (`idIndividu`),
  UNIQUE KEY `adresseMail` (`adresseMail`),
  KEY `prenom` (`prenom`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `individu`
--

INSERT INTO `individu` (`idIndividu`, `prenom`, `nom`, `telephonePortable`, `adresseMail`, `motDePasse`) VALUES
(1, 'Adeline', 'Alpha', '0435887445', 'a.alpha@gmail.com', 'b64478e0ab377aef04ffe5fc78e5a812eee3264cf3c5e1d37feccba671d59943'),
(2, 'Boris', 'Bravo', '0573720666', 'b.bravo@hotmail.com', 'e179fdee9e10b074bcd64daf85fd1267939d6f2f5d9eb75645c3ce1640f1cb46'),
(3, 'Carole', 'Charlie', '0747705860', 'c.charlie@laposte.net', '50568e9073984cf19ab9ebfdda6007dc67bf802a8fd934c64d27fea4e2dec4b8'),
(4, 'Daniel', 'Delta', '0712925546', 'd.delta@yahoo.fr', '4431ad8a35f2a6665a9c4181a85f619907d88a681d3929a6b9c68503ce849a66'),
(5, 'Édouard', 'Echo', '0586232852', 'e.echo@gmail.com', '29dd5403838903ade27969772a740cc6cfb85c8038532fe3504823577e7baca8'),
(6, 'Fanny', 'Foxtrot', '0592094475', 'f.foxtrot@outlook.com', '591e73d8aa19ea4592803f6c8dfe358bf699cb34d342f5c8ca6ba73c9354b212'),
(7, 'Gérard', 'Golf', '0443699569', 'g.golf@gmail.com', '83c3a3a3e2e1171501584c25d1b42da88b3b6726cbeba422ff90787aad62b4e0'),
(8, 'Hubert', 'Hotel', '0371441742', 'h.hotel@orange.fr', '524f9f7f8decbe448c8b8356ec89967e36934bc9e9fcf753a0bc0cf184e0ce5a'),
(9, 'Isabelle', 'India', '0334097176', 'i.india@gmail.com', '66404642f1ff9470273dcec736d7f2c9a7ecff0eb25ded1f9628b95af0253299'),
(10, 'Jacques', 'Juliet', '0274870863', 'j.juliet@laposte.net', '007c0eeae0eabefca803c344bcaa2b5a200c0a49a91dc5cf727aba758e750609'),
(11, 'Kévin', 'Kilo', '0185672024', 'k.kilo@gmail.com', '7cee0ad391cf5a88b100b39c7e00466febb09be5f8cf80d7bd01603b96c801f5'),
(12, 'Laurent', 'Lima', '0423930878', 'l.lima@free.com', '68ba71becf6b1514e6601fb69d2cb73991ab3768ce80ad4e2242b37420adf0b0'),
(13, 'Maéva', 'Mike', '0153638684', 'm.mike@yahoo.fr', 'e33d3637eba560276eee24cfc8ef80060db085cf39ea095feed4e1085e492481'),
(14, 'Nicolas', 'November', '0573757284', 'n.november@gmail.com', '8a634de4237eb732051ff156453849c0ba44701520065cc839ff20176e9def2d'),
(15, 'Olivier', 'Oscar', '0488640459', 'o.oscar@laposte.net', 'd82d68b90684998d0f48fc4e31f09a7d521863a61a753a75b9986c09fbfc4269'),
(16, 'Patrick', 'Papa', '0690353368', 'p.papa@orange.fr', '343e8193a39a0148bedbda718cbf135ea211f3693aa8fafc00602057e72fd65d'),
(17, 'Quentin', 'Quebec', '0388950067', 'q.quebec@gmail.com', '2151732002ef987484a34a4e6c836ad1f6de7c74aa18ab5bae85539d9b9c7629'),
(18, 'Rémi', 'Romeo', '0546871156', 'r.romeo@hotmail.com', '651e35f02d9e701cb2e3ca617f44247aa515ccb05f70ff954c1b77db4a36181a'),
(19, 'Sophie', 'Sierra', '0660001564', 's.sierra@yahoo.fr', '3e08ed1b24629895c0a908282721d7717c72ec1a8cee29747a0d4737c669c2a9'),
(20, 'Tiphaine', 'Tango', '0688189531', 't.tango@outlook.com', '20c54ad494defe76f09ef40a00a882c8546d5f74d1b394b8acdb3a8ec8f5c807'),
(21, 'quentin', 'falvard', '0666666666', 'toto@yopmail.com', '969ba23724b8af4924300ce97f8084d1a30a7271a903d44f14f87d54349bb646'),
(22, 'rasta', 'tocket', '0666666668', 'rasta@yopmail.com', 'f707fb17144d84db7a72fe9cc934e5af6d36d9da6cea6ee5be200b3273da6192');

--
-- Déclencheurs `individu`
--
DROP TRIGGER IF EXISTS `mailInsert`;
DELIMITER $$
CREATE TRIGGER `mailInsert` BEFORE INSERT ON `individu` FOR EACH ROW BEGIN
    IF (new.adresseMail NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+.[A-Z]{2,63}$')
    THEN
        SIGNAL SQLSTATE '45000'
 		SET MESSAGE_TEXT = 'L'adresse e-mail n'est pas sous la forme aa@aa.aa';
    END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `mailUpdate`;
DELIMITER $$
CREATE TRIGGER `mailUpdate` BEFORE UPDATE ON `individu` FOR EACH ROW BEGIN
    IF (new.adresseMail NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+.[A-Z]{2,63}$')
    THEN
        SIGNAL SQLSTATE '45000'
 		SET MESSAGE_TEXT = 'L'adresse e-mail n'est pas sous la forme aa@aa.aa';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `restaurant`
--

DROP TABLE IF EXISTS `restaurant`;
CREATE TABLE IF NOT EXISTS `restaurant` (
  `idRestaurant` int NOT NULL AUTO_INCREMENT,
  `raisonSociale` varchar(50) NOT NULL,
  `delaiHabituel` int NOT NULL,
  `idAdresse` int NOT NULL,
  PRIMARY KEY (`idRestaurant`),
  KEY `Restaurant_Adresse_FK` (`idAdresse`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `restaurant`
--

INSERT INTO `restaurant` (`idRestaurant`, `raisonSociale`, `delaiHabituel`, `idAdresse`) VALUES
(7, 'Chamas Tacos', 15, 1),
(8, 'Salmon Lovers', 30, 2),
(9, 'La Pizza Lyonnaise', 20, 3),
(10, 'Cousbox', 25, 4),
(11, 'Burger House', 10, 5),
(12, 'Crok’in', 15, 6);

--
-- Déclencheurs `restaurant`
--
DROP TRIGGER IF EXISTS `delaiUpdate`;
DELIMITER $$
CREATE TRIGGER `delaiUpdate` BEFORE UPDATE ON `restaurant` FOR EACH ROW BEGIN
IF (new.delaiHabituel < 5 OR new.delaiHabituel > 75)
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Le delai doit être compris entre 5 et 75 minutes';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la vue `comretard`
--
DROP TABLE IF EXISTS `comretard`;

DROP VIEW IF EXISTS `comretard`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `comretard`  AS  select `commande`.`idCommande` AS `idCommande`,`commande`.`dateCommande` AS `dateCommande`,`commande`.`dateLivraisonEstimee` AS `dateLivraisonEstimee`,`commande`.`dateLivraisonReelle` AS `dateLivraisonReelle`,time_format(timediff(`commande`.`dateLivraisonEstimee`,`commande`.`dateLivraisonReelle`),'%i') AS `Retard`,concat(`individu`.`prenom`,' ',`individu`.`nom`) AS `Coursier` from ((`commande` join `coursier` on((`coursier`.`idIndividu` = `commande`.`idIndividuCoursier`))) join `individu` on((`individu`.`idIndividu` = `coursier`.`idIndividu`))) where (timediff(`commande`.`dateLivraisonEstimee`,`commande`.`dateLivraisonReelle`) > 0) ;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `bloquer`
--
ALTER TABLE `bloquer`
  ADD CONSTRAINT `Bloquer_Client_FK` FOREIGN KEY (`idIndividuClient`) REFERENCES `client` (`idIndividu`),
  ADD CONSTRAINT `Bloquer_Coursier_1_FK` FOREIGN KEY (`idIndividuCoursier`) REFERENCES `coursier` (`idIndividu`);

--
-- Contraintes pour la table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `Client_Individu_FK` FOREIGN KEY (`idIndividu`) REFERENCES `individu` (`idIndividu`);

--
-- Contraintes pour la table `commande`
--
ALTER TABLE `commande`
  ADD CONSTRAINT `Commande_Adresse_FK` FOREIGN KEY (`idAdresse`) REFERENCES `adresse` (`idAdresse`),
  ADD CONSTRAINT `Commande_Client_1_FK` FOREIGN KEY (`idIndividuClient`) REFERENCES `client` (`idIndividu`),
  ADD CONSTRAINT `Commande_Coursier_FK` FOREIGN KEY (`idIndividuCoursier`) REFERENCES `coursier` (`idIndividu`),
  ADD CONSTRAINT `Commande_Restaurant_FK` FOREIGN KEY (`idRestaurant`) REFERENCES `restaurant` (`idRestaurant`);

--
-- Contraintes pour la table `coursier`
--
ALTER TABLE `coursier`
  ADD CONSTRAINT `Coursier_Individu_FK` FOREIGN KEY (`idIndividu`) REFERENCES `individu` (`idIndividu`);

--
-- Contraintes pour la table `restaurant`
--
ALTER TABLE `restaurant`
  ADD CONSTRAINT `Restaurant_Adresse_FK` FOREIGN KEY (`idAdresse`) REFERENCES `adresse` (`idAdresse`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
