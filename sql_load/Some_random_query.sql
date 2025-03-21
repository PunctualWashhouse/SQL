CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

SELECT *
FROM job_applied;

INSERT INTO job_applied (
    job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status
)
VALUES
    (1, '2024-02-01', TRUE, 'resume1.pdf', TRUE, 'cover_letter1.pdf', 'pending'),
    (2, '2024-02-02', FALSE, 'RESUME_02.PDF', FALSE, 'NULL', 'interview scheduled'),
    (3, '2024-02-03', TRUE, 'resume3.pdf', TRUE, 'cover_letter3.pdf', 'ghosted'),
    (4, '2024-02-04', TRUE, 'resume4.pdf', FALSE, 'NULL', 'submitted'),
    (5, '2024-02-05', TRUE, 'resume5.pdf', TRUE, 'cover_letter5.pdf', 'rejected');

ALTER TABLE job_applied
ADD contact VARCHAR(50);

UPDATE job_applied
SET    contact = 'Erlich Bachman'
WHERE  job_id = 1;

UPDATE job_applied
SET    contact = 'Dinesh Chugtai'
WHERE  job_id = 2;

UPDATE job_applied
SET    contact = 'Bertram Gilfoyle'
WHERE  job_id = 3;

UPDATE job_applied
SET    contact = 'Jian Yang'
WHERE  job_id = 4;

UPDATE job_applied
SET    contact = 'Big Head'
WHERE  job_id = 5;

ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT

ALTER TABLE job_applied
DROP COLUMN contact_name;

-- Itt sok minden nincs meg sajnos
____________________________________________________
CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT job_posted_date
FROM march_jobs

____________________________________________________
-- CASE expressions --

SELECT
	CASE
		WHEN column_name = 'Value1' THEN 'value1 leírása'
        WHEN column_name = 'Value1' THEN 'value1 leírása'
		ELSE 'Other'
	END AS column_description
FROM táblanév;
PÉLDA:
SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY
    location_category

____________________________________________________
-- Subqueries and CTEs --

SELECT *
FROM (
	SELECT *
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 4
) AS january_jobs;
De miért kell elé meg után ez a cucc?

____________________________________________________
WITH january_jobs AS (
	SELECT *
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT *
FROM january_jobs;

____________________________________________________
SELECT
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = true
    ORDER BY
        company_id
)

____________________________________________________
WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM    job_postings_fact
    GROUP BY
        company_id)

SELECT company_dim.name as company_name,
company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC

____________________________________________________
/*
Find the count of the number of remote job postings per skill
    - Display the top 5 skills by their demand in remote jobs
    - Include skill ID, name, and count of postings requiring the skill
    - -- in case of data analyst jobs
*/
WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = True AND
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5

____________________________________________________
-- UNION & UNION ALL queries --

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs

____________________________________________________
/*
Find job postings from the first quarter that hava a salary greater than $70K
    - Combine job posting tables from the first quarter of 2023 (Jan-Mar)
    - Get job postings with an average yearly salary > $70,000
*/

SELECT
    quarter1_job_postings.job_title_short, -- a honnant elvileg nem KELL itt definiálni (q1...)
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::DATE,
    salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
WHERE
    quarter1_job_postings.salary_year_avg > 70000
ORDER BY
    quarter1_job_postings.salary_year_avg DESC

____________________________________________________
-- PROJECT SECTION (2:58:25) --

-- In other .sql files.