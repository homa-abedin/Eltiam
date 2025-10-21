
drop table if exists dw..soratmali
GO

select   Jalali_Year, startdate,enddate,    season,sorat
	--, ROW_NUMBER()over (partition by Jalali_Year,Season order by Jalali_Year,Season, sorat) RowNumber
	,sum(Debit)Debit
	, sum(Credit)Credit
	,sum(Debit- Credit) debitbalanced
	into dw..soratmali
from (
	select 
	case 
		when da.IdL3 in (51,52 	,53	,54	,55	,56	,314	,316, 62,63,64,315, 274,304,319)     then N'دارایی ثابت مشهود'
		when  da.IdL3 in ( 57,58 ,59 ,60 ,61 ,66)  then N'دارایی نامشهود'
		 when da.idl3 = 402 then N'دریافتنی بلند مدت'
		when da.IdL3= 6 then N'ذخیره مزایای پایان خدمت کارکنان'
		when da.idl3 in (26,27	,41	,401,28	,29	,42	,43	,44	,45	,46	,47	,48	,267,268,318,343,391,414,416,418,419,425,427,431,433,435,442,450,451,384,422,452,453) then N'دریافتنی های تجاری و سایر دریافتنی ها'
		when da.IdL3 in (95)  then N'مالیات پرداختنی'
		when  da.IdL3 in (45,67 ,68 ,290,325,88 ,89 ,90 ,85 ,86 ,87 ,91 ,92 ,93   ,94 ,96 ,97 ,98 ,99 ,100,101,102,103,104,105,106,317,323,324,326,339,340,359,382,393,398,404,407,412,413,424,432,443,464,108,109,110,111,374,375,376,389,7)  then  N'پرداختنی های تجاری و سایرپرداختنی ها'
		when da.IdL3 in ( 35  ,38	,39	,49	,273	,319	,366	,437) then N'پیش پرداخت ها'
		when da.IdL3 in (439,440,441,423) then N'تسهیلات مالی'
		when da.IdL3 in (30,33,34,352) then N'%موجودی مواد و کالا%'
		--when IdL2 in ( 17) 
		when  da.IdL3  in (23,24,25,302,332,428,468)then  N'موجودی نقد'  
		--when  IdL2 in (25)  
		--when  IdL3 in (438) 
		--when  IdL3 in (115)  
		--when  IdL3 in (402) 	
		--when  IdL3 in (121) 
		else da.namel2
 
		--when d.idl2 = 27 then N'سود انباشته'
		--else NameL2
	end as sorat   
	
	,sum(Debit)Debit
	, sum(Credit)Credit
	,sum(Debit- Credit) debitbalanced
	,da.IdL3, da.IdL2, Jalali_Year
	, startdate,enddate,Season
	--into dw..soratmali
	  FROM dw..FactFinance fv
	  join (select * from dw..DimAccountL1_3)da on da.IdL3=fv.IDL3
	JOIN dimdate AS d ON d.datekey=fv.DateKey
	JOIN (SELECT * FROM [stage]..datefiscal) df ON d.datekey BETWEEN df.startdate AND  enddate
	WHERE   FINDocHeader_FINDocType not in (2,4)
	group by da.IdL3, da.IdL2, Jalali_Year, startdate,enddate,  da.namel2, season
	) a 
	group by   Jalali_Year, startdate,enddate,  sorat , season