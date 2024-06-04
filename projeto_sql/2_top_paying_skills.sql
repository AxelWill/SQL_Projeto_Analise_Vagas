/*
Quais habilidades são necessárias para as vagas com melhores salários de analista de dados?
-Usaremos como base a query 1, adicionando as habilidades necessárias para a vaga
-Isso nos dará uma uma boa ideia de quais vagas com alto salário requerem quais habilidades,
    ajudando pessoas procurando trabalho a saber quais habilidades aprimorar
*/

WITH top_paying_jobs AS(
SELECT
    job_id,
    company_dim.name AS company_name,
    job_title,
    salary_year_avg
FROM
    job_postings_fact
LEFT JOIN
    company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM skills_dim
LEFT JOIN skills_job_dim
ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN top_paying_jobs ON skills_job_dim.job_id = top_paying_jobs.job_id;

/*Agora, se quisermos ver quais competências pagam mais no brasil podemos fazer o seguinte*/

WITH top_paying_jobs AS(
SELECT
    job_id,
    company_dim.name AS company_name,
    job_title,
    salary_year_avg
FROM
    job_postings_fact
LEFT JOIN
    company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_location LIKE '%Brazil%'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM skills_dim
LEFT JOIN skills_job_dim
ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN top_paying_jobs ON skills_job_dim.job_id = top_paying_jobs.job_id


--Vemos rapidamente que SQL continua aparecendo muito, além de python
