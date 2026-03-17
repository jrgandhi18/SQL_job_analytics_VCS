/*Question:
Write a SQL query to find all job postings from the first quarter (January, February, and March) that offer an average yearly salary greater than $70,000.

Requirements:

Combine the data from three separate tables: january_jobs, february_jobs, and march_jobs using a set operator.

Filter the results to only include rows where the salary_year_avg is more than 70,000.

Use a CTE to keep the code organized.*/
 With firstquater AS (
    select *
    From january_jobs
    UNION all
    select *
    From february_jobs
    UNION ALL
    select *
    From march_jobs
 )
SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::Date,
    salary_year_avg
From firstquater
where
    salary_year_avg > 70000 AND job_title_short ='Data Analyst'
ORDER BY salary_year_avg desc;