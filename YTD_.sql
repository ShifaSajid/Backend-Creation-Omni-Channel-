/****** Script for SelectTopNRows command from SSMS  ******/
with base_cte as
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
 ) 

select A.SPECIES,A.CATEGORY,A.MANUFACTURER,A.BRAND,A.PROPHY,A.REGION,A.[MONTH],A.[YEAR]
       ,A.UNITS,A.REVENUE,A.YTD_doses
	   ,isnull(B.YTD_doses,0) as PYTD_doses
	   ,A.YTD_revenue
	   ,isnull(B.YTD_revenue,0) AS PYTD_revenue
 from base_cte A
 left join base_cte B
 on A.SPECIES=B.SPECIES
 AND A.CATEGORY=B.CATEGORY
 AND A.MANUFACTURER=B.MANUFACTURER
 AND A.BRAND=B.BRAND
 AND A.PROPHY=B.PROPHY
 AND A.REGION=B.REGION
 AND A.[MONTH]=B.[MONTH]
 AND A.[YEAR]-B.[YEAR]=1
 ORDER BY A.SPECIES,A.CATEGORY,A.MANUFACTURER,A.BRAND,A.PROPHY,A.REGION,A.[YEAR],A.[MONTH]
