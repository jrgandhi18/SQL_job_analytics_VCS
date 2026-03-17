/*Answer: What are the top skills based on salary?
Look at the average salary associated with each skill for Data Analyst positions
Focuses on roles with specified salaries, regardless of location
Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve*/

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

/*
Here's  a  breakdown of the result for top paying skills
-High Demand for a Big Data & ML Skills:Top salaries
-Software Dev & Deployment Proficiency
-Cloud Computing Experties:Familiarity with cloud

[
  {
    "skills": "svn",
    "avg_sal": "400000"
  },
  {
    "skills": "solidity",
    "avg_sal": "179000"
  },
  {
    "skills": "couchbase",
    "avg_sal": "160515"
  },
  {
    "skills": "datarobot",
    "avg_sal": "155486"
  },
  {
    "skills": "golang",
    "avg_sal": "155000"
  },
  {
    "skills": "mxnet",
    "avg_sal": "149000"
  },
  {
    "skills": "dplyr",
    "avg_sal": "147633"
  },
  {
    "skills": "vmware",
    "avg_sal": "147500"
  },
  {
    "skills": "terraform",
    "avg_sal": "146734"
  },
  {
    "skills": "twilio",
    "avg_sal": "138500"
  },
  {
    "skills": "gitlab",
    "avg_sal": "134126"
  },
  {
    "skills": "kafka",
    "avg_sal": "129999"
  },
  {
    "skills": "puppet",
    "avg_sal": "129820"
  },
  {
    "skills": "keras",
    "avg_sal": "127013"
  },
  {
    "skills": "pytorch",
    "avg_sal": "125226"
  },
  {
    "skills": "perl",
    "avg_sal": "124686"
  },
  {
    "skills": "ansible",
    "avg_sal": "124370"
  },
  {
    "skills": "hugging face",
    "avg_sal": "123950"
  },
  {
    "skills": "tensorflow",
    "avg_sal": "120647"
  },
  {
    "skills": "cassandra",
    "avg_sal": "118407"
  },
  {
    "skills": "notion",
    "avg_sal": "118092"
  },
  {
    "skills": "atlassian",
    "avg_sal": "117966"
  },
  {
    "skills": "bitbucket",
    "avg_sal": "116712"
  },
  {
    "skills": "airflow",
    "avg_sal": "116387"
  },
  {
    "skills": "scala",
    "avg_sal": "115480"
  }
]
*/