# Introdução 
Mergulhemos no mercado de trabalho da área de vagas. Focando em cargos de analista de dados,
 este projeto explora cargos com os maiores salários, habilidades em alta demanda, e onde demanda encontra altos salários
 em análise de dados.

 Queries SQL: ![clique aqui](/projeto_sql/)

# Background
Este projeto foi desenvolvido com a ideia de apontar as melhores vagas, em termo de pagamento, e as melhores habilidades para se aprender
 para conseguir tais vagas.

Dados do ![Curso de SQL](https://www.lukebarousse.com/sql) de Luke Barousse.
 
Com isto em mente, foram feitas 5 questões, e 5 queries SQL respondendo elas.

1. Quais são as vagas de analista de dados com maior salário?
2. Quais são as habilidades requeridas para as vagas de maior salário?
3. Quais são as habilidades que são requeridas em maior quantia de vagas?
4. Quais habilidades estão associadas a maiores salários?
5. Quais são as melhores habilidades para aprender ou aprimorar?

Com isso, gerou ainda uma dúvida. As questões acimas parecem não preencher todas as informações que podem ser úteis, então mais uma foi adicionada

6. Considerando as vagas de maior salário, quais habilidades aparecem mais como requisito?

# Análise
Cada query feita mirava investigar sobre os aspectos dos cargos de análise de dados, cada uma respondendo uma das perguntas acima.

As questões foram abordadas da seguinte maneira:

### 1. Maiores salários para analistas de dados
Para identificar os cargos de maiores salários foram selecionadas, além de outras colunas para maior informações, a coluna de salário médio anual
e título do cargo. Ordenando por maiores salários e focando em cargos remotos, esta query mostra os maiores salários da área.

``` SQL
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
LIMIT 50;
```
- Os 50 maiores salários variam de $138500 a $650000 anuais na área de análise de dados para vagas remotas, mostrando ser uma área promissora para seguir profissionalmente.

### 2. Habilidades que pagam mais
Usando de base a Query 1, pudemos encontrar a habilidades que preencher os requisitos das vagas dos cargos de maiores salários da área de dados.

```SQL
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
```
- As habilidades mais bem remuneradas neste conjunto de dados são Oracle, Linux e Git, entre outros.
- As competências de SQL, Python, e R aparecem logo em seguida, se repetindo várias vezes na lista das 10 melhores vagas.

### 3. Habilidades com maior demanda
Saber quais são as habilidades dos cargos mais bem remuneradas pode não ser exatamente a informação que estejamos procurando, já que isso não esclarece
quão acessível é uma vaga nestes cargos, por isso a Query 3 tem a intenção de mostrar quais das habilidades são requisitadas com maior frequência.

```sql
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
```
- Esta Query simples mostra para nós quais habilidades estão no topo da lista de requesitos para conseguir uma vaga como analísta de dados.
- SQL, Excel e Python lideram a lista, com 92 mil vagas pedindo SQL como requisito para os candidatos à vaga.
![Top_demand_skills](SQL_Projeto_Analise_Vagas\projeto_sql\assets\image.png)
  
# O que aprendi
# Conclusão
