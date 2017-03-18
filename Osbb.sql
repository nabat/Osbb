CREATE TABLE `osbb_main` (
  `uid` int(10) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `living_space` double(10,2) unsigned NOT NULL DEFAULT '0.00',
  `utility_room` double(10,2) unsigned NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`uid`)
) COMMENT='OSBB users';