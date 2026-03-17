
/* Goal: Find the "Optimal" skills (High Demand + High Salary)
-Totally Remote jobs*/
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