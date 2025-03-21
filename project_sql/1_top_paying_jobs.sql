/*
Top paying data analyst jobs?
- collecting top 10 remote,
- eliminate those without salary,
- company names of these jobs,
...so that we can see the best opportunities as a data analyst.
*/

-- TOP 10 data analyst jobs with company name by salary in descending order --
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10

-- Hungarian jobs by salary in descending order --
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_location LIKE '%Hungary%' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC