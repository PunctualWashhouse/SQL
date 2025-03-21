/*
What are the top skills based on salary?
- avg salary for data analyst jobs,
- any roles or location
...to reveal how different skills impact salary, and identify the most rewarding skills to learn.
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
   AND job_location = 'Anywhere' -- job_work_from_home = True would be the same(?)
GROUP BY
    skills
ORDER BY avg_salary DESC
LIMIT 25;