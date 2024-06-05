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
LIMIT 10;
```

# O que aprendi
# Conclusão
