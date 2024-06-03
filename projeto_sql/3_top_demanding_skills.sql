/* Quais são as skills com maior demanda para analise de dados?
Semelhante à query 2, faremos join das tabelas de skills com a job_postings_fact
*/


SELECT
    sk.skills,
    count(sk.skill_id)
FROM
    job_postings_fact AS jbf
INNER JOIN skills_job_dim AS skjb ON skjb.job_id = jbf.job_id
INNER JOIN skills_dim AS sk ON sk.skill_id = skjb.skill_id
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY sk.skills
ORDER BY count DESC
LIMIT 10;

/* Conferiremos também todas as vagas, e vamos comparar se as vagas remotas requerem habilidades diferentes das presenciais*/

SELECT
    sk.skills,
    count(sk.skill_id)
FROM
    job_postings_fact AS jbf
INNER JOIN skills_job_dim AS skjb ON skjb.job_id = jbf.job_id
INNER JOIN skills_dim AS sk ON sk.skill_id = skjb.skill_id
WHERE 
    job_work_from_home = FALSE
GROUP BY sk.skills
ORDER BY count DESC
LIMIT 10;

-- Agora as remotas

SELECT
    sk.skills,
    count(sk.skill_id)
FROM
    job_postings_fact AS jbf
INNER JOIN skills_job_dim AS skjb ON skjb.job_id = jbf.job_id
INNER JOIN skills_dim AS sk ON sk.skill_id = skjb.skill_id
WHERE 
    job_work_from_home = TRUE
GROUP BY sk.skills
ORDER BY count DESC
LIMIT 10;

/*Os dois resultados não são muito diferentes.
Azuere e Spark não aparecem no top 10 remoto, enquanto Excel e Power BI parecem ser mais importantes nessas vagas.
Mas os resultados gerais são semelhantes, e isso se deve ao banco de dados utilizado, que só inclue cargos na área de dados ou computação.*/ 