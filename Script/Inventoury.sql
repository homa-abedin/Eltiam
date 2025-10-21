SELECT
		sum([Quantity])[Quantity]
      ,sum([QtyReserved])[QtyReserved]
      ,sum([QtyOnTheWay])[QtyOnTheWay]
	  , ProductKey
	  ,WarehouseKey
      , DateKey
	  , SKUKey
	  ,FiscalYearKey
  FROM [Eltiam].[dbo].[WHSTransactions]

  group by DateKey, WarehouseKey	  , SKUKey
	  ,FiscalYearKey
	  , ProductKey

  order by DateKey



