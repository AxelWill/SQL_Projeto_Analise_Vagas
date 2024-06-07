# Introdução 
Mergulhemos no mercado de trabalho da área de vagas. Focando em cargos de analista de dados,
 este projeto explora cargos com os maiores salários, habilidades em alta demanda, e onde demanda encontra altos salários
 em análise de dados.

 Queries SQL: ![clique aqui](/projeto_sql/)
 
 Dentro dos arquivos também é explorado um pouco mais os dados.

# Background
Este projeto foi desenvolvido com a ideia de apontar as melhores vagas, em termo de pagamento, e as melhores habilidades para se aprender
 para conseguir tais vagas.

Dados do Curso de SQL de Luke Barousse.
 
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

### 1. ![Maiores salários para analistas de dados](/projeto_sql/1_top_paying_jobs.sql)
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

### 2. ![Habilidades que pagam mais](/projeto_sql/2_top_paying_skills.sql)
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

### 3. ![Habilidades com maior demanda](/projeto_sql/3_top_demanding_skills.sql)
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

![Top_demand_skills](/projeto_sql/assets/Q3.png)
-* O gráfico gerado pelo PostgreSQL mostra quais são as habilidades que passuem a maior quantia de vagas com este requisito.
  
### ![4. Habilidades com maior remuneração em média](/projeto_sql/4_top_average_paying_skills.sql)
A Query 2 nos mostra as habilidades mais bem remuneradas, e a 3 mostra as mais requisitadas, o objetivo da Query 4 é mostrar quais ferramentas tem a maior remuneração em média e nos ajudar a identificar a skill ideal para aprimorar. 

```SQL
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
```
- A query acima mostra os salários médios para cada habilidade em vagas de analísta de dados.
- O resultados são um pouco diferente do imaginado levando em conta as últimas duas queries, SQL e python não aparecem no top 10, na verdade, se expandir a lista, SQL está na posição 109.
![Top_demand_skills](/projeto_sql/assets/Q4.png)
-* O gráfico gerado pelo PostgreSQL mostra as habilidades mais bem remuneradas em média, com SVN no topo.

### 5. ![Habilidades ideais](/projeto_sql/4_optimal_skills.sql)
A Query 4 nos mostrou algo que pode ser um pouco confuso.

SQL não é uma das habilidades mais bem remuneradas em média, na verdade elá abaixo do meio da lista de mais de 170 habilidades.

Então, qual é a melhor habilidade para se aprender, levando em consideração salário e demanda?

```SQL
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
```
![Top_demand_skills](/projeto_sql/assets/Q5_1.png)
- A query acima apresenta primeiro vagas com baixíssima demanda, reforçando o que vimos na Query 2, onde habilidades mais nichadas recebem maior remuneração, então como podemos obter informações mais relevantes?
- A Query a seguir foi modificada para ignorar as habilidades com remuneração abaixo de $75000, escolhido arbitráriamente, para não serem tão influenciadas por vagas menos importantes, além de desconsiderar habilidades com menos de 15 vagas, que seriam competências muito específicas.

```SQL
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
```
![Top_demand_skills](/projeto_sql/assets/Q5_2.png)
-* Com a query atualizada, apenas vagas com remuneração significativa e habilidades com maior demanda foram considerados, assim vemos que SQL saltou posições para nº 14, mostrando quão valiosa está habilidade é.

Como objetivo inicial, considerando que a diferença de remuneração entre as outras habilidades do top 20, e que sua demanda é significativamente maior que qualquer outra, estas queries já seriam o suficiente para mostrar que SQL tem extrema relevância para vagas de analísta de dados.
Mas ainda assim houve uma inconsistência quando foram comparadas as médias salariais.

Vamos explorar um pouco mais.

### 6. ![Maiores demandas com maiores salários](/projeto_sql/6_top_demand_top_paying_jobs.sql)
Esta Query tem o objetivo de selecionar as vagas de maior remuneração, como ja feito antes, e com base nelas, analisar quais são as habilidades que tem mais demanda, já que haviam habilidades mais raras no topo da lista, esta query nos mostra algo interessante.

```SQL
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
    AND job_title_short = 'Data Analyst'
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
```
- Esta query nos mostra qual a demanda de cada habilidade nas 50 vagas mais bem remuneradas como analista de dados, e o que nós vemos é SQL liderando.

![Top_demand_skills](/projeto_sql/assets/Q6.png)
-* SQL em alta, junto de python, mostra-se a melhor habilidade para se aprender para entrar na área.

O que aconteceu então para a Query 4 não mostrar SQL como uma habilidade de alta remuneração? As grande maioria das vagas são de remuneração mais baixa, e sendo a habilidade disparadamente a com maior demanda, essas vagas acabam puxando SQL para baixo na lista, dando a impressão de que não são tão ótimas, quando na verdade ela é uma competência presente em todos os níveis de atuação, sendo, por esta análise, a melhor habilidade para aprimorar ou aprender com o objetivo de trabalhar na área de análise de dados.


# O que aprendi
- **Queries Avançadas:** Com CTE e uniões de tabelas pude fazer análises por partes, facilitando muito a formação de queries mais interessantes.
- **Agregação de dados:** Este projeto utilizou muito a cláusula GROUP BY, ajudando a me familizarizar com a agregação, que até então era um tanto confusa para mim.
- **Questionamente Analítico:** O projeto propôs 5 questões, e dentro delas fui capaz de entender o motivos delas, como responder elas, como eu poderia fazer outra análise a partir daquelas propostas e queries, e ainda deidi uma 6ª questão que achei que cabia bem à análise e ao projeto.

# Conclusão

