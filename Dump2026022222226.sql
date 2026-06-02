-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: lab_information_system
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `billing`
--

DROP TABLE IF EXISTS `billing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing` (
  `bill_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `cpt_code` varchar(10) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `payment_status` enum('Pending','Paid','Denied') DEFAULT NULL,
  PRIMARY KEY (`bill_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `billing_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing`
--

LOCK TABLES `billing` WRITE;
/*!40000 ALTER TABLE `billing` DISABLE KEYS */;
INSERT INTO `billing` VALUES (1,4,'12345',400.00,'Paid');
/*!40000 ALTER TABLE `billing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diagnoses`
--

DROP TABLE IF EXISTS `diagnoses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diagnoses` (
  `diagnosis_id` int NOT NULL AUTO_INCREMENT,
  `icd10_code` varchar(10) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`diagnosis_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diagnoses`
--

LOCK TABLES `diagnoses` WRITE;
/*!40000 ALTER TABLE `diagnoses` DISABLE KEYS */;
INSERT INTO `diagnoses` VALUES (1,'E11.9','Type 2 diabetes mellitus s');
/*!40000 ALTER TABLE `diagnoses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `item_name` varchar(150) DEFAULT NULL,
  `lot_number` varchar(100) DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `lab_id` int DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `lab_id` (`lab_id`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`lab_id`) REFERENCES `laboratories` (`lab_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,'reagent kit','123','2026-02-20',10,1);
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `laboratories`
--

DROP TABLE IF EXISTS `laboratories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `laboratories` (
  `lab_id` int NOT NULL AUTO_INCREMENT,
  `lab_name` varchar(150) NOT NULL,
  `location` varchar(200) DEFAULT NULL,
  `accreditation` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`lab_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `laboratories`
--

LOCK TABLES `laboratories` WRITE;
/*!40000 ALTER TABLE `laboratories` DISABLE KEYS */;
INSERT INTO `laboratories` VALUES (1,'sahil','gad','sassa','2026-02-18 05:42:16'),(3,'ram','kolhapur','kolhapur ','2026-02-18 06:35:03');
/*!40000 ALTER TABLE `laboratories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_tests`
--

DROP TABLE IF EXISTS `order_tests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_tests` (
  `order_test_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `test_id` int NOT NULL,
  PRIMARY KEY (`order_test_id`),
  KEY `order_id` (`order_id`),
  KEY `test_id` (`test_id`),
  CONSTRAINT `order_tests_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_tests_ibfk_2` FOREIGN KEY (`test_id`) REFERENCES `tests` (`test_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_tests`
--

LOCK TABLES `order_tests` WRITE;
/*!40000 ALTER TABLE `order_tests` DISABLE KEYS */;
INSERT INTO `order_tests` VALUES (1,1,1),(2,4,1),(5,3,2),(6,3,1);
/*!40000 ALTER TABLE `order_tests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `physician_id` int DEFAULT NULL,
  `diagnosis_id` int DEFAULT NULL,
  `order_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('Ordered','Collected','Processing','Completed','Cancelled') DEFAULT 'Ordered',
  PRIMARY KEY (`order_id`),
  KEY `physician_id` (`physician_id`),
  KEY `diagnosis_id` (`diagnosis_id`),
  KEY `idx_orders_patient` (`patient_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`physician_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`diagnosis_id`) REFERENCES `diagnoses` (`diagnosis_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,4,2,1,'2026-02-14 14:39:16','Collected'),(3,10,7,1,'2026-02-18 21:01:54','Completed'),(4,10,7,1,'2026-02-18 21:07:11','Processing'),(5,10,7,1,'2026-02-20 23:40:28','Ordered');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results`
--

DROP TABLE IF EXISTS `results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `results` (
  `result_id` int NOT NULL AUTO_INCREMENT,
  `order_test_id` int DEFAULT NULL,
  `result_value` varchar(100) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `reference_range` varchar(100) DEFAULT NULL,
  `abnormal_flag` enum('Normal','High','Low','Critical') DEFAULT NULL,
  `result_status` enum('Preliminary','Final','Corrected') DEFAULT NULL,
  `validated_by` int DEFAULT NULL,
  `validated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`result_id`),
  UNIQUE KEY `order_test_id` (`order_test_id`),
  KEY `validated_by` (`validated_by`),
  KEY `idx_results_order_test` (`order_test_id`),
  CONSTRAINT `results_ibfk_1` FOREIGN KEY (`order_test_id`) REFERENCES `order_tests` (`order_test_id`),
  CONSTRAINT `results_ibfk_2` FOREIGN KEY (`validated_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results`
--

LOCK TABLES `results` WRITE;
/*!40000 ALTER TABLE `results` DISABLE KEYS */;
INSERT INTO `results` VALUES (4,2,'68','mg','-','Normal','Final',NULL,'2026-02-19 22:07:09'),(13,1,'92','dl','90-120','Normal','Final',NULL,NULL),(15,6,'55','mg','90-120','High','Final',NULL,'2026-02-20 21:54:59'),(16,5,'55','dl','90-120','Low','Final',NULL,'2026-02-20 21:54:54');
/*!40000 ALTER TABLE `results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `specimens`
--

DROP TABLE IF EXISTS `specimens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `specimens` (
  `specimen_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `specimen_barcode` varchar(100) DEFAULT NULL,
  `specimen_type` varchar(100) DEFAULT NULL,
  `collection_time` datetime DEFAULT NULL,
  `received_time` datetime DEFAULT NULL,
  `status` enum('Collected','In Transit','Received','Rejected','Processing','Completed') DEFAULT NULL,
  `technician_id` int DEFAULT NULL,
  PRIMARY KEY (`specimen_id`),
  UNIQUE KEY `specimen_barcode` (`specimen_barcode`),
  KEY `order_id` (`order_id`),
  KEY `technician_id` (`technician_id`),
  CONSTRAINT `specimens_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `specimens_ibfk_2` FOREIGN KEY (`technician_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specimens`
--

LOCK TABLES `specimens` WRITE;
/*!40000 ALTER TABLE `specimens` DISABLE KEYS */;
INSERT INTO `specimens` VALUES (1,1,'sfdhetrg','Blood','2026-02-19 17:24:00','2026-02-20 22:45:00','Completed',NULL),(2,4,'123456','Blood','2026-02-19 15:07:00','2026-02-19 15:07:00','Completed',NULL),(3,4,'456123','Tissue','2026-02-19 16:11:00','2026-02-20 22:43:00','Processing',NULL),(5,4,'789456','Blood','2026-02-19 16:11:00','2026-02-20 22:44:00','Processing',NULL),(6,3,'555555','Blood','2026-02-20 16:19:00','2026-02-19 21:53:00','Completed',NULL);
/*!40000 ALTER TABLE `specimens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tests`
--

DROP TABLE IF EXISTS `tests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tests` (
  `test_id` int NOT NULL AUTO_INCREMENT,
  `test_name` varchar(150) NOT NULL,
  `loinc_code` varchar(20) DEFAULT NULL,
  `snomed_code` varchar(20) DEFAULT NULL,
  `specimen_type` varchar(100) DEFAULT NULL,
  `normal_range` varchar(100) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`test_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tests`
--

LOCK TABLES `tests` WRITE;
/*!40000 ALTER TABLE `tests` DISABLE KEYS */;
INSERT INTO `tests` VALUES (1,'Blood Glucose','1233','8956','Blood','90-150','mg/dL','2026-02-14 09:09:16'),(2,'blood ','98946','123456','Blood','70-100','mg','2026-02-19 09:04:00');
/*!40000 ALTER TABLE `tests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `user_type` enum('patient','physician','admin') NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `address` text,
  `license_number` varchar(50) DEFAULT NULL,
  `mrn` varchar(50) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `mrn` (`mrn`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'physician','ravi','gupta','Male','2026-02-01','1234567898','john@lab.com','gad','89846531',NULL,'hashed_pass',1,'2026-02-14 09:09:16','2026-02-18 08:37:23'),(4,'patient','Michael','Johnson',NULL,NULL,NULL,'michael@lab.com',NULL,NULL,NULL,'hashed_pass',1,'2026-02-14 09:09:16','2026-02-14 09:09:16'),(5,'admin','chtan','patil','Male','2008-02-06','7894561233','chetan@gmail.com',NULL,NULL,'MRN1771142500225','$2a$10$ocU6FUgkqxM9sjujyTjCAutg5zTZUTL7R0sDMilEhuEBcl5VcMAg.',1,'2026-02-15 08:01:40','2026-02-16 04:37:36'),(6,'patient','rohan','gurav','Male','2002-12-12','7894561233','rohan@gmail.com',NULL,NULL,'MRN1771153602662','$2a$10$ATBkS3sVH7VzS6iWbbeBSuwW8PEiRjDxjuDKzotTHvUGctP0qNrMu',1,'2026-02-15 11:06:42','2026-02-15 11:06:42'),(7,'physician','amruta','patil','Female',NULL,'9876543210','am@gmail.com','wee','1234567899',NULL,'$2a$10$INn7vL/uzaW99Vca4Z6/WeAdsopKsJSNld59ywRvLw/o/FXnIBBSW',1,'2026-02-16 09:32:38','2026-02-16 09:35:08'),(9,'physician','ram','sham','Male','1998-11-11','7894561233','ram@gmail.com','aefwd','1234567899',NULL,'$2a$10$QGDlKoEk8zNR5WpNBqGZH.6yA1ZtjZjESKTnivTadCfOozXsVdAhu',1,'2026-02-18 06:11:23','2026-02-18 06:11:23'),(10,'patient','geeta','kore','Female','2026-02-04','7276043152','geeta@gmail.com','gad',NULL,'MRN12234566554651','$2a$10$0IFCHXSRzdEvPX1OAhT8HuGKHn.ONL2T0YtrGR3.jPUYGXkhfeGdy',1,'2026-02-18 11:21:35','2026-02-18 17:43:50');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-26 18:35:25
