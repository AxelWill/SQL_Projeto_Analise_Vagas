/*Quais são as melhores habilidades baseadas em salário?
-Olharemos cargos com salários especificados
-Analisaremos os cargos de Data Analyst.
-Assim poderemos saber quais competências são mais recompensadoras financeiramente para aprender ou aprimorar.
*/

SELECT
    sk.skills,
    ROUND(AVG(jbf.salary_year_avg),0) AS average_salary
FROM
    job_postings_fact AS jbf
INNER JOIN skills_job_dim AS skjb ON skjb.job_id = jbf.job_id
INNER JOIN skills_dim AS sk ON sk.skill_id = skjb.skill_id
WHERE 
    job_title_short = 'Data Analyst'
    AND jbf.salary_year_avg IS NOT NULL
GROUP BY sk.skills
ORDER BY average_salary DESC
LIMIT 10;

