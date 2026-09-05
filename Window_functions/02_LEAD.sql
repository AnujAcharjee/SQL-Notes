USE sql_learning;

-- Goal: Find users who appear 3 or more times consecutively.
--
-- LEAD() looks at rows AFTER the current row.
--
-- For each login:
--   LEAD(user_name, 1) → next login
--   LEAD(user_name, 2) → login after the next one
--
-- If both of those users are the same as the current user,
-- then the same user appears in 3 consecutive rows.
--
-- Example:
--   Anuj → Anuj → Anuj
--    ↑       ↑       ↑
--  current  next   next+2
--
-- The inner query marks such rows as 'repeat'.
-- The outer query keeps only those rows and returns
-- DISTINCT user names so each user appears only once.

SELECT DISTINCT user_name
FROM (
    SELECT
        user_name,
        CASE
            WHEN user_name = LEAD(user_name, 1) OVER (ORDER BY login_id)
             AND user_name = LEAD(user_name, 2) OVER (ORDER BY login_id)
            THEN 'repeat'
            ELSE NULL
        END AS repeated_users
    FROM login_details
) AS x
WHERE x.repeated_users IS NOT NULL;