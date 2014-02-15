-- Wordpress db
create database wordpress;
grant all privileges on wordpress.* to "wordpress"@"localhost"
    identified by "wordpress";

-- concrete5 db
create database concrete5;
grant all privileges on concrete5.* to "concrete5"@"localhost"
    identified by "concrete5";

-- symfony db
create database symfony;
grant all privileges on symfony.* to "symfony"@"localhost"
    identified by "symfony";

-- laravel db
create database laravel;
grant all privileges on laravel.* to "laravel"@"localhost"
    identified by "laravel";

-- drupal db
create database drupal;
grant all privileges on drupal.* to "drupal"@"localhost"
    identified by "drupal";

flush privileges;
    
