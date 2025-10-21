





update t 
set [data] =1 
from [DW].[kharazmi].dimcustomer t 
where t.CustomerID in  (1000, 12000, 20000, 29000, 47000, 48000, 42000,52000, 27000, 12000, 24000, 64000, 69219, 69254, 69257, 69238, 22000, 69237, 69316)




select  CustomerKey as customerid, CustomerCode, customer as [name],CenterKeyNow, CustomerTypeKey, CustomerType, OwnershipType, OwnershipTypeKey, GLN,  20000 as pakhsh  
--into dw.kharazmi.DimCustomerPakhsh
from   dimcustomer
where status=0



select id, centerkey as centerid, CenterName, idprovince, provincename,mycenter, 20000 as pakhsh  
into dw.kharazmi.dimcenterpakhsh

from dimcenter





select * from 
(

 select 
ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id
, BatchNumber
 ,case when IRC_B is null then  LAG(IRC_B) OVER (PARTITION BY productid ORDER BY batchnumber) else IRC_B  end as IRC_B
  ,case when GTIN_B is null then  LAG(GTIN_B) OVER (PARTITION BY productid ORDER BY batchnumber) else GTIN_B  end as GTIN_B

 , productid ,
   productcode 
 ,  productname
 , Status,Summary  
 , null as EnglishName
 , null as ProductidKharazmi
 , 20000 as pakhsh
 --into dw.kharazmi.dimproductpakhsh

from (
   select  w.BatchNumber
   ,case when  w.IRC_B is null then d.IRC else  w.IRC_B end as IRC_B
      ,case when  w.GTIN_B is null then d.GTIN else  w.GTIN_B end as GTIN_B

  , p.Id productid , p.Code productcode , p.name as productname , p.Status,Summary  
   from
   (select BatchNumber,IRC_B, WHSSKU_PUBProduct, GTIN_B  from stage.Eltiam.WHSSKUs
   group by BatchNumber,IRC_B, WHSSKU_PUBProduct, GTIN_B
   ) w
  join (select * from stage.Eltiam.PUBProducts )p on p.id= w. WHSSKU_PUBProduct
LEFT JOIN (select * from  stage.Eltiam.PUBProductDetails ) D
	ON P.Id = D.Id  
    where d.PUBProductDetail_PUBSupplier=118
	and  p.Status=1
		) a
		where IRC_B is not null
	group by 
	BatchNumber,
	IRC_B, GTIN_B, productid , 
	productcode
	,  productname , Status,Summary)p 
	 left join (select * from DW.kharazmi.dimproduct where irc is not null)  dp on dp.IRC= p.IRC_B COLLATE Persian_100_CI_AI












	 select distinct GTIN_B ,IRC_B, p.Name, p.Code, w.BatchNumber from  stage.Eltiam.WHSSKUs w
		join (select * from stage.eltiam.PUBProducts) p on p.Id= w.WHSSKU_PUBProduct
	 
	 where GTIN_B is not null and WHSSKU_PUBProduct=3
	 order by  GTIN_B