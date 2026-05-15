USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE LINKEDIN;

CREATE SCHEMA IF NOT EXISTS LINKEDIN.SILVER;
 

CREATE OR REPLACE TABLE LINKEDIN.SILVER.JOB_POSTINGS AS
SELECT
    job_id::INT AS job_id,
    company_name,
    title,
    description,
    TRY_TO_DOUBLE(max_salary) AS max_salary,
    TRY_TO_DOUBLE(med_salary) AS med_salary,
    TRY_TO_DOUBLE(min_salary) AS min_salary,
    pay_period,
    formatted_work_type,
    location,
    TRY_TO_NUMBER(applies) AS applies,
 
    TO_TIMESTAMP_NTZ(original_listed_time / 1000) AS original_listed_time,
 
    CASE WHEN UPPER(remote_allowed) IN ('1','TRUE','YES') THEN TRUE ELSE FALSE END AS remote_allowed,
    TRY_TO_NUMBER(views) AS views,
    job_posting_url,
    application_url,
    application_type,
 
    TO_TIMESTAMP_NTZ(expiry / 1000) AS expiry,
    TO_TIMESTAMP_NTZ(closed_time / 1000) AS closed_time,
    formatted_experience_level,
    skills_desc,
 
    TO_TIMESTAMP_NTZ(listed_time / 1000) AS listed_time,
 
    posting_domain,
    CASE WHEN UPPER(sponsored) IN ('1','TRUE','YES') THEN TRUE ELSE FALSE END AS sponsored,
    work_type,
    currency,
    compensation_type
FROM LINKEDIN.BRONZE.JOB_POSTINGS;
 
CREATE OR REPLACE TABLE LINKEDIN.SILVER.COMPANIES AS
SELECT
    data:company_id::INT AS company_id,
    data:name::STRING AS company_name,
    data:description::STRING AS description,
    data:company_size::INT AS company_size,
    data:state::STRING AS state,
    data:country::STRING AS country,
    data:city::STRING AS city,
    data:zip_code::STRING AS zip_code,
    data:address::STRING AS address,
    data:url::STRING AS url
FROM LINKEDIN.BRONZE.COMPANIES;
 
-- EMPLOYEE_COUNTS
CREATE OR REPLACE TABLE LINKEDIN.SILVER.EMPLOYEE_COUNTS AS
SELECT
    company_id::INT AS company_id,
    TRY_TO_NUMBER(employee_count) AS employee_count,
    TRY_TO_NUMBER(follower_count) AS follower_count,
    TO_TIMESTAMP(TRY_TO_NUMBER(time_recorded)) AS time_recorded
FROM LINKEDIN.BRONZE.EMPLOYEE_COUNTS;
 

CREATE OR REPLACE TABLE LINKEDIN.SILVER.JOB_INDUSTRIES AS
SELECT
    data:job_id::INT AS job_id,
    data:industry_id::INT AS industry_id
FROM LINKEDIN.BRONZE.JOB_INDUSTRIES;
 

CREATE OR REPLACE TABLE LINKEDIN.SILVER.COMPANY_INDUSTRIES AS
SELECT
    data:company_id::INT AS company_id,
    data:industry::STRING AS industry
FROM LINKEDIN.BRONZE.COMPANY_INDUSTRIES;
 

CREATE OR REPLACE TABLE LINKEDIN.SILVER.JOB_SKILLS AS
SELECT job_id::INT AS job_id, skill_abr
FROM LINKEDIN.BRONZE.JOB_SKILLS;
 

CREATE OR REPLACE TABLE LINKEDIN.SILVER.BENEFITS AS
SELECT
    job_id::INT AS job_id,
    CASE WHEN UPPER(inferred) IN ('1','TRUE') THEN TRUE ELSE FALSE END AS inferred,
    type AS benefit_type
FROM LINKEDIN.BRONZE.BENEFITS;
 