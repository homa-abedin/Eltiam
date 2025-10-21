select CenterName ,
    [تجهیزات], [دارویی] , [گیاهی], [مکمل], [بهداشتی] from 	
	(select 
	(sum(Quantity*price)- sum(returnQuantity* returnPrice))/1000000 sales
	, CenterName, PRoductCategory
	from dw..FactSales fs
	join (select * from dw..dimcustomer) c on c.CustomerKey= fs.CustomerKey
	join (select * from dw..dimcenter) ce on ce.id= fs.centerID
	join (select * from dw..dimdate)d on d.datekey= fs.DateKey
	join (select * from dw..dimproduct) dp on dp.ProductKey=fs.ProductKey

	
	where fs.DateKey between 14030101 and 14031231 
	group by  CenterName, PRoductCategory
		)as SourceTable
PIVOT (
    sum(sales) FOR PRoductCategory IN([تجهیزات], [دارویی] , [گیاهی], [مکمل], [بهداشتی]) 
    
) AS PivotTable;