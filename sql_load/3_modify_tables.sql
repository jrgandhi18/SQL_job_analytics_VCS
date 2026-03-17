/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
 Database Load Issues (follow if receiving permission denied when running SQL code below)
 
 NOTE: If you are having issues with permissions. And you get error: 
 
 'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'
 
 1. Open pgAdmin
 2. In Object Explorer (left-hand pane), navigate to `sql_course` database
 3. Right-click `sql_course` and select `PSQL Tool`
 - This opens a terminal window to write the following code
 4. Get the absolute file path of your csv files
 1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
 5. Paste the following into `PSQL Tool`, (with the CORRECT file path)
 
 \copy company_dim FROM '[Insert File Path]/company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
 
 \copy skills_dim FROM '[Insert File Path]/skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
 
 \copy job_postings_fact FROM '[Insert File Path]/job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
 
 \copy skills_job_dim FROM '[Insert File Path]/skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
 
 */
-- NOTE: This has been updated from the video to fix issues with encoding
COPY company_dim
FROM 'C:\Codeplayground\DATASCIENCE\SQL_vsc\csv_files\company_dim.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );
COPY skills_dim
FROM 'C:\Codeplayground\DATASCIENCE\SQL_VCS\csv_files\skills_dim.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );
COPY job_postings_fact
FROM 'C:\Codeplayground\DATASCIENCE\SQL_VCS\csv_files\job_postings_fact.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );
COPY skills_job_dim
FROM 'C:\Codeplayground\DATASCIENCE\SQL_VCS\csv_files\skills_job_dim.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );
SELECT job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE as date
FROM job_postings_fact;
SELECT job_title_short AS title,
    job_location AS location,
    job_posted_date as date
FROM job_postings_fact;
SELECT job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' as date
FROM job_postings_fact
LIMIT 10;
SELECT COUNT(job_id) AS job_posted_times,
    EXTRACT(
        MONTH
        FROM job_posted_date
    ) AS DATE_Month
from job_postings_fact
GROUP BY DATE_Month
ORDER BY job_posted_times DESC;
SELECT *
FROM job_postings_fact
LIMIT 10;
SELECT job_schedule_type,
    AVG(salary_year_avg) as Year_avg,
    AVG(salary_hour_avg) as Hourly_avg
FROM job_postings_fact
WHERE job_posted_date > '2023-06-01'
GROUP BY job_schedule_type;
SELECT EXTRACT(
        MONTH
        FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York'
    ) AS MONTH,
    COUNT(job_id) as post_counts
FROM job_postings_fact
GROUP BY MONTH
ORDER BY MONTH;
SELECT cd.name
FROM job_postings_fact jpf
    JOIN company_dim cd ON jpf.company_id = cd.company_id
WHERE jpf.job_health_insurance IS TRUE
    AND EXTRACT(
        QUARTER
        FROM jpf.job_posted_date
    ) = 2
    AND EXTRACT(
        YEAR
        FROM jpf.job_posted_date
    ) = 2023
GROUP BY cd.name;
-- January
CREATE TABLE january_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(
        MONTH
        FROM job_posted_date
    ) = 1;
-- February
CREATE TABLE february_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(
        MONTH
        FROM job_posted_date
    ) = 2;
-- March
CREATE TABLE march_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(
        MONTH
        FROM job_posted_date
    ) = 3;
select job_posted_date
from march_jobs;
SELECT COUNT(job_id) as number_of_postings,
    AVG(salary_year_avg) as avg_sal,
    CASE
        WHEN job_location = 'Anywhere' Then 'Remote'
        when job_location = 'Denver, CO' Then 'Local'
        Else 'On-Site'
    End As location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
    And salary_year_avg IS NOT NULL
GROUP BY location_category;



SELECT MAX(salary_year_avg)
FROM job_postings_fact
WHERE salary_year_avg>(select AVG(salary_year_avg)
From job_postings_fact
WHERE job_title_short='Data Analyst'
);


WITH january__jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=1

)
SELECT *
From january__jobs;


SELECT name AS company_name
From company_dim
WHERE company_id In(
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = true
    ORDER BY company_id
);


With jobs_NY AS(
    SELECT *
    FROM job_postings_fact
    WHERE job_location LIKE '%York%'
)
select * 
From jobs_NY;



With company_job_count AS(
    SELECt company_id,
    COUNT(*) as total_jobs
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT company_dim.name AS company_name,
company_job_count.total_jobs
FROM company_dim
left join company_job_count
ON company_job_count.company_id =company_dim.company_id
ORDER BY total_jobs DESC;


With skill_dekho AS(
    select skill_id, COUNT(*) as counts_id

    FROM skills_job_dim
    GROUP BY skill_id
    ORDER by counts_id DESC
    LIMIT 5
)
SELECT sdd.skills,
sd.counts_id
FROM skill_dekho sd
inner join skills_dim sdd
ON sd.skill_id=sdd.skill_id
;


With company_job_count as(
    select company_id,
    Count(*) AS total_job
    From job_postings_fact
    GROUP BY company_id
    
)
select company_id,

    total_job,
    CASE
     WHEN total_job < 10 Then 'Small'
     WHEN total_job between 10 AND 50 then 'Medium'
     Else 'Large'
    End AS Company_size
FROM company_job_count; 



/* Find the count of the number of remote job postings per skill
-Display the top 5 skills by their demands in remote jobs -Include skills ID, name  and count of postings requiring the skill */
WITH remote_job_skills AS (
    SELECT 
        skill_id,
        COUNT(*) AS skill_count
    FROM 
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings 
        ON skills_to_job.job_id = job_postings.job_id
    WHERE 
        job_postings.job_work_from_home = True
    GROUP BY 
        skill_id
)

SELECT 
    skills.skill_id,
    skills.skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills 
    ON skills.skill_id = remote_job_skills.skill_id
ORDER BY 
    skill_count DESC
LIMIT 5;


/*union*/

SELECT job_id, job_title_short,job_schedule_type
FROM january_jobs

UNION ALL
SELECT job_id,job_title_short,job_schedule_type
From february_jobs;



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