
/* 
As querys anteriores respondiam uma questão um pouco específica.
A pergunta de quais as habilidades que mais pagam ou quais hailidades possuem mais vagas podem parecer um tanto disconexas
Devido à abrangência de algumas ferramentas, as habilidades mais requisitadas também aparecem em vagas com salários menores, e pode nos dar impressão que essa competências não estão relacionadas à grandes salários.
Então vamos fazer a seguinta análise, dentro das vagas com maiores salários, quais as habilidades que mais aparecem como requisito?
*/

WITH top_paying_jobs AS(
SELECT
    job_id,
    salary_year_avg
FROM
    job_postings_fact
LEFT JOIN
    company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 50
)

SELECT
    skills,
    count(skills_dim.skill_id) as frequencia
FROM skills_dim
LEFT JOIN skills_job_dim
ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN top_paying_jobs ON skills_job_dim.job_id = top_paying_jobs.job_id
GROUP BY skills
ORDER BY frequencia DESC;

/*
Novamente podemos ver, SQL, e principalmente Python, aparecem no topo, mostrando que,
embora haja alta procura desta ferramenta em cargos iniciais, ela se mantém com uma alta procura para as posições que pagam mais
*/
