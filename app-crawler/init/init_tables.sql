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