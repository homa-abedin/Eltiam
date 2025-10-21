
SELECT  datekey FDatekey
      ,[Jalali] FJalali
	  ,case when  lead(datekey)over ( order by datekey) is null then (
            SELECT TOP 1 datekey 
            FROM [Stage].[dbo].[dimdate] AS d2 
            WHERE d2.datekey > d1.datekey 
            ORDER BY d2.datekey
        ) else  lead(datekey)over ( order by datekey) end as LDatekey
	  ,case when  lead([Jalali])over ( order by [Jalali]) is null then (
            SELECT TOP 1 [Jalali] 
            FROM [Stage].[dbo].[dimdate] AS d2 
            WHERE d2.datekey > d1.datekey 
            ORDER BY d2.datekey
        ) else  lead([Jalali])over ( order by [Jalali]) end as LJalai
, Null as Eltiam
  , Null as Hejrat
  , Null as Daya
  , Null as Qasem
  , Null as Mahya
  , Null as Momtaz
  , Null as Hasti
  , Null as Samen
  , Null as Alborz
  , Null as Razi
  , Null as Ferdos
  , Null as Nokhbegan
  , Null as toba
  , Null as Behestan
  , Null as Shaya
  into Stage.kharazmi.FetchWebservice
  FROM [Stage].[dbo].[dimdate]d1
  where datekey between 14030101 and 14061230



