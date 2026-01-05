/* =====================================================
   A/B Testing Project – SQL Data Cleaning & Analysis
   ===================================================== */

-- A/B Testing Data Preparation Script
-- Objective: Create a clean, experiment-valid dataset
-- Steps:
-- 1. Join ab_data with country mapping
-- 2. Remove duplicate users
-- 3. Remove mismatched group-page assignments
-- 4. Export final dataset for statistical analysis


select * from ab_data;

ALTER TABLE ab_data
RENAME COLUMN timestamp TO session_duration;

-- Step 1: Inspect raw experiment data
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT user_id) AS unique_users
FROM ab_data;


-- Step 2: Join experiment data with country information
CREATE TABLE ab_final AS
SELECT
    a.user_id,
    a.session_duration,
    a.user_group,
    a.landing_page,
    a.converted,
    c.country
FROM ab_data a
JOIN countries_raw c
ON a.user_id = c.user_id;


-- Step 3: Remove duplicate users
-- A/B testing requires one observation per user
DELETE FROM ab_final
WHERE user_id NOT IN (
    SELECT user_id
    FROM (
        SELECT user_id
        FROM ab_final
        GROUP BY user_id
        HAVING COUNT(*) = 1
    ) t
);


-- Step 4: Validate incorrect group–page assignments
SELECT COUNT(*) AS invalid_rows
FROM ab_final
WHERE
(user_group = 'control' AND landing_page = 'new_page')
OR
(user_group = 'treatment' AND landing_page = 'old_page');


-- Step 5: Remove mismatched group–page rows
DELETE FROM ab_final
WHERE NOT (
    (user_group = 'control' AND landing_page = 'old_page')
 OR (user_group = 'treatment' AND landing_page = 'new_page')
);


-- Step 6: Overall conversion metrics
SELECT
    user_group,
    landing_page,
    COUNT(*) AS users,
    SUM(converted) AS conversions,
    ROUND(AVG(converted), 4) AS conversion_rate
FROM ab_final
GROUP BY user_group, landing_page;


-- Step 7: Country-level conversion analysis
SELECT
    country,
    user_group,
    landing_page,
    COUNT(*) AS users,
    SUM(converted) AS conversions,
    ROUND(AVG(converted), 4) AS conversion_rate
FROM ab_final
GROUP BY country, user_group, landing_page
ORDER BY country;


-- Step 8: Data quality checks (NULL validation)
SELECT
    SUM(user_id IS NULL) AS null_user_id,
    SUM(user_group IS NULL) AS null_group,
    SUM(landing_page IS NULL) AS null_page,
    SUM(converted IS NULL) AS null_converted,
    SUM(country IS NULL) AS null_country
FROM ab_final;


-- Step 9: Validate binary nature of conversion
SELECT DISTINCT converted
FROM ab_final;




-- Step 10: EXPORT the CSV file
SELECT
    user_id,
    session_duration,
    user_group,
    landing_page,
    CAST(converted AS UNSIGNED) AS converted,
    country
FROM ab_final
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ab_final.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';





