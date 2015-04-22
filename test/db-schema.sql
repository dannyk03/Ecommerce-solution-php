-- MySQL dump 10.13  Distrib 5.6.19, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: imaginer_system
-- ------------------------------------------------------
-- Server version	5.6.19-0ubuntu0.14.04.1-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `action_log`
--

DROP TABLE IF EXISTS `action_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `website_id` int(11) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `extra` text,
  `date_created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `INDEX` (`website_id`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2486 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_craigslist`
--

DROP TABLE IF EXISTS `analytics_craigslist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_craigslist` (
  `website_id` int(11) NOT NULL,
  `craigslist_market_id` int(11) NOT NULL,
  `craigslist_tag_id` int(11) NOT NULL,
  `unique` int(11) NOT NULL,
  `views` int(11) NOT NULL,
  `posts` int(11) NOT NULL,
  `date` datetime NOT NULL,
  KEY `object_id` (`website_id`,`craigslist_market_id`,`craigslist_tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `analytics_emails`
--

DROP TABLE IF EXISTS `analytics_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `analytics_emails` (
  `mc_campaign_id` varchar(50) NOT NULL,
  `ac_campaign_id` int(11) DEFAULT NULL,
  `syntax_errors` int(11) NOT NULL,
  `hard_bounces` int(11) NOT NULL,
  `soft_bounces` int(11) NOT NULL,
  `unsubscribes` int(11) NOT NULL,
  `abuse_reports` int(11) NOT NULL,
  `forwards` int(11) NOT NULL,
  `forwards_opens` int(11) NOT NULL,
  `opens` int(11) NOT NULL,
  `unique_opens` int(11) NOT NULL,
  `last_open` datetime NOT NULL,
  `clicks` int(11) NOT NULL,
  `unique_clicks` int(11) NOT NULL,
  `last_click` datetime NOT NULL,
  `users_who_clicked` int(11) NOT NULL,
  `emails_sent` int(11) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `mc_campaign_id` (`mc_campaign_id`),
  UNIQUE KEY `ac_campaign_id` (`ac_campaign_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `api_ext_log`
--

DROP TABLE IF EXISTS `api_ext_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_ext_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `api` varchar(45) DEFAULT NULL,
  `method` varchar(100) DEFAULT NULL,
  `url` varchar(200) DEFAULT NULL,
  `request` text,
  `raw_request` text,
  `response` text,
  `raw_response` text,
  `date_created` datetime DEFAULT NULL,
  `date_updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `INDEX` (`api`)
) ENGINE=InnoDB AUTO_INCREMENT=203879 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `api_key_ashley_account`
--

DROP TABLE IF EXISTS `api_key_ashley_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_key_ashley_account` (
  `api_key_id` int(11) NOT NULL DEFAULT '0',
  `ashley_account` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`api_key_id`,`ashley_account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `api_key_brand`
--

DROP TABLE IF EXISTS `api_key_brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_key_brand` (
  `api_key_id` int(11) NOT NULL DEFAULT '0',
  `brand_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`api_key_id`,`brand_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `api_keys`
--

DROP TABLE IF EXISTS `api_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_keys` (
  `api_key_id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `key` varchar(32) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `date_created` datetime NOT NULL,
  `api_keyscol` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`api_key_id`),
  KEY `company_id` (`company_id`,`user_id`,`brand_id`),
  CONSTRAINT `fk_ak` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `api_log`
--

