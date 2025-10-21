drop table if exists dw.kharazmi.DimCustomerPakhsh
GO

		select 
		COALESCE(p.Name, e.Customer  , d.Customer, c.Customer, m.Customer, h.Customer, a.Customer, r.Customer, t.Customer, b.Customer ) AS CustomerName
		,COALESCE(p.GLN, e.gln, c.GLN, m.GLN, h.custgln, a.gln, r.GLN, t.gln, b.gln, d.gln) AS GLN
	
		, case when p.gln  is null then 'other' else 'ttac' end as kind 
		into dw.kharazmi.DimCustomerPakhsh
		from Stage.Eltiam.Pharmacies p


		full join (
				select case when gln =0 or gln is null then N'بدون GLN' else  min(Customer) end as Customer ,gln from stage.web.Qhasem_CustomerSales
				group by  gln --9435
				)c on c.GLN= p.GLN
				------------32105

		full join (
				select case when gln =0 or gln is null then N'بدون GLN' else  min(Customer) end as Customer ,gln from stage.web.Mahya_CustomerSales s
				group by gln ---8924
				)m on m.GLN= p.GLN

		full join (
				select case when CustGLN =0 or CustGLN is null then N'بدون GLN' else  min(CustName) end as Customer, CustGLN from stage.web.hasti_CustomerSales s

				group by   CustGLN --5338
				)h on h.CustGLN= p.GLN

				-------------hasti
		full join (
				select case when gln =0 or gln is null then N'بدون GLN' else  min(Customer) end as Customer ,gln from stage.web.Alborz_CustomerSales s
				group by   gln --51
				)a on a.GLN= p.GLN

		full join (
				select case when gln =0 or gln is null then N'بدون GLN' else  min(Customer) end as Customer ,gln from stage.web.Razi_CustomerSales s
				group by gln --6863
				)r on r.GLN= p.GLN
		full join (
				select case when gln =0 or gln is null then N'بدون GLN' else  min(CustomerName) end as Customer ,gln from stage.web.Toba_CustomerSales s
				group by   gln --2547
				)t on t.GLN= p.GLN
		full join (
				select case when gln =0 or gln is null then N'بدون GLN' else  min(Customer) end as Customer , GLN from stage.web.Barij_CustomerSales s
				group by    gln --4014
				)b on b.GLN= p.GLN
		full join (
				
						select case when gln ='0' or gln is null then N'بدون GLN' else  min(Customer) end as Customer ,gln 
						from dw..factsales fs
						join( select * from dw..dimproduct where SupplierCode=100) p on p.ProductKey=fs.ProductKey
						join (select * from dw..dimcustomer)dc on dc.CustomerKey= fs.CustomerKey
						where dc.gln is not null and fs.DateKey>=14030101
						group by GLN
								
				)e on e.GLN= p.GLN
		full join (
				select case when gln =0 or gln is null then N'بدون GLN' else  min(CustomerName) end as Customer ,gln  from stage.Web.Daya_CustomerSales s
				
				group by gln --9596
				)d on d.GLN= p.GLN


			GO

