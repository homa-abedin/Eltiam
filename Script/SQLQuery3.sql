declare @k int = (select datekey from dimdate where date =cast (getdate() as date))

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
    FROM dbo.WHSTransaction s 
	join (select * from Back..dimproduct where SupplierCode=100)p on s.ProductKey = p.ProductKey
    WHERE datekey >= 14030101  and not (Quantity is not null and QtyReserved is not null and Quantity=QtyReserved)
    GROUP BY WarehouseKey,s.ProductKey,SKUKey,FiscalYearKey,DateKey
),sel2 AS (
    SELECT 
        s.*,
        SUM(s.DailyQuantity - s.DailyReserved) OVER (
            PARTITION BY WarehouseKey,s.ProductKey,SKUKey
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
    JOIN (select * from DimDate where  datekey between 14030101 and @k) d on d.datekey >= p.startdate and d.datekey<=p.enddate
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
            PARTITION BY s.WarehouseKey,s.ProductKey,s.SKUKey
            ORDER BY s.DateKey
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS FilledBalance
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
            when s.FilledBalance = 0 and s.DailyQuantity is null and s.DailyOnWay is null and s.DailyReserved is null then null
            else s.FilledBalance end FilledBalance2
    FROM sel4 s
),sel6 AS (
    SELECT 
        s.*
    FROM sel5 s
    WHERE FilledBalance2 IS NOT NULL
)
select WarehouseKey,productkey,skukey, FilledBalance2 from sel6
where 
--WarehouseKey=10
productkey=3
and DateKey = 14040727
--and productkey=176504
--and skukey= 176504
--group by WarehouseKey,productkey, skukey
--having min(FilledBalance2) > 0
--SELECT @@VERSION AS VersionInfo;