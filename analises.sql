--Análise por IdadeA

SELECT
  ROUND(AVG(Age),2) AS IdadeMedia,
  MIN(Age) AS IdadeMin,
  MAX(Age) AS IdadeMax
FROM projeto-ibm-hr.employee.employee_attrition;


SELECT
  ROUND(AVG(Age),2) AS IdadeMedia,
  MIN(Age) AS IdadeMin,
  MAX(Age) AS IdadeMax
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = false;

SELECT
  ROUND(AVG(Age),2) AS IdadeMedia,
  MIN(Age) AS IdadeMin,
  MAX(Age) AS IdadeMax
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = true;

SELECT
  CASE 
    WHEN Age >= 18 AND Age<25 THEN "18-24"
    WHEN Age >=25 AND Age <35 THEN "25-34"
    WHEN Age >=35 AND Age < 45 THEN "35-44"
    WHEN Age >=45  THEN "45-60"
  END AS FaixaEtaria,
FROM projeto-ibm-hr.employee.employee_attrition;

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
ORDER BY FaixaEtaria;


--Análise por Gênero

SELECT Gender,
  COUNT(EmployeeNumber) AS TotalFunc,
  SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END) AS DesligadosFunc,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/(SELECT COUNT(EmployeeNumber) FROM projeto-ibm-hr.employee.employee_attrition WHERE Attrition = true),2),"%") AS PorcentagemTotal,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/COUNT(EmployeeNumber),2),"%") AS TaxaAtrito
FROM projeto-ibm-hr.employee.employee_attrition
GROUP BY Gender;


--Análise pelo Grau de Escolaridade

SELECT 
  CASE 
    WHEN Education = 1 THEN 'Below College'
    WHEN Education = 2 THEN 'College'
    WHEN Education = 3 THEN 'Bachelor'
    WHEN Education = 4 THEN 'Master'
    WHEN Education = 5 THEN  'Doctor'
  END AS GrauEscolaridade
FROM projeto-ibm-hr.employee.employee_attrition;

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
GROUP BY GrauEscolaridade;

--Análise por Estado Civil

SELECT 
  MaritalStatus,
  COUNT(EmployeeNumber) AS TotalFunc,
  SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END) AS DesligadosFunc,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/ (SELECT COUNT(EmployeeNumber)FROM projeto-ibm-hr.employee.employee_attrition WHERE Attrition = true),2),"%") AS PorcentagemTotal,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/COUNT(EmployeeNumber),2),"%") AS TaxaAtrito
FROM projeto-ibm-hr.employee.employee_attrition
GROUP BY MaritalStatus;

--Análise por Tempo de Empresa

SELECT 
  ROUND(AVG(YearsAtCompany),2) AS MediaTempoEmpresa,
  MIN(YearsAtCompany) AS MinTempoEmpresa,
  MAX(YearsAtCompany) AS MaxTempoEmpresa
FROM projeto-ibm-hr.employee.employee_attrition;


SELECT
  CASE 
   WHEN YearsAtCompany < 3 THEN "0-2"
   WHEN YearsAtCompany >=3 AND YearsAtCompany < 6 THEN "3-5"
   WHEN YearsAtCompany >=6 AND YearsAtCompany < 11 THEN "5-10"
   WHEN YearsAtCompany >=11 AND YearsAtCompany < 21 THEN "11-20"
   WHEN YearsAtCompany >=21 AND YearsAtCompany < 31 THEN "21-30"
   WHEN YearsAtCompany >=31 AND YearsAtCompany < 41 THEN "31-40"
  END AS AnosEmpresa
FROM projeto-ibm-hr.employee.employee_attrition;

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
GROUP BY AnosEmpresa;

--Análise Salarial

SELECT 
  ROUND(AVG(MonthlyIncome),2) AS SalarioMedio,
  MIN(MonthlyIncome) AS SalarioMin,
  MAX(MonthlyIncome) AS SalarioMax
FROM projeto-ibm-hr.employee.employee_attrition;


SELECT 
  ROUND(AVG(MonthlyIncome),2) AS SalarioMedio,
  MIN(MonthlyIncome) AS SalarioMin,
  MAX(MonthlyIncome) AS SalarioMax
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = false;

