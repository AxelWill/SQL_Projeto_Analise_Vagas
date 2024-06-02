/*
O objetivo é identificar os empregos de analista de dados com maior salário
- Identifiar os 10 maiores salários de cargos remotos
- Focar em vagas que foram postadas com salários especificados
- Focar nas vagas de maior salário para dos dar um entendimento das habilidade que devemos focar para conseguir vagas semelhantes
*/

SELECT
    job_id,
    company_dim.company_id,
    company_dim.name AS company_name,
    job_title,
    job_location,    
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN
    company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_location = 'Anywhere'
    AND job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

/* Agora mudando um pouco a descrição, se quisermos ver o salário por hora, apenas no brasil?*/


SELECT
    job_id,
    company_dim.company_id,
    company_dim.name AS company_name,
    job_title,
    job_location,    
    job_schedule_type,
    salary_hour_avg,
    salary_rate,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN
    company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_location LIKE 'Brazil'
    AND job_title_short = 'Data Analyst'
    AND salary_rate = 'hour'
ORDER BY
    salary_hour_avg DESC
LIMIT 10;

/* Há apenas uma vaga com pagamento em hora
Então vamos restringir para apenas as vagas que possuem algum descritivo do salário*/

SELECT
    job_id,
    company_dim.company_id,
    company_dim.name AS company_name,
    job_title,
    job_location,    
    job_schedule_type,
    salary_hour_avg,
    salary_rate,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN
    company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_location LIKE 'Brazil'
    AND job_title_short = 'Data Analyst'
    AND salary_rate IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

/* Também há muitas vagas sem descritivo de salário, que podem ser oportunidades valiosas
Mas para essa análise, onde queremos ver quais habilidades são requeridas em cargos que pagam bem, estas vagas não tem grande valor analítico.*/