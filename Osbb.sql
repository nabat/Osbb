CREATE TABLE IF NOT EXISTS `osbb_ownership_types` (
  `id` TINYINT(3) UNSIGNED,
  `name` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`id`)
) COMMENT = 'Osbb ownership types';

REPLACE INTO `osbb_ownership_types` (`id`, `name`) VALUES
  (1, 'Приватизована'),
  (2, 'Комунальна'),
  (3, 'Відомча'),
  (4, 'Державна (бронь, без врахування надлишків)'),
  (5, 'Викуплена'),
  (6, 'Кооперативна'),
  (7, '-');

CREATE TABLE IF NOT EXISTS `osbb_main` (
  `uid` INT(10) UNSIGNED NOT NULL,
  `type` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `ownership_type` TINYINT(3) UNSIGNED REFERENCES `osbb_ownership_types` (`id`) ON DELETE RESTRICT,
  `total_area` DOUBLE(10, 2) UNSIGNED NOT NULL DEFAULT 0.00,
  `living_area` DOUBLE(10, 2) UNSIGNED NOT NULL DEFAULT 0.00,
  `utility_area` DOUBLE(10, 2) UNSIGNED NOT NULL DEFAULT 0.00,
  `balcony_area` DOUBLE(10, 2) UNSIGNED NOT NULL DEFAULT 0.00,
  `useful_area` DOUBLE(10, 2) UNSIGNED NOT NULL DEFAULT 0.00,
  `rooms_count` TINYINT(2) UNSIGNED NOT NULL DEFAULT 1,
  `people_count` TINYINT(2) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`uid`)
)
  COMMENT = 'OSBB users';


CREATE TABLE IF NOT EXISTS `osbb_area_types` (
  `id` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(200) NOT NULL DEFAULT '',
  `living_area` DOUBLE(10, 2) UNSIGNED NOT NULL DEFAULT '0.00',
  `utility_area` DOUBLE(10, 2) UNSIGNED NOT NULL DEFAULT '0.00',
  `total_area` DOUBLE(10, 2) UNSIGNED NOT NULL DEFAULT '0.00',
  `domain_id` SMALLINT(3) UNSIGNED NOT NULL DEFAULT '0',
  `comments` TEXT,
  UNIQUE KEY (`name`)
)
  COMMENT = 'OSBB area types';

CREATE TABLE IF NOT EXISTS `osbb_spending_types` (
  `id` INT(2) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL DEFAULT '',
  `comments` TEXT,
  PRIMARY KEY (`id`)
)
  COMMENT = 'OSBB spending types';

CREATE TABLE IF NOT EXISTS `osbb_tarifs` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(40) NOT NULL DEFAULT '',
  `unit` TINYINT(1) NOT NULL DEFAULT '0',
  `price` DOUBLE(10, 2) UNSIGNED NOT NULL DEFAULT '0.00',
  `document_base` VARCHAR(120) NOT NULL DEFAULT '',
  `start_date` DATE NOT NULL,
  `set_all` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `name` (`name`)
)
  COMMENT = 'Osbb Tarifs';

CREATE TABLE IF NOT EXISTS `osbb_users_services` (
  `id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` INT(10) UNSIGNED NOT NULL,
  `tp_id` SMALLINT(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `uid_tp` (`uid`, `tp_id`)
)
  COMMENT = 'Osbb Users Services';