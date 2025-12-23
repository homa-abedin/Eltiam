drop table if exists dw..factFinance_P_L
GO

;WITH Periods AS (
    SELECT Jalali_Year, N'۳ماهه' AS PeriodType, 
           CAST(Jalali_Year * 10000 + 101 AS int) AS StartDate,
           CAST(Jalali_Year * 10000 + 331 AS int) AS EndDate
    FROM dimdate
    GROUP BY Jalali_Year
    UNION ALL
    SELECT Jalali_Year, N'۶ماهه', 
           CAST(Jalali_Year * 10000 + 101 AS int),
           CAST(Jalali_Year * 10000 + 631 AS int)
    FROM dimdate
    GROUP BY Jalali_Year
    UNION ALL
    SELECT Jalali_Year, N'۹ماهه',
           CAST(Jalali_Year * 10000 + 101 AS int),
           CAST(Jalali_Year * 10000 + 930 AS int)
    FROM dimdate
    GROUP BY Jalali_Year
    UNION ALL
    SELECT Jalali_Year, N'۱۲ماهه',
           CAST(Jalali_Year * 10000 + 101 AS int),
           CAST(Jalali_Year * 10000 + 1231 AS int)
    FROM dimdate
    GROUP BY Jalali_Year
)
, base AS (
    SELECT 
        p.Jalali_Year,
        p.PeriodType,
        CASE 
            WHEN f.IDL2 = 28 THEN 1 --N'SalesFinance'
            WHEN f.IDL2 IN (37,36) THEN 2--N'COGS'
            WHEN f.IDL2 IN (31,34,35) THEN 3--N'Expenses'
            WHEN f.IDL2 = 29 THEN 4--N'OtherIncome'
            WHEN f.IDL2 = 32 THEN 5--N'OtherExpenses'
            WHEN f.IDL2 = 33 THEN 6--N'FinancialExpenses'
            WHEN f.IDL2 = 30 THEN 7--N'OtherNONOperationIncome'
        END AS SodvaZian,idl2,p.StartDate, p.EndDate,
        SUM(f.DebitBalance) AS Amount
    FROM dw..FactFinance f
    JOIN Periods p 
      ON f.DateKey >= p.StartDate AND f.DateKey <p.EndDate
    WHERE f.FINDocHeader_FINDocType NOT IN (2,4)
    GROUP BY p.Jalali_Year, p.PeriodType, f.IDL2,p.StartDate, p.EndDate 
)

,
-- خلاصه سالانه با Pivot ساده (برای محاسبات بعدی)
agg AS (
    SELECT
        Jalali_Year,PeriodType,
        SUM(CASE WHEN SodvaZian = 1--N'SalesFinance'
			THEN -1*Amount ELSE 0 END) AS daramad_amaliati,
        SUM(CASE WHEN SodvaZian = 2--N'COGS' 
		THEN -1*Amount ELSE 0 END) AS bahaye_tamam,
        SUM(CASE WHEN SodvaZian = 3--N'Expenses' 
		THEN -1*Amount ELSE 0 END) AS hazine_edari,
        SUM(CASE WHEN SodvaZian = 4--N'OtherIncome' 
		THEN -1*Amount ELSE 0 END) AS saye_daramad,
        SUM(CASE WHEN SodvaZian = 5--N'OtherExpenses'
		THEN -1*Amount ELSE 0 END) AS saye_hazine,
        SUM(CASE WHEN SodvaZian = 6--N'FinancialExpenses'
		THEN -1*Amount ELSE 0 END) AS hazine_mali,
        SUM(CASE WHEN SodvaZian = 7--N'OtherNONOperationIncome' 
		THEN -1*Amount ELSE 0 END) AS saye_daramad_amaliati
    FROM base
    GROUP BY Jalali_Year, PeriodType
)

