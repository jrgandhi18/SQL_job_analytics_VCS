/*Most in demand skills for my role*/

/* Most in-demand skills for Remote Data Analyst roles */

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