CREATE DATABASE IF NOT EXISTS prompt_hub_test
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

GRANT ALL PRIVILEGES ON prompt_hub_test.* TO 'prompt_hub'@'%';
FLUSH PRIVILEGES;
