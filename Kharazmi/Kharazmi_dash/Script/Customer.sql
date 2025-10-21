drop table if exists #DimCustomerPakhsh
GO

		select 
		ROW_NUMBER() OVER (PARTITION BY p.gln order by p.id ) as Id,
		COALESCE(p.Name, e.Customer, d.CustomerName, c.Customer, m.Customer, h.CustName, a.Customer, r.Customer, t.CustomerName, b.Customer ) AS CustomerName
		,COALESCE(p.GLN, c.GLN, m.GLN, h.custgln, a.gln, r.GLN, t.gln, b.gln, e.gln, d.gln) AS GLN
		, c.CustomerCode Qhasem
		, m.CustomerCode as Mahya
		, h.CustID as Hasti
		, a.CustomerCode Alborz
		, r.CustomerCode Razi
		, t.CustomerId Toba
		, b.CustomerCode Barij
		, e.CustomerKey Eltiam
		, d.CustomerCode Daya
		, case when p.gln  is null then 'other' else 'ttac' end as kind 
		into #DimCustomerPakhsh
		from Stage.Eltiam.Pharmacies p


		full join (
				select Customer, CustomerCode,gln from stage.web.Qhasem_CustomerSales
				
				group by Customer, CustomerCode,gln --9435
				)c on c.GLN= p.GLN
				------------32105

		full join (
				select Customer, CustomerCode,gln from stage.web.Mahya_CustomerSales s
				--where not exists (select gln from  dw.kharazmi.DimCustomerPakhsh p where  p.gln=s .GLN )
				group by Customer, CustomerCode,gln ---8924
				)m on m.GLN= p.GLN

		full join (
				select CustID, CustName, CustGLN from stage.web.hasti_CustomerSales s
				--where not exists (select gln from  dw.kharazmi.DimCustomerPakhsh p where  p.gln=s .CustGLN )

				group by  CustID, CustName, CustGLN --5338
				)h on h.CustGLN= p.GLN

				-------------hasti
		full join (
				select Customer, CustomerCode,gln from stage.web.Alborz_CustomerSales s
				--where not exists (select gln from dw. kharazmi.DimCustomerPakhsh p where  p.gln=s .GLN )
				group by  Customer, CustomerCode,gln --51
				)a on a.GLN= p.GLN

		full join (
				select Customer, CustomerCode,gln from stage.web.Razi_CustomerSales s
				--where not exists (select gln from  dw.kharazmi.DimCustomerPakhsh p where  p.gln=s .GLN )
				group by  Customer, CustomerCode,gln --6863
				)r on r.GLN= p.GLN
		full join (
				select CustomerName, CustomerId,gln from stage.web.Toba_CustomerSales s
				--where not exists (select gln from  dw.kharazmi.DimCustomerPakhsh p where  p.gln=s .GLN )
				group by  CustomerName, CustomerId,gln --2547
				)t on t.GLN= p.GLN
		full join (
				select Customer,gln, CustomerCode from stage.web.Barij_CustomerSales s
				--where not exists (select gln from  dw.kharazmi.DimCustomerPakhsh p where  p.gln=s .GLN )
				group by  Customer , CustomerCode,gln --4014
				)b on b.GLN= p.GLN
		full join (
				select * from (
						select distinct dc. CustomerKey, Customer,gln 
						from dw..factsales fs
						join( select * from dw..dimproduct where SupplierCode=100) p on p.ProductKey=fs.ProductKey
						join (select * from dw..dimcustomer)dc on dc.CustomerKey= fs.CustomerKey
						where dc.gln is not null and fs.DateKey>=14030101
						) s
				
				--where not exists (select gln from  dw.kharazmi.DimCustomerPakhsh p where  p.gln=s .GLN )
				   
				group by s. Customer , s.CustomerKey,s.gln --14668
				)e on e.GLN= p.GLN
		full join (
				select CustomerName,gln, CustomerCode from stage.Web.Daya_CustomerSales s
				--where not exists (select gln from  dw.kharazmi.DimCustomerPakhsh p where  p.gln=s .GLN )
				
				group by  CustomerName,gln, CustomerCode --9596
				)d on d.GLN= p.GLN


			GO


insert into DW.kharazmi.DimCustomerPakhsh
(
	
	[CustomerName]
	,[GLN]
	,[Qhasem]
	,[Mahya]
	,[Hasti]
	,[Alborz]
	,[Razi]
	,[Toba]
	,[Barij]
	,[Eltiam]
	,[Daya]
	,[kind]
 )
 
	select 
	max(customername)customername,gln,max(qhasem)qhasem,max(mahya)mahya,max(hasti)hasti,max(alborz)alborz
	,max(razi)razi,max(toba)toba,max(barij)barij,max(eltiam)eltiam,max(daya)daya, max(kind  )
				
	from #DimCustomerPakhsh d 
	where not exists (select gln from dw.kharazmi.DimCustomerPakhsh p where  p.gln= d.gln)
		
	group by gln