DROP TABLE IF EXISTS `api_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_log` (
  `api_log_id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `type` varchar(20) NOT NULL,
  `method` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `success` tinyint(1) NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`api_log_id`),
  KEY `company_id` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1144145 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `api_settings`
--

DROP TABLE IF EXISTS `api_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_settings` (
  `api_key_id` int(11) NOT NULL,
  `key` varchar(200) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`api_key_id`,`key`),
  KEY `fk_as_idx` (`api_key_id`),
  CONSTRAINT `fk_as` FOREIGN KEY (`api_key_id`) REFERENCES `api_keys` (`api_key_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attribute_item_relations`
--

DROP TABLE IF EXISTS `attribute_item_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_item_relations` (
  `attribute_item_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  PRIMARY KEY (`product_id`,`attribute_item_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attribute_items`
--

DROP TABLE IF EXISTS `attribute_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_items` (
  `attribute_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `attribute_id` int(11) NOT NULL,
  `attribute_item_name` text NOT NULL,
  `sequence` int(11) NOT NULL,
  PRIMARY KEY (`attribute_item_id`),
  KEY `attribute_id` (`attribute_id`),
  FULLTEXT KEY `attribute_item_name` (`attribute_item_name`)
) ENGINE=MyISAM AUTO_INCREMENT=6434 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attribute_relations`
--

DROP TABLE IF EXISTS `attribute_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_relations` (
  `attribute_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  KEY `category_id` (`category_id`),
  KEY `fk_ar_idx` (`attribute_id`),
  CONSTRAINT `fk_ar` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`attribute_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_ar2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attributes`
--

DROP TABLE IF EXISTS `attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attributes` (
  `attribute_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`attribute_id`)
) ENGINE=InnoDB AUTO_INCREMENT=468 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_user_websites`
--

DROP TABLE IF EXISTS `auth_user_websites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_websites` (
  `auth_user_website_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `website_id` int(11) NOT NULL,
  `pages` tinyint(1) NOT NULL DEFAULT '0',
  `products` tinyint(1) NOT NULL DEFAULT '0',
  `analytics` tinyint(1) NOT NULL DEFAULT '0',
  `blog` tinyint(1) NOT NULL DEFAULT '0',
  `email_marketing` tinyint(1) NOT NULL DEFAULT '0',
  `geo_marketing` int(1) NOT NULL DEFAULT '0',
  `shopping_cart` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`auth_user_website_id`),
  KEY `user_id` (`user_id`,`website_id`),
  KEY `fk_auw_idx` (`website_id`),
  KEY `fk_auw2_idx` (`user_id`),
  CONSTRAINT `fk_auw` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_auw2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5317 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `brands`
--

DROP TABLE IF EXISTS `brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `brands` (
  `brand_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `link` varchar(200) NOT NULL,
  `image` varchar(200) NOT NULL,
  PRIMARY KEY (`brand_id`),
  KEY `name_2` (`name`),
  FULLTEXT KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=997 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_category_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `google_taxonomy` varchar(255) NOT NULL,
  `sequence` int(11) NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=1601 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `checklist_items`
--

DROP TABLE IF EXISTS `checklist_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `checklist_items` (
  `checklist_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `checklist_section_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `assigned_to` varchar(100) NOT NULL,
  `section` varchar(100) NOT NULL,
  `sequence` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`checklist_item_id`),
  KEY `fk_ci_idx` (`checklist_section_id`),
  CONSTRAINT `fk_ci` FOREIGN KEY (`checklist_section_id`) REFERENCES `checklist_sections` (`checklist_section_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `checklist_sections`
--

DROP TABLE IF EXISTS `checklist_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `checklist_sections` (
  `checklist_section_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `sequence` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`checklist_section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `checklist_website_item_notes`
--

DROP TABLE IF EXISTS `checklist_website_item_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `checklist_website_item_notes` (
  `checklist_website_item_note_id` int(11) NOT NULL AUTO_INCREMENT,
  `checklist_website_item_id` int(11) NOT NULL,
  `note` text NOT NULL,
  `user_id` int(11) NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`checklist_website_item_note_id`),
  KEY `checklist_item_id` (`checklist_website_item_id`),
  CONSTRAINT `fk_cwin` FOREIGN KEY (`checklist_website_item_id`) REFERENCES `checklist_website_items` (`checklist_website_item_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7494 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `checklist_website_items`
--

DROP TABLE IF EXISTS `checklist_website_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `checklist_website_items` (
  `checklist_website_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `checklist_id` int(11) NOT NULL,
  `checklist_item_id` int(11) NOT NULL,
  `checked` tinyint(1) NOT NULL DEFAULT '0',
  `date_checked` datetime DEFAULT NULL,
  PRIMARY KEY (`checklist_website_item_id`),
  KEY `checklist_id` (`checklist_id`,`checklist_item_id`),
  KEY `fk_cwi_idx` (`checklist_id`),
  KEY `fk_cwi2_idx` (`checklist_item_id`),
  CONSTRAINT `fk_cwi` FOREIGN KEY (`checklist_id`) REFERENCES `checklists` (`checklist_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_cwi2` FOREIGN KEY (`checklist_item_id`) REFERENCES `checklist_items` (`checklist_item_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=76758 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `checklists`
--

DROP TABLE IF EXISTS `checklists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `checklists` (
  `checklist_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `type` varchar(100) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_finished` datetime DEFAULT NULL,
  PRIMARY KEY (`checklist_id`),
  KEY `fk_c_idx` (`website_id`),
  CONSTRAINT `fk_c` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1669 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `companies` (
  `company_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `domain` varchar(100) NOT NULL,
  `email` varchar(200) NOT NULL,
  `status` int(1) NOT NULL DEFAULT '1',
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `less` text,
  `css` text,
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `company_packages`
--

DROP TABLE IF EXISTS `company_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_packages` (
  `company_package_id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `website_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`company_package_id`),
  KEY `company_id` (`company_id`,`website_id`),
  KEY `fk_cp_idx` (`company_id`),
  CONSTRAINT `fk_cp` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `craigslist_ad_headlines`
--

DROP TABLE IF EXISTS `craigslist_ad_headlines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craigslist_ad_headlines` (
  `craigslist_ad_id` int(11) NOT NULL,
  `headline` varchar(250) NOT NULL,
  KEY `craigslist_ad_id` (`craigslist_ad_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `craigslist_ad_markets`
--

DROP TABLE IF EXISTS `craigslist_ad_markets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craigslist_ad_markets` (
  `craigslist_ad_id` int(11) NOT NULL,
  `craigslist_market_id` int(11) NOT NULL,
  `primus_product_id` int(11) NOT NULL,
  PRIMARY KEY (`craigslist_ad_id`,`craigslist_market_id`,`primus_product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `craigslist_ads`
--

DROP TABLE IF EXISTS `craigslist_ads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craigslist_ads` (
  `craigslist_ad_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `text` text NOT NULL,
  `price` float NOT NULL,
  `error` text NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_posted` datetime NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`craigslist_ad_id`),
  KEY `website_id` (`website_id`,`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2694 DEFAULT CHARSET=utf8 COMMENT='Craigslist ads that account-side customers post';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `craigslist_categories`
--

DROP TABLE IF EXISTS `craigslist_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craigslist_categories` (
  `craigslist_category_id` int(11) NOT NULL AUTO_INCREMENT,
  `craigslist_category_code` varchar(3) NOT NULL,
  `category_name` varchar(50) NOT NULL,
  PRIMARY KEY (`craigslist_category_id`),
  UNIQUE KEY `craigslist_category_code` (`craigslist_category_code`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `craigslist_cities`
--

DROP TABLE IF EXISTS `craigslist_cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craigslist_cities` (
  `craigslist_city_id` int(11) NOT NULL AUTO_INCREMENT,
  `craigslist_city_code` varchar(3) NOT NULL,
  `city_name` varchar(20) NOT NULL,
  `state_name` varchar(20) NOT NULL,
  `country` varchar(20) NOT NULL,
  PRIMARY KEY (`craigslist_city_id`),
  UNIQUE KEY `craigslist_city_code` (`craigslist_city_code`)
) ENGINE=InnoDB AUTO_INCREMENT=708 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `craigslist_districts`
--

DROP TABLE IF EXISTS `craigslist_districts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craigslist_districts` (
  `craigslist_district_id` int(11) NOT NULL AUTO_INCREMENT,
  `craigslist_district_code` varchar(5) NOT NULL,
  `name` varchar(50) NOT NULL,
  `craigslist_city_id` int(11) NOT NULL,
  PRIMARY KEY (`craigslist_district_id`),
  KEY `craigslist_city_id` (`craigslist_city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `craigslist_headlines`
--

DROP TABLE IF EXISTS `craigslist_headlines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craigslist_headlines` (
  `craigslist_headline_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL,
  `headline` text NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`craigslist_headline_id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `craigslist_market_links`
--

DROP TABLE IF EXISTS `craigslist_market_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craigslist_market_links` (
  `website_id` int(11) NOT NULL,
  `craigslist_market_id` int(11) NOT NULL,
  `market_id` int(11) NOT NULL,
  `cl_category_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`website_id`,`craigslist_market_id`,`market_id`,`cl_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `craigslist_markets`
--

DROP TABLE IF EXISTS `craigslist_markets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craigslist_markets` (
  `craigslist_market_id` int(11) NOT NULL AUTO_INCREMENT,
  `cl_market_id` int(11) NOT NULL,
  `parent_market_id` int(11) NOT NULL,
  `state` varchar(30) NOT NULL,
  `city` varchar(100) NOT NULL,
  `area` varchar(100) NOT NULL,
  `submarket` tinyint(1) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`craigslist_market_id`),
  UNIQUE KEY `state` (`state`,`city`,`area`)
) ENGINE=InnoDB AUTO_INCREMENT=575 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `craigslist_tags`
--

DROP TABLE IF EXISTS `craigslist_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craigslist_tags` (
  `craigslist_tag_id` int(11) NOT NULL,
  `object_id` int(11) NOT NULL,
  `type` enum('category','product') NOT NULL,
  PRIMARY KEY (`craigslist_tag_id`),
  KEY `category_id` (`object_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `craigslist_templates`
--

DROP TABLE IF EXISTS `craigslist_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `craigslist_templates` (
  `craigslist_template_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL,
  `title` varchar(250) NOT NULL,
  `description` text NOT NULL,
  `publish_visibility` text NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`craigslist_template_id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_associations`
--

DROP TABLE IF EXISTS `email_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_associations` (
  `email_id` int(11) NOT NULL,
  `email_list_id` int(11) NOT NULL,
  PRIMARY KEY (`email_id`,`email_list_id`),
  KEY `fk_eas_idx` (`email_id`),
  KEY `fk_eas2_idx` (`email_list_id`),
  CONSTRAINT `fk_eas` FOREIGN KEY (`email_id`) REFERENCES `emails` (`email_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_eas2` FOREIGN KEY (`email_list_id`) REFERENCES `email_lists` (`email_list_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_autoresponders`
--

DROP TABLE IF EXISTS `email_autoresponders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_autoresponders` (
  `email_autoresponder_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `email_list_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(100) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `current_offer` tinyint(1) NOT NULL DEFAULT '0',
  `default` tinyint(1) NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`email_autoresponder_id`),
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_ea` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1252 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_import_emails`
--

DROP TABLE IF EXISTS `email_import_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_import_emails` (
  `website_id` int(11) NOT NULL,
  `email` varchar(200) NOT NULL,
  `name` varchar(100) NOT NULL,
  `date_created` datetime NOT NULL,
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_eie` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_lists`
--

DROP TABLE IF EXISTS `email_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_lists` (
  `email_list_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL DEFAULT '0',
  `ac_list_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`email_list_id`),
  KEY `fk_el_idx` (`website_id`),
  CONSTRAINT `fk_el` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6880 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_message_associations`
--

DROP TABLE IF EXISTS `email_message_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_message_associations` (
  `email_message_id` int(11) NOT NULL,
  `email_list_id` int(11) NOT NULL,
  KEY `email_message_id` (`email_message_id`,`email_list_id`),
  KEY `fk_ema_idx` (`email_message_id`),
  KEY `fk_ema2_idx` (`email_list_id`),
  CONSTRAINT `fk_ema` FOREIGN KEY (`email_message_id`) REFERENCES `email_messages` (`email_message_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_ema2` FOREIGN KEY (`email_list_id`) REFERENCES `email_lists` (`email_list_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_message_meta`
--

DROP TABLE IF EXISTS `email_message_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_message_meta` (
  `email_message_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `value` text NOT NULL,
  KEY `email_message_id` (`email_message_id`,`type`),
  KEY `fk_emm_idx` (`email_message_id`),
  CONSTRAINT `fk_emm` FOREIGN KEY (`email_message_id`) REFERENCES `email_messages` (`email_message_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_messages`
--

DROP TABLE IF EXISTS `email_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_messages` (
  `email_message_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `email_template_id` int(11) NOT NULL,
  `mc_campaign_id` varchar(50) NOT NULL,
  `ac_campaign_id` int(11) DEFAULT NULL,
  `ac_message_id` int(11) DEFAULT NULL,
  `subject` varchar(150) NOT NULL,
  `message` text NOT NULL,
  `type` varchar(50) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `date_sent` datetime NOT NULL,
  `date_created` datetime NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `from` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`email_message_id`),
  KEY `website_id` (`website_id`),
  KEY `ac_index` (`ac_message_id`,`ac_campaign_id`),
  CONSTRAINT `fk_em` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3136 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_template_associations`
--

DROP TABLE IF EXISTS `email_template_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_template_associations` (
  `email_template_id` int(11) NOT NULL,
  `website_id` int(11) NOT NULL,
  KEY `email_template_id` (`email_template_id`),
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_eta` FOREIGN KEY (`email_template_id`) REFERENCES `email_templates` (`email_template_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_eta2` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_template_options`
--

DROP TABLE IF EXISTS `email_template_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_template_options` (
  `email_template_id` int(11) NOT NULL,
  `key` varchar(50) NOT NULL,
  `value` text NOT NULL,
  KEY `email_template_id` (`email_template_id`),
  CONSTRAINT `fk_eto` FOREIGN KEY (`email_template_id`) REFERENCES `email_templates` (`email_template_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_templates`
--

DROP TABLE IF EXISTS `email_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_templates` (
  `email_template_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `template` text NOT NULL,
  `image` varchar(150) NOT NULL,
  `thumbnail` varchar(150) NOT NULL,
  `type` varchar(30) NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`email_template_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3321 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `emails`
--

DROP TABLE IF EXISTS `emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emails` (
  `email_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `email` varchar(200) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `date_created` datetime NOT NULL,
  `date_unsubscribed` datetime NOT NULL,
  `date_synced` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`email_id`),
  KEY `email` (`email`),
  KEY `fk_e_idx` (`website_id`),
  CONSTRAINT `fk_e` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=406921 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `index_products`
--

DROP TABLE IF EXISTS `index_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `index_products` (
  `product_id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `industry_id` int(11) NOT NULL DEFAULT '1',
  `website_id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `sku` varchar(100) NOT NULL,
  `price` float NOT NULL,
  `price_min` float NOT NULL,
  `weight` float NOT NULL,
  `volume` float NOT NULL,
  `product_specifications` text NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `alternate_price` float NOT NULL,
  `sale_price` float NOT NULL,
  `wholesale_price` float NOT NULL,
  `inventory` int(11) NOT NULL,
  `additional_shipping_amount` float NOT NULL,
  `protection_amount` float NOT NULL,
  `additional_shipping_type` varchar(20) NOT NULL,
  `alternate_price_name` varchar(30) NOT NULL DEFAULT 'List Price',
  `meta_title` varchar(200) NOT NULL,
  `meta_description` varchar(250) NOT NULL,
  `meta_keywords` varchar(200) NOT NULL,
  `protection_type` varchar(20) NOT NULL,
  `price_note` varchar(100) NOT NULL,
  `product_note` text NOT NULL,
  `ships_in` varchar(60) NOT NULL,
  `store_sku` varchar(30) NOT NULL,
  `warranty_length` varchar(60) NOT NULL,
  `alternate_price_strikethrough` tinyint(1) NOT NULL,
  `display_inventory` tinyint(1) NOT NULL,
  `on_sale` tinyint(1) NOT NULL,
  `sequence` int(11) NOT NULL DEFAULT '100000',
  `manual_price` int(1) NOT NULL DEFAULT '0',
  `setup_fee` float DEFAULT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `brand` varchar(200) NOT NULL,
  `category` varchar(200) NOT NULL,
  `industry` varchar(200) NOT NULL,
  `tags` varchar(200) DEFAULT NULL,
  `is_ashley_express` tinyint(1) NOT NULL DEFAULT '0',
  `image` varchar(200) DEFAULT NULL,
  `attribute_items` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`product_id`,`website_id`),
  KEY `slug` (`slug`),
  KEY `sku` (`sku`,`name`),
  KEY `brand_id` (`brand_id`,`industry_id`,`website_id`,`category_id`),
  KEY `local_products_category_id` (`category_id`),
  KEY `website_id` (`website_id`),
  FULLTEXT KEY `name` (`name`,`description`,`sku`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `industries`
--

DROP TABLE IF EXISTS `industries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `industries` (
  `industry_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`industry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kb_article`
--

DROP TABLE IF EXISTS `kb_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_article` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kb_category_id` int(11) DEFAULT NULL,
  `kb_page_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `slug` varchar(100) DEFAULT NULL,
  `content` text,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `date_created` datetime DEFAULT NULL,
  `date_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`kb_page_id`,`kb_category_id`,`user_id`),
  KEY `fk_kba_idx` (`kb_category_id`),
  KEY `fk_kba2_idx` (`kb_page_id`),
  FULLTEXT KEY `FULLTEXT` (`title`,`content`),
  CONSTRAINT `fk_kba` FOREIGN KEY (`kb_category_id`) REFERENCES `kb_category` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kb_article_rating`
--

DROP TABLE IF EXISTS `kb_article_rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_article_rating` (
  `kb_article_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` tinyint(4) NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `UNIQUE` (`kb_article_id`,`user_id`),
  KEY `kb_article_id` (`kb_article_id`,`timestamp`,`rating`,`user_id`),
  KEY `fk_kbar_idx` (`kb_article_id`),
  CONSTRAINT `fk_kbar` FOREIGN KEY (`kb_article_id`) REFERENCES `kb_article` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kb_article_view`
--

DROP TABLE IF EXISTS `kb_article_view`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_article_view` (
  `kb_article_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `kb_article_id` (`user_id`,`kb_article_id`,`timestamp`),
  KEY `fk_kbav_idx` (`kb_article_id`),
  CONSTRAINT `fk_kbav` FOREIGN KEY (`kb_article_id`) REFERENCES `kb_article` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kb_category`
--

DROP TABLE IF EXISTS `kb_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `section` enum('account','admin') DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `FULLTEXT` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kb_page`
--

DROP TABLE IF EXISTS `kb_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kb_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kb_category_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kb_category_id` (`kb_category_id`),
  FULLTEXT KEY `FULLTEXT` (`name`),
  CONSTRAINT `fk_category_id` FOREIGN KEY (`kb_category_id`) REFERENCES `kb_category` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=156 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mobile_associations`
--

DROP TABLE IF EXISTS `mobile_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_associations` (
  `mobile_subscriber_id` int(11) NOT NULL,
  `mobile_list_id` int(11) NOT NULL,
  `trumpia_contact_id` int(11) NOT NULL,
  PRIMARY KEY (`mobile_subscriber_id`,`mobile_list_id`,`trumpia_contact_id`),
  KEY `fk_ma_idx` (`mobile_subscriber_id`),
  KEY `fk_ma2_idx` (`mobile_list_id`),
  CONSTRAINT `fk_ma` FOREIGN KEY (`mobile_subscriber_id`) REFERENCES `mobile_subscribers` (`mobile_subscriber_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_ma2` FOREIGN KEY (`mobile_list_id`) REFERENCES `mobile_lists` (`mobile_list_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mobile_keyword_lists`
--

DROP TABLE IF EXISTS `mobile_keyword_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_keyword_lists` (
  `mobile_keyword_id` int(11) NOT NULL,
  `mobile_list_id` int(11) NOT NULL,
  PRIMARY KEY (`mobile_keyword_id`,`mobile_list_id`),
  KEY `fk_mkl_idx` (`mobile_keyword_id`),
  KEY `fk_mkl2_idx` (`mobile_list_id`),
  CONSTRAINT `fk_mkl` FOREIGN KEY (`mobile_keyword_id`) REFERENCES `mobile_keywords` (`mobile_keyword_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_mkl2` FOREIGN KEY (`mobile_list_id`) REFERENCES `mobile_lists` (`mobile_list_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mobile_keywords`
--

DROP TABLE IF EXISTS `mobile_keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_keywords` (
  `mobile_keyword_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `keyword` varchar(50) NOT NULL,
  `response` varchar(140) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`mobile_keyword_id`),
  KEY `am_keyword_campaign_id` (`website_id`),
  CONSTRAINT `fk_mk` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mobile_lists`
--

DROP TABLE IF EXISTS `mobile_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_lists` (
  `mobile_list_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `frequency` int(11) NOT NULL,
  `description` varchar(50) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`mobile_list_id`),
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_ml` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mobile_message_associations`
--

DROP TABLE IF EXISTS `mobile_message_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_message_associations` (
  `mobile_message_id` int(11) NOT NULL,
  `mobile_list_id` int(11) NOT NULL,
  PRIMARY KEY (`mobile_message_id`,`mobile_list_id`),
  KEY `fk_mma_idx` (`mobile_message_id`),
  KEY `fk_mma2_idx` (`mobile_list_id`),
  CONSTRAINT `fk_mma` FOREIGN KEY (`mobile_message_id`) REFERENCES `mobile_messages` (`mobile_message_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_mma2` FOREIGN KEY (`mobile_list_id`) REFERENCES `mobile_lists` (`mobile_list_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mobile_messages`
--

DROP TABLE IF EXISTS `mobile_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_messages` (
  `mobile_message_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` varchar(160) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `date_sent` datetime NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`mobile_message_id`),
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_mm` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mobile_pages`
--

DROP TABLE IF EXISTS `mobile_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_pages` (
  `mobile_page_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `title` varchar(250) NOT NULL,
  `content` text NOT NULL,
  `meta_title` text NOT NULL,
  `meta_description` text NOT NULL,
  `meta_keywords` text NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `updated_user_id` int(11) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`mobile_page_id`),
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_mp` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mobile_plans`
--

DROP TABLE IF EXISTS `mobile_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_plans` (
  `mobile_plan_id` int(11) NOT NULL AUTO_INCREMENT,
  `trumpia_plan_id` int(11) NOT NULL,
  `name` varchar(20) CHARACTER SET latin1 NOT NULL,
  `credits` int(11) NOT NULL,
  `keywords` int(11) NOT NULL,
  PRIMARY KEY (`mobile_plan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mobile_subscribers`
--

DROP TABLE IF EXISTS `mobile_subscribers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_subscribers` (
  `mobile_subscriber_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `date_created` datetime NOT NULL,
  `date_unsubscribed` datetime NOT NULL,
  `date_synced` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`mobile_subscriber_id`),
  UNIQUE KEY `website_id` (`website_id`,`phone`),
  KEY `fk_ms_idx` (`website_id`),
  CONSTRAINT `fk_ms` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=587 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=53415 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_items` (
  `order_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `item` varchar(200) NOT NULL,
  `quantity` smallint(6) NOT NULL,
  `amount` float NOT NULL,
  `monthly` float NOT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `fk_oi` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3004 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `total_amount` float NOT NULL,
  `total_monthly` float NOT NULL,
  `type` varchar(50) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1487 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_group_relations`
--

DROP TABLE IF EXISTS `product_group_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_group_relations` (
  `product_group_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  KEY `product_id` (`product_id`),
  KEY `product_group_id` (`product_group_id`),
  CONSTRAINT `fk_pgr` FOREIGN KEY (`product_group_id`) REFERENCES `product_groups` (`product_group_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_groups`
--

DROP TABLE IF EXISTS `product_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_groups` (
  `product_group_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`product_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=160 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_images` (
  `product_image_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `image` varchar(200) NOT NULL,
  `sequence` int(11) NOT NULL,
  PRIMARY KEY (`product_image_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4905520 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_images_rmi`
--

DROP TABLE IF EXISTS `product_images_rmi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_images_rmi` (
  `product_id` int(11) NOT NULL,
  `image` varchar(200) CHARACTER SET utf8 NOT NULL,
  `sequence` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_import`
--

DROP TABLE IF EXISTS `product_import`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_import` (
  `category_id` int(11) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `industry_id` int(11) NOT NULL DEFAULT '1',
  `website_id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `status` varchar(50) NOT NULL,
  `sku` varchar(100) NOT NULL,
  `price` float NOT NULL,
  `price_min` float NOT NULL,
  `product_specifications` text NOT NULL,
  `image` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_option_list_items`
--

DROP TABLE IF EXISTS `product_option_list_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_option_list_items` (
  `product_option_list_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_option_id` int(11) NOT NULL,
  `value` varchar(100) NOT NULL,
  `sequence` int(11) NOT NULL,
  PRIMARY KEY (`product_option_list_item_id`),
  KEY `product_option_id` (`product_option_id`),
  CONSTRAINT `fk_poli` FOREIGN KEY (`product_option_id`) REFERENCES `product_options` (`product_option_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=935 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_option_relations`
--

DROP TABLE IF EXISTS `product_option_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_option_relations` (
  `product_option_id` int(11) NOT NULL,
  `brand_id` int(11) NOT NULL,
  KEY `product_option_id` (`product_option_id`,`brand_id`),
  KEY `fk_por_idx` (`product_option_id`),
  CONSTRAINT `fk_por` FOREIGN KEY (`product_option_id`) REFERENCES `product_options` (`product_option_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_options`
--

DROP TABLE IF EXISTS `product_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_options` (
  `product_option_id` int(11) NOT NULL AUTO_INCREMENT,
  `option_type` varchar(10) NOT NULL,
  `option_title` varchar(100) NOT NULL,
  `option_name` varchar(250) NOT NULL,
  PRIMARY KEY (`product_option_id`)
) ENGINE=InnoDB AUTO_INCREMENT=823 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_specification`
--

DROP TABLE IF EXISTS `product_specification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_specification` (
  `product_id` int(11) NOT NULL,
  `key` text,
  `value` text,
  `sequence` int(11) DEFAULT NULL,
  KEY `INDEX` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_specification_rmi`
--

DROP TABLE IF EXISTS `product_specification_rmi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_specification_rmi` (
  `product_id` int(11) NOT NULL,
  `key` text CHARACTER SET utf8,
  `value` text CHARACTER SET utf8,
  `sequence` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `industry_id` int(11) NOT NULL DEFAULT '1',
  `website_id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `status` varchar(50) NOT NULL,
  `sku` varchar(100) NOT NULL,
  `price` float NOT NULL,
  `price_min` float NOT NULL,
  `weight` float NOT NULL,
  `volume` float NOT NULL,
  `product_specifications` text NOT NULL,
  `publish_visibility` varchar(20) NOT NULL,
  `publish_date` datetime NOT NULL,
  `user_id_created` int(11) NOT NULL,
  `user_id_modified` int(11) NOT NULL,
  `date_created` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `depth` float DEFAULT NULL,
  `height` float DEFAULT NULL,
  `length` float DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  KEY `slug` (`slug`),
  KEY `sku` (`sku`,`name`),
  KEY `publish_visibility` (`publish_visibility`),
  KEY `brand_id` (`brand_id`,`industry_id`,`website_id`,`category_id`),
  KEY `products_user_id_created` (`user_id_created`),
  KEY `products_user_id_modified` (`user_id_modified`),
  FULLTEXT KEY `name` (`name`,`description`,`sku`)
) ENGINE=MyISAM AUTO_INCREMENT=872064 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `products_rmi`
--

DROP TABLE IF EXISTS `products_rmi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products_rmi` (
  `product_id` int(11) NOT NULL DEFAULT '0',
  `category_id` int(11) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `industry_id` int(11) NOT NULL DEFAULT '1',
  `website_id` int(11) NOT NULL,
  `name` varchar(200) CHARACTER SET utf8 NOT NULL,
  `slug` varchar(200) CHARACTER SET utf8 NOT NULL,
  `description` text CHARACTER SET utf8 NOT NULL,
  `status` varchar(50) CHARACTER SET utf8 NOT NULL,
  `sku` varchar(100) CHARACTER SET utf8 NOT NULL,
  `price` float NOT NULL,
  `price_min` float NOT NULL,
  `weight` float NOT NULL,
  `volume` float NOT NULL,
  `product_specifications` text CHARACTER SET utf8 NOT NULL,
  `publish_visibility` varchar(20) CHARACTER SET utf8 NOT NULL,
  `publish_date` datetime NOT NULL,
  `user_id_created` int(11) NOT NULL,
  `user_id_modified` int(11) NOT NULL,
  `date_created` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ratings` (
  `rating_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `ip_address` varchar(15) NOT NULL,
  `rating` int(11) NOT NULL,
  `date_created` datetime DEFAULT NULL,
  PRIMARY KEY (`rating_id`),
  UNIQUE KEY `UNIQUE` (`product_id`,`ip_address`)
) ENGINE=InnoDB AUTO_INCREMENT=97298 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rmi_stage`
--

DROP TABLE IF EXISTS `rmi_stage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rmi_stage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `val_id` varchar(255) DEFAULT NULL,
  `upc_code` varchar(255) DEFAULT NULL,
  `sku_code` varchar(255) DEFAULT NULL,
  `sku_description` text,
  `weight` float DEFAULT NULL,
  `shape_name` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `vendor_name` varchar(255) DEFAULT NULL,
  `collection_name` varchar(255) DEFAULT NULL,
  `type_name` varchar(255) DEFAULT NULL,
  `origin_name` varchar(255) DEFAULT NULL,
  `description` text,
  `content_name` varchar(255) DEFAULT NULL,
  `vendor_content` varchar(255) DEFAULT NULL,
  `pile` float DEFAULT NULL,
  `feature` text,
  `care` text,
  `design_name` varchar(255) DEFAULT NULL,
  `vendor_design_id` varchar(255) DEFAULT NULL,
  `parent_style_name` varchar(255) DEFAULT NULL,
  `child_style_name` varchar(255) DEFAULT NULL,
  `field_design_name` varchar(255) DEFAULT NULL,
  `style_name` varchar(255) DEFAULT NULL,
  `vendor_primary_color` varchar(255) DEFAULT NULL,
  `vendor_detail_color` varchar(255) DEFAULT NULL,
  `background_color_name` varchar(255) DEFAULT NULL,
  `border_color_name` varchar(255) DEFAULT NULL,
  `width_1` float DEFAULT NULL,
  `width_2` float DEFAULT NULL,
  `length_1` float DEFAULT NULL,
  `length_2` float DEFAULT NULL,
  `size_category` varchar(255) DEFAULT NULL,
  `size_feet_inches` varchar(255) DEFAULT NULL,
  `size_decimal` varchar(255) DEFAULT NULL,
  `size_width_decimal` float DEFAULT NULL,
  `size_length_decimal` float DEFAULT NULL,
  `map_price` float DEFAULT NULL,
  `msrp` float DEFAULT NULL,
  `unit_price` float DEFAULT NULL,
  `vendor_cost` float DEFAULT NULL,
  `sale_price` float DEFAULT NULL,
  `image_filename` text,
  `medium_image_filename` text,
  `small_image_filename` text,
  `full_image_filename` text,
  `active` varchar(255) DEFAULT NULL,
  `dropped` varchar(255) DEFAULT NULL,
  `ecommerce` varchar(255) DEFAULT NULL,
  `new_arrival` varchar(255) DEFAULT NULL,
  `image_not_available` varchar(255) DEFAULT NULL,
  `calculated_1` varchar(255) DEFAULT NULL,
  `calculated_2` varchar(255) DEFAULT NULL,
  `calculated_3` varchar(255) DEFAULT NULL,
  `calculated_4` varchar(255) DEFAULT NULL,
  `calculated_5` varchar(255) DEFAULT NULL,
  `calculated_6` varchar(255) DEFAULT NULL,
  `dateupdated` datetime DEFAULT NULL,
  `idvendor` int(11) DEFAULT NULL,
  `idstyle` int(11) DEFAULT NULL,
  `idmaincolor` int(11) DEFAULT NULL,
  `idsecondarycolor` int(11) DEFAULT NULL,
  `idweave` int(11) DEFAULT NULL,
  `idmaterial` int(11) DEFAULT NULL,
  `idshape` int(11) DEFAULT NULL,
  `idcoo` int(11) DEFAULT NULL,
  `idsize` int(11) DEFAULT NULL,
  `imported` varchar(10) DEFAULT NULL,
  `PageName` varchar(255) DEFAULT NULL,
  `idstyle2` int(11) DEFAULT NULL,
  `dateimported` datetime DEFAULT NULL,
  `mid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=243169 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `server`
--

DROP TABLE IF EXISTS `server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `server` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `ip` varchar(15) DEFAULT NULL,
  `nodebalancer_ip` varchar(15) DEFAULT NULL,
  `whm_hash` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sm_about_us`
--

DROP TABLE IF EXISTS `sm_about_us`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sm_about_us` (
  `sm_facebook_page_id` int(11) NOT NULL,
  `fb_page_id` varchar(50) NOT NULL,
  `website_page_id` int(11) NOT NULL,
  `key` varchar(32) NOT NULL,
  `content` text NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `fb_page_id` (`fb_page_id`),
  KEY `fk_smau_idx` (`sm_facebook_page_id`),
  CONSTRAINT `fk_smau` FOREIGN KEY (`sm_facebook_page_id`) REFERENCES `sm_facebook_page` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sm_contact_us`
--

DROP TABLE IF EXISTS `sm_contact_us`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sm_contact_us` (
  `sm_facebook_page_id` int(11) NOT NULL,
  `fb_page_id` varchar(50) NOT NULL,
  `website_page_id` int(11) NOT NULL,
  `key` varchar(32) NOT NULL,
  `content` text NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `fb_page_id` (`fb_page_id`),
  KEY `fk_smcu_idx` (`sm_facebook_page_id`),
  CONSTRAINT `fk_smcu` FOREIGN KEY (`sm_facebook_page_id`) REFERENCES `sm_facebook_page` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sm_current_ad`
--

DROP TABLE IF EXISTS `sm_current_ad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sm_current_ad` (
  `sm_facebook_page_id` int(11) NOT NULL,
  `fb_page_id` varchar(50) NOT NULL,
  `website_page_id` int(11) NOT NULL,
  `key` varchar(32) NOT NULL,
  `content` text NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `fb_page_id` (`fb_page_id`),
  KEY `fk_smca_idx` (`sm_facebook_page_id`),
  CONSTRAINT `fk_smca` FOREIGN KEY (`sm_facebook_page_id`) REFERENCES `sm_facebook_page` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sm_email_sign_up`
--

DROP TABLE IF EXISTS `sm_email_sign_up`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sm_email_sign_up` (
  `sm_facebook_page_id` int(11) NOT NULL,
  `fb_page_id` bigint(20) NOT NULL,
  `email_list_id` int(11) NOT NULL,
  `key` varchar(32) NOT NULL,
  `tab` text NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `fb_page_id` (`fb_page_id`),
  KEY `fk_smesu_idx` (`sm_facebook_page_id`),
  CONSTRAINT `fk_smesu` FOREIGN KEY (`sm_facebook_page_id`) REFERENCES `sm_facebook_page` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sm_facebook_page`
--

DROP TABLE IF EXISTS `sm_facebook_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sm_facebook_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_smfp` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=409 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sm_facebook_site`
--

DROP TABLE IF EXISTS `sm_facebook_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sm_facebook_site` (
  `sm_facebook_page_id` int(11) NOT NULL,
  `fb_page_id` varchar(50) NOT NULL,
  `key` varchar(32) NOT NULL,
  `content` text NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `fb_page_id` (`fb_page_id`),
  KEY `fk_smfs_idx` (`sm_facebook_page_id`),
  CONSTRAINT `fk_smfs` FOREIGN KEY (`sm_facebook_page_id`) REFERENCES `sm_facebook_page` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sm_fan_offer`
--

DROP TABLE IF EXISTS `sm_fan_offer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sm_fan_offer` (
  `sm_facebook_page_id` int(11) NOT NULL,
  `fb_page_id` varchar(50) NOT NULL,
  `email_list_id` int(11) NOT NULL,
  `key` varchar(32) NOT NULL,
  `before` text NOT NULL,
  `after` text NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `share_title` varchar(100) NOT NULL,
  `share_image_url` varchar(200) NOT NULL,
  `share_text` text NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `fb_page_id` (`fb_page_id`),
  KEY `fk_smfo_idx` (`sm_facebook_page_id`),
  CONSTRAINT `fk_smfo` FOREIGN KEY (`sm_facebook_page_id`) REFERENCES `sm_facebook_page` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sm_posting`
--

DROP TABLE IF EXISTS `sm_posting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sm_posting` (
  `sm_facebook_page_id` int(11) NOT NULL,
  `fb_user_id` bigint(20) NOT NULL,
  `fb_page_id` bigint(20) NOT NULL,
  `key` varchar(32) NOT NULL,
  `access_token` text NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `key` (`fb_page_id`,`key`),
  KEY `fk_smpo_idx` (`sm_facebook_page_id`),
  CONSTRAINT `fk_smpo` FOREIGN KEY (`sm_facebook_page_id`) REFERENCES `sm_facebook_page` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sm_posting_posts`
--

DROP TABLE IF EXISTS `sm_posting_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sm_posting_posts` (
  `sm_posting_post_id` int(11) NOT NULL AUTO_INCREMENT,
  `sm_facebook_page_id` int(11) NOT NULL,
  `access_token` text NOT NULL,
  `post` text NOT NULL,
  `link` varchar(200) NOT NULL,
  `error` text NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `date_posted` datetime NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`sm_posting_post_id`),
  KEY `date_posted` (`date_posted`),
  KEY `fk_smpp_idx` (`sm_facebook_page_id`),
  CONSTRAINT `fk_smpp` FOREIGN KEY (`sm_facebook_page_id`) REFERENCES `sm_facebook_page` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=18135 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sm_products`
--

DROP TABLE IF EXISTS `sm_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sm_products` (
  `sm_facebook_page_id` int(11) NOT NULL,
  `fb_page_id` varchar(50) NOT NULL,
  `key` varchar(32) NOT NULL,
  `content` text NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `fb_page_id` (`fb_page_id`),
  KEY `fk_smp_idx` (`sm_facebook_page_id`),
  CONSTRAINT `fk_smpr` FOREIGN KEY (`sm_facebook_page_id`) REFERENCES `sm_facebook_page` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sm_share_and_save`
--

DROP TABLE IF EXISTS `sm_share_and_save`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sm_share_and_save` (
  `sm_facebook_page_id` int(11) NOT NULL,
  `fb_page_id` varchar(50) NOT NULL,
  `email_list_id` int(11) NOT NULL,
  `maximum_email_list_id` int(11) NOT NULL,
  `key` varchar(32) NOT NULL,
  `before` text NOT NULL,
  `after` text NOT NULL,
  `minimum` int(11) NOT NULL,
  `maximum` int(11) NOT NULL,
  `share_title` varchar(100) NOT NULL,
  `share_image_url` varchar(200) NOT NULL,
  `share_text` text NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `fb_page_id` (`fb_page_id`),
  KEY `fk_smsas_idx` (`sm_facebook_page_id`),
  CONSTRAINT `fk_smsas` FOREIGN KEY (`sm_facebook_page_id`) REFERENCES `sm_facebook_page` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sm_sweepstakes`
--

DROP TABLE IF EXISTS `sm_sweepstakes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sm_sweepstakes` (
  `sm_facebook_page_id` int(11) NOT NULL,
  `fb_page_id` varchar(50) NOT NULL,
  `email_list_id` int(11) NOT NULL,
  `key` varchar(32) NOT NULL,
  `before` text NOT NULL,
  `after` text NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `contest_rules_url` varchar(200) NOT NULL,
  `share_title` varchar(100) NOT NULL,
  `share_image_url` varchar(200) NOT NULL,
  `share_text` text NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `fb_page_id` (`fb_page_id`),
  KEY `fk_sms_idx` (`sm_facebook_page_id`),
  CONSTRAINT `fk_sms` FOREIGN KEY (`sm_facebook_page_id`) REFERENCES `sm_facebook_page` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `tag_id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(11) NOT NULL,
  `type` varchar(30) NOT NULL,
  `value` varchar(100) NOT NULL,
  PRIMARY KEY (`tag_id`),
  KEY `value` (`value`),
  KEY `object_id` (`object_id`),
  FULLTEXT KEY `value_2` (`value`)
) ENGINE=MyISAM AUTO_INCREMENT=11121942 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ticket_comments`
--

DROP TABLE IF EXISTS `ticket_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_comments` (
  `ticket_comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `to_address` varchar(255) DEFAULT NULL,
  `cc_address` varchar(255) DEFAULT NULL,
  `bcc_address` varchar(255) DEFAULT NULL,
  `comment` text NOT NULL,
  `private` tinyint(1) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `jira_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`ticket_comment_id`),
  KEY `ticket_id` (`ticket_id`,`user_id`),
  KEY `fk_tc_idx` (`ticket_id`),
  CONSTRAINT `fk_tc` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`ticket_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=56867 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ticket_uploads`
--

DROP TABLE IF EXISTS `ticket_uploads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_uploads` (
  `ticket_upload_id` int(11) NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) NOT NULL,
  `ticket_comment_id` int(11) NOT NULL,
  `key` varchar(200) NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`ticket_upload_id`),
  KEY `ticket_id` (`ticket_id`,`ticket_comment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10633 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickets` (
  `ticket_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `assigned_to_user_id` int(11) NOT NULL,
  `website_id` int(11) NOT NULL,
  `summary` varchar(140) NOT NULL,
  `message` text NOT NULL,
  `priority` tinyint(1) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `browser_name` varchar(50) NOT NULL,
  `browser_version` varchar(20) NOT NULL,
  `browser_platform` varchar(50) NOT NULL,
  `browser_user_agent` varchar(200) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `jira_id` int(11) DEFAULT NULL,
  `jira_key` varchar(255) DEFAULT NULL,
  `user_id_created` int(11) DEFAULT NULL,
  PRIMARY KEY (`ticket_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33395 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_product_images`
--

DROP TABLE IF EXISTS `tmp_product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_product_images` (
  `product_image_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `image` varchar(200) DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  PRIMARY KEY (`product_image_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tokens` (
  `token_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `key` varchar(100) NOT NULL,
  `token_type` varchar(30) NOT NULL,
  `date_valid` datetime NOT NULL,
  PRIMARY KEY (`token_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3502 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(32) NOT NULL,
  `contact_name` varchar(100) NOT NULL,
  `store_name` varchar(100) NOT NULL,
  `work_phone` varchar(20) NOT NULL,
  `cell_phone` varchar(20) NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `billing_first_name` varchar(50) NOT NULL,
  `billing_last_name` varchar(50) NOT NULL,
  `billing_address1` varchar(150) NOT NULL,
  `billing_city` varchar(150) NOT NULL,
  `billing_state` varchar(50) NOT NULL,
  `billing_zip` varchar(10) NOT NULL,
  `arb_subscription_id` varchar(13) NOT NULL,
  `role` tinyint(2) NOT NULL DEFAULT '5',
  `status` tinyint(2) NOT NULL DEFAULT '1',
  `email_signature` text,
  `job_title` varchar(255) DEFAULT NULL,
  `last_login` datetime NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `new_features_dismissed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_u_idx` (`company_id`),
  CONSTRAINT `fk_u` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3002 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_attachments`
--

DROP TABLE IF EXISTS `website_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_attachments` (
  `website_attachment_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_page_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `extra` varchar(200) NOT NULL,
  `meta` varchar(200) NOT NULL,
  `sequence` int(2) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`website_attachment_id`,`website_page_id`,`key`),
  KEY `fk_wa_idx` (`website_page_id`),
  CONSTRAINT `fk_wa` FOREIGN KEY (`website_page_id`) REFERENCES `website_pages` (`website_page_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=41755 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_auto_price`
--

DROP TABLE IF EXISTS `website_auto_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_auto_price` (
  `website_id` int(11) NOT NULL,
  `brand_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `price` float DEFAULT NULL,
  `sale_price` float DEFAULT NULL,
  `alternate_price` float DEFAULT NULL,
  `ending` float DEFAULT NULL,
  `future` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`website_id`,`category_id`,`brand_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_blocked_category`
--

DROP TABLE IF EXISTS `website_blocked_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_blocked_category` (
  `website_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  PRIMARY KEY (`website_id`,`category_id`),
  KEY `fk_wbc_idx` (`website_id`),
  KEY `fk_wbc2_idx` (`category_id`),
  CONSTRAINT `fk_wbc` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_wbc2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_brand_category`
--

DROP TABLE IF EXISTS `website_brand_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_brand_category` (
  `website_id` int(11) NOT NULL DEFAULT '0',
  `brand_id` int(11) NOT NULL DEFAULT '0',
  `category_id` int(11) NOT NULL DEFAULT '0',
  `image_url` varchar(255) DEFAULT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`website_id`,`brand_id`,`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_brands`
--

DROP TABLE IF EXISTS `website_brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_brands` (
  `website_id` int(11) NOT NULL,
  `brand_id` int(11) NOT NULL,
  `name` varchar(250) NOT NULL,
  `content` text NOT NULL,
  `meta_title` text NOT NULL,
  `meta_description` text NOT NULL,
  `meta_keywords` text NOT NULL,
  `top` tinyint(1) NOT NULL DEFAULT '1',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`website_id`,`brand_id`),
  KEY `fk_wca_idx` (`website_id`),
  KEY `fk_wca2_idx` (`brand_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_cart_item_options`
--

DROP TABLE IF EXISTS `website_cart_item_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_cart_item_options` (
  `website_cart_item_id` int(11) NOT NULL,
  `product_option_id` int(11) NOT NULL,
  `product_option_list_item_id` int(11) NOT NULL,
  KEY `website_cart_item_id` (`website_cart_item_id`,`product_option_id`),
  KEY `fk_wcio_idx` (`website_cart_item_id`),
  CONSTRAINT `fk_wcio` FOREIGN KEY (`website_cart_item_id`) REFERENCES `website_cart_items` (`website_cart_item_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_cart_items`
--

DROP TABLE IF EXISTS `website_cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_cart_items` (
  `website_cart_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_cart_id` int(11) NOT NULL,
  `product_id` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL,
  `weight` float NOT NULL DEFAULT '0',
  `protection` tinyint(1) NOT NULL,
  `extra` text NOT NULL COMMENT 'Serialized!',
  `date_created` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`website_cart_item_id`),
  KEY `cart_id` (`website_cart_id`),
  CONSTRAINT `fk_wci` FOREIGN KEY (`website_cart_id`) REFERENCES `website_carts` (`website_cart_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=173470 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_carts`
--

DROP TABLE IF EXISTS `website_carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_carts` (
  `website_cart_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `website_shipping_method_id` int(11) NOT NULL,
  `website_ashley_express_shipping_method_id` int(11) DEFAULT NULL,
  `website_coupon_id` int(11) NOT NULL,
  `expires` datetime NOT NULL,
  `zip` varchar(10) NOT NULL,
  `shipping_price` float NOT NULL,
  `tax_price` float NOT NULL,
  `coupon_discount` float DEFAULT NULL,
  `total_price` float DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`website_cart_id`),
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_wcar` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=89489 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_categories`
--

DROP TABLE IF EXISTS `website_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_categories` (
  `website_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `title` varchar(250) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `content` text NOT NULL,
  `meta_title` text NOT NULL,
  `meta_description` text NOT NULL,
  `meta_keywords` text NOT NULL,
  `image_url` varchar(200) NOT NULL,
  `top` tinyint(1) NOT NULL DEFAULT '1',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `header_script` text,
  PRIMARY KEY (`website_id`,`category_id`),
  KEY `fk_wca_idx` (`website_id`),
  KEY `fk_wca2_idx` (`category_id`),
  CONSTRAINT `fk_wca` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_wca2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_coupon_relations`
--

DROP TABLE IF EXISTS `website_coupon_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_coupon_relations` (
  `website_coupon_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  PRIMARY KEY (`website_coupon_id`,`product_id`),
  KEY `fk_wcr_idx` (`website_coupon_id`),
  CONSTRAINT `fk_wcr` FOREIGN KEY (`website_coupon_id`) REFERENCES `website_coupons` (`website_coupon_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_coupon_shipping_methods`
--

DROP TABLE IF EXISTS `website_coupon_shipping_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_coupon_shipping_methods` (
  `website_coupon_id` int(11) NOT NULL,
  `website_shipping_method_id` int(11) NOT NULL,
  KEY `fk_wcsm_idx` (`website_coupon_id`),
  KEY `fk_wcsm2_idx` (`website_shipping_method_id`),
  CONSTRAINT `fk_wcsm` FOREIGN KEY (`website_coupon_id`) REFERENCES `website_coupons` (`website_coupon_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_wcsm2` FOREIGN KEY (`website_shipping_method_id`) REFERENCES `website_shipping_methods` (`website_shipping_method_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_coupons`
--

DROP TABLE IF EXISTS `website_coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_coupons` (
  `website_coupon_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `code` varchar(30) NOT NULL,
  `type` varchar(20) NOT NULL,
  `amount` float NOT NULL,
  `minimum_purchase_amount` float NOT NULL,
  `store_wide` tinyint(1) NOT NULL,
  `buy_one_get_one_free` tinyint(1) NOT NULL,
  `item_limit` int(11) NOT NULL,
  `date_start` datetime NOT NULL,
  `date_end` datetime NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`website_coupon_id`),
  KEY `code` (`code`),
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_wc` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=345 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_files`
--

DROP TABLE IF EXISTS `website_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_files` (
  `website_file_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `file_path` varchar(200) NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`website_file_id`),
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_wf` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=31420 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_industries`
--

DROP TABLE IF EXISTS `website_industries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_industries` (
  `website_id` int(11) NOT NULL,
  `industry_id` int(11) NOT NULL,
  PRIMARY KEY (`website_id`,`industry_id`),
  KEY `fk_wi_idx` (`website_id`),
  KEY `fk_wi2_idx` (`industry_id`),
  CONSTRAINT `fk_wi` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_wi2` FOREIGN KEY (`industry_id`) REFERENCES `industries` (`industry_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_location`
--

DROP TABLE IF EXISTS `website_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_location` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `city` varchar(200) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `zip` varchar(10) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `fax` varchar(20) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `website` varchar(200) DEFAULT NULL,
  `store_hours` text,
  `lat` varchar(20) DEFAULT NULL,
  `lng` varchar(20) DEFAULT NULL,
  `sequence` int(11) NOT NULL,
  `date_created` datetime DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT NULL,
  `store_image` varchar(500) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `INDEX` (`website_id`),
  CONSTRAINT `fk_wl` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1446 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_notes`
--

DROP TABLE IF EXISTS `website_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_notes` (
  `website_note_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text CHARACTER SET latin1 NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`website_note_id`),
  KEY `website_id` (`website_id`,`user_id`),
  KEY `fk_wn_idx` (`website_id`),
  CONSTRAINT `fk_wn` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=18057 DEFAULT CHARSET=utf8 COMMENT='Website notes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_order_item_options`
--

DROP TABLE IF EXISTS `website_order_item_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_order_item_options` (
  `website_order_item_id` int(11) NOT NULL,
  `product_option_id` int(11) NOT NULL,
  `product_option_list_item_id` int(11) NOT NULL,
  `price` float NOT NULL,
  `option_type` varchar(10) NOT NULL,
  `option_name` varchar(250) NOT NULL,
  `list_item_value` varchar(100) NOT NULL,
  KEY `website_order_item_id` (`website_order_item_id`,`product_option_id`),
  KEY `fk_woio_idx` (`website_order_item_id`),
  CONSTRAINT `fk_woio` FOREIGN KEY (`website_order_item_id`) REFERENCES `website_order_items` (`website_order_item_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_order_items`
--

DROP TABLE IF EXISTS `website_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_order_items` (
  `website_order_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `sku` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` float NOT NULL,
  `additional_shipping_price` float NOT NULL,
  `protection_price` float NOT NULL,
  `extra` text NOT NULL,
  `price_note` varchar(50) NOT NULL,
  `product_note` text NOT NULL,
  `ships_in` varchar(60) NOT NULL,
  `store_sku` varchar(30) NOT NULL,
  `warranty_length` varchar(60) NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`website_order_item_id`),
  KEY `website_order_id` (`website_order_id`,`sku`),
  KEY `fk_woi_idx` (`website_order_id`),
  CONSTRAINT `fk_woi` FOREIGN KEY (`website_order_id`) REFERENCES `website_orders` (`website_order_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7527 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_orders`
--

DROP TABLE IF EXISTS `website_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_orders` (
  `website_order_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `website_user_id` int(11) NOT NULL,
  `website_cart_id` int(11) NOT NULL,
  `website_shipping_method_id` int(11) NOT NULL,
  `website_ashley_express_shipping_method_id` int(11) DEFAULT NULL,
  `authorize_only` int(1) NOT NULL DEFAULT '0',
  `website_coupon_id` int(11) NOT NULL,
  `shipping_price` float NOT NULL,
  `tax_price` float NOT NULL,
  `coupon_discount` float NOT NULL,
  `total_cost` float NOT NULL,
  `email` varchar(200) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `billing_name` varchar(100) DEFAULT NULL,
  `billing_first_name` varchar(50) NOT NULL,
  `billing_last_name` varchar(50) NOT NULL,
  `billing_address1` varchar(100) NOT NULL,
  `billing_address2` varchar(100) NOT NULL,
  `billing_city` varchar(100) NOT NULL,
  `billing_state` varchar(30) NOT NULL,
  `billing_zip` varchar(10) NOT NULL,
  `billing_phone` varchar(13) NOT NULL,
  `billing_alt_phone` varchar(13) NOT NULL,
  `shipping_name` varchar(100) DEFAULT NULL,
  `shipping_first_name` varchar(50) NOT NULL,
  `shipping_last_name` varchar(50) NOT NULL,
  `shipping_address1` varchar(100) NOT NULL,
  `shipping_address2` varchar(100) NOT NULL,
  `shipping_city` varchar(100) NOT NULL,
  `shipping_state` varchar(30) NOT NULL,
  `shipping_zip` varchar(10) NOT NULL,
  `status` int(11) NOT NULL,
  `date_created` datetime NOT NULL,
  `shipping_track_number` text,
  PRIMARY KEY (`website_order_id`),
  KEY `website_user_id` (`website_user_id`),
  KEY `fk_wo_idx` (`website_id`),
  CONSTRAINT `fk_wo` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5141 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_page_product`
--

DROP TABLE IF EXISTS `website_page_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_page_product` (
  `website_page_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `sequence` int(11) DEFAULT NULL,
  PRIMARY KEY (`website_page_id`,`product_id`),
  KEY `fk_wpp_idx` (`website_page_id`),
  CONSTRAINT `fk_wpp` FOREIGN KEY (`website_page_id`) REFERENCES `website_pages` (`website_page_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_pagemeta`
--

DROP TABLE IF EXISTS `website_pagemeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_pagemeta` (
  `website_pagemeta_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_page_id` int(11) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `value` text,
  PRIMARY KEY (`website_pagemeta_id`),
  UNIQUE KEY `website_page_id` (`website_page_id`,`key`),
  KEY `fk_pm_idx` (`website_page_id`),
  CONSTRAINT `fk_pm` FOREIGN KEY (`website_page_id`) REFERENCES `website_pages` (`website_page_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=19892 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_pages`
--

DROP TABLE IF EXISTS `website_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_pages` (
  `website_page_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `title` varchar(250) NOT NULL,
  `content` text NOT NULL,
  `meta_title` text NOT NULL,
  `meta_description` text NOT NULL,
  `meta_keywords` text NOT NULL,
  `mobile` tinyint(4) NOT NULL DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `updated_user_id` int(11) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `top` tinyint(1) NOT NULL DEFAULT '1',
  `header_script` text,
  PRIMARY KEY (`website_page_id`),
  UNIQUE KEY `website_id` (`website_id`,`slug`),
  KEY `fk_wp_idx` (`website_id`),
  CONSTRAINT `fk_wp` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=14167 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_passwords`
--

DROP TABLE IF EXISTS `website_passwords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_passwords` (
  `website_password_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `username` text NOT NULL,
  `password` text NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `iv` varchar(100) DEFAULT NULL,
  `notes` text,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`website_password_id`),
  KEY `website_id_index` (`website_id`),
  CONSTRAINT `fk_wpw` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='Website Passwords';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_product_ashley_express`
--

DROP TABLE IF EXISTS `website_product_ashley_express`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_product_ashley_express` (
  `website_id` int(11) NOT NULL DEFAULT '0',
  `product_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`website_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_product_ashley_express_master`
--

DROP TABLE IF EXISTS `website_product_ashley_express_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_product_ashley_express_master` (
  `sku` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`sku`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_product_group_relations`
--

DROP TABLE IF EXISTS `website_product_group_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_product_group_relations` (
  `website_product_group_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  PRIMARY KEY (`website_product_group_id`,`product_id`),
  KEY `fk_wpgr_idx` (`website_product_group_id`),
  KEY `FH_DanB_1` (`product_id`,`website_product_group_id`),
  CONSTRAINT `fk_wpgr` FOREIGN KEY (`website_product_group_id`) REFERENCES `website_product_groups` (`website_product_group_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_product_groups`
--

DROP TABLE IF EXISTS `website_product_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_product_groups` (
  `website_product_group_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`website_product_group_id`),
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_wpg` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6065491 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_product_option_list_items`
--

DROP TABLE IF EXISTS `website_product_option_list_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_product_option_list_items` (
  `website_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_option_id` int(11) NOT NULL,
  `product_option_list_item_id` int(11) NOT NULL,
  `price` float NOT NULL,
  `alt_price` float DEFAULT NULL,
  `alt_price2` float DEFAULT NULL,
  PRIMARY KEY (`product_id`,`website_id`,`product_option_id`,`product_option_list_item_id`),
  KEY `website_id` (`website_id`,`product_id`,`product_option_id`,`product_option_list_item_id`),
  KEY `fk_website_product_option_list_items_idx` (`website_id`),
  KEY `fk_wpoli_idx` (`product_option_id`),
  KEY `fk_wpoli2_idx` (`product_option_list_item_id`),
  CONSTRAINT `fk_website_product_option_list_items` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_wpoli` FOREIGN KEY (`product_option_id`) REFERENCES `product_options` (`product_option_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_wpoli2` FOREIGN KEY (`product_option_list_item_id`) REFERENCES `product_option_list_items` (`product_option_list_item_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_product_options`
--

DROP TABLE IF EXISTS `website_product_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_product_options` (
  `website_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_option_id` int(11) NOT NULL,
  `price` float NOT NULL,
  `required` tinyint(1) NOT NULL,
  PRIMARY KEY (`website_id`,`product_id`,`product_option_id`),
  KEY `fk_website_product_options_idx` (`website_id`),
  KEY `fk_wpo_idx` (`product_option_id`),
  CONSTRAINT `fk_website_product_options` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_wpo` FOREIGN KEY (`product_option_id`) REFERENCES `product_options` (`product_option_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_product_shipping_method`
--

DROP TABLE IF EXISTS `website_product_shipping_method`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_product_shipping_method` (
  `product_id` int(11) DEFAULT NULL,
  `website_id` int(11) DEFAULT NULL,
  `website_shipping_method_id` int(11) DEFAULT NULL,
  `shipping_price` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_product_view`
--

DROP TABLE IF EXISTS `website_product_view`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_product_view` (
  `website_product_view_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `ip` char(15) CHARACTER SET latin1 DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  PRIMARY KEY (`website_product_view_id`),
  KEY `website_id` (`website_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15407904 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_products`
--

DROP TABLE IF EXISTS `website_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_products` (
  `website_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `alternate_price` float NOT NULL,
  `price` float NOT NULL,
  `sale_price` float NOT NULL,
  `wholesale_price` float NOT NULL,
  `inventory` int(11) NOT NULL,
  `additional_shipping_amount` float NOT NULL,
  `weight` float NOT NULL,
  `protection_amount` float NOT NULL,
  `additional_shipping_type` varchar(20) NOT NULL,
  `alternate_price_name` varchar(30) NOT NULL DEFAULT 'List Price',
  `meta_title` varchar(200) NOT NULL,
  `meta_description` varchar(250) NOT NULL,
  `meta_keywords` varchar(200) NOT NULL,
  `protection_type` varchar(20) NOT NULL,
  `price_note` varchar(100) NOT NULL,
  `product_note` text NOT NULL,
  `ships_in` varchar(60) NOT NULL,
  `store_sku` varchar(30) NOT NULL,
  `warranty_length` varchar(60) NOT NULL,
  `alternate_price_strikethrough` tinyint(1) NOT NULL,
  `display_inventory` tinyint(1) NOT NULL,
  `on_sale` tinyint(1) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `sequence` int(11) NOT NULL DEFAULT '100000',
  `blocked` int(1) NOT NULL DEFAULT '0',
  `active` int(1) NOT NULL DEFAULT '1',
  `manual_price` int(1) NOT NULL DEFAULT '0',
  `setup_fee` float DEFAULT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`website_id`,`product_id`),
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_website_products` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_reach_comments`
--

DROP TABLE IF EXISTS `website_reach_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_reach_comments` (
  `website_reach_comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_reach_id` int(11) NOT NULL,
  `website_user_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comment` text NOT NULL,
  `private` tinyint(1) NOT NULL DEFAULT '0',
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`website_reach_comment_id`),
  KEY `website_reach_id` (`website_reach_id`,`website_user_id`,`user_id`),
  KEY `fk_website_reach_comments_idx` (`website_reach_id`),
  CONSTRAINT `fk_website_reach_comments` FOREIGN KEY (`website_reach_id`) REFERENCES `website_reaches` (`website_reach_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5635 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_reach_meta`
--

DROP TABLE IF EXISTS `website_reach_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_reach_meta` (
  `website_reach_id` int(11) NOT NULL,
  `key` varchar(50) NOT NULL,
  `value` text NOT NULL,
  KEY `website_reach_id` (`website_reach_id`),
  CONSTRAINT `fk_website_reach_meta` FOREIGN KEY (`website_reach_id`) REFERENCES `website_reaches` (`website_reach_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_reaches`
--

DROP TABLE IF EXISTS `website_reaches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_reaches` (
  `website_reach_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `website_user_id` int(11) NOT NULL,
  `assigned_to_user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `waiting` tinyint(1) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `assigned_to_date` datetime NOT NULL,
  `date_created` datetime NOT NULL,
  `priority` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`website_reach_id`),
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_website_reaches` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=199974 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_settings`
--

DROP TABLE IF EXISTS `website_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_settings` (
  `website_id` int(11) NOT NULL,
  `key` varchar(50) NOT NULL,
  `value` mediumtext NOT NULL,
  PRIMARY KEY (`website_id`,`key`),
  KEY `fk_website_settings_idx` (`website_id`),
  CONSTRAINT `fk_website_settings` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_shipping_methods`
--

DROP TABLE IF EXISTS `website_shipping_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_shipping_methods` (
  `website_shipping_method_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `type` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `method` varchar(20) NOT NULL,
  `amount` float NOT NULL,
  `zip_codes` text NOT NULL,
  `extra` text NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`website_shipping_method_id`),
  KEY `website_id` (`website_id`),
  CONSTRAINT `fk_website_shipping_methods` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1293 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_sm_account`
--

DROP TABLE IF EXISTS `website_sm_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_sm_account` (
  `website_sm_account_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `sm` enum('facebook','twitter','foursquare') NOT NULL,
  `sm_reference_id` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `auth_information` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`website_sm_account_id`),
  KEY `website_sm_account_website_id` (`website_id`),
  CONSTRAINT `website_sm_account_website_id` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_sm_post`
--

DROP TABLE IF EXISTS `website_sm_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_sm_post` (
  `website_sm_post_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_sm_account_id` int(11) DEFAULT NULL,
  `content` text,
  `photo` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `post_at` datetime DEFAULT NULL,
  `timezone` varchar(80) DEFAULT NULL,
  `posted` int(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sm_message` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`website_sm_post_id`),
  KEY `website_sm_post_website_sm_account_id` (`website_sm_account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_tokens`
--

DROP TABLE IF EXISTS `website_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_tokens` (
  `website_token_id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(32) NOT NULL,
  `match` varchar(100) NOT NULL,
  `type` varchar(50) NOT NULL,
  `date_valid` datetime NOT NULL,
  PRIMARY KEY (`website_token_id`),
  KEY `key` (`key`,`match`)
) ENGINE=InnoDB AUTO_INCREMENT=303 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_top_brands`
--

DROP TABLE IF EXISTS `website_top_brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_top_brands` (
  `website_id` int(11) NOT NULL,
  `brand_id` int(11) NOT NULL,
  `sequence` int(11) NOT NULL,
  PRIMARY KEY (`website_id`,`brand_id`),
  KEY `fk_website_top_brands_idx` (`website_id`),
  CONSTRAINT `fk_website_top_brands` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_users`
--

DROP TABLE IF EXISTS `website_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_users` (
  `website_user_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL DEFAULT '',
  `password` varchar(64) NOT NULL DEFAULT '',
  `billing_name` varchar(100) DEFAULT NULL,
  `billing_first_name` varchar(50) DEFAULT NULL,
  `billing_last_name` varchar(50) DEFAULT NULL,
  `billing_address1` varchar(100) DEFAULT NULL,
  `billing_address2` varchar(100) DEFAULT NULL,
  `billing_city` varchar(100) DEFAULT NULL,
  `billing_state` varchar(30) DEFAULT NULL,
  `billing_zip` varchar(10) DEFAULT NULL,
  `billing_phone` varchar(13) NOT NULL,
  `billing_alt_phone` varchar(13) NOT NULL,
  `shipping_name` varchar(100) DEFAULT NULL,
  `shipping_first_name` varchar(50) DEFAULT NULL,
  `shipping_last_name` varchar(50) DEFAULT NULL,
  `shipping_address1` varchar(100) DEFAULT NULL,
  `shipping_address2` varchar(100) DEFAULT NULL,
  `shipping_city` varchar(100) DEFAULT NULL,
  `shipping_state` varchar(30) DEFAULT NULL,
  `shipping_zip` varchar(10) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `date_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`website_user_id`),
  KEY `email` (`email`),
  KEY `fk_website_users_idx` (`website_id`),
  CONSTRAINT `fk_website_users` FOREIGN KEY (`website_id`) REFERENCES `websites` (`website_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=139128 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_wishlist`
--

DROP TABLE IF EXISTS `website_wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_wishlist` (
  `website_wishlist_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_options` varchar(255) NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`website_wishlist_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4971 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_yext_analytics`
--

DROP TABLE IF EXISTS `website_yext_analytics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_yext_analytics` (
  `location_id` int(11) NOT NULL DEFAULT '0',
  `date` date NOT NULL DEFAULT '0000-00-00',
  `searches` int(11) DEFAULT NULL,
  `profile_views` int(11) DEFAULT NULL,
  `special_offer_clicks` int(11) DEFAULT NULL,
  `foursquare_checkins` int(11) DEFAULT NULL,
  `facebook_likes` int(11) DEFAULT NULL,
  `facebook_talking_about` int(11) DEFAULT NULL,
  `facebook_where_here` int(11) DEFAULT NULL,
  `yelp_views` int(11) DEFAULT NULL,
  PRIMARY KEY (`location_id`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_yext_bio`
--

DROP TABLE IF EXISTS `website_yext_bio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_yext_bio` (
  `website_yext_bio_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `website_yext_location_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`website_yext_bio_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1425498748 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_yext_category`
--

DROP TABLE IF EXISTS `website_yext_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_yext_category` (
  `id` int(11) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_yext_listing`
--

DROP TABLE IF EXISTS `website_yext_listing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_yext_listing` (
  `location_id` varchar(50) NOT NULL DEFAULT '',
  `site_id` varchar(50) NOT NULL DEFAULT '',
  `website_id` int(11) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `screenshot_url` varchar(255) DEFAULT NULL,
  `website_yext_listing_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`website_yext_listing_id`),
  KEY `website_yext_listing_website_id` (`website_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14430 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_yext_location`
--

DROP TABLE IF EXISTS `website_yext_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_yext_location` (
  `website_yext_location_id` int(11) NOT NULL AUTO_INCREMENT,
  `website_id` int(11) DEFAULT NULL,
  `synchronize_products` int(11) NOT NULL DEFAULT '0',
  `name` varchar(200) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`website_yext_location_id`),
  KEY `website_yext_location_website_id` (`website_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1072 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `website_yext_review`
--

DROP TABLE IF EXISTS `website_yext_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `website_yext_review` (
  `website_yext_review_id` int(11) NOT NULL DEFAULT '0',
  `location_id` int(11) DEFAULT NULL,
  `site_id` varchar(50) DEFAULT NULL,
  `rating` float DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` text,
  `author_name` varchar(255) DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  PRIMARY KEY (`website_yext_review_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `websites`
--

DROP TABLE IF EXISTS `websites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `websites` (
  `website_id` int(11) NOT NULL AUTO_INCREMENT,
  `company_package_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `os_user_id` int(11) NOT NULL,
  `user_id_updated` int(11) DEFAULT NULL,
  `server_id` int(11) NOT NULL,
  `domain` varchar(150) NOT NULL,
  `subdomain` varchar(50) NOT NULL,
  `title` varchar(100) NOT NULL DEFAULT 'Website Title',
  `plan_name` varchar(200) NOT NULL,
  `plan_description` text NOT NULL,
  `theme` varchar(50) NOT NULL DEFAULT 'theme1',
  `logo` varchar(200) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `pages` tinyint(4) NOT NULL DEFAULT '1',
  `mobile_pages` tinyint(4) NOT NULL DEFAULT '0',
  `products` int(11) NOT NULL DEFAULT '200',
  `product_catalog` tinyint(1) NOT NULL DEFAULT '1',
  `link_brands` tinyint(1) NOT NULL DEFAULT '0',
  `blog` tinyint(1) NOT NULL,
  `email_marketing` tinyint(1) NOT NULL,
  `geo_marketing` int(1) NOT NULL DEFAULT '0',
  `mobile_marketing` tinyint(1) NOT NULL,
  `shopping_cart` tinyint(1) NOT NULL,
  `seo` tinyint(4) NOT NULL,
  `room_planner` tinyint(1) NOT NULL,
  `craigslist` tinyint(1) NOT NULL,
  `social_media` tinyint(4) NOT NULL,
  `domain_registration` tinyint(1) NOT NULL,
  `additional_email_addresses` smallint(6) NOT NULL,
  `ftp_host` varchar(100) NOT NULL,
  `ftp_username` varchar(100) NOT NULL,
  `ftp_password` varchar(100) NOT NULL,
  `ga_profile_id` int(11) NOT NULL,
  `ga_tracking_key` varchar(20) NOT NULL,
  `wordpress_username` varchar(100) NOT NULL,
  `wordpress_password` varchar(100) NOT NULL,
  `mc_list_id` varchar(20) NOT NULL DEFAULT '0',
  `type` varchar(50) NOT NULL DEFAULT 'Furniture',
  `version` varchar(20) NOT NULL DEFAULT '0',
  `live` tinyint(1) NOT NULL DEFAULT '0',
  `status` int(11) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`website_id`),
  KEY `user_id` (`user_id`,`os_user_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1725 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-04-20 16:56:22
