SELECT Status_Donation -- 1:waiting  0: Temporary defereed   9,3: Active  
-- plasma: 3: exclusion(mane hamishegi)    0: BloodSample  (sample movafagh)       1: plasma-(ehdaye movafagh)   2:eligibility test (تست)  , null: noaction
--Plasma_Status=0 hich plasmaii ehda nakardan 
--Viro_serum:نتیجه تست ویروسی سرم خون
--DonateSuccessfulStatus: وضیع موفقیت آمیز بودن اهدا
--testresualt:2    va plasma :0: samplemovafagh   1: Ehdamovafagh    2: test



  FROM [Plasma].[dbo].[Tbl_donations]
  where Donor_ID= '03002516'
  order by Save_Date

  select *
  FROM [Plasma].[dbo].[Tbl_donations]
    where Donation_ID in (803333635,
803035040,
803036124,
803213002,
803003056)
	group by Plasma



	select  Viro_serum, count(*)
  FROM [Plasma].[dbo].[Tbl_donations]
  group by Viro_serum



  select * 
    FROM [Plasma].[dbo].[Tbl_donations]
	where Plasma_Status=2


	 select * 
    FROM [Plasma].[dbo].[Tbl_donations]
	where Plasma_Status=3