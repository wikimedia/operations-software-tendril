-- MariaDB dump 10.17  Distrib 10.4.13-MariaDB, for Linux (x86_64)
--
-- Host: db1115    Database: tendril
-- ------------------------------------------------------
-- Server version	10.1.44-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `columns`
--

DROP TABLE IF EXISTS `columns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `columns` (
  `server_id` int(10) unsigned NOT NULL,
  `table_catalog` varchar(512) NOT NULL DEFAULT '',
  `table_schema` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `column_name` varchar(64) NOT NULL DEFAULT '',
  `ordinal_position` bigint(21) unsigned NOT NULL DEFAULT '0',
  `column_default` longtext,
  `is_nullable` varchar(3) NOT NULL DEFAULT '',
  `data_type` varchar(64) NOT NULL DEFAULT '',
  `character_maximum_length` bigint(21) unsigned DEFAULT NULL,
  `character_octet_length` bigint(21) unsigned DEFAULT NULL,
  `numeric_precision` bigint(21) unsigned DEFAULT NULL,
  `numeric_scale` bigint(21) unsigned DEFAULT NULL,
  `datetime_precision` bigint(21) unsigned DEFAULT NULL,
  `character_set_name` varchar(32) DEFAULT NULL,
  `collation_name` varchar(32) DEFAULT NULL,
  `column_type` longtext NOT NULL,
  `column_key` varchar(3) NOT NULL DEFAULT '',
  `extra` varchar(27) NOT NULL DEFAULT '',
  `privileges` varchar(80) NOT NULL DEFAULT '',
  `column_comment` varchar(1024) NOT NULL DEFAULT '',
  KEY `i1` (`server_id`,`table_schema`,`table_name`,`column_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-10-21 12:18:55