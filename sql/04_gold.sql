CREATE SCHEMA IF NOT EXISTS LINKEDIN.GOLD;

-- DIMENSION taille entreprise
CREATE OR REPLACE TABLE LINKEDIN.GOLD.DIM_COMPANY_SIZE AS
SELECT column1 AS size_code, column2 AS size_label
FROM VALUES
    (0,'Self-employed'),
    (1,'1-10 employés'),
    (2,'11-50 employés'),
    (3,'51-200 employés'),
    (4,'201-500 employés'),
    (5,'501-1 000 employés'),
    (6,'1 001-5 000 employés'),
    (7,'5 001+ employés');


-- FACT JOB POSTINGS (version SAFE)
CREATE OR REPLACE TABLE LINKEDIN.GOLD.FACT_JOB_POSTINGS AS
SELECT
    jp.job_id,
    jp.title,
    jp.company_name,
    jp.formatted_work_type,
    jp.location,

    jp.min_salary,
    jp.med_salary,
    jp.max_salary,
    jp.pay_period,

    jp.remote_allowed,
    jp.listed_time,

    c.company_id,
    c.company_size,

    NVL(cs.size_label, 'Inconnu') AS company_size_label,

    c.country,
    c.city

FROM LINKEDIN.SILVER.JOB_POSTINGS jp

LEFT JOIN LINKEDIN.SILVER.COMPANIES c
    ON UPPER(jp.company_name) = UPPER(c.company_name)

LEFT JOIN LINKEDIN.GOLD.DIM_COMPANY_SIZE cs
    ON c.company_size = cs.size_code;


-- CHECK
SELECT COUNT(*) FROM LINKEDIN.GOLD.FACT_JOB_POSTINGS;


-- FACT JOB + INDUSTRY (CORRIGÉE)
CREATE OR REPLACE VIEW LINKEDIN.GOLD.FACT_JOB_INDUSTRY AS
SELECT
    jp.job_id,
    jp.title,
    jp.company_name,
    jp.formatted_work_type,
    jp.max_salary,
    jp.med_salary,
    jp.min_salary,
    jp.pay_period,

    ci.industry

FROM LINKEDIN.SILVER.JOB_POSTINGS jp

LEFT JOIN LINKEDIN.SILVER.JOB_INDUSTRIES ji
    ON jp.job_id = ji.job_id

LEFT JOIN LINKEDIN.SILVER.COMPANY_INDUSTRIES ci
    ON jp.company_name IS NOT NULL;  
