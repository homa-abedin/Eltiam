select CenterName ,
    [خصوصی], [دولتی],Jalali_MonthString from 	
	(select 
	(sum(Quantity*price)- sum(returnQuantity* returnPrice))/1000000 sales
	, CenterName, OwnershipType, d.Jalali_MonthString
	from dw..FactSales fs
	join (select * from dw..dimcustomer) c on c.CustomerKey= fs.CustomerKey
	join (select * from dw..dimcenter) ce on ce.id= fs.centerID
	join (select * from dw..dimdate)d on d.datekey= fs.DateKey
	
	where fs.DateKey between 14030101 and 14031231 
	group by centerID, OwnershipType, CenterName,d.Jalali_MonthString
	)as SourceTable
PIVOT (
    sum(sales) FOR OwnershipType IN([خصوصی], [دولتی] ) , for Jalali_MonthString in ()
    
) AS PivotTable;