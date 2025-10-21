
use DW
GO

drop table if exists #dimProductPakhsh
GO


select 
[LatinBrand]
,[PersianBrand]
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
	[GTIN]
      ,[LatinBrand]
      ,[PersianBrand]
from Stage.Web.[TotalProductImported]
where status not like N'نیازمند ویرایش'
)kharazmi ---232
------------------------------------------------
left join 
(
select ProductId, GTIN, ProductName from stage.web.Daya_CustomerSales
group by ProductId, GTIN, ProductName  --140
)daya on  case when len(daya.GTIN) = 14 then daya.gtin else '0'+daya.GTIN end = case when len(kharazmi.GTIN)=14   then kharazmi.gtin else '0'+ kharazmi.gtin end 
---236
left join 
(
select Product, GTIN, ProductCode from stage.web.Qhasem_CustomerSales
group by Product, GTIN, ProductCode  --104
)Qhasem on  case when len(Qhasem.GTIN) = 14 then Qhasem.gtin else '0'+Qhasem.GTIN end = case when len(kharazmi.GTIN)=14   then kharazmi.gtin else '0'+ kharazmi.gtin end 
--244
left join
(
select Product, GTIN, ProductCode from stage.web.Mahya_ProductSales
group by Product, GTIN, ProductCode  --73
)Mahya on  case when len(Mahya.GTIN) = 14 then Mahya.gtin else '0'+Mahya.GTIN end = case when len(kharazmi.GTIN)=14   then kharazmi.gtin else '0'+ kharazmi.gtin end 
--244

left join
(
select Product, GTIN, ProductCode from stage.web.Momtaz_Products
group by Product, GTIN, ProductCode  --120
)Momtaz on   case when len(Momtaz.GTIN) = 14 then Momtaz.gtin else '0'+Momtaz.GTIN end = case when len(kharazmi.GTIN)=14   then kharazmi.gtin else '0'+ kharazmi.gtin end 
--244
left join
(
select ProdName, GTIN, ProdID from stage.web.hasti_Inventory
group by ProdName, GTIN, ProdID  --82
)hasti on   case when len(hasti.GTIN) = 14 then hasti.gtin else '0'+hasti.GTIN end = case when len(kharazmi.GTIN)=14   then kharazmi.gtin else '0'+ kharazmi.gtin end 
--244
--left join
--(
--select * from stage.web.Alborz_Inventory
--group by ProdName, GTIN, ProdID  --82
--)Alborz on   case when len(Alborz.GTIN) = 14 then Alborz.gtin else '0'+Alborz.GTIN end = case when len(kharazmi.GTIN)=14   then kharazmi.gtin else '0'+ kharazmi.gtin end
----244

left join
(
select Product, GTIN, ProductCode from stage.web.Barij_Inventory
group by Product, GTIN, ProductCode  --66
)Barij on  case when len(Barij.GTIN) = 14 then Barij.gtin else '0'+Barij.GTIN end = case when len(kharazmi.GTIN)=14   then kharazmi.gtin else '0'+ kharazmi.gtin end
--245

left join
(
select Product,case when len(GTIN) <14 then CONCAT('0', GTIN) else GTIN end as GTIN, ProductKey from dw..dimproduct
where SupplierCode=100
and ProductStatus=1
and gtin is not null
group by Product, ProductKey ,GTIN --43
)eltiam on  case when len(eltiam.GTIN) = 14 then eltiam.gtin else '0'+eltiam.GTIN end = case when len(kharazmi.GTIN)=14   then kharazmi.gtin else '0'+ kharazmi.gtin end



GO

insert into dw.kharazmi.dimProductPakhsh
(
[LatinBrand]
,[PersianBrand]
, GTIN
, Daya,Qasem,Mahya,Momtaz,hasti,barij, eltiam
)

select 
	[LatinBrand]
,[PersianBrand]
, GTIN
, max(Daya)Daya,max(Qasem)Qasem
	,max(Mahya)Mahya,max(Momtaz)Momtaz,max(hasti)hasti,max(barij)barij, max(eltiam)eltiam 
from #dimProductPakhsh d 
where not exists (select * from dw.kharazmi.dimProductPakhsh p where p.GTIN =d.GTIN)
group by [LatinBrand]
,[PersianBrand]
, GTIN

	








