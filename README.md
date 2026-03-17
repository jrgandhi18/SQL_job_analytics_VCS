# Introduction
Dive into the data job market! Focusing on data analyst roles, this project explores & top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.
SQL queries? Check them out here: [project_sql folder](/project_sql/)
# background 
Driven by a quest to navigate the data analyst job market more effectively, this project was born fron a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.
 It's picked with insights on job titles, salaries, locations, and essential skills.
## The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?

2. What skills are required for these top-paying jobs?

3. What skills are most in demand for data analysts?

4. Which skills are associated with higher salaries?

5. What are the most optimal skills to learn?
# Tools I used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

**SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.

**PostgreSQL**: The chosen database management system, ideal for handling the job posting data.

**Visual Studio Code**: My go-to for database management and executing SQL queries.

**Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking. 
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.
```
 SELECT
  jpf.job_id,
  jpf.job_title,
  jpf.job_title_short,
  jpf.job_location,
  jpf.job_schedule_type,
  jpf.salary_year_avg,
  jpf.job_posted_date,
  cd.name

FROM
  job_postings_fact jpf
LEFT JOIN company_dim cd
ON jpf.company_id=cd.company_id
WHERE
  jpf.job_title_short ='Data Analyst' AND jpf.job_location='Anywhere' AND jpf.salary_year_avg IS NOT NULL
ORDER BY jpf.salary_year_avg DESC
LIMIT 10;
```
### 2. Skills for Top Paying Jobs
To understand what it takes to land a high-paying role, I joined the top 10 jobs from the previous query with the skills table. This reveals the specific technical requirements that top-tier companies are looking for in candidates.
```
WITH high_paying_jobs AS( SELECT
  jpf.job_id,
  jpf.job_title,
  jpf.job_title_short,
  jpf.job_location,
  jpf.job_schedule_type,
  jpf.salary_year_avg,
  jpf.job_posted_date,
  cd.name

FROM
  job_postings_fact jpf
LEFT JOIN company_dim cd
ON jpf.company_id=cd.company_id
WHERE
  jpf.job_title_short ='Data Analyst' AND jpf.job_location='Anywhere' AND jpf.salary_year_avg IS NOT NULL
ORDER BY jpf.salary_year_avg DESC
LIMIT 10
)
SELECT hpj.*,sd.skills

FROM high_paying_jobs hpj
INNER JOIN skills_job_dim sjd  
ON hpj.job_id = sjd.job_id
INNER JOIN 
skills_dim sd 
ON sjd.skill_id=sd.skill_id
ORDER BY hpj.salary_year_avg DESC;
```
### 3. In-Demand Skills
I analyzed the frequency of skills across all Data Analyst job postings to identify the most common requirements. This helps in understanding the baseline tools (like SQL and Excel) that every analyst must master to stay competitive.
```
WITH remote_job_skills AS ( 
  SELECT
    skill_id,
    COUNT(*) AS skill_count
  FROM
    skills_job_dim AS sjd
  INNER JOIN job_postings_fact AS jpf ON sjd.job_id = jpf.job_id -- Connection point
  WHERE
    jpf.job_work_from_home = TRUE 
    AND jpf.job_title_short = 'Data Analyst'
  GROUP BY
    skill_id
)

SELECT
  sd.skill_id,
  sd.skills,
  rjs.skill_count
FROM 
  remote_job_skills AS rjs
INNER JOIN skills_dim AS sd ON rjs.skill_id = sd.skill_id
ORDER BY 
  rjs.skill_count DESC
LIMIT 5;
```
### 4. Skills Based on Salary
By calculating the average salary for each skill, I identified which technical abilities have the highest market value. This separates the "common" skills from the "premium" ones like Big Data and Cloud technologies.
```
SELECT
  skills,
  ROUND(AVG(salary_year_avg),0) AS avg_sal
FROM job_postings_fact

INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_title_short='Data Analyst' AND salary_year_avg IS NOT NULL --job_work_from_home=TRUE--
GROUP BY
  skills
ORDER BY
  avg_sal DESC
LIMIT 25;
```
### 5. Optimal Skills (High Demand + High Salary)
This final analysis finds the "sweet spot" by combining demand and salary data. It identifies the skills that are not only high-paying but also have a high volume of job openings, offering the best career ROI for a Data Analyst.
```
WITH skills_demand AS (
    SELECT
        skills,
        skills_dim.skill_id,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL 
        AND job_work_from_home = TRUE  -- 
    GROUP BY
        skills_dim.skill_id, 
        skills          
), 

average_salary AS (
    SELECT
        skills,
        skills_dim.skill_id,       
        ROUND(AVG(salary_year_avg), 0) AS avg_sal
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL 
        AND job_work_from_home = TRUE  -- 
    GROUP BY
        skills_dim.skill_id,
        skills           
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,             
    demand_count,
    avg_sal
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id;
```
# What I Learned
Throughout this project, I didn't just sharpen my SQL skills; I gained a deep understanding of the data analyst job market:

SQL is the Foundation: The analysis clearly showed that SQL remains the most critical and mandatory skill. It appeared in the vast majority of high-paying job postings.

The "Premium" Skill Gap: While Python and Excel are common, roles reaching the $200k+ salary bracket specifically demand expertise in PySpark, Databricks, and Big Data technologies.

Remote Work is Lucrative: A significant portion of the top-paying jobs identified were remote, highlighting that high-end analytical roles are increasingly location-independent.

Advanced Querying Techniques: Mastering CTEs (Common Table Expressions) and complex Joins allowed me to transform raw, unstructured data into actionable business insights.
# Conclusion
The final takeaway from this project is that becoming a top-tier Data Analyst requires more than just basic tools. To enter the top 10% salary bracket, an "Optimal Stack" should include:

Core Proficiency: Advanced SQL and Python.

Visualization: Tableau or Power BI.

The Competitive Edge: Cloud platforms (AWS/Azure) and Big Data processing tools.

This project serves as a cornerstone of my portfolio, demonstrating my ability to not only write code but to solve real-world business problems using data-driven insights.