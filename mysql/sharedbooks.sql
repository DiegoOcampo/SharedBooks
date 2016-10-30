-- -----------------------------------------------------
-- Copyright 2016 SharedBooks
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--  http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- -----------------------------------------------------

-- MySQL Workbench Forward Engineering
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Table `cities`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cities`;
CREATE TABLE IF NOT EXISTS `cities` (
  `city_id` INT NOT NULL AUTO_INCREMENT,
  `name` NVARCHAR(45) NOT NULL,
  PRIMARY KEY (`city_id`),
  UNIQUE INDEX `city_id_UNIQUE` (`city_id` ASC),
  UNIQUE INDEX `city_name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `email` NVARCHAR(45) NOT NULL COMMENT 'Must be a valid email address',
  `password` BINARY(32) NOT NULL COMMENT 'md5 hash',
  `profile_img` MEDIUMBLOB NOT NULL,
  `real_name` NVARCHAR(50) NOT NULL,
  `city_id` INT NOT NULL,
  `address` NVARCHAR(45) NOT NULL COMMENT 'the address where the user wants to receive the books he buys',
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC),
  UNIQUE INDEX `user_email_UNIQUE` (`email` ASC),
  INDEX `fk_users_cities_idx` (`city_id` ASC),
  CONSTRAINT `fk_users_cities`
    FOREIGN KEY (`city_id`)
    REFERENCES `cities` (`city_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `categories`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `name` NVARCHAR(15) NOT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE INDEX `category_id_UNIQUE` (`category_id` ASC),
  UNIQUE INDEX `category_name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `books`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `books`;
CREATE TABLE IF NOT EXISTS `books` (
  `book_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `name` NVARCHAR(45) NOT NULL,
  `author` NVARCHAR(45) NOT NULL,
  `is_new` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 is new, 0 is second hand',
  `category_id` INT NOT NULL,
  `price` INT NOT NULL DEFAULT 0 COMMENT 'colombian pesos',
  `preview` NVARCHAR(255) NOT NULL COMMENT 'Link to a pdf with the book preview',
  `quantity` INT NOT NULL DEFAULT 1,
  `rate_sum` INT NOT NULL DEFAULT 0 COMMENT 'the sum of all the ratings that users have given this book',
  `rate_count` INT NOT NULL DEFAULT 0 COMMENT 'the number of users who have rated this book',
  PRIMARY KEY (`book_id`, `user_id`),
  UNIQUE INDEX `book_id_UNIQUE` (`book_id` ASC),
  INDEX `fk_books_users_idx` (`user_id` ASC),
  INDEX `fk_books_category_idx` (`category_id` ASC),
  CONSTRAINT `fk_books_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_books_categories`
    FOREIGN KEY (`category_id`)
    REFERENCES `categories` (`category_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `sales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sales`;
CREATE TABLE IF NOT EXISTS `sales` (
  `sales_id` INT NOT NULL AUTO_INCREMENT,
  `book_id` INT NOT NULL,
  `book_user_id` INT NOT NULL COMMENT 'user who sells the book',
  `user_id` INT NOT NULL COMMENT 'user who buys the book',
  `units` INT NOT NULL DEFAULT 1 COMMENT 'the number of units of the book that were bought',
  `sale_date` DATE NOT NULL,
  `sale_total` VARCHAR(45) NULL COMMENT 'the total price of the sale',
  PRIMARY KEY (`sales_id`, `book_id`, `book_user_id`, `user_id`),
  UNIQUE INDEX `sales_id_UNIQUE` (`sales_id` ASC),
  INDEX `fk_sales_books_idx` (`book_id` ASC, `book_user_id` ASC),
  INDEX `fk_sales_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_sales_books`
    FOREIGN KEY (`book_id` , `book_user_id`)
    REFERENCES `books` (`book_id` , `user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_sales_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
