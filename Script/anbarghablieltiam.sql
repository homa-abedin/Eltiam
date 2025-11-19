--drop table if exists web.eltiam_inventory
select 
a.*,cast (pp.Price*QtyStock as decimal(18,0))   pq, N'eltiam' pakhsh, 20000 as valuepakhsh, 1 as isinsert
--into web.eltiam_inventory
from (

 SELECT  

  d.DateKey,
  p1.kharazmi ProductCode,
  convert(varchar(10),d.BatchNumber) BatchNo
  ,e.miladiExpire ExpDate
  , i.Price
,d.ProductKey
,cp.Id centerid
  --,d.centerid
  ,SUM(ISNULL(i.Quantity, 0)) OVER (
    PARTITION BY d.Jalali_Year, d.ProductKey,d.BatchNumber, d.CenterId
    ORDER BY d.ProductKey,d.BatchNumber, d.CenterId,d.datekey
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS QtyStock

  ,SUM(ISNULL(i.QtyOnTheWay, 0)) OVER (
    PARTITION BY d.Jalali_Year, d.ProductKey,d.BatchNumber, d.CenterId
    ORDER BY d.ProductKey,d.BatchNumber, d.CenterId,d.datekey
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS InWay
FROM 
(
	select ProductKey, datekey, Jalali_Year, CenterId,BatchNumber  from 
	(
		select fi.ProductKey, fi.CenterId ,BatchNumber
		from dw..FactInventory fi
		join (select * from dw..dimproduct where SupplierCode = 100) p on p.ProductKey = fi.ProductKey
		where   DateKey >= 14030101 
		group by fi.ProductKey, fi.CenterId,BatchNumber
	) fi
	join ( select * from dw..dimdate where DateKey >= 14030101 and Date < getdate()) d on 1=1
) d
LEFT JOIN (
    SELECT * 
    FROM DW.dbo.FactInventory 
) i ON i.DateKey = d.DateKey and i.ProductKey = d.ProductKey and i.CenterId = d.CenterId and i.BatchNumber = d.BatchNumber 
join (select ProductCode, ProductKey from dw..dimproduct )p on p.ProductKey=d.ProductKey
join (select * from web.mapproduct) p1 on p1.eltiam=p.productcode
join(select * from dw..dimcenter)c on c.id= d.CenterId
join (SELECT distinct ProductKey, BatchNumber,ShamsiExpire, miladiExpire   FROM DW.dbo.FactInventory where DateKey>=14030101) e on d.ProductKey = e.ProductKey and e.BatchNumber = d.BatchNumber
join (select * from dw.kharazmi.DimCenterPakhsh)cp on cp.Eltiam=c.warehouse
)a

left join (select PUBProductPrice_PUBProduct,StartDateKey,EndDateKey,cast  (Price as decimal (18,0))Price from eltiam.PUBProductPrices where IsConfirmed=1)pp on pp.PUBProductPrice_PUBProduct= a.ProductKey 
and a.DateKey between pp.StartDateKey and pp.EndDateKey
where

(QtyStock<>0 or InWay<>0)
 and datekey > (select max(datekey) from web.eltiam_inventory)
order by ProductKey,BatchNo, CenterId,datekey