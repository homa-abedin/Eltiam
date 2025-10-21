drop table if exists dw.kharazmi.DimproductPakhsh
GO
WITH ValidGTINs AS (
    SELECT ProductCode, MIN(GTIN) AS Valid_GTIN
    FROM web.Mahya_ProductSales
    WHERE GTIN IS NOT NULL
    GROUP BY ProductCode
)
, eltiamGTINs AS (
    SELECT ProductKey, max(GTIN) AS Valid_GTIN
    FROM dw..dimproduct
    WHERE GTIN IS NOT NULL and SupplierCode=100
    GROUP BY ProductKey
)
	select  
		p.latinbrand,
		COALESCE( p.persianbrand, e.product,c.product,m.Product, h.product, b.product,d.product)productname
		,COALESCE(p.Gtin,e.gtin, c.gtin, m.gtin, h.gtin, b.gtin, d.gtin)gtin
		
		, case when p.gtin  is null then 'other' else 'ttac' end as kind 
		into dw.kharazmi.DimproductPakhsh


		--select * 
		from Stage.Web.TotalProductImported p--476
		
		full join (
				select case when GTIN =0 or GTIN is null then N'بدون GTIN' else  min(Product) end as Product ,GTIN from stage.web.Qhasem_CustomerSales
				group by  GTIN  --77
				)c on c.GTIN= p.GTIN

		full join (
				select min(Product) as Product ,v.Valid_GTIN GTIN from stage.web.Mahya_ProductSales s
				join ValidGTINs v on v.Valid_GTIN= s.GTIN
				group by Valid_GTIN --72
				)m on m.GTIN= p.GTIN

		full join (
				select case when gtin =0 or gtin is null then N'بدون GTIN' else  min(ProdName) end as Product, gtin from stage.web.hasti_Inventory s
				group by   gtin --98
				)h on h.gtin= p.gtin

				-------------hasti
		--full join (
		--		select case when GTIN =0 or GTIN is null then N'بدون GTIN' else  min(product) end as product ,GTIN from stage.web.Alborz_Inventory s
		--		group by   GTIN --51
		--		)a on a.gtin= p.gtin

		--full join (
		--		select case when gtin =0 or gtin is null then N'بدون GTIN' else  min(Product) end as Product ,gtin from stage.web.Razi_Inventory s
		--		group by gtin --6863
		--		)r on r.gtin= p.gtin
		--full join (
		--		select case when GTIN =0 or GTIN is null then N'بدون GTIN' else  min(invProdctName) end as product ,GTIN from stage.web.Toba_Inventory s
		--		group by   GTIN --2547
		--		)t on t.GTIN= p.GTIN
		full join (
				select case when GTIN =0 or GTIN is null then N'بدون GTIN' else  min(Product) end as Product , GTIN from stage.web.Barij_Inventory s
				group by    GTIN --65
				)b on b.GTIN= p.GTIN

		full join (
				
						select   min(Product)  Product ,e.Valid_GTIN  GTIN
						from dw..factsales fs
						join( select * from dw..dimproduct where SupplierCode=100) p on p.ProductKey=fs.ProductKey
						join (select * from eltiamGTINs) e on e.ProductKey= p.ProductKey
						where  fs.DateKey>=14030101
						group by Valid_GTIN
								
				)e on e.GTIN= p.GTIN

		full join (
				select case when GTIN =0 or GTIN is null then N'بدون GTIN' else  min(ProductName) end as Product ,gtin  from stage.Web.Daya_CustomerSales s
				
				group by GTIN --126
				)d on d.GTIN= p.GTIN

						where  p.status not like N'نیازمند ویرایش' or  p.status is null






						--select * from dw.kharazmi.DimproductPakhsh
						--where productname like N'بدون GTIN'