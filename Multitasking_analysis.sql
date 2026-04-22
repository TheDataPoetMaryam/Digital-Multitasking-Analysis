-- =========================================
-- DATABASE SETUP
-- =========================================
CREATE DATABASE student_data;
USE student_data;

-- =========================================
-- CHECK ORIGINAL DATA
-- =========================================
SELECT * FROM `fp sem2 cleaned` LIMIT 10;
SELECT COUNT(*) FROM `fp sem2 cleaned`;

-- Rename table
RENAME TABLE `fp sem2 cleaned` TO fp_sem2_clean;

-- =========================================
-- STRUCTURE CHECK
-- =========================================
DESCRIBE fp_sem2_clean;

-- Fix column name
ALTER TABLE fp_sem2_clean
CHANGE `Age group` age_group VARCHAR(20);

-- =========================================
-- TIMESTAMP CLEANING
-- =========================================

ALTER TABLE fp_sem2_clean
ADD COLUMN submit_time DATETIME;

SET SQL_SAFE_UPDATES = 0;

UPDATE fp_sem2_clean
SET submit_time = STR_TO_DATE(`ï»¿Timestamp`, '%d-%m-%Y %H:%i');

-- =========================================
-- START TIME CLEANING
-- =========================================

ALTER TABLE fp_sem2_clean
ADD COLUMN start_time_clean TIME;

-- Remove AM/PM and fix formatting
UPDATE fp_sem2_clean
SET `Start time` = REPLACE(`Start time`, ' PM', '');

UPDATE fp_sem2_clean
SET `Start time` = REPLACE(`Start time`, ' AM', '');

UPDATE fp_sem2_clean
SET `Start time` = REPLACE(`Start time`, '.', ':');

UPDATE fp_sem2_clean
SET `Start time` = TRIM(`Start time`);

-- Convert to TIME
UPDATE fp_sem2_clean
SET start_time_clean = STR_TO_DATE(`Start time`, '%H:%i');

-- Adjust PM manually
UPDATE fp_sem2_clean
SET start_time_clean = ADDTIME(start_time_clean, '12:00:00')
WHERE start_time_clean < '12:00:00';

-- =========================================
-- TIME DIFFERENCE CALCULATION
-- =========================================

ALTER TABLE fp_sem2_clean
ADD COLUMN time_taken INT;

UPDATE fp_sem2_clean
SET time_taken =
TIMESTAMPDIFF(
    MINUTE,
    start_time_clean,
    TIME(submit_time)
);

-- Fix midnight crossover cases
UPDATE fp_sem2_clean
SET time_taken =
CASE
    WHEN TIME(submit_time) < start_time_clean
    THEN TIMESTAMPDIFF(
        MINUTE,
        start_time_clean,
        ADDTIME(TIME(submit_time), '24:00:00')
    )
    ELSE TIMESTAMPDIFF(
        MINUTE,
        start_time_clean,
        TIME(submit_time)
    )
END;

-- =========================================
-- DATA VALIDATION
-- =========================================

-- Missing values
SELECT *
FROM fp_sem2_clean
WHERE score IS NULL OR time_taken IS NULL;

-- Invalid durations
SELECT *
FROM fp_sem2_clean
WHERE time_taken < 1 OR time_taken > 30;

-- =========================================
-- FIX ENCODING ISSUES
-- =========================================

UPDATE fp_sem2_clean
SET age_group = '20 - 22'
WHERE TRIM(age_group) = '20Ã¢â‚¬â€œ22';

UPDATE fp_sem2_clean
SET age_group = '23 - 25'
WHERE TRIM(age_group) = '24Ã¢â‚¬â€œ25';

-- =========================================
-- BASIC ANALYSIS CHECKS
-- =========================================

SELECT background_media, COUNT(*)
FROM fp_sem2_clean
GROUP BY background_media;

SELECT COUNT(*) AS total_responses
FROM fp_sem2_clean;

-- Final preview
SELECT * FROM fp_sem2_clean;