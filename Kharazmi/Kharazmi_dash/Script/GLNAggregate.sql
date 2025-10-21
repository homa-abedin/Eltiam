

select 
	case when p.gln is null then Customer else name end as CustomerName
	, CustomerCode,case when  p.gln is null then c.gln else p.gln end as GLN
	from stage.web.Qhasem_CustomerSales c
	left join (select GLN, name from Stage.Eltiam.Pharmacies )p on p.GLN= c.GLN
	group by Customer,name, CustomerCode, p.gln,c.gln  --9642, 9332
	-------------Qhasem

union
(
	select case when p.gln is null then Customer else name end as CustomerName
	, CustomerCode,case when  p.gln is null then c.gln else p.gln end as GLN
	from stage.web.Mahya_CustomerSales c
	left join (select GLN, name from Stage.Eltiam.Pharmacies )p on p.GLN= c.GLN
	group by Customer,name, CustomerCode, p.gln,c.gln  --8924
	-----------Mahya

)

union
(
	select case when p.gln is null then c.Customer else name end as CustomerName
	, CustomerCode,case when  p.gln is null then c.gln else p.gln end as GLN
	from stage.web.Momtaz_CustomerSales c
	left join (select GLN, name from Stage.Eltiam.Pharmacies )p on p.GLN= c.GLN
	group by Customer,name, CustomerCode, p.gln,c.gln  --7238
)
-----------Momtaz
--union 
--(
--	select case when p.gln is null then c.CustName else name end as CustomerName
--	, CustID,case when  p.gln is null then c.CustGLN else p.gln end as GLN
--	from stage.web.hasti_CustomerSales c
--	left join (select GLN, name from Stage.Eltiam.Pharmacies )p on p.GLN= c.CustGLN
--	group by  c.CustName,name, CustID, p.gln,c.CustGLN  --7238
--)

union
(
	select case when p.gln is null then c.Customer else name end as CustomerName
	, CustomerCode,case when  p.gln is null then c.gln else p.gln end as GLN
	from stage.web.Barij_CustomerSales c
	left join (select GLN, name from Stage.Eltiam.Pharmacies )p on p.GLN= c.GLN
	group by Customer,name, CustomerCode, p.gln,c.gln  --4014
)
------------Barij
union
(
	select case when p.gln is null then c.Customer else name end as CustomerName
	, CustomerCode,case when  p.gln is null then c.gln else p.gln end as GLN
	from stage.web.Alborz_CustomerSales c
	left join (select GLN, name from Stage.Eltiam.Pharmacies )p on p.GLN= c.GLN
	group by Customer,name, CustomerCode, p.gln,c.gln  --51
)

-------------Alborz

union
(
	select case when p.gln is null then c.Customer else name end as CustomerName
	, CustomerCode,case when  p.gln is null then c.gln else p.gln end as GLN
	from stage.web.Razi_CustomerSales c
	left join (select GLN, name from Stage.Eltiam.Pharmacies )p on p.GLN= c.GLN
	group by Customer,name, CustomerCode, p.gln,c.gln  --6863
)

---------------Razi
union
(
	select case when p.gln is null then c.CustomerName else name end as CustomerName
	, CustomerId,case when  p.gln is null then c.gln else p.gln end as GLN
	from stage.web.Toba_CustomerSales c
	left join (select GLN, name from Stage.Eltiam.Pharmacies )p on p.GLN= c.GLN
	group by c.CustomerName,name, CustomerId, p.gln,c.gln  --2547
)

-----------Toba


--union
--(
--	select case when p.gln is null then c.CustomerName else name end as CustomerName
--	, code,case when  p.gln is null then c.gln else p.gln end as GLN
--	from stage.web.Daya_CustomerSales c
--	left join (select GLN, name from Stage.Eltiam.Pharmacies )p on p.GLN= c.GLN
--	group by c.CustomerName,name, CustomerId, p.gln,c.gln  --2547
--)
--Daya
