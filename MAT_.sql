/****** Script for SelectTopNRows command from SSMS  ******/
with base_cte as
(
SELECT p.SPECIES
       ,P.CATEGORY
	   ,P.MANUFACTURER
	   ,P.BRAND
       ,P.PROPHY
	   ,P.REGION
	   ,P.[MONTH]
	   ,P.[YEAR]
	   ,P.UNITS
	   ,P.REVENUE
--,P.dt_
       ,SUM(cpu_) as MAT_doses
	   ,sum(cpr_) as MAT_revenue
FROM
(
	select A.SPECIES,A.CATEGORY,A.MANUFACTURER,A.BRAND
			,A.PROPHY,A.REGION,A.[MONTH],A.[YEAR],A.UNITS,A.REVENUE,A.dt AS dt_,A.pdt,B.dt
			,CASE WHEN B.dt >=A.pdt and B.dt<=A.dt then 1 end as cc
			,CASE WHEN B.dt >=A.pdt and B.dt<=A.dt then B.UNITS ELSE 0 end as cpu_
			,CASE WHEN B.dt >=A.pdt and B.dt<=A.dt then B.REVENUE ELSE 0 end as cpr_
	from
	(
		select *,CONVERT( DATE ,'01/'+mm+'/'+yy ,103) AS dt,CONVERT( DATE ,'01/'+mm+'/'+py ,103) AS pdt
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
			  ,cast([YEAR] as nvarchar(20)) as yy
			  ,cast([MONTH] as nvarchar(20)) as mm
			  ,cast([YEAR]-1 as nvarchar(20)) as py
			  ,[UNITS]
			  ,[REVENUE]
		FROM  [Backend Creation].[dbo].[Sheet1$]
		--where SPECIES='Canine' and CATEGORY='CHEWS' and MANUFACTURER='Hills' and BRAND='PrescriptionDiet' 
		--AND PROPHY=0
		  ) as a
	  ) as A
	inner join
	(
		select *,CONVERT( DATE ,'01/'+mm+'/'+yy ,103) AS dt
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
			  ,cast([YEAR] as nvarchar(20)) as yy
			  ,cast([MONTH] as nvarchar(20)) as mm
			  ,cast([YEAR]-1 as nvarchar(20)) as py
			  ,[UNITS]
			  ,[REVENUE]
		FROM [Backend Creation].[dbo].[Sheet1$]
		--where SPECIES='Canine' and CATEGORY='CHEWS' and MANUFACTURER='Hills' and BRAND='PrescriptionDiet' 
		--AND PROPHY=0
		  ) as a
	  ) as B
	on A.[SPECIES]=B.[SPECIES]
	and A.CATEGORY=B.CATEGORY
	AND A.MANUFACTURER=B.MANUFACTURER
	AND A.BRAND=B.BRAND
	AND A.PROPHY=B.PROPHY
	AND A.REGION=B.REGION
	AND A.DT>=B.dt
	--ORDER BY A.REGION,A.dt
) AS P
GROUP BY p.SPECIES,P.CATEGORY,P.MANUFACTURER,P.BRAND
         ,P.PROPHY,P.REGION,P.[MONTH],P.[YEAR],P.UNITS,P.REVENUE,P.dt_
--ORDER BY p.SPECIES,P.CATEGORY,P.MANUFACTURER,P.BRAND
--         ,P.PROPHY,P.REGION,P.[YEAR],P.[MONTH]
)

select A.SPECIES,A.CATEGORY,A.MANUFACTURER,A.BRAND,A.PROPHY,A.REGION,A.[MONTH],A.[YEAR]
       ,A.UNITS,A.REVENUE,A.MAT_doses ,isnull(B.MAT_doses,0)  AS PMAT_doses
	   ,A.MAT_revenue,isnull(B.MAT_revenue,0)  as PMAT_revenue
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
