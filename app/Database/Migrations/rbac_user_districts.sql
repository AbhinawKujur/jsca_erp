-- RBAC: user_districts table
-- Links users to the districts they are allowed to access.
-- If a user has no rows here (and is not superadmin), they see nothing.

CREATE TABLE IF NOT EXISTS `user_districts` (
  `id`          int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`     int(10) UNSIGNED NOT NULL,
  `district_id` int(10) UNSIGNED NOT NULL,
  `created_at`  datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_user_district` (`user_id`, `district_id`),
  KEY `idx_user`     (`user_id`),
  KEY `idx_district` (`district_id`),
  CONSTRAINT `fk_ud_user`     FOREIGN KEY (`user_id`)     REFERENCES `users`     (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ud_district` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
