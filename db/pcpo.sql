-- MySQL dump 10.13  Distrib 8.0.25, for Linux (x86_64)
--
-- Host: localhost    Database: gco
-- ------------------------------------------------------
-- Server version	8.0.25-0ubuntu0.20.04.1

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
-- Table structure for table `auth_assignment`
--

DROP TABLE IF EXISTS `auth_assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_assignment` (
  `item_name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` int DEFAULT NULL,
  PRIMARY KEY (`item_name`,`user_id`),
  KEY `idx-auth_assignment-user_id` (`user_id`),
  CONSTRAINT `auth_assignment_ibfk_1` FOREIGN KEY (`item_name`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_assignment`
--

LOCK TABLES `auth_assignment` WRITE;
/*!40000 ALTER TABLE `auth_assignment` DISABLE KEYS */;
INSERT INTO `auth_assignment` VALUES ('admin','1',1626868976);
/*!40000 ALTER TABLE `auth_assignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_item`
--

DROP TABLE IF EXISTS `auth_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_item` (
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `type` smallint NOT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `rule_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` blob,
  `created_at` int DEFAULT NULL,
  `updated_at` int DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `rule_name` (`rule_name`),
  KEY `idx-auth_item-type` (`type`),
  CONSTRAINT `auth_item_ibfk_1` FOREIGN KEY (`rule_name`) REFERENCES `auth_rule` (`name`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_item`
--

LOCK TABLES `auth_item` WRITE;
/*!40000 ALTER TABLE `auth_item` DISABLE KEYS */;
INSERT INTO `auth_item` VALUES ('admin',1,'??????????????????????????',NULL,NULL,1626867481,1626867481),('changesystemsettings',2,'???????????????? ?????????????????? ??????????????????',NULL,NULL,1626867481,1626867481),('manager',1,'????????????????',NULL,NULL,1626867481,1626867481),('viewalldata',2,'???????????????? ???????? ????????????',NULL,NULL,1626867481,1626867481);
/*!40000 ALTER TABLE `auth_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_item_child`
--

DROP TABLE IF EXISTS `auth_item_child`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_item_child` (
  `parent` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `child` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`parent`,`child`),
  KEY `child` (`child`),
  CONSTRAINT `auth_item_child_ibfk_1` FOREIGN KEY (`parent`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `auth_item_child_ibfk_2` FOREIGN KEY (`child`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_item_child`
--

LOCK TABLES `auth_item_child` WRITE;
/*!40000 ALTER TABLE `auth_item_child` DISABLE KEYS */;
INSERT INTO `auth_item_child` VALUES ('admin','changesystemsettings'),('admin','manager'),('manager','viewalldata');
/*!40000 ALTER TABLE `auth_item_child` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_rule`
--

DROP TABLE IF EXISTS `auth_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_rule` (
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `data` blob,
  `created_at` int DEFAULT NULL,
  `updated_at` int DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_rule`
--

LOCK TABLES `auth_rule` WRITE;
/*!40000 ALTER TABLE `auth_rule` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hardware`
--

DROP TABLE IF EXISTS `hardware`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hardware` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ipaddress` varchar(45) NOT NULL,
  `hostname` varchar(45) NOT NULL,
  `macaddress` varchar(45) NOT NULL,
  `motherboard` varchar(240) NOT NULL,
  `cpu` varchar(240) NOT NULL,
  `ram` varchar(240) NOT NULL,
  `video` varchar(240) NOT NULL,
  `hdd` varchar(2048) DEFAULT '',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `macadd` (`macaddress`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hardware`
--

LOCK TABLES `hardware` WRITE;
/*!40000 ALTER TABLE `hardware` DISABLE KEYS */;
/*!40000 ALTER TABLE `hardware` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `networks`
--

DROP TABLE IF EXISTS `networks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `networks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `iprange` varchar(45) NOT NULL,
  `user` varchar(45) NOT NULL,
  `password` varchar(120) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `networks`
--

LOCK TABLES `networks` WRITE;
/*!40000 ALTER TABLE `networks` DISABLE KEYS */;
/*!40000 ALTER TABLE `networks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `options`
--

DROP TABLE IF EXISTS `options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `options` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL DEFAULT 'NULL',
  `description` varchar(250) DEFAULT NULL,
  `option` varchar(250) NOT NULL DEFAULT 'NULL',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `options`
--

LOCK TABLES `options` WRITE;
/*!40000 ALTER TABLE `options` DISABLE KEYS */;
INSERT INTO `options` VALUES (1,'telegrambotapikey','???????? ???????? telegram','0'),(2,'telegramchatid','id ????????, ???????? ?????????? ???????????????????? ??????????????????????','0'),(3,'notificationemail','?????????? ?????????????????? ??????????, ???? ?????????????? ?????????? ?????????????????? ??????????????????????, ?? ???????????? ???????? ???????? ???????????????????? ?????????????????? (?????????? ?????????????? ?????????????????? ??????????????, ???????????????? ???? ?????????????? [,])','recepient@somemail.tld'),(4,'smtphost','?????????? smtp ??????????????','smtp.yandex.ru'),(5,'smtpport','???????? smtp ??????????????','465'),(6,'smtpencryption','???????????????? ???????????????????? smtp ??????????????','1'),(7,'emailuser','???????????????????????? smtp ??????????????, ???? ???????????????? ?????????? ?????????????????????????? ???????????????? ??????????????????','alert@somemail.tld'),(8,'emailpwd','???????????? ???????????????????????? smtp ??????????????, ???? ???????????????? ?????????? ?????????????????????????? ???????????????? ??????????????????','strongpassword'),(9,'maxscanthreads','?????????????????????? ???????????????????? ???????????????????? ?????????????? ???????????? ???????????????????? ?? ????????????','15'),(10,'telegram_notifications_enabled','???????????????? ???????????????????? ?????????? ????????????????','0'),(11,'smtp_notifications_enabled','???????????????? ???????????????? ???????????????? ???????????? ???????????????? ???? ??????????','0'),(12,'days_for_colorize_new_hosts','???????????????????? ?????????? ?????? ???????????????? ?? \"??????????????????????????\" ?????????????? ???????????? ???????????? ?? ??????????????????, ???????????????????? ?? ?????????????? ?????????????????? ???? ?????????????????? N ??????????.','3'),(13,'days_for_colorize_lost_info_hosts','???????????????????? ?????????? ?????? ???????????????? ?? \"??????????????????????????\" ???????????????????? ???????????? ???????????? ?? ??????????????????, ???????????????????? ?? ?????????????? ???? ???????????????????? ???? ?????????????????? N ??????????.','14'),(14,'timezone','???????? ????????, ???????????????????????? ?? ???????????????????? ???? ??????????????????','Asia/Bishkek'),(15,'emailaboutchanges','?????????? ???????????????????? ???????????????????? ?? ?????????????? ????????????, ?????????????? ???????????????????????? ???? ?????????? ???? ???????????????????? ?? ?????????????????????????? ????????????','1'),(16,'emailaboutnewhosts','?????????? ???????????????????? ???????????????????? ?? ?????????????? ????????????, ?????????????? ???????????????????????? ???? ?????????? ?? ?????????? ????????????','1'),(17,'emailaboutfailedhosts','?????????? ???????????????????? ???????????????????? ?? ?????????????? ????????????, ?????????????? ???????????????????????? ???? ?????????? ?? ?????????????????????????? ????????????','0'),(18,'telegram_message_send_max_tries','???????????????????????? ???????????????????? ???????????????????? ?????????????? ???????????????? ?????????????????? (???????????????? ?????????? ?????????????????? ???? ???????? ???????????? ???????????????? ??????????????????)','20'),(19,'telegram_message_send_retry_delay','???????????????????? ?????????? ?????????????????? ???????????????? ?????????????????? ?????????? ???????????????? (?????????????????????? ?? ????????????????)','15'),(20,'scanner_debug_mode_enabled','???????????????? ?????????? ?????????????? ?? ??????????????','0'),(21,'scanner_debug_level','?????????????? ?????????????????????? ???????????????????? ?????????????? ?? ??????????????','1'),(22,'smtp_debug_enabled','???????????????? ?????????? ?????????????? ?????? ???????????????? ??????????','0'),(23,'hdd_add_iscsi_drives','?????????????????? ?????? ???????????????? ?????????? ??????????, ???????????????????????? ???? iSCSI','0'),(24,'hdd_add_usb_drives','?????????????????? ?????? ???????????????? ?????????? ??????????, ???????????????????????? ???? USB','0');
/*!40000 ALTER TABLE `options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scanstat`
--

DROP TABLE IF EXISTS `scanstat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scanstat` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `hostsscanned` int DEFAULT '0',
  `failedhosts` int DEFAULT '0',
  `newhosts` int DEFAULT '0',
  `ipaddresschanges` int DEFAULT '0',
  `hostnamechanges` int DEFAULT '0',
  `motherboardchanges` int DEFAULT '0',
  `cpuchanges` int DEFAULT '0',
  `ramchanges` int DEFAULT '0',
  `videochanges` int DEFAULT '0',
  `hddchanges` int DEFAULT '0',
  `begin_at` timestamp NULL DEFAULT NULL,
  `end_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scanstat`
--

LOCK TABLES `scanstat` WRITE;
/*!40000 ALTER TABLE `scanstat` DISABLE KEYS */;
/*!40000 ALTER TABLE `scanstat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session` (
  `id` char(40) NOT NULL,
  `expire` int DEFAULT NULL,
  `data` longblob,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session`
--

LOCK TABLES `session` WRITE;
/*!40000 ALTER TABLE `session` DISABLE KEYS */;
INSERT INTO `session` VALUES ('9k9bpctahndh4gdom7b9sk81a1',1626873599,_binary '__flash|a:0:{}__id|i:4;__authKey|s:32:\"r0EuLCFK4o3l0vyS1T8i9_YBBxIj_iad\";__returnUrl|s:25:\"http://10.245.139.4/admin\";',NULL),('mmitl8nl4etjpn166i38qm65ee',1626948568,_binary '__flash|a:0:{}__id|i:1;__authKey|s:32:\"xX_sKglXxBi9pKHKPaq-E_6eit5wVXak\";',1);
/*!40000 ALTER TABLE `session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `fullname` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `auth_key` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password_reset_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `status` smallint NOT NULL DEFAULT '10',
  `created_at` int NOT NULL,
  `updated_at` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `password_reset_token` (`password_reset_token`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'pcpoadmin','PCPO Administrator','xX_sKglXxBi9pKHKPaq-E_6eit5wVXak','$2y$13$S/rjN9j5WDgjRYFngQZMce.Gnjc8IWJgev0UYp6gNzk9fIXR.Ceza',NULL,'admin@email.tld',10,1626865721,1626868976);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-07-22 15:47:25