,
calc AS (
     SELECT
        Jalali_Year,PeriodType,
       CAST( daramad_amaliati AS decimal(18,2))[درآمد عملیاتی] ,
        CAST( bahaye_tamam AS decimal(18,2))[بهای تمام شده],
        CAST( hazine_edari AS decimal(18,2))[هزینه‌های فروش، اداری و عمومی],
        CAST( saye_daramad AS decimal(18,2))[سایر درآمدها],
        CAST( saye_hazine AS decimal(18,2))[سایر هزینه‌ها],
        CAST( hazine_mali AS decimal(18,2))[هزینه‌های مالی],
        CAST( saye_daramad_amaliati AS decimal(18,2))[سایر درآمدهای غیرعملیاتی],
        -- محاسبات صحیح
        CAST((daramad_amaliati + bahaye_tamam)AS decimal(18,2))  AS [سود ناخالص],
        CAST((daramad_amaliati + bahaye_tamam + hazine_edari + saye_daramad + saye_hazine)AS decimal(18,2)) AS [سود عملیاتی],
        CAST((daramad_amaliati +bahaye_tamam + hazine_edari + saye_daramad + saye_hazine 
         + hazine_mali + saye_daramad_amaliati)AS decimal(18,2)) AS [سود عملیات در حال تداوم قبل از مالیات],
       CAST(
            CASE 
                WHEN (daramad_amaliati + bahaye_tamam + hazine_edari + saye_daramad + saye_hazine 
                      + hazine_mali + saye_daramad_amaliati) < 0 THEN 0
                ELSE (daramad_amaliati + bahaye_tamam + hazine_edari + saye_daramad + saye_hazine 
                      + hazine_mali + saye_daramad_amaliati) * -0.25
            END 
        AS decimal(18,2) ) AS [هزینه مالیات بردرآمد],

		CAST((daramad_amaliati +bahaye_tamam + hazine_edari + saye_daramad + saye_hazine 
         + hazine_mali + saye_daramad_amaliati)
		 +
	
            CASE 
                WHEN (daramad_amaliati + bahaye_tamam + hazine_edari + saye_daramad + saye_hazine 
                      + hazine_mali + saye_daramad_amaliati) < 0 THEN 0
                ELSE (daramad_amaliati + bahaye_tamam + hazine_edari + saye_daramad + saye_hazine 
                      + hazine_mali + saye_daramad_amaliati) * -0.25
            END 
        AS decimal(18,2) ) as [سود خالص]

    FROM agg
),
unpvt AS (
    SELECT 
        Jalali_Year,
		PeriodType,
        SodvaZian,
        Amount
    FROM calc
    UNPIVOT (
        Amount FOR SodvaZian IN (
            [درآمد عملیاتی],
            [بهای تمام شده],
            [هزینه‌های فروش، اداری و عمومی],
            [سایر درآمدها],
            [سایر هزینه‌ها],
            [هزینه‌های مالی],
            [سایر درآمدهای غیرعملیاتی],
            [سود ناخالص],
            [سود عملیاتی],
            [سود عملیات در حال تداوم قبل از مالیات],
            [هزینه مالیات بردرآمد],
            [سود خالص]
        )
    ) AS unpvt
)
-- 👇 محاسبه درصد نسبت به درآمد عملیاتی
SELECT 
  cast (concat(u.Jalali_Year ,'0101') as int )datekey,
	u.PeriodType,
    u.SodvaZian,
    u.Amount,
    CAST(
        CASE 
            WHEN a.daramad_amaliati = 0 THEN NULL
            ELSE (u.Amount / a.daramad_amaliati) 
        END AS decimal(10,4)
    ) AS RatioToRevenuePercent
	, CASE 
        WHEN u.SodvaZian = N'درآمد عملیاتی' THEN 1
        WHEN u.SodvaZian = N'بهای تمام شده' THEN 2
        WHEN u.SodvaZian = N'سود ناخالص'   THEN 3
        WHEN u.SodvaZian = N'هزینه‌های فروش، اداری و عمومی'  THEN 4
        WHEN u.SodvaZian = N'سایر درآمدها'   THEN 5
        WHEN u.SodvaZian = N'سایر هزینه‌ها'   THEN 6
        WHEN u.SodvaZian = N'هزینه‌های مالی'   THEN 8
        WHEN u.SodvaZian = N'سایر درآمدهای غیرعملیاتی' THEN 9
        WHEN u.SodvaZian = N'سود عملیاتی' THEN 7
        WHEN u.SodvaZian = N'سود عملیات در حال تداوم قبل از مالیات' THEN 10
        WHEN u.SodvaZian = N'هزینه مالیات بردرآمد'  THEN 11
        WHEN u.SodvaZian = N'سود خالص'     THEN 12
        ELSE 99
    END AS SodvaZianSortID
	,CASE u.PeriodType 
              WHEN N'۳ماهه' THEN 1 
              WHEN N'۶ماهه' THEN 2 
              WHEN N'۹ماهه' THEN 3 
              when N'۱۲ماهه' then 4 END as PeriodTypeId
	into dw..factFinance_P_L
FROM unpvt u
JOIN agg a ON u.Jalali_Year = a.Jalali_Year and u.PeriodType= a.PeriodType 
ORDER BY datekey, 
         CASE u.PeriodType 
              WHEN N'۳ماهه' THEN 1 
              WHEN N'۶ماهه' THEN 2 
              WHEN N'۹ماهه' THEN 3 
              ELSE 4 END;





