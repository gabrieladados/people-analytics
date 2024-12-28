# People Analytics: Insights para Retenção de Talentos

> Este repositório apresenta uma análise de People Analytics utilizando SQL para explorar e gerar insights a partir de uma base de dados fictícia da IBM. 
>

## 🤔 O que é People Analytics?  

People Analytics é uma metodologia que coleta, organiza e analisa dados de forma estratégica, transformando informações gerenciais em insights valiosos. Esses insights ajudam as lideranças a tomar decisões mais assertivas em relação aos colaboradores da organização.

## 🛠️ Tecnologias Utilizadas  

- **SQL:** Para consultas e extração dos dados.
- **Google BigQuery:** Para armazenamento e manipulação da base de dados.
- **Tableau:** Para visualização dos insights.


## 🗂️ Base de Dados  

A base utilizada é o conjunto de dados **IBM HR Analytics Attrition Dataset**, disponível no Kaggle. Você pode acessá-la através deste [link](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset?resource=download).

### 🗃️ Estrutura dos Dados

A base original possui 35 colunas, mas utilizamos 15 colunas relevantes para a análise. Confira o dicionário dos dados:

| **Coluna**              | **Descrição**                                                                                  |
|--------------------------|-----------------------------------------------------------------------------------------------|
| `Age`                   | Idade dos colaboradores.                                                                      |
| `Attrition`             | Indica se o colaborador está ativo ou não na empresa.                                         |
| `BusinessTravel`        | Frequência de viagens a trabalho.                                                             |
| `Department`            | Departamento onde o colaborador trabalha.                                                    |
| `DistanceFromHome`      | Distância da casa do colaborador até o trabalho.                                              |
| `Education`             | Grau de escolaridade (1: Below College, 2: College, 3: Bachelor, 4: Master, 5: Doctor).       |
| `EmployeeNumber`        | Identificador único do colaborador.                                                           |
| `EnvironmentSatisfaction` | Satisfação com o ambiente de trabalho (1: Baixa, 4: Muito Alta).                            |
| `Gender`                | Gênero do colaborador.                                                                        |
| `JobInvolvement`        | Envolvimento com o trabalho (1: Baixo, 4: Muito Alto).                                        |
| `JobSatisfaction`       | Satisfação com o trabalho (1: Baixa, 4: Muito Alta).                                          |
| `MaritalStatus`         | Estado civil do colaborador.                                                                  |
| `MonthlyIncome`         | Renda mensal do colaborador.                                                                  |
| `RelationshipSatisfaction` | Satisfação com os relacionamentos no trabalho (1: Baixa, 4: Muito Alta).                   |
| `YearsAtCompany`        | Tempo de empresa em anos.                                                                     |

## 📥 Importação da Base para o BigQuery  

1. Faça o download da base de dados no Kaggle.
2. Acesse o BigQuery e crie um novo projeto.
3. Adicione o arquivo baixado ao projeto como uma nova tabela:
   - Nome do conjunto de dados: `employee`.
   - Nome da tabela: `employee_attrition`.

A tabela contém **1.470 linhas** e **15 colunas**.

---
## 🔍 Análise por Idade

### Pergunta:
Será que existe alguma faixa etária mais propensa a sair da empresa?

Abaixo, vamos analisar a idade média, mínima e máxima dos colaboradores da base de dados da IBM.

### Consulta SQL: Idade Geral
```sql
SELECT
  ROUND(AVG(Age),2) AS IdadeMedia,
  MIN(Age) AS IdadeMin,
  MAX(Age) AS IdadeMax
FROM projeto-ibm-hr.employee.employee_attrition
```
![sql 1](https://github.com/user-attachments/assets/43c45303-c17e-4d40-979a-7d96aae21d0b)

Vamos verificar se existe uma diferença na idade média dos colaboradores que saíram em comparação aos colaboradores que continuaram ativos na empresa.
```sql
SELECT
  ROUND(AVG(Age),2) AS IdadeMedia,
  MIN(Age) AS IdadeMin,
  MAX(Age) AS IdadeMax
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = false
```
![sql 2](https://github.com/user-attachments/assets/7f558176-1430-4786-b64c-d37ab06cb653)

```sql
SELECT
  ROUND(AVG(Age),2) AS IdadeMedia,
  MIN(Age) AS IdadeMin,
  MAX(Age) AS IdadeMax
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = true
```
![sql3](https://github.com/user-attachments/assets/893a6704-e2d4-4cd9-b97b-73cd594aa70f)

Percebemos que em média os colaboradores que saíram da empresa eram 4 anos mais novos que os colaboradores que continuaram ativos. Para conseguirmos aprofundar na análise, vamos criar faixas etárias.
```sql
SELECT
  CASE 
    WHEN Age >= 18 AND Age<25 THEN "18-24"
    WHEN Age >=25 AND Age <35 THEN "25-34"
    WHEN Age >=35 AND Age < 45 THEN "35-44"
    WHEN Age >=45  THEN "45-60"
  END AS FaixaEtaria,
FROM projeto-ibm-hr.employee.employee_attrition
```

Agora, vamos trazer algumas informações por faixa etária como: o número total de colaboradores, número de desligados, percentual do total de desligados e a taxa de atrito. Na taxa de atrito consideramos a quantidade de pessoas desligadas naquela faixa etária e dividimos pela quantidade total de colaboradores na mesma faixa etária. Assim, conseguimos entender a representatividade dessas saídas para aquele grupo em questão.
```sql
SELECT FaixaEtaria,
  COUNT(EmployeeNumber) AS TotalFunc,
  SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END) AS DesligadosFunc,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/(SELECT COUNT(EmployeeNumber) FROM projeto-ibm-hr.employee.employee_attrition WHERE Attrition = true),2),"%") AS PorcentagemTotalDesligados,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END) * 100)/ COUNT(EmployeeNumber), 2), "%") AS TaxaAtrito
FROM
  (SELECT
    CASE 
      WHEN Age >= 18 AND Age<25 THEN "18-24"
      WHEN Age >=25 AND Age <35 THEN "25-34"
      WHEN Age >=35 AND Age < 45 THEN "35-44"
      WHEN Age >=45  THEN "45-60"
    END AS FaixaEtaria,
    Age,
    Attrition,
    EmployeeNumber
  FROM projeto-ibm-hr.employee.employee_attrition) AS ClassificacaoEtaria
GROUP BY FaixaEtaria
ORDER BY FaixaEtaria
```
![sql4](https://github.com/user-attachments/assets/c2b38993-e8cb-49b9-9cce-ab85c9ff9edd)

Nota-se que a faixa etária de colaboradores entre 18 e 24 anos é a que apresenta maior taxa de atrito (39,18%), seguido pelos colaboradores entre 25 e 34 anos (20,22%).

---
## 🔍 Análise por Gênero

### Pergunta: 
Qual é o gênero que apresenta maior taxa de atrito?

```sql
SELECT Gender,
  COUNT(EmployeeNumber) AS TotalFunc,
  SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END) AS DesligadosFunc,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/(SELECT COUNT(EmployeeNumber) FROM projeto-ibm-hr.employee.employee_attrition WHERE Attrition = true),2),"%") AS PorcentagemTotal,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/COUNT(EmployeeNumber),2),"%") AS TaxaAtrito
FROM projeto-ibm-hr.employee.employee_attrition
GROUP BY Gender
```
![sql5](https://github.com/user-attachments/assets/d091f1e8-0e2f-400d-9724-cbabf8b61bd1)

Percebe-se que a taxa de atrito do gênero masculino (17,01%) é relativamente maior que do gênero feminino (14,8%).

---
## 🔍 Análise pelo Grau de Escolaridade

### Pergunta: 
Existe algum grau de escolaridade mais propenso a sair da empresa?

Como o campo Education retorna resultados numéricos de 1 a 4, vamos classificar de acordo com o dicionário da base de dados.
```sql
SELECT 
  CASE 
    WHEN Education = 1 THEN 'Below College'
    WHEN Education = 2 THEN 'College'
    WHEN Education = 3 THEN 'Bachelor'
    WHEN Education = 4 THEN 'Master'
    WHEN Education = 5 THEN  'Doctor'
  END AS GrauEscolaridade
FROM projeto-ibm-hr.employee.employee_attrition
```
Feito isso, agora vamos verificar o número total de colaboradores, número de inativos, o percentual de inativos e a taxa de atrito por grau de escolaridade.

```sql
SELECT 
  GrauEscolaridade,
  COUNT(EmployeeNumber) AS TotalFunc,
  SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END) AS DesligadosFunc,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/(SELECT COUNT(EmployeeNumber) FROM projeto-ibm-hr.employee.employee_attrition WHERE Attrition = true),2),"%") AS PorcentagemTotal,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/COUNT(EmployeeNumber),2),"%") AS TaxaAtrito
FROM
(SELECT 
  CASE 
    WHEN Education = 1 THEN 'Below College'
    WHEN Education = 2 THEN 'College'
    WHEN Education = 3 THEN 'Bachelor'
    WHEN Education = 4 THEN 'Master'
    WHEN Education = 5 THEN  'Doctor'
  END AS GrauEscolaridade,
  Attrition,
  EmployeeNumber
FROM projeto-ibm-hr.employee.employee_attrition)
GROUP BY GrauEscolaridade

```

![sql6](https://github.com/user-attachments/assets/102e1eda-8971-4c59-a587-61bfa048209c)

É notável que os colaboradores que apresentam um grau de escolaridade mais baixo são os que possuem as maiores taxas de atrito. Enquanto os que possuem mestrado (14,57%) ou doutorado (10,42%), são os que possuem as menores taxas de atrito.

---
## 🔍 Análise por Estado Civil

### Pergunta: 
Qual é o estado civil que apresenta maior taxa de atrito?
```sql
SELECT 
  MaritalStatus,
  COUNT(EmployeeNumber) AS TotalFunc,
  SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END) AS DesligadosFunc,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/ (SELECT COUNT(EmployeeNumber)FROM projeto-ibm-hr.employee.employee_attrition WHERE Attrition = true),2),"%") AS PorcentagemTotal,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/COUNT(EmployeeNumber),2),"%") AS TaxaAtrito
FROM projeto-ibm-hr.employee.employee_attrition
GROUP BY MaritalStatus
```
![sql7](https://github.com/user-attachments/assets/a9e4c0da-39c0-4c2c-8de1-7ee53192ef0a)

Os colaboradores solteiros são os que apresentam o maior número absoluto de desligados (120), além da maior taxa de atrito (25,53%).


---
## 🔍 Análise por Tempo de Empresa

### Pergunta: 
Os colaboradores com menor tempo de empresa são os que apresentam a maior taxa de atrito?

Abaixo, vamos analisar a média, o mínimo e o máximo de tempo que os colaboradores da IBM ficam na empresa.
```sql
SELECT 
  ROUND(AVG(YearsAtCompany),2) AS MediaTempoEmpresa,
  MIN(YearsAtCompany) AS MinTempoEmpresa,
  MAX(YearsAtCompany) AS MaxTempoEmpresa
FROM projeto-ibm-hr.employee.employee_attrition
```
![sql8](https://github.com/user-attachments/assets/6038a02f-fdef-4b31-94b2-49be39c083d9)

Para facilitar a análise, criaremos classificações do tempo de empresa.

```sql
SELECT
  CASE 
   WHEN YearsAtCompany < 3 THEN "0-2"
   WHEN YearsAtCompany >=3 AND YearsAtCompany < 6 THEN "3-5"
   WHEN YearsAtCompany >=6 AND YearsAtCompany < 11 THEN "5-10"
   WHEN YearsAtCompany >=11 AND YearsAtCompany < 21 THEN "11-20"
   WHEN YearsAtCompany >=21 AND YearsAtCompany < 31 THEN "21-30"
   WHEN YearsAtCompany >=31 AND YearsAtCompany < 41 THEN "31-40"
  END AS AnosEmpresa
FROM projeto-ibm-hr.employee.employee_attrition
```
Feito isso, agora é hora de analisarmos o número total de colaboradores, o número de inativos, o percentual de inativos e a taxa de atrito por tempo de empresa.

```sql
SELECT 
  AnosEmpresa,
  COUNT(EmployeeNumber) AS TotalFunc,
  SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END) AS DesligadosFun,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/(SELECT COUNT (EmployeeNumber) FROM projeto-ibm-hr.employee.employee_attrition WHERE Attrition = true),2),"%") AS PorcentagemTotal,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/ COUNT(EmployeeNumber),2),"%") AS TaxaAtrito
FROM
(SELECT
  CASE 
   WHEN YearsAtCompany < 3 THEN "0-2"
   WHEN YearsAtCompany >=3 AND YearsAtCompany < 6 THEN "3-5"
   WHEN YearsAtCompany >=6 AND YearsAtCompany < 11 THEN "5-10"
   WHEN YearsAtCompany >=11 AND YearsAtCompany < 21 THEN "11-20"
   WHEN YearsAtCompany >=21 AND YearsAtCompany < 31 THEN "21-30"
   WHEN YearsAtCompany >=31 AND YearsAtCompany < 41 THEN "31-40"
  END AS AnosEmpresa,
  EmployeeNumber,
  Attrition
FROM projeto-ibm-hr.employee.employee_attrition)
GROUP BY AnosEmpresa
```
![sql9](https://github.com/user-attachments/assets/c7e8649c-e231-4bc5-98c7-01310dba8e93)

Nota-se que a maior taxa de atrito está nos colaboradores que possuem entre 0 e 2 anos de empresa (29,82%). Essa taxa vai se reduzindo ao longo do tempo de empresa, até apresentar um novo pico com os colaboradores que possuem de 31 a 40 anos de empresa (25,00%).

---
## 🔍 Análise Salarial

### Pergunta: 
Os colaboradores que saíram da empresa apresentavam menores salários comparado aos que estão ativos?

Inicialmente, vamos analisar a média, o mínimo e o máximo de salário de todos os colaboradores.

```sql
SELECT 
  ROUND(AVG(MonthlyIncome),2) AS SalarioMedio,
  MIN(MonthlyIncome) AS SalarioMin,
  MAX(MonthlyIncome) AS SalarioMax
FROM projeto-ibm-hr.employee.employee_attrition
```
![sql10](https://github.com/user-attachments/assets/f450cf98-760b-45c4-9c9b-45fac0aac6aa)

Agora iremos comparar essas mesmas medidas entre aqueles que foram desligados e aqueles permanecem ativos na empresa.

```sql
SELECT 
  ROUND(AVG(MonthlyIncome),2) AS SalarioMedio,
  MIN(MonthlyIncome) AS SalarioMin,
  MAX(MonthlyIncome) AS SalarioMax
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = false
```
![sql11](https://github.com/user-attachments/assets/8e11020c-8f97-4195-aed4-99b3bfcb0716)

```sql
SELECT 
  ROUND(AVG(MonthlyIncome),2) AS SalarioMedio,
  MIN(MonthlyIncome) AS SalarioMin,
  MAX(MonthlyIncome) AS SalarioMax
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = true
```
![sql12](https://github.com/user-attachments/assets/8ed9d4b9-7f3c-4038-84e3-5e8fec0f1414)

Nota-se que os colaboradores que saíram da empresa recebiam aproximadamente 29,94% a menos que os demais colaboradores.

---
## 🔍 Análise por Departamento

### Pergunta: 
Qual é o departamento com a maior taxa de atrito?
```sql
SELECT 
  Department,
  COUNT(EmployeeNumber) AS TotalFunc,
  SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END) AS TotalDesligados,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/ (SELECT COUNT(EmployeeNumber) FROM projeto-ibm-hr.employee.employee_attrition WHERE Attrition = true),2), "%") AS PorcentagemTotalDesligados,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/COUNT(EmployeeNumber),2),"%") AS TaxaAtrito
FROM projeto-ibm-hr.employee.employee_attrition
GROUP BY Department
```
![sql14](https://github.com/user-attachments/assets/83355e50-2f8e-4a4e-aadc-1ee769bce0e5)

Como podemos notar, o departamento de vendas é o que apresenta a maior taxa de atrito (20,63%), seguido por recursos humanos (19,05%). Vamos cruzar esses dados com o de salário para conseguirmos mais insights.

Abaixo segue a média, o valor mínimo e máximo do salário dos colaboradores que permaneceram na empresa em comparação aos que saíram.

**Departamento x Salário**
```sql
SELECT 
  Department,
  ROUND(AVG(MonthlyIncome),2) AS MediaSal,
  MIN(MonthlyIncome) AS MinSal,
  MAX(MonthlyIncome) AS MaxSal
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = false
GROUP BY(Department)
```
![sql15](https://github.com/user-attachments/assets/aad6d35c-0b36-49bf-a0d5-d015659134f5)

```sql
SELECT 
  Department,
  ROUND(AVG(MonthlyIncome),2) AS MediaSal,
  MIN(MonthlyIncome) AS MinSal,
  MAX(MonthlyIncome) AS MaxSal
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = true
GROUP BY(Department)
```
![sql16](https://github.com/user-attachments/assets/ae4a883c-add7-4bf1-bc64-1bdc77da91c4)

Em uma análise geral, percebe-se a média salarial dos colaboradores que permaneceram na empresa é maior quando comparado aqueles que saíram. Isso pode ser percebido em todos os 3 departamentos.

Vamos analisar melhor essa diferença entre as médias salariais de cada departamento:

- **Research & Development**: 7232,24 (média dos colaboradores que ficaram) — 4108,08 (média dos colaboradores que saíram) = 3124,16 → (3124,16/7232,24)*100 = 43,19%

- **Sales**: 6630,33 (média dos colaboradores que ficaram) — 5908,46 (média dos colaboradores que saíram) = 721,87 → (721,87/6630,33)*100 = 10,88%

- **Human Resources**: 7345,98 (média dos colaboradores que ficaram) — 3715,75 (média dos colaboradores que saíram) = 3630,23 → (3630,23/7345,98)*100 = 49,41%

Percebe-se que os colaboradores de recursos humanos que saíram da empresa recebiam em média 49,41% a menos que os demais colaboradores do mesmo departamento. Isso explica a alta taxa de atrito de 19,05%.

Já a área de vendas, que apresentou a maior taxa de atrito (20,63%), nota-se que os colaboradores que saíram recebiam em média 10,88% a menos que os demais, o que comparado com os outros dois setores não é um número tão elevado. Vale destacar que para uma taxa de atrito ser alta podemos ter diversas variáveis envolvidas. Vamos analisar agora por uma ótica de clima e cultura para conseguirmos mais informações.

**Departamento x Satisfação com o Trabalho**
```sql
SELECT 
  Department,
  ROUND(AVG(EnvironmentSatisfaction),2) AS SatisfacaoAmbiente,
  ROUND(AVG(JobInvolvement),2) AS EnvolvimentoTrabalho,
  ROUND(AVG(JobSatisfaction),2) AS SatisfacaoTrabalho,
  ROUND(AVG(RelationshipSatisfaction),2) AS SatisfacaoRelacionamentos
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = false
GROUP BY(Department)
```
![sql17](https://github.com/user-attachments/assets/348fce2f-5943-422a-9c39-c25eadb8837e)

```sql
SELECT 
  Department,
  ROUND(AVG(EnvironmentSatisfaction),2) AS SatisfacaoAmbiente,
  ROUND(AVG(JobInvolvement),2) AS EnvolvimentoTrabalho,
  ROUND(AVG(JobSatisfaction),2) AS SatisfacaoTrabalho,
  ROUND(AVG(RelationshipSatisfaction),2) AS SatisfacaoRelacionamentos
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = true
GROUP BY(Department)
```
![sql18](https://github.com/user-attachments/assets/d59c9230-8662-40b1-9e0f-be2702359a5d)

Analisando a satisfação do ambiente e com o trabalho, o departamento de recursos humanos é o que apresenta as menores médias. Já em relação ao envolvimento com o trabalho o departamento de vendas possui a menor média (2,47) e na satisfação com os relacionamentos, a menor média é do departamento de P&D (2,52).

Portanto, percebemos que a alta taxa de atrito do departamento de recursos humanos (19,05%) pode ser explicada pela diferença salarial de 49,41% a menos em relação aos demais colaboradores do mesmo setor, além da baixa satisfação com o ambiente e o trabalho.

Já em relação ao departamento de vendas (com taxa de atrito de 20,63%) não foi possível tirar informações conclusivas com os dados de salário e engajamento disponíveis. O ideal seria analisar as pesquisas de desligamentos desses colaboradores, além de aplicar pesquisas de pulsos direcionadas para esse público, a fim de identificar as causas e criar planos de ação.

---
## 🔍 Análise da Distância de casa para o trabalho

### Pergunta: 
A distância em relação ao trabalho impacta na decisão dos colaboradores de sair da empresa?

Primeiramente, vamos analisar a distância média, máxima e mínimia.
```sql
SELECT 
  ROUND(AVG(DistanceFromHome),2) AS DistanciaMedia,
  MIN(DistanceFromHome) AS DistanciaMin,
  MAX(DistanceFromHome) AS DistanciaMax
FROM projeto-ibm-hr.employee.employee_attrition
```
![sql19](https://github.com/user-attachments/assets/4a4cc0da-f783-473f-8b79-cb2d66e7c5f7)
Para facilitar a análise, criaremos uma classificação das distâncias em grupos:

```sql
SELECT 
 CASE
   WHEN DistanceFromHome > 0 AND DistanceFromHome <6 THEN "01-05"
   WHEN DistanceFromHome >= 6 AND DistanceFromHome < 11 THEN "06-10"
   WHEN DistanceFromHome >= 11 AND DistanceFromHome < 21 THEN "11-20"
   WHEN DistanceFromHome >=  21 AND DistanceFromHome < 30 THEN "21-29"
 END AS ClassificacaoDistancia
FROM projeto-ibm-hr.employee.employee_attrition
GROUP BY ClassificacaoDistancia
ORDER BY ClassificacaoDistancia
```
Feito isso, vamos analisar o número total de colaboradores, número de colaboradores inativos, o percentual dos inativos e a taxa de atrito por grupo de distância de casa até o trabalho.

```sql
SELECT 
  ClassificacaoDistancia,
  COUNT(EmployeeNumber) AS TotalFunc,
  SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END) AS DesligadosFunc,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/ (SELECT COUNT (EmployeeNumber) FROM projeto-ibm-hr.employee.employee_attrition WHERE Attrition = true), 2), "%") AS PorcentagemTotal,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/ COUNT(EmployeeNumber), 2), "%") AS TaxaAtrito

FROM
(SELECT 
  CASE
    WHEN DistanceFromHome > 0 AND DistanceFromHome <6 THEN "01-5"
    WHEN DistanceFromHome >= 6 AND DistanceFromHome < 11 THEN "06-10"
    WHEN DistanceFromHome >= 11 AND DistanceFromHome < 21 THEN "11-20"
    WHEN DistanceFromHome >=  21 AND DistanceFromHome < 30 THEN "21-29"
  END AS ClassificacaoDistancia,
  EmployeeNumber,
  Attrition
FROM projeto-ibm-hr.employee.employee_attrition)
GROUP BY ClassificacaoDistancia
ORDER BY ClassificacaoDistancia

```
![sql20](https://github.com/user-attachments/assets/2c927911-27d1-4db9-bc6a-05d36d2f8290)

Observa-se que quanto maior a distância que o colaborador tem da sua casa até o trabalho, maior se torna a taxa de atrito. Destaque-se os colaboradores que moram de 21 a 29 km de distância com taxa de 22,06%.

Agora vamos comparar esses dados com a satisfação. Será que os colaboradores que moram mais distante do trabalho estão mais insatisfeitos?

**Distância X Satisfação**

```sql
SELECT  
  ClassificacaoDistancia,
  ROUND(AVG(EnvironmentSatisfaction),2) AS SatisfacaoAmbiente,
  ROUND(AVG(JobInvolvement),2) AS EnvolvimentoTrabalho,
  ROUND(AVG(JobSatisfaction),2) AS SatisfacaoTrabalho,
  ROUND(AVG(RelationshipSatisfaction),2) AS SatisfacaoRelacionamentos
FROM
(SELECT 
  CASE
    WHEN DistanceFromHome > 0 AND DistanceFromHome <6 THEN "01-5"
    WHEN DistanceFromHome >= 6 AND DistanceFromHome < 11 THEN "06-10"
    WHEN DistanceFromHome >= 11 AND DistanceFromHome < 21 THEN "11-20"
    WHEN DistanceFromHome >=  21 AND DistanceFromHome < 30 THEN "21-29"
  END AS ClassificacaoDistancia,
  EmployeeNumber,
  Attrition, 
  DistanceFromHome,
  EnvironmentSatisfaction,
  JobInvolvement,
  JobSatisfaction,
  RelationshipSatisfaction
FROM projeto-ibm-hr.employee.employee_attrition)
GROUP BY ClassificacaoDistancia
ORDER BY ClassificacaoDistancia
```
![sql21](https://github.com/user-attachments/assets/223da330-0f8b-4270-a252-0f7a648718b7)

Percebemos que a média de satisfação com o ambiente e o envolvimento com o trabalho daqueles que moram entre 21 a 29 km de distância é menor que comparado aos demais grupos.

---
## 🔍 Análise pela frequência de Viagens a Trabalho

### Pergunta: 
Os colaboradores que realizam muitas viagens a trabalho são os que apresentam maior taxa de atrito?

Abaixo segue a análise do total de colaboradores, número de inativos, percentual de inativos e a taxa de atrito por frequência de viagens a trabalho.

```sql
SELECT 
  BusinessTravel,
  COUNT(EmployeeNumber) AS TotalFunc,
  SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)AS DesligadosFunc,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/(SELECT COUNT(EmployeeNumber) FROM projeto-ibm-hr.   employee.employee_attrition WHERE Attrition = true),2), "%") AS PorcentagemTotalDesligados,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/COUNT(EmployeeNumber),2), "%") AS TaxaAtrito
FROM projeto-ibm-hr.employee.employee_attrition
GROUP BY BusinessTravel
```
![sql22](https://github.com/user-attachments/assets/18db8997-8200-490c-b76e-ff44d5ab40a4)

Podemos perceber que quanto maior a frequência de viagens a trabalho, maior a taxa de atrito dos funcionários. Os que viajam frequentemente possuem uma taxa de 24,91%, os que viajam raramente apresentam 14,91% e os que não viajam apenas 8,00%.













## 💡 Principais Insights  

A análise revelou fatores que influenciam na capacidade de retenção dos colaboradores na empresa:

- **Idade:** Jovens (18-34 anos) têm maior taxa de atrito, enquanto os mais experientes têm taxas mais baixas.
- **Gênero:** Homens possuem uma taxa de atrito maior (17,01%) que mulheres (14,08%).
- **Escolaridade:** Colaboradores com maior escolaridade têm menores taxas de atrito.
- **Estado Civil:** Solteiros têm a maior taxa de atrito (25,53%).
- **Tempo de Empresa:** Colaboradores com até 2 anos de empresa apresentam a maior taxa de atrito (29,82%).
- **Remuneração:** Colaboradores que saíram recebiam 29,94% menos que a média dos demais.
- **Departamento:** Profissionais do departamento de Recursos Humanos recebiam em média 49,41% a menos que os demais do mesmo setor, e esse departamento apresenta a menor média de satisfação com o trabalho e o ambiente.
- **Distância Casa-Trabalho:** Maior distância está associada a maior taxa de atrito.
- **Viagens a Trabalho:** Colaboradores que viajam frequentemente têm maior taxa de atrito (24,91%).

---

## 🎯 Recomendações Estratégicas  

Com base nos insights, propomos as seguintes ações:

1. **Programas de Retenção para Colaboradores Jovens**: Criar programas com foco de desenvolvimento profissional e oportunidades de crescimento para os colaboradores mais jovens, visando aumentar o engajamento e a retenção.

2. **Incentivos para Funcionários Experientes**: Reconhecer e valorizar a experiência dos colaboradores mais experientes por meio de programas de reconhecimento, eventos anuais para colaboradores com muitos anos de empresa e criação de benefícios adicionais.

3. **Incentivos Educacionais**: Oferecer incentivos para educação continuada, como bolsas de estudo ou programas de treinamento interno, para reduzir a taxa de atrito entre os colaboradores sem graduação.

4. **Programas de Integração para Novos Colaboradores**: Desenvolver programas de integração robustos para novos colaboradores, especialmente para aqueles com menos de 2 anos de empresa, para aumentar o envolvimento e a conexão com a empresa desde o início.

5. **Revisão de Remuneração**: Realizar uma revisão salarial para garantir que os salários dos colaboradores estejam alinhados com o mercado e com as responsabilidades do cargo.

6. **Melhoria do Ambiente de Trabalho**: Realizar pesquisas periódicas de pulso e engajamento para identificar os motivos de baixa insatisfação com o trabalho e ambiente, visando a implantação de contramedidas.

7. **Flexibilidade no Modelo de Trabalho**: Considerar políticas de trabalho remoto ou flexível para colaboradores que moram mais longe do escritório, visando reduzir o impacto da distância na taxa de atrito.

8. **Redução das Viagens a Trabalho**: Avaliar a necessidade e frequência das viagens a trabalho e buscar maneiras de reduzir a carga de viagens, quando possível, para minimizar o impacto na taxa de atrito dos colaboradores.


---

## 📈 Dashboard no Tableau 

- **KPIs monitorados e Análises Realizadas**:
    - Total de Colaboradores (ativos e desligados).
    - Total de Colaboradores ativos
    - Total de Colaboradores Desligados
    - Taxa de Desligamento.
    - Taxa de Desligamento por idade, gênero, escolaridade e estado civil.
    - Taxa de Desligamento por anos de empresa, departamento, distância e frequência de viagens a trabalho.
    - Análise Salarial por departamento dos colaboradores ativos e desligados. 
    <br>  
      
  > 👉 **Acesse o dashboard no Tableau Public aqui:**   [Dashboard no Tableau](https://public.tableau.com/views/hr_attrition_17105255789630/Demographics?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)


![Demographics](https://github.com/user-attachments/assets/130d93bf-9a10-48a1-a891-ef19d1eaea4c)

![image](https://github.com/user-attachments/assets/4175546d-b6a7-4148-a4d4-7fe9ead68be1)


---


## Contribuições

Muito obrigada por acompanhar meu projeto até aqui! 🎉

Contribuições são **muito bem-vindas**. Se você tem sugestões ou melhorias, fique à vontade para abrir uma **issue** ou enviar um **pull request**.

Gostou do projeto? Não esqueça de dar uma ⭐️! 


**Meus Contatos:**

💻 [LinkedIn](https://www.linkedin.com/in/gabrielasantanamorais/)  
📩 [E-mail](mailto:gabrielasmorais01@gmail.com)

**Até a próxima!** 🚀
