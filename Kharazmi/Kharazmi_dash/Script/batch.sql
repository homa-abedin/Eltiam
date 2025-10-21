
select * from (
SELECT   
	po.PartRef, BatchID, b.Number batchnumber,p.Code, po.Number productnumber,po.Name,max (LEFT(bc.CharacteristicValue, 10) )AS Expr1, min(LEFT(bc.CharacteristicValue, 10) )Expr2

FROM [192.168.200.12].[Rahkarandb_sg3].[LGS3].[Batch] b
join (select * FROM   [192.168.200.12].[Rahkarandb_sg3].LGS3.BatchCharacteristic where CharacteristicRef=12)AS bc on bc.BatchRef=b.BatchID
join (select * from [192.168.200.12].[Rahkarandb_sg3].lgs3.Part where PartNature=2) p on p.PartID=b.PartRef 
--join (select * from[192.168.200.12].[Rahkarandb_sg3].[GNR3].[Characteristic])cii on cii.CharacteristicID= bc.CharacteristicRef
--join (select * from[192.168.200.12].[Rahkarandb_sg3].[GNR3].[CharacteristicItem]) ci on cii.CharacteristicID=ci.CharacteristicRef

join (select * from [192.168.200.12].[Rahkarandb_sg3].sls3.Product) po on po.PartRef= p.PartID
join (select [Value],PartRef from [192.168.200.12].[Rahkarandb_sg3].LGS3.PartSpecification where specificationRef=9) GTIN on GTIN.PartRef=p.PartID
join(select distinct ProductRef from Stage.kharazmi.SLS3OrderItem where OrderDate>='2025-03-20')o on o.ProductRef= po.ProductID

where GTIN.Value is not null  
--and b.BatchID = 13782 
and CharacteristicRef=12
group by po.PartRef, BatchID, b.Number,p.Code, po.Number,po.Name
)a 
where Expr2 is null