-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 03, 2024 at 12:31 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `protomo_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `completedfocus_tb`
--

CREATE TABLE `completedfocus_tb` (
  `focus_id` varchar(8) NOT NULL,
  `focus_duration` int(20) NOT NULL,
  `date_completed` date NOT NULL,
  `day_completed` varchar(10) NOT NULL,
  `week_completed` varchar(10) NOT NULL,
  `month_completed` varchar(10) NOT NULL,
  `year_completed` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `completedtasks_tb`
--

CREATE TABLE `completedtasks_tb` (
  `task_id` varchar(8) NOT NULL,
  `task_name` varchar(20) NOT NULL,
  `date_completed` date NOT NULL,
  `day_completed` varchar(10) NOT NULL,
  `week_completed` varchar(10) NOT NULL,
  `month_completed` varchar(10) NOT NULL,
  `year_completed` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_tb`
--

CREATE TABLE `inventory_tb` (
  `item_id` varchar(8) NOT NULL,
  `name` varchar(20) NOT NULL,
  `type` varchar(20) NOT NULL,
  `rep` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_tb`
--

INSERT INTO `inventory_tb` (`item_id`, `name`, `type`, `rep`, `quantity`) VALUES
('1', 'food1', 'food', 2, 0),
('2', 'food2', 'food', 5, 0),
('3', 'meds1', 'meds', 2, 0),
('4', 'meds2', 'meds', 5, 0),
('5', 'skin1', 'skin', NULL, 0),
('6', 'skin2', 'skin', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `shop_tb`
--

CREATE TABLE `shop_tb` (
  `item_id` varchar(8) NOT NULL,
  `name` varchar(20) NOT NULL,
  `type` varchar(20) NOT NULL,
  `rep` int(11) DEFAULT NULL,
  `availability` tinyint(1) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shop_tb`
--

INSERT INTO `shop_tb` (`item_id`, `name`, `type`, `rep`, `availability`, `price`) VALUES
('1', 'food1', 'food', 2, 1, 10),
('2', 'food2', 'food', 5, 1, 25),
('3', 'meds1', 'meds', 2, 1, 10),
('4', 'meds2', 'meds', 5, 1, 25),
('5', 'skin1', 'skin', NULL, 1, 100),
('6', 'skin2', 'skin', NULL, 1, 200);

-- --------------------------------------------------------

--
-- Table structure for table `tasks_tb`
--

CREATE TABLE `tasks_tb` (
  `task_id` varchar(8) NOT NULL,
  `task_name` varchar(20) NOT NULL,
  `date_entered` date NOT NULL,
  `assigned_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tomo_creds`
--

CREATE TABLE `tomo_creds` (
  `tomo_id` int(4) NOT NULL,
  `tomo_name` varchar(20) NOT NULL,
  `birth_date` date NOT NULL,
  `death_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `inventory_tb`
--
ALTER TABLE `inventory_tb`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `shop_tb`
--
ALTER TABLE `shop_tb`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `tasks_tb`
--
ALTER TABLE `tasks_tb`
  ADD PRIMARY KEY (`task_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
