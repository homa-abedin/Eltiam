
drop table if exists   dw..dimbill
GO

select * into dw..dimbill
from 
(
---------- cheque bargashti
select 
 r.id
 ,dc.id centerid
 , r.CustomerKey
 ,r.PaymentMethodLookup
 , r.DateKey
 , r.ChequeDateKey
 , r.Amount
 , r.number
 , r.AppliedAmount
 , a1.BouncedReceivableKey
 , N'برگشتی' kind
	, count(a2.SalesOrderKey)cntsalesorderkey

	,datediff(day,max(d5.date), DATEADD(day ,sum(DATEDIFF(day, getdate(), d2.date)*a2.AmountAllocated)/ sum(a2.AmountAllocated),GETDATE())) forjeasli
		, DATEDIFF(day,DATEADD(day ,sum(DATEDIFF(day, getdate(), d2.date)*a2.AmountAllocated)/ sum(a2.AmountAllocated),GETDATE()),max(d3.date)) takhir_tajil
	, case when max(d5.Date)>max(d2.date) then 1 else 0 end as season

	--,round (sum(a2.AmountAllocated * InvoiceDueDateDuration)/ sum( a2.AmountAllocated),0) AVGDue 

	--, avg( DATEDIFF(DAY, d2.Date, d3.Date) )  vosolshode
	--, avg( DATEDIFF(DAY, d2.Date, d4.Date) )  bayadvosolmishod
	, sum(InvoiceNetAmount)InvoiceNetAmount
	, sum(a2.DiscountAmount)DiscountAmount
	, sum(a2.AmountAllocated)AmountAllocated
from eltiam.ARPARAllocations a1
left join (select * from eltiam.ARPARAllocations) a2 on a1.BouncedReceivableKey=a2.ReceivableKey 
left join (select * from eltiam.ARPReceivables) r on r.id=a1.ReceivableKey
left join (select * from eltiam.ARPReceivables) r1 on r1.id=a2.ReceivableKey
left join (select * from eltiam.SLSSalesOrderHeaders) sales on sales.id=a2.SalesOrderKey
left join (select * from DimDate) d2 on d2.DateKey= sales.InvoicedueDate
left join (select * from DimDate) d3 on d3.DateKey= r.ChequeDateKey
left join (select * from DimDate) d4 on d4.DateKey= r1.ChequeDateKey
left join (select * from DimDate) d5 on d5.DateKey= sales.InvoiceDateKey
left join (select * from  [DW].[dbo].[dimcenter] where mycenter=1)dc on dc.centerkey=r.CenterKey

where a1.BouncedReceivableKey is not null and not  exists (select * from eltiam.ARPARAllocations where BouncedReceivableKey is not null and BouncedReceivableKey=a1.ReceivableKey)
--and r.id= 90503
and r.Id is not null
--and left(r.DateKey,4)=1400
group by 
 r.id
 ,dc.id
 , r.CustomerKey
 ,r.PaymentMethodLookup
 , r.DateKey
 , r.ChequeDateKey
 , r.Amount
 , r.number
 , r.AppliedAmount
 , a1.BouncedReceivableKey
 having count(a2.SalesOrderKey) <>0




 ----------------------- other
union 

 

select 
 r.id
 ,dc.id centerid
 , r.CustomerKey
 ,r.PaymentMethodLookup
 , r.DateKey
 , r.ChequeDateKey
 , r.Amount
 , r.number
 , r.AppliedAmount
 , a1.BouncedReceivableKey
 , N'تسویه شده' kind
	, count(isnull(a1.SalesOrderKey,0))cntsalesorderkey
	,datediff(day,max(d4.date), DATEADD(day ,sum(DATEDIFF(day, getdate(), d2.date)*AmountAllocated)/ sum(AmountAllocated),GETDATE())) forjeasli
	, DATEDIFF(day,DATEADD(day ,sum(DATEDIFF(day, getdate(), d2.date)*AmountAllocated)/ sum(AmountAllocated),GETDATE()),max(d3.date)) takhir_tajil
	, case when max(d5.Date)>max(d2.date) then 1 else 0 end as season
	, sum(InvoiceNetAmount)InvoiceNetAmount
	, sum(a1.DiscountAmount)DiscountAmount
	, sum(a1.AmountAllocated)AmountAllocated


from eltiam.ARPARAllocations a1
left join (select * from eltiam.ARPReceivables) r on r.id=a1.ReceivableKey
left join (select * from eltiam.SLSSalesOrderHeaders) sales on sales.id=a1.SalesOrderKey
left join (select * from DimDate) d2 on d2.DateKey= sales.InvoicedueDate
left join (select * from DimDate) d3 on d3.DateKey= r.ChequeDateKey
left join (select * from DimDate) d4 on d4.DateKey= sales.InvoiceDateKey
left join (select * from DimDate) d5 on d5.DateKey= r.DateKey
left join (select * from  [DW].[dbo].[dimcenter] where mycenter=1)dc on dc.centerkey=r.CenterKey
where 
a1.BouncedReceivableKey is null and not  exists (select * from eltiam.ARPARAllocations where BouncedReceivableKey is not null and BouncedReceivableKey=a1.ReceivableKey)
group by 
 r.id
, dc.id
 , r.CustomerKey
 ,r.PaymentMethodLookup
 , r.DateKey
 , r.ChequeDateKey
 , r.Amount
 , r.number
 , r.AppliedAmount
 , a1.BouncedReceivableKey


 )a



 select * from dw..dimcenter  where  id= 28

 select sum(AmountAllocated)/ 1076157385073, season from dw..dimbill
 where centerid= 28
  and datekey between 14030101 and 14031229
  group by season
