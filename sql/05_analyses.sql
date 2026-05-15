
WITH ranked AS (
    SELECT industry, title, COUNT(*) AS nb_offres,
        RANK() OVER (PARTITION BY industry ORDER BY COUNT(*) DESC) AS rnk
    FROM LINKEDIN.GOLD.FACT_JOB_INDUSTRY
    WHERE industry IS NOT NULL
    GROUP BY industry, title
)
SELECT industry, title, nb_offres
FROM ranked WHERE rnk <= 10
ORDER BY industry, rnk;

WITH ranked_salary AS (
    SELECT industry, title,
        ROUND(AVG(max_salary), 0) AS avg_max_salary,
        RANK() OVER (PARTITION BY industry ORDER BY AVG(max_salary) DESC) AS rnk
    FROM LINKEDIN.GOLD.FACT_JOB_INDUSTRY
    WHERE industry IS NOT NULL
      AND max_salary IS NOT NULL
      AND pay_period = 'YEARLY'
    GROUP BY industry, title
)
SELECT industry, title, avg_max_salary
FROM ranked_salary WHERE rnk <= 10
ORDER BY industry, rnk;