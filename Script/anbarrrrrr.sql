
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
    WHERE   datekey>  (select  isnull (max(DateKey),14030101 ) from  web.eltiam_inventory where pakhsh like N'%eltiam%')
    GROUP BY s.ProductKey, DateKey, FiscalYearKey, SKUKey, WarehouseKey
),
ProductSKU AS (
    SELECT DISTINCT s.ProductKey, SKUKey,WarehouseKey

    FROM eltiam.WHSTransactions s
		join (select * from dw..dimproduct where SupplierCode=100)p on s.ProductKey = p.ProductKey

),
AllDatesProducts AS (
    SELECT 
        d.DateKey,
        d.Jalali_Year,
        p.ProductKey,
        p.SKUKey,
		p.WarehouseKey
    FROM DimDate d
    CROSS JOIN ProductSKU p
    WHERE  datekey>  (select  isnull (max(DateKey),14030101) from  web.eltiam_inventory where pakhsh like N'%eltiam%')
),
FinalCalc AS (
    SELECT 
        a.ProductKey,
        a.DateKey,
        a.Jalali_Year,
		a.WarehouseKey,
        COALESCE(dt.FiscalYearKey, a.Jalali_Year) AS FiscalYearKey,
        a.SKUKey,
        COALESCE(dt.DailyQuantity, 0) AS DailyQuantity,
        COALESCE(dt.DailyOnWay, 0) AS DailyOnWay,
        COALESCE(dt.DailyReserved, 0) AS DailyReserved
    FROM AllDatesProducts a
    LEFT JOIN DailyTransactions dt
        ON a.ProductKey = dt.ProductKey 
        AND a.DateKey = dt.DateKey
        AND a.SKUKey = dt.SKUKey
		and a.WarehouseKey= dt.WarehouseKey
),
CumulativeCalc AS (
    SELECT 
        ProductKey,
        DateKey,
        Jalali_Year,
        SKUKey,
		WarehouseKey,
        SUM(DailyQuantity) OVER (
            PARTITION BY Jalali_Year,ProductKey, SKUKey,WarehouseKey
            ORDER BY DateKey
            ROWS UNBOUNDED PRECEDING
        ) AS CumulativeQuantity,
        SUM(DailyOnWay) OVER (
            PARTITION BY Jalali_Year,ProductKey, SKUKey,WarehouseKey
            ORDER BY DateKey
            ROWS UNBOUNDED PRECEDING
        ) AS CumulativeOnWay,
        SUM(DailyReserved) OVER (
            PARTITION BY Jalali_Year,ProductKey, SKUKey,WarehouseKey
            ORDER BY DateKey
            ROWS UNBOUNDED PRECEDING
        ) AS CumulativeReserved
    FROM FinalCalc
)
, pro as (
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
SELECT k.datekey
, mp.kharazmi productcode
, dc.Id as centerid 
, dsku.Id as BatchNo
, sku.ExpireAlternateDateKey  ExpDate
, CF_DailyQuantity as QtyStock
,CumulativeOnWay InWay
, CF_DailyQuantity* ConsumerPrice as qtyprice 
, 2000 as pakhsh , N'eltiam' as valuepakhsh, 1 as isinsert
FROM (
    SELECT
        c.ProductKey,
        c.DateKey,
        c.Jalali_Year,
        c.SKUKey,
		WarehouseKey,
        CASE 
            WHEN c.CumulativeQuantity  = 0 THEN
        MAX(  c.CumulativeQuantity - c.CumulativeReserved )
            OVER (
                PARTITION BY Jalali_Year,c.ProductKey, c.SKUKey, c.WarehouseKey
                ORDER BY c.DateKey
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            )
    ELSE 
        c.CumulativeQuantity - c.CumulativeReserved
        END AS CF_DailyQuantity,
       
            
                c.CumulativeOnWay,
       
        
                c.CumulativeReserved
        
    FROM CumulativeCalc c
    JOIN dw..dimproduct p
        ON p.ProductKey = c.ProductKey
        AND p.SupplierCode = 100
    --WHERE c.DateKey <= 14040720
    --  AND c.Jalali_Year = 1404
    --  AND c.ProductKey = 5962
    --   AND c.SKUKey = 181864
	   --and WarehouseKey= 66
) k
join (select * from dw..dimproduct where SupplierCode=100)dp on dp.ProductKey= k.ProductKey
join (select distinct eltiam, kharazmi from pro)mp on mp.eltiam= dp.ProductCode
join(select * from eltiam.WHSSKUs)sku on sku.Id= k.SKUKey 
join (select * from dw.kharazmi.dimsku)dsku on dsku.BatchNo= sku.BatchNumber 
and dsku.ProductCode= mp.kharazmi
join (select * from dw.kharazmi.DimCenterPakhsh)dc on dc.Eltiam=WarehouseKey
join (select * from price) p on p.ProductKey= dp.ProductKey
WHERE CF_DailyQuantity <> 0 
   OR CumulativeOnWay <> 0 
   OR CumulativeReserved <> 0
ORDER BY DateKey,k.ProductKey, WarehouseKey  ;

