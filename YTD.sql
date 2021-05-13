/****** Script for SelectTopNRows command from SSMS  ******/
select A.SPECIES,A.CATEGORY,A.MANUFACTURER,A.BRAND,A.PROPHY,A.REGION,A.[MONTH],A.[YEAR]
       ,A.UNITS,A.YTD_doses ,CAST(isnull(B.YTD_doses,0) AS DECIMAL(12,4)) AS PYTD_doses
	   ,A.REVENUE,A.YTD_revenue,CAST(isnull(B.YTD_revenue,0) AS DECIMAL(12,4)) as PYTD_revenue 
from
(
SELECT [SPECIES]
      ,[CATEGORY]
      ,ISNULL([MANUFACTURER],'Blank') as [MANUFACTURER]
      ,[BRAND]
      ,[PROPHY]
      ,[REGION]
      ,[MONTH]
      ,[YEAR]
      , [UNITS]
      , [REVENUE]
      ,CAST(sum([UNITS]) OVER (partition by [SPECIES],[CATEGORY],[MANUFACTURER],[BRAND],[PROPHY],[REGION],[YEAR]
	               order by 
				   --[SPECIES],[CATEGORY],[MANUFACTURER],[BRAND],
				   [PROPHY],[REGION],[YEAR],[MONTH] )AS DECIMAL(12,4)) as YTD_doses
	  ,CAST(sum([REVENUE]) OVER (partition by [SPECIES],[CATEGORY],[MANUFACTURER],[BRAND],[PROPHY],[REGION],[YEAR]
	               order by 
				   --[SPECIES],[CATEGORY],[MANUFACTURER],[BRAND],
				   [PROPHY],[REGION],[YEAR],[MONTH] ) AS DECIMAL(12,4))as YTD_revenue
  FROM [Backend Creation].[dbo].[Sheet1$]
 -- where SPECIES='Canine' and CATEGORY='CHEWS' and MANUFACTURER='Hills' and BRAND='PrescriptionDiet' 
 -- AND PROPHY=0
 ) as A
 LEFT JOIN
 (
SELECT [SPECIES]
      ,[CATEGORY]
      ,ISNULL([MANUFACTURER],'Blank') as [MANUFACTURER]
      ,[BRAND]
      ,[PROPHY]
      ,[REGION]
      ,[MONTH]
      ,[YEAR]
      ,[UNITS]
      ,[REVENUE]
      ,sum([UNITS]) OVER (partition by [SPECIES],[CATEGORY],[MANUFACTURER],[BRAND],[PROPHY],[REGION],[YEAR]
	               order by 
				   --[SPECIES],[CATEGORY],[MANUFACTURER],[BRAND],
				   [PROPHY],[REGION],[YEAR],[MONTH] ) as YTD_doses
	  ,sum([REVENUE]) OVER (partition by [SPECIES],[CATEGORY],[MANUFACTURER],[BRAND],[PROPHY],[REGION],[YEAR]
	               order by 
				   --[SPECIES],[CATEGORY],[MANUFACTURER],[BRAND],
				   [PROPHY],[REGION],[YEAR],[MONTH] ) as YTD_revenue
  FROM [Backend Creation].[dbo].[Sheet1$]
 -- where SPECIES='Canine' and CATEGORY='CHEWS' and MANUFACTURER='Hills' and BRAND='PrescriptionDiet' 
  --AND PROPHY=0
 ) as B
 ON A.SPECIES=B.SPECIES
 AND A.CATEGORY=B.CATEGORY
 AND A.MANUFACTURER=B.MANUFACTURER
 AND A.BRAND=B.BRAND
 AND A.PROPHY=B.PROPHY
 AND A.REGION=B.REGION
 AND A.[MONTH]=B.[MONTH]
 AND A.[YEAR]-B.[YEAR]=1


 ORDER BY A.SPECIES,A.CATEGORY,A.MANUFACTURER,A.BRAND,A.PROPHY,A.REGION,A.[YEAR],A.[MONTH]
       