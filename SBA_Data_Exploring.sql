/****** Script for SelectTopNRows command from SSMS  ******/

--EXPLORING THE DATA


SELECT *
  FROM [PortfolioDB].[dbo].[sba_public_data]


  --What is the summary of all approved PPP Loans

SELECT 
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(InitialApprovalAmount) AS Approved_Amount, 
	AVG(InitialApprovalAmount) AS Average_Loan_Size
FROM [PortfolioDB].[dbo].[sba_public_data]


--Compare how much Loan was given in 2020 and 2021


SELECT 
    YEAR(DateApproved) AS Year_Approved,
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(InitialApprovalAmount) AS Approved_Amount, 
	AVG(InitialApprovalAmount) AS Average_Loan_Size
FROM 
    [PortfolioDB].[dbo].[sba_public_data]
WHERE 
     year(DateApproved) = 2020
GROUP BY 
     year(DateApproved)

UNION

SELECT 
    YEAR(DateApproved) AS Year_Approved,
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(InitialApprovalAmount) AS Approved_Amount, 
	AVG(InitialApprovalAmount) AS Average_Loan_Size
FROM 
    [PortfolioDB].[dbo].[sba_public_data]
WHERE 
     year(DateApproved) = 2021
GROUP BY 
     year(DateApproved)


--How many unique financial institutions (Originating_Lenders) were involved in the approved PPP loans in 2020 as compared to 2021

SELECT 
    COUNT(DISTINCT (OriginatingLender)) AS Originating_Lender,
    YEAR(DateApproved) AS Year_Approved,
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(InitialApprovalAmount) AS Approved_Amount, 
	AVG(InitialApprovalAmount) AS Average_Loan_Size
FROM 
    [PortfolioDB].[dbo].[sba_public_data]
WHERE 
     year(DateApproved) = 2020
GROUP BY 
     year(DateApproved)

UNION

SELECT 
    COUNT(DISTINCT (OriginatingLender)) AS Originating_Lender,
    YEAR(DateApproved) AS Year_Approved,
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(InitialApprovalAmount) AS Approved_Amount, 
	AVG(InitialApprovalAmount) AS Average_Loan_Size
FROM 
    [PortfolioDB].[dbo].[sba_public_data]
WHERE 
     year(DateApproved) = 2021
GROUP BY 
     year(DateApproved)


--Top 15 Originating Lenders by loan count, total amount approved and average amount approved in 2020 and 2021

SELECT TOP 15
    OriginatingLender,
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(InitialApprovalAmount) AS Approved_Amount, 
	AVG(InitialApprovalAmount) AS Average_Loan_Size
FROM 
    [PortfolioDB].[dbo].[sba_public_data]
WHERE 
     year(DateApproved) = 2021
GROUP BY 
     OriginatingLender
ORDER BY 3 DESC


SELECT TOP 15
    OriginatingLender,
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(InitialApprovalAmount) AS Approved_Amount, 
	AVG(InitialApprovalAmount) AS Average_Loan_Size
FROM 
    [PortfolioDB].[dbo].[sba_public_data]
WHERE 
     year(DateApproved) = 2020
GROUP BY 
     OriginatingLender
ORDER BY 3 DESC


--Top 20 Industries that received the PPP Loans in 2020 AND 2021

SELECT	TOP 20
    d.Sector,
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(InitialApprovalAmount) AS Approved_Amount, 
	AVG(InitialApprovalAmount) AS Average_Loan_Size
FROM 
    [PortfolioDB].[dbo].[sba_public_data] AS p
	INNER JOIN [PortfolioDB].[dbo].[sba_naics_sector_codes_description] AS d
	   ON LEFT(p.NAICSCode, 2) = d.LookupCodes
WHERE 
     year(DateApproved) = 2020
GROUP BY 
     d.Sector
ORDER BY 3 DESC


SELECT	TOP 20
    d.Sector,
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(InitialApprovalAmount) AS Approved_Amount, 
	AVG(InitialApprovalAmount) AS Average_Loan_Size
FROM 
    [PortfolioDB].[dbo].[sba_public_data] AS p
	INNER JOIN [PortfolioDB].[dbo].[sba_naics_sector_codes_description] AS d
	   ON LEFT(p.NAICSCode, 2) = d.LookupCodes
WHERE 
     year(DateApproved) = 2021
GROUP BY 
     d.Sector
ORDER BY 3 DESC

--Percentage of the Loan amount approved to the Top 20 industries as against the Total PPP loan approved

