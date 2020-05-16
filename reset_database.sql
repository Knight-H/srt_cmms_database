-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema srt-db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `srt-db` ;

-- -----------------------------------------------------
-- Schema srt-db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `srt-db` DEFAULT CHARACTER SET utf8 ;
USE `srt-db` ;

-- -----------------------------------------------------
-- Table `srt-db`.`item_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`item_group` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`item_group` (
  `id` INT NOT NULL,
  `name` NVARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`uom_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`uom_group` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`uom_group` (
  `uom_group_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`uom_group_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`item` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`item` (
  `id` INT NOT NULL,
  `description` NVARCHAR(255) NULL,
  `item_group_id` INT NOT NULL,
  `active` BIT(1) NOT NULL,
  `remark` NVARCHAR(4096) NULL,
  `uom_group_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_item_item_group_idx` (`item_group_id` ASC) VISIBLE,
  INDEX `fk_item_uom_group1_idx` (`uom_group_id` ASC) VISIBLE,
  CONSTRAINT `fk_item_item_group`
    FOREIGN KEY (`item_group_id`)
    REFERENCES `srt-db`.`item_group` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_item_uom_group1`
    FOREIGN KEY (`uom_group_id`)
    REFERENCES `srt-db`.`uom_group` (`uom_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Add \"superseded_by\" & \"is_active\" column to indicate if the item is still being used';


-- -----------------------------------------------------
-- Table `srt-db`.`warehouse_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`warehouse_type` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`warehouse_type` (
  `warehouse_type_id` INT NOT NULL,
  `type` NVARCHAR(255) NOT NULL,
  PRIMARY KEY (`warehouse_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`warehouse`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`warehouse` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`warehouse` (
  `warehouse_id` INT NOT NULL,
  `name` NVARCHAR(255) NOT NULL,
  `location` VARCHAR(45) NULL,
  `warehouse_type_id` INT NOT NULL,
  `use_central` INT NOT NULL,
  PRIMARY KEY (`warehouse_id`),
  INDEX `fk_warehouse_warehouse_type1_idx` (`warehouse_type_id` ASC) VISIBLE,
  CONSTRAINT `fk_warehouse_warehouse_type1`
    FOREIGN KEY (`warehouse_type_id`)
    REFERENCES `srt-db`.`warehouse_type` (`warehouse_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`gender`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`gender` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`gender` (
  `gender_id` INT NOT NULL AUTO_INCREMENT,
  `gender` NVARCHAR(45) NOT NULL,
  PRIMARY KEY (`gender_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`title`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`title` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`title` (
  `title_id` INT NOT NULL,
  `prefix_en` VARCHAR(45) NOT NULL,
  `prefix_th` NVARCHAR(45) NOT NULL,
  PRIMARY KEY (`title_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`level`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`level` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`level` (
  `level_id` INT NOT NULL,
  `level` NVARCHAR(255) NOT NULL,
  `description` NVARCHAR(255) NULL,
  PRIMARY KEY (`level_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`user` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`user` (
  `user_id` INT NOT NULL,
  `employee_id` VARCHAR(45) NOT NULL,
  `username` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `national_id` VARCHAR(13) NULL,
  `password_hash` VARCHAR(255) NULL,
  `firstname_en` VARCHAR(255) NULL,
  `lastname_en` VARCHAR(255) NULL,
  `firstname_th` NVARCHAR(255) NULL,
  `lastname_th` NVARCHAR(255) NULL,
  `address` VARCHAR(255) NULL,
  `birthdate` DATE NULL,
  `phone` VARCHAR(15) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_approved` BIT(1) NULL,
  `active` BIT(1) NULL,
  `gender_id` INT NULL,
  `title_id` INT NULL,
  `level_id` INT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `employee_id_UNIQUE` (`employee_id` ASC) VISIBLE,
  INDEX `fk_user_gender1_idx` (`gender_id` ASC) VISIBLE,
  INDEX `fk_user_title1_idx` (`title_id` ASC) VISIBLE,
  INDEX `fk_user_level1_idx` (`level_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_gender1`
    FOREIGN KEY (`gender_id`)
    REFERENCES `srt-db`.`gender` (`gender_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_title1`
    FOREIGN KEY (`title_id`)
    REFERENCES `srt-db`.`title` (`title_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_level1`
    FOREIGN KEY (`level_id`)
    REFERENCES `srt-db`.`level` (`level_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`status_orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`status_orders` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`status_orders` (
  `id` INT NOT NULL,
  `status` VARCHAR(45) NULL,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`permission`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`permission` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`permission` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `modules_id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`purchase_orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`purchase_orders` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`purchase_orders` (
  `id` INT NOT NULL,
  `po_number` VARCHAR(45) NULL,
  `customers_id` INT NOT NULL,
  `to_address` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`maintenance_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`maintenance_type` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`maintenance_type` (
  `id` INT NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`position_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`position_group` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`position_group` (
  `position_group_id` INT NOT NULL,
  `name` NVARCHAR(45) NOT NULL,
  PRIMARY KEY (`position_group_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`position`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`position` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`position` (
  `position_id` INT NOT NULL,
  `name` NVARCHAR(255) NOT NULL,
  `abbreviation` NVARCHAR(45) NULL,
  `position_group_id` INT NULL,
  `warehouse_id` INT NULL,
  PRIMARY KEY (`position_id`),
  INDEX `fk_position_position_group1_idx` (`position_group_id` ASC) VISIBLE,
  INDEX `fk_position_warehouse1_idx` (`warehouse_id` ASC) VISIBLE,
  CONSTRAINT `fk_position_position_group1`
    FOREIGN KEY (`position_group_id`)
    REFERENCES `srt-db`.`position_group` (`position_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_position_warehouse1`
    FOREIGN KEY (`warehouse_id`)
    REFERENCES `srt-db`.`warehouse` (`warehouse_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`function`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`function` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`function` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`position_has_function`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`position_has_function` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`position_has_function` (
  `position_id` INT NOT NULL,
  `function_id` INT NOT NULL,
  PRIMARY KEY (`position_id`, `function_id`),
  INDEX `fk_asot_table_functions1_idx` (`function_id` ASC) VISIBLE,
  CONSTRAINT `fk_asot_table_organization_hierarchy1`
    FOREIGN KEY (`position_id`)
    REFERENCES `srt-db`.`position` (`position_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_asot_table_functions`
    FOREIGN KEY (`function_id`)
    REFERENCES `srt-db`.`function` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Which level has which function. If a function isn\'t there, it is implied that the function is OUTSIDE the level.\n';


-- -----------------------------------------------------
-- Table `srt-db`.`user_include_function`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`user_include_function` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`user_include_function` (
  `functions_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `include_function` BIT(1) NOT NULL COMMENT '0 = false, exclude said function\n1 = true, include said function',
  PRIMARY KEY (`user_id`, `functions_id`),
  INDEX `fk_user_include_function_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_asot_table_2_functions1`
    FOREIGN KEY (`functions_id`)
    REFERENCES `srt-db`.`function` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_include_function_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `srt-db`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Important: a row represent an EXCLUSION or INCLUSION of a function. Meaning\nthat 1 row can only meant the function is included or excluded.';


-- -----------------------------------------------------
-- Table `srt-db`.`category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`category` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`category` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Allow for grouping. ';


-- -----------------------------------------------------
-- Table `srt-db`.`category_has_functions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`category_has_functions` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`category_has_functions` (
  `category_id` INT NOT NULL,
  `functions_id` INT NOT NULL,
  PRIMARY KEY (`category_id`, `functions_id`),
  INDEX `fk_category_has_functions_functions1_idx` (`functions_id` ASC) VISIBLE,
  INDEX `fk_category_has_functions_category1_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `fk_category_has_functions_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `srt-db`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_category_has_functions_functions1`
    FOREIGN KEY (`functions_id`)
    REFERENCES `srt-db`.`function` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`document_type_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`document_type_group` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`document_type_group` (
  `document_type_group_id` INT NOT NULL,
  `name` NVARCHAR(4096) NOT NULL,
  `description` NVARCHAR(4096) NULL,
  PRIMARY KEY (`document_type_group_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`document_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`document_type` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`document_type` (
  `document_type_id` INT NOT NULL,
  `name` NVARCHAR(255) NOT NULL,
  `description` NVARCHAR(4096) NULL,
  `document_type_group_id` INT NOT NULL,
  `from_warehouse_type_id` INT NOT NULL,
  `to_warehouse_type_id` INT NOT NULL,
  PRIMARY KEY (`document_type_id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  INDEX `fk_document_type_warehouse_type1_idx` (`from_warehouse_type_id` ASC) VISIBLE,
  INDEX `fk_document_type_warehouse_type2_idx` (`to_warehouse_type_id` ASC) VISIBLE,
  INDEX `fk_document_type_document_type_group1_idx` (`document_type_group_id` ASC) VISIBLE,
  CONSTRAINT `fk_document_type_warehouse_type1`
    FOREIGN KEY (`from_warehouse_type_id`)
    REFERENCES `srt-db`.`warehouse_type` (`warehouse_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_document_type_warehouse_type2`
    FOREIGN KEY (`to_warehouse_type_id`)
    REFERENCES `srt-db`.`warehouse_type` (`warehouse_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_document_type_document_type_group1`
    FOREIGN KEY (`document_type_group_id`)
    REFERENCES `srt-db`.`document_type_group` (`document_type_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`document_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`document_status` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`document_status` (
  `document_status_id` INT NOT NULL,
  `status` VARCHAR(45) NULL,
  PRIMARY KEY (`document_status_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`document_action_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`document_action_type` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`document_action_type` (
  `document_action_type_id` INT NOT NULL,
  `action` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`document_action_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`document`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`document` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`document` (
  `document_id` INT NOT NULL AUTO_INCREMENT,
  `document_type_id` INT NOT NULL,
  `internal_document_id` NVARCHAR(45) NOT NULL,
  `created_on` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `remark` NVARCHAR(4096) NULL,
  `created_by_admin_id` INT NOT NULL,
  `created_by_user_id` INT NOT NULL,
  `document_status_id` INT NOT NULL,
  `document_action_type_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_document_document_type1_idx` (`document_type_id` ASC) VISIBLE,
  UNIQUE INDEX `internal_document_id_UNIQUE` (`internal_document_id` ASC) INVISIBLE,
  INDEX `fk_document_user1_idx` (`created_by_user_id` ASC) VISIBLE,
  INDEX `fk_document_document_status1_idx` (`document_status_id` ASC) INVISIBLE,
  INDEX `fk_document_user2_idx` (`created_by_admin_id` ASC) VISIBLE,
  INDEX `fk_document_document_action_type1_idx` (`document_action_type_id` ASC) VISIBLE,
  CONSTRAINT `fk_document_document_type1`
    FOREIGN KEY (`document_type_id`)
    REFERENCES `srt-db`.`document_type` (`document_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_document_user1`
    FOREIGN KEY (`created_by_user_id`)
    REFERENCES `srt-db`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_document_document_status1`
    FOREIGN KEY (`document_status_id`)
    REFERENCES `srt-db`.`document_status` (`document_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_document_user2`
    FOREIGN KEY (`created_by_admin_id`)
    REFERENCES `srt-db`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_document_document_action_type1`
    FOREIGN KEY (`document_action_type_id`)
    REFERENCES `srt-db`.`document_action_type` (`document_action_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`icd`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`icd` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`icd` (
  `document_id` INT NOT NULL,
  `dest_warehouse_id` INT NOT NULL,
  `src_warehouse_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_document_identifier_warehouse1_idx` (`dest_warehouse_id` ASC) VISIBLE,
  INDEX `fk_document_identifier_warehouse2_idx` (`src_warehouse_id` ASC) VISIBLE,
  INDEX `fk_icd_document1_idx` (`document_id` ASC) VISIBLE,
  CONSTRAINT `fk_document_identifier_warehouse1`
    FOREIGN KEY (`dest_warehouse_id`)
    REFERENCES `srt-db`.`warehouse` (`warehouse_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_document_identifier_warehouse2`
    FOREIGN KEY (`src_warehouse_id`)
    REFERENCES `srt-db`.`warehouse` (`warehouse_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_icd_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Common table for all other documents.\nTODO Add UNIQUE ( document_type, document_id )';


-- -----------------------------------------------------
-- Table `srt-db`.`document_attachment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`document_attachment` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`document_attachment` (
  `id` INT NOT NULL,
  `path` NVARCHAR(255) NOT NULL COMMENT 'Note name limit on any linux system seems to be 255 bytes (Not sure if byte or character) thus 255 is the max here\nNote path limit on any linux system seems to be 4096 bytes (Not sure if byte or character)\nTODO figure out the system path and name limit on installation',
  `document_id` INT NOT NULL,
  `name` NVARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_icd_attachment_document1_idx` (`document_id` ASC) VISIBLE,
  CONSTRAINT `fk_icd_attachment_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`approval_process_lookup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`approval_process_lookup` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`approval_process_lookup` (
  `approval_process_lookup_id` INT NOT NULL,
  `created_on` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `description` NVARCHAR(4096) NULL,
  PRIMARY KEY (`approval_process_lookup_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`approval_process`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`approval_process` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`approval_process` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `created_on` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NULL,
  `document_id` INT NOT NULL,
  `approval_process_lookup_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_approval_process_document1_idx` (`document_id` ASC) VISIBLE,
  INDEX `fk_approval_process_approval_process_lookup1_idx` (`approval_process_lookup_id` ASC) VISIBLE,
  CONSTRAINT `fk_approval_process_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_approval_process_approval_process_lookup1`
    FOREIGN KEY (`approval_process_lookup_id`)
    REFERENCES `srt-db`.`approval_process_lookup` (`approval_process_lookup_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`approval_step`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`approval_step` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`approval_step` (
  `approval_process_id` INT NOT NULL,
  `step_number` INT NOT NULL,
  `is_skipped` BIT(1) NOT NULL,
  PRIMARY KEY (`approval_process_id`, `step_number`),
  INDEX `fk_approval_step_approval_process1_idx` (`approval_process_id` ASC) VISIBLE,
  CONSTRAINT `fk_approval_step_approval_process1`
    FOREIGN KEY (`approval_process_id`)
    REFERENCES `srt-db`.`approval_process` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`approval_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`approval_status` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`approval_status` (
  `approval_status_id` INT NOT NULL,
  `name` NVARCHAR(45) NOT NULL,
  `description` NVARCHAR(4096) NULL,
  PRIMARY KEY (`approval_status_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`approval_by`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`approval_by` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`approval_by` (
  `id` INT NOT NULL,
  `approval_step_id` INT NOT NULL,
  `approval_status_id` INT NOT NULL DEFAULT 0,
  `user_id` INT NOT NULL,
  `position_group_id` INT NOT NULL,
  `approved_on` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `remark` VARCHAR(4096) NULL,
  `approval_step_approval_process_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_approval_by_approval_status1_idx` (`approval_status_id` ASC) VISIBLE,
  INDEX `fk_approval_by_user1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_approval_by_position_group1_idx` (`position_group_id` ASC) VISIBLE,
  INDEX `fk_approval_by_approval_step1_idx` (`approval_step_approval_process_id` ASC, `approval_step_id` ASC) VISIBLE,
  CONSTRAINT `fk_approval_by_approval_status1`
    FOREIGN KEY (`approval_status_id`)
    REFERENCES `srt-db`.`approval_status` (`approval_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_approval_by_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `srt-db`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_approval_by_position_group1`
    FOREIGN KEY (`position_group_id`)
    REFERENCES `srt-db`.`position_group` (`position_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_approval_by_approval_step1`
    FOREIGN KEY (`approval_step_approval_process_id` , `approval_step_id`)
    REFERENCES `srt-db`.`approval_step` (`approval_process_id` , `step_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`salvage_return`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`salvage_return` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`salvage_return` (
  `document_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_salvage_return_icd1_idx` (`document_id` ASC) VISIBLE,
  CONSTRAINT `fk_salvage_return_icd1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`icd` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`goods_receipt_po`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`goods_receipt_po` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`goods_receipt_po` (
  `document_id` INT NOT NULL,
  `po_id` NVARCHAR(45) NULL COMMENT 'ID of the purchase order document',
  PRIMARY KEY (`document_id`),
  INDEX `fk_goods_receipt_po_1_icd1_idx` (`document_id` ASC) VISIBLE,
  CONSTRAINT `fk_goods_receipt_po_1_icd1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`icd` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'This table is intended to document goods ordered (Purchased Order) into the system.\n\nGrainularity: 1 row = 1 Goods receipt which have multiple item type\nNOTE: Currently it is assumed that 1 goods receipt = ';


-- -----------------------------------------------------
-- Table `srt-db`.`uom`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`uom` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`uom` (
  `uom_code` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(45) NULL,
  `abbreviation` VARCHAR(45) NULL,
  `uom_group_id` INT NOT NULL,
  `is_default` BIT(1) NULL,
  PRIMARY KEY (`uom_code`),
  INDEX `fk_uom_uom_group1_idx` (`uom_group_id` ASC) VISIBLE,
  CONSTRAINT `fk_uom_uom_group1`
    FOREIGN KEY (`uom_group_id`)
    REFERENCES `srt-db`.`uom_group` (`uom_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`item_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`item_status` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`item_status` (
  `item_status_id` INT NOT NULL,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`item_status_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`icd_line_item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`icd_line_item` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`icd_line_item` (
  `document_id` INT NOT NULL,
  `line_number` INT NOT NULL,
  `quantity` INT NOT NULL,
  `uom_id` INT NOT NULL,
  `per_unit_price` DECIMAL(19,4) NOT NULL,
  `item_id` INT NOT NULL,
  `item_status_id` INT NOT NULL,
  PRIMARY KEY (`document_id`, `line_number`),
  INDEX `fk_has_item_unit_of_measurement1_idx` (`uom_id` ASC) VISIBLE,
  INDEX `fk_has_item_item1_idx` (`item_id` ASC) VISIBLE,
  INDEX `fk_icd_line_item_icd1_idx` (`document_id` ASC) VISIBLE,
  INDEX `fk_icd_line_item_item_status1_idx` (`item_status_id` ASC) VISIBLE,
  CONSTRAINT `fk_has_item_unit_of_measurement1`
    FOREIGN KEY (`uom_id`)
    REFERENCES `srt-db`.`uom` (`uom_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_has_item_item1`
    FOREIGN KEY (`item_id`)
    REFERENCES `srt-db`.`item` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_icd_line_item_icd1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`icd` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_icd_line_item_item_status1`
    FOREIGN KEY (`item_status_id`)
    REFERENCES `srt-db`.`item_status` (`item_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`inventory_transfer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`inventory_transfer` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`inventory_transfer` (
  `document_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_inventory_transfer_icd1_idx` (`document_id` ASC) VISIBLE,
  CONSTRAINT `fk_inventory_transfer_icd1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`icd` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`authority_transfer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`authority_transfer` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`authority_transfer` (
  `id` INT NOT NULL,
  `src_user_id` INT NOT NULL,
  `dest_user_id` INT NOT NULL,
  `date_start` DATETIME NOT NULL,
  `date_end` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_temporary_authority_transfer_user1_idx` (`src_user_id` ASC) VISIBLE,
  INDEX `fk_temporary_authority_transfer_user2_idx` (`dest_user_id` ASC) VISIBLE,
  CONSTRAINT `fk_temporary_authority_transfer_user1`
    FOREIGN KEY (`src_user_id`)
    REFERENCES `srt-db`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_temporary_authority_transfer_user2`
    FOREIGN KEY (`dest_user_id`)
    REFERENCES `srt-db`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`goods_return`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`goods_return` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`goods_return` (
  `document_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_goods_return_1_icd1_idx` (`document_id` ASC) VISIBLE,
  CONSTRAINT `fk_goods_return_1_icd1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`icd` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`goods_receipt_fix`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`goods_receipt_fix` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`goods_receipt_fix` (
  `document_id` INT NOT NULL,
  `fix_date` DATE NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_goods_receipt_fix_1_icd1_idx` (`document_id` ASC) VISIBLE,
  CONSTRAINT `fk_goods_receipt_fix_1_icd1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`icd` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`goods_receipt`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`goods_receipt` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`goods_receipt` (
  `document_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  CONSTRAINT `fk_goods_receipt_icd1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`icd` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`goods_issue`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`goods_issue` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`goods_issue` (
  `document_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  CONSTRAINT `fk_goods_issue_icd1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`icd` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`division`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`division` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`division` (
  `division_id` INT NOT NULL AUTO_INCREMENT,
  `name` NVARCHAR(255) NOT NULL,
  PRIMARY KEY (`division_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`district`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`district` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`district` (
  `district_id` INT NOT NULL COMMENT 'ระดับแขวง',
  `name` NVARCHAR(255) NOT NULL,
  `division_id` INT NOT NULL,
  PRIMARY KEY (`district_id`),
  INDEX `fk_location_district_location_division1_idx` (`division_id` ASC) VISIBLE,
  CONSTRAINT `fk_location_district_location_division1`
    FOREIGN KEY (`division_id`)
    REFERENCES `srt-db`.`division` (`division_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`node`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`node` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`node` (
  `node_id` INT NOT NULL COMMENT 'ระดับตอน',
  `name` NVARCHAR(255) NOT NULL,
  `district_id` INT NOT NULL,
  PRIMARY KEY (`node_id`),
  INDEX `fk_location_node_location_district1_idx` (`district_id` ASC) VISIBLE,
  CONSTRAINT `fk_location_node_location_district1`
    FOREIGN KEY (`district_id`)
    REFERENCES `srt-db`.`district` (`district_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`goods_fix`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`goods_fix` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`goods_fix` (
  `document_id` INT NOT NULL,
  `fix_date` DATE NULL,
  `location_node_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_goods_fix_icd1_idx` (`document_id` ASC) VISIBLE,
  INDEX `fk_goods_fix_location_node1_idx` (`location_node_id` ASC) VISIBLE,
  CONSTRAINT `fk_goods_fix_icd1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`icd` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_goods_fix_location_node1`
    FOREIGN KEY (`location_node_id`)
    REFERENCES `srt-db`.`node` (`node_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`salvage_sold`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`salvage_sold` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`salvage_sold` (
  `document_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_salvage_sold_1_icd1_idx` (`document_id` ASC) VISIBLE,
  CONSTRAINT `fk_salvage_sold_1_icd1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`icd` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`user_has_position`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`user_has_position` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`user_has_position` (
  `user_id` INT NOT NULL,
  `position_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `position_id`),
  INDEX `fk_user_has_position_position1_idx` (`position_id` ASC) VISIBLE,
  INDEX `fk_user_has_position_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_position_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `srt-db`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_position_position1`
    FOREIGN KEY (`position_id`)
    REFERENCES `srt-db`.`position` (`position_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`position_hierarchy`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`position_hierarchy` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`position_hierarchy` (
  `ancestor_id` INT NOT NULL,
  `decendant_id` INT NOT NULL,
  `path_length` INT NOT NULL,
  `is_root` BIT(1) NOT NULL,
  PRIMARY KEY (`ancestor_id`, `decendant_id`),
  INDEX `fk_position_has_position_position2_idx` (`decendant_id` ASC) VISIBLE,
  INDEX `fk_position_has_position_position1_idx` (`ancestor_id` ASC) VISIBLE,
  CONSTRAINT `fk_position_has_position_position1`
    FOREIGN KEY (`ancestor_id`)
    REFERENCES `srt-db`.`position` (`position_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_position_has_position_position2`
    FOREIGN KEY (`decendant_id`)
    REFERENCES `srt-db`.`position` (`position_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`station`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`station` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`station` (
  `station_id` INT NOT NULL COMMENT 'ระดับสถานี',
  `name` NVARCHAR(255) NOT NULL,
  `node_id` INT NOT NULL,
  PRIMARY KEY (`station_id`),
  INDEX `fk_location_station_location_node1_idx` (`node_id` ASC) VISIBLE,
  CONSTRAINT `fk_location_station_location_node1`
    FOREIGN KEY (`node_id`)
    REFERENCES `srt-db`.`node` (`node_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`equipment_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`equipment_group` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`equipment_group` (
  `equipment_group_id` INT NOT NULL,
  `name` NVARCHAR(255) NOT NULL,
  `description` NVARCHAR(4096) NULL,
  PRIMARY KEY (`equipment_group_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`equipment_item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`equipment_item` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`equipment_item` (
  `item_id` INT NOT NULL,
  `useful_life` INT NULL,
  `equipment_group_id` INT NOT NULL,
  PRIMARY KEY (`item_id`),
  INDEX `fk_equipment_item_equipment_group1_idx` (`equipment_group_id` ASC) VISIBLE,
  CONSTRAINT `fk_item_fixed_asset_item1`
    FOREIGN KEY (`item_id`)
    REFERENCES `srt-db`.`item` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_equipment_item_equipment_group1`
    FOREIGN KEY (`equipment_group_id`)
    REFERENCES `srt-db`.`equipment_group` (`equipment_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`equipment_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`equipment_status` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`equipment_status` (
  `equipment_status_id` INT NOT NULL,
  `status` VARCHAR(45) NULL,
  PRIMARY KEY (`equipment_status_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`equipment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`equipment` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`equipment` (
  `equipment_id` INT NOT NULL,
  `serial_no` VARCHAR(45) NOT NULL,
  `equipment_item_id` INT NOT NULL,
  `equipment_status_id` INT NOT NULL,
  `cost` DECIMAL(19,4) NULL,
  `location_station_id` INT NULL,
  `imported_on` DATE NOT NULL,
  `remark` NVARCHAR(4096) NULL,
  INDEX `fk_fixed_asset_location_station1_idx` (`location_station_id` ASC) VISIBLE,
  INDEX `fk_equipment_item_equipment_idx` (`equipment_item_id` ASC) VISIBLE,
  PRIMARY KEY (`equipment_id`),
  INDEX `fk_equipment_fa_status1_idx` (`equipment_status_id` ASC) VISIBLE,
  CONSTRAINT `fk_fixed_asset_location_station1`
    FOREIGN KEY (`location_station_id`)
    REFERENCES `srt-db`.`station` (`station_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fixed_asset_item_fixed_asset1`
    FOREIGN KEY (`equipment_item_id`)
    REFERENCES `srt-db`.`equipment_item` (`item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_equipment_fa_status1`
    FOREIGN KEY (`equipment_status_id`)
    REFERENCES `srt-db`.`equipment_status` (`equipment_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`work_request`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`work_request` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`work_request` (
  `document_id` INT NOT NULL,
  `accident` NVARCHAR(255) NULL,
  `request_by` NVARCHAR(255) NULL,
  `accident_on` DATETIME NULL,
  `responsible_by` NVARCHAR(255) NULL,
  `location_node_id` INT NULL,
  `location_detail` VARCHAR(4025) NULL,
  `remark` NVARCHAR(4025) NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_work_request_location_node1_idx` (`location_node_id` ASC) VISIBLE,
  INDEX `fk_work_request_document1_idx` (`document_id` ASC) VISIBLE,
  CONSTRAINT `fk_work_request_location_node1`
    FOREIGN KEY (`location_node_id`)
    REFERENCES `srt-db`.`node` (`node_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_work_request_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`system_type_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`system_type_group` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`system_type_group` (
  `system_type_group_id` INT NOT NULL,
  `system_type_group` NVARCHAR(255) NULL,
  PRIMARY KEY (`system_type_group_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`system_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`system_type` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`system_type` (
  `system_type_id` INT NOT NULL,
  `system_type` NVARCHAR(255) NULL,
  `system_type_group_id` INT NOT NULL,
  PRIMARY KEY (`system_type_id`),
  INDEX `fk_sub_maintenance_type_main_system1_idx` (`system_type_group_id` ASC) VISIBLE,
  CONSTRAINT `fk_sub_maintenance_type_main_system1`
    FOREIGN KEY (`system_type_group_id`)
    REFERENCES `srt-db`.`system_type_group` (`system_type_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`car_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`car_type` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`car_type` (
  `car_id` INT NOT NULL,
  `car_type` NVARCHAR(255) NULL,
  PRIMARY KEY (`car_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`case_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`case_type` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`case_type` (
  `case_id` INT NOT NULL,
  `description` NVARCHAR(255) NULL,
  PRIMARY KEY (`case_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`accident_cause`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`accident_cause` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`accident_cause` (
  `cause_id` INT NOT NULL,
  `cause` NVARCHAR(255) NULL,
  PRIMARY KEY (`cause_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`interrupt`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`interrupt` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`interrupt` (
  `interrupt_id` INT NOT NULL,
  `interrupt_type` NVARCHAR(255) NULL,
  PRIMARY KEY (`interrupt_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`service_method`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`service_method` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`service_method` (
  `sm_id` INT NOT NULL AUTO_INCREMENT,
  `sm_method_type` VARCHAR(45) NULL,
  PRIMARY KEY (`sm_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`hardware_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`hardware_type` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`hardware_type` (
  `hardware_type_id` INT NOT NULL,
  `hardware_type` NVARCHAR(255) NULL,
  PRIMARY KEY (`hardware_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`recv_accident_from`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`recv_accident_from` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`recv_accident_from` (
  `recv_id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`recv_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`ss101`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`ss101` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`ss101` (
  `document_id` INT NOT NULL,
  `name` NVARCHAR(255) NULL,
  `accident_on` DATETIME NULL,
  `recv_on` DATETIME NULL,
  `arrived_on` DATETIME NULL,
  `finished_on` DATETIME NULL,
  `total_fail_time` DECIMAL(10,2) NULL,
  `recv_accident_from_id` INT NOT NULL,
  `recv_accident_from_desc` NVARCHAR(255) NULL,
  `case_id` INT NULL,
  `cause_id` INT NULL,
  `summary_cause_condition` NVARCHAR(4096) NULL,
  `loss` DECIMAL(19,4) NULL,
  `car_type_id` INT NULL,
  `interrupt_id` INT NULL,
  `service_method_id` INT NULL,
  `service_method_desc` NVARCHAR(4096) NULL,
  `location_node_id` INT NULL,
  `location_station_id` INT NULL,
  `location_desc` NVARCHAR(4096) NULL,
  `hardware_type_id` INT NULL,
  `member_1` NVARCHAR(255) NULL,
  `member_2` NVARCHAR(255) NULL,
  `member_3` NVARCHAR(255) NULL,
  `remark` NVARCHAR(4096) NULL,
  `sub_maintenance_type_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_doc_error101_accident_cause1_idx` (`cause_id` ASC) VISIBLE,
  INDEX `fk_ss101_car_type1_idx` (`car_type_id` ASC) VISIBLE,
  INDEX `fk_ss101_interrupt1_idx` (`interrupt_id` ASC) VISIBLE,
  INDEX `fk_ss101_service_method1_idx` (`service_method_id` ASC) VISIBLE,
  INDEX `fk_ss101_accident_case1_idx` (`case_id` ASC) VISIBLE,
  INDEX `fk_ss101_hardware_mt1_idx` (`hardware_type_id` ASC) VISIBLE,
  INDEX `fk_ss101_sub_maintenance_type1_idx` (`sub_maintenance_type_id` ASC) VISIBLE,
  INDEX `fk_wo_ss101_document1_idx` (`document_id` ASC) VISIBLE,
  INDEX `fk_wo_ss101_location_node1_idx` (`location_node_id` ASC) VISIBLE,
  INDEX `fk_wo_ss101_recv_accident_from1_idx` (`recv_accident_from_id` ASC) VISIBLE,
  INDEX `fk_ss101_location_station1_idx` (`location_station_id` ASC) VISIBLE,
  CONSTRAINT `fk_doc_error101_accident_cause1`
    FOREIGN KEY (`cause_id`)
    REFERENCES `srt-db`.`accident_cause` (`cause_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ss101_car_type1`
    FOREIGN KEY (`car_type_id`)
    REFERENCES `srt-db`.`car_type` (`car_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ss101_interrupt1`
    FOREIGN KEY (`interrupt_id`)
    REFERENCES `srt-db`.`interrupt` (`interrupt_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ss101_service_method1`
    FOREIGN KEY (`service_method_id`)
    REFERENCES `srt-db`.`service_method` (`sm_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ss101_accident_case1`
    FOREIGN KEY (`case_id`)
    REFERENCES `srt-db`.`case_type` (`case_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ss101_hardware_mt1`
    FOREIGN KEY (`hardware_type_id`)
    REFERENCES `srt-db`.`hardware_type` (`hardware_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ss101_sub_maintenance_type1`
    FOREIGN KEY (`sub_maintenance_type_id`)
    REFERENCES `srt-db`.`system_type` (`system_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_wo_ss101_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_wo_ss101_location_node1`
    FOREIGN KEY (`location_node_id`)
    REFERENCES `srt-db`.`node` (`node_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_wo_ss101_recv_accident_from1`
    FOREIGN KEY (`recv_accident_from_id`)
    REFERENCES `srt-db`.`recv_accident_from` (`recv_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ss101_location_station1`
    FOREIGN KEY (`location_station_id`)
    REFERENCES `srt-db`.`station` (`station_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`loss_line_item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`loss_line_item` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`loss_line_item` (
  `document_id` INT NOT NULL,
  `id` INT NOT NULL,
  `description` VARCHAR(255) NULL,
  `quantity` DECIMAL(9,4) NULL,
  `uom_code` INT NOT NULL,
  `price` DECIMAL(19,4) NULL,
  `item_id` INT NULL,
  `remark` NVARCHAR(4096) NULL,
  PRIMARY KEY (`document_id`, `id`),
  INDEX `fk_loss_line_item_item1_idx` (`item_id` ASC) VISIBLE,
  INDEX `fk_loss_line_item_uom1_idx` (`uom_code` ASC) VISIBLE,
  CONSTRAINT `fk_loss_line_item_ss1011`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`ss101` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_loss_line_item_item1`
    FOREIGN KEY (`item_id`)
    REFERENCES `srt-db`.`item` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_loss_line_item_uom1`
    FOREIGN KEY (`uom_code`)
    REFERENCES `srt-db`.`uom` (`uom_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`freq_unit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`freq_unit` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`freq_unit` (
  `freq_unit_id` INT NOT NULL,
  `unit_type` NVARCHAR(45) NOT NULL,
  PRIMARY KEY (`freq_unit_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`document_reference`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`document_reference` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`document_reference` (
  `document_id` INT NOT NULL,
  `refer_to_document_id` INT NOT NULL,
  PRIMARY KEY (`document_id`, `refer_to_document_id`),
  INDEX `fk_document_has_document_document2_idx` (`refer_to_document_id` ASC) VISIBLE,
  INDEX `fk_document_has_document_document1_idx` (`document_id` ASC) VISIBLE,
  CONSTRAINT `fk_document_has_document_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_document_has_document_document2`
    FOREIGN KEY (`refer_to_document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`icd_line_item_reference`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`icd_line_item_reference` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`icd_line_item_reference` (
  `document_id` INT NOT NULL,
  `icd_line_item_id` INT NOT NULL,
  `refers_to_document_id` INT NOT NULL,
  `refers_to_icd_line_item_id` INT NOT NULL,
  PRIMARY KEY (`document_id`, `icd_line_item_id`, `refers_to_document_id`, `refers_to_icd_line_item_id`),
  INDEX `fk_icd_line_item_has_icd_line_item_icd_line_item2_idx` (`refers_to_document_id` ASC, `refers_to_icd_line_item_id` ASC) VISIBLE,
  INDEX `fk_icd_line_item_has_icd_line_item_icd_line_item1_idx` (`document_id` ASC, `icd_line_item_id` ASC) VISIBLE,
  CONSTRAINT `fk_icd_line_item_has_icd_line_item_icd_line_item1`
    FOREIGN KEY (`document_id` , `icd_line_item_id`)
    REFERENCES `srt-db`.`icd_line_item` (`document_id` , `line_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_icd_line_item_has_icd_line_item_icd_line_item2`
    FOREIGN KEY (`refers_to_document_id` , `refers_to_icd_line_item_id`)
    REFERENCES `srt-db`.`icd_line_item` (`document_id` , `line_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`item_inventory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`item_inventory` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`item_inventory` (
  `item_id` INT NOT NULL,
  `warehouse_id` INT NOT NULL,
  `item_status_id` INT NOT NULL,
  `begin_unit_count` DECIMAL(9,4) NULL,
  `receive_unit_count` DECIMAL(9,4) NULL,
  `issue_unit_count` DECIMAL(9,4) NULL,
  `state_in_unit_count` DECIMAL(9,4) NULL,
  `state_out_unit_count` DECIMAL(9,4) NULL,
  `adjustment_unit_count` DECIMAL(9,4) NULL,
  `current_unit_count` DECIMAL(9,4) NULL,
  PRIMARY KEY (`item_id`, `warehouse_id`, `item_status_id`),
  INDEX `fk_item_inventory_warehouse1_idx` (`warehouse_id` ASC) VISIBLE,
  INDEX `fk_item_inventory_item_status1_idx` (`item_status_id` ASC) VISIBLE,
  CONSTRAINT `fk_item_inventory_item1`
    FOREIGN KEY (`item_id`)
    REFERENCES `srt-db`.`item` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_item_inventory_warehouse1`
    FOREIGN KEY (`warehouse_id`)
    REFERENCES `srt-db`.`warehouse` (`warehouse_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_item_inventory_item_status1`
    FOREIGN KEY (`item_status_id`)
    REFERENCES `srt-db`.`item_status` (`item_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`physical_count`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`physical_count` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`physical_count` (
  `document_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  CONSTRAINT `fk_physical_count_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`physical_count_line_item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`physical_count_line_item` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`physical_count_line_item` (
  `id` INT NOT NULL,
  `document_id` INT NOT NULL,
  `count_datetime` DATETIME NULL,
  `unit_count` DECIMAL(9,4) NULL,
  `item_status_id` INT NOT NULL,
  `item_id` INT NOT NULL,
  `warehouse_id` INT NOT NULL,
  PRIMARY KEY (`id`, `document_id`),
  INDEX `fk_physical_count_line_item_physical_count1_idx` (`document_id` ASC) VISIBLE,
  INDEX `fk_physical_count_line_item_item_status1_idx` (`item_status_id` ASC) VISIBLE,
  INDEX `fk_physical_count_line_item_item1_idx` (`item_id` ASC) VISIBLE,
  INDEX `fk_physical_count_line_item_warehouse1_idx` (`warehouse_id` ASC) VISIBLE,
  CONSTRAINT `fk_physical_count_line_item_physical_count1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`physical_count` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_physical_count_line_item_item_status1`
    FOREIGN KEY (`item_status_id`)
    REFERENCES `srt-db`.`item_status` (`item_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_physical_count_line_item_item1`
    FOREIGN KEY (`item_id`)
    REFERENCES `srt-db`.`item` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_physical_count_line_item_warehouse1`
    FOREIGN KEY (`warehouse_id`)
    REFERENCES `srt-db`.`warehouse` (`warehouse_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`inventory_adjustment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`inventory_adjustment` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`inventory_adjustment` (
  `document_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  CONSTRAINT `fk_inventory_adjustment_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`inventory_adjustment_line_item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`inventory_adjustment_line_item` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`inventory_adjustment_line_item` (
  `id` INT NOT NULL,
  `document_id` INT NOT NULL,
  `adjustment_datetime` DATETIME NULL,
  `unit_count` DECIMAL(9,4) NULL,
  `item_status_id` INT NOT NULL,
  `item_id` INT NOT NULL,
  `warehouse_id` INT NOT NULL,
  PRIMARY KEY (`id`, `document_id`),
  INDEX `fk_inventory_adjustment_line_item_inventory_adjustment1_idx` (`document_id` ASC) VISIBLE,
  INDEX `fk_inventory_adjustment_line_item_item_status1_idx` (`item_status_id` ASC) VISIBLE,
  INDEX `fk_inventory_adjustment_line_item_item1_idx` (`item_id` ASC) VISIBLE,
  INDEX `fk_inventory_adjustment_line_item_warehouse1_idx` (`warehouse_id` ASC) VISIBLE,
  CONSTRAINT `fk_inventory_adjustment_line_item_inventory_adjustment1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`inventory_adjustment` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inventory_adjustment_line_item_item_status1`
    FOREIGN KEY (`item_status_id`)
    REFERENCES `srt-db`.`item_status` (`item_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inventory_adjustment_line_item_item1`
    FOREIGN KEY (`item_id`)
    REFERENCES `srt-db`.`item` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_inventory_adjustment_line_item_warehouse1`
    FOREIGN KEY (`warehouse_id`)
    REFERENCES `srt-db`.`warehouse` (`warehouse_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`item_inventory_journal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`item_inventory_journal` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`item_inventory_journal` (
  `item_inventory_journal_id` INT NOT NULL,
  `document_id` INT NOT NULL,
  `icd_line_number` INT NOT NULL,
  `item_id` INT NOT NULL,
  `warehouse_id` INT NOT NULL,
  `item_status_id` INT NOT NULL,
  `physical_count_document_id` INT NULL,
  `physical_count_line_item_id` INT NULL,
  `inventory_adjustment_document_id` INT NULL,
  `inventory_adjustment_line_item_id` INT NULL,
  `created_on` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `change_unit_count` DECIMAL(9,4) NOT NULL,
  PRIMARY KEY (`item_inventory_journal_id`),
  INDEX `fk_item_inventory_journal_icd_line_item1_idx` (`document_id` ASC, `icd_line_number` ASC) VISIBLE,
  INDEX `fk_item_inventory_journal_item_inventory1_idx` (`item_id` ASC, `warehouse_id` ASC, `item_status_id` ASC) VISIBLE,
  INDEX `fk_item_inventory_journal_physical_count_line_item1_idx` (`physical_count_line_item_id` ASC, `physical_count_document_id` ASC) VISIBLE,
  INDEX `fk_item_inventory_journal_inventory_adjustment_line_item1_idx` (`inventory_adjustment_line_item_id` ASC, `inventory_adjustment_document_id` ASC) VISIBLE,
  CONSTRAINT `fk_item_inventory_journal_icd_line_item1`
    FOREIGN KEY (`document_id` , `icd_line_number`)
    REFERENCES `srt-db`.`icd_line_item` (`document_id` , `line_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_item_inventory_journal_item_inventory1`
    FOREIGN KEY (`item_id` , `warehouse_id` , `item_status_id`)
    REFERENCES `srt-db`.`item_inventory` (`item_id` , `warehouse_id` , `item_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_item_inventory_journal_physical_count_line_item1`
    FOREIGN KEY (`physical_count_line_item_id` , `physical_count_document_id`)
    REFERENCES `srt-db`.`physical_count_line_item` (`id` , `document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_item_inventory_journal_inventory_adjustment_line_item1`
    FOREIGN KEY (`inventory_adjustment_line_item_id` , `inventory_adjustment_document_id`)
    REFERENCES `srt-db`.`inventory_adjustment_line_item` (`id` , `document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`reporting_period`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`reporting_period` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`reporting_period` (
  `reporting_period_id` INT NOT NULL,
  `start_datetime` DATETIME NULL,
  `end_datetime` DATETIME NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`reporting_period_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`item_inventory_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`item_inventory_history` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`item_inventory_history` (
  `reporting_period_id` INT NOT NULL,
  `item_id` INT NOT NULL,
  `warehouse_id` INT NOT NULL,
  `item_status_id` INT NOT NULL,
  `begin_unit_count` DECIMAL(9,4) NULL,
  `receive_unit_count` DECIMAL(9,4) NULL,
  `issue_unit_count` DECIMAL(9,4) NULL,
  `state_in_unit_count` DECIMAL(9,4) NULL,
  `state_out_unit_count` DECIMAL(9,4) NULL,
  `adjustment_unit_count` DECIMAL(9,4) NULL,
  `ending_unit_count` DECIMAL(9,4) NULL,
  PRIMARY KEY (`reporting_period_id`, `item_id`, `warehouse_id`, `item_status_id`),
  INDEX `fk_item_inventory_history_item_inventory1_idx` (`item_id` ASC, `warehouse_id` ASC, `item_status_id` ASC) VISIBLE,
  CONSTRAINT `fk_item_inventory_history_reporting_period1`
    FOREIGN KEY (`reporting_period_id`)
    REFERENCES `srt-db`.`reporting_period` (`reporting_period_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_item_inventory_history_item_inventory1`
    FOREIGN KEY (`item_id` , `warehouse_id` , `item_status_id`)
    REFERENCES `srt-db`.`item_inventory` (`item_id` , `warehouse_id` , `item_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`work_order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`work_order` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`work_order` (
  `document_id` INT NOT NULL,
  `request_by` NVARCHAR(255) NULL,
  `work_requestcol` NVARCHAR(255) NULL,
  `accident_name` NVARCHAR(255) NULL,
  `root_cause` NVARCHAR(4025) NULL,
  `remark` NVARCHAR(4025) NULL,
  `recv_accident_from_recv_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_work_order_recv_accident_from1_idx` (`recv_accident_from_recv_id` ASC) VISIBLE,
  CONSTRAINT `fk_work_order_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_work_order_recv_accident_from1`
    FOREIGN KEY (`recv_accident_from_recv_id`)
    REFERENCES `srt-db`.`recv_accident_from` (`recv_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`equipment_status_log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`equipment_status_log` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`equipment_status_log` (
  `equipment_id` INT NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `document_id` INT NOT NULL,
  `fa_status_id` INT NOT NULL,
  PRIMARY KEY (`equipment_id`, `timestamp`),
  INDEX `fk_document_has_fixed_asset_document1_idx` (`document_id` ASC) VISIBLE,
  INDEX `fk_document_action_to_fa_fa_status1_idx` (`fa_status_id` ASC) VISIBLE,
  INDEX `fk_doc_action_to_fa_equipment1_idx` (`equipment_id` ASC) VISIBLE,
  CONSTRAINT `fk_document_has_fixed_asset_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_document_action_to_fa_fa_status1`
    FOREIGN KEY (`fa_status_id`)
    REFERENCES `srt-db`.`equipment_status` (`equipment_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_doc_action_to_fa_equipment1`
    FOREIGN KEY (`equipment_id`)
    REFERENCES `srt-db`.`equipment` (`equipment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`checklist_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`checklist_group` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`checklist_group` (
  `checklist_group_id` INT NOT NULL,
  PRIMARY KEY (`checklist_group_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`checklist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`checklist` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`checklist` (
  `checklist_id` INT NOT NULL,
  `checklist_group_id` INT NOT NULL,
  `checklist_name` NVARCHAR(255) NOT NULL,
  `remark` NVARCHAR(4096) NULL,
  INDEX `fk_checklist_checklist_group1_idx` (`checklist_group_id` ASC) VISIBLE,
  PRIMARY KEY (`checklist_id`),
  CONSTRAINT `fk_checklist_checklist_group1`
    FOREIGN KEY (`checklist_group_id`)
    REFERENCES `srt-db`.`checklist_group` (`checklist_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`checklist_equipment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`checklist_equipment` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`checklist_equipment` (
  `checklist_group_id` INT NOT NULL,
  `equipment_item_id` INT NOT NULL,
  PRIMARY KEY (`checklist_group_id`),
  INDEX `fk_checklist_equipment_equipment_item1_idx` (`equipment_item_id` ASC) VISIBLE,
  CONSTRAINT `fk_checklist_fa_checklist1`
    FOREIGN KEY (`checklist_group_id`)
    REFERENCES `srt-db`.`checklist` (`checklist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_checklist_equipment_equipment_item1`
    FOREIGN KEY (`equipment_item_id`)
    REFERENCES `srt-db`.`equipment_item` (`item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`checklist_custom`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`checklist_custom` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`checklist_custom` (
  `checklist_group_id` INT NOT NULL,
  `quantity` DECIMAL(9,4) NOT NULL,
  `uom_code` INT NOT NULL,
  `serial_number` NVARCHAR(255) NULL,
  PRIMARY KEY (`checklist_group_id`),
  INDEX `fk_checklist_custom_group_uom1_idx` (`uom_code` ASC) VISIBLE,
  CONSTRAINT `fk_checklist_custom_checklist1`
    FOREIGN KEY (`checklist_group_id`)
    REFERENCES `srt-db`.`checklist` (`checklist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_checklist_custom_group_uom1`
    FOREIGN KEY (`uom_code`)
    REFERENCES `srt-db`.`uom` (`uom_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`checklist_line_item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`checklist_line_item` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`checklist_line_item` (
  `checklist_id` INT NOT NULL,
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `freq` INT NOT NULL,
  `freq_unit_id` INT NOT NULL,
  `start_on` DATE NOT NULL,
  `active` BIT(1) NOT NULL,
  `remark` NVARCHAR(4096) NULL,
  INDEX `fk_checklist_line_item_freq_unit1_idx` (`freq_unit_id` ASC) VISIBLE,
  INDEX `fk_checklist_line_item_checklist1_idx` (`checklist_id` ASC) VISIBLE,
  PRIMARY KEY (`checklist_id`, `id`),
  CONSTRAINT `fk_checklist_line_item_freq_unit1`
    FOREIGN KEY (`freq_unit_id`)
    REFERENCES `srt-db`.`freq_unit` (`freq_unit_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_checklist_line_item_checklist1`
    FOREIGN KEY (`checklist_id`)
    REFERENCES `srt-db`.`checklist` (`checklist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`checklist_equipment_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`checklist_equipment_group` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`checklist_equipment_group` (
  `checklist_group_id` INT NOT NULL,
  `equipment_group_id` INT NOT NULL,
  PRIMARY KEY (`checklist_group_id`),
  INDEX `fk_checklist_equipment_group_equipment_group1_idx` (`equipment_group_id` ASC) VISIBLE,
  CONSTRAINT `fk_type_checklist_fa_group_checklist_group1`
    FOREIGN KEY (`checklist_group_id`)
    REFERENCES `srt-db`.`checklist_group` (`checklist_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_checklist_equipment_group_equipment_group1`
    FOREIGN KEY (`equipment_group_id`)
    REFERENCES `srt-db`.`equipment_group` (`equipment_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`checklist_custom_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`checklist_custom_group` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`checklist_custom_group` (
  `checklist_group_id` INT NOT NULL,
  `checklist_group_name` NVARCHAR(255) NULL,
  PRIMARY KEY (`checklist_group_id`),
  CONSTRAINT `fk_type_checklist_custom_group_checklist_group1`
    FOREIGN KEY (`checklist_group_id`)
    REFERENCES `srt-db`.`checklist_group` (`checklist_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`node_has_checklist_custom_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`node_has_checklist_custom_group` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`node_has_checklist_custom_group` (
  `location_node_id` INT NOT NULL,
  `checklist_group_id` INT NOT NULL,
  PRIMARY KEY (`location_node_id`, `checklist_group_id`),
  INDEX `fk_district_has_maintenance_group_location_node1_idx` (`location_node_id` ASC) VISIBLE,
  INDEX `fk_location_district_has_maintenance_group_maintenance_grou_idx` (`checklist_group_id` ASC) VISIBLE,
  CONSTRAINT `fk_location_district_has_maintenance_group_maintenance_group1`
    FOREIGN KEY (`checklist_group_id`)
    REFERENCES `srt-db`.`checklist_custom_group` (`checklist_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_district_has_maintenance_group_location_node1`
    FOREIGN KEY (`location_node_id`)
    REFERENCES `srt-db`.`node` (`node_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`work_order_pm`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`work_order_pm` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`work_order_pm` (
  `document_id` INT NOT NULL,
  `location_node_id` INT NOT NULL,
  `checklist_id` INT NOT NULL,
  `name` NVARCHAR(255) NOT NULL,
  `status` BIT(1) NOT NULL,
  `remark` NVARCHAR(4096) NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_wo_maintenance_plan_checklist1_idx` (`checklist_id` ASC) VISIBLE,
  INDEX `fk_wo_maintenance_plan_location_node1_idx` (`location_node_id` ASC) VISIBLE,
  CONSTRAINT `fk_wo_maintenance_plan_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_wo_maintenance_plan_checklist1`
    FOREIGN KEY (`checklist_id`)
    REFERENCES `srt-db`.`checklist` (`checklist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_wo_maintenance_plan_location_node1`
    FOREIGN KEY (`location_node_id`)
    REFERENCES `srt-db`.`node` (`node_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`equipment_installation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`equipment_installation` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`equipment_installation` (
  `document_id` INT NOT NULL,
  `equipment_id` INT NOT NULL,
  `installed_on` DATETIME NULL,
  `location_remark` VARCHAR(255) NULL,
  `location_station_id` INT NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_fa_installation_location_station1_idx` (`location_station_id` ASC) VISIBLE,
  INDEX `fk_fa_installation_equipment1_idx` (`equipment_id` ASC) VISIBLE,
  CONSTRAINT `fk_fa_installation_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fa_installation_location_station1`
    FOREIGN KEY (`location_station_id`)
    REFERENCES `srt-db`.`station` (`station_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fa_installation_equipment1`
    FOREIGN KEY (`equipment_id`)
    REFERENCES `srt-db`.`equipment` (`equipment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`goods_maintenance`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`goods_maintenance` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`goods_maintenance` (
  `document_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  CONSTRAINT `fk_fa_installation_document2`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`notification`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`notification` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`notification` (
  `notification_id` INT NOT NULL,
  `user_id_recipient` INT NOT NULL,
  `is_read` BIT(1) NOT NULL,
  `document_type_id` INT NOT NULL,
  `document_id` INT NOT NULL,
  `action_document` VARCHAR(45) NULL,
  `url` VARCHAR(45) NULL,
  PRIMARY KEY (`notification_id`, `user_id_recipient`),
  INDEX `fk_notification_user2_idx` (`user_id_recipient` ASC) VISIBLE,
  INDEX `fk_notification_document_type1_idx` (`document_type_id` ASC) VISIBLE,
  INDEX `fk_notification_document1_idx` (`document_id` ASC) VISIBLE,
  CONSTRAINT `fk_notification_user2`
    FOREIGN KEY (`user_id_recipient`)
    REFERENCES `srt-db`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_notification_document_type1`
    FOREIGN KEY (`document_type_id`)
    REFERENCES `srt-db`.`document_type` (`document_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_notification_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`checklist_line_item_use_equipment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`checklist_line_item_use_equipment` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`checklist_line_item_use_equipment` (
  `checklist_id` INT NOT NULL,
  `checklist_line_item_id` INT NOT NULL,
  `item_id` INT NOT NULL,
  `quantity` DECIMAL(9,4) NOT NULL,
  `uom_id` INT NOT NULL,
  INDEX `fk_use_maintenance_equipment_uom1_idx` (`uom_id` ASC) VISIBLE,
  INDEX `fk_use_maintenance_equipment_item1_idx` (`item_id` ASC) VISIBLE,
  PRIMARY KEY (`checklist_id`, `checklist_line_item_id`, `item_id`),
  INDEX `fk_use_maintenance_equipment_checklist_line_item1_idx` (`checklist_id` ASC, `checklist_line_item_id` ASC) VISIBLE,
  CONSTRAINT `fk_use_maintenance_equipment_uom1`
    FOREIGN KEY (`uom_id`)
    REFERENCES `srt-db`.`uom` (`uom_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_use_maintenance_equipment_item1`
    FOREIGN KEY (`item_id`)
    REFERENCES `srt-db`.`item` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_use_maintenance_equipment_checklist_line_item1`
    FOREIGN KEY (`checklist_id` , `checklist_line_item_id`)
    REFERENCES `srt-db`.`checklist_line_item` (`checklist_id` , `id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`uom_conversion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`uom_conversion` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`uom_conversion` (
  `convert_from_uom_code` INT NOT NULL,
  `convert_to_uom_code` INT NOT NULL,
  `amount` DECIMAL(9,4) NULL,
  `description` VARCHAR(255) NULL COMMENT 'A short text representation of the formula used to convert between two distinct units of measure. For example to convert degrees celcius to degrees Fahrenheit use F=(C * 9/5)+32. It requires a little more information that a simple ratio.',
  PRIMARY KEY (`convert_from_uom_code`, `convert_to_uom_code`),
  INDEX `fk_uom_has_uom_uom2_idx` (`convert_to_uom_code` ASC) VISIBLE,
  INDEX `fk_uom_has_uom_uom1_idx` (`convert_from_uom_code` ASC) VISIBLE,
  CONSTRAINT `fk_uom_has_uom_uom1`
    FOREIGN KEY (`convert_from_uom_code`)
    REFERENCES `srt-db`.`uom` (`uom_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_uom_has_uom_uom2`
    FOREIGN KEY (`convert_to_uom_code`)
    REFERENCES `srt-db`.`uom` (`uom_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`approval_step_action`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`approval_step_action` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`approval_step_action` (
  `approval_step_action_id` INT NOT NULL,
  `action` NVARCHAR(255) NOT NULL,
  PRIMARY KEY (`approval_step_action_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`approval_step_lookup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`approval_step_lookup` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`approval_step_lookup` (
  `approval_process_lookup_id` INT NOT NULL,
  `step_number` INT NOT NULL,
  `step_last_number` INT NOT NULL,
  `position_group_id` INT NOT NULL,
  `approval_step_action_id` INT NOT NULL,
  `is_destination` BIT(1) NOT NULL,
  `escalated_approval_process_lookup_id` INT NOT NULL,
  `skippable_same_previous_position_group` BIT(1) NOT NULL,
  `skippable_same_between_position_group` BIT(1) NOT NULL,
  `description` NVARCHAR(4096) NULL,
  PRIMARY KEY (`approval_process_lookup_id`, `step_number`),
  INDEX `fk_approval_step_lookup_approval_process_lookup1_idx` (`approval_process_lookup_id` ASC) VISIBLE,
  INDEX `fk_approval_step_lookup_position_group1_idx` (`position_group_id` ASC) VISIBLE,
  INDEX `fk_approval_step_lookup_approval_step_action1_idx` (`approval_step_action_id` ASC) VISIBLE,
  INDEX `fk_approval_step_lookup_approval_process_lookup2_idx` (`escalated_approval_process_lookup_id` ASC) VISIBLE,
  CONSTRAINT `fk_approval_step_lookup_approval_process_lookup1`
    FOREIGN KEY (`approval_process_lookup_id`)
    REFERENCES `srt-db`.`approval_process_lookup` (`approval_process_lookup_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_approval_step_lookup_position_group1`
    FOREIGN KEY (`position_group_id`)
    REFERENCES `srt-db`.`position_group` (`position_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_approval_step_lookup_approval_step_action1`
    FOREIGN KEY (`approval_step_action_id`)
    REFERENCES `srt-db`.`approval_step_action` (`approval_step_action_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_approval_step_lookup_approval_process_lookup2`
    FOREIGN KEY (`escalated_approval_process_lookup_id`)
    REFERENCES `srt-db`.`approval_process_lookup` (`approval_process_lookup_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`goods_maintenance_line_item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`goods_maintenance_line_item` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`goods_maintenance_line_item` (
  `document_id` INT NOT NULL,
  `id` INT NOT NULL,
  `quantity_damaged` INT NULL,
  `quantity_used` INT NULL,
  `quantity_salvage` INT NULL,
  INDEX `fk_table1_fa_maintenance1_idx` (`document_id` ASC) VISIBLE,
  PRIMARY KEY (`document_id`, `id`),
  CONSTRAINT `fk_table1_fa_maintenance1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`goods_maintenance` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`goods_usage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`goods_usage` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`goods_usage` (
  `document_id` INT NOT NULL,
  PRIMARY KEY (`document_id`),
  CONSTRAINT `fk_goods_usage_icd1`
    FOREIGN KEY (`document_id`)
    REFERENCES `srt-db`.`icd` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `srt-db`.`document_type_approval_process_lookup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `srt-db`.`document_type_approval_process_lookup` ;

CREATE TABLE IF NOT EXISTS `srt-db`.`document_type_approval_process_lookup` (
  `document_type_id` INT NOT NULL,
  `document_action_type_id` INT NOT NULL,
  `version_number` INT NOT NULL,
  `approval_process_lookup_id` INT NOT NULL,
  `start_on` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_on` DATETIME NULL,
  `active` BIT(1) NOT NULL,
  `remark` NVARCHAR(4096) NULL,
  PRIMARY KEY (`document_type_id`, `document_action_type_id`, `version_number`),
  INDEX `fk_document_type_has_approval_process_lookup_approval_proce_idx` (`approval_process_lookup_id` ASC) VISIBLE,
  INDEX `fk_document_type_has_approval_process_lookup_document_type1_idx` (`document_type_id` ASC) VISIBLE,
  INDEX `fk_document_type_approval_process_lookup_document_action_ty_idx` (`document_action_type_id` ASC) VISIBLE,
  CONSTRAINT `fk_document_type_has_approval_process_lookup_document_type1`
    FOREIGN KEY (`document_type_id`)
    REFERENCES `srt-db`.`document_type` (`document_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_document_type_has_approval_process_lookup_approval_process1`
    FOREIGN KEY (`approval_process_lookup_id`)
    REFERENCES `srt-db`.`approval_process_lookup` (`approval_process_lookup_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_document_type_approval_process_lookup_document_action_type1`
    FOREIGN KEY (`document_action_type_id`)
    REFERENCES `srt-db`.`document_action_type` (`document_action_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
