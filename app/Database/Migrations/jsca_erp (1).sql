-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Mar 26, 2026 at 07:18 AM
-- Server version: 10.4.34-MariaDB-1:10.4.34+maria~ubu2004
-- PHP Version: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jsca_erp`
--

-- --------------------------------------------------------

--
-- Table structure for table `account_groups`
--

CREATE TABLE `account_groups` (
  `G_Name` varchar(10) NOT NULL,
  `Acc_Name` varchar(200) NOT NULL,
  `Acc_Type` varchar(100) NOT NULL,
  `YesNo` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `account_groups`
--

INSERT INTO `account_groups` (`G_Name`, `Acc_Name`, `Acc_Type`, `YesNo`) VALUES
('G1', 'ACCOUNTS PAYABLE', 'Libilities', 'No'),
('G10', 'DEPOSITS (Assets)', 'Assets', 'No'),
('G11', 'SALES TAX', 'Libilities', 'No'),
('G12', 'EXPENDITURE', 'Expenses', 'No'),
('G13', 'EXPENSES (Trading A/C)', 'Expenses', 'No'),
('G14', 'EXPENSES (Profit & Loss A/C)', 'Expenses', 'No'),
('G15', 'FIXED ASSETS', 'Assets', 'No'),
('G16', 'INCOME (Revenue)', 'Income', 'No'),
('G17', 'INVESTMENTS', 'Assets', 'No'),
('G18', 'LOANS & ADVANCES (Assets)', 'Assets', 'No'),
('G19', 'LOAN (Liabilities)', 'Libilities', 'No'),
('G2', 'ACCOUNTS RECEIVABLE', 'Assets', 'No'),
('G20', 'MFG. & TDG. EXPENSES', 'Expenses', 'No'),
('G21', 'MISC. EXPENSES (Assets)', 'Expenses', 'No'),
('G22', 'PROVISIONS', 'Liabilities', 'No'),
('G23', 'PURCHASE ACCOUNT', 'Expenses', 'No'),
('G24', 'RESERVES & SURPLUS', 'Liabilities', 'No'),
('G25', 'SALES ACCOUNT', 'Income', 'No'),
('G26', 'SECURED LOANS', 'Liabilities', 'No'),
('G27', 'OPENING STOCK', 'Assets', 'No'),
('G28', 'SUNDRY CREDITORS', 'Liabilities', 'No'),
('G29', 'SUNDRY DEBTORS', 'Assets', 'No'),
('G3', 'ADMN. EXPENSES', 'Expenses', 'No'),
('G30', 'SUSPENSE ACCOUNT', 'Expenses', 'No'),
('G31', 'UNSECURED LOANS', 'Liabilities', 'No'),
('G32', 'PURCHASE RETURNS', 'Expenses', 'No'),
('G33', 'SALES RETURNS', 'Income', 'No'),
('G34', 'WITHDRAWAL', 'Expenses', 'No'),
('G35', 'ADDITIONAL CAPITAL', 'Liabilities', 'No'),
('G36', 'CLOSING STOCK', 'Assets', 'No'),
('G4', 'BANK ACCOUNT', 'Assets', 'No'),
('G5', 'BANK OCC A/C', 'Liabilities', 'No'),
('G6', 'CAPITAL ACCOUNT', 'Liabilities', 'No'),
('G7', 'CASH A/C', 'Assets', 'No'),
('G8', 'ASSETS', 'Assets', 'No'),
('G9', 'LIABILITIES', 'Liabilities', 'No');

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `module` varchar(50) NOT NULL,
  `record_id` int(10) UNSIGNED DEFAULT NULL,
  `old_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_data`)),
  `new_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_data`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `action`, `module`, `record_id`, `old_data`, `new_data`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 1, 'LOGIN', 'auth', 1, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 11:43:14'),
(2, 1, 'LOGIN', 'auth', 1, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 11:47:21'),
(3, 1, 'LOGIN', 'auth', 1, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 12:08:22'),
(4, 1, 'LOGOUT', 'auth', 1, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 12:23:29'),
(5, 1, 'LOGIN', 'auth', 1, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 12:23:37'),
(6, 1, 'LOGOUT', 'auth', 1, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 13:05:05'),
(7, 1, 'LOGIN', 'auth', 1, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 13:05:34'),
(8, 1, 'LOGIN', 'auth', 1, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 11:14:31'),
(9, 1, 'LOGOUT', 'auth', 1, NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 12:53:59'),
(10, 1, 'LOGIN', 'auth', 1, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-14 06:14:27'),
(11, 1, 'LOGIN', 'auth', 1, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-14 09:35:08'),
(12, 1, 'LOGIN', 'auth', 1, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-14 11:50:10'),
(13, 1, 'CREATE', 'players', 1, NULL, '{\"jsca_player_id\":\"JSCA-P-2026-00001\",\"full_name\":\"rowhit\",\"date_of_birth\":\"2026-03-14\",\"gender\":\"Male\",\"age_category\":\"U14\",\"district_id\":\"2\",\"role\":\"Batsman\",\"batting_style\":\"Right-hand\",\"bowling_style\":\"Right-arm Fast\",\"aadhaar_number\":\"312312312312\",\"phone\":\"6206086679\",\"email\":\"Ghgsa@gmail.com\",\"address\":\"ranchi\",\"guardian_name\":\"rk\",\"guardian_phone\":\"4234234234234\",\"photo_path\":\"uploads\\/players\\/1773491034_cf0c9ab476d0593b60dc.jpg\",\"registered_by\":\"1\",\"created_at\":\"2026-03-14 12:23:54\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-14 12:23:54'),
(14, 1, 'LOGIN', 'auth', 1, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-16 04:27:01'),
(15, 1, 'LOGIN', 'auth', 1, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-16 11:54:04'),
(16, 1, 'LOGIN', 'auth', 1, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-17 07:09:33'),
(17, 1, 'LOGIN', 'auth', 1, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-17 09:22:07'),
(18, 1, 'LOGIN', 'auth', 1, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-17 13:07:00'),
(19, 1, 'CREATE', 'players', 2, NULL, '{\"jsca_player_id\":\"JSCA-P-2026-00002\",\"full_name\":\"riya\",\"date_of_birth\":\"2026-03-17\",\"gender\":\"Female\",\"age_category\":\"U14\",\"district_id\":\"3\",\"role\":\"All-rounder\",\"batting_style\":\"Right-hand\",\"bowling_style\":\"N\\/A\",\"aadhaar_number\":\"342222222222\",\"phone\":\"1222222222124\",\"email\":\"Ghgsa@gmail.com\",\"address\":\"dasdasdasdasdas\",\"guardian_name\":\"rjk\",\"guardian_phone\":\"5345335345345\",\"photo_path\":null,\"registered_by\":\"1\",\"created_at\":\"2026-03-17 13:22:29\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-17 13:22:29'),
(20, 1, 'CREATE', 'players', 3, NULL, '{\"jsca_player_id\":\"JSCA-P-2026-00003\",\"full_name\":\"sukuna\",\"date_of_birth\":\"2002-01-17\",\"gender\":\"Male\",\"age_category\":\"Senior\",\"district_id\":\"8\",\"role\":\"Batsman\",\"batting_style\":\"Right-hand\",\"bowling_style\":\"N\\/A\",\"aadhaar_number\":\"123123123123\",\"phone\":\"6206086679\",\"email\":\"d@gmail.com\",\"address\":\"dasdasd, asdasdasdasd, Jharkhand, PIN: 321231\",\"guardian_name\":\"dasdasd\",\"guardian_phone\":\"6206086679\",\"photo_path\":null,\"registered_by\":\"1\",\"created_at\":\"2026-03-17 13:30:26\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-17 13:30:26'),
(21, 1, 'CREATE', 'coaches', 1, NULL, '{\"jsca_coach_id\":\"JSCA-C-2026-0001\",\"full_name\":\"gojo\",\"date_of_birth\":\"2026-03-04\",\"gender\":\"Male\",\"phone\":\"6206086679\",\"email\":\"admin@school.com\",\"address\":\"ranhdi adnkasld dasjda \",\"district_id\":\"4\",\"specialization\":\"General\",\"level\":\"Head Coach\",\"bcci_coach_id\":\"312312312\",\"aadhaar_number\":\"312333333333\",\"experience_years\":2,\"previous_teams\":\"dasdas adsdas \",\"achievements\":\"dasdas das asdasdsad\",\"photo_path\":\"uploads\\/coaches\\/1773754374_94305e75ff7fd306bd0b.jpg\",\"registered_by\":\"1\",\"created_at\":\"2026-03-17 13:32:54\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-17 13:32:54'),
(22, 1, 'LOGIN', 'auth', 1, NULL, NULL, '172.18.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-21 04:26:55'),
(23, 1, 'LOGIN', 'auth', 1, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 06:48:28'),
(24, 1, 'LOGIN', 'auth', 1, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 09:16:20'),
(25, 1, 'CREATE', 'players', 5, NULL, '{\"jsca_player_id\":\"JSCA-P-2026-00005\",\"full_name\":\"makima\",\"date_of_birth\":\"2021-03-03\",\"gender\":\"Female\",\"age_category\":\"U14\",\"district_id\":\"15\",\"role\":\"Bowler\",\"batting_style\":\"Right-hand\",\"bowling_style\":\"Right-arm Fast\",\"aadhaar_number\":\"620608667931\",\"phone\":\"6206086679\",\"email\":\"rk301855@gmai.com\",\"address\":\"ranchi, ranchi, Jharkhand, PIN: 312312\",\"guardian_name\":\"rk\",\"guardian_phone\":\"6206086679\",\"photo_path\":null,\"status\":\"Active\",\"registration_type\":\"manual\",\"user_id\":3,\"registered_by\":\"1\",\"created_at\":\"2026-03-24 09:30:44\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 09:30:44'),
(26, 1, 'CREATE', 'players', 6, NULL, '{\"jsca_player_id\":\"JSCA-P-2026-00006\",\"full_name\":\"maru\",\"date_of_birth\":\"2021-03-04\",\"gender\":\"Male\",\"age_category\":\"U14\",\"district_id\":\"4\",\"role\":\"Batsman\",\"batting_style\":\"Right-hand\",\"bowling_style\":\"Right-arm Medium\",\"aadhaar_number\":\"620608667931\",\"phone\":\"6206086679\",\"email\":\"gexixop345@onbap.com\",\"address\":\"ranchi, ranchi, Jharkhand, PIN: 123412\",\"guardian_name\":\"rkk\",\"guardian_phone\":\"6206086679\",\"photo_path\":null,\"status\":\"Active\",\"registration_type\":\"manual\",\"user_id\":5,\"registered_by\":\"1\",\"created_at\":\"2026-03-24 09:35:32\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 09:35:32'),
(27, 1, 'CREATE', 'venues', 9, NULL, '{\"name\":\"morabadi stadium\",\"district_id\":\"1\",\"capacity\":3000,\"has_floodlights\":1,\"has_scoreboard\":1,\"has_dressing\":1,\"pitch_type\":\"Turf\",\"contact_person\":\"rowhit\",\"contact_phone\":\"6206043243\",\"address\":\"near morabadi\",\"lat\":null,\"lng\":null,\"is_active\":1,\"created_at\":\"2026-03-24 09:43:57\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 09:43:57'),
(28, 1, 'CREATE', 'officials', 1, NULL, '{\"jsca_official_id\":\"JSCA-UMP-0001\",\"official_type_id\":\"1\",\"full_name\":\"rohit\",\"email\":\"tilab37005@izkat.com\",\"phone\":\"6206086679\",\"gender\":\"Female\",\"dob\":\"2026-03-17\",\"district_id\":\"1\",\"address\":\"ranchiii\",\"experience_years\":\"2\",\"profile_photo\":null,\"user_id\":7,\"status\":\"Active\",\"registered_by\":\"1\",\"created_at\":\"2026-03-24 10:32:29\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 10:32:29'),
(29, 1, 'CREATE', 'tournaments', 1, NULL, '{\"jsca_tournament_id\":\"JSCA-TR-2026-001\",\"name\":\"funny morabadi match\",\"short_name\":\"fm match\",\"edition\":\"1st\",\"season\":\"2026-2027\",\"age_category\":\"U14\",\"gender\":\"Male\",\"format\":\"T10\",\"overs\":\"10\",\"structure\":\"Round Robin\",\"is_zonal\":0,\"start_date\":\"2026-03-28\",\"end_date\":\"2026-03-26\",\"registration_deadline\":\"2026-03-18\",\"venue_id\":\"9\",\"max_teams\":\"10\",\"organizer_name\":\"rk\",\"organizer_phone\":\"6206086677\",\"organizer_email\":\"test@gmail.com\",\"prize_pool\":\"100000\",\"winner_prize\":\"10000\",\"runner_prize\":\"10000\",\"description\":\"dasdasd\",\"rules\":\"dasdasdasd\",\"banner_path\":null,\"status\":\"Draft\",\"created_by\":\"1\",\"created_at\":\"2026-03-24 10:53:02\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 10:53:02'),
(30, 1, 'CREATE', 'tournaments', 2, NULL, '{\"jsca_tournament_id\":\"JSCA-TR-2026-002\",\"name\":\"wewwww\",\"short_name\":\"www\",\"edition\":\"1st\",\"season\":\"2026-2027\",\"age_category\":\"U14\",\"gender\":\"Male\",\"format\":\"T10\",\"overs\":\"10\",\"structure\":\"Round Robin\",\"is_zonal\":0,\"start_date\":\"2026-03-25\",\"end_date\":\"2026-03-26\",\"registration_deadline\":\"2026-03-23\",\"venue_id\":\"9\",\"max_teams\":\"2\",\"organizer_name\":\"rk\",\"organizer_phone\":\"6206086677\",\"organizer_email\":\"test@gmail.com\",\"prize_pool\":\"10000\",\"winner_prize\":\"10000\",\"runner_prize\":\"10000\",\"description\":null,\"rules\":null,\"banner_path\":null,\"status\":\"Draft\",\"created_by\":\"1\",\"created_at\":\"2026-03-24 10:57:26\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 10:57:26'),
(31, 1, 'STATUS_CHANGE', 'tournaments', 2, NULL, '{\"status\":\"Fixture Ready\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 11:02:32'),
(32, 1, 'CREATE', 'teams', 1, NULL, '{\"jsca_team_id\":\"JSCA-T-2026-0001\",\"tournament_id\":\"1\",\"district_id\":\"15\",\"name\":\"meoww\",\"zone\":\"South\",\"status\":\"Registered\",\"created_at\":\"2026-03-24 11:21:27\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 11:21:27'),
(33, 1, 'PLAYER_ADDED', 'teams', 1, NULL, '{\"player_id\":5}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 11:22:02'),
(34, 1, 'CREATE', 'users', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 11:53:22'),
(35, 8, 'LOGIN', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 11:53:52'),
(36, 1, 'UPDATE', 'users', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:09:00'),
(37, 1, 'UPDATE', 'users', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:11:38'),
(38, 8, 'LOGOUT', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:15:15'),
(39, 8, 'LOGIN', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:15:53'),
(40, 8, 'LOGOUT', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:18:53'),
(41, 8, 'LOGIN', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:19:21'),
(42, 8, 'LOGIN', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:19:46'),
(43, 8, 'LOGIN', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:21:27'),
(44, 8, 'LOGIN', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:22:08'),
(45, 8, 'LOGIN', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:23:08'),
(46, 1, 'UPDATE', 'users', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:24:02'),
(47, 8, 'LOGOUT', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:24:21'),
(48, 8, 'LOGIN', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:24:34'),
(49, 1, 'UPDATE', 'users', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 12:27:56'),
(50, 1, 'LOGIN', 'auth', 1, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 07:02:36'),
(51, 1, 'UPDATE', 'users', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 07:20:36'),
(52, 8, 'LOGIN', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-03-25 07:20:53'),
(53, 1, 'UPDATE', 'users', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 07:21:29'),
(54, 8, 'LOGOUT', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-03-25 07:22:30'),
(55, 8, 'LOGIN', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-03-25 07:23:16'),
(56, 1, 'CREATE', 'officials', 2, NULL, '{\"jsca_official_id\":\"JSCA-SCR-0001\",\"official_type_id\":\"2\",\"full_name\":\"vishal\",\"email\":\"rks7549079802@gmail.com\",\"phone\":null,\"gender\":\"Female\",\"dob\":\"2003-06-25\",\"district_id\":\"1\",\"address\":null,\"experience_years\":null,\"grade\":\"A\",\"fee_per_match\":null,\"bank_name\":null,\"bank_account\":\"000000000000\",\"bank_ifsc\":\"TEST0001234\",\"profile_photo\":null,\"user_id\":10,\"status\":\"Active\",\"registered_by\":\"1\",\"created_at\":\"2026-03-25 07:38:23\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 07:38:23'),
(57, 1, 'UPDATE', 'venues', 1, '{\"id\":\"1\",\"name\":\"JSCA International Stadium\",\"district_id\":\"1\",\"capacity\":\"45000\",\"has_floodlights\":\"1\",\"has_scoreboard\":\"0\",\"has_dressing\":\"0\",\"pitch_type\":\"Grass\",\"contact_person\":null,\"contact_phone\":null,\"address\":null,\"lat\":null,\"lng\":null,\"is_active\":\"1\",\"created_at\":\"2026-03-09 18:15:09\"}', '{\"name\":\"JSCA International Stadium\",\"district_id\":\"1\",\"capacity\":45000,\"has_floodlights\":1,\"has_scoreboard\":0,\"has_dressing\":0,\"pitch_type\":\"Grass\",\"contact_person\":\"\",\"contact_phone\":\"\",\"address\":\"\",\"lat\":null,\"lng\":null,\"is_active\":1}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 07:46:15'),
(58, 1, 'CREATE', 'officials', 3, NULL, '{\"jsca_official_id\":\"JSCA-UMP-0002\",\"official_type_id\":\"1\",\"full_name\":\"rahul\",\"email\":\"Ghgsa@gmail.com\",\"phone\":\"6206086679\",\"gender\":\"Male\",\"dob\":\"2005-02-17\",\"district_id\":\"1\",\"address\":\"ranchi\",\"experience_years\":\"3\",\"grade\":\"A\",\"fee_per_match\":\"10000\",\"bank_name\":\"SBI\",\"bank_account\":\"000000000000\",\"bank_ifsc\":\"TEST0001235\",\"profile_photo\":null,\"user_id\":11,\"status\":\"Active\",\"registered_by\":\"1\",\"created_at\":\"2026-03-25 07:48:13\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 07:48:13'),
(59, 1, 'CREATE', 'officials', 4, NULL, '{\"jsca_official_id\":\"JSCA-REF-0001\",\"official_type_id\":\"3\",\"full_name\":\"sumit\",\"email\":\"me@mydomain.com\",\"phone\":\"6206086679\",\"gender\":\"Male\",\"dob\":\"2001-02-23\",\"district_id\":\"1\",\"address\":null,\"experience_years\":\"5\",\"grade\":\"A\",\"fee_per_match\":\"49999.98\",\"bank_name\":\"SBI\",\"bank_account\":\"00000000000\",\"bank_ifsc\":\"TEST0001236\",\"profile_photo\":null,\"user_id\":12,\"status\":\"Active\",\"registered_by\":\"1\",\"created_at\":\"2026-03-25 07:49:31\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 07:49:31'),
(60, 1, 'UPDATE', 'officials', 1, '{\"id\":\"1\",\"jsca_official_id\":\"JSCA-UMP-0001\",\"official_type_id\":\"1\",\"full_name\":\"rohit\",\"email\":\"tilab37005@izkat.com\",\"phone\":\"6206086679\",\"gender\":\"Female\",\"dob\":\"2026-03-17\",\"district_id\":\"1\",\"address\":\"ranchiii\",\"experience_years\":\"2\",\"grade\":null,\"fee_per_match\":null,\"bank_name\":null,\"bank_account\":null,\"bank_ifsc\":null,\"profile_photo\":null,\"user_id\":\"7\",\"status\":\"Active\",\"registered_by\":\"1\",\"created_at\":\"2026-03-24 10:32:29\",\"updated_at\":null}', '{\"official_type_id\":\"4\",\"full_name\":\"rohit\",\"email\":\"tilab37005@izkat.com\",\"phone\":\"6206086679\",\"gender\":\"Female\",\"dob\":\"2026-03-17\",\"district_id\":\"1\",\"address\":\"ranchiii\",\"experience_years\":\"2\",\"grade\":null,\"fee_per_match\":null,\"bank_name\":null,\"bank_account\":null,\"bank_ifsc\":null,\"status\":\"Active\",\"updated_at\":\"2026-03-25 07:50:21\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 07:50:22'),
(61, 1, 'UPDATE', 'coaches', 1, '{\"id\":\"1\",\"jsca_coach_id\":\"JSCA-C-2026-0001\",\"full_name\":\"gojo\",\"date_of_birth\":\"2026-03-04\",\"gender\":\"Male\",\"phone\":\"6206086679\",\"email\":\"admin@school.com\",\"address\":\"ranhdi adnkasld dasjda \",\"district_id\":\"4\",\"photo_path\":\"uploads\\/coaches\\/1773754374_94305e75ff7fd306bd0b.jpg\",\"specialization\":\"General\",\"level\":\"Head Coach\",\"bcci_coach_id\":\"312312312\",\"aadhaar_number\":\"312333333333\",\"aadhaar_verified\":\"0\",\"experience_years\":\"2\",\"previous_teams\":\"dasdas adsdas \",\"achievements\":\"dasdas das asdasdsad\",\"status\":\"Active\",\"registered_by\":\"1\",\"created_at\":\"2026-03-17 13:32:54\",\"updated_at\":\"2026-03-17 13:32:54\"}', '{\"full_name\":\"gojo\",\"phone\":\"6206086679\",\"email\":\"admin@school.com\",\"address\":\"ranhdi adnkasld dasjda \",\"district_id\":\"1\",\"specialization\":\"General\",\"level\":\"Head Coach\",\"bcci_coach_id\":\"312312312\",\"experience_years\":2,\"previous_teams\":\"dasdas adsdas \",\"achievements\":\"dasdas das asdasdsad\",\"status\":\"Active\",\"updated_at\":\"2026-03-25 07:52:11\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 07:52:11'),
(62, 1, 'CREATE', 'coaches', 2, NULL, '{\"jsca_coach_id\":\"JSCA-C-2026-0002\",\"full_name\":\"subham\",\"date_of_birth\":\"1998-02-25\",\"gender\":\"Male\",\"phone\":\"6206086679\",\"email\":\"m@gmail.com\",\"address\":\"\",\"district_id\":\"1\",\"specialization\":\"Batting\",\"level\":\"NCA Level 1\",\"bcci_coach_id\":\"\",\"aadhaar_number\":\"312312312312\",\"experience_years\":6,\"previous_teams\":\"\",\"achievements\":\"\",\"photo_path\":null,\"registered_by\":\"1\",\"created_at\":\"2026-03-25 07:53:21\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 07:53:21'),
(63, 1, 'CREATE', 'tournaments', 3, NULL, '{\"jsca_tournament_id\":\"JSCA-TR-2026-003\",\"name\":\"ranchi sports league\",\"short_name\":\"rsl\",\"edition\":null,\"season\":\"2026-2027\",\"age_category\":\"U14\",\"gender\":\"Male\",\"format\":\"T10\",\"overs\":\"10\",\"structure\":\"Round Robin\",\"is_zonal\":0,\"start_date\":\"2026-03-26\",\"end_date\":\"2026-03-27\",\"registration_deadline\":\"2026-03-22\",\"venue_id\":\"1\",\"max_teams\":\"2\",\"organizer_name\":null,\"organizer_phone\":null,\"organizer_email\":null,\"prize_pool\":\"10000\",\"winner_prize\":\"6000\",\"runner_prize\":\"4000\",\"description\":null,\"rules\":null,\"banner_path\":null,\"status\":\"Draft\",\"created_by\":\"1\",\"created_at\":\"2026-03-25 08:13:27\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 08:13:27'),
(64, 1, 'CREATE', 'teams', 2, NULL, '{\"jsca_team_id\":\"JSCA-T-2026-0002\",\"tournament_id\":\"3\",\"district_id\":\"1\",\"name\":\"ranchi fighters\",\"zone\":\"South\",\"manager_name\":\"rowhti\",\"manager_phone\":\"6206086673\",\"registered_by\":\"1\",\"status\":\"Registered\",\"created_at\":\"2026-03-25 08:14:14\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 08:14:14'),
(65, 1, 'CREATE', 'teams', 3, NULL, '{\"jsca_team_id\":\"JSCA-T-2026-0003\",\"tournament_id\":\"3\",\"district_id\":\"1\",\"name\":\"morabdi fighters\",\"zone\":\"South\",\"manager_name\":\"rohit\",\"manager_phone\":\"6206086677\",\"registered_by\":\"1\",\"status\":\"Registered\",\"created_at\":\"2026-03-25 08:16:12\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 08:16:12'),
(66, 1, 'CREATE', 'teams', 4, NULL, '{\"jsca_team_id\":\"JSCA-T-2026-0004\",\"tournament_id\":\"3\",\"district_id\":\"1\",\"name\":\"namkum fighters\",\"zone\":\"South\",\"manager_name\":\"rohtitee\",\"manager_phone\":\"6206086677\",\"registered_by\":\"1\",\"status\":\"Registered\",\"created_at\":\"2026-03-25 08:17:48\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 08:17:48'),
(67, 8, 'LOGOUT', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-03-25 09:12:16'),
(68, 8, 'LOGIN', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-03-25 09:12:39'),
(69, 1, 'UPDATE', 'users', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 09:13:11'),
(70, 8, 'LOGOUT', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-03-25 09:13:30'),
(71, 8, 'LOGIN', 'auth', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0', '2026-03-25 09:13:46'),
(72, 1, 'UPDATE', 'users', 8, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 09:14:06'),
(73, 1, 'CREATE', 'teams', 5, NULL, '{\"jsca_team_id\":\"JSCA-T-2026-0005\",\"tournament_id\":\"3\",\"district_id\":\"1\",\"name\":\"main road rollers\",\"zone\":\"South\",\"manager_name\":\"rowwww\",\"manager_phone\":\"9570037775\",\"registered_by\":\"1\",\"status\":\"Registered\",\"created_at\":\"2026-03-25 11:01:04\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:01:04'),
(74, 1, 'PLAYER_ADDED', 'teams', 5, NULL, '{\"player_id\":19}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:05:05'),
(75, 1, 'PLAYER_ADDED', 'teams', 5, NULL, '{\"player_id\":18}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:05:20'),
(76, 1, 'COACH_ADDED', 'teams', 5, NULL, '{\"coach_id\":1}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:05:34'),
(77, 1, 'PLAYER_ADDED', 'teams', 5, NULL, '{\"player_id\":27}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:21:08'),
(78, 1, 'PLAYER_ADDED', 'teams', 5, NULL, '{\"player_id\":31}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:21:24'),
(79, 1, 'PLAYER_ADDED', 'teams', 5, NULL, '{\"player_id\":28}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:21:36'),
(80, 1, 'PLAYER_ADDED', 'teams', 5, NULL, '{\"player_id\":25}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:21:47'),
(81, 1, 'PLAYER_ADDED', 'teams', 5, NULL, '{\"player_id\":23}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:21:58'),
(82, 1, 'PLAYER_ADDED', 'teams', 5, NULL, '{\"player_id\":22}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:22:08'),
(83, 1, 'PLAYER_ADDED', 'teams', 5, NULL, '{\"player_id\":29}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:22:20'),
(84, 1, 'PLAYER_ADDED', 'teams', 5, NULL, '{\"player_id\":26}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:22:28'),
(85, 1, 'PLAYER_ADDED', 'teams', 5, NULL, '{\"player_id\":24}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:22:38'),
(86, 1, 'PLAYER_ADDED', 'teams', 5, NULL, '{\"player_id\":30}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:22:46'),
(87, 1, 'UPDATE', 'teams', 5, '{\"id\":\"5\",\"jsca_team_id\":\"JSCA-T-2026-0005\",\"tournament_id\":\"3\",\"district_id\":\"1\",\"name\":\"main road rollers\",\"zone\":\"South\",\"captain_id\":\"19\",\"vice_captain_id\":\"18\",\"manager_name\":\"rowwww\",\"manager_phone\":\"9570037775\",\"registered_by\":\"1\",\"status\":\"Registered\",\"created_at\":\"2026-03-25 11:01:04\",\"updated_at\":null}', '{\"name\":\"main road rollers\",\"zone\":\"South\",\"manager_name\":\"rowwww\",\"manager_phone\":\"9570037775\",\"status\":\"Confirmed\",\"updated_at\":\"2026-03-25 11:23:00\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:23:00'),
(88, 1, 'UPDATE', 'teams', 2, '{\"id\":\"2\",\"jsca_team_id\":\"JSCA-T-2026-0002\",\"tournament_id\":\"3\",\"district_id\":\"1\",\"name\":\"ranchi fighters\",\"zone\":\"South\",\"captain_id\":null,\"vice_captain_id\":null,\"manager_name\":\"rowhti\",\"manager_phone\":\"6206086673\",\"registered_by\":\"1\",\"status\":\"Registered\",\"created_at\":\"2026-03-25 08:14:14\",\"updated_at\":null}', '{\"name\":\"ranchi fighters\",\"zone\":\"South\",\"manager_name\":\"rowhti\",\"manager_phone\":\"6206086673\",\"status\":\"Confirmed\",\"updated_at\":\"2026-03-25 11:23:50\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:23:50'),
(89, 1, 'STATUS_CHANGE', 'tournaments', 3, '{\"status\":\"Draft\"}', '{\"status\":\"Registration\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:24:47'),
(90, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":46}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:50:55'),
(91, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":27}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:51:08'),
(92, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":25}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:51:21'),
(93, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":51}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:51:33'),
(94, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":22}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:51:43'),
(95, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":48}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:51:53'),
(96, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":23}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:52:02'),
(97, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":44}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:52:11'),
(98, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":31}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:52:22'),
(99, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":19}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:52:32'),
(100, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":47}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:52:41'),
(101, 1, 'COACH_ADDED', 'teams', 2, NULL, '{\"coach_id\":3}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:52:56'),
(102, 1, 'COACH_ADDED', 'teams', 2, NULL, '{\"coach_id\":2}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:53:21'),
(103, 1, 'STATUS_CHANGE', 'tournaments', 3, '{\"status\":\"Registration\"}', '{\"status\":\"Fixture Ready\"}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 11:54:23'),
(104, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":50}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 12:46:19'),
(105, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":52}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 12:46:30'),
(106, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":42}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 12:46:39'),
(107, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":49}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 12:46:48'),
(108, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":45}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 12:46:58'),
(109, 1, 'PLAYER_ADDED', 'teams', 2, NULL, '{\"player_id\":43}', '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-25 12:47:08'),
(110, 1, 'LOGIN', 'auth', 1, NULL, NULL, '172.19.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-26 07:12:53');

-- --------------------------------------------------------

--
-- Table structure for table `batting_stats`
--

CREATE TABLE `batting_stats` (
  `id` int(10) UNSIGNED NOT NULL,
  `fixture_id` int(10) UNSIGNED NOT NULL,
  `player_id` int(10) UNSIGNED NOT NULL,
  `team_id` int(10) UNSIGNED NOT NULL,
  `innings` tinyint(4) DEFAULT 1,
  `runs` int(11) DEFAULT 0,
  `balls_faced` int(11) DEFAULT 0,
  `fours` int(11) DEFAULT 0,
  `sixes` int(11) DEFAULT 0,
  `dismissal` enum('b','c','lbw','run out','hit wicket','retired hurt','not out','c&b','stumped') DEFAULT 'not out',
  `bowler_id` int(10) UNSIGNED DEFAULT NULL,
  `fielder_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bowling_stats`
--

CREATE TABLE `bowling_stats` (
  `id` int(10) UNSIGNED NOT NULL,
  `fixture_id` int(10) UNSIGNED NOT NULL,
  `player_id` int(10) UNSIGNED NOT NULL,
  `team_id` int(10) UNSIGNED NOT NULL,
  `innings` tinyint(4) DEFAULT 1,
  `overs` decimal(4,1) DEFAULT 0.0,
  `maidens` int(11) DEFAULT 0,
  `runs_conceded` int(11) DEFAULT 0,
  `wickets` int(11) DEFAULT 0,
  `wides` int(11) DEFAULT 0,
  `no_balls` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `coaches`
--

CREATE TABLE `coaches` (
  `id` int(10) UNSIGNED NOT NULL,
  `jsca_coach_id` varchar(30) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `date_of_birth` date NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `district_id` int(10) UNSIGNED DEFAULT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `specialization` enum('Batting','Bowling','Fielding','Wicket-keeping','Fitness','General') NOT NULL DEFAULT 'General',
  `level` enum('Assistant','Head Coach','Bowling Coach','Batting Coach','Fielding Coach','Fitness Trainer','NCA Level 1','NCA Level 2','NCA Level 3') NOT NULL DEFAULT 'Assistant',
  `bcci_coach_id` varchar(50) DEFAULT NULL COMMENT 'BCCI issued coach ID',
  `aadhaar_number` varchar(12) DEFAULT NULL,
  `aadhaar_verified` tinyint(1) NOT NULL DEFAULT 0,
  `experience_years` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `previous_teams` text DEFAULT NULL COMMENT 'Comma separated or JSON',
  `achievements` text DEFAULT NULL,
  `status` enum('Active','Inactive','Suspended') NOT NULL DEFAULT 'Active',
  `registered_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `coaches`