WITH CTE AS
(
SELECT	TOP 20
    d.Sector,
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(InitialApprovalAmount) AS Approved_Amount, 
	AVG(InitialApprovalAmount) AS Average_Loan_Size
FROM 
    [PortfolioDB].[dbo].[sba_public_data] AS p
	INNER JOIN [PortfolioDB].[dbo].[sba_naics_sector_codes_description] AS d
	   ON LEFT(p.NAICSCode, 2) = d.LookupCodes
WHERE 
     year(DateApproved) = 2020
GROUP BY 
     d.Sector
--ORDER BY 3 DESC
)
SELECT Sector, Number_of_Approved, Approved_Amount, Average_Loan_Size,
Approved_Amount/SUM(Approved_Amount) OVER () * 100 AS Percent_by_Amount
FROM CTE
ORDER BY Approved_Amount DESC



WITH CTE AS
(
SELECT	TOP 20
    d.Sector,
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(InitialApprovalAmount) AS Approved_Amount, 
	AVG(InitialApprovalAmount) AS Average_Loan_Size
FROM 
    [PortfolioDB].[dbo].[sba_public_data] AS p
	INNER JOIN [PortfolioDB].[dbo].[sba_naics_sector_codes_description] AS d
	   ON LEFT(p.NAICSCode, 2) = d.LookupCodes
WHERE 
     year(DateApproved) = 2021
GROUP BY 
     d.Sector
--ORDER BY 3 DESC
)
SELECT Sector, Number_of_Approved, Approved_Amount, Average_Loan_Size,
Approved_Amount/SUM(Approved_Amount) OVER () * 100 AS Percent_by_Amount
FROM CTE
ORDER BY Approved_Amount DESC


---How much of the PPP Loans have been fully forgiven 

SELECT 
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(CurrentApprovalAmount) AS Current_Approved_Amount, 
	AVG(CurrentApprovalAmount) AS Current_Average_Loan_Size,
	SUM(ForgivenessAmount) AS Amount_Forgiven
FROM 
    [PortfolioDB].[dbo].[sba_public_data]
WHERE 
     year(DateApproved) = 2020
ORDER BY 3 DESC


SELECT 
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(CurrentApprovalAmount) AS Current_Approved_Amount, 
	AVG(CurrentApprovalAmount) AS Current_Average_Loan_Size,
	SUM(ForgivenessAmount) AS Amount_Forgiven
FROM 
    [PortfolioDB].[dbo].[sba_public_data]
WHERE 
     year(DateApproved) = 2021
ORDER BY 3 DESC



--Percentage of the PPP Loan that has been Forgiven as against the Current Approved Amount.

SELECT 
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(CurrentApprovalAmount) AS Current_Approved_Amount, 
	AVG(CurrentApprovalAmount) AS Current_Average_Loan_Size,
	SUM(ForgivenessAmount) AS Amount_Forgiven,
	SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount) * 100 AS Percent_Forgiven
FROM 
    [PortfolioDB].[dbo].[sba_public_data]
WHERE 
     year(DateApproved) = 2020
ORDER BY 3 DESC


SELECT 
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(CurrentApprovalAmount) AS Current_Approved_Amount, 
	AVG(CurrentApprovalAmount) AS Current_Average_Loan_Size,
	SUM(ForgivenessAmount) AS Amount_Forgiven,
	SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount) * 100 AS Percent_Forgiven
FROM 
    [PortfolioDB].[dbo].[sba_public_data]
WHERE 
     year(DateApproved) = 2021
ORDER BY 3 DESC


--Total Amount and Percentage of the PPP Loan that have been forgiven(Both 2020 and 2021)

SELECT 
    COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(CurrentApprovalAmount) AS Current_Approved_Amount, 
	AVG(CurrentApprovalAmount) AS Current_Average_Loan_Size,
	SUM(ForgivenessAmount) AS Amount_Forgiven,
	SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount) * 100 AS Percent_Forgiven
FROM 
    [PortfolioDB].[dbo].[sba_public_data]


--Year and Month with the highest PPP loans approved

SELECT
    YEAR(DateApproved) AS Year_Approved,
	MONTH(DateApproved) AS Month_Approved,
	COUNT(LoanNumber) AS Number_of_Approved, 
    SUM(InitialApprovalAmount) AS Approved_Amount, 
	AVG(InitialApprovalAmount) AS Average_Loan_Size
FROM
    [PortfolioDB].[dbo].[sba_public_data]
GROUP BY
    YEAR(DateApproved),
	MONTH(DateApproved)
ORDER BY 4 DESC