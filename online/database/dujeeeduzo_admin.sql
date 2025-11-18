-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 18, 2025 at 11:19 AM
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
  `rp` int(11) DEFAULT NULL,
  `sp` int(11) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `country` varchar(50) NOT NULL,
  `blood_group` varchar(10) NOT NULL,
  `status` enum('red','prime') DEFAULT 'red',
  `joining_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `reg_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `account_holder` varchar(100) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `account_number` varchar(50) DEFAULT NULL,
  `ifsc_code` varchar(20) DEFAULT NULL,
  `branch_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`id`, `mlm_id`, `ref_id`, `full_name`, `phone`, `email`, `roll_no`, `rp`, `sp`, `password`, `country`, `blood_group`, `status`, `joining_date`, `reg_date`, `account_holder`, `bank_name`, `account_number`, `ifsc_code`, `branch_name`) VALUES
(1, 'DE000000', 'DENP000000', 'dujeeeduzonenepal', '990560289', 'chiranjibidhakal501@gmail.com', '5656678', 1600, 2000, '$2y$10$yxozRPihS89O/yJ5K9rdzuh64D4OfXDTkSzwa0Cx/3cN7ZXm694Tm', 'India', 'O+', 'prime', '2025-11-12 11:13:23', '2025-11-12 11:13:23', NULL, NULL, NULL, NULL, NULL),
(27, 'DE000001', 'DE000000', 'Chiranjibi Dhakal', '6294861380', 'chiranjibidhakal567@gmail.com', '', 1600, 2000, '$2y$10$Px.hWl0bBPcQkAvgjdkUcuCe77mW0xKUXKNuFw6/gs8/whpWxuX5q', 'India', 'O+', 'prime', '2025-11-13 13:38:06', '2025-11-13 13:38:06', NULL, NULL, NULL, NULL, NULL),
(28, 'DE000002', 'DE000001', 'Khabar Man Rai', '9847211939', 'krai9dujee@gmail.com', '', 1600, 2000, '$2y$10$8zh3kwGujkKZtNdIjLievOqemRAid1oTS55BerZ.oBWJiU.UTBm62', 'Nepal', 'AB+', 'prime', '2025-11-13 15:40:16', '2025-11-13 15:40:16', NULL, NULL, NULL, NULL, NULL),
(29, 'DE000003', 'DE000002', 'Pahal Man Limbu', '9761049954', 'pahalmanlimbu718@gmail.com', '', 1600, 2000, '$2y$10$zr8xV0fwZr/MogigaelYdu6UG6UniTvPz27NmMjpbmt5/7c4gTwY.', 'Nepal', 'A+', 'prime', '2025-11-13 15:52:49', '2025-11-13 15:52:49', NULL, NULL, NULL, NULL, NULL),
(30, 'DE000004', 'DE000003', 'Ganga bahadur pariyar', '9812350254', 'billionerganga2022@gmail.com', '', 1600, 2000, '$2y$10$CBcoyHdiIhuWf36nTay0SO0kBKi5tk5GhXM9mXSEEtuv0ig6nIiMC', 'Nepal', 'B+', 'prime', '2025-11-13 15:57:39', '2025-11-13 15:57:39', NULL, NULL, NULL, NULL, NULL),
(31, 'DE000005', 'DE000004', 'gaurav sundas', '9700440996', 'gangaihelp@gmail.com', '', 800, 1000, '$2y$10$Nw9oQzKoOVysWQjVbwwvue0Y7JlIFxjHpoOtRDAGSCjxrAnLqdPUO', 'Nepal', 'B+', 'red', '2025-11-13 16:06:26', '2025-11-13 16:06:26', NULL, NULL, NULL, NULL, NULL),
(32, 'DE000006', 'DE000003', 'kamal bahadur Pithakote thapa magar', '9807154293', 'kamalpithakote123@gmail.com', '', 800, 1000, '$2y$10$FHbseUPYc6qmXMrQF7a35eMUrtXo71twU1hjruw1yUTVuWqDjxqna', 'Nepal', 'B+', 'red', '2025-11-13 16:24:13', '2025-11-13 16:24:13', NULL, NULL, NULL, NULL, NULL),
(33, 'DE000007', 'DE000003', 'Bimala Limbu', '9820352723', 'bimal234@gmail.com', '', 800, 1000, '$2y$10$EI/OAepQd8/UuA7N66i1NeX6HJD0ZVncDPuMmtJrPtxhri8DvqIpW', 'Nepal', 'O+', 'red', '2025-11-13 16:30:22', '2025-11-13 16:30:22', NULL, NULL, NULL, NULL, NULL),
(35, 'DE000008', 'DE000002', 'Bishnu Kumar Rai', '9842223225', 'bishnur508@gmail.com', '', 800, 1000, '$2y$10$I2qggutwbFkl1LYnh8.YDerWVUcqiMDeGcIhPpc/KJHkMxJdr8dnO', 'Nepal', 'O+', 'red', '2025-11-14 02:36:23', '2025-11-14 02:36:23', NULL, NULL, NULL, NULL, NULL),
(36, 'DE000009', 'DE000002', 'Sandhya Shrestha', '9811372273', 'sandhyashrestha10695@gmail.com', '', 800, 1000, '$2y$10$T4swmO4mmVAqvzPa3pWIb.408bN/pGSNQyrj2QutoGptS04eWD1w.', 'Nepal', 'AB-', 'red', '2025-11-14 02:41:37', '2025-11-14 02:41:37', NULL, NULL, NULL, NULL, NULL),
(37, 'DE000010', 'DE000003', 'Dambar linkhim subba', '9823015292', 'devlingkhim977@gmail.com', '', 800, 1000, '$2y$10$7ilNa5mxFfJZrS7DfytvQeHrEi1ZFrkBZyPF7oa5LAdDZ03LV1Fb6', 'Nepal', 'AB+', 'red', '2025-11-14 05:02:06', '2025-11-14 05:02:06', NULL, NULL, NULL, NULL, NULL),
(38, 'DE000011', 'DE000003', 'Ful kumari tumbapo', '9814961742', 'Kful5496@gmail', '', 800, 1000, '$2y$10$JRb8c67vWmu8ke2d0PE2eeykdxcpPjO7AcIw0cTTzg5ckGOXKk0mC', 'Nepal', 'B+', 'red', '2025-11-14 05:04:42', '2025-11-14 05:04:42', NULL, NULL, NULL, NULL, NULL),
(39, 'DE000012', 'DE000002', 'Indra Devi Rai', '9816307721', 'indradevirai710@gmail.com', '', 800, 1000, '$2y$10$M81ZlwThlV6i6fZwd.r3QOh84TLIwZzgYXyBazz.iTyIhO7qpxZFS', 'Nepal', 'A+', 'red', '2025-11-14 05:52:33', '2025-11-14 05:52:33', NULL, NULL, NULL, NULL, NULL),
(40, 'DE000013', 'DE000002', 'Nama Kumari Rai', '9805909709', 'rainamakumari@gmail.com', '', 800, 1000, '$2y$10$XMKZSb4EEgcP5aSRXIucuOjMrl0Pysqv0KgVoAaZqbb2GgDSYyU6e', 'Nepal', 'AB-', 'red', '2025-11-14 05:57:33', '2025-11-14 05:57:33', NULL, NULL, NULL, NULL, NULL),
(41, 'DE000014', 'DE000002', 'Anusha Rai', '9742271915', 'anusha*@gmail.com', '', 800, 1000, '$2y$10$jSjoTThDvuGZaIabb.IewO0qhNxqIINcl6TAn0egs5NLAYU01lmu2', 'Nepal', 'O+', 'red', '2025-11-14 06:02:13', '2025-11-14 06:02:13', NULL, NULL, NULL, NULL, NULL),
(42, 'DE000015', 'DE000002', 'Ramesh Rai', '9814365300', 'ramesh*@gmail.com', '', 800, 1000, '$2y$10$6KP9PnZjOuYXex/7YL.Lhe2ITyM6rD64AarR6L9cUK0hoFMdPuiAS', 'Nepal', 'AB+', 'red', '2025-11-14 06:06:00', '2025-11-14 06:06:00', NULL, NULL, NULL, NULL, NULL),
(43, 'DE000016', 'DE000002', 'Uma Karki', '9804013419', 'uma*@gmail.com', '', 800, 1000, '$2y$10$PXWzGgYWaihTeNeKSC3CWuE9M.cgHfHupO8PCSFLbc19zq5udGJ6i', 'Nepal', 'AB+', 'red', '2025-11-14 06:09:44', '2025-11-14 06:09:44', NULL, NULL, NULL, NULL, NULL),
(44, 'DE000017', 'DE000002', 'Rajkumar Rouniyar', '9700861453', 'rajku*@gmail.com', '', 800, 1000, '$2y$10$YlTZU2zFHjKf8kruPEmev.zEOBdjLMkJw0.Esqa.Zx5VWFPGuCQQW', 'Nepal', 'O+', 'red', '2025-11-14 06:13:30', '2025-11-14 06:13:30', NULL, NULL, NULL, NULL, NULL),
(45, 'DE000018', 'DE000002', 'Anil Parsai', '9807394615', 'prasaianil1122@gmail.com', '', 800, 1000, '$2y$10$urD85Als/qQcbO6LgDjP/.TjW6Vlda7kEOnTCcxWvxJKgTyMndxce', 'Nepal', 'AB-', 'red', '2025-11-14 06:16:04', '2025-11-14 06:16:04', NULL, NULL, NULL, NULL, NULL),
(46, 'DE000019', 'DE000008', 'Kiran Rai', '9819379665', 'kiran*@gmail.com', '', 800, 1000, '$2y$10$0WCt6f8ZbZp0fvriUWDHyeiaO5RjlfAyIi.FJJ4ysDZ7hGSZWs/LS', 'Nepal', 'O+', 'red', '2025-11-14 07:12:56', '2025-11-14 07:12:56', NULL, NULL, NULL, NULL, NULL),
(47, 'DE000020', 'DE000008', 'Maiya Jogi', '9807050659', 'maiya*@gmail.com', '', 800, 1000, '$2y$10$KahBLwMFv7nKNU6us/HGzu3QdylxfYcPLYDmB4FHs5Qj4ouCZ0yoe', 'Nepal', 'AB-', 'red', '2025-11-14 07:21:41', '2025-11-14 07:21:41', NULL, NULL, NULL, NULL, NULL),
(48, 'DE000021', 'DE000008', 'Rokmani Devi Rai', '9805330339', 'rukma*@gmail.com', '', 800, 1000, '$2y$10$732ghg6lmUq1O5XZ1W6.DOz4ckwTC43BYFlgp8mWD346YAT/Gbb2K', 'Nepal', 'AB+', 'red', '2025-11-14 07:29:34', '2025-11-14 07:29:34', NULL, NULL, NULL, NULL, NULL),
(49, 'DE000022', 'DE000008', 'Binita Limbu', '9810540716', 'binita*@gmail.com', '', 800, 1000, '$2y$10$F2qfQeyX4yiJSyEVhYDoHOc6bCgsqLaeFVlQdfie3FvJ886GJwFVi', 'Nepal', 'B-', 'red', '2025-11-14 07:32:39', '2025-11-14 07:32:39', NULL, NULL, NULL, NULL, NULL),
(50, 'DE000023', 'DE000008', 'Gajendra Shrestha', '9842066440', 'gajendrastha440@gmail.com', '', 800, 1000, '$2y$10$c6WMEuv2fr83nFxJg7FGK..GcyI6mFUhhLOIdBT9bcM8.fIWNrJe2', 'Nepal', 'AB+', 'red', '2025-11-14 07:36:27', '2025-11-14 07:36:27', NULL, NULL, NULL, NULL, NULL),
(51, 'DE000024', 'DE000011', 'Dik kumari magar', '9816737284', 'magardikkumari@gmail', '', 800, 1000, '$2y$10$hgTIA8cj5UU/8dqT7J1i6.x6PhmC3b.c4JdZHToT8kuRTpDL3shNC', 'Nepal', 'A+', 'red', '2025-11-14 08:45:28', '2025-11-14 08:45:28', NULL, NULL, NULL, NULL, NULL),
(52, 'DE000025', 'DE000004', 'Bimal majhi', '9801410053', 'billionerbimal2026@gmail.com', '', 800, 1000, '$2y$10$Efblftr8t7Q/fxVlJqbz7uR7dYsvAtxDZR.ZfORV0Agb5vdCwPtGC', 'Nepal', 'AB+', 'red', '2025-11-14 10:20:47', '2025-11-14 10:20:47', NULL, NULL, NULL, NULL, NULL),
(53, 'DE000026', 'DE000004', 'harka bahadur biswakarma', '9812323691', 'biswokarmaharkabahadur@gmail.com', '', 800, 1000, '$2y$10$xDSuVbAxn1s45NHn2D.Ul.oXEGM5uj9qEJqoPjbeRL2CDZp8XlWjK', 'Nepal', 'A+', 'red', '2025-11-14 10:24:28', '2025-11-14 10:24:28', NULL, NULL, NULL, NULL, NULL),
(54, 'DE000027', 'DE000026', 'Hasta rai', '9814917307', 'hastarai4@gmail.com', '', 800, 1000, '$2y$10$vdKSVDp90JuFUjT.LUkk8OTdlRlEZ4XB0bkphPPheMV9f0dyiIywa', 'Nepal', 'A+', 'red', '2025-11-14 10:29:20', '2025-11-14 10:29:20', NULL, NULL, NULL, NULL, NULL),
(55, 'DE000028', 'DE000004', 'Binuta shrestha', '9848907461', 'binuta2000@gmail.com', '', 800, 1000, '$2y$10$RaSFhWv1wktT4Z4s9tfKkOzIgdLJChcpznYvCfuAKf3v3fb9TTdcS', 'Nepal', 'B+', 'red', '2025-11-14 10:35:24', '2025-11-14 10:35:24', NULL, NULL, NULL, NULL, NULL),
(56, 'DE000029', 'DE000019', 'Lxpa Diki Shrpa', '9804385923', NULL, '', 800, 1000, '$2y$10$9oBamGPMktOEsH1sNCgb0.6b97X28XHgzk/g99Skr47.vVgjqN94m', 'Nepal', 'AB-', 'red', '2025-11-14 10:41:38', '2025-11-14 10:41:38', NULL, NULL, NULL, NULL, NULL),
(57, 'DE000030', 'DE000019', 'Sirjana Gurung', '9769809349', '000000000', '', 800, 1000, '$2y$10$MxWwjAnL.d2Nmlpnd5d1I.iR19E3y4WweH3pjOBoYigS5r8JEF6ha', 'Nepal', 'B-', 'red', '2025-11-14 10:47:32', '2025-11-14 10:47:32', NULL, NULL, NULL, NULL, NULL),
(58, 'DE000031', 'DE000019', 'Kumar B. Karki', '9845033146', '00000000', '', 800, 1000, '$2y$10$gC./ypbf4wvJpFo2soGQnuA3/gSsZLyVOo2.uA0eXSJY8w4WjWToS', 'Nepal', 'O+', 'red', '2025-11-14 10:50:54', '2025-11-14 10:50:54', NULL, NULL, NULL, NULL, NULL),
(59, 'DE000032', 'DE000019', 'Dil B. Shrestha', '9815390232', '000000000', '', 800, 1000, '$2y$10$B4bW2kxtMA7bAohkeTlr0.xHl1aOVrK8HhzOLLiiH8bbP97CvIVVm', 'Nepal', 'A-', 'red', '2025-11-14 10:53:25', '2025-11-14 10:53:25', NULL, NULL, NULL, NULL, NULL),
(60, 'DE000033', 'DE000019', 'Rita Kumari Chaudhary', '9851061246', '000000000', '', 800, 1000, '$2y$10$HcSOE6zb7pc.C/6dxXTTEuNllz8Yq4MMFFNsel.nFgj6l1aROAO5u', 'Nepal', 'AB+', 'red', '2025-11-14 10:56:12', '2025-11-14 10:56:12', NULL, NULL, NULL, NULL, NULL),
(61, 'DE000034', 'DE000004', 'Radha devi paswan', '9862155031', 'rdp@gmail.com', '', 800, 1000, '$2y$10$rlNGYT1SWwwI0NT9cgkBgeUhCV4oxzAMSslKcuXbudjPVSSzsa9SO', 'Nepal', 'B+', 'red', '2025-11-14 10:56:55', '2025-11-14 10:56:55', NULL, NULL, NULL, NULL, NULL),
(62, 'DE000035', 'DE000021', 'Santi Gurung', '9860692087', '00000000', '', 800, 1000, '$2y$10$ahkmFT0HiH6mB/92b7s7N.nwXCgxIKp4GZbfv7bhxreYAx9Dr0WA.', 'Nepal', 'AB-', 'red', '2025-11-14 11:02:24', '2025-11-14 11:02:24', NULL, NULL, NULL, NULL, NULL),
(63, 'DE000036', 'DE000021', 'Kiran Rai', '9808226238', '000000000', '', 800, 1000, '$2y$10$DmF8NDlx1tHoFotIhRuVCOITxsqO0DGD3VUqOM6Q/GDFQ3EgITSm2', 'Nepal', 'O+', 'red', '2025-11-14 11:05:08', '2025-11-14 11:05:08', NULL, NULL, NULL, NULL, NULL),
(64, 'DE000037', 'DE000021', 'Dil Kumar Limbu', '9819392627', '000000000', '', 800, 1000, '$2y$10$sCz9/wWp92lmgDCNxycbyu6Pc51VdoqckidKpfI4s83yq9cFk75Uy', 'Nepal', 'A-', 'red', '2025-11-14 11:07:48', '2025-11-14 11:07:48', NULL, NULL, NULL, NULL, NULL),
(65, 'DE000038', 'DE000021', 'Kendra Maya Tharu', '9801358710', '000000000', '', 800, 1000, '$2y$10$rXPQukJjAieWbWInkcPiiuqzzBpzLeyj8JBG82TjTCD5zKRLZ0T0S', 'Nepal', 'AB+', 'red', '2025-11-14 11:10:28', '2025-11-14 11:10:28', NULL, NULL, NULL, NULL, NULL),
(66, 'DE000039', 'DE000021', 'Anju Bajgain', '9805330963', '000000000', '', 800, 1000, '$2y$10$SQ65wdKgIzm5Ej9oheqe0exusvKbcnndv4yEOO6I.9K1YbjblRG4C', 'Nepal', 'O+', 'red', '2025-11-14 11:13:11', '2025-11-14 11:13:11', NULL, NULL, NULL, NULL, NULL),
(67, 'DE000040', 'DE000022', 'Iswri Gimiray', '9842174208', '000000000', '', 800, 1000, '$2y$10$P1hjtLfixPcplOkyqyxuEOEHfi3b8PErhx0SGtoV.huqQ/cltR1u6', 'Nepal', 'AB-', 'red', '2025-11-14 11:18:02', '2025-11-14 11:18:02', NULL, NULL, NULL, NULL, NULL),
(68, 'DE000041', 'DE000022', 'Rukmani Rai', '9702509670', '000000000', '', 800, 1000, '$2y$10$1jPmwJSv/uPqoP6YFDqK9eQspcKYeC0Po2lm9FmGGmH.k0dTpcFwm', 'Nepal', 'B-', 'red', '2025-11-14 11:20:19', '2025-11-14 11:20:19', NULL, NULL, NULL, NULL, NULL),
(69, 'DE000042', 'DE000022', 'Mandabi Khatiwada', '9702681968', '000000000', '', 800, 1000, '$2y$10$h9g3eWNaCCyMvH3zDCbaGe.WiTAEOM1hsxWjVKLREuYxwWh6DWMRm', 'Nepal', 'AB-', 'red', '2025-11-14 11:23:50', '2025-11-14 11:23:50', NULL, NULL, NULL, NULL, NULL),
(70, 'DE000043', 'DE000022', 'Fulmati Chaudhary', '9862963857', '000000000', '', 800, 1000, '$2y$10$hThfkNCzs.SCNFpg06RT5e2HkdK32nfoSS9/yhrVbjTPDbYLFU45a', 'Nepal', 'AB+', 'red', '2025-11-14 11:26:57', '2025-11-14 11:26:57', NULL, NULL, NULL, NULL, NULL),
(71, 'DE000044', 'DE000022', 'Thakan Chaudhary', '9707255124', '000000000', '', 800, 1000, '$2y$10$yn8KYkuGIimJ9WzxFun/dufWSYJoNyjTWQvbfqkqvNfhmXHnppzgO', 'Nepal', 'O+', 'red', '2025-11-14 11:29:56', '2025-11-14 11:29:56', NULL, NULL, NULL, NULL, NULL),
(72, 'DE000045', 'DE000030', 'Bhola Adhikari', '9842229888', '000000000', '', 800, 1000, '$2y$10$3fqgYHhqWJY/HMZONTEDlusPt2ZZli1XVa87uC6ZsOJoYGJFYomiG', 'Nepal', 'B-', 'red', '2025-11-14 11:39:11', '2025-11-14 11:39:11', NULL, NULL, NULL, NULL, NULL),
(73, 'DE000046', 'DE000030', 'Mabar Rai', '9805353791', '000000000', '', 800, 1000, '$2y$10$Ncv6USvk.A2jt64R0G9mgez5LLL5z2UbvoJFZYuYkEDeOelsv2ytm', 'Nepal', 'B-', 'red', '2025-11-14 11:41:48', '2025-11-14 11:41:48', NULL, NULL, NULL, NULL, NULL),
(74, 'DE000047', 'DE000030', 'Hari Paudel', '9805346599', '000000000', '', 800, 1000, '$2y$10$vE8Z5YqAvo3jKdEY7ccQMO5QQmoZUOcQFz4aqT.VeJ.6lt.jsc4hW', 'Nepal', 'O+', 'red', '2025-11-14 11:44:12', '2025-11-14 11:44:12', NULL, NULL, NULL, NULL, NULL),
(75, 'DE000048', 'DE000030', 'Him Timsina', '9852054628', '000000000', '', 800, 1000, '$2y$10$6SiwE1u46umAjcSJ9z1lX.l9aXRbr0.GkVQ5ceXUVALt.QBfl/Gfu', 'Nepal', 'A+', 'red', '2025-11-14 11:47:02', '2025-11-14 11:47:02', NULL, NULL, NULL, NULL, NULL),
(76, 'DE000049', 'DE000030', 'Janga Bir Rai', '9829076179', '000000000', '', 800, 1000, '$2y$10$.XIFJ4JIj9I.l2J9tBjDm.cfLqj7WqgKOGTi.oF2k042VobcNVAam', 'Nepal', 'O+', 'red', '2025-11-14 11:50:40', '2025-11-14 11:50:40', NULL, NULL, NULL, NULL, NULL),
(77, 'DE000050', 'DE000031', 'Ramesh Raut', '9852090516', '000000000', '', 800, 1000, '$2y$10$bRg6p9B8xSEjVoXwcnut5uBnoqbD3bIiNboN7rk.y9ZcWlDe1vQeO', 'Nepal', 'O+', 'red', '2025-11-14 11:58:00', '2025-11-14 11:58:00', NULL, NULL, NULL, NULL, NULL),
(78, 'DE000051', 'DE000031', 'Charan Gurung', '9852056392', '000000000', '', 800, 1000, '$2y$10$PG82z7xMqFW/cUV5MaJYee3ueKwoSMgCljG.7YPV/PKPgWQKCZHj6', 'Nepal', 'AB+', 'red', '2025-11-14 12:04:12', '2025-11-14 12:04:12', NULL, NULL, NULL, NULL, NULL),
(79, 'DE000052', 'DE000031', 'Khadga B.Basnet', '9812398489', '00000000', '', 800, 1000, '$2y$10$1o4RSgrofMDBmklXJ3IyMuuoD3tHjxU9VOz/D1TTnn0siqt8AzD6W', 'Nepal', 'O-', 'red', '2025-11-14 12:08:51', '2025-11-14 12:08:51', NULL, NULL, NULL, NULL, NULL),
(80, 'DE000053', 'DE000031', 'Mohan Adhikari', '9852036047', '000000000', '', 800, 1000, '$2y$10$QGCXQhrvA/7220Is0/FHgeI/W3uquazYCEq3YGZWMaMo3pg5OLNWe', 'Nepal', 'AB-', 'red', '2025-11-14 12:11:41', '2025-11-14 12:11:41', NULL, NULL, NULL, NULL, NULL),
(81, 'DE000054', 'DE000031', 'Jiwan Khadka', '9804090251', '000000000', '', 800, 1000, '$2y$10$KJFjTb33ZOOeyqkhgQAjgehzoZYwQj0oODws.Df32WVKJuc3sst4e', 'Nepal', 'O-', 'red', '2025-11-14 12:14:03', '2025-11-14 12:14:03', NULL, NULL, NULL, NULL, NULL),
(82, 'DE000055', 'DE000032', 'Muna Rai', '9816004420', '000000000', '', 800, 1000, '$2y$10$/JrbDSqXiuLH2hURcyaDUOZmQIu2rE/6fLxqUnkhgPC1g9wMadk/a', 'Nepal', 'AB-', 'red', '2025-11-14 12:18:00', '2025-11-14 12:18:00', NULL, NULL, NULL, NULL, NULL),
(83, 'DE000056', 'DE000032', 'Durga Paudel', '9806352596', '000000000', '', 800, 1000, '$2y$10$PGb5w8xYTegT.Ay87V9Vj.ntcDCBwcXv2HD3If8kKonx/JEwiBYBC', 'Nepal', 'A-', 'red', '2025-11-14 12:20:15', '2025-11-14 12:20:15', NULL, NULL, NULL, NULL, NULL),
(84, 'DE000057', 'DE000032', 'Amisha Gurung', '9810044160', '000000000', '', 800, 1000, '$2y$10$Ek1LqPcDAKLCMVcCgDnpLe8ZeAaXCNNO6NYwB4sdW49owD0ymEZbO', 'Nepal', 'AB+', 'red', '2025-11-14 12:22:30', '2025-11-14 12:22:30', NULL, NULL, NULL, NULL, NULL),
(85, 'DE000058', 'DE000032', 'Arun Saha', '9842026656', '000000000', '', 800, 1000, '$2y$10$Us05r0su6bEC8KEZhFcjd./BIK7mivniU8TwOJKMZXgMWx6rlakgu', 'Nepal', 'O-', 'red', '2025-11-14 12:24:53', '2025-11-14 12:24:53', NULL, NULL, NULL, NULL, NULL),
(86, 'DE000059', 'DE000032', 'Kirshna K. Rai', '9819316426', '000000000', '', 800, 1000, '$2y$10$4uhB7HXrgk68069YT5PUeOq4MBLKAky3JbAeka8bYFl9O6Na2dh92', 'Nepal', 'A+', 'red', '2025-11-14 12:27:33', '2025-11-14 12:27:33', NULL, NULL, NULL, NULL, NULL),
(87, 'DE000060', 'DE000033', 'Bhakt Rajbansi', '9816357660', '000000000', '', 800, 1000, '$2y$10$UHqqNg935KaoHQGoDwK1terKG7R90Utw/23RjWW1t7tJ3AdJjItt6', 'Nepal', 'B-', 'red', '2025-11-14 12:36:44', '2025-11-14 12:36:44', NULL, NULL, NULL, NULL, NULL),
(88, 'DE000061', 'DE000033', 'Bhoj K.Shrestha', '9852054986', '000000000', '', 800, 1000, '$2y$10$aKzBjX.Iln5eSwuvgMAH9ugLpylDHN8Vo.lqIDzKQpYP6r728VDUi', 'Nepal', 'O+', 'red', '2025-11-14 12:40:02', '2025-11-14 12:40:02', NULL, NULL, NULL, NULL, NULL),
(89, 'DE000062', 'DE000033', 'Bholanath Basnet', '9824315188', '000000000', '', 800, 1000, '$2y$10$tvpgHn83ho.8fqmcbsVIreQnVtjCSpttJFIYLbJ62hSIpoz5kg5.i', 'Nepal', 'A-', 'red', '2025-11-14 12:42:12', '2025-11-14 12:42:12', NULL, NULL, NULL, NULL, NULL),
(90, 'DE000063', 'DE000033', 'Popendra Shrestha', '9827002651', '000000000', '', 800, 1000, '$2y$10$jxKPJAOOZqrD63fHSjVh5OP4V71Y1kt4cMVpp0MZsLmetKasi8TWG', 'Nepal', 'AB-', 'red', '2025-11-14 12:44:21', '2025-11-14 12:44:21', NULL, NULL, NULL, NULL, NULL),
(91, 'DE000064', 'DE000033', 'Taka Rai', '9762943873', '000000000', '', 800, 1000, '$2y$10$bPeLTqumG9n5Ih7KYMpGKe1dfGSSUb.VFVLF9ygJTZek2SljIRlYW', 'Nepal', 'O+', 'red', '2025-11-14 12:46:12', '2025-11-14 12:46:12', NULL, NULL, NULL, NULL, NULL),
(92, 'DE000065', 'DE000011', 'Prakash chaudhari', '9812772970', 'prakashchaudhari23@#.com', '', 800, 1000, '$2y$10$fyFRb6/SN/xWeRwfGFvcDOAYSg0xu3iD7IbXal.7tQIwFisjsRTM2', 'Nepal', 'B+', 'red', '2025-11-14 17:25:48', '2025-11-14 17:25:48', NULL, NULL, NULL, NULL, NULL),
(93, 'DE000066', 'DE000011', 'ram bahadur limbu tumbapo', '9824919433', 'ramtumbapo24@#.com', '', 800, 1000, '$2y$10$pQt9RhRwRIdn.oopoN5ymuYp0RuJ2d2Pzx8HaDoRBJ73v4lQNysiW', 'Nepal', 'AB+', 'red', '2025-11-14 17:37:34', '2025-11-14 17:37:34', NULL, NULL, NULL, NULL, NULL),
(94, 'DE000067', 'DE000011', 'Dik kumari magar', '9814153516', 'magardikkumari@gmail', '', 800, 1000, '$2y$10$y28XKiQuf21hY398PKIzAuLpZ98R3v1VFk7ZcxVOeV46SO4PLQH.q', 'Nepal', 'O+', 'red', '2025-11-14 17:49:58', '2025-11-14 17:49:58', NULL, NULL, NULL, NULL, NULL),
(95, 'DE000068', 'DE000011', 'Pemduki sherpa', '9861160983', 'mmayassepa@gmail', '', 800, 1000, '$2y$10$1zRjAXmdWddE1yiC80jiM.JdlxrGWEA6.sj29PPYnHBhsR6pUVXkW', 'Nepal', 'B+', 'red', '2025-11-15 03:30:01', '2025-11-15 03:30:01', NULL, NULL, NULL, NULL, NULL),
(96, 'DE000069', 'DE000068', 'jjj', '123456', 'w@gg.com', '', 800, 1000, '$2y$10$V.xgQ/27ARRtdakRbEbVFe9UnYYOPD4I2.dFrTCeK6KVyCDLFP2xu', 'India', 'O-', 'red', '2025-11-15 14:18:56', '2025-11-15 14:18:56', NULL, NULL, NULL, NULL, NULL),
(97, 'DE000070', 'DE000001', 'Anjana Chetri', '8637319458', 'ad@gmail.com', '', 1600, 2000, '$2y$10$VGwrIyammtaGZrcpK.fsr.dFLYnK6PoJbTGUBwsyqwo3q9j4rIy0u', 'India', 'A+', 'prime', '2025-11-15 14:24:01', '2025-11-15 14:24:01', NULL, NULL, NULL, NULL, NULL),
(98, 'DE000071', 'DE000070', '4555', '033', 'ss@gmail.com', '', 800, 1000, '$2y$10$.GKj7uhQRRnsO6iurLqn7eH9q8Ynsj0ZPP0VHsGaUNoYkIxZVRcB.', 'India', 'O+', 'red', '2025-11-15 14:29:25', '2025-11-15 14:29:25', NULL, NULL, NULL, NULL, NULL),
(99, 'DE000072', 'DE000023', 'Lok B. Basnet', '9824176990', '0000000000', '', 800, 1000, '$2y$10$0sdBeDgnOue450/AHALgHuPc07j/s9sxbxHA8Vq0tdVCMxC1nl0YG', 'Nepal', 'AB+', 'red', '2025-11-15 16:08:31', '2025-11-15 16:08:31', NULL, NULL, NULL, NULL, NULL),
(100, 'DE000073', 'DE000005', 'Keshab prasad phuyel', '9827041455', 'keshabphuyel@gmail.com', '', 800, 1000, '$2y$10$nHLaMfEQDrUnbY1PXf2FreAMpQ2slHSpZNlPoKMRjhtr78KhViuQS', 'Nepal', 'A+', 'red', '2025-11-16 05:03:05', '2025-11-16 05:03:05', NULL, NULL, NULL, NULL, NULL),
(101, 'DE000074', 'DE000005', 'damoder prasad gairapipli', '9709804606', 'streakk35@gmail.com', '', 800, 1000, '$2y$10$W3NsUSBNflFOUT68dbcdM.M3krbCal/hshuVK83G2fGbyvpZsA9ZW', 'Nepal', 'AB+', 'red', '2025-11-16 05:05:54', '2025-11-16 05:05:54', NULL, NULL, NULL, NULL, NULL),
(102, 'DE000075', 'DE000005', 'prince dikpal', '9744239733', 'ledgerblock101@gmail.com', '', 800, 1000, '$2y$10$2ke07H6qCSiv1AWxEdCRS.9GqvDXuN9OvB0qMyG07Ne.KQG6a7AVu', 'Nepal', 'A-', 'red', '2025-11-16 05:08:06', '2025-11-16 05:08:06', NULL, NULL, NULL, NULL, NULL),
(103, 'DE000076', 'DE000005', 'Harimaya pariyar', '980738696', 'ghanendrahelp@gmail.com', '', 800, 1000, '$2y$10$CmlIW/0Ciq8rK0S7of.57eNNLGPEcxT2itGDTfSBRIxo.NJwewlhC', 'Nepal', 'B+', 'red', '2025-11-16 05:10:52', '2025-11-16 05:10:52', NULL, NULL, NULL, NULL, NULL),
(104, 'DE000077', 'DE000005', 'rajkumar majhi', '9763706145', 'rkmajhi@gmail.com', '', 800, 1000, '$2y$10$bfFHi7NULkUED9pNnsv6F.cXSPLOMB4Pt/0elyG40d6caRh4Do/Hu', 'Nepal', 'B+', 'red', '2025-11-16 05:13:00', '2025-11-16 05:13:00', NULL, NULL, NULL, NULL, NULL),
(105, 'DE000078', 'DE000076', 'arun pariyar das', '9811346634', 'apd@gmail.com', '', 800, 1000, '$2y$10$WxQw1957PU.QaEzacbK7/OjhM7gFNbRB25o5g7FiehK.ALKufouPe', 'Nepal', 'A+', 'red', '2025-11-16 05:29:20', '2025-11-16 05:29:20', NULL, NULL, NULL, NULL, NULL),
(106, 'DE000079', 'DE000076', 'sanjay sundas', '9815351302', 'ssundas@gmail.com', '', 800, 1000, '$2y$10$CSfd9pr0zzZWVGhmCKgHPOgT3KhalWL8CwIHS3DserjUu7PhwLoCC', 'Nepal', 'AB+', 'red', '2025-11-16 05:31:48', '2025-11-16 05:31:48', NULL, NULL, NULL, NULL, NULL),
(107, 'DE000080', 'DE000076', 'Yam maya nepali', '9827027195', 'ymnepali@gmail.com', '', 800, 1000, '$2y$10$/DaRf9yTX6TIo98Jpglsk.VBYgo8McHumdN0AsmyyAju2Tr5a18g6', 'Nepal', 'B-', 'red', '2025-11-16 05:34:57', '2025-11-16 05:34:57', NULL, NULL, NULL, NULL, NULL),
(108, 'DE000081', 'DE000076', 'jagdishowr darji', '9825177017', 'jdarji@gmail.com', '', 800, 1000, '$2y$10$yD/q4TOxGTkqs8i9E90dMuU5/08VSi3vR/jX/1PG20CYxzeaCR0zW', 'Nepal', 'A+', 'red', '2025-11-16 05:39:38', '2025-11-16 05:39:38', NULL, NULL, NULL, NULL, NULL),
(109, 'DE000082', 'DE000001', 'Krishna Prasad Limbu', '1234567890', '0000', '', 1600, 2000, '$2y$10$JAIliW7iSuCU0UgmftVFxulR6KjtOoXrolLYc8OVNhxwos.zwpVYG', 'Nepal', 'O+', 'prime', '2025-11-16 05:40:11', '2025-11-16 05:40:11', NULL, NULL, NULL, NULL, NULL),
(110, 'DE000083', 'DE000001', 'Ganga Ram Sharma', '1234567891', '00000', '', 1600, 2000, '$2y$10$G6TJ5eKssYWV8bCsBDRym.CJBFLx7G1rGGW/T/xRhywwcjGgwXomS', 'India', 'O+', 'prime', '2025-11-16 05:42:05', '2025-11-16 05:42:05', NULL, NULL, NULL, NULL, NULL),
(111, 'DE000084', 'DE000076', 'durga maya nepali', '9847210818', 'dnepali@gmail.com', '', 800, 1000, '$2y$10$jruydAEAHgT.WwJNEVXlNuCID1/5eLu7/s//90pdAymu87xLmFNAa', 'Nepal', 'B+', 'red', '2025-11-16 05:42:45', '2025-11-16 05:42:45', NULL, NULL, NULL, NULL, NULL),
(112, 'DE000085', 'DE000001', 'Saran Rai', '1234567892', '000000', '', 1600, 2000, '$2y$10$df.RdPexVdfxtAXUhcRqiOUu8c.mmlD/Zn9qfuJvBx1eoHEeyKCI6', 'Nepal', 'O+', 'prime', '2025-11-16 05:43:38', '2025-11-16 05:43:38', NULL, NULL, NULL, NULL, NULL),
(113, 'DE000086', 'DE000001', 'Sunil Chamling', '1234567893', '0000000', '', 1600, 2000, '$2y$10$.FHj9ltezmCChgC24f0WAumLp5Mzm81CmtcJ746zIko3VEe9g7DdG', 'India', 'O+', 'prime', '2025-11-16 05:44:49', '2025-11-16 05:44:49', NULL, NULL, NULL, NULL, NULL),
(114, 'DE000087', 'DE000001', 'Dev Kumari Thapa', '1234567894', 'devk@gmail.com', '', 1600, 2000, '$2y$10$7XJO8iqDADMvdJV3ehZ29Oq.7C0eUZN8sK6Ba1/gPns4X.X3mFIAu', 'Nepal', 'O+', 'prime', '2025-11-16 05:46:50', '2025-11-16 05:46:50', NULL, NULL, NULL, NULL, NULL),
(115, 'DE000088', 'DE000001', 'Tara Prasad Ghimire', '1234567895', 'taraprasad@gmail.com', '', 1600, 2000, '$2y$10$WdXxPycRdaR7STwYrf1IlOEp4mm77q55UzLcfV5OeMyN0OXsUjuCO', 'Nepal', 'O+', 'prime', '2025-11-16 05:48:22', '2025-11-16 05:48:22', NULL, NULL, NULL, NULL, NULL),
(116, 'DE000089', 'DE000001', 'Prem Prasad Rai', '1234567896', 'prai@gmail.com', '', 1600, 2000, '$2y$10$6VefGh/5GeFeC/8q2rmiPerP8dxw1Vx73yT0viyhTr8rADfjp/PzC', 'India', 'O+', 'prime', '2025-11-16 05:49:53', '2025-11-16 05:49:53', NULL, NULL, NULL, NULL, NULL),
(117, 'DE000090', 'DE000001', 'Yam Bahadur Limbu', '1234567897', 'yam@gmail.com', '', 1600, 2000, '$2y$10$HfJ64Cy1cptfVsBz9Au1P.BV4HkNJpdQyfokUSMsjmyk6Dkr5JIXy', 'Nepal', 'O+', 'prime', '2025-11-16 05:50:54', '2025-11-16 05:50:54', NULL, NULL, NULL, NULL, NULL),
(118, 'DE000091', 'DE000026', 'Rajesh rai', '9826365151', 'rrai@gmail.com', '', 800, 1000, '$2y$10$29TltCX7iUrGmWD9mD5CNeV6IQaZop8sl8Uq.fKWF4nYxuUMXPf86', 'Nepal', 'AB+', 'red', '2025-11-16 05:56:56', '2025-11-16 05:56:56', NULL, NULL, NULL, NULL, NULL),
(119, 'DE000092', 'DE000026', 'tara devi parsai', '9814917301', 'parsaitaradevi@gmail.com', '', 800, 1000, '$2y$10$fZfHki0j5oilvCSif0ubiuzGXsaIg4ZxOd8q2TNWWVcfOoLl4YmYS', 'Nepal', 'O+', 'red', '2025-11-16 06:06:44', '2025-11-16 06:06:44', NULL, NULL, NULL, NULL, NULL),
(120, 'DE000093', 'DE000026', 'chandra thapa', '9816012570', 'cthapa@gmail.com', '', 800, 1000, '$2y$10$BlcgKJdoatwfwflvSoTIrePIE8sJ0nMx.rN7.1n72REuBXlepl2y2', 'Nepal', 'B+', 'red', '2025-11-16 06:09:45', '2025-11-16 06:09:45', NULL, NULL, NULL, NULL, NULL),
(121, 'DE000094', 'DE000026', 'ramesh rocka', '9817924332', 'rockaramesh@gmail.com', '', 800, 1000, '$2y$10$gAm8oqyNfdhPL9jujAiiNecz3yUuZrX/xnUnUqEEmsYiKa1gUHBNq', 'Nepal', 'AB+', 'red', '2025-11-16 06:12:26', '2025-11-16 06:12:26', NULL, NULL, NULL, NULL, NULL),
(122, 'DE000095', 'DE000026', 'govinda pradhan', '9815941061', 'gpradhan@gmail.com', '', 800, 1000, '$2y$10$L0DBWL9zMsCL8c4aL3XEoujKkgT6ZDDRzKjnSRcXoVlCvtEyKqhN.', 'Nepal', 'B+', 'red', '2025-11-16 06:16:40', '2025-11-16 06:16:40', NULL, NULL, NULL, NULL, NULL),
(123, 'DE000096', 'DE000023', 'Ram B.Raut', '9814380993', '00000000000', '', 800, 1000, '$2y$10$J.PBjruGfUg1MfLUfE3tmOTtF88vysSR7lOZoElN/7ssq9TxoP6eS', 'Nepal', 'AB-', 'red', '2025-11-16 07:20:27', '2025-11-16 07:20:27', NULL, NULL, NULL, NULL, NULL),
(124, 'DE000097', 'DE000023', 'Prashuram Rai', '9845034779', 'prashu*@gmail.com', '', 800, 1000, '$2y$10$JbzJmBzjNb08A78CEOpEn.JZHVtm.C9PQaoikq2HiDQ.qRegMhham', 'Nepal', 'AB-', 'red', '2025-11-16 07:32:46', '2025-11-16 07:32:46', NULL, NULL, NULL, NULL, NULL),
(125, 'DE000098', 'DE000023', 'Ram K. Tamang', '9817356783', '', '', 800, 1000, '$2y$10$iSFuOYwgGy2q5Ne4QrsZCuzqjx9pMVgtgG7KHY0fIszyeG1cuWztm', 'Nepal', 'AB+', 'red', '2025-11-16 07:35:09', '2025-11-16 07:35:09', NULL, NULL, NULL, NULL, NULL),
(126, 'DE000099', 'DE000023', 'Bhim B Shrestha', '9827015623', '', '', 800, 1000, '$2y$10$zdKvyiK75dG5GDzSW0ByFeIUv.Yj6jw44hZ6WuSMMFK0Bvcw8dyD6', 'Nepal', 'O-', 'red', '2025-11-16 07:37:28', '2025-11-16 07:37:28', NULL, NULL, NULL, NULL, NULL),
(127, 'DE000100', 'DE000072', 'Gopal Khatiwada', '9816332879', '', '', 800, 1000, '$2y$10$WcXkonkBOB2OcyfpXN2.oeqADswZrAs7F6oiXE.IGwugvKtdAOPnO', 'Nepal', 'A-', 'red', '2025-11-16 07:40:50', '2025-11-16 07:40:50', NULL, NULL, NULL, NULL, NULL),
(128, 'DE000101', 'DE000072', 'Khaem Paudel', '9842185555', '', '', 800, 1000, '$2y$10$/wv.v4GGuaVxFouNEWpJlOTgmKygp9LpYY7d99QfOeMGYJai1XJ9i', 'Nepal', 'O+', 'red', '2025-11-16 08:08:58', '2025-11-16 08:08:58', NULL, NULL, NULL, NULL, NULL),
(129, 'DE000102', 'DE000072', 'Kopila Jogi', '9816312400', '', '', 800, 1000, '$2y$10$HKWZG7rARVfLMZkeuhvqYudGEEMyIxbbWWz8C/Ogjrex00SaoO60i', 'Nepal', 'AB-', 'red', '2025-11-16 08:11:58', '2025-11-16 08:11:58', NULL, NULL, NULL, NULL, NULL),
(130, 'DE000103', 'DE000072', 'Santosh K. Nepal', '9804092454', '', '', 800, 1000, '$2y$10$FJJNqUknp7aj4A5BHuKqjue9r836eTgzYgJiFT7LbD.pGkEvrQMa.', 'Nepal', 'O+', 'red', '2025-11-16 08:14:57', '2025-11-16 08:14:57', NULL, NULL, NULL, NULL, NULL),
(131, 'DE000104', 'DE000072', 'Pabit Rai', '9819224708', 'DE000072', '', 800, 1000, '$2y$10$7XKX.p8ffPvGrR7WdgV9JuWvfUS3QBiXAycSDwFdpBhPHDnpXaeb2', 'Nepal', 'AB+', 'red', '2025-11-16 08:17:01', '2025-11-16 08:17:01', NULL, NULL, NULL, NULL, NULL),
(132, 'DE000105', 'DE000096', 'Sher Bahadur Basnet', '9819307122', '', '', 800, 1000, '$2y$10$RFegf5puW1oF482GEoRDQu4AT2t2yWyxgnGWxpyDUd4CkU4yuzogu', 'Nepal', 'AB+', 'red', '2025-11-16 08:20:55', '2025-11-16 08:20:55', NULL, NULL, NULL, NULL, NULL),
(133, 'DE000106', 'DE000096', 'Dip B. Das', '9825374670', '', '', 800, 1000, '$2y$10$4jhSU0RpBvuNlHILnKnMhOj8qNYfbTR/smbVGllyD7/atfzR6NtZG', 'Nepal', 'O-', 'red', '2025-11-16 08:23:11', '2025-11-16 08:23:11', NULL, NULL, NULL, NULL, NULL),
(134, 'DE000107', 'DE000096', 'Aita Lxmi Rai', '9807034856', '', '', 800, 1000, '$2y$10$cgZpQRgqLtly9HV2MLXi/.T02.3AAjk68QEmIia/e2HUK1wlyjwvm', 'Nepal', 'O+', 'red', '2025-11-16 08:25:20', '2025-11-16 08:25:20', NULL, NULL, NULL, NULL, NULL),
(135, 'DE000108', 'DE000096', 'Suraj Rai', '9813128401', '', '', 800, 1000, '$2y$10$gy/rYFMba1Ma2oyXtWZDDeW7jafiUqrG46EzcPDQN1uPs6yORwVE.', 'Nepal', 'A-', 'red', '2025-11-16 08:27:12', '2025-11-16 08:27:12', NULL, NULL, NULL, NULL, NULL),
(136, 'DE000109', 'DE000096', 'Ramjit Rai', '9826391652', '', '', 800, 1000, '$2y$10$g3omh8BCwAIPYrrh/j.4nuFz6StXAvOLm0QiA.tx0FwwlU/EKaaDO', 'Nepal', 'AB-', 'red', '2025-11-16 08:29:06', '2025-11-16 08:29:06', NULL, NULL, NULL, NULL, NULL),
(137, 'DE000110', 'DE000097', 'Mustakim Mansuri', '9705768786', '', '', 800, 1000, '$2y$10$Slj4.wy4.amX4yIhviF8aOkBOo6BNBnPZwTTKWffK3Z4GEAx8ZBkm', 'Nepal', 'B-', 'red', '2025-11-16 08:32:18', '2025-11-16 08:32:18', NULL, NULL, NULL, NULL, NULL),
(138, 'DE000111', 'DE000097', 'Tayab Miya', '9824396444', '', '', 800, 1000, '$2y$10$gSqsrySY.8rnG6WAHDx3leuU0m4oYEapsuWF8R0uG7dmECCPK4yHS', 'Nepal', 'O+', 'red', '2025-11-16 08:34:37', '2025-11-16 08:34:37', NULL, NULL, NULL, NULL, NULL),
(139, 'DE000112', 'DE000097', 'Madan Parajuli', '9810402991', '', '', 800, 1000, '$2y$10$ABj3Yo9SCjDIOWFW2TMSPu.rt8JbWeDnbfQu0h5DyBH4Kuage0etO', 'Nepal', 'B+', 'red', '2025-11-16 08:36:17', '2025-11-16 08:36:17', NULL, NULL, NULL, NULL, NULL),
(140, 'DE000113', 'DE000097', 'Prakash Bastola', '9803115591', '', '', 800, 1000, '$2y$10$kdFfiO1r4QfCLOGwlplT1eIKx0TyAD1MdrIqBp453rEK427XptnQO', 'Nepal', 'AB+', 'red', '2025-11-16 08:39:35', '2025-11-16 08:39:35', NULL, NULL, NULL, NULL, NULL),
(141, 'DE000114', 'DE000097', 'Dilkumari Rai', '9863603011', '', '', 800, 1000, '$2y$10$6lfYtxoDwi/nFRRA3Foagu15IwRyMc.BEgmIcQIp8UIFmHopYrVwi', 'Nepal', 'O+', 'red', '2025-11-16 08:41:43', '2025-11-16 08:41:43', NULL, NULL, NULL, NULL, NULL),
(142, 'DE000115', 'DE000098', 'Sarita Rai', '9842570646', '', '', 800, 1000, '$2y$10$xp9BPb9u9tw9RRdiGKOwCu1.I5Kq3rUAixy.xVqrw/vX94WEG4hsy', 'Nepal', 'O+', 'red', '2025-11-16 08:44:47', '2025-11-16 08:44:47', NULL, NULL, NULL, NULL, NULL),
(143, 'DE000116', 'DE000097', 'Rabina Panthi', '9860211169', '', '', 800, 1000, '$2y$10$xQ0RLsNxUS/kTRIW33k9BerR6KWNj3MU9V4sBHpp7QWEIleeedmYC', 'Nepal', 'B+', 'red', '2025-11-16 08:47:02', '2025-11-16 08:47:02', NULL, NULL, NULL, NULL, NULL),
(144, 'DE000117', 'DE000097', 'Pahalser Rai', '9861109331', '', '', 800, 1000, '$2y$10$My2d0YHOBx07iMub/QnTvuEWeYE.13xkSBdhlhJ0HO2Zb2FodIDrq', 'Nepal', 'O-', 'red', '2025-11-16 08:48:49', '2025-11-16 08:48:49', NULL, NULL, NULL, NULL, NULL),
(145, 'DE000118', 'DE000098', 'Tinjure Rai', '9865243952', '', '', 800, 1000, '$2y$10$fpYdrgOyMz6JP7tz5r3nI.Nlxro/0hs369srPy1JvAMoukG94osJW', 'Nepal', 'A-', 'red', '2025-11-16 08:50:46', '2025-11-16 08:50:46', NULL, NULL, NULL, NULL, NULL),
(146, 'DE000119', 'DE000098', 'Nite Rajbangsi', '9804918031', '', '', 800, 1000, '$2y$10$VYqeLgo71W7APqfDk0tR6uPhE8d1uFSPnUaC/XPWvRcoeOWXU5f8y', 'Nepal', 'AB-', 'red', '2025-11-16 08:52:54', '2025-11-16 08:52:54', NULL, NULL, NULL, NULL, NULL),
(147, 'DE000120', 'DE000099', 'Rajmati Subba', '9842436404', '', '', 800, 1000, '$2y$10$bVB8ayDwKw/AybA1rDaLCOzIHROfu/LNuSiHgVrOGn/4Q1qfkZVYa', 'Nepal', 'O-', 'red', '2025-11-16 08:55:21', '2025-11-16 08:55:21', NULL, NULL, NULL, NULL, NULL),
(148, 'DE000121', 'DE000099', 'Bhola Adhikari', '9852060562', '', '', 800, 1000, '$2y$10$olrk1KESXTSAGMgM8U9C3.J.pa/p0s2aaEoL/a5RzU2ymkcjiZxO.', 'Nepal', 'AB+', 'red', '2025-11-16 08:57:19', '2025-11-16 08:57:19', NULL, NULL, NULL, NULL, NULL),
(149, 'DE000122', 'DE000099', 'Ratna Bahadur Karki', '9842141945', '', '', 800, 1000, '$2y$10$0A30sxTiHCPYLnITq335kuLpBAm37AMyzHFbRtgS6HfBRP6d1VZ5q', 'Nepal', 'B-', 'red', '2025-11-16 08:59:16', '2025-11-16 08:59:16', NULL, NULL, NULL, NULL, NULL),
(150, 'DE000123', 'DE000099', 'Susil Budathoki', '9852038405', '', '', 800, 1000, '$2y$10$HeIGg.J72FKCdr8DZM.08OgJRt.Bj4GC5womY.p.i7wn80zW17cUO', 'Nepal', 'A-', 'red', '2025-11-16 09:01:09', '2025-11-16 09:01:09', NULL, NULL, NULL, NULL, NULL),
(151, 'DE000124', 'DE000099', 'Gopal Karki', '9842 08982', '', '', 800, 1000, '$2y$10$p.sdUnQsFBIzc5mx.9CVNOtZdZIsfI/9lFeR18cAVVNOT8.YLKeIe', 'Nepal', 'AB-', 'red', '2025-11-16 09:02:40', '2025-11-16 09:02:40', NULL, NULL, NULL, NULL, NULL),
(152, 'DE000125', 'DE000020', 'Abiral Rai', '9824308778', '', '', 800, 1000, '$2y$10$ihgWETaFZ7OnUEO8O9lgROykWaLZPJVyYOPYbpUMMnwj/oWreP/7y', 'Nepal', 'AB-', 'red', '2025-11-16 09:06:55', '2025-11-16 09:06:55', NULL, NULL, NULL, NULL, NULL),
(153, 'DE000126', 'DE000020', 'Dankumari Rai', '9826397878', '', '', 800, 1000, '$2y$10$lO32fXbXr4LjSX16vmVdr.M3LpzMQWofJm/mwg0Q1TKgQMCw3UUt2', 'Nepal', 'O+', 'red', '2025-11-16 09:08:40', '2025-11-16 09:08:40', NULL, NULL, NULL, NULL, NULL),
(154, 'DE000127', 'DE000020', 'Chandra Subba', '9808703058', '', '', 800, 1000, '$2y$10$Y4lYxcjBVmXk.W4kEAKpRuiCRjkVnroMyGzC5AoygqreTrckFnq7O', 'Nepal', 'A-', 'red', '2025-11-16 09:10:44', '2025-11-16 09:10:44', NULL, NULL, NULL, NULL, NULL),
(155, 'DE000128', 'DE000020', 'Nagendra Gutam', '9842637079', '', '', 800, 1000, '$2y$10$MSEhjTqIMM14Yn9LAKccD.wsUW761LAGJR3pwt/QTjdCXg6aGOa3G', 'Nepal', 'O-', 'red', '2025-11-16 09:12:35', '2025-11-16 09:12:35', NULL, NULL, NULL, NULL, NULL),
(156, 'DE000129', 'DE000020', 'Hem Bahadur Srestha', '9823584863', '', '', 800, 1000, '$2y$10$MCLYI2j2C3NAf5dixO7wae7/b4/WE1Do/aGQJjuqSEEQjIZdftbAS', 'Nepal', 'O+', 'red', '2025-11-16 09:15:09', '2025-11-16 09:15:09', NULL, NULL, NULL, NULL, NULL),
(157, 'DE000130', 'DE000029', 'Lalit Rai', '9842650297', '', '', 800, 1000, '$2y$10$a.2KWTh3dTdPRdX9NTLxI.d.zN6DzKn187LwZGgWkAOZWOMbw6Rra', 'Nepal', 'O+', 'red', '2025-11-16 09:26:08', '2025-11-16 09:26:08', NULL, NULL, NULL, NULL, NULL),
(158, 'DE000131', 'DE000029', 'Jitmaya Rai', '9842186717', '', '', 800, 1000, '$2y$10$..Nl6gsqU/9dHaifA30zaOq5QAiGx0Sa4OOdVuWGImvlFTbaMdoLy', 'Nepal', 'B+', 'red', '2025-11-16 09:28:13', '2025-11-16 09:28:13', NULL, NULL, NULL, NULL, NULL),
(159, 'DE000132', 'DE000029', 'Jiwan Niraula', '9816306168', '', '', 800, 1000, '$2y$10$szOGiIH.H50GxRdtK0vfXuO/Dlgyyc4aVBZaFWMtCX0Dsg7IpAkAa', 'Nepal', 'O-', 'red', '2025-11-16 09:30:17', '2025-11-16 09:30:17', NULL, NULL, NULL, NULL, NULL),
(160, 'DE000133', 'DE000029', 'Sbba Rai', '9816368547', '', '', 800, 1000, '$2y$10$AjF6034vaICVhl/3f2ya3.cgRx52HE.LB1qG6RF0PZDBH3erA4LKm', 'Nepal', 'AB-', 'red', '2025-11-16 09:31:56', '2025-11-16 09:31:56', NULL, NULL, NULL, NULL, NULL),
(161, 'DE000134', 'DE000029', 'Maru Karki', '9852057463', '', '', 800, 1000, '$2y$10$OyZeEvRn3XvHlSGdVlMHBeh29GBAGEVQPCU5mAZRgc.UHyQICZW.i', 'Nepal', 'AB-', 'red', '2025-11-16 09:33:30', '2025-11-16 09:33:30', NULL, NULL, NULL, NULL, NULL),
(162, 'DE000135', 'DE000125', 'Chndra Karki', '9842191707', '', '', 800, 1000, '$2y$10$xH/oOwWE9Xsn9YsNnm7S8OblIu5I6uxlkechvO17bAvvz4sPt0hLa', 'Nepal', 'O+', 'red', '2025-11-16 09:47:19', '2025-11-16 09:47:19', NULL, NULL, NULL, NULL, NULL),
(163, 'DE000136', 'DE000125', 'Rajendra Rai', '9749249792', '', '', 800, 1000, '$2y$10$wXKb5zHUN1Pja/Ilutam1.w2Az2cxN63h.h7xhCNAFhNDe5YDsE/C', 'Nepal', 'AB+', 'red', '2025-11-16 09:50:00', '2025-11-16 09:50:00', NULL, NULL, NULL, NULL, NULL),
(164, 'DE000137', 'DE000125', 'Menuka Rai', '9814315212', '', '', 800, 1000, '$2y$10$EN4FGYo97At1hIyXNfft2.HWZptUFCdfuzDHguCUIfFTwKreXjxW2', 'Nepal', 'O-', 'red', '2025-11-16 09:52:18', '2025-11-16 09:52:18', NULL, NULL, NULL, NULL, NULL),
(165, 'DE000138', 'DE000125', 'Naradmani Rai', '9827027610', '', '', 800, 1000, '$2y$10$C8urHtE2FtpykX5Q5rtyk.GQyA.LUMhrvslo9qzpRADlk/517FmQu', 'Nepal', 'AB-', 'red', '2025-11-16 09:55:07', '2025-11-16 09:55:07', NULL, NULL, NULL, NULL, NULL),
(166, 'DE000139', 'DE000125', 'Manihang Rai', '9808324143', '', '', 800, 1000, '$2y$10$JFgme47lV6Zh.bGSSsnbFuTD1jExgITumuh4dB047Lw/fIdQuAFmS', 'Nepal', 'A-', 'red', '2025-11-16 09:57:14', '2025-11-16 09:57:14', NULL, NULL, NULL, NULL, NULL),
(167, 'DE000140', 'DE000126', 'Danapati Nepal', '9807374870', '', '', 800, 1000, '$2y$10$SHwQQ8iuPOVk.MNJuQoR/OkRXj6jE3aVGXKLt2mWL/E.UTvLX8tO6', 'Nepal', 'AB+', 'red', '2025-11-16 10:09:25', '2025-11-16 10:09:25', NULL, NULL, NULL, NULL, NULL),
(168, 'DE000141', 'DE000126', 'Prabhulal Chaudhary', '9807387044', '', '', 800, 1000, '$2y$10$UuaeBspuW42ZQqy4rkNvreHVP0o.HcmipZAj7hY5nfyRW1PmUXiLS', 'Nepal', 'AB-', 'red', '2025-11-16 10:12:33', '2025-11-16 10:12:33', NULL, NULL, NULL, NULL, NULL),
(169, 'DE000142', 'DE000126', 'Kesab Gurung', '9804021892', '', '', 800, 1000, '$2y$10$MBHyFc5lQuPegADQAW8H5OsZMjxAkNpJL2U6lYY4wEpVIlgUHvIjO', 'Nepal', 'O-', 'red', '2025-11-16 10:14:22', '2025-11-16 10:14:22', NULL, NULL, NULL, NULL, NULL),
(170, 'DE000143', 'DE000126', 'Rabin Chaudhary', '9749921875', '', '', 800, 1000, '$2y$10$vyUV9/ZBPHx/720qAYRkA.5g0E4ijKm7amKdECXfXxFk2U7nuOBvC', 'Nepal', 'O+', 'red', '2025-11-16 10:16:02', '2025-11-16 10:16:02', NULL, NULL, NULL, NULL, NULL),
(171, 'DE000144', 'DE000126', 'Panch Kumari Rai', '9842445629', '', '', 800, 1000, '$2y$10$qBw7DxJJH6XF2mF5JtETlOhPbZD4bbJ1PKEjRGWmwiKWTHqP23h/G', 'Nepal', 'AB-', 'red', '2025-11-16 10:17:47', '2025-11-16 10:17:47', NULL, NULL, NULL, NULL, NULL),
(172, 'DE000145', 'DE000127', 'Bimala Rai', '9816006022', '', '', 800, 1000, '$2y$10$2ogAvAdlVrqOq59sbj2F7.b0CnETBMuL9pLZ/27.eyxzTDhaK4msq', 'Nepal', 'O+', 'red', '2025-11-16 10:23:02', '2025-11-16 10:23:02', NULL, NULL, NULL, NULL, NULL),
(173, 'DE000146', 'DE000127', 'Debimaya Sarki', '9819036641', '', '', 800, 1000, '$2y$10$qZ2NUtqsX5FLPZ5O29U/weLrzFZLlgPAx81V8TRN7zrPudBOB9Oy6', 'Nepal', 'O-', 'red', '2025-11-16 10:24:42', '2025-11-16 10:24:42', NULL, NULL, NULL, NULL, NULL),
(174, 'DE000147', 'DE000127', 'Renuka Rai', '9824341059', '', '', 800, 1000, '$2y$10$E3wAUC1zslQH0aQsSdNsPuxbMWuiFUoVJ85sL7yGPREzP6Lzxo9hS', 'Nepal', 'B+', 'red', '2025-11-16 10:26:32', '2025-11-16 10:26:32', NULL, NULL, NULL, NULL, NULL),
(175, 'DE000148', 'DE000127', 'Kousila Rana', '9861831869', '', '', 800, 1000, '$2y$10$twUUHFLdOhggcJ/X2FhR6.CGJm.g5Jt81UiFDfo6X9oavLUr6h1Ja', 'Nepal', 'AB-', 'red', '2025-11-16 10:28:19', '2025-11-16 10:28:19', NULL, NULL, NULL, NULL, NULL),
(176, 'DE000149', 'DE000127', 'Kabita Rai', '9804053524', '', '', 800, 1000, '$2y$10$QPnmTMe5H0HK05ACR/sMMu1kbtTOjVst9WolAB5PakyMgu09I6xty', 'Nepal', 'A-', 'red', '2025-11-16 10:29:54', '2025-11-16 10:29:54', NULL, NULL, NULL, NULL, NULL),
(177, 'DE000150', 'DE000128', 'Dipendra Chaudhary', '9818818095', '', '', 800, 1000, '$2y$10$kJQFoEX.LlC49Iqb2yHI6edyJ.4Ony.SeEN3yimuVvOlTdsZN.UPO', 'Nepal', 'AB-', 'red', '2025-11-16 10:32:42', '2025-11-16 10:32:42', NULL, NULL, NULL, NULL, NULL),
(178, 'DE000151', 'DE000128', 'Sujane Shrestha', '9819076881', '', '', 800, 1000, '$2y$10$H9g5iXkhI2v1mQmvXQdyd.Dj6eCSVLfuiGmUIxXui0yNvLlwxOW/O', 'Nepal', 'AB-', 'red', '2025-11-16 10:34:45', '2025-11-16 10:34:45', NULL, NULL, NULL, NULL, NULL),
(179, 'DE000152', 'DE000128', 'Krishna Nepal', '9842710285', '', '', 800, 1000, '$2y$10$IZisduuH5o9la4Y2xSAt0ubnjOlZDfRR8HKak9oQ99trq0wr3euRi', 'Nepal', 'B-', 'red', '2025-11-16 10:36:53', '2025-11-16 10:36:53', NULL, NULL, NULL, NULL, NULL),
(180, 'DE000153', 'DE000128', 'Dantosh K.c', '9812331708', '9803115591', '', 800, 1000, '$2y$10$sNGGwKVnsO4kJ7tbeMmdE.eV.Nk6SfhpNoQ1NKgWkRCa6NHyVSPva', 'Nepal', 'O+', 'red', '2025-11-16 10:38:38', '2025-11-16 10:38:38', NULL, NULL, NULL, NULL, NULL),
(181, 'DE000154', 'DE000128', 'Sabitra Guotam', '9805366441', '', '', 800, 1000, '$2y$10$SfncDyBz7eLNEEFfWfLg3Ojv4j.wLTJAe/cpaKHR8isItEdOK7Uvy', 'Nepal', 'A-', 'red', '2025-11-16 10:40:34', '2025-11-16 10:40:34', NULL, NULL, NULL, NULL, NULL),
(182, 'DE000155', 'DE000129', 'Dan Kumari Rai', '9812352422', '', '', 800, 1000, '$2y$10$3rk27serfPtGeFsrak7BqOX9O05BH6pFHGpScJyrbOFgpTpJpk8hO', 'Nepal', 'O+', 'red', '2025-11-16 10:43:24', '2025-11-16 10:43:24', NULL, NULL, NULL, NULL, NULL),
(183, 'DE000156', 'DE000129', 'Aasis Tamang', '9806005627', '', '', 800, 1000, '$2y$10$SYaZpbk3yRf2C8bDcWg2wOgun27CIqwwfCUh9agr.ctLz7ndBEF3K', 'Nepal', 'AB-', 'red', '2025-11-16 10:45:18', '2025-11-16 10:45:18', NULL, NULL, NULL, NULL, NULL),
(184, 'DE000157', 'DE000129', 'Sabita Chaudhary', '9842061097', '', '', 800, 1000, '$2y$10$FrFwn4rGhyWrdpYFt8yjD.0/qCwx/kUviM8KwM56qUh9/LXB5kiRu', 'Nepal', 'AB-', 'red', '2025-11-16 10:46:55', '2025-11-16 10:46:55', NULL, NULL, NULL, NULL, NULL),
(185, 'DE000158', 'DE000129', 'Karna Bahadur Basnet', '9868192047', '', '', 800, 1000, '$2y$10$vf57qtcxa5ONdjm/nxCBROSZCvwbwlUO6x1ney8H2ymwjTdE5I7L6', 'Nepal', 'O+', 'red', '2025-11-16 10:48:49', '2025-11-16 10:48:49', NULL, NULL, NULL, NULL, NULL),
(186, 'DE000159', 'DE000129', 'Abinarayan Chaudhary', '9816331237', '', '', 800, 1000, '$2y$10$Pgj8gKz4VKIv4wOVoUp4ROUVHe9oOoeJd1hs.bO9xtvpSVmR4DXMC', 'Nepal', 'A+', 'red', '2025-11-16 10:50:40', '2025-11-16 10:50:40', NULL, NULL, NULL, NULL, NULL),
(187, 'DE000160', 'DE000039', 'Aayusha Bagain', '9765379163', '', '', 800, 1000, '$2y$10$kpjHuC19JGvJBsaEI8RLEuLf1WfaThNj4pKn8aDEvcSYMBiNLUhry', 'Nepal', 'AB-', 'red', '2025-11-16 12:11:17', '2025-11-16 12:11:17', NULL, NULL, NULL, NULL, NULL),
(188, 'DE000161', 'DE000039', 'Kalpana Bhattarai', '9842148658', '', '', 800, 1000, '$2y$10$Fo/1wv7kLvlYp8cZjazPkObuQo3tYWh1YCKZMJ.ySyMnsqXhLPzAe', 'Nepal', 'O+', 'red', '2025-11-16 12:13:13', '2025-11-16 12:13:13', NULL, NULL, NULL, NULL, NULL),
(189, 'DE000162', 'DE000039', 'Aaysh Bagain', '9804342735', '', '', 800, 1000, '$2y$10$5xxwTf5p5NINWwP7vwqoyuFaWS9fWhx0RXbIInPobceHk7Cd/1HC2', 'Nepal', 'A-', 'red', '2025-11-16 12:15:15', '2025-11-16 12:15:15', NULL, NULL, NULL, NULL, NULL),
(190, 'DE000163', 'DE000039', 'Sashi Bagain', '9811010088', '', '', 800, 1000, '$2y$10$M5MzcNumn4EYml2ckF.5wuHPQFiCvI2V0TIkBHvcAb7rJrnGzPKvi', 'Nepal', 'O+', 'red', '2025-11-16 12:16:52', '2025-11-16 12:16:52', NULL, NULL, NULL, NULL, NULL),
(191, 'DE000164', 'DE000039', 'Jay Kumari Rai', '9848353824', '', '', 800, 1000, '$2y$10$MoulskM.7vU/B6Uonw47ROHS1lrKQSCcSgl9LcUTnNwKn0oY5fTR6', 'Nepal', 'A-', 'red', '2025-11-16 12:18:32', '2025-11-16 12:18:32', NULL, NULL, NULL, NULL, NULL),
(192, 'DE000165', 'DE000010', 'Kamala Limbu', '9812302544', 'kamallimbu23#@gmail.com', '', 800, 1000, '$2y$10$ocAmz5oA0X9rgkhrm7Smuu7kAO2lJtZjGiuF9kcDTx6LmTSvCAoDe', 'Nepal', 'B+', 'red', '2025-11-16 13:59:11', '2025-11-16 13:59:11', NULL, NULL, NULL, NULL, NULL),
(193, 'DE000166', 'DE000010', 'amish limkhim limbu', '9804090674', 'amishlimkhim45#@gmail.com', '', 800, 1000, '$2y$10$Usl/b5YuBXkPQBVo.MZwv.Vz3Er4vyXuxuQVe3KIPaA7r4WXZxTHe', 'Nepal', 'A+', 'red', '2025-11-16 14:02:41', '2025-11-16 14:02:41', NULL, NULL, NULL, NULL, NULL),
(194, 'DE000167', 'DE000010', 'Pabitra limbu', '9824756735', 'pabitralimbu43#@gmail.com', '', 800, 1000, '$2y$10$APBunN9qhjZa5tVygC8n8.G5pk1itiI8DTORNYhAyhszaUaRw0rFO', 'Nepal', 'B+', 'red', '2025-11-16 14:07:29', '2025-11-16 14:07:29', NULL, NULL, NULL, NULL, NULL),
(195, 'DE000168', 'DE000010', 'himal pande', '9842116547', 'himalpande45#@gmail.com', '', 800, 1000, '$2y$10$aOzCJjmrh2NEgEDrWDwJEuzMlFD43TMh.XCirQuW2qkzm66HA30cW', 'Nepal', 'AB+', 'red', '2025-11-16 14:13:27', '2025-11-16 14:13:27', NULL, NULL, NULL, NULL, NULL),
(196, 'DE000169', 'DE000010', 'man kumar limbu', '9804945596', 'mankumarlimbu56#@gmail.com', '', 800, 1000, '$2y$10$2ZSWqPFAQAiUdHJwfgmREO04F12vAIK7tU1LhPVkYATO1rT6Bw5Ey', 'Nepal', 'O+', 'red', '2025-11-16 14:16:23', '2025-11-16 14:16:23', NULL, NULL, NULL, NULL, NULL),
(197, 'DE000170', 'DE000010', 'Tek bahadur limbu', '9863499321', 'tekbahadurlimbu45#@gmail.com', '', 800, 1000, '$2y$10$SrAb6Kb1ZjgYA8sw/hEyD.PqDWNpBo79eVBnj6yOF923LOADDsmjS', 'Nepal', 'B+', 'red', '2025-11-16 14:23:51', '2025-11-16 14:23:51', NULL, NULL, NULL, NULL, NULL),
(198, 'DE000171', 'DE000011', 'Devi kumari shrestha', '9821321823', 'devikumarishresth67#@gmail.com', '', 800, 1000, '$2y$10$bs2nrUyiK1BVQFJGe9BQWOrcZpt0ndKxJxpqz.A8DyGFHrW7O5rR2', 'Nepal', 'B+', 'red', '2025-11-17 02:22:21', '2025-11-17 02:22:21', NULL, NULL, NULL, NULL, NULL),
(199, 'DE000172', 'DE000011', 'Naun kumar rai', '9745297706', 'naungkumarrai7#@gmail.com', '', 800, 1000, '$2y$10$jIByeuSYB3TnVOP/f8AiQuDdKGjLALJd9qL.y0fFvHTdz4Hd9NFpu', 'Nepal', 'AB-', 'red', '2025-11-17 02:26:38', '2025-11-17 02:26:38', NULL, NULL, NULL, NULL, NULL),
(200, 'DE000173', 'DE000025', 'Dipak pokhrel', '9842673327', 'pokhreld@gmail.com', '', 800, 1000, '$2y$10$uSE/yC5DnHgU8zencr57RejoQznbtmmMDacD6DxdtOfL0FrylxcdG', 'Nepal', 'A+', 'red', '2025-11-17 05:08:14', '2025-11-17 05:08:14', NULL, NULL, NULL, NULL, NULL),
(201, 'DE000174', 'DE000025', 'purna limbu', '9862614439', 'limbup39@gmail.com', '', 800, 1000, '$2y$10$gPyKAohIrEnOeBre.DldpuOZTWfSDZeBSTLQNnlpZvvuoJ51tZm6m', 'Nepal', 'AB+', 'red', '2025-11-17 05:12:10', '2025-11-17 05:12:10', NULL, NULL, NULL, NULL, NULL),
(202, 'DE000175', 'DE000025', 'Diksha khatiwada', '9842671321', 'khatiwadad@gmail.com', '', 800, 1000, '$2y$10$tM.jLfgG4n5HtyzIALO20.2yhbkMW.Qrk4MVbCSolgYwu4cagg8t6', 'Nepal', 'O+', 'red', '2025-11-17 05:14:48', '2025-11-17 05:14:48', NULL, NULL, NULL, NULL, NULL),
(203, 'DE000176', 'DE000025', 'pramila mahato', '9815944014', 'mahatop14@gmail.com', '', 800, 1000, '$2y$10$BhEutditAJdSv5HEHARu5.58CVjyYQoAQG5Ik3fO/LLBMDSMQxUmG', 'Nepal', 'O+', 'red', '2025-11-17 05:20:07', '2025-11-17 05:20:07', NULL, NULL, NULL, NULL, NULL),
(204, 'DE000177', 'DE000025', 'Rohit ray krishna', '9824954634', 'rohitdujee@gmail.com', '', 800, 1000, '$2y$10$zAp6cVbif8y.40JxvdCgWOOOkCqtQosMP3PXS2x60J4NT6g.RAoDi', 'Nepal', 'B+', 'red', '2025-11-17 05:23:23', '2025-11-17 05:23:23', NULL, NULL, NULL, NULL, NULL),
(205, 'DE000178', 'DE000027', 'Dambar kumar gajmer', '9807388863', 'gajmerdk@gmail.com', '', 800, 1000, '$2y$10$tWaL0wTEvI0VRYJt/7hy7ecogeoJPzfBLuDFiXg6Aox9Z8r5ZIKua', 'Nepal', 'O+', 'red', '2025-11-17 06:08:41', '2025-11-17 06:08:41', NULL, NULL, NULL, NULL, NULL),
(206, 'DE000179', 'DE000027', 'Krishna kumari sth', '9819365641', 'krishnakumasherestha78@gmail.com', '', 800, 1000, '$2y$10$2Y2XM3dv.ZTZMt2aL7nMWexq7U6yCh8xVrzJJbMAjoYu6rST0tYnS', 'Nepal', 'O+', 'red', '2025-11-17 06:12:49', '2025-11-17 06:12:49', NULL, NULL, NULL, NULL, NULL),
(207, 'DE000180', 'DE000002', 'Tony D\'suoza', '8902072138', 'sanjumukherjee786@gmail.com', '', 800, 1000, '$2y$10$S/5kJNsXR//VI5jsuDUBqeketkar7VveHt.fXQYm1HN4a1yyhkIju', 'India', 'A-', 'red', '2025-11-17 10:10:18', '2025-11-17 10:10:18', NULL, NULL, NULL, NULL, NULL),
(208, 'DE000181', 'DE000035', 'Sashinarayn Chaudhary', '9842095521', NULL, '', 800, 1000, '$2y$10$07vryaEuC0v3TRmx5DaaQuI5U3m.2X8AdlwjG5NXzbumQMLI5lgci', 'Nepal', 'AB-', 'red', '2025-11-17 11:56:30', '2025-11-17 11:56:30', NULL, NULL, NULL, NULL, NULL),
(209, 'DE000182', 'DE000035', 'Debi Achary', '9814051708', NULL, '', 800, 1000, '$2y$10$M.dpXX05rzYUSCiZN4uenOEsv/bt2/AkQ93ZQDiwUZds/eh.GxZ6i', 'Nepal', 'A+', 'red', '2025-11-17 11:59:46', '2025-11-17 11:59:46', NULL, NULL, NULL, NULL, NULL),
(210, 'DE000183', 'DE000035', 'Kalpana Chetri', '9815911870', NULL, '', 800, 1000, '$2y$10$tqiVP0mab8fmXjRDjcT.YeNtn9w0ZeDHRx0xZ.oBrI4Fa8wnwlFzO', 'Nepal', 'B+', 'red', '2025-11-17 12:01:30', '2025-11-17 12:01:30', NULL, NULL, NULL, NULL, NULL),
(211, 'DE000184', 'DE000035', 'Anupa K.C', '9811012834', NULL, '', 800, 1000, '$2y$10$dqdR8c5.QMlv/GX1.2K7cuFvAxdxPw4RNU4llrMnZRrIDiGhWPQG.', 'Nepal', 'B-', 'red', '2025-11-17 12:02:38', '2025-11-17 12:02:38', NULL, NULL, NULL, NULL, NULL),
(212, 'DE000185', 'DE000035', 'Rajib Saha', '9810581096', NULL, '', 800, 1000, '$2y$10$PGKC/9TIFV56RfGZ0sRAh.fahbHSgeg6JLfr1n9pllfcRG2rB4vTa', 'Nepal', 'O+', 'red', '2025-11-17 12:03:56', '2025-11-17 12:03:56', NULL, NULL, NULL, NULL, NULL),
(213, 'DE000186', 'DE000036', 'Udim Rai', '9808655319', NULL, '', 800, 1000, '$2y$10$epyZUQfk.hSFsd5WPic24efhgWGhJk8QHZLfRcnLkls6gXKtI17y6', 'Nepal', 'AB+', 'red', '2025-11-17 12:06:07', '2025-11-17 12:06:07', NULL, NULL, NULL, NULL, NULL),
(214, 'DE000187', 'DE000036', 'Yogendra Baraili', '9842236062', NULL, '', 800, 1000, '$2y$10$HX6TWwVsVJFpTkT5oVuEG.U3xpsMkkuWnmjg5TQouUM3JwUX4lG1O', 'Nepal', 'O-', 'red', '2025-11-17 12:07:38', '2025-11-17 12:07:38', NULL, NULL, NULL, NULL, NULL),
(215, 'DE000188', 'DE000036', 'Anil B.K', '9819398646', NULL, '', 800, 1000, '$2y$10$RKgApPlGGJGUHLEs1MPm5.rGtzTj8CDtarUy0oPCdHEld/NHo6J36', 'Nepal', 'AB+', 'red', '2025-11-17 12:08:52', '2025-11-17 12:08:52', NULL, NULL, NULL, NULL, NULL),
(216, 'DE000189', 'DE000036', 'Amit Magar', '9842145579', NULL, '', 800, 1000, '$2y$10$9xKycHVPxc4i.KUhql927.RQXqBjq9t2cfxkssMV1IsteN1tGx5Pq', 'Nepal', 'O-', 'red', '2025-11-17 12:10:06', '2025-11-17 12:10:06', NULL, NULL, NULL, NULL, NULL),
(217, 'DE000190', 'DE000037', 'Jayanti Rai', '9815744274', NULL, '', 800, 1000, '$2y$10$m34T6sZ6cPEr0sLAYhWSeOeCLnNJDqb29pO/23mzZl8MTCaK59.zW', 'Nepal', 'O+', 'red', '2025-11-17 12:12:03', '2025-11-17 12:12:03', NULL, NULL, NULL, NULL, NULL),
(218, 'DE000191', 'DE000037', 'Jitmaya Bhusal', '9842186718', NULL, '', 800, 1000, '$2y$10$lM1CYSSA7l0unSOqR4SYI.ST15gZnGQr39QhoxxHAshNOQbth0M8e', 'Nepal', 'AB-', 'red', '2025-11-17 12:14:09', '2025-11-17 12:14:09', NULL, NULL, NULL, NULL, NULL),
(219, 'DE000192', 'DE000037', 'Kesab Bhattarai', '9819059686', NULL, '', 800, 1000, '$2y$10$6KHnxTAeJyNTpXTNzZQLg./IRePayL4Vt/3pE4.RXkLwYA4g5.0o.', 'Nepal', 'AB+', 'red', '2025-11-17 12:15:55', '2025-11-17 12:15:55', NULL, NULL, NULL, NULL, NULL),
(220, 'DE000193', 'DE000037', 'Kumar Bhattarai', '9806082363', NULL, '', 800, 1000, '$2y$10$jm0Fa2lVXRNQ7r1udOTbseCfYwHowVw1SKPzHSb3UENpGx6MtKrCu', 'Nepal', 'B+', 'red', '2025-11-17 12:17:14', '2025-11-17 12:17:14', NULL, NULL, NULL, NULL, NULL),
(221, 'DE000194', 'DE000037', 'Khageswar Khatiwada', '9842321250', NULL, '', 800, 1000, '$2y$10$1zgmMHrBYjTorNfpF9wqduvsyKaJctKaeBTbBKErx2yc5gRVhd4lq', 'Nepal', 'A+', 'red', '2025-11-17 12:18:59', '2025-11-17 12:18:59', NULL, NULL, NULL, NULL, NULL),
(222, 'DE000195', 'DE000038', 'Tara Rai', '9801478252', NULL, '', 800, 1000, '$2y$10$7x3XZNKAVVKOW1f6ebaeCepS2MUR8/Om7oblDLs8VNFpsil3gPLOm', 'Nepal', 'O+', 'red', '2025-11-17 12:20:26', '2025-11-17 12:20:26', NULL, NULL, NULL, NULL, NULL),
(223, 'DE000196', 'DE000038', 'Naina Rai', '9827326248', NULL, '', 800, 1000, '$2y$10$N3I5kC3kRHyzl.uIsoeWSO1gPLn3BhoQm7MNAX73t/wMZwCoi.AoS', 'Nepal', 'A-', 'red', '2025-11-17 12:21:44', '2025-11-17 12:21:44', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `members` (`id`, `mlm_id`, `ref_id`, `full_name`, `phone`, `email`, `roll_no`, `rp`, `sp`, `password`, `country`, `blood_group`, `status`, `joining_date`, `reg_date`, `account_holder`, `bank_name`, `account_number`, `ifsc_code`, `branch_name`) VALUES
(224, 'DE000197', 'DE000038', 'Sabita Rai', '9819036599', NULL, '', 800, 1000, '$2y$10$xujkbwCvRXqm/L/vY4XrT.z08ofWjxi4Dzk/rRN1GcXpO3OJ.nspe', 'Nepal', 'O+', 'red', '2025-11-17 12:22:44', '2025-11-17 12:22:44', NULL, NULL, NULL, NULL, NULL),
(225, 'DE000198', 'DE000038', 'Badiraj Yakha', '9823846015', NULL, '', 800, 1000, '$2y$10$/Q9u8DDy1ZHzMXaouf4Ecehnp/5Wd2HP.ZTlxntwWEvVfNDNwQLw6', 'Nepal', 'B+', 'red', '2025-11-17 12:25:21', '2025-11-17 12:25:21', NULL, NULL, NULL, NULL, NULL),
(226, 'DE000199', 'DE000038', 'Kamak Rai', '9804339397', NULL, '', 800, 1000, '$2y$10$YH7jeiTehOKszQ/PIY02Buc0MCQxBUoBje8HwuzzZww1JdL0cZaFS', 'Nepal', 'AB-', 'red', '2025-11-17 12:26:36', '2025-11-17 12:26:36', NULL, NULL, NULL, NULL, NULL),
(227, 'DE000200', 'DE000036', 'Durga Rai', '9845054450', NULL, '', 800, 1000, '$2y$10$1aBmDFIDojT1CT8YuWO8/u8uf..rfIBDE.aTiTfZLZ2JzHJHvshfu', 'Nepal', 'A-', 'red', '2025-11-17 12:30:08', '2025-11-17 12:30:08', NULL, NULL, NULL, NULL, NULL),
(229, 'DE000201', 'DE000006', 'Bhakta bahadur pithakote magar', '9819304967', 'bhaktabahadurpithakote67#@gmail.com', '', 800, 1000, '$2y$10$9JdiMt7dB5bzT2EG1L00NeyR7nfR0WgmsVRYZw0j7siNhpcK7Vzom', 'Nepal', 'B+', 'red', '2025-11-17 13:58:32', '2025-11-17 13:58:32', NULL, NULL, NULL, NULL, NULL),
(230, 'DE000202', 'DE000006', 'min kumari lama', '9822223963', 'minkumarilama15#@gmail.com', '', 800, 1000, '$2y$10$paOUZOWhmPaLBYUzm34XMuaCkedGi4yM9BU7BCRlaRL87lFlJwEtm', 'Nepal', 'AB+', 'red', '2025-11-17 15:36:35', '2025-11-17 15:36:35', NULL, NULL, NULL, NULL, NULL),
(231, 'DE000203', 'DE000006', 'Puspalal shresth', '9845685284', 'puspslalshresth23#@gmail.com', '', 800, 1000, '$2y$10$n.EAummTOv444pnSZdCMZuMT8q90LLPWxJS4FrOcfIOsHWoox86B2', 'Nepal', 'B+', 'red', '2025-11-17 15:39:31', '2025-11-17 15:39:31', NULL, NULL, NULL, NULL, NULL),
(232, 'DE000204', '', '', '', NULL, '', 800, 1000, '$2y$10$VpGplXtPCsHvaXDtjJT1qu.vaQPigWQ0vfRSUdeR0CTyZ92QRXhl2', '', '', 'red', '2025-11-17 16:25:48', '2025-11-17 16:25:48', NULL, NULL, NULL, NULL, NULL),
(233, 'DE000205', 'DE000028', 'Asmita sth', '9820378549', 'asmitamillioner@gmail.com', '', 800, 1000, '$2y$10$N6PrUmf.7d1gFso662e/bedHJXwOm10DzjFRQxn/PZN72zFgwVWau', 'Nepal', 'O+', 'red', '2025-11-18 05:48:17', '2025-11-18 05:48:17', NULL, NULL, NULL, NULL, NULL),
(234, 'DE000206', 'DE000028', 'balkumar sherestha', '9704504044', 'sthb@gmail.com', '', 800, 1000, '$2y$10$CdT2OUU0em6VwrqdI.tojO1FwncC2JTFxAcrJwc4ODCwZIBP56a62', 'Nepal', 'AB-', 'red', '2025-11-18 05:52:53', '2025-11-18 05:52:53', NULL, NULL, NULL, NULL, NULL),
(235, 'DE000207', 'DE000028', 'yashodha shrestha', '9862810794', 'ysth@gmail.com', '', 800, 1000, '$2y$10$Ug0rkgf9OCtWDbU0h7R0Y.f9EGe3YztPJvLJ4ajy0bSVhwYoWtXoC', 'Nepal', 'B+', 'red', '2025-11-18 05:56:16', '2025-11-18 05:56:16', NULL, NULL, NULL, NULL, NULL),
(236, 'DE000208', 'DE000028', 'rewata sherestha', '9861463065', 'srewata@gmail.com', '', 800, 1000, '$2y$10$3jY6UbVZZP7vfQs69a1Zy.zUrMmwjncolbXRN.AfPmhfjbLLa.Jsu', 'Nepal', 'A+', 'red', '2025-11-18 06:01:09', '2025-11-18 06:01:09', NULL, NULL, NULL, NULL, NULL),
(237, 'DE000209', 'DE000028', 'tej bahadur sth', '9814381274', 'stb@gmail.com', '', 800, 1000, '$2y$10$m3buhf5IthXinK2vm7ERh.SET9yb4cNQ3fkx1N/pgU0IJE19aEDne', 'Nepal', 'AB-', 'red', '2025-11-18 06:04:07', '2025-11-18 06:04:07', NULL, NULL, NULL, NULL, NULL),
(238, 'DE000210', 'DE000205', 'Rojanta rai', '9815306520', 'rjrai@gmail.com', '', 800, 1000, '$2y$10$JTmF6ck4aQ1hUG1WXMQc8.g6LTVQJWxAlA542Ww0NlGm9PwCNDL2O', 'Nepal', 'B+', 'red', '2025-11-18 06:21:58', '2025-11-18 06:21:58', NULL, NULL, NULL, NULL, NULL),
(239, 'DE000211', 'DE000205', 'Man bahadur sth', '9819365010', 'smb@gmail.com', '', 800, 1000, '$2y$10$cMwcuTEZ7HfXQc4SPwMP6ebVwUiuguqDusBU9pjKPqBBnzsBIQSiC', 'Nepal', 'A+', 'red', '2025-11-18 08:48:13', '2025-11-18 08:48:13', NULL, NULL, NULL, NULL, NULL),
(240, 'DE000212', 'DE000205', 'amrita bantawa', '9826346091', 'ba@gmail.com', '', 800, 1000, '$2y$10$FFYkmKPobllthEvkPUPP/.zBA6oGNBUANQ/XAon0yE0nZ8YXdhrhO', 'Nepal', 'AB-', 'red', '2025-11-18 08:50:54', '2025-11-18 08:50:54', NULL, NULL, NULL, NULL, NULL),
(241, 'DE000213', 'DE000205', 'pujan pariyar', '9804382062', 'pp@gmail.com', '', 800, 1000, '$2y$10$glHGhy2aINb/ygrW2bWQKeH2bYrKUqyTkuheC/.7cIs5mQ7fqtAbm', 'Nepal', 'B+', 'red', '2025-11-18 08:53:03', '2025-11-18 08:53:03', NULL, NULL, NULL, NULL, NULL),
(242, 'DE000214', 'DE000205', 'rajkumar soden', '9815371011', 'rs@gamail.com', '', 800, 1000, '$2y$10$rNyTwYOIQSilmMEzwR8cyuyTermqM0vEK.p11M59wLgrfd0NRkLSG', 'Nepal', 'O+', 'red', '2025-11-18 08:57:01', '2025-11-18 08:57:01', NULL, NULL, NULL, NULL, NULL);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=243;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
