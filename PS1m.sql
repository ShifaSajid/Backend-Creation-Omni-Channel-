/****** Script for SelectTopNRows command from SSMS  ******/
select B.SPECIES
       ,B.CATEGORY
	   ,B.MANUFACTURER
	   ,B.BRAND
	   ,B.PROPHY
	   ,B.REGION
	   ,B.[MONTH]
	   ,B.[YEAR]
	   ,B.UNITS
	   ,B.REVENUE
	   ,isnull(cast(UNITS/Previous_revenue as decimal(10,4)),0) as PS1m
from(
select * ,case when [MONTH]-Pvm=1 or [MONTH]-Pvm=-11 then Pvm end  as  Previous_month 
         ,case when [MONTH]-Pvm=1 or [MONTH]-Pvm=-11 then Prv end  as  Previous_revenue 
from
(
SELECT [SPECIES]
      ,[CATEGORY]
      ,[MANUFACTURER]
      ,[BRAND]
      ,[PROPHY]
      ,[REGION]
      ,[MONTH]
      ,[YEAR]
      ,[UNITS]
      ,[REVENUE]
      ,LAG([MONTH]) OVER (partition by [SPECIES],[CATEGORY],[MANUFACTURER],[BRAND],[PROPHY],[REGION]
	                order by [SPECIES],[CATEGORY],[MANUFACTURER],[BRAND],[PROPHY],[REGION],[YEAR],[MONTH] ) as Pvm
	  ,LAG([REVENUE]) OVER (partition by [SPECIES],[CATEGORY],[MANUFACTURER],[BRAND],[PROPHY],[REGION]
	                order by [SPECIES],[CATEGORY],[MANUFACTURER],[BRAND],[PROPHY],[REGION],[YEAR],[MONTH] ) as Prv

	
  FROM [Backend Creation].[dbo].[Sheet1$]
 -- where SPECIES='Canine' and CATEGORY='CHEWS' and MANUFACTURER='BIAH' and BRAND='OraVet' 
--  AND PROPHY=1
 ) as A 
 ) as B