-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 13, 2025 at 01:59 PM
-- Server version: 10.6.24-MariaDB
-- PHP Version: 8.4.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dujeeeduzo_admin`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`dujeeeduzo`@`localhost` PROCEDURE `GenerateNewMLMID` (OUT `new_mlm_id` VARCHAR(20))   BEGIN
    DECLARE last_number INT;
    DECLARE new_number VARCHAR(6);
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(mlm_id, 6) AS UNSIGNED)), 0) INTO last_number 
    FROM members;
    
    SET last_number = last_number + 1;
    SET new_number = LPAD(last_number, 6, '0');
    SET new_mlm_id = CONCAT('NPMLM', new_number);
END$$

CREATE DEFINER=`dujeeeduzo`@`localhost` PROCEDURE `ValidateReferral` (IN `p_ref_id` VARCHAR(20), OUT `p_is_valid` BOOLEAN, OUT `p_status` VARCHAR(10), OUT `p_message` VARCHAR(255))   BEGIN
    DECLARE member_count INT;
    DECLARE member_status VARCHAR(10);
    
    SELECT COUNT(*), status INTO member_count, member_status
    FROM members 
    WHERE mlm_id = p_ref_id;
    
    IF member_count = 0 THEN
        SET p_is_valid = FALSE;
        SET p_status = NULL;
        SET p_message = 'Invalid Referred ID';
    ELSEIF member_status != 'prime' THEN
        SET p_is_valid = FALSE;
        SET p_status = member_status;
        SET p_message = 'Referred member is not prime';
    ELSE
        SET p_is_valid = TRUE;
        SET p_status = member_status;
        SET p_message = 'Valid prime member';
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

CREATE TABLE `admin_users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('superadmin','admin','moderator') DEFAULT 'admin',
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `status`, `created_at`, `last_login`) VALUES
(1, 'admin', 'admin', 'System Administrator', 'admin@npmlm.com', 'superadmin', 'active', '2025-11-11 11:54:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `id` int(11) NOT NULL,
  `mlm_id` varchar(20) NOT NULL,
  `ref_id` varchar(20) DEFAULT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `roll_no` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `country` varchar(50) NOT NULL,
  `blood_group` varchar(10) NOT NULL,
  `status` enum('red','prime') DEFAULT 'red',
  `joining_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `reg_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`id`, `mlm_id`, `ref_id`, `full_name`, `phone`, `email`, `roll_no`, `password`, `country`, `blood_group`, `status`, `joining_date`, `reg_date`) VALUES
(1, 'DE000000', 'DENP000000', 'dujeeeduzonenepal', '990560289', 'chiranjibidhakal501@gmail.com', '5656678', '$2y$10$yxozRPihS89O/yJ5K9rdzuh64D4OfXDTkSzwa0Cx/3cN7ZXm694Tm', 'India', 'O+', 'prime', '2025-11-12 11:13:23', '2025-11-12 11:13:23'),
(27, 'DE000001', 'DE000000', 'Chiranjibi Dhakal', '6294861380', 'chiranjibidhakal567@gmail.com', '', '$2y$10$Px.hWl0bBPcQkAvgjdkUcuCe77mW0xKUXKNuFw6/gs8/whpWxuX5q', 'India', 'O+', 'red', '2025-11-13 13:38:06', '2025-11-13 13:38:06');

-- --------------------------------------------------------

--
-- Table structure for table `system_settings`
--

CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text NOT NULL,
  `description` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `system_settings`
--

INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `description`, `updated_at`) VALUES
(1, 'company_name', 'Dujeeeduzone Nepal', 'Official company name', '2025-11-11 11:54:53'),
(2, 'company_address', 'Kathmandu, Nepal', 'Company headquarters address', '2025-11-11 11:54:53');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idx_username` (`username`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mlm_id` (`mlm_id`),
  ADD KEY `idx_mlm_id` (`mlm_id`),
  ADD KEY `idx_ref_id` (`ref_id`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`),
  ADD KEY `idx_setting_key` (`setting_key`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
