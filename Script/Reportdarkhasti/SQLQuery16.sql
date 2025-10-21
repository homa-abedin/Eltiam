select 
	(sum(Quantity*price)- sum(returnQuantity* returnPrice))/1000000 sales
	, CenterName
	from dw..FactSales fs
	join (select * from dw..dimcustomer) c on c.CustomerKey= fs.CustomerKey
	join (select * from dw..dimcenter) ce on ce.id= fs.centerID
	join (select * from dw..dimdate)d on d.datekey= fs.DateKey
	join (SELECT pp.name, pp.Code, pp.id
  FROM [192.168.10.5].[Eltiam].[dbo].[PUBProductDetails]pd
  join (select * from [192.168.10.5].[Eltiam].[dbo].PUBProducts)pp on pp.id=pd.Id
  where IsImported <>0)k on k.id=fs.ProductKey

	
	where fs.DateKey between 14030101 and 14031231 
	group by  CenterName
