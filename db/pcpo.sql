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
INSERT INTO `auth_item` VALUES ('admin',1,'Администратор',NULL,NULL,1626867481,1626867481),('changesystemsettings',2,'Изменять системные настройки',NULL,NULL,1626867481,1626867481),('manager',1,'Менеджер',NULL,NULL,1626867481,1626867481),('viewalldata',2,'Просмотр всех данных',NULL,NULL,1626867481,1626867481);
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
INSERT INTO `options` VALUES (1,'telegrambotapikey','Ключ бота telegram','0'),(2,'telegramchatid','id чата, куда будут высылаться уведомления','0'),(3,'notificationemail','Адрес почтового ящика, на который будут приходить уведомления, в случае если были обнаружены изменения (можно указать несколько адресов, разделяя их запятой [,])','recepient@somemail.tld'),(4,'smtphost','Адрес smtp сервера','smtp.yandex.ru'),(5,'smtpport','Порт smtp сервера','465'),(6,'smtpencryption','Протокол шифрования smtp сервера','1'),(7,'emailuser','Пользователь smtp сервера, от которого будет производиться отправка сообщений','alert@somemail.tld'),(8,'emailpwd','Пароль пользователя smtp сервера, от которого будет производиться отправка сообщений','strongpassword'),(9,'maxscanthreads','Максимально допустимое количество потоков забора информации с хостов','15'),(10,'telegram_notifications_enabled','Включить оповещение через телеграм','0'),(11,'smtp_notifications_enabled','Включить отправку сводного отчёта проверок на почту','0'),(12,'days_for_colorize_new_hosts','Количество суток для проверки и \"подсвечивания\" красным цветом хостов в аналитике, информация о которых появилась за последние N суток.','3'),(13,'days_for_colorize_lost_info_hosts','Количество суток для проверки и \"подсвечивания\" фиолетовым цветом хостов в аналитике, информация о которых не появлялась за последние N суток.','14'),(14,'timezone','Тайм зона, используемая в интерфейсе по умолчанию','Asia/Bishkek'),(15,'emailaboutchanges','Нужно вкладывать информацию в сводные отчёты, которые отправляются на почту об изменениях в конфигурациях хостов','1'),(16,'emailaboutnewhosts','Нужно вкладывать информацию в сводные отчёты, которые отправляются на почту о новых хостах','1'),(17,'emailaboutfailedhosts','Нужно вкладывать информацию в сводные отчёты, которые отправляются на почту о непроверенных хостах','0'),(18,'telegram_message_send_max_tries','Максимальное допустимое количество попыток отправки сообщений (телеграм может посчитать за спам частую отправку сообщений)','20'),(19,'telegram_message_send_retry_delay','Промежуток между попытками отправки сообщений через телеграм (указывается в секундах)','15'),(20,'scanner_debug_mode_enabled','Включить режим отладки в сканере','0'),(21,'scanner_debug_level','Уровень отображения информации отладки в сканере','1'),(22,'smtp_debug_enabled','Включить режим отладки при отправке почты','0'),(23,'hdd_add_iscsi_drives','Учитывать при проверке хоста диски, подключенные по iSCSI','0'),(24,'hdd_add_usb_drives','Учитывать при проверке хоста диски, подключенные по USB','0');
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
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scanstat`
--

LOCK TABLES `scanstat` WRITE;
/*!40000 ALTER TABLE `scanstat` DISABLE KEYS */;
INSERT INTO `scanstat` VALUES (1,204,5,0,0,0,0,0,0,0,0,'2021-07-10 10:00:57','2021-07-10 10:01:41'),(2,205,5,1,0,0,0,0,0,0,0,'2021-07-10 10:16:15','2021-07-10 10:17:01'),(3,205,5,1,0,0,2,0,0,0,0,'2021-07-10 11:41:30','2021-07-10 11:42:14'),(4,203,7,0,0,0,0,0,0,0,0,'2021-07-10 11:50:41','2021-07-10 11:52:20'),(5,206,5,1,0,0,0,0,0,0,0,'2021-07-10 12:18:19','2021-07-10 12:19:06'),(6,206,5,0,0,0,0,0,0,0,0,'2021-07-10 12:19:25','2021-07-10 12:20:16'),(7,203,6,0,0,0,0,0,1,0,0,'2021-07-10 18:43:34','2021-07-10 18:45:19'),(8,203,5,1,0,0,0,0,0,0,0,'2021-07-10 18:49:22','2021-07-10 18:50:03'),(9,203,5,0,0,0,0,0,0,0,0,'2021-07-10 19:35:25','2021-07-10 19:36:07'),(10,203,6,0,0,0,0,0,0,0,0,'2021-07-10 19:38:33','2021-07-10 19:42:04'),(11,203,5,0,0,0,0,0,0,0,0,'2021-07-10 20:16:25','2021-07-10 20:17:09'),(12,203,5,0,0,0,0,0,0,0,0,'2021-07-10 20:17:49','2021-07-10 20:18:34'),(13,204,5,0,0,0,0,0,0,0,0,'2021-07-10 20:19:46','2021-07-10 20:22:17'),(14,204,5,0,0,0,0,0,0,0,0,'2021-07-10 20:23:28','2021-07-10 20:24:19'),(15,202,5,0,0,0,0,0,0,0,0,'2021-07-10 20:37:48','2021-07-10 20:38:28'),(16,204,5,0,0,0,0,0,0,0,0,'2021-07-10 20:39:31','2021-07-10 20:40:12'),(17,199,5,0,0,0,0,0,0,0,0,'2021-07-10 20:42:37','2021-07-10 20:43:18'),(18,202,7,0,0,0,0,0,0,0,0,'2021-07-10 20:46:29','2021-07-10 20:47:42'),(19,204,5,0,0,0,0,0,0,0,0,'2021-07-10 20:48:52','2021-07-10 20:49:43'),(20,203,5,0,0,0,0,0,1,0,0,'2021-07-10 20:51:39','2021-07-10 20:52:22'),(21,204,5,0,0,0,0,0,0,0,0,'2021-07-10 20:55:34','2021-07-10 20:56:16'),(22,204,5,0,0,0,0,0,0,0,0,'2021-07-10 20:57:09','2021-07-10 20:57:49'),(23,203,5,0,0,0,0,0,0,0,0,'2021-07-10 20:59:14','2021-07-10 20:59:55'),(24,203,5,0,0,0,0,0,0,0,0,'2021-07-10 21:00:33','2021-07-10 21:01:13'),(25,203,5,0,0,0,0,0,0,0,0,'2021-07-10 21:01:44','2021-07-10 21:02:25'),(26,204,5,0,0,0,0,0,0,0,0,'2021-07-10 21:03:42','2021-07-10 21:04:23'),(27,204,5,0,0,0,0,0,0,0,0,'2021-07-10 21:06:07','2021-07-10 21:06:49'),(28,350,8,0,0,0,0,0,0,0,0,'2021-07-10 21:12:57','2021-07-10 21:15:06'),(29,350,8,0,0,0,0,0,0,0,0,'2021-07-11 05:56:34','2021-07-11 05:58:51'),(30,350,8,0,0,0,0,0,0,0,0,'2021-07-11 05:59:10','2021-07-11 06:01:12'),(31,201,5,1,0,0,0,0,0,0,0,'2021-07-11 06:19:47','2021-07-11 06:20:35'),(32,203,5,0,0,0,0,0,0,0,0,'2021-07-11 06:49:04','2021-07-11 06:49:50'),(33,203,5,0,0,0,0,0,0,0,0,'2021-07-11 06:54:26','2021-07-11 06:55:16'),(34,203,5,0,0,0,0,0,0,0,0,'2021-07-11 07:10:18','2021-07-11 07:11:02'),(35,2,0,2,0,0,0,0,0,0,0,'2021-07-12 03:36:45','2021-07-12 03:36:55'),(36,1,0,0,0,0,0,0,0,0,0,'2021-07-12 03:37:25','2021-07-12 03:37:29'),(37,2,0,2,0,0,0,0,0,0,0,'2021-07-12 03:38:02','2021-07-12 03:38:11'),(38,2,0,0,0,0,0,0,0,0,0,'2021-07-12 03:38:30','2021-07-12 03:38:38'),(39,2,0,2,0,0,0,0,0,0,0,'2021-07-12 03:41:01','2021-07-12 03:41:09'),(40,2,0,0,0,0,0,0,0,0,0,'2021-07-12 03:41:35','2021-07-12 03:41:43'),(41,2,0,0,0,0,2,2,0,2,0,'2021-07-12 03:45:44','2021-07-12 03:45:52'),(42,2,0,2,0,0,0,0,0,0,0,'2021-07-12 03:46:13','2021-07-12 03:46:22'),(43,2,0,0,0,0,0,0,0,0,0,'2021-07-12 03:47:36','2021-07-12 03:47:41'),(44,2,0,0,0,0,0,0,0,0,0,'2021-07-12 03:48:17','2021-07-12 03:48:26'),(45,2,0,2,0,0,0,0,0,0,0,'2021-07-12 03:52:03','2021-07-12 03:52:12'),(46,2,0,0,0,0,0,0,0,0,0,'2021-07-12 03:52:19','2021-07-12 03:52:25'),(47,2,0,0,0,0,0,0,0,0,0,'2021-07-12 03:52:48','2021-07-12 03:52:54'),(48,3,0,1,0,0,0,0,0,0,0,'2021-07-12 03:58:01','2021-07-12 03:58:07'),(49,3,0,0,0,0,0,0,0,0,0,'2021-07-12 03:58:24','2021-07-12 03:58:33'),(50,3,0,0,0,0,0,0,0,0,0,'2021-07-12 03:59:07','2021-07-12 03:59:13'),(51,4,0,1,0,0,0,0,0,0,0,'2021-07-12 04:42:48','2021-07-12 04:42:55'),(52,4,0,0,0,0,1,0,0,0,0,'2021-07-12 04:43:34','2021-07-12 04:43:42'),(53,4,0,0,0,0,4,0,0,0,0,'2021-07-13 03:40:03','2021-07-13 03:40:12'),(54,4,0,0,0,0,2,0,0,0,0,'2021-07-13 05:38:04','2021-07-13 05:38:12'),(55,4,0,0,0,2,0,0,0,0,0,'2021-07-13 05:58:56','2021-07-13 05:59:10'),(56,4,0,0,0,0,1,0,0,0,0,'2021-07-13 07:07:57','2021-07-13 07:08:07'),(57,204,5,87,0,0,0,0,0,0,0,'2021-07-13 07:24:43','2021-07-13 07:25:35'),(58,204,5,0,0,0,0,0,0,0,0,'2021-07-13 07:25:50','2021-07-13 07:26:40'),(59,203,5,0,0,0,0,0,0,0,0,'2021-07-13 07:27:04','2021-07-13 07:27:58'),(60,149,2,147,0,0,0,0,0,0,0,'2021-07-13 07:28:31','2021-07-13 07:29:13'),(61,346,7,0,0,0,0,0,0,0,0,'2021-07-13 07:29:21','2021-07-13 07:30:49'),(62,350,7,0,0,0,0,0,0,0,0,'2021-07-13 07:31:37','2021-07-13 07:33:09'),(63,346,8,0,0,0,0,0,0,0,0,'2021-07-13 07:34:14','2021-07-13 07:36:31'),(64,350,7,0,0,0,0,0,0,0,0,'2021-07-13 07:41:46','2021-07-13 07:43:06'),(65,344,7,0,0,0,0,0,0,0,0,'2021-07-13 07:46:03','2021-07-13 07:47:28'),(66,350,7,2,0,0,0,0,1,0,0,'2021-07-13 09:08:10','2021-07-13 09:09:34'),(67,353,7,1,0,0,4,1,0,0,0,'2021-07-13 09:14:01','2021-07-13 09:15:24'),(68,350,7,1,0,0,0,0,1,0,0,'2021-07-14 02:53:35','2021-07-14 02:55:12'),(69,352,7,0,0,0,0,0,0,0,1,'2021-07-14 02:58:39','2021-07-14 03:00:04'),(70,350,7,0,0,0,0,0,0,0,0,'2021-07-14 03:36:44','2021-07-14 03:38:04'),(71,349,6,2,1,0,0,0,0,2,1,'2021-07-21 05:08:18','2021-07-21 05:09:39'),(72,348,7,0,0,0,0,0,0,0,0,'2021-07-21 09:32:42','2021-07-21 09:34:33'),(73,353,6,0,0,0,0,0,0,0,0,'2021-07-21 13:04:04','2021-07-21 13:05:29'),(74,277,6,0,0,0,0,0,0,0,0,'2021-07-21 16:10:57','2021-07-21 16:12:20'),(75,350,7,0,0,0,0,0,0,0,1,'2021-07-21 16:13:17','2021-07-21 16:15:05'),(76,350,7,0,0,0,0,0,0,0,0,'2021-07-21 16:20:03','2021-07-21 16:22:40'),(77,188,3,0,0,0,0,0,0,0,0,'2021-07-21 16:29:36','2021-07-21 16:30:37'),(78,353,6,0,0,0,0,0,0,0,1,'2021-07-21 16:50:37','2021-07-21 16:52:15'),(79,292,5,0,0,0,0,0,0,0,69,'2021-07-22 03:21:21','2021-07-22 03:22:47'),(80,355,6,355,0,0,0,0,0,0,0,'2021-07-22 03:28:11','2021-07-22 03:30:49'),(81,355,6,0,0,0,0,0,0,0,355,'2021-07-22 03:47:57','2021-07-22 03:49:22'),(82,354,7,0,0,0,0,0,0,0,0,'2021-07-22 03:49:26','2021-07-22 03:51:29'),(83,355,6,355,0,0,0,0,0,0,0,'2021-07-22 03:53:58','2021-07-22 03:55:17'),(84,355,6,1,0,0,0,0,0,0,1,'2021-07-22 06:46:08','2021-07-22 06:47:31'),(85,353,6,0,0,0,0,0,0,0,0,'2021-07-22 06:50:59','2021-07-22 06:52:22'),(86,355,6,0,0,0,0,0,0,0,0,'2021-07-22 06:56:19','2021-07-22 06:57:44'),(87,355,6,0,0,0,0,0,0,0,0,'2021-07-22 07:01:04','2021-07-22 07:02:31'),(88,355,6,355,0,0,0,0,0,0,0,'2021-07-22 07:03:01','2021-07-22 07:04:31'),(89,324,36,0,0,0,0,0,0,0,1,'2021-07-22 07:10:22','2021-07-22 07:13:40'),(90,354,7,0,0,0,0,0,0,0,1,'2021-07-22 07:13:47','2021-07-22 07:15:07'),(91,354,6,0,0,0,0,0,0,0,1,'2021-07-22 07:15:35','2021-07-22 07:16:56'),(92,253,1,1,0,0,0,0,0,0,0,'2021-07-22 07:22:39','2021-07-22 07:23:47');
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
INSERT INTO `session` VALUES ('9k9bpctahndh4gdom7b9sk81a1',1626873599,_binary '__flash|a:0:{}__id|i:4;__authKey|s:32:\"r0EuLCFK4o3l0vyS1T8i9_YBBxIj_iad\";__returnUrl|s:25:\"http://10.245.139.4/admin\";',NULL),('ufqaunc2lpnf2k74lakfhvmuvu',1626941512,_binary '__flash|a:0:{}',NULL);
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

-- Dump completed on 2021-07-22 13:48:38
