declare @k int = (select datekey from dimdate where date =cast (getdate() as date))

;WITH DailyTransactions AS (
    SELECT 
        s.ProductKey,
        DateKey,
        FiscalYearKey,
        SKUKey,
		WarehouseKey,
        SUM(Quantity) AS DailyQuantity,
        SUM(QtyOnTheWay) AS DailyOnWay,
        SUM(QtyReserved) AS DailyReserved
    FROM eltiam.WHSTransactions s 
	join (select * from dw..dimproduct where SupplierCode=100)p on s.ProductKey = p.ProductKey
    WHERE   datekey>=14030101  and (Quantity-QtyReserved)<>0
	----(select  isnull (max(DateKey),14030101 ) from  web.eltiam_inventory where pakhsh like N'%eltiam%')
    GROUP BY s.ProductKey, DateKey, FiscalYearKey, SKUKey, WarehouseKey
	----order by DateKey



	--SELECT 
 --       s.ProductKey,
 --       DateKey,
 --       FiscalYearKey,
 --       SKUKey,
	--	WarehouseKey,
 --       Quantity AS DailyQuantity,
 --       QtyOnTheWay AS DailyOnWay,
 --       QtyReserved AS DailyReserved
 --   FROM eltiam.WHSTransactions s 
	--join (select * from dw..dimproduct where SupplierCode=100)p on s.ProductKey = p.ProductKey
 --   WHERE   datekey>=14030101 and (Quantity-QtyReserved)<>0
	--(select  isnull (max(DateKey),14030101 ) from  web.eltiam_inventory where pakhsh like N'%eltiam%')
    --GROUP BY s.ProductKey, DateKey, FiscalYearKey, SKUKey, WarehouseKey
	--order by DateKey
)

,
ProductSKU AS (
 --   SELECT DISTINCT 
	--	s.ProductKey, 
	--	SKUKey,WarehouseKey
 --   FROM eltiam.WHSTransactions s
	--join (select * from dw..dimproduct where SupplierCode=100)p on s.ProductKey = p.ProductKey
select  ProductKey, SKUKey,WarehouseKey , min(DateKey)startdate ,max(DateKey)enddate from DailyTransactions group by ProductKey, SKUKey,WarehouseKey
),
FiscalYear AS(
select    max(FiscalYearKey)FiscalYearKey, left (datekey, 4)yearl from DailyTransactions  group by left (datekey, 4)

),

AllDatesProducts AS (
 --   SELECT 
 --       d.DateKey,
 --       d.Jalali_Year,
 --       p.ProductKey,
 --       p.SKUKey,
	--	p.WarehouseKey
 --   FROM DimDate d
 --   CROSS JOIN ProductSKU p
 --   WHERE  datekey between   14030101
	----(select  isnull (max(DateKey),14030101) from  web.eltiam_inventory where pakhsh like N'%eltiam%')
	--and @k

	SELECT 
        d.DateKey,
        d.Jalali_Year,
        p.ProductKey,
        p.SKUKey,
		p.WarehouseKey
    FROM ProductSKU p 
    JOIN (select * from DimDate where  datekey between   14030101 and @k) d on d.datekey>= p.startdate and d.datekey<p.enddate
)
,
FinalCalc AS (
  --  SELECT 
  --      a.ProductKey,
  --      a.DateKey,
  --      a.Jalali_Year,
		--a.WarehouseKey,
  --      COALESCE(dt.FiscalYearKey, a.Jalali_Year) AS FiscalYearKey,
  --      a.SKUKey,
  --      COALESCE(dt.DailyQuantity, 0) AS DailyQuantity,
  --      COALESCE(dt.DailyOnWay, 0) AS DailyOnWay,
  --      COALESCE(dt.DailyReserved, 0) AS DailyReserved
  --  FROM AllDatesProducts a
  --  LEFT JOIN DailyTransactions dt
  --      ON a.ProductKey = dt.ProductKey 
  --      AND a.DateKey = dt.DateKey
  --      AND a.SKUKey = dt.SKUKey
		--and a.WarehouseKey= dt.WarehouseKey


		    SELECT 
        a.ProductKey,
        a.DateKey,
        a.Jalali_Year,
		a.WarehouseKey,
        isnull(dt.FiscalYearKey, fy.FiscalYearKey) AS FiscalYearKey,
        a.SKUKey,
        dt.DailyQuantity AS DailyQuantity,
        dt.DailyOnWay AS DailyOnWay,
        dt.DailyReserved AS DailyReserved,
		dt.DailyQuantity-dt.DailyReserved as remain
    FROM AllDatesProducts a
    LEFT JOIN DailyTransactions dt
        ON a.ProductKey = dt.ProductKey 
        AND a.DateKey = dt.DateKey
        AND a.SKUKey = dt.SKUKey
		and a.WarehouseKey= dt.WarehouseKey
	join (select * from FiscalYear)fy on fy.yearl=a.Jalali_Year
)


