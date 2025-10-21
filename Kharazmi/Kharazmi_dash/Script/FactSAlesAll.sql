select null as FactorID, Factordate,  Quantity, Price, IsPrize, BatchNumber, ExpireDate,  p.Id centerID, dc.id CustomerID, dp.productid
, 69319as codepakhsh 
from Stage.Web.Daya_CustomerSales c
join (select * from dw.kharazmi. dimcenterpakhsh) p  on p.Daya= c.CenterId
join (select * from dw.kharazmi. DimCustomerPakhsh) dc  on dc.Daya= c.customercode
join (select * from dw.kharazmi. Dimproductpakhsh) dp  on dp.Daya= c.ProductId
where RecordTypeId= 1

------------------------Daya

select FactorID,Factordate,  Quantity, Price, IsPrize, BatchNumber, ExpireDate,  p.Id centerID, dc.id CustomerID, dp.productid
, 29000 as codepakhsh 
from Stage.Web.Qhasem_CustomerSales c
join (select * from dw.kharazmi. dimcenterpakhsh) p  on p.Qasem= c.CenterCode
join (select * from dw.kharazmi. DimCustomerPakhsh) dc  on dc.Qhasem= c.customercode
join (select * from dw.kharazmi. Dimproductpakhsh) dp  on dp.Qasem= c.ProductCode
where RecordTypeId= 1

-------------------------Qhasem


	select
	ShomarehFaktor as FactorID, date as Factordate,  Quantity- Bonus as Quantity, NetPrice as price,case when Bonus<>0 then 1 else 0 end as  IsPrize
	,Null BatchNumber,null as  ExpireDate,  p.Id centerID, dc.id CustomerID, dp.productid
	, 47000 as codepakhsh 
	from Stage.Web.Mahya_CustomerSales c
	join (select * from dw.kharazmi. dimcenterpakhsh) p  on p.Mahya= c.CenterCode
	join (select * from dw.kharazmi. DimCustomerPakhsh) dc  on dc.Mahya= c.customercode
	join (select * from dw.kharazmi. Dimproductpakhsh) dp  on dp.Mahya= c.ProductCode
	where NoeBarge=N'فروش' 
union 
	select
	ShomarehFaktor as FactorID, date as Factordate,   Bonus as Quantity,0  as price,case when Bonus<>0 then 1 else 0 end as  IsPrize
	,Null BatchNumber,null as  ExpireDate,  p.Id centerID, dc.id CustomerID, dp.productid
	, 47000 as codepakhsh 
	from Stage.Web.Mahya_CustomerSales c
	join (select * from dw.kharazmi. dimcenterpakhsh) p  on p.Mahya= c.CenterCode
	join (select * from dw.kharazmi. DimCustomerPakhsh) dc  on dc.Mahya= c.customercode
	join (select * from dw.kharazmi. Dimproductpakhsh) dp  on dp.Mahya= c.ProductCode
	where NoeBarge=N'فروش'

	-----------------------Mahya

select SalesID FactorID,SalesDate Factordate, ProdQty Quantity,ProdPriceKhales Price,null IsPrize,BatchNo BatchNumber,Null ExpireDate,  p.Id centerID, dc.id CustomerID, dp.productid
, 42000 as codepakhsh 
from Stage.Web.hasti_CustomerSales c
join (select * from dw.kharazmi. dimcenterpakhsh) p  on p.Hasti= c.DSID
join (select * from dw.kharazmi. DimCustomerPakhsh) dc  on dc.Hasti= c.CustID
join (select * from dw.kharazmi. Dimproductpakhsh) dp  on dp.Hasti= c.ProdID
where TypeSales= N'فروش'
and ProdQty>0

----------------hasti

--select ShomarehFaktor FactorID,BillShamsiDate Factordate,  Quantity, Price, IsPrize, BatchNumber, ExpireDate,  p.Id centerID, dc.id CustomerID, dp.productid
--, 12000 as codepakhsh 
--from Stage.Web.Alborz_CustomerSales c
--join (select * from dw.kharazmi. dimcenterpakhsh) p  on p.Qasem= c.CenterCode
--join (select * from dw.kharazmi. DimCustomerPakhsh) dc  on dc.Qhasem= c.customercode
--join (select * from dw.kharazmi. Dimproductpakhsh ) dp  on dp.Qasem= c.ProductCode
--where SaleType= 1


-----------------Alborz  gtin nadare


--select ShomarehFaktor FactorID,Date Factordate,  Quantity, Price,null IsPrize,null BatchNumber,null ExpireDate,  p.Id centerID, dc.id CustomerID, dp.productid
--, 24000 as codepakhsh 
--from Stage.Web.Razi_CustomerSales c
--join (select * from dw.kharazmi. dimcenterpakhsh) p  on p.Razi= c.CenterCode
--join (select * from dw.kharazmi. DimCustomerPakhsh) dc  on dc.Razi= c.customercode
--join (select * from dw.kharazmi. Dimproductpakhsh ) dp  on dp.Razi= c.ProductCode
--where SaleType= 1

--------------------razi   gtin nadare



--select  FactorID, Factordate,  Quantity, Price,case when IsPrize= 0 then 0 else 1 end as IsPrize 
--, BatchNumber, ExpireDate,  p.Id centerID, dc.id CustomerID, dp.productid
--, 69254 as codepakhsh 
--from Stage.Web.Toba_CustomerSales c
--join (select * from dw.kharazmi. dimcenterpakhsh) p  on p.Toba= c.CenterCode
--join (select * from dw.kharazmi. DimCustomerPakhsh) dc  on dc.Toba= c.customercode
--join (select * from dw.kharazmi. Dimproductpakhsh ) dp  on dp.Toba= c.ProductCode
--where RecordTypeId=101
--and Price<>0
-----------------------------------Toba GTIN nadare




	select ShomarehFaktor FactorID,date Factordate,  Quantity,NetPrice as  Price,case when Bonus= 0 then 0 else 1 end as IsPrize 
	,null BatchNumber,null ExpireDate,  p.Id centerID, dc.id CustomerID, dp.productid
	, 29000 as codepakhsh 
	from Stage.Web.Barij_CustomerSales c
	join (select * from dw.kharazmi. dimcenterpakhsh) p  on p.Barij= c.CenterCode
	join (select * from dw.kharazmi. DimCustomerPakhsh) dc  on dc.Barij= c.customercode
	join (select * from dw.kharazmi. Dimproductpakhsh ) dp  on dp.Barij= c.ProductCode
	where 
	 NetPrice<>0 and ReturnQuantity<>0

 union 

	 select ShomarehFaktor FactorID,date Factordate,  Quantity,NetPrice as  Price,case when Bonus= 0 then 0 else 1 end as IsPrize 
	,null BatchNumber,null ExpireDate,  p.Id centerID, dc.id CustomerID, dp.productid
	, 69319 as codepakhsh 
	from Stage.Web.Barij_CustomerSales c
	join (select * from dw.kharazmi. dimcenterpakhsh) p  on    p.Barij= c.CenterCode
	join (select * from dw.kharazmi. DimCustomerPakhsh) dc  on dc.Barij= c.customercode
	join (select * from dw.kharazmi. Dimproductpakhsh ) dp  on dp.Barij= c.ProductCode
	where 
	 NetPrice=0 and ReturnQuantity<>0
	 ------------------------ Barij


	 select InvoiceNumber, DateKey, Quantity ,Price, c.centerkey, case when DiscountQuantity<>0 then 0 else 1 end as isprize
	 ,null BatchNumber,null ExpireDate,  p.Id centerID, dc.id CustomerID, dp.productid
	 select count(*)
	from
	 ( select * from dw..factsales fs
	 join dw..dimcenter dc on dc.id= fs.centerID) c ---16966127
	join  (select * from dw.kharazmi.dimcenterpakhsh) p  on    p.Eltiam= c.centerkey----16966127
	join  (select * from dw.kharazmi.DimCustomerPakhsh) dc  on dc.Eltiam= c.CustomerKey ---13,642,887
	left join  (select * from dw.kharazmi.Dimproductpakhsh  where eltiam is not null) dp  on dp.Eltiam= c.ProductKey ---14,063,410
	where DateKey>=14030101



	select GTIN, count(*) from dw.kharazmi.Dimproductpakhsh 
	where eltiam is not null
	group by GTIN
	having count(*)>1




	select * from dw.kharazmi.Dimproductpakhsh 
where gtin='06260160201615'