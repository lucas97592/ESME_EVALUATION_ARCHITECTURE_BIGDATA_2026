USE DATABASE LINKEDIN;
USE SCHEMA BRONZE;
USE ROLE ACCOUNTADMIN;
 

CREATE TABLE IF NOT EXISTS LINKEDIN.BRONZE.JOB_POSTINGS (
    job_id STRING, company_name STRING, title STRING, description STRING,
    max_salary STRING, med_salary STRING, min_salary STRING, pay_period STRING,
    formatted_work_type STRING, location STRING, applies STRING,
    original_listed_time STRING, remote_allowed STRING, views STRING,
    job_posting_url STRING, application_url STRING, application_type STRING,
    expiry STRING, closed_time STRING, formatted_experience_level STRING,
    skills_desc STRING, listed_time STRING, posting_domain STRING,
    sponsored STRING, work_type STRING, currency STRING, compensation_type STRING
);
COPY INTO LINKEDIN.BRONZE.JOB_POSTINGS
FROM @linkedin_stage/job_postings.csv
FILE_FORMAT = (FORMAT_NAME = 'LINKEDIN.BRONZE.csv_format');
SELECT COUNT(*) FROM LINKEDIN.BRONZE.JOB_POSTINGS;
 

CREATE TABLE IF NOT EXISTS LINKEDIN.BRONZE.BENEFITS (
    job_id STRING, inferred STRING, type STRING
);
COPY INTO LINKEDIN.BRONZE.BENEFITS
FROM @linkedin_stage/benefits.csv
FILE_FORMAT = (FORMAT_NAME = 'LINKEDIN.BRONZE.csv_format');
SELECT COUNT(*) FROM LINKEDIN.BRONZE.BENEFITS;
 

CREATE TABLE IF NOT EXISTS LINKEDIN.BRONZE.EMPLOYEE_COUNTS (
    company_id STRING, employee_count STRING,
    follower_count STRING, time_recorded STRING
);
COPY INTO LINKEDIN.BRONZE.EMPLOYEE_COUNTS
FROM @linkedin_stage/employee_counts.csv
FILE_FORMAT = (FORMAT_NAME = 'LINKEDIN.BRONZE.csv_format');
SELECT COUNT(*) FROM LINKEDIN.BRONZE.EMPLOYEE_COUNTS;
 

CREATE TABLE IF NOT EXISTS LINKEDIN.BRONZE.JOB_SKILLS (
    job_id STRING, skill_abr STRING
);
COPY INTO LINKEDIN.BRONZE.JOB_SKILLS
FROM @linkedin_stage/job_skills.csv
FILE_FORMAT = (FORMAT_NAME = 'LINKEDIN.BRONZE.csv_format');
SELECT COUNT(*) FROM LINKEDIN.BRONZE.JOB_SKILLS;