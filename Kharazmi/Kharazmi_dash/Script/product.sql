
use DW
GO

drop table if exists #dimProductPakhsh
GO


select 
kharazmi.ProductID
, kharazmi.number
, kharazmi.name
, kharazmi.sodorparvane
, kharazmi.GTIN
, daya.ProductId Daya
, Qhasem.ProductCode Qasem
, Mahya.ProductCode Mahya
, Momtaz.ProductCode  Momtaz
, hasti.ProdID hasti
, Barij.ProductCode barij
, eltiam.ProductKey eltiam
into #dimProductPakhsh
from (
select
	ProductID, number, name, sodorparvane, GTIN
from dw.kharazmi.dimproduct
where state=1  and GTIN is not null
group by ProductID, number, name, sodorparvane, GTIN
)kharazmi ---232
------------------------------------------------
left join 
(
select ProductId, GTIN, ProductName from stage.web.Daya_CustomerSales
group by ProductId, GTIN, ProductName  --140
)daya on daya.GTIN=kharazmi.GTIN
---236
left join 
(
select Product, GTIN, ProductCode from stage.web.Qhasem_CustomerSales
group by Product, GTIN, ProductCode  --104
)Qhasem on Qhasem.GTIN=kharazmi.GTIN
--244
left join
(
select Product, GTIN, ProductCode from stage.web.Mahya_ProductSales
group by Product, GTIN, ProductCode  --73
)Mahya on Mahya.GTIN=kharazmi.GTIN
--244

left join
(
select Product, GTIN, ProductCode from stage.web.Momtaz_Products
group by Product, GTIN, ProductCode  --120
)Momtaz on Momtaz.GTIN=kharazmi.GTIN
--244
left join
(
select ProdName, GTIN, ProdID from stage.web.hasti_Inventory
group by ProdName, GTIN, ProdID  --82
)hasti on hasti.GTIN=kharazmi.GTIN
--244
--left join
--(
--select * from stage.web.Alborz_Inventory
--group by ProdName, GTIN, ProdID  --82
--)Alborz on Alborz.GTIN=kharazmi.GTIN
----244

left join
(
select Product, GTIN, ProductCode from stage.web.Barij_Inventory
group by Product, GTIN, ProductCode  --66
)Barij on Barij.GTIN=kharazmi.GTIN
--245

left join
(
select Product,case when len(GTIN) <14 then CONCAT('0', GTIN) else GTIN end as GTIN, ProductKey from dw..dimproduct
where SupplierCode=100
and ProductStatus=1
and gtin is not null
group by Product, ProductKey ,GTIN --43
)eltiam on eltiam.GTIN=kharazmi.GTIN



GO

insert into dw.kharazmi.dimProductPakhsh
(
ProductID, Number,name, sodorparvane,GTIN, Daya,Qasem,Mahya,Momtaz,hasti,barij, eltiam
)

select 
	ProductID, Number,max( name)name, sodorparvane,max(GTIN)GTIN, max(Daya)Daya,max(Qasem)Qasem
	,max(Mahya)Mahya,max(Momtaz)Momtaz,max(hasti)hasti,max(barij)barij, max(eltiam)eltiam , count(*)
from #dimProductPakhsh d 
--where not exists (select * from dw.kharazmi.dimProductPakhsh p where p.GTIN =d.GTIN)
group by ProductID, Number, sodorparvane
	
	select * from #Dimproductpakhsh 
where gtin in (06260160220937)
order by gtin

--truncate table dw.kharazmi.dimProductPakhsh





	select distinct  product from stage.web.Qhasem_CustomerSales
	where gtin in (06260160202643,
06260160203480)
	
	ProductCode in ( 62211149,
62211150)