--

INSERT INTO `coaches` (`id`, `jsca_coach_id`, `full_name`, `date_of_birth`, `gender`, `phone`, `email`, `address`, `district_id`, `photo_path`, `specialization`, `level`, `bcci_coach_id`, `aadhaar_number`, `aadhaar_verified`, `experience_years`, `previous_teams`, `achievements`, `status`, `registered_by`, `created_at`, `updated_at`) VALUES
(1, 'JSCA-C-2026-0001', 'gojo', '2026-03-04', 'Male', '6206086679', 'admin@school.com', 'ranhdi adnkasld dasjda ', 1, 'uploads/coaches/1773754374_94305e75ff7fd306bd0b.jpg', 'General', 'Head Coach', '312312312', '312333333333', 0, 2, 'dasdas adsdas ', 'dasdas das asdasdsad', 'Active', 1, '2026-03-17 13:32:54', '2026-03-25 07:52:11'),
(2, 'JSCA-C-2026-0002', 'subham', '1998-02-25', 'Male', '6206086679', 'm@gmail.com', '', 1, NULL, 'Batting', 'NCA Level 1', '', '312312312312', 0, 6, '', '', 'Active', 1, '2026-03-25 07:53:21', '2026-03-25 07:53:21'),
(3, 'JSCA-C-2026-0003', 'Manoj Kumar Sharma', '1980-04-15', 'Male', '9844400001', NULL, NULL, 1, NULL, 'Batting', 'NCA Level 2', NULL, NULL, 0, 12, NULL, NULL, 'Active', 1, '2026-03-25 11:47:41', '2026-03-25 11:47:41'),
(4, 'JSCA-C-2026-0004', 'Pradeep Tirkey', '1985-09-22', 'Male', '9844400002', NULL, NULL, 1, NULL, 'Bowling', 'NCA Level 1', NULL, NULL, 0, 8, NULL, NULL, 'Active', 1, '2026-03-25 11:47:41', '2026-03-25 11:47:41');

-- --------------------------------------------------------

--
-- Table structure for table `coach_documents`
--

CREATE TABLE `coach_documents` (
  `id` int(10) UNSIGNED NOT NULL,
  `coach_id` int(10) UNSIGNED NOT NULL,
  `doc_type` enum('aadhaar_front','aadhaar_back','coaching_certificate','bcci_certificate','nca_certificate','medical_fitness','police_verification','photo','other') NOT NULL,
  `label` varchar(100) DEFAULT NULL,
  `file_path` varchar(255) NOT NULL,
  `file_name` varchar(150) NOT NULL,
  `mime_type` varchar(80) DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `verified_by` int(10) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `uploaded_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `districts`
--

CREATE TABLE `districts` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `zone` enum('North','South','East','West','Central') NOT NULL,
  `code` varchar(5) NOT NULL,
  `lat` decimal(9,6) DEFAULT NULL,
  `lng` decimal(9,6) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `districts`
--

INSERT INTO `districts` (`id`, `name`, `zone`, `code`, `lat`, `lng`, `is_active`) VALUES
(1, 'Ranchi', 'South', 'RCH', 23.344100, 85.309600, 1),
(2, 'Dhanbad', 'East', 'DHN', 23.795700, 86.430400, 1),
(3, 'Bokaro', 'East', 'BKR', 23.669300, 85.990700, 1),
(4, 'Jamshedpur', 'East', 'JMP', 22.804600, 86.202900, 1),
(5, 'Hazaribagh', 'North', 'HZB', 23.997500, 85.363700, 1),
(6, 'Giridih', 'North', 'GRD', 24.186800, 86.305700, 1),
(7, 'Deoghar', 'West', 'DGR', 24.486300, 86.692400, 1),
(8, 'Dumka', 'West', 'DMK', 24.267100, 87.246400, 1),
(9, 'Chatra', 'North', 'CHT', 24.200600, 84.872900, 1),
(10, 'Koderma', 'North', 'KDR', 24.464700, 85.596500, 1),
(11, 'Lohardaga', 'South', 'LHD', 23.435700, 84.685200, 1),
(12, 'Gumla', 'South', 'GML', 23.045100, 84.539200, 1),
(13, 'Simdega', 'South', 'SMD', 22.609200, 84.503100, 1),
(14, 'Pakur', 'West', 'PKR', 24.634400, 87.835700, 1),
(15, 'Godda', 'West', 'GDA', 24.829600, 87.210800, 1),
(16, 'Sahebganj', 'West', 'SHB', 25.241100, 87.636200, 1),
(17, 'Jamtara', 'West', 'JMT', 23.961400, 86.801600, 1),
(18, 'Palamu', 'Central', 'PLM', 24.029100, 84.073400, 1),
(19, 'Garhwa', 'Central', 'GRW', 24.168000, 83.804100, 1),
(20, 'Latehar', 'Central', 'LTR', 23.744900, 84.493700, 1),
(21, 'Khunti', 'South', 'KHT', 23.071700, 85.279700, 1),
(22, 'West Singhbhum', 'East', 'WSB', 22.567200, 85.511500, 1),
(23, 'Seraikela', 'East', 'SKL', 22.582700, 85.998700, 1),
(24, 'Ramgarh', 'North', 'RMG', 23.630400, 85.517700, 1);

-- --------------------------------------------------------

--
-- Table structure for table `fixtures`
--

CREATE TABLE `fixtures` (
  `id` int(10) UNSIGNED NOT NULL,
  `tournament_id` int(10) UNSIGNED NOT NULL,
  `match_number` varchar(10) NOT NULL,
  `stage` varchar(50) DEFAULT 'League',
  `zone` varchar(20) DEFAULT NULL,
  `match_date` date NOT NULL,
  `match_time` time NOT NULL,
  `team_a_id` int(10) UNSIGNED NOT NULL,
  `team_b_id` int(10) UNSIGNED NOT NULL,
  `venue_id` int(10) UNSIGNED NOT NULL,
  `is_day_night` tinyint(1) DEFAULT 0,
  `umpire1_id` int(10) UNSIGNED DEFAULT NULL,
  `umpire2_id` int(10) UNSIGNED DEFAULT NULL,
  `scorer_id` int(10) UNSIGNED DEFAULT NULL,
  `referee_id` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('Scheduled','Live','Completed','Abandoned','Postponed') DEFAULT 'Scheduled',
  `winner_team_id` int(10) UNSIGNED DEFAULT NULL,
  `result_summary` text DEFAULT NULL,
  `crichieros_id` varchar(50) DEFAULT NULL,
  `youtube_url` varchar(255) DEFAULT NULL,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ledger_heads`
--

CREATE TABLE `ledger_heads` (
  `id` int(11) NOT NULL,
  `group_id` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `opening_balance` decimal(12,2) DEFAULT 0.00,
  `balance_type` enum('Dr','Cr') DEFAULT 'Dr',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `ledger_heads`
--

INSERT INTO `ledger_heads` (`id`, `group_id`, `name`, `opening_balance`, `balance_type`, `created_at`, `updated_at`) VALUES
(1, 'G1', 'XYZ ', 5401.12, 'Dr', '2026-03-21 08:24:23', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `live_matches`
--

CREATE TABLE `live_matches` (
  `id` int(10) UNSIGNED NOT NULL,
  `team_a_id` int(10) UNSIGNED DEFAULT NULL,
  `team_b_id` int(10) UNSIGNED DEFAULT NULL,
  `team_a_custom` varchar(100) DEFAULT NULL COMMENT 'Custom team name if not in teams table',
  `team_b_custom` varchar(100) DEFAULT NULL COMMENT 'Custom team name if not in teams table',
  `team_a_score` varchar(50) DEFAULT NULL COMMENT 'e.g. 145/6 (18 ov)',
  `team_b_score` varchar(50) DEFAULT NULL,
  `venue` varchar(150) DEFAULT NULL,
  `tournament_name` varchar(150) DEFAULT NULL,
  `match_type` enum('T20','ODI','Test','T10','Other') NOT NULL DEFAULT 'T20',
  `status` enum('live','completed','abandoned') NOT NULL DEFAULT 'live',
  `notes` varchar(255) DEFAULT NULL,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `match_scorecards`
--

CREATE TABLE `match_scorecards` (
  `id` int(10) UNSIGNED NOT NULL,
  `fixture_id` int(10) UNSIGNED NOT NULL,
  `toss_winner_id` int(10) UNSIGNED DEFAULT NULL,
  `toss_decision` enum('Bat','Bowl') DEFAULT NULL,
  `team_a_score` varchar(20) DEFAULT NULL,
  `team_b_score` varchar(20) DEFAULT NULL,
  `team_a_overs` decimal(4,1) DEFAULT NULL,
  `team_b_overs` decimal(4,1) DEFAULT NULL,
  `player_of_match` int(10) UNSIGNED DEFAULT NULL,
  `source` enum('Manual','CricHeroes','API') DEFAULT 'Manual',
  `notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `officials`
--

CREATE TABLE `officials` (
  `id` int(10) UNSIGNED NOT NULL,
  `jsca_official_id` varchar(30) NOT NULL,
  `official_type_id` int(10) UNSIGNED NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `gender` enum('Male','Female','Other') NOT NULL DEFAULT 'Male',
  `dob` date DEFAULT NULL,
  `district_id` int(10) UNSIGNED NOT NULL,
  `address` text DEFAULT NULL,
  `experience_years` tinyint(3) UNSIGNED DEFAULT NULL,
  `grade` enum('A','B','C','D','Panel') DEFAULT NULL,
  `fee_per_match` decimal(8,2) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `bank_account` varchar(20) DEFAULT NULL,
  `bank_ifsc` varchar(11) DEFAULT NULL,
  `profile_photo` varchar(255) DEFAULT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  `registered_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `officials`
--

INSERT INTO `officials` (`id`, `jsca_official_id`, `official_type_id`, `full_name`, `email`, `phone`, `gender`, `dob`, `district_id`, `address`, `experience_years`, `grade`, `fee_per_match`, `bank_name`, `bank_account`, `bank_ifsc`, `profile_photo`, `user_id`, `status`, `registered_by`, `created_at`, `updated_at`) VALUES
(1, 'JSCA-UMP-0001', 4, 'rohit', 'tilab37005@izkat.com', '6206086679', 'Female', '2026-03-17', 1, 'ranchiii', 2, NULL, NULL, NULL, NULL, NULL, NULL, 7, 'Active', 1, '2026-03-24 10:32:29', '2026-03-25 07:50:21'),
(2, 'JSCA-SCR-0001', 2, 'vishal', 'rks7549079802@gmail.com', NULL, 'Female', '2003-06-25', 1, NULL, NULL, 'A', NULL, NULL, '000000000000', 'TEST0001234', NULL, 10, 'Active', 1, '2026-03-25 07:38:23', NULL),
(3, 'JSCA-UMP-0002', 1, 'rahul', 'Ghgsa@gmail.com', '6206086679', 'Male', '2005-02-17', 1, 'ranchi', 3, 'A', 10000.00, 'SBI', '000000000000', 'TEST0001235', NULL, 11, 'Active', 1, '2026-03-25 07:48:13', NULL),
(4, 'JSCA-REF-0001', 3, 'sumit', 'me@mydomain.com', '6206086679', 'Male', '2001-02-23', 1, NULL, 5, 'A', 49999.98, 'SBI', '00000000000', 'TEST0001236', NULL, 12, 'Active', 1, '2026-03-25 07:49:31', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `official_certifications`
--

CREATE TABLE `official_certifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `official_id` int(10) UNSIGNED NOT NULL,
  `certification_name` varchar(150) NOT NULL,
  `body` varchar(100) DEFAULT NULL,
  `level` varchar(80) DEFAULT NULL,
  `certified_date` date DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `official_types`
--

CREATE TABLE `official_types` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(60) NOT NULL,
  `prefix` varchar(10) NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `official_types`
--

INSERT INTO `official_types` (`id`, `name`, `prefix`, `role_id`, `is_active`, `created_at`) VALUES
(1, 'Umpire', 'UMP', 5, 1, '2026-03-24 10:14:29'),
(2, 'Scorer', 'SCR', 6, 1, '2026-03-24 10:14:29'),
(3, 'Referee', 'REF', 7, 1, '2026-03-24 10:14:29'),
(4, 'Match Referee', 'MRF', 8, 1, '2026-03-24 10:14:29');

-- --------------------------------------------------------

--
-- Table structure for table `payment_vouchers`
--

CREATE TABLE `payment_vouchers` (
  `id` int(10) UNSIGNED NOT NULL,
  `voucher_number` varchar(20) NOT NULL,
  `fixture_id` int(10) UNSIGNED DEFAULT NULL,
  `tournament_id` int(10) UNSIGNED DEFAULT NULL,
  `official_id` int(10) UNSIGNED DEFAULT NULL,
  `payee_name` varchar(100) NOT NULL,
  `payee_type` enum('Umpire','Scorer','Referee','Vendor','Player','Staff','Other') NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `bank_account` varchar(20) DEFAULT NULL,
  `bank_ifsc` varchar(11) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `status` enum('Draft','Pending Approval','Approved','Paid','Rejected','Cancelled') DEFAULT 'Draft',
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `approved_by` int(10) UNSIGNED DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `payment_ref` varchar(100) DEFAULT NULL,
  `payment_mode` enum('NEFT','RTGS','UPI','Cash','Cheque') DEFAULT 'NEFT',
  `receipt_path` varchar(255) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `id` int(10) UNSIGNED NOT NULL,
  `jsca_player_id` varchar(20) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `date_of_birth` date NOT NULL,
  `gender` enum('Male','Female','Other') DEFAULT 'Male',
  `age_category` enum('U14','U16','U19','Senior','Masters') NOT NULL,
  `district_id` int(10) UNSIGNED NOT NULL,
  `role` enum('Batsman','Bowler','All-rounder','Wicket-keeper') NOT NULL,
  `batting_style` enum('Right-hand','Left-hand') DEFAULT NULL,
  `bowling_style` enum('Right-arm Fast','Right-arm Medium','Right-arm Off-spin','Right-arm Leg-spin','Left-arm Fast','Left-arm Medium','Left-arm Orthodox','Left-arm Chinaman','N/A') DEFAULT 'N/A',
  `aadhaar_number` varchar(12) DEFAULT NULL,
  `aadhaar_verified` tinyint(1) DEFAULT 0,
  `digilocker_id` varchar(50) DEFAULT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `guardian_name` varchar(100) DEFAULT NULL,
  `guardian_phone` varchar(15) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `status` enum('Active','Inactive','Suspended','Retired') DEFAULT 'Active',
  `selection_pool` enum('District','State','None') DEFAULT 'None',
  `registered_by` int(10) UNSIGNED DEFAULT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `registration_type` enum('manual','self') NOT NULL DEFAULT 'manual',
  `verified_by` int(10) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`id`, `jsca_player_id`, `full_name`, `date_of_birth`, `gender`, `age_category`, `district_id`, `role`, `batting_style`, `bowling_style`, `aadhaar_number`, `aadhaar_verified`, `digilocker_id`, `photo_path`, `address`, `guardian_name`, `guardian_phone`, `email`, `phone`, `status`, `selection_pool`, `registered_by`, `user_id`, `registration_type`, `verified_by`, `verified_at`, `created_at`, `updated_at`) VALUES
(1, 'JSCA-P-2026-00001', 'rowhit', '2026-03-14', 'Male', 'U14', 2, 'Batsman', 'Right-hand', 'Right-arm Fast', '312312312312', 0, NULL, 'uploads/players/1773491034_cf0c9ab476d0593b60dc.jpg', 'ranchi', 'rk', '4234234234234', 'Ghgsa@gmail.com', '6206086679', 'Active', 'None', 1, NULL, 'manual', NULL, NULL, '2026-03-14 12:23:54', NULL),
(2, 'JSCA-P-2026-00002', 'riya', '2026-03-17', 'Female', 'U14', 3, 'All-rounder', 'Right-hand', 'N/A', '342222222222', 0, NULL, NULL, 'dasdasdasdasdas', 'rjk', '5345335345345', 'Ghgsa@gmail.com', '1222222222124', 'Active', 'None', 1, NULL, 'manual', NULL, NULL, '2026-03-17 13:22:29', NULL),
(3, 'JSCA-P-2026-00003', 'sukuna', '2002-01-17', 'Male', 'Senior', 8, 'Batsman', 'Right-hand', 'N/A', '123123123123', 0, NULL, NULL, 'dasdasd, asdasdasdasd, Jharkhand, PIN: 321231', 'dasdasd', '6206086679', 'd@gmail.com', '6206086679', 'Active', 'None', 1, NULL, 'manual', NULL, NULL, '2026-03-17 13:30:26', NULL),
(4, 'JSCA-P-2026-00004', 'gojo', '2021-03-04', 'Male', 'U14', 8, 'Batsman', 'Right-hand', 'Right-arm Fast', '620608667941', 0, NULL, 'uploads/players/1774343987_35cb3a20e42c8d13cf90.jpg', 'ranchi, ranhchi, Jharkhand, PIN: 832323', 'rk', '6206086679', '5mincode6@gmail.com', '6206086679', 'Inactive', 'None', NULL, 2, 'self', NULL, NULL, '2026-03-24 09:19:47', NULL),
(5, 'JSCA-P-2026-00005', 'makima', '2021-03-03', 'Female', 'U14', 15, 'Bowler', 'Right-hand', 'Right-arm Fast', '620608667931', 0, NULL, NULL, 'ranchi, ranchi, Jharkhand, PIN: 312312', 'rk', '6206086679', 'rk301855@gmai.com', '6206086679', 'Active', 'None', 1, 3, 'manual', NULL, NULL, '2026-03-24 09:30:44', NULL),
(6, 'JSCA-P-2026-00006', 'maru', '2021-03-04', 'Male', 'U14', 4, 'Batsman', 'Right-hand', 'Right-arm Medium', '620608667931', 0, NULL, NULL, 'ranchi, ranchi, Jharkhand, PIN: 123412', 'rkk', '6206086679', 'gexixop345@onbap.com', '6206086679', 'Active', 'None', 1, 5, 'manual', NULL, NULL, '2026-03-24 09:35:32', NULL),
(7, 'JSCA-P-2026-00007', 'Rohit Kumar Singh', '2000-03-15', 'Male', 'Senior', 1, 'Batsman', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234501', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(8, 'JSCA-P-2026-00008', 'Amit Sharma', '1998-07-22', 'Male', 'Senior', 1, 'Bowler', 'Right-hand', 'Right-arm Fast', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234502', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(9, 'JSCA-P-2026-00009', 'Vikash Oraon', '2001-11-05', 'Male', 'Senior', 1, 'All-rounder', 'Right-hand', 'Right-arm Medium', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234503', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(10, 'JSCA-P-2026-00010', 'Deepak Mahto', '1999-01-30', 'Male', 'Senior', 1, 'Wicket-keeper', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234504', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(11, 'JSCA-P-2026-00011', 'Suraj Tirkey', '2002-09-18', 'Male', 'Senior', 1, 'Batsman', 'Left-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234505', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(12, 'JSCA-P-2026-00012', 'Manish Gupta', '1997-04-12', 'Male', 'Senior', 1, 'Bowler', 'Right-hand', 'Right-arm Off-spin', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234506', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(13, 'JSCA-P-2026-00013', 'Priya Kumari', '2003-06-25', 'Female', 'Senior', 1, 'Batsman', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234507', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(14, 'JSCA-P-2026-00014', 'Arjun Prasad', '2008-02-14', 'Male', 'U19', 1, 'All-rounder', 'Right-hand', 'Right-arm Medium', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234508', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(15, 'JSCA-P-2026-00015', 'Rahul Minz', '2009-08-03', 'Male', 'U19', 1, 'Batsman', 'Left-hand', 'Left-arm Orthodox', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234509', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(16, 'JSCA-P-2026-00016', 'Sanjay Hembrom', '2010-12-20', 'Male', 'U16', 1, 'Bowler', 'Right-hand', 'Right-arm Leg-spin', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234510', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(17, 'JSCA-P-2026-00017', 'Anita Devi', '2011-05-09', 'Female', 'U16', 1, 'Batsman', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234511', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(18, 'JSCA-P-2026-00018', 'Ravi Shankar Yadav', '2012-10-17', 'Male', 'U14', 1, 'All-rounder', 'Right-hand', 'Right-arm Medium', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234512', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(19, 'JSCA-P-2026-00019', 'Nikhil Toppo', '2013-03-28', 'Male', 'U14', 1, 'Bowler', 'Left-hand', 'Left-arm Fast', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234513', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(20, 'JSCA-P-2026-00020', 'Kavita Soren', '1985-07-11', 'Female', 'Masters', 1, 'Batsman', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234514', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(21, 'JSCA-P-2026-00021', 'Dinesh Mahali', '1983-01-04', 'Male', 'Masters', 1, 'Bowler', 'Right-hand', 'Right-arm Off-spin', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9801234515', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 07:56:35', NULL),
(22, 'JSCA-P-2026-00022', 'Aryan Singh', '2012-03-11', 'Male', 'U14', 1, 'Batsman', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9822200001', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(23, 'JSCA-P-2026-00023', 'Kartik Mahto', '2013-07-04', 'Male', 'U14', 1, 'Bowler', 'Right-hand', 'Right-arm Fast', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9822200002', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(24, 'JSCA-P-2026-00024', 'Saurav Oraon', '2012-11-19', 'Male', 'U14', 1, 'All-rounder', 'Left-hand', 'Left-arm Orthodox', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9822200003', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(25, 'JSCA-P-2026-00025', 'Deepak Tirkey', '2013-02-28', 'Male', 'U14', 1, 'Wicket-keeper', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9822200004', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(26, 'JSCA-P-2026-00026', 'Rahul Gope', '2012-08-15', 'Male', 'U14', 1, 'Batsman', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9822200005', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(27, 'JSCA-P-2026-00027', 'Amit Kujur', '2013-05-22', 'Male', 'U14', 1, 'Bowler', 'Right-hand', 'Right-arm Off-spin', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9822200006', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(28, 'JSCA-P-2026-00028', 'Vishal Hembrom', '2012-09-30', 'Male', 'U14', 1, 'Batsman', 'Left-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9822200007', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(29, 'JSCA-P-2026-00029', 'Priya Minj', '2013-01-17', 'Female', 'U14', 1, 'Batsman', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9822200008', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(30, 'JSCA-P-2026-00030', 'Suresh Barla', '2012-06-08', 'Male', 'U14', 1, 'Bowler', 'Left-hand', 'Left-arm Fast', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9822200009', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(31, 'JSCA-P-2026-00031', 'Neeraj Kandulna', '2013-04-25', 'Male', 'U14', 1, 'All-rounder', 'Right-hand', 'Right-arm Medium', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9822200010', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(32, 'JSCA-P-2026-00032', 'Aryan Lakra', '2012-04-10', 'Male', 'U14', 13, 'Batsman', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9811100001', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(33, 'JSCA-P-2026-00033', 'Sunil Kujur', '2013-01-22', 'Male', 'U14', 13, 'Bowler', 'Right-hand', 'Right-arm Medium', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9811100002', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(34, 'JSCA-P-2026-00034', 'Rajan Ekka', '2012-09-05', 'Male', 'U14', 13, 'All-rounder', 'Left-hand', 'Left-arm Orthodox', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9811100003', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(35, 'JSCA-P-2026-00035', 'Deepa Minj', '2013-06-18', 'Female', 'U14', 13, 'Batsman', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9811100004', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(36, 'JSCA-P-2026-00036', 'Rohit Tirkey', '2012-11-30', 'Male', 'U14', 13, 'Wicket-keeper', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9811100005', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(37, 'JSCA-P-2026-00037', 'Ankit Horo', '2013-03-14', 'Male', 'U14', 13, 'Bowler', 'Right-hand', 'Right-arm Fast', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9811100006', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(38, 'JSCA-P-2026-00038', 'Priti Oraon', '2012-07-25', 'Female', 'U14', 13, 'All-rounder', 'Right-hand', 'Right-arm Off-spin', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9811100007', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(39, 'JSCA-P-2026-00039', 'Vikram Kandulna', '2013-08-09', 'Male', 'U14', 13, 'Batsman', 'Left-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9811100008', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(40, 'JSCA-P-2026-00040', 'Suman Barla', '2012-05-17', 'Male', 'U14', 13, 'Bowler', 'Left-hand', 'Left-arm Fast', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9811100009', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(41, 'JSCA-P-2026-00041', 'Nisha Dungdung', '2013-02-28', 'Female', 'U14', 13, 'Batsman', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9811100010', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:20:20', NULL),
(42, 'JSCA-P-2026-00042', 'Rohan Sahu', '2012-02-14', 'Male', 'U14', 1, 'Batsman', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9833300001', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:46:53', NULL),
(43, 'JSCA-P-2026-00043', 'Tushar Pandey', '2013-06-09', 'Male', 'U14', 1, 'Bowler', 'Right-hand', 'Right-arm Fast', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9833300002', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:46:53', NULL),
(44, 'JSCA-P-2026-00044', 'Manav Gupta', '2012-10-23', 'Male', 'U14', 1, 'All-rounder', 'Right-hand', 'Right-arm Medium', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9833300003', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:46:53', NULL),
(45, 'JSCA-P-2026-00045', 'Shivam Tiwari', '2013-03-17', 'Male', 'U14', 1, 'Wicket-keeper', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9833300004', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:46:53', NULL),
(46, 'JSCA-P-2026-00046', 'Aditya Verma', '2012-07-31', 'Male', 'U14', 1, 'Batsman', 'Left-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9833300005', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:46:53', NULL),
(47, 'JSCA-P-2026-00047', 'Nitin Rajak', '2013-01-05', 'Male', 'U14', 1, 'Bowler', 'Right-hand', 'Right-arm Off-spin', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9833300006', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:46:53', NULL),
(48, 'JSCA-P-2026-00048', 'Gaurav Mahto', '2012-05-19', 'Male', 'U14', 1, 'Batsman', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9833300007', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:46:53', NULL),
(49, 'JSCA-P-2026-00049', 'Sanjay Kumar', '2013-09-28', 'Male', 'U14', 1, 'All-rounder', 'Left-hand', 'Left-arm Orthodox', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9833300008', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:46:53', NULL),
(50, 'JSCA-P-2026-00050', 'Piyush Oraon', '2012-12-11', 'Male', 'U14', 1, 'Bowler', 'Left-hand', 'Left-arm Fast', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9833300009', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:46:53', NULL),
(51, 'JSCA-P-2026-00051', 'Ananya Singh', '2013-04-02', 'Female', 'U14', 1, 'Batsman', 'Right-hand', 'N/A', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9833300010', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:46:53', NULL),
(52, 'JSCA-P-2026-00052', 'Ritesh Hembrom', '2012-08-26', 'Male', 'U14', 1, 'Bowler', 'Right-hand', 'Right-arm Leg-spin', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '9833300011', 'Active', 'None', NULL, NULL, 'manual', NULL, NULL, '2026-03-25 11:46:53', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `player_career_stats`
--

CREATE TABLE `player_career_stats` (
  `id` int(10) UNSIGNED NOT NULL,
  `player_id` int(10) UNSIGNED NOT NULL,
  `matches` int(11) DEFAULT 0,
  `runs` int(11) DEFAULT 0,
  `highest_score` int(11) DEFAULT 0,
  `batting_avg` decimal(6,2) DEFAULT 0.00,
  `strike_rate` decimal(6,2) DEFAULT 0.00,
  `fifties` int(11) DEFAULT 0,
  `hundreds` int(11) DEFAULT 0,
  `wickets` int(11) DEFAULT 0,
  `best_bowling` varchar(10) DEFAULT NULL,
  `bowling_avg` decimal(6,2) DEFAULT 0.00,
  `economy` decimal(5,2) DEFAULT 0.00,
  `catches` int(11) DEFAULT 0,
  `last_updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_career_stats`
--

INSERT INTO `player_career_stats` (`id`, `player_id`, `matches`, `runs`, `highest_score`, `batting_avg`, `strike_rate`, `fifties`, `hundreds`, `wickets`, `best_bowling`, `bowling_avg`, `economy`, `catches`, `last_updated`) VALUES
(1, 1, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-14 12:23:54'),
(2, 2, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-17 13:22:29'),
(3, 3, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-17 13:30:26'),
(4, 4, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-24 09:19:47'),
(5, 5, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-24 09:30:44'),
(6, 6, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-24 09:35:32'),
(7, 7, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(8, 8, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(9, 9, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(10, 10, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(11, 11, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(12, 12, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(13, 13, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(14, 14, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(15, 15, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(16, 16, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(17, 17, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(18, 18, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(19, 19, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(20, 20, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(21, 21, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 07:56:35'),
(22, 22, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(23, 23, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(24, 24, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(25, 25, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(26, 26, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(27, 27, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(28, 28, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(29, 29, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(30, 30, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(31, 31, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(32, 32, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(33, 33, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(34, 34, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(35, 35, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(36, 36, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(37, 37, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(38, 38, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(39, 39, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(40, 40, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(41, 41, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:20:20'),
(53, 42, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:46:53'),
(54, 43, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:46:53'),
(55, 44, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:46:53'),
(56, 45, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:46:53'),
(57, 46, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:46:53'),
(58, 47, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:46:53'),
(59, 48, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:46:53'),
(60, 49, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:46:53'),
(61, 50, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:46:53'),
(62, 51, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:46:53'),
(63, 52, 0, 0, 0, 0.00, 0.00, 0, 0, 0, NULL, 0.00, 0.00, 0, '2026-03-25 11:46:53');

-- --------------------------------------------------------

--
-- Table structure for table `player_documents`
--

CREATE TABLE `player_documents` (
  `id` int(10) UNSIGNED NOT NULL,
  `player_id` int(10) UNSIGNED NOT NULL,
  `doc_type` enum('aadhaar_front','aadhaar_back','birth_certificate','school_certificate','noc','medical_fitness','photo','other') NOT NULL,
  `label` varchar(100) DEFAULT NULL COMMENT 'Custom label for other type',
  `file_path` varchar(255) NOT NULL,
  `file_name` varchar(150) NOT NULL,
  `mime_type` varchar(80) DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `verified_by` int(10) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `uploaded_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_otp_verifications`
--

CREATE TABLE `player_otp_verifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(150) NOT NULL,
  `otp` varchar(6) NOT NULL,
  `expires_at` datetime NOT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player_otp_verifications`
--

INSERT INTO `player_otp_verifications` (`id`, `email`, `otp`, `expires_at`, `verified`, `created_at`) VALUES
(1, '5mincode6@gmail.com', '748642', '2026-03-24 09:28:24', 1, '2026-03-24 09:18:24');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `permissions`, `created_at`) VALUES
(1, 'superadmin', '[\"all\"]', '2026-03-09 18:15:08'),
(2, 'admin', '[\"players\",\"coaches\",\"teams\",\"fixtures\",\"finance\",\"tournaments\",\"officials\",\"reports\",\"venues\"]', '2026-03-09 18:15:08'),
(3, 'selector', '[\"players.view\",\"analytics.view\",\"tournaments.view\"]', '2026-03-09 18:15:08'),
(4, 'accounts', '[\"finance.view\",\"finance.approve\",\"reports.finance\"]', '2026-03-09 18:15:08'),
(5, 'umpire', '[\"fixtures.view\",\"matches.view\"]', '2026-03-09 18:15:08'),
(6, 'data_entry', '[\"players.create\",\"matches.score\",\"fixtures.view\"]', '2026-03-09 18:15:08'),
(7, 'referee', '[\"officials\", \"fixtures\"]', '2026-03-24 10:10:47'),
(8, 'match_referee', '[\"officials\", \"fixtures\"]', '2026-03-24 10:10:47');

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `id` int(10) UNSIGNED NOT NULL,
  `jsca_team_id` varchar(30) DEFAULT NULL,
  `tournament_id` int(10) UNSIGNED NOT NULL,
  `district_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `zone` enum('North','South','East','West','Central','None') DEFAULT 'None',
  `captain_id` int(10) UNSIGNED DEFAULT NULL,
  `vice_captain_id` int(10) UNSIGNED DEFAULT NULL,
  `manager_name` varchar(100) DEFAULT NULL,
  `manager_phone` varchar(15) DEFAULT NULL,
  `registered_by` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('Registered','Confirmed','Withdrawn') DEFAULT 'Registered',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`id`, `jsca_team_id`, `tournament_id`, `district_id`, `name`, `zone`, `captain_id`, `vice_captain_id`, `manager_name`, `manager_phone`, `registered_by`, `status`, `created_at`, `updated_at`) VALUES
(1, 'JSCA-T-2026-0001', 1, 15, 'meoww', 'South', NULL, NULL, NULL, NULL, NULL, 'Registered', '2026-03-24 11:21:27', NULL),
(2, 'JSCA-T-2026-0002', 3, 1, 'ranchi fighters', 'South', 46, 50, 'rowhti', '6206086673', 1, 'Confirmed', '2026-03-25 08:14:14', '2026-03-25 11:23:50'),
(3, 'JSCA-T-2026-0003', 3, 1, 'morabdi fighters', 'South', NULL, NULL, 'rohit', '6206086677', 1, 'Registered', '2026-03-25 08:16:12', NULL),
(4, 'JSCA-T-2026-0004', 3, 1, 'namkum fighters', 'South', NULL, NULL, 'rohtitee', '6206086677', 1, 'Registered', '2026-03-25 08:17:48', NULL),
(5, 'JSCA-T-2026-0005', 3, 1, 'main road rollers', 'South', 19, 18, 'rowwww', '9570037775', 1, 'Confirmed', '2026-03-25 11:01:04', '2026-03-25 11:23:00');

-- --------------------------------------------------------

--
-- Table structure for table `team_coaches`
--

CREATE TABLE `team_coaches` (
  `id` int(10) UNSIGNED NOT NULL,
  `team_id` int(10) UNSIGNED NOT NULL,
  `coach_id` int(10) UNSIGNED NOT NULL,
  `role` varchar(80) NOT NULL DEFAULT 'Head Coach',
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `team_coaches`
--

INSERT INTO `team_coaches` (`id`, `team_id`, `coach_id`, `role`, `from_date`, `to_date`, `is_current`) VALUES
(1, 5, 1, 'Head Coach', '2026-03-25', NULL, 1),
(2, 2, 3, 'Head Coach', '2026-03-25', NULL, 1),
(3, 2, 2, 'Head Coach', '2026-03-25', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `team_documents`
--

CREATE TABLE `team_documents` (
  `id` int(10) UNSIGNED NOT NULL,
  `team_id` int(10) UNSIGNED NOT NULL,
  `doc_type` enum('registration_form','affiliation_certificate','noc','player_consent','insurance','other') NOT NULL,
  `label` varchar(100) DEFAULT NULL,
  `file_path` varchar(255) NOT NULL,
  `file_name` varchar(150) NOT NULL,
  `mime_type` varchar(80) DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `verified_by` int(10) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `uploaded_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `team_players`
--

CREATE TABLE `team_players` (
  `id` int(10) UNSIGNED NOT NULL,
  `team_id` int(10) UNSIGNED NOT NULL,
  `player_id` int(10) UNSIGNED NOT NULL,
  `jersey_number` int(11) DEFAULT NULL,
  `is_captain` tinyint(1) DEFAULT 0,
  `is_vice_captain` tinyint(1) DEFAULT 0,
  `is_wk` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `team_players`
--

INSERT INTO `team_players` (`id`, `team_id`, `player_id`, `jersey_number`, `is_captain`, `is_vice_captain`, `is_wk`, `created_at`) VALUES
(1, 1, 5, 34, 0, 0, 0, '2026-03-24 11:22:02'),
(2, 5, 19, NULL, 1, 0, 0, '2026-03-25 11:05:05'),
(3, 5, 18, NULL, 0, 1, 0, '2026-03-25 11:05:20'),
(4, 5, 27, NULL, 0, 0, 0, '2026-03-25 11:21:08'),
(5, 5, 31, NULL, 0, 0, 1, '2026-03-25 11:21:24'),
(6, 5, 28, NULL, 0, 0, 0, '2026-03-25 11:21:36'),
(7, 5, 25, NULL, 0, 0, 0, '2026-03-25 11:21:47'),
(8, 5, 23, NULL, 0, 0, 0, '2026-03-25 11:21:58'),
(9, 5, 22, NULL, 0, 0, 0, '2026-03-25 11:22:08'),
(10, 5, 29, NULL, 0, 0, 0, '2026-03-25 11:22:20'),
(11, 5, 26, NULL, 0, 0, 0, '2026-03-25 11:22:28'),
(12, 5, 24, NULL, 0, 0, 0, '2026-03-25 11:22:38'),
(13, 5, 30, NULL, 0, 0, 0, '2026-03-25 11:22:46'),
(14, 2, 46, NULL, 1, 0, 0, '2026-03-25 11:50:55'),
(17, 2, 51, NULL, 0, 0, 0, '2026-03-25 11:51:33'),
(19, 2, 48, NULL, 0, 0, 0, '2026-03-25 11:51:53'),
(21, 2, 44, NULL, 0, 0, 0, '2026-03-25 11:52:11'),
(24, 2, 47, NULL, 0, 0, 0, '2026-03-25 11:52:41'),
(25, 2, 50, NULL, 0, 1, 0, '2026-03-25 12:46:19'),
(26, 2, 52, NULL, 0, 0, 0, '2026-03-25 12:46:30'),
(27, 2, 42, NULL, 0, 0, 0, '2026-03-25 12:46:39'),
(28, 2, 49, NULL, 0, 0, 0, '2026-03-25 12:46:48'),
(29, 2, 45, NULL, 0, 0, 0, '2026-03-25 12:46:58'),
(30, 2, 43, NULL, 0, 0, 0, '2026-03-25 12:47:08');

-- --------------------------------------------------------

--
-- Table structure for table `tournaments`
--

CREATE TABLE `tournaments` (
  `id` int(10) UNSIGNED NOT NULL,
  `jsca_tournament_id` varchar(20) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `short_name` varchar(20) DEFAULT NULL,
  `edition` varchar(50) DEFAULT NULL,
  `season` varchar(10) NOT NULL,
  `age_category` enum('U14','U16','U19','Senior','Masters','Women') NOT NULL,
  `category` varchar(20) DEFAULT NULL,
  `gender` enum('Male','Female','Mixed') DEFAULT 'Male',
  `format` enum('T10','T20','ODI-40','ODI-50','Test','Custom') NOT NULL,
  `overs` int(11) DEFAULT 20,
  `structure` enum('Round Robin','Knockout','Group+Knockout','League+Playoffs','Zonal') NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `is_zonal` tinyint(1) DEFAULT 0,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `venue_id` int(10) UNSIGNED DEFAULT NULL,
  `organizer_name` varchar(100) DEFAULT NULL,
  `organizer_phone` varchar(15) DEFAULT NULL,
  `organizer_email` varchar(150) DEFAULT NULL,
  `registration_deadline` date DEFAULT NULL,
  `total_teams` int(11) DEFAULT 0,
  `max_teams` int(11) DEFAULT NULL,
  `total_matches` int(11) DEFAULT 0,
  `status` enum('Draft','Registration','Fixture Ready','Ongoing','Completed','Cancelled') DEFAULT 'Draft',
  `prize_pool` decimal(12,2) DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `rules` text DEFAULT NULL,
  `banner_path` varchar(255) DEFAULT NULL,
  `winner_prize` decimal(12,2) DEFAULT 0.00,
  `runner_prize` decimal(12,2) DEFAULT 0.00,
  `travel_constraint` enum('Minimize','Zonal','Centralized','None') DEFAULT 'None',
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `registered_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tournaments`
--

INSERT INTO `tournaments` (`id`, `jsca_tournament_id`, `name`, `short_name`, `edition`, `season`, `age_category`, `category`, `gender`, `format`, `overs`, `structure`, `type`, `is_zonal`, `start_date`, `end_date`, `venue_id`, `organizer_name`, `organizer_phone`, `organizer_email`, `registration_deadline`, `total_teams`, `max_teams`, `total_matches`, `status`, `prize_pool`, `description`, `rules`, `banner_path`, `winner_prize`, `runner_prize`, `travel_constraint`, `created_by`, `registered_by`, `created_at`, `updated_at`) VALUES
(1, 'JSCA-TR-2026-001', 'funny morabadi match', 'fm match', '1st', '2026-2027', 'U14', NULL, 'Male', 'T10', 10, 'Round Robin', NULL, 0, '2026-03-28', '2026-03-26', 9, 'rk', '6206086677', 'test@gmail.com', '2026-03-18', 0, 10, 0, 'Draft', 100000.00, 'dasdasd', 'dasdasdasd', NULL, 10000.00, 10000.00, 'None', 1, NULL, '2026-03-24 10:53:02', NULL),
(2, 'JSCA-TR-2026-002', 'wewwww', 'www', '1st', '2026-2027', 'U14', NULL, 'Male', 'T10', 10, 'Round Robin', NULL, 0, '2026-03-25', '2026-03-26', 9, 'rk', '6206086677', 'test@gmail.com', '2026-03-23', 0, 2, 0, 'Fixture Ready', 10000.00, NULL, NULL, NULL, 10000.00, 10000.00, 'None', 1, NULL, '2026-03-24 10:57:26', '2026-03-24 11:02:32'),
(3, 'JSCA-TR-2026-003', 'ranchi sports league', 'rsl', NULL, '2026-2027', 'U14', NULL, 'Male', 'T10', 10, 'Round Robin', NULL, 0, '2026-03-26', '2026-03-27', 1, NULL, NULL, NULL, '2026-03-22', 0, 2, 0, 'Fixture Ready', 10000.00, NULL, NULL, NULL, 6000.00, 4000.00, 'None', 1, NULL, '2026-03-25 08:13:27', '2026-03-25 11:54:23');

-- --------------------------------------------------------

--
-- Table structure for table `tournament_budgets`
--

CREATE TABLE `tournament_budgets` (
  `id` int(10) UNSIGNED NOT NULL,
  `tournament_id` int(10) UNSIGNED NOT NULL,
  `total_budget` decimal(12,2) DEFAULT 0.00,
  `allocated` decimal(12,2) DEFAULT 0.00,
  `spent` decimal(12,2) DEFAULT 0.00,
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tournament_documents`
--

CREATE TABLE `tournament_documents` (
  `id` int(10) UNSIGNED NOT NULL,
  `tournament_id` int(10) UNSIGNED NOT NULL,
  `doc_type` enum('approval_letter','bcci_sanction','insurance','schedule','rules_regulations','sponsorship_agreement','other') NOT NULL,
  `label` varchar(100) DEFAULT NULL,
  `file_path` varchar(255) NOT NULL,
  `file_name` varchar(150) NOT NULL,
  `mime_type` varchar(80) DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `verified_by` int(10) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `uploaded_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `custom_permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`custom_permissions`)),
  `full_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `last_login` datetime DEFAULT NULL,
  `reset_token` varchar(100) DEFAULT NULL,
  `reset_expires` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `role_id`, `custom_permissions`, `full_name`, `email`, `phone`, `password_hash`, `is_active`, `last_login`, `reset_token`, `reset_expires`, `created_at`, `updated_at`) VALUES
(1, 1, NULL, 'JSCA Super Admin', 'admin@jsca.in', '9000000001', '$2y$10$GIe68NrFKjr14UXXAUCqHufkk6gBxgZWYD9OxpcIMvhAkfyIPl.Vi', 1, '2026-03-26 07:12:53', NULL, NULL, '2026-03-09 18:15:09', '2026-03-26 07:12:53'),
(2, 3, NULL, 'gojo', '5mincode6@gmail.com', '6206086679', '$2y$10$8GTfKHrTKLVNUX55AsXOrenXy7MDX9tUobUGebVJe3CWftD/lh116', 0, NULL, NULL, NULL, '2026-03-24 09:19:47', NULL),
(3, 3, NULL, 'makima', 'rk301855@gmai.com', '6206086679', '$2y$10$QII99f9TLBAY3buTsUmbiujfDBxEJzNXJ/xmd5sLh1mTbl1P/HelO', 1, NULL, NULL, NULL, '2026-03-24 09:30:44', NULL),
(5, 3, NULL, 'maru', 'gexixop345@onbap.com', '6206086679', '$2y$10$KourKWnZV9iuPw5RauIyAOA4cmjmsaiwsYHd6OzURXp4H43xLLzea', 1, NULL, NULL, NULL, '2026-03-24 09:35:32', NULL),
(7, 5, NULL, 'rohit', 'tilab37005@izkat.com', '6206086679', '$2y$10$wLOShiow2UF5aUxOPGs7puDmvdyH7WlVK5Z2Of4.NQF7feeZcgw4S', 1, NULL, NULL, NULL, '2026-03-24 10:32:29', NULL),
(8, 4, '[\"players\",\"coaches\",\"venues\",\"teams\",\"officials\",\"finance\",\"reports\"]', 'yuuko', 'yu@gmail.com', '6206086679', '$2y$10$/HYcaoeMhm7IFVmNV3LG4.On2sBNE9i6qLyB9Adt70JWrQbssfYjm', 1, '2026-03-25 09:13:46', NULL, NULL, '2026-03-24 11:53:22', '2026-03-25 09:14:06'),
(10, 6, NULL, 'vishal', 'rks7549079802@gmail.com', '', '$2y$10$VMoZxUHBoJPmoI2jQhLUreq44m5rEnL4hKVzqExGvEXmIacbO7sVW', 1, NULL, NULL, NULL, '2026-03-25 07:38:23', NULL),
(11, 5, NULL, 'rahul', 'Ghgsa@gmail.com', '6206086679', '$2y$10$zdeM7FqP3/WWD3qptje0jO3jQYpUByTZrSYf272dNfR9ZIUqE1Bb.', 1, NULL, NULL, NULL, '2026-03-25 07:48:13', NULL),
(12, 7, NULL, 'sumit', 'me@mydomain.com', '6206086679', '$2y$10$eAgSeXK34OV5tLNPFQ6jfO5eHrsc1UZUyiPswZs8GxHU/ZXPOt.oi', 1, NULL, NULL, NULL, '2026-03-25 07:49:31', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_districts`
--

CREATE TABLE `user_districts` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `district_id` int(10) UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_districts`
--

INSERT INTO `user_districts` (`id`, `user_id`, `district_id`, `created_at`) VALUES
(9, 8, 11, '2026-03-25 09:14:06');

-- --------------------------------------------------------

--
-- Table structure for table `venues`
--

CREATE TABLE `venues` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `district_id` int(10) UNSIGNED NOT NULL,
  `capacity` int(11) DEFAULT 0,
  `has_floodlights` tinyint(1) DEFAULT 0,
  `has_scoreboard` tinyint(1) DEFAULT 0,
  `has_dressing` tinyint(1) DEFAULT 0,
  `pitch_type` enum('Grass','Turf','Concrete','Red-soil') DEFAULT 'Grass',
  `contact_person` varchar(100) DEFAULT NULL,
  `contact_phone` varchar(15) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `lat` decimal(9,6) DEFAULT NULL,
  `lng` decimal(9,6) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `venues`
--

INSERT INTO `venues` (`id`, `name`, `district_id`, `capacity`, `has_floodlights`, `has_scoreboard`, `has_dressing`, `pitch_type`, `contact_person`, `contact_phone`, `address`, `lat`, `lng`, `is_active`, `created_at`) VALUES
(1, 'JSCA International Stadium', 1, 45000, 1, 0, 0, 'Grass', '', '', '', NULL, NULL, 1, '2026-03-09 18:15:09'),
(2, 'Keenan Stadium', 4, 25000, 1, 0, 0, 'Grass', NULL, NULL, NULL, NULL, NULL, 1, '2026-03-09 18:15:09'),
(3, 'Bokaro Steel City Ground', 3, 8000, 0, 0, 0, 'Grass', NULL, NULL, NULL, NULL, NULL, 1, '2026-03-09 18:15:09'),
(4, 'Dhanbad District Ground', 2, 5000, 0, 0, 0, 'Grass', NULL, NULL, NULL, NULL, NULL, 1, '2026-03-09 18:15:09'),
(5, 'Hazaribagh Ground', 5, 4000, 0, 0, 0, 'Grass', NULL, NULL, NULL, NULL, NULL, 1, '2026-03-09 18:15:09'),
(6, 'Deoghar Cricket Ground', 7, 3500, 0, 0, 0, 'Grass', NULL, NULL, NULL, NULL, NULL, 1, '2026-03-09 18:15:09'),
(7, 'Giridih Sports Complex', 6, 3000, 0, 0, 0, 'Grass', NULL, NULL, NULL, NULL, NULL, 1, '2026-03-09 18:15:09'),
(8, 'Dumka Stadium', 8, 4500, 1, 0, 0, 'Grass', NULL, NULL, NULL, NULL, NULL, 1, '2026-03-09 18:15:09'),
(9, 'morabadi stadium', 1, 3000, 1, 1, 1, 'Turf', 'rowhit', '6206043243', 'near morabadi', NULL, NULL, 1, '2026-03-24 09:43:57');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account_groups`
--
ALTER TABLE `account_groups`
  ADD PRIMARY KEY (`G_Name`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_module_record` (`module`,`record_id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Indexes for table `batting_stats`
--
ALTER TABLE `batting_stats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fixture_id` (`fixture_id`),
  ADD KEY `team_id` (`team_id`),
  ADD KEY `idx_player_fixture` (`player_id`,`fixture_id`);

--
-- Indexes for table `bowling_stats`
--
ALTER TABLE `bowling_stats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fixture_id` (`fixture_id`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `team_id` (`team_id`);

--
-- Indexes for table `coaches`
--
ALTER TABLE `coaches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `jsca_coach_id` (`jsca_coach_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_district` (`district_id`);

--
-- Indexes for table `coach_documents`
--
ALTER TABLE `coach_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_coach` (`coach_id`);

--
-- Indexes for table `districts`
--
ALTER TABLE `districts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `fixtures`
--
ALTER TABLE `fixtures`
  ADD PRIMARY KEY (`id`),
  ADD KEY `team_a_id` (`team_a_id`),
  ADD KEY `team_b_id` (`team_b_id`),
  ADD KEY `venue_id` (`venue_id`),
  ADD KEY `umpire1_id` (`umpire1_id`),
  ADD KEY `umpire2_id` (`umpire2_id`),
  ADD KEY `scorer_id` (`scorer_id`),
  ADD KEY `referee_id` (`referee_id`),
  ADD KEY `idx_tournament_date` (`tournament_id`,`match_date`);

--
-- Indexes for table `ledger_heads`
--
ALTER TABLE `ledger_heads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_id` (`group_id`);

--
-- Indexes for table `live_matches`
--
ALTER TABLE `live_matches`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `fk_lm_team_a` (`team_a_id`),
  ADD KEY `fk_lm_team_b` (`team_b_id`);

--
-- Indexes for table `match_scorecards`
--
ALTER TABLE `match_scorecards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `fixture_id` (`fixture_id`),
  ADD KEY `player_of_match` (`player_of_match`);

--
-- Indexes for table `officials`
--
ALTER TABLE `officials`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `jsca_official_id` (`jsca_official_id`),
  ADD KEY `fk_off_type` (`official_type_id`),
  ADD KEY `fk_off_district` (`district_id`),
  ADD KEY `fk_off_user` (`user_id`),
  ADD KEY `fk_off_regby` (`registered_by`);

--
-- Indexes for table `official_certifications`
--
ALTER TABLE `official_certifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `official_id` (`official_id`);

--
-- Indexes for table `official_types`
--
ALTER TABLE `official_types`
  ADD PRIMARY KEY (`id`),
  ADD KEY `role_id` (`role_id`);

--
-- Indexes for table `payment_vouchers`
--
ALTER TABLE `payment_vouchers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `voucher_number` (`voucher_number`),
  ADD KEY `fixture_id` (`fixture_id`),
  ADD KEY `official_id` (`official_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_tournament` (`tournament_id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `jsca_player_id` (`jsca_player_id`),
  ADD KEY `registered_by` (`registered_by`),
  ADD KEY `idx_age_category` (`age_category`),
  ADD KEY `idx_district` (`district_id`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `player_career_stats`
--
ALTER TABLE `player_career_stats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `player_id` (`player_id`);

--
-- Indexes for table `player_documents`
--
ALTER TABLE `player_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_player` (`player_id`);

--
-- Indexes for table `player_otp_verifications`
--
ALTER TABLE `player_otp_verifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email` (`email`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tournament_id` (`tournament_id`),
  ADD KEY `district_id` (`district_id`),
  ADD KEY `captain_id` (`captain_id`),
  ADD KEY `vice_captain_id` (`vice_captain_id`);

--
-- Indexes for table `team_coaches`
--
ALTER TABLE `team_coaches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_team_coach` (`team_id`,`coach_id`,`is_current`),
  ADD KEY `fk_tc_coach` (`coach_id`);

--
-- Indexes for table `team_documents`
--
ALTER TABLE `team_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_team` (`team_id`);

--
-- Indexes for table `team_players`
--
ALTER TABLE `team_players`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_team_player` (`team_id`,`player_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `tournaments`
--
ALTER TABLE `tournaments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `tournament_budgets`
--
ALTER TABLE `tournament_budgets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tournament_id` (`tournament_id`);

--
-- Indexes for table `tournament_documents`
--
ALTER TABLE `tournament_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tournament` (`tournament_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `role_id` (`role_id`);

--
-- Indexes for table `user_districts`
--
ALTER TABLE `user_districts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_district` (`user_id`,`district_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_district` (`district_id`);

--
-- Indexes for table `venues`
--
ALTER TABLE `venues`
  ADD PRIMARY KEY (`id`),
  ADD KEY `district_id` (`district_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT for table `batting_stats`
--
ALTER TABLE `batting_stats`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bowling_stats`
--
ALTER TABLE `bowling_stats`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `coaches`
--
ALTER TABLE `coaches`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `coach_documents`
--
ALTER TABLE `coach_documents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `districts`
--
ALTER TABLE `districts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `fixtures`
--
ALTER TABLE `fixtures`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ledger_heads`
--
ALTER TABLE `ledger_heads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `live_matches`
--
ALTER TABLE `live_matches`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `match_scorecards`
--
ALTER TABLE `match_scorecards`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `officials`
--
ALTER TABLE `officials`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `official_certifications`
--
ALTER TABLE `official_certifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `official_types`
--
ALTER TABLE `official_types`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `payment_vouchers`
--
ALTER TABLE `payment_vouchers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `player_career_stats`
--
ALTER TABLE `player_career_stats`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `player_documents`
--
ALTER TABLE `player_documents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_otp_verifications`
--
ALTER TABLE `player_otp_verifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `teams`
--
ALTER TABLE `teams`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `team_coaches`
--
ALTER TABLE `team_coaches`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `team_documents`
--
ALTER TABLE `team_documents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `team_players`
--
ALTER TABLE `team_players`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `tournaments`
--
ALTER TABLE `tournaments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tournament_budgets`
--
ALTER TABLE `tournament_budgets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tournament_documents`
--
ALTER TABLE `tournament_documents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `user_districts`
--
ALTER TABLE `user_districts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `venues`
--
ALTER TABLE `venues`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `batting_stats`
--
ALTER TABLE `batting_stats`
  ADD CONSTRAINT `batting_stats_ibfk_1` FOREIGN KEY (`fixture_id`) REFERENCES `fixtures` (`id`),
  ADD CONSTRAINT `batting_stats_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`),
  ADD CONSTRAINT `batting_stats_ibfk_3` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`);

--
-- Constraints for table `bowling_stats`
--
ALTER TABLE `bowling_stats`
  ADD CONSTRAINT `bowling_stats_ibfk_1` FOREIGN KEY (`fixture_id`) REFERENCES `fixtures` (`id`),
  ADD CONSTRAINT `bowling_stats_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`),
  ADD CONSTRAINT `bowling_stats_ibfk_3` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`);

--
-- Constraints for table `coach_documents`
--
ALTER TABLE `coach_documents`
  ADD CONSTRAINT `fk_cd_coach` FOREIGN KEY (`coach_id`) REFERENCES `coaches` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `fixtures`
--
ALTER TABLE `fixtures`
  ADD CONSTRAINT `fixtures_ibfk_1` FOREIGN KEY (`tournament_id`) REFERENCES `tournaments` (`id`),
  ADD CONSTRAINT `fixtures_ibfk_2` FOREIGN KEY (`team_a_id`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `fixtures_ibfk_3` FOREIGN KEY (`team_b_id`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `fixtures_ibfk_4` FOREIGN KEY (`venue_id`) REFERENCES `venues` (`id`),
  ADD CONSTRAINT `fixtures_ibfk_5` FOREIGN KEY (`umpire1_id`) REFERENCES `officials` (`id`),
  ADD CONSTRAINT `fixtures_ibfk_6` FOREIGN KEY (`umpire2_id`) REFERENCES `officials` (`id`),
  ADD CONSTRAINT `fixtures_ibfk_7` FOREIGN KEY (`scorer_id`) REFERENCES `officials` (`id`),
  ADD CONSTRAINT `fixtures_ibfk_8` FOREIGN KEY (`referee_id`) REFERENCES `officials` (`id`);

--
-- Constraints for table `ledger_heads`
--
ALTER TABLE `ledger_heads`
  ADD CONSTRAINT `ledger_heads_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `account_groups` (`G_Name`);

--
-- Constraints for table `live_matches`
--
ALTER TABLE `live_matches`
  ADD CONSTRAINT `fk_lm_team_a` FOREIGN KEY (`team_a_id`) REFERENCES `teams` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_lm_team_b` FOREIGN KEY (`team_b_id`) REFERENCES `teams` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `match_scorecards`
--
ALTER TABLE `match_scorecards`
  ADD CONSTRAINT `match_scorecards_ibfk_1` FOREIGN KEY (`fixture_id`) REFERENCES `fixtures` (`id`),
  ADD CONSTRAINT `match_scorecards_ibfk_2` FOREIGN KEY (`player_of_match`) REFERENCES `players` (`id`);

--
-- Constraints for table `officials`
--
ALTER TABLE `officials`
  ADD CONSTRAINT `fk_off_district` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`),
  ADD CONSTRAINT `fk_off_regby` FOREIGN KEY (`registered_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_off_type` FOREIGN KEY (`official_type_id`) REFERENCES `official_types` (`id`),
  ADD CONSTRAINT `fk_off_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `official_certifications`
--
ALTER TABLE `official_certifications`
  ADD CONSTRAINT `official_certifications_ibfk_1` FOREIGN KEY (`official_id`) REFERENCES `officials` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `official_types`
--
ALTER TABLE `official_types`
  ADD CONSTRAINT `official_types_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Constraints for table `payment_vouchers`
--
ALTER TABLE `payment_vouchers`
  ADD CONSTRAINT `payment_vouchers_ibfk_1` FOREIGN KEY (`fixture_id`) REFERENCES `fixtures` (`id`),
  ADD CONSTRAINT `payment_vouchers_ibfk_2` FOREIGN KEY (`tournament_id`) REFERENCES `tournaments` (`id`),
  ADD CONSTRAINT `payment_vouchers_ibfk_3` FOREIGN KEY (`official_id`) REFERENCES `officials` (`id`),
  ADD CONSTRAINT `payment_vouchers_ibfk_4` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `payment_vouchers_ibfk_5` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`),
  ADD CONSTRAINT `players_ibfk_2` FOREIGN KEY (`registered_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `player_career_stats`
--
ALTER TABLE `player_career_stats`
  ADD CONSTRAINT `player_career_stats_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`);

--
-- Constraints for table `player_documents`
--
ALTER TABLE `player_documents`
  ADD CONSTRAINT `fk_pd_player` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `teams`
--
ALTER TABLE `teams`
  ADD CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`tournament_id`) REFERENCES `tournaments` (`id`),
  ADD CONSTRAINT `teams_ibfk_2` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`),
  ADD CONSTRAINT `teams_ibfk_3` FOREIGN KEY (`captain_id`) REFERENCES `players` (`id`),
  ADD CONSTRAINT `teams_ibfk_4` FOREIGN KEY (`vice_captain_id`) REFERENCES `players` (`id`);

--
-- Constraints for table `team_coaches`
--
ALTER TABLE `team_coaches`
  ADD CONSTRAINT `fk_tc_coach` FOREIGN KEY (`coach_id`) REFERENCES `coaches` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `team_documents`
--
ALTER TABLE `team_documents`
  ADD CONSTRAINT `fk_td_team` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `team_players`
--
ALTER TABLE `team_players`
  ADD CONSTRAINT `team_players_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `team_players_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`);

--
-- Constraints for table `tournaments`
--
ALTER TABLE `tournaments`
  ADD CONSTRAINT `tournaments_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `tournament_budgets`
--
ALTER TABLE `tournament_budgets`
  ADD CONSTRAINT `tournament_budgets_ibfk_1` FOREIGN KEY (`tournament_id`) REFERENCES `tournaments` (`id`);

--
-- Constraints for table `tournament_documents`
--
ALTER TABLE `tournament_documents`
  ADD CONSTRAINT `fk_trd_tournament` FOREIGN KEY (`tournament_id`) REFERENCES `tournaments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Constraints for table `user_districts`
--
ALTER TABLE `user_districts`
  ADD CONSTRAINT `fk_ud_district` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ud_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `venues`
--
ALTER TABLE `venues`
  ADD CONSTRAINT `venues_ibfk_1` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