,
CumulativeCalc AS (
    SELECT 
        ProductKey,
        DateKey,
        Jalali_Year,
		FiscalYearKey,
        SKUKey,
		WarehouseKey,
        SUM(DailyQuantity) OVER (
            PARTITION BY FiscalYearKey,Jalali_Year,WarehouseKey,ProductKey, SKUKey
            ORDER BY DateKey
            ROWS UNBOUNDED PRECEDING
        ) AS CumulativeQuantity,
        SUM(DailyOnWay) OVER (
            PARTITION BY FiscalYearKey,Jalali_Year,WarehouseKey,ProductKey, SKUKey
            ORDER BY DateKey
            ROWS UNBOUNDED PRECEDING
        ) AS CumulativeOnWay,
        SUM(DailyReserved) OVER (
            PARTITION BY FiscalYearKey,Jalali_Year,WarehouseKey,ProductKey, SKUKey
            ORDER BY DateKey
            ROWS UNBOUNDED PRECEDING
        ) AS CumulativeReserved
    FROM FinalCalc
)




,
 pro as (
select  MIN(kharazmi)kharazmi, eltiam from  stage.web.mapproduct where eltiam is not null group by eltiam
)


, price as 
(
select ProductKey, ConsumerPrice from dw..dimproduct dp
join (select * from stage.Eltiam. PUBProductPrices)pp on
pp.PUBProductPrice_PUBProduct= dp.ProductKey
where pp.IsConfirmed=1 and  @k between StartDateKey and EndDateKey
and Suppliercode=100
)



--SELECT k.datekey
--, mp.kharazmi productcode
--, dc.Id as centerid 
--, dsku.Id as BatchNo
--, sku.ExpireAlternateDateKey  ExpDate
--, CF_DailyQuantity as QtyStock
--,CumulativeOnWay InWay
--, CF_DailyQuantity
--* ConsumerPrice as qtyprice 
--, 2000 as pakhsh , N'eltiam' as valuepakhsh, 1 as isinsert
--into kharazmi.eltiam_inventory
--FROM (
--    SELECT
--        c.ProductKey,
--        c.DateKey,
--        c.Jalali_Year,
--        c.SKUKey,
--		WarehouseKey,
--        CASE 
--            WHEN c.CumulativeQuantity  = 0 THEN
--        MAX(  c.CumulativeQuantity - c.CumulativeReserved )
--            OVER (
--                PARTITION BY Jalali_Year,c.ProductKey, c.SKUKey, c.WarehouseKey
--                ORDER BY c.DateKey
--                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
--            )
--    ELSE 
--        c.CumulativeQuantity - c.CumulativeReserved
--        END AS CF_DailyQuantity,
       
            
--                c.CumulativeOnWay,
       
        
--                c.CumulativeReserved
        
--    FROM CumulativeCalc c
--    JOIN dw..dimproduct p
--        ON p.ProductKey = c.ProductKey
--        AND p.SupplierCode = 100
--    --WHERE c.DateKey <= 14040720
--    --  AND c.Jalali_Year = 1404
--    --  AND c.ProductKey = 5962
--    --   AND c.SKUKey = 181864
--	   --and WarehouseKey= 66


--) k
--join (select * from dw..dimproduct where SupplierCode=100)dp on dp.ProductKey= k.ProductKey

--join (select distinct eltiam, kharazmi from pro)mp on mp.eltiam= dp.ProductCode
--join(select * from eltiam.WHSSKUs)sku on sku.Id= k.SKUKey and sku.WHSSKU_PUBProduct= dp.ProductKey
--join (select * from dw.kharazmi.dimsku)dsku on dsku.BatchNo= sku.BatchNumber  
--and dsku.ProductCode= mp.kharazmi
--join (select * from dw.kharazmi.DimCenterPakhsh)dc on dc.Eltiam=WarehouseKey
--join (select * from price) p on p.ProductKey= dp.ProductKey
--WHERE CF_DailyQuantity <> 0 
--   OR CumulativeOnWay <> 0 
--   OR CumulativeReserved <> 0
--ORDER BY DateKey,k.ProductKey, WarehouseKey   



select * from FinalCalc

where productkey=6284
and skukey= 176504
and WarehouseKey=10
order by DateKey


--select * from eltiam.WHSSKUs
--where Id=176504


--select * from eltiam.PUBProducts where id=6284
