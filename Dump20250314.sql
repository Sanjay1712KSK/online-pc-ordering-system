-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: pc
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `pc`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `pc` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `pc`;

--
-- Table structure for table `chipset_compatibility`
--

DROP TABLE IF EXISTS `chipset_compatibility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chipset_compatibility` (
  `Chipset` varchar(50) NOT NULL,
  `SupportedCPUs` json NOT NULL,
  `SupportedRamTypes` set('DDR3','DDR4','DDR5') NOT NULL,
  `MaxRamFrequencyMHZ` int NOT NULL,
  `MinPSUWatts` int NOT NULL DEFAULT '300',
  PRIMARY KEY (`Chipset`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chipset_compatibility`
--

LOCK TABLES `chipset_compatibility` WRITE;
/*!40000 ALTER TABLE `chipset_compatibility` DISABLE KEYS */;
INSERT INTO `chipset_compatibility` VALUES ('B550','[\"Ryzen 5 5600X\", \"Ryzen 7 5800X\", \"Ryzen 9 5900X\"]','DDR4',3200,500),('X670','[\"Ryzen 7 7700X\", \"Ryzen 9 7900X\"]','DDR5',6000,650),('Z690','[\"Core i5-12600K\", \"Core i7-12700K\", \"Core i9-12900K\"]','DDR5',4800,600);
/*!40000 ALTER TABLE `chipset_compatibility` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_pc_orders`
--

DROP TABLE IF EXISTS `custom_pc_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_pc_orders` (
  `Build_No` int NOT NULL AUTO_INCREMENT,
  `Custom_PC_OrderID` varchar(20) NOT NULL,
  `UserID` int NOT NULL,
  `CPU` varchar(100) NOT NULL,
  `GPU` varchar(100) NOT NULL,
  `Chipset` varchar(50) NOT NULL,
  `Motherboard` varchar(50) NOT NULL,
  `RAM` varchar(100) NOT NULL,
  `PrimaryStorage` varchar(100) NOT NULL,
  `SecondaryStorage` varchar(100) DEFAULT 'None',
  `PSU` varchar(100) NOT NULL,
  `Cooling` varchar(100) NOT NULL,
  `Case` varchar(100) NOT NULL,
  `AdditionalParts` json DEFAULT NULL,
  `TotalPrice` decimal(10,2) DEFAULT NULL,
  `VirtualBuildDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `Last_Modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Build_No`),
  UNIQUE KEY `Custom_PC_OrderID` (`Custom_PC_OrderID`),
  KEY `idx_UserID` (`UserID`),
  KEY `idx_Chipset` (`Chipset`),
  FULLTEXT KEY `CPU` (`CPU`,`GPU`,`Motherboard`),
  CONSTRAINT `custom_pc_orders_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserNo`) ON DELETE CASCADE,
  CONSTRAINT `custom_pc_orders_ibfk_2` FOREIGN KEY (`Chipset`) REFERENCES `chipset_compatibility` (`Chipset`),
  CONSTRAINT `chk_TotalPrice` CHECK ((`TotalPrice` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_pc_orders`
--

LOCK TABLES `custom_pc_orders` WRITE;
/*!40000 ALTER TABLE `custom_pc_orders` DISABLE KEYS */;
INSERT INTO `custom_pc_orders` VALUES (4,'PC000004',1,'Ryzen 5 5600X','RTX 3060','B550','ASUS TUF B550','DDR4 3200MHz 16GB','Samsung 970 EVO 1TB','Seagate Barracuda 2TB','550W Bronze','Cooler Master Hyper 212','NZXT H510','{\"RGB_Fans\": 2}',1200.50,'2025-03-12 06:33:14','2025-03-12 06:33:14'),(7,'PC000007',1,'Ryzen 5 5600X','RTX 3060','B550','ASUS TUF Gaming B550','DDR4 3200MHz 16GB','Samsung 970 EVO 1TB','Seagate Barracuda 2TB','550W Bronze','Cooler Master Hyper 212','NZXT H510','{\"RGB_Fans\": 2}',1200.50,'2025-03-12 14:17:43','2025-03-12 14:17:43');
/*!40000 ALTER TABLE `custom_pc_orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Check_RAM_Chipset_Compatibility` BEFORE INSERT ON `custom_pc_orders` FOR EACH ROW BEGIN
    DECLARE max_freq INT;
    DECLARE ram_type VARCHAR(10);
    DECLARE ram_freq INT;
    SELECT MaxRamFrequencyMHZ, SupportedRamTypes 
    INTO max_freq, ram_type
    FROM Chipset_Compatibility 
    WHERE Chipset = NEW.Chipset;
    SET ram_freq = CAST(REGEXP_SUBSTR(NEW.RAM, '[0-9]+') AS UNSIGNED);
    IF ram_freq > max_freq THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Selected RAM exceeds chipset max frequency!';
    END IF;
    IF FIND_IN_SET(SUBSTRING_INDEX(NEW.RAM, ' ', 1), ram_type) = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Selected RAM type is not compatible with the chipset!';
    END IF;
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
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Check_CPU_Chipset_Compatibility` BEFORE INSERT ON `custom_pc_orders` FOR EACH ROW BEGIN
    DECLARE valid_cpu JSON;
    -- Fetch supported CPUs for the given chipset
    SELECT SupportedCPUs 
    INTO valid_cpu
    FROM Chipset_Compatibility 
    WHERE Chipset = NEW.Chipset;

    -- Check if the new CPU exists in the SupportedCPUs JSON list
    IF JSON_SEARCH(valid_cpu, 'one', NEW.CPU) IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Selected CPU is not compatible with the chipset!';
    END IF;
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
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_insert_CustomPC` BEFORE INSERT ON `custom_pc_orders` FOR EACH ROW BEGIN
    DECLARE next_id INT;
    SELECT AUTO_INCREMENT INTO next_id
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Custom_PC_Orders' AND TABLE_SCHEMA = DATABASE();
    SET NEW.Custom_PC_OrderID = CONCAT('PC', LPAD(next_id, 6, '0'));
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
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Check_PSU_Wattage` BEFORE INSERT ON `custom_pc_orders` FOR EACH ROW BEGIN
    DECLARE min_watts INT;
    DECLARE psu_watts INT;
    
    SELECT MinPSUWatts 
    INTO min_watts
    FROM Chipset_Compatibility 
    WHERE Chipset = NEW.Chipset;

    -- Ensure PSU wattage extraction is safe
    SET psu_watts = IFNULL(CAST(REGEXP_SUBSTR(NEW.PSU, '[0-9]+') AS UNSIGNED), 0);

    -- Validate wattage requirement
    IF psu_watts < min_watts THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Selected PSU does not meet the minimum wattage requirement!';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `predefined_pc_builds`
--

DROP TABLE IF EXISTS `predefined_pc_builds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `predefined_pc_builds` (
  `Build_ID` int NOT NULL AUTO_INCREMENT,
  `UseCase_ID` int NOT NULL,
  `UserID` int NOT NULL,
  `Build_Name` varchar(255) NOT NULL,
  `Components` json NOT NULL,
  `TotalPrice` decimal(10,2) DEFAULT NULL,
  `Created_At` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `Last_Modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CPU` varchar(255) GENERATED ALWAYS AS (json_unquote(json_extract(`Components`,_utf8mb4'$.CPU'))) STORED,
  `GPU` varchar(255) GENERATED ALWAYS AS (json_unquote(json_extract(`Components`,_utf8mb4'$.GPU'))) STORED,
  `RAM` varchar(255) GENERATED ALWAYS AS (json_unquote(json_extract(`Components`,_utf8mb4'$.RAM'))) STORED,
  `Storage` varchar(255) GENERATED ALWAYS AS (json_unquote(json_extract(`Components`,_utf8mb4'$.PrimaryStorage'))) STORED,
  `Motherboard` varchar(255) GENERATED ALWAYS AS (json_unquote(json_extract(`Components`,_utf8mb4'$.Motherboard'))) STORED,
  `Case` varchar(255) GENERATED ALWAYS AS (json_unquote(json_extract(`Components`,_utf8mb4'$.Case'))) STORED,
  `Cooler` varchar(255) GENERATED ALWAYS AS (json_unquote(json_extract(`Components`,_utf8mb4'$.Cooler'))) STORED,
  `PSU` varchar(255) GENERATED ALWAYS AS (json_unquote(json_extract(`Components`,_utf8mb4'$.PSU'))) STORED,
  `Monitor` varchar(255) GENERATED ALWAYS AS (json_unquote(json_extract(`Components`,_utf8mb4'$.Monitor'))) STORED,
  `Accessories` varchar(255) GENERATED ALWAYS AS (json_unquote(json_extract(`Components`,_utf8mb4'$.Accessories'))) STORED,
  PRIMARY KEY (`Build_ID`),
  UNIQUE KEY `Build_Name` (`Build_Name`),
  KEY `UseCase_ID` (`UseCase_ID`),
  KEY `UserID` (`UserID`),
  KEY `idx_cpu` (`CPU`),
  KEY `idx_gpu` (`GPU`),
  KEY `idx_ram` (`RAM`),
  KEY `idx_storage` (`Storage`),
  KEY `idx_motherboard` (`Motherboard`),
  KEY `idx_case` (`Case`),
  KEY `idx_cooler` (`Cooler`),
  KEY `idx_psu` (`PSU`),
  KEY `idx_monitor` (`Monitor`),
  KEY `idx_accessories` (`Accessories`),
  CONSTRAINT `predefined_pc_builds_ibfk_1` FOREIGN KEY (`UseCase_ID`) REFERENCES `use_cases` (`UseCase_ID`) ON DELETE CASCADE,
  CONSTRAINT `predefined_pc_builds_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserNo`) ON DELETE CASCADE,
  CONSTRAINT `predefined_pc_builds_chk_1` CHECK ((`TotalPrice` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `predefined_pc_builds`
--

LOCK TABLES `predefined_pc_builds` WRITE;
/*!40000 ALTER TABLE `predefined_pc_builds` DISABLE KEYS */;
INSERT INTO `predefined_pc_builds` (`Build_ID`, `UseCase_ID`, `UserID`, `Build_Name`, `Components`, `TotalPrice`, `Created_At`, `Last_Modified`) VALUES (9,1,6,'Basic Office PC','{\"CPU\": \"Intel Core i3-13100\", \"GPU\": \"Integrated UHD Graphics 730\", \"PSU\": \"450W Bronze\", \"RAM\": \"8GB DDR4 2666MHz\", \"PrimaryStorage\": \"256GB NVMe SSD\"}',450.00,'2025-03-12 15:44:21','2025-03-12 15:44:21');
/*!40000 ALTER TABLE `predefined_pc_builds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `use_cases`
--

DROP TABLE IF EXISTS `use_cases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `use_cases` (
  `UseCase_ID` int NOT NULL AUTO_INCREMENT,
  `UseCase_Name` varchar(255) NOT NULL,
  `Metadata` json NOT NULL,
  PRIMARY KEY (`UseCase_ID`),
  UNIQUE KEY `UseCase_Name` (`UseCase_Name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `use_cases`
--

LOCK TABLES `use_cases` WRITE;
/*!40000 ALTER TABLE `use_cases` DISABLE KEYS */;
INSERT INTO `use_cases` VALUES (1,'Office PC Basic','{\"Expected_Budget\": \"$300 - $500\", \"Recommended_CPU\": \"Intel Core i3 / Ryzen 3\", \"Recommended_GPU\": \"Integrated Graphics\", \"Recommended_RAM\": \"8GB DDR4\", \"Recommended_Storage\": \"256GB SSD + 1TB HDD\"}'),(2,'Gaming Starter','{\"Expected_Budget\": \"$600 - $800\", \"Recommended_CPU\": \"Intel Core i5 / Ryzen 5\", \"Recommended_GPU\": \"GTX 1650 / RX 6500 XT\", \"Recommended_RAM\": \"16GB DDR4 3200MHz\", \"Recommended_Storage\": \"512GB SSD + 1TB HDD\"}'),(3,'Gaming Pro','{\"Expected_Budget\": \"$900 - $1200\", \"Recommended_CPU\": \"Intel Core i5 / Ryzen 7\", \"Recommended_GPU\": \"RTX 3060 / RX 6700 XT\", \"Recommended_RAM\": \"16GB DDR4 3600MHz\", \"Recommended_Storage\": \"1TB NVMe SSD\"}'),(4,'Content Creator PC','{\"Expected_Budget\": \"$1200 - $1500\", \"Recommended_CPU\": \"Intel Core i7 / Ryzen 7\", \"Recommended_GPU\": \"RTX 4060 Ti / RX 6800\", \"Recommended_RAM\": \"32GB DDR5 5200MHz\", \"Recommended_Storage\": \"1TB NVMe SSD + 2TB HDD\"}'),(5,'Pro Video Editing Rig','{\"Expected_Budget\": \"$2000 - $2500\", \"Recommended_CPU\": \"Intel Core i9 / Ryzen 9\", \"Recommended_GPU\": \"RTX 4070 Ti / RX 7900 XT\", \"Recommended_RAM\": \"32GB DDR5 6000MHz\", \"Recommended_Storage\": \"2TB NVMe SSD + 4TB HDD\"}'),(6,'Ultimate Gaming PC','{\"Expected_Budget\": \"$3000+\", \"Recommended_CPU\": \"Intel Core i9 / Ryzen 9\", \"Recommended_GPU\": \"RTX 4090 / RX 7900 XTX\", \"Recommended_RAM\": \"32GB DDR5 6000MHz\", \"Recommended_Storage\": \"2TB NVMe SSD\"}'),(7,'AI Workstation','{\"Expected_Budget\": \"$5000+\", \"Recommended_CPU\": \"AMD Threadripper / Intel Xeon\", \"Recommended_GPU\": \"RTX 6000 Ada / H100\", \"Recommended_RAM\": \"128GB DDR5 ECC\", \"Recommended_Storage\": \"4TB NVMe SSD\"}'),(8,'Extreme Ultimate Build','{\"Expected_Budget\": \"$10,000+\", \"Recommended_CPU\": \"AMD Threadripper 7995WX / Intel Xeon W9-3495X\", \"Recommended_GPU\": \"RTX 4090 x 2 / RX 7900 XTX x 2\", \"Recommended_RAM\": \"256GB DDR5 ECC\", \"Recommended_Storage\": \"8TB NVMe SSD + 10TB HDD\"}');
/*!40000 ALTER TABLE `use_cases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `UserID` int DEFAULT ((floor((rand() * ((999999 - 100000) + 1))) + 100000)),
  `UserNo` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Age` int DEFAULT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `Gender` enum('Male','Female') NOT NULL,
  `PhoneNo` varchar(13) NOT NULL,
  `LastModified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `password_hash` varchar(255) NOT NULL,
  PRIMARY KEY (`UserNo`),
  UNIQUE KEY `PhoneNo` (`PhoneNo`),
  UNIQUE KEY `UserID` (`UserID`),
  KEY `idx_PhoneNo` (`PhoneNo`),
  CONSTRAINT `users_chk_1` CHECK ((`Age` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (398089,1,'Sanjay Kumar S',19,'1/235 xyz street,city','Male','+919487044111','2025-03-12 04:46:23','1c918023d679a37e1f3338c9029fe54730b3338643dea17773a25e4c67956699'),(129258,5,'Alice Smith',30,'456 Elm St','Female','9876543211','2025-03-12 06:37:12','343fcb40497549085c98ae137c137116a5c2442eb8dc0bf0cac3a3419ce05b9f'),(189131,6,'User1',25,'Address1','Male','1234567890','2025-03-12 15:43:56','9b29b1d990ae54e3154843982ded7e6a11f161e454ddf94b82b7849584c92e28'),(542211,7,'User2',30,'Address2','Female','1234567891','2025-03-12 15:43:56','28a62edee56dce6d5e30187fda34d81f9368db05c3e23a49bd5ea21aaf43aac0');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Hash_Password_Before_Insert` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    SET NEW.password_hash = SHA2(NEW.password_hash, 256);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'pc'
--

--
-- Dumping routines for database 'pc'
--

--
-- Current Database: `rbc`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rbc` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rbc`;

--
-- Table structure for table `message_audit`
--

DROP TABLE IF EXISTS `message_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `message_audit` (
  `audit_id` int NOT NULL AUTO_INCREMENT,
  `message_id` int DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`audit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message_audit`
--

LOCK TABLES `message_audit` WRITE;
/*!40000 ALTER TABLE `message_audit` DISABLE KEYS */;
INSERT INTO `message_audit` VALUES (1,1,'INSERT','2025-03-07 15:55:10'),(2,2,'INSERT','2025-03-07 16:18:48'),(3,3,'INSERT','2025-03-07 16:18:53'),(4,4,'INSERT','2025-03-07 16:20:53'),(5,4,'INSERT','2025-03-07 16:20:53'),(6,5,'INSERT','2025-03-07 16:21:10'),(7,5,'INSERT','2025-03-07 16:21:10'),(8,6,'INSERT','2025-03-07 16:21:21'),(9,6,'INSERT','2025-03-07 16:21:21'),(10,7,'INSERT','2025-03-07 16:21:44'),(11,7,'INSERT','2025-03-07 16:21:44'),(12,8,'INSERT','2025-03-07 16:25:42'),(13,8,'INSERT','2025-03-07 16:25:42');
/*!40000 ALTER TABLE `message_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_input` text NOT NULL,
  `bot_response` text NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'hello','Hare! Bhaiyaa vaanga vaanga!!!','2025-03-07 15:55:10'),(2,'help','Enna help pannanum?? Seri seri, here’s what you can ask me:\n- **Casual Talk**: hello, epdi iruka, nee yaaru da\n- **WhatsApp Help**: how to send a WhatsApp message\n- **Entertainment**: tell me a joke, sing a song, roast me\n- **Life Talks**: motivate me, inspire me, meaning of life\n- **Goodbye**: bye, exit\nCome on, ask me something interesting! ?','2025-03-07 16:18:48'),(3,'roast me','Ohhh, you want a roast? Okay, here goes... ???\nBro, your WiFi speed is so slow, even a tortoise would outrun your downloads! ??\nTry me again, I got plenty more! ?','2025-03-07 16:18:53'),(4,'help','Enna help pannanum?? Seri seri, here’s what you can ask me:\n- **Casual Talk**: hello, epdi iruka, nee yaaru da\n- **WhatsApp Help**: how to send a WhatsApp message\n- **Entertainment**: tell me a joke, sing a song, roast me\n- **Life Talks**: motivate me, inspire me, meaning of life\n- **Goodbye**: bye, exit\nCome on, ask me something interesting! ?','2025-03-07 16:20:53'),(5,'meaning of life','Deep question! ? Some say life is about happiness, some say it’s about purpose. \nFor me, it\'s about making every conversation meaningful! ? What do *you* think?','2025-03-07 16:21:10'),(6,'life is a game','Hmm... I\'m not sure I understood that. ?\nBut hey, I\'m still learning! Can you rephrase that or ask me something else?','2025-03-07 16:21:21'),(7,'nee yaaru da','Naan thaan da Leo... Leo das..... RATATA RATATA ???\nBut beyond that, I\'m your chatbot buddy! Here to talk, help, and maybe even roast you a little ?','2025-03-07 16:21:44'),(8,'goodbye','Oh, you\'re leaving already? ?\nAlright, take care! If you ever want to chat again, you know where to find me. Bye-bye! ?','2025-03-07 16:25:42');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_message_insert` AFTER INSERT ON `messages` FOR EACH ROW BEGIN INSERT INTO message_audit (message_id, action) VALUES (NEW.id, 'INSERT'); END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'rbc'
--

--
-- Dumping routines for database 'rbc'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-14 12:35:18
