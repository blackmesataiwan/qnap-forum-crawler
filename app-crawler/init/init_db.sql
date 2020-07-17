/*
SQLyog Community v13.1.6 (64 bit)
MySQL - 5.5.57-MariaDB : Database - ss-forum
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`ss-forum` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `ss-forum`;

/*Table structure for table `content` */

DROP TABLE IF EXISTS `content`;

CREATE TABLE `content` (
  `id` varchar(8) NOT NULL,
  `topic_id` int(10) unsigned NOT NULL,
  `post_index` double unsigned NOT NULL,
  `post_type` enum('Main','Re') NOT NULL,
  `poster` text NOT NULL,
  `create_date` datetime NOT NULL,
  `content` longtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `date_rank` */

DROP TABLE IF EXISTS `date_rank`;

CREATE TABLE `date_rank` (
  `_date` date NOT NULL,
  `id` int(10) unsigned NOT NULL,
  `rank` int(10) unsigned NOT NULL,
  `replies` int(10) unsigned NOT NULL,
  `views` int(10) unsigned NOT NULL,
  PRIMARY KEY (`_date`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Table structure for table `metadata` */

DROP TABLE IF EXISTS `metadata`;

CREATE TABLE `metadata` (
  `id` int(10) unsigned NOT NULL,
  `topic` text NOT NULL,
  `poster` text NOT NULL,
  `link` text NOT NULL,
  `create_date` datetime NOT NULL,
  `last_post_date` datetime NOT NULL,
  `replies` int(10) unsigned NOT NULL,
  `views` int(10) unsigned NOT NULL,
  `rank` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/* Trigger structure for table `metadata` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `Rank_daily_I` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'admin'@'%' */ /*!50003 TRIGGER `Rank_daily_I` AFTER INSERT ON `metadata` FOR EACH ROW BEGIN
	INSERT INTO date_rank SET id = NEW.id, rank = NEW.rank, _date=NOW(), replies=NEW.replies, views=NEW.views ON DUPLICATE KEY UPDATE id=VALUES(id),rank=VALUES(rank),_date=VALUES(_date),replies=VALUES(replies),views=VALUES(views);
	/*INSERT INTO date_rank(id, rank, _date) VALUES(id=NEW.id, rank=NEW.rank, _date=NOW()) ON DUPLICATE KEY UPDATE id=VALUES(id),rank=VALUES(rank),_date=VALUES(_date);*/
    END */$$


DELIMITER ;

/* Trigger structure for table `metadata` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `Rank_daily_U` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'admin'@'%' */ /*!50003 TRIGGER `Rank_daily_U` AFTER UPDATE ON `metadata` FOR EACH ROW BEGIN
	INSERT INTO date_rank SET id = NEW.id, rank = NEW.rank, _date=NOW(), replies=NEW.replies, views=NEW.views ON DUPLICATE KEY UPDATE id=VALUES(id),rank=VALUES(rank),_date=VALUES(_date),replies=VALUES(replies),views=VALUES(views);
	/*INSERT INTO date_rank(id, rank, _date) VALUES(id=OLD.id, rank=OLD.rank, _date=NOW()) ON DUPLICATE KEY UPDATE id=VALUES(id),rank=VALUES(rank),_date=VALUES(_date);
	INSERT INTO date_rank(id, rank, _date) VALUES(id=NEW.id, rank=NEW.rank, _date=NOW()) ON DUPLICATE KEY UPDATE id=VALUES(id),rank=VALUES(rank),_date=VALUES(_date);*/
    END */$$


DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
