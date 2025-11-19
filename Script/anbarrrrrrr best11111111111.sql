declare @k int = (select datekey from dimdate where Date=cast (DATEADD(day,-1, getdate())as date) );
declare @l int = (select   max(datekey)  from  kharazmi.eltiam_inventory)
declare @m int = (select   max(FiscalYearKey)  from  kharazmi.eltiam_inventory)
;WITH sel1 AS (
    SELECT 
		WarehouseKey,
        s.ProductKey,
        SKUKey,
        DateKey,
        FiscalYearKey,
        SUM(Quantity) AS DailyQuantity,
        SUM(QtyOnTheWay) AS DailyOnWay,
        SUM(QtyReserved) AS DailyReserved
        --Quantity AS DailyQuantity,
        --QtyOnTheWay AS DailyOnWay,
        --QtyReserved AS DailyReserved
    FROM Eltiam.WHSTransactions s 
	join (select * from dw..dimproduct where SupplierCode=100)p on s.ProductKey = p.ProductKey
    WHERE FiscalYearKey>=@m
	--between 14030101 and @k
	--> (select   max(FiscalYearKey)  from  kharazmi.eltiam_inventory)
	--and datekey<= @k
	and not (Quantity is not null and QtyReserved is not null and Quantity=QtyReserved)
	 
    GROUP BY WarehouseKey,s.ProductKey,SKUKey,FiscalYearKey,DateKey
	--order by DateKey
)
,sel2 AS (
    SELECT 
        s.*,
        SUM(s.DailyQuantity - s.DailyReserved) OVER (
            PARTITION BY FiscalYearKey,WarehouseKey,s.ProductKey,SKUKey
            ORDER BY DateKey
            ROWS UNBOUNDED PRECEDING
        ) AS Balance
    FROM sel1 s

),ProductSKU AS (
    select
        ProductKey,
        SKUKey,
        WarehouseKey,
        min(DateKey)startdate,
        max(DateKey)enddate 
    from sel2 
    group by ProductKey, SKUKey,WarehouseKey
),FiscalYear AS(
    select
        max(FiscalYearKey) FiscalYearKey, 
        left (datekey, 4)yearl 
    from sel2  
    group by left (datekey, 4)
),DateDayProduct AS (
	SELECT 
        d.DateKey,
        d.Jalali_Year,
		p.WarehouseKey,
        p.ProductKey,
        p.SKUKey
    FROM ProductSKU p 
    JOIN (select * from DimDate where  datekey between 14030101 and @k) d on d.datekey >= p.startdate and d.datekey<=@k   --p.enddate
),sel3 AS (
    SELECT 
		a.WarehouseKey,
        a.SKUKey,
        a.ProductKey,
        a.DateKey,
        a.Jalali_Year,
        isnull(dt.FiscalYearKey, fy.FiscalYearKey) AS FiscalYearKey,
        dt.DailyQuantity AS DailyQuantity,
        dt.DailyOnWay AS DailyOnWay,
        dt.DailyReserved AS DailyReserved,
        dt.Balance
    FROM DateDayProduct a
    LEFT JOIN (select * from sel2) dt on 
        a.ProductKey = dt.ProductKey 
        AND a.DateKey = dt.DateKey
        AND a.SKUKey = dt.SKUKey
		and a.WarehouseKey= dt.WarehouseKey
    join (select * from FiscalYear) fy on fy.yearl = a.Jalali_Year
),sel4 AS (
    SELECT 
        s.*,

             LAST_VALUE(s.Balance) IGNORE NULLS OVER (
                PARTITION BY  FiscalYearKey,s.WarehouseKey,s.ProductKey,s.SKUKey
                ORDER BY s.DateKey
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            )
         AS FilledBalance
    FROM sel3 s
	
),sel5 AS (
    SELECT 
		s.WarehouseKey,
        s.SKUKey,
        s.ProductKey,
        s.DateKey,
        s.Jalali_Year,
        s.FiscalYearKey,
        s.DailyQuantity,
        s.DailyOnWay,
        s.DailyReserved,
        case 
            --
			when s.FilledBalance = 0 and s.DailyQuantity is null  and s.DailyReserved is null and s.DailyOnWay is null
			then null
            else s.FilledBalance end FilledBalance2
    FROM sel4 s
),
 pro as (
select  MIN(kharazmi)kharazmi, eltiam from  stage.web.mapproduct where eltiam is not null group by eltiam
--), price as 
--(
--select ProductKey, ConsumerPrice from dw..dimproduct dp
--join (select * from stage.Eltiam. PUBProductPrices)pp on
--pp.PUBProductPrice_PUBProduct= dp.ProductKey
--where pp.IsConfirmed=1 and 14040801 between StartDateKey and EndDateKey
--and Suppliercode=100
),sel6 AS (
    SELECT 
        s.*
    FROM sel5 s
    WHERE FilledBalance2 IS NOT NULL
) 


--select * from sel6
--where productkey=3930
--and warehousekey=1
--order by datekey

--select k.datekey
--, k.FiscalYearKey
--, mp.kharazmi   productcode
--,dc.Id as centerid
--, dsku.id  as BatchNo
--, dsku.ExpireDate  as  ExpDate
--, k.FilledBalance2  as QtyStock
--, 0 as InWay
--,cast(dpp.fee as bigint ) Fee1
--, N'eltiam' as pakhsh
--, 20000 as valuepakhsh
--, isinsert=1
----into kharazmi.eltiam_inventory

--from sel6 k

--join (select * from dw..dimproduct where SupplierCode=100)dp on dp.ProductKey= k.ProductKey
--join (select distinct eltiam, kharazmi from pro)mp on mp.eltiam= dp.ProductCode
--join(select * from eltiam.WHSSKUs)sku on sku.Id= k.SKUKey and sku.WHSSKU_PUBProduct= dp.ProductKey
--join (select * from dw.kharazmi.dimsku)dsku on dsku.BatchNo= sku.BatchNumber  
--and dsku.ProductCode= mp.kharazmi
--join (select * from dw.kharazmi.DimCenterPakhsh)dc on dc.Eltiam=WarehouseKey
--join (select * from dw.kharazmi.DimPRoductPrice) dpp on dpp.productcode=mp.kharazmi 
--and k.DateKey >= dpp.StartDate and k.DateKey< dpp.EndDate 
--where k.datekey>14040809
--ORDER BY DateKey



