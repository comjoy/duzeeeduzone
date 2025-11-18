-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 18, 2025 at 12:19 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `npmlm_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerateNewMLMID` (OUT `new_mlm_id` VARCHAR(20))   BEGIN
    DECLARE last_number INT;
    DECLARE new_number VARCHAR(6);
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(mlm_id, 6) AS UNSIGNED)), 0) INTO last_number 
    FROM members;
    
    SET last_number = last_number + 1;
    SET new_number = LPAD(last_number, 6, '0');
    SET new_mlm_id = CONCAT('NPMLM', new_number);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ValidateReferral` (IN `p_ref_id` VARCHAR(20), OUT `p_is_valid` BOOLEAN, OUT `p_status` VARCHAR(10), OUT `p_message` VARCHAR(255))   BEGIN
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
(31, 'DE000005', 'DE000003', 'gaurav sundas', '9700440996', 'gangaihelp@gmail.com', '', 800, 1000, '$2y$10$Nw9oQzKoOVysWQjVbwwvue0Y7JlIFxjHpoOtRDAGSCjxrAnLqdPUO', 'Nepal', 'B+', 'red', '2025-11-13 16:06:26', '2025-11-13 16:06:26', NULL, NULL, NULL, NULL, NULL),
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
(52, 'DE000025', 'DE000003', 'Bimal majhi', '9801410053', 'billionerbimal2026@gmail.com', '', 800, 1000, '$2y$10$Efblftr8t7Q/fxVlJqbz7uR7dYsvAtxDZR.ZfORV0Agb5vdCwPtGC', 'Nepal', 'AB+', 'red', '2025-11-14 10:20:47', '2025-11-14 10:20:47', NULL, NULL, NULL, NULL, NULL),
(53, 'DE000026', 'DE000003', 'harka bahadur biswakarma', '9812323691', 'biswokarmaharkabahadur@gmail.com', '', 800, 1000, '$2y$10$xDSuVbAxn1s45NHn2D.Ul.oXEGM5uj9qEJqoPjbeRL2CDZp8XlWjK', 'Nepal', 'A+', 'red', '2025-11-14 10:24:28', '2025-11-14 10:24:28', NULL, NULL, NULL, NULL, NULL),
(54, 'DE000027', 'DE000026', 'Hasta rai', '9814917307', 'hastarai4@gmail.com', '', 800, 1000, '$2y$10$vdKSVDp90JuFUjT.LUkk8OTdlRlEZ4XB0bkphPPheMV9f0dyiIywa', 'Nepal', 'A+', 'red', '2025-11-14 10:29:20', '2025-11-14 10:29:20', NULL, NULL, NULL, NULL, NULL),
(55, 'DE000028', 'DE000003', 'Binuta shrestha', '9848907461', 'binuta2000@gmail.com', '', 800, 1000, '$2y$10$RaSFhWv1wktT4Z4s9tfKkOzIgdLJChcpznYvCfuAKf3v3fb9TTdcS', 'Nepal', 'B+', 'red', '2025-11-14 10:35:24', '2025-11-14 10:35:24', NULL, NULL, NULL, NULL, NULL),
(56, 'DE000029', 'DE000019', 'Lxpa Diki Shrpa', '9804385923', NULL, '', 800, 1000, '$2y$10$9oBamGPMktOEsH1sNCgb0.6b97X28XHgzk/g99Skr47.vVgjqN94m', 'Nepal', 'AB-', 'red', '2025-11-14 10:41:38', '2025-11-14 10:41:38', NULL, NULL, NULL, NULL, NULL),
(57, 'DE000030', 'DE000019', 'Sirjana Gurung', '9769809349', '000000000', '', 800, 1000, '$2y$10$MxWwjAnL.d2Nmlpnd5d1I.iR19E3y4WweH3pjOBoYigS5r8JEF6ha', 'Nepal', 'B-', 'red', '2025-11-14 10:47:32', '2025-11-14 10:47:32', NULL, NULL, NULL, NULL, NULL),
(58, 'DE000031', 'DE000019', 'Kumar B. Karki', '9845033146', '00000000', '', 800, 1000, '$2y$10$gC./ypbf4wvJpFo2soGQnuA3/gSsZLyVOo2.uA0eXSJY8w4WjWToS', 'Nepal', 'O+', 'red', '2025-11-14 10:50:54', '2025-11-14 10:50:54', NULL, NULL, NULL, NULL, NULL),
(59, 'DE000032', 'DE000019', 'Dil B. Shrestha', '9815390232', '000000000', '', 800, 1000, '$2y$10$B4bW2kxtMA7bAohkeTlr0.xHl1aOVrK8HhzOLLiiH8bbP97CvIVVm', 'Nepal', 'A-', 'red', '2025-11-14 10:53:25', '2025-11-14 10:53:25', NULL, NULL, NULL, NULL, NULL),
(60, 'DE000033', 'DE000019', 'Rita Kumari Chaudhary', '9851061246', '000000000', '', 800, 1000, '$2y$10$HcSOE6zb7pc.C/6dxXTTEuNllz8Yq4MMFFNsel.nFgj6l1aROAO5u', 'Nepal', 'AB+', 'red', '2025-11-14 10:56:12', '2025-11-14 10:56:12', NULL, NULL, NULL, NULL, NULL),
(61, 'DE000034', 'DE000003', 'Radha devi paswan', '9862155031', 'rdp@gmail.com', '', 800, 1000, '$2y$10$rlNGYT1SWwwI0NT9cgkBgeUhCV4oxzAMSslKcuXbudjPVSSzsa9SO', 'Nepal', 'B+', 'red', '2025-11-14 10:56:55', '2025-11-14 10:56:55', NULL, NULL, NULL, NULL, NULL),
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
(76, 'DE000049', 'DE000001', 'tony', '8902072138', NULL, '', 800, 1000, '$2y$10$swRHX5Zq6ETU4YGgMGIR9eq4VpS83XShzAlhrZ.n857jMMmAmWnPu', 'Afganistan', 'O-', 'red', '2025-11-15 09:33:31', '2025-11-15 09:33:31', NULL, NULL, NULL, NULL, NULL),
(77, 'DE000050', 'DE000001', 'tony', '8902072132', 'comjoytest@gmail.com', '', 800, 1000, '$2y$10$r3C0clWwzocStmsPLb2dmusLYn1bQ9bwTJ0eRYzizQmbREGh5ml4W', 'Afganistan', 'O-', 'red', '2025-11-15 09:33:52', '2025-11-15 09:33:52', NULL, NULL, NULL, NULL, NULL),
(78, 'DE000051', 'DE000050', 'raj pal', '8798989+8', 'comjoytest56@gmail.com', '', 800, 1000, '$2y$10$F9fkx3l0c4lqxlB0pkn7buFuDP0CsKHJDSr1Jant1ujqDRg5bjVkK', 'India', 'O+', 'red', '2025-11-15 14:00:32', '2025-11-15 14:00:32', NULL, NULL, NULL, NULL, NULL),
(79, 'DE000052', 'DE000001', 'sumit bhowmick', '7998082902', 'sanjumukherjee786@gmail.com', '', 800, 1000, '$2y$10$3A4JdQx1QHS9l17eQd4boOizOvgQeB7cR067Boasx3mJwNDnqeJQ2', 'Afganistan', 'AB-', 'red', '2025-11-17 08:56:13', '2025-11-17 08:56:13', 'sumit bhowmick', 'punjab national bank', '5100047845964', 'SBIN2545482t', 'hooghly'),
(80, 'DE000053', 'DE000002', 'tony', '8902072131', NULL, '', 800, 1000, '$2y$10$pH0ZutVd0sLY9o9X4SGA.ueNUeyy309Y76R1qLY4bXgGli8KHarWm', 'India', 'O-', 'red', '2025-11-17 10:06:03', '2025-11-17 10:06:03', NULL, NULL, NULL, NULL, NULL),
(81, 'DE000054', 'DE000007', 'sanju paul', '8902072133', NULL, '', 800, 1000, '$2y$10$X4E0ZBJd7ubmPnVl/F3VFu7ghUCa1T3JHAWECV0kFy1Dn3Ps52O.i', 'Nepal', 'O+', 'red', '2025-11-18 09:08:27', '2025-11-18 09:08:27', NULL, NULL, NULL, NULL, NULL),
(82, 'DE000055', 'DE000005', 'basir', '+9777890546789', NULL, '', 800, 1000, '$2y$10$mPKh1YT/FM76cAXRVrFm3.2WyhtIpCElnjkci.qYxKWp371a33wQy', 'Nepal', 'AB+', 'red', '2025-11-18 09:14:38', '2025-11-18 09:14:38', NULL, NULL, NULL, NULL, NULL);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
