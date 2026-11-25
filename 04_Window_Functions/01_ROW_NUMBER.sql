USE sql_learning;

-- Goal:
-- Find users whose user_name appears more than once.
--
-- Approach:
-- 1. PARTITION BY user_name → put identical names into the same group.
-- 2. ROW_NUMBER()            → number each row inside that group.
-- 3. row_num > 1             → identifies the duplicate occurrences.
--
-- Example:
-- If 'Anuj' appears 3 times:
--
-- user_name | user_id | row_num
-- ----------|---------|--------
-- Anuj      | 1       | 1       ← first occurrence
-- Anuj      | 4       | 2       ← duplicate
-- Anuj      | 8       | 3       ← duplicate


-- Step 1: Number rows within each user_name group
SELECT *,
	ROW_NUMBER() OVER (
		PARTITION BY user_name
		ORDER BY user_id
	) AS row_num
FROM users
ORDER BY user_id;


-- Step 2: Fetch only the duplicate rows
-- A row_num of 1 = first occurrence → NOT a duplicate.
-- A row_num greater than 1 = subsequent occurrence → DUPLICATE.
--
-- The subquery is required because we cannot directly use
-- the window-function result (row_num) in the WHERE clause
-- at the same query level.
--
-- The outer query filters the numbered result.


USE sql_learning;

SELECT *
FROM (
		SELECT *,
			ROW_NUMBER() OVER (
				PARTITION BY user_name
				ORDER BY user_id
			) AS row_num
		FROM users
	) AS x
WHERE x.row_num > 1;