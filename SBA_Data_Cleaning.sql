/****** Script for SelectTopNRows command from SSMS  ******/

CLEANING THE DATA

--1. Reduce the records and have only the records that we will be working with. We are only interesed in the Sector Where the NAICS_Codes are blank

SELECT [NAICS_Codes]
      ,[NAICS_Industry_Description]
  FROM [PortfolioDB].[dbo].[sba_industry_standards]
  WHERE [NAICS_Codes] = ''


  --We will not need the [NAICS_Codes] 
  SELECT 
      [NAICS_Industry_Description]
  FROM [PortfolioDB].[dbo].[sba_industry_standards]
  WHERE [NAICS_Codes] = ''


  --We have to get the Sector numbers from the Description Column and name them as LookupCodes
  SELECT 
      [NAICS_Industry_Description],
	 SUBSTRING([NAICS_Industry_Description], 8, 2) AS LookupCodes
  FROM [PortfolioDB].[dbo].[sba_industry_standards]
  WHERE [NAICS_Codes] = ''

  --Remove rows that don't have Sector numbers to extract. Example, row 7 and 9
  --We will introduce a conditional statement to remove them. Either using an IIF clause or Case clause.

   SELECT 
      [NAICS_Industry_Description],
	IIF([NAICS_Industry_Description] LIKE '%-%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS LookupCodes
  FROM [PortfolioDB].[dbo].[sba_industry_standards]
  WHERE [NAICS_Codes] = ''

  SELECT 
      [NAICS_Industry_Description],
	IIF([NAICS_Industry_Description] LIKE '%-%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS LookupCodes_if,
	CASE WHEN [NAICS_Industry_Description] LIKE '%-%' THEN SUBSTRING([NAICS_Industry_Description], 8, 2) END AS LookupCodes_case
  FROM [PortfolioDB].[dbo].[sba_industry_standards]
  WHERE [NAICS_Codes] = ''


  SELECT 
      [NAICS_Industry_Description],
	IIF([NAICS_Industry_Description] LIKE '%-%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS LookupCodes_if
	--CASE WHEN [NAICS_Industry_Description] LIKE '%-%' THEN SUBSTRING([NAICS_Industry_Description], 8, 2) END AS LookupCodes_case
  FROM [PortfolioDB].[dbo].[sba_industry_standards]
  WHERE [NAICS_Codes] = ''

  
  --We need to extract the Sector from the Description Column

  SELECT 
      [NAICS_Industry_Description],
	IIF([NAICS_Industry_Description] LIKE '%-%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS LookupCodes,
	SUBSTRING([NAICS_Industry_Description], CHARINDEX('-',[NAICS_Industry_Description] ) + 1 , LEN([NAICS_Industry_Description]) ) AS Sector
  FROM [PortfolioDB].[dbo].[sba_industry_standards]
  WHERE [NAICS_Codes] = ''
  
  
  
  --Remove rows that will not be needed (row 7 and 9)

  SELECT 
      [NAICS_Industry_Description],
	IIF([NAICS_Industry_Description] LIKE '%-%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS LookupCodes,
	IIF([NAICS_Industry_Description] LIKE '%-%', SUBSTRING([NAICS_Industry_Description], CHARINDEX('-',[NAICS_Industry_Description] ) + 1 , LEN([NAICS_Industry_Description]) ), '') AS Sector
  FROM [PortfolioDB].[dbo].[sba_industry_standards]
  WHERE [NAICS_Codes] = ''


  SELECT *
  FROM(
  
  SELECT 
      [NAICS_Industry_Description],
	IIF([NAICS_Industry_Description] LIKE '%-%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS LookupCodes,
	IIF([NAICS_Industry_Description] LIKE '%-%', SUBSTRING([NAICS_Industry_Description], CHARINDEX('-',[NAICS_Industry_Description] ) + 1 , LEN([NAICS_Industry_Description]) ), '') AS Sector
  FROM [PortfolioDB].[dbo].[sba_industry_standards]
  WHERE [NAICS_Codes] = ''

  ) AS MAIN
WHERE LookupCodes != ''


--Remove leading spaces in front of each specific Sector. Example, leading space if front of (' Agriculture, Forestry, Fishing and Hunting') by using LTRIM

SELECT *
  FROM(
  
  SELECT 
      [NAICS_Industry_Description],
	IIF([NAICS_Industry_Description] LIKE '%-%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS LookupCodes,
	IIF([NAICS_Industry_Description] LIKE '%-%', LTRIM(SUBSTRING([NAICS_Industry_Description], CHARINDEX('-',[NAICS_Industry_Description] ) + 1 , LEN([NAICS_Industry_Description]) )), '') AS Sector
  FROM [PortfolioDB].[dbo].[sba_industry_standards]
  WHERE [NAICS_Codes] = ''

  ) AS MAIN
WHERE LookupCodes != ''


--Put the records that we will be working with into a Table

SELECT *
INTO sba_naics_sector_codes_description
  FROM(
  
  SELECT 
      [NAICS_Industry_Description],
	IIF([NAICS_Industry_Description] LIKE '%-%', SUBSTRING([NAICS_Industry_Description], 8, 2), '') AS LookupCodes,
	IIF([NAICS_Industry_Description] LIKE '%-%', LTRIM(SUBSTRING([NAICS_Industry_Description], CHARINDEX('-',[NAICS_Industry_Description] ) + 1 , LEN([NAICS_Industry_Description]) )), '') AS Sector
  FROM [PortfolioDB].[dbo].[sba_industry_standards]
  WHERE [NAICS_Codes] = ''

  ) AS MAIN
WHERE LookupCodes != ''



--Lets inspect the new Table [sba_naics_sector_codes_description]

SELECT TOP (1000) [NAICS_Industry_Description]
      ,[LookupCodes]
      ,[Sector]
  FROM [PortfolioDB].[dbo].[sba_naics_sector_codes_description]

  --Insert the missing LookupCodes that were not included

  INSERT INTO [PortfolioDB].[dbo].[sba_naics_sector_codes_description]
    VALUES
  ('Sector 31 – 33 – Manufacturing', 32, 'Manufacturing'), 
  ('Sector 31 – 33 – Manufacturing', 33, 'Manufacturing'), 
  ('Sector 44 - 45 – Retail Trade', 45, 'Retail Trade'),
  ('Sector 48 - 49 – Transportation and Warehousing', 49, 'Transportation and Warehousing')

  UPDATE [PortfolioDB].[dbo].[sba_naics_sector_codes_description]
  SET Sector ='Manufacturing'
  WHERE LookupCodes = 31

  UPDATE [PortfolioDB].[dbo].[sba_naics_sector_codes_description]
  SET Sector ='Retail Trade'
  WHERE LookupCodes = 44

  UPDATE [PortfolioDB].[dbo].[sba_naics_sector_codes_description]
  SET Sector ='Transportation and Warehousing'
  WHERE LookupCodes = 48

 --Check to see if every update was effected

 SELECT TOP (1000) [NAICS_Industry_Description]
      ,[LookupCodes]
      ,[Sector]
  FROM [PortfolioDB].[dbo].[sba_naics_sector_codes_description]
  ORDER BY LookupCodes