SELECT 
  ROUND(AVG(MonthlyIncome),2) AS SalarioMedio,
  MIN(MonthlyIncome) AS SalarioMin,
  MAX(MonthlyIncome) AS SalarioMax
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = true;


--Análise por Departamento

SELECT 
  Department,
  COUNT(EmployeeNumber) AS TotalFunc,
  SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END) AS TotalDesligados,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/ (SELECT COUNT(EmployeeNumber) FROM projeto-ibm-hr.employee.employee_attrition WHERE Attrition = true),2), "%") AS PorcentagemTotalDesligados,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/COUNT(EmployeeNumber),2),"%") AS TaxaAtrito
FROM projeto-ibm-hr.employee.employee_attrition
GROUP BY Department;


--Departamento X Salário

SELECT 
  Department,
  ROUND(AVG(MonthlyIncome),2) AS MediaSal,
  MIN(MonthlyIncome) AS MinSal,
  MAX(MonthlyIncome) AS MaxSal
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = false
GROUP BY(Department);

SELECT 
  Department,
  ROUND(AVG(MonthlyIncome),2) AS MediaSal,
  MIN(MonthlyIncome) AS MinSal,
  MAX(MonthlyIncome) AS MaxSal
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = true
GROUP BY(Department);

--Departamento X Satisfação com o Trabalho

SELECT 
  Department,
  ROUND(AVG(EnvironmentSatisfaction),2) AS SatisfacaoAmbiente,
  ROUND(AVG(JobInvolvement),2) AS EnvolvimentoTrabalho,
  ROUND(AVG(JobSatisfaction),2) AS SatisfacaoTrabalho,
  ROUND(AVG(RelationshipSatisfaction),2) AS SatisfacaoRelacionamentos
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = false
GROUP BY(Department);

SELECT 
  Department,
  ROUND(AVG(EnvironmentSatisfaction),2) AS SatisfacaoAmbiente,
  ROUND(AVG(JobInvolvement),2) AS EnvolvimentoTrabalho,
  ROUND(AVG(JobSatisfaction),2) AS SatisfacaoTrabalho,
  ROUND(AVG(RelationshipSatisfaction),2) AS SatisfacaoRelacionamentos
FROM projeto-ibm-hr.employee.employee_attrition
WHERE Attrition = true
GROUP BY(Department);


--Análise da Distância de casa para o trabalho

SELECT 
  ROUND(AVG(DistanceFromHome),2) AS DistanciaMedia,
  MIN(DistanceFromHome) AS DistanciaMin,
  MAX(DistanceFromHome) AS DistanciaMax
FROM projeto-ibm-hr.employee.employee_attrition;


SELECT 
 CASE
   WHEN DistanceFromHome > 0 AND DistanceFromHome <6 THEN "01-05"
   WHEN DistanceFromHome >= 6 AND DistanceFromHome < 11 THEN "06-10"
   WHEN DistanceFromHome >= 11 AND DistanceFromHome < 21 THEN "11-20"
   WHEN DistanceFromHome >=  21 AND DistanceFromHome < 30 THEN "21-29"
 END AS ClassificacaoDistancia
FROM projeto-ibm-hr.employee.employee_attrition
GROUP BY ClassificacaoDistancia
ORDER BY ClassificacaoDistancia;

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
ORDER BY ClassificacaoDistancia;

--Distância X Satisfação

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
ORDER BY ClassificacaoDistancia;

--Análise pela frequência de Viagens a Trabalho

SELECT 
  BusinessTravel,
  COUNT(EmployeeNumber) AS TotalFunc,
  SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)AS DesligadosFunc,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/(SELECT COUNT(EmployeeNumber) FROM projeto-ibm-hr.   employee.employee_attrition WHERE Attrition = true),2), "%") AS PorcentagemTotalDesligados,
  CONCAT(ROUND((SUM(CASE WHEN Attrition = true THEN 1 ELSE 0 END)*100)/COUNT(EmployeeNumber),2), "%") AS TaxaAtrito
FROM projeto-ibm-hr.employee.employee_attrition
GROUP BY BusinessTravel