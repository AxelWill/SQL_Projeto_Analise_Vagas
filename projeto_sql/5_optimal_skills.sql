/*Antes de decidir qual é a melhor habilidade para aprender, devemos levar em conta ambas a demanda e o salario
*/ 

SELECT
    sk.skills,
    COUNT(skjb.job_id) AS demand_count,
    ROUND(AVG(jpf.salary_year_avg)) as avg_slr
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS skjb ON jpf.job_id = skjb.job_id
INNER JOIN skills_dim AS sk ON skjb.skill_id = sk.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    sk.skill_id
ORDER BY 
    avg_slr DESC,
    demand_count DESC
LIMIT 20;

/* Antes de decidir, vamos filtrar um pouco, iremos retirar vagas que pagam menos de 75000, e também as que tem demanda muito baixa.*/


SELECT
    sk.skills,
    COUNT(skjb.job_id) AS demand_count,
    ROUND(AVG(jpf.salary_year_avg)) as avg_slr
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS skjb ON jpf.job_id = skjb.job_id
INNER JOIN skills_dim AS sk ON skjb.skill_id = sk.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg > 75000
    AND job_work_from_home = TRUE
GROUP BY
    sk.skill_id
HAVING COUNT(skjb.job_id) > 15
ORDER BY 
    avg_slr DESC,
    demand_count DESC
LIMIT 20;