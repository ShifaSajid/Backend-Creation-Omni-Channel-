/****** Script for SelectTopNRows command from SSMS  ******/
SELECT p.Species,P.Manufacturer,P.Brand,P.dt_,SUM(cp_) as MAT
FROM
(
select A.Species,A.Manufacturer,A.Brand,A.dt AS dt_,A.pdt,B.dt
,CASE WHEN B.DT >=A.pdt and B.dt<=A.dt then 1 end as cc
,CASE WHEN B.DT >=A.pdt and B.dt<=A.dt then B.[Value] ELSE 0 end as cp_
from
(
select *,CONVERT( DATE ,'01/'+mm+'/'+yy ,103) AS dt,CONVERT( DATE ,'01/'+mm+'/'+py ,103) AS pdt
from
(
SELECT [Species]
      ,[Manufacturer]
      ,[Brand]
      ,cast([Year] as nvarchar(20)) as yy
      ,cast([Month] as nvarchar(20)) as mm
	  ,cast([Year]-1 as nvarchar(20)) as py
	  ,[Value]
  FROM [Backend Creation].[dbo].[shifa]
  ) as a
  ) as A
inner join
(
select *,CONVERT( DATE ,'01/'+mm+'/'+yy ,103) AS dt
from
(
SELECT [Species]
      ,[Manufacturer]
      ,[Brand]
      ,cast([Year] as nvarchar(20)) as yy
      ,cast([Month] as nvarchar(20)) as mm
	  ,cast([Year]-1 as nvarchar(20)) as py
	  ,[Value]
  FROM [Backend Creation].[dbo].[shifa]
  ) as a
  ) as B
on A.Species=B.Species
AND A.Manufacturer=B.Manufacturer
AND A.Brand=B.Brand
AND A.DT>=B.dt
--ORDER BY A.dt
) AS P
GROUP BY P.Species,P.Manufacturer,P.Brand,P.dt_