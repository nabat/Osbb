CREATE TABLE `osbb_main` (
  `uid` int(10) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `living_space` double(10,2) unsigned NOT NULL DEFAULT '0.00',
  `utility_room` double(10,2) unsigned NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`uid`)
) COMMENT='OSBB users';


CREATE TABLE `osbb_area_types` (
  `id` tinyint(3) unsigned NOT NULL auto_increment PRIMARY KEY,
  `name` VARCHAR (200) NOT NULL DEFAULT '',
  `living_space` double(10,2) unsigned NOT NULL DEFAULT '0.00',
  `utility_room` double(10,2) unsigned NOT NULL DEFAULT '0.00',
  `total_space` double(10,2) unsigned NOT NULL DEFAULT '0.00',
  `comments` text,
  UNIQUE KEY (`name`)
) COMMENT='OSBB area types';

CREATE TABLE `osbb_spending_types` (
  `id` int(2) unsigned NOT NULL auto_increment,
  `name` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) COMMENT='OSBB spending types';