 truncate table [Stage].[dbo].[Updates]
 insert into [stage].[dbo].[updates]
 (id)
 select sc.invoiceitemID
 from  [stage].[kharazmi].sls3invoiceitem c

 inner join [192.168.200.12].[Rahkarandb_sg3].[SLS3].[invoiceitem] sc on   sc.invoiceitemID=c.invoiceitemID and sc.Version<> c.Version




   insert into [stage].[kharazmi].sls3invoiceitem
(
[InvoiceItemID]
      ,[SalesAreaRef]
      ,[InvoiceRef]
      ,[RowNumber]
      ,[Type]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[Date]
      ,[ProductRef]
      ,[ProductUnitRef]
      ,[PriceBaseUnitRef]
      ,[PriceBaseFee]
      ,[Quantity]
      ,[ProductPackRef]
      ,[ProductPackItemRef]
      ,[ProductPackQuantity]
      ,[MajorUnitQuantity]
      ,[MajorUnitInitialQuantity]
      ,[InitialQuantity]
      ,[ShippingPointRef]
      ,[RecipientType]
      ,[RecipientRef]
      ,[RecipientPartyRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[Version]
      ,[Fee]
      ,[Price]
      ,[PrepaidBaseDocumentRef]
      ,[PrepaidBaseDocumentType]
      ,[PrepaidBaseDocumentReferenceType]
      ,[PrepaidAmount]
      ,[PrepaidAmountSetByUser]
      ,[EffectiveNetPrice]
      ,[Status]
      ,[ReductionAmount]
      ,[AdditionAmount]
      ,[PlantRef]
      ,[InventoryRef]
      ,[Description]
      ,[ParentRef]
      ,[OriginalFreeProductRef]
      ,[FreeProductBusinessPolicyRef]
      ,[FreeProductBusinessPolicyConditionRowRef]
      ,[NetPrice]
      ,[ContractRef]
      ,[ContractItemRef]
      ,[ContractItemVersionNumber]
      ,[HasReservation]
      ,[ReferenceHasReservation]
      ,[TrackingFactor1]
      ,[TrackingFactor2]
      ,[TrackingFactor3]
      ,[TrackingFactor4]
      ,[TrackingFactor5]
      ,[PartTrackingFactorRef1]
      ,[PartTrackingFactorRef2]
      ,[PartTrackingFactorRef3]
      ,[PartTrackingFactorRef4]
      ,[PartTrackingFactorRef5]
      ,[TrackingFactorInputMode1]
      ,[TrackingFactorInputMode2]
      ,[TrackingFactorInputMode3]
      ,[TrackingFactorInputMode4]
      ,[TrackingFactorInputMode5]
      ,[TrackingFactorValue]
      ,[BatchRef]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[InclusiveRelatedInitialQuantity]
      ,[InclusiveRelatedInitialUnit]
      ,[CanSetTrackingFactorManually]
      ,[ExitPolicyRef]
      ,[SettlementRespite]
      ,[IsSettlementRespiteSetByReference]
      ,[CanceledBy]
      ,[CanceledDate]
      ,[isinsert]
      ,[isupdate]   )                  
   select
[InvoiceItemID]
      ,[SalesAreaRef]
      ,[InvoiceRef]
      ,[RowNumber]
      ,[Type]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[Date]
      ,[ProductRef]
      ,[ProductUnitRef]
      ,[PriceBaseUnitRef]
      ,[PriceBaseFee]
      ,[Quantity]
      ,[ProductPackRef]
      ,[ProductPackItemRef]
      ,[ProductPackQuantity]
      ,[MajorUnitQuantity]
      ,[MajorUnitInitialQuantity]
      ,[InitialQuantity]
      ,[ShippingPointRef]
      ,[RecipientType]
      ,[RecipientRef]
      ,[RecipientPartyRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[Version]
      ,[Fee]
      ,[Price]
      ,[PrepaidBaseDocumentRef]
      ,[PrepaidBaseDocumentType]
      ,[PrepaidBaseDocumentReferenceType]
      ,[PrepaidAmount]
      ,[PrepaidAmountSetByUser]
      ,[EffectiveNetPrice]
      ,[Status]
      ,[ReductionAmount]
      ,[AdditionAmount]
      ,[PlantRef]
      ,[InventoryRef]
      ,[Description]
      ,[ParentRef]
      ,[OriginalFreeProductRef]
      ,[FreeProductBusinessPolicyRef]
      ,[FreeProductBusinessPolicyConditionRowRef]
      ,[NetPrice]
      ,[ContractRef]
      ,[ContractItemRef]
      ,[ContractItemVersionNumber]
      ,[HasReservation]
      ,[ReferenceHasReservation]
      ,[TrackingFactor1]
      ,[TrackingFactor2]
      ,[TrackingFactor3]
      ,[TrackingFactor4]
      ,[TrackingFactor5]
      ,[PartTrackingFactorRef1]
      ,[PartTrackingFactorRef2]
      ,[PartTrackingFactorRef3]
      ,[PartTrackingFactorRef4]
      ,[PartTrackingFactorRef5]
      ,[TrackingFactorInputMode1]
      ,[TrackingFactorInputMode2]
      ,[TrackingFactorInputMode3]
      ,[TrackingFactorInputMode4]
      ,[TrackingFactorInputMode5]
      ,[TrackingFactorValue]
      ,[BatchRef]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[InclusiveRelatedInitialQuantity]
      ,[InclusiveRelatedInitialUnit]
      ,[CanSetTrackingFactorManually]
      ,[ExitPolicyRef]
      ,[SettlementRespite]
      ,[IsSettlementRespiteSetByReference]
      ,[CanceledBy]
      ,[CanceledDate]
  ,1
 ,NULL

   FROM [192.168.200.12].[Rahkarandb_sg3].[SLS3].[invoiceitem] invoiceitem
where 
--invoiceitem.date>=cast (cast( year(getdate()) as varchar )+'-01-01' as date) and 
not exists(
 select [invoiceitemId] from [stage].[kharazmi].sls3invoiceitem z1 where z1.[invoiceitemId] = invoiceitem.[invoiceitemId])






 

   insert into [stage].[kharazmi].sls3invoiceitem
(
[InvoiceItemID]
      ,[SalesAreaRef]
      ,[InvoiceRef]
      ,[RowNumber]
      ,[Type]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[Date]
      ,[ProductRef]
      ,[ProductUnitRef]
      ,[PriceBaseUnitRef]
      ,[PriceBaseFee]
      ,[Quantity]
      ,[ProductPackRef]
      ,[ProductPackItemRef]
      ,[ProductPackQuantity]
      ,[MajorUnitQuantity]
      ,[MajorUnitInitialQuantity]
      ,[InitialQuantity]
      ,[ShippingPointRef]
      ,[RecipientType]
      ,[RecipientRef]
      ,[RecipientPartyRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[Version]
      ,[Fee]
      ,[Price]
      ,[PrepaidBaseDocumentRef]
      ,[PrepaidBaseDocumentType]
      ,[PrepaidBaseDocumentReferenceType]
      ,[PrepaidAmount]
      ,[PrepaidAmountSetByUser]
      ,[EffectiveNetPrice]
      ,[Status]
      ,[ReductionAmount]
      ,[AdditionAmount]
      ,[PlantRef]
      ,[InventoryRef]
      ,[Description]
      ,[ParentRef]
      ,[OriginalFreeProductRef]
      ,[FreeProductBusinessPolicyRef]
      ,[FreeProductBusinessPolicyConditionRowRef]
      ,[NetPrice]
      ,[ContractRef]
      ,[ContractItemRef]
      ,[ContractItemVersionNumber]
      ,[HasReservation]
      ,[ReferenceHasReservation]
      ,[TrackingFactor1]
      ,[TrackingFactor2]
      ,[TrackingFactor3]
      ,[TrackingFactor4]
      ,[TrackingFactor5]
      ,[PartTrackingFactorRef1]
      ,[PartTrackingFactorRef2]
      ,[PartTrackingFactorRef3]
      ,[PartTrackingFactorRef4]
      ,[PartTrackingFactorRef5]
      ,[TrackingFactorInputMode1]
      ,[TrackingFactorInputMode2]
      ,[TrackingFactorInputMode3]
      ,[TrackingFactorInputMode4]
      ,[TrackingFactorInputMode5]
      ,[TrackingFactorValue]
      ,[BatchRef]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[InclusiveRelatedInitialQuantity]
      ,[InclusiveRelatedInitialUnit]
      ,[CanSetTrackingFactorManually]
      ,[ExitPolicyRef]
      ,[SettlementRespite]
      ,[IsSettlementRespiteSetByReference]
      ,[CanceledBy]
      ,[CanceledDate]
      ,[isinsert]
      ,[isupdate]   )                  
   select
[InvoiceItemID]
      ,[SalesAreaRef]
      ,[InvoiceRef]
      ,[RowNumber]
      ,[Type]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[Date]
      ,[ProductRef]
      ,[ProductUnitRef]
      ,[PriceBaseUnitRef]
      ,[PriceBaseFee]
      ,[Quantity]
      ,[ProductPackRef]
      ,[ProductPackItemRef]
      ,[ProductPackQuantity]
      ,[MajorUnitQuantity]
      ,[MajorUnitInitialQuantity]
      ,[InitialQuantity]
      ,[ShippingPointRef]
      ,[RecipientType]
      ,[RecipientRef]
      ,[RecipientPartyRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[Version]
      ,[Fee]
      ,[Price]
      ,[PrepaidBaseDocumentRef]
      ,[PrepaidBaseDocumentType]
      ,[PrepaidBaseDocumentReferenceType]
      ,[PrepaidAmount]
      ,[PrepaidAmountSetByUser]
      ,[EffectiveNetPrice]
      ,[Status]
      ,[ReductionAmount]
      ,[AdditionAmount]
      ,[PlantRef]
      ,[InventoryRef]
      ,[Description]
      ,[ParentRef]
      ,[OriginalFreeProductRef]
      ,[FreeProductBusinessPolicyRef]
      ,[FreeProductBusinessPolicyConditionRowRef]
      ,[NetPrice]
      ,[ContractRef]
      ,[ContractItemRef]
      ,[ContractItemVersionNumber]
      ,[HasReservation]
      ,[ReferenceHasReservation]
      ,[TrackingFactor1]
      ,[TrackingFactor2]
      ,[TrackingFactor3]
      ,[TrackingFactor4]
      ,[TrackingFactor5]
      ,[PartTrackingFactorRef1]
      ,[PartTrackingFactorRef2]
      ,[PartTrackingFactorRef3]
      ,[PartTrackingFactorRef4]
      ,[PartTrackingFactorRef5]
      ,[TrackingFactorInputMode1]
      ,[TrackingFactorInputMode2]
      ,[TrackingFactorInputMode3]
      ,[TrackingFactorInputMode4]
      ,[TrackingFactorInputMode5]
      ,[TrackingFactorValue]
      ,[BatchRef]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[InclusiveRelatedInitialQuantity]
      ,[InclusiveRelatedInitialUnit]
      ,[CanSetTrackingFactorManually]
      ,[ExitPolicyRef]
      ,[SettlementRespite]
      ,[IsSettlementRespiteSetByReference]
      ,[CanceledBy]
      ,[CanceledDate]
  ,null
 ,1

   FROM [192.168.200.12].[Rahkarandb_sg3].[SLS3].[invoiceitem] invoiceitem
where 
--invoiceitem.date>=cast (cast( year(getdate()) as varchar )+'-01-01' as date) and 
not exists(
 select [invoiceitemId] from [stage].[kharazmi].sls3invoiceitem z1 where z1.[invoiceitemId] = invoiceitem.[invoiceitemId])



 delete  from kharazmi.SLS3InvoiceItem 
where not exists   (select * from [192.168.200.12].[Rahkarandb_sg3].[sls3].InvoiceItem ii where  ii.invoiceitemid=SLS3InvoiceItem.InvoiceItemID)




  truncate table [Stage_Speedy].[dbo].[Updates]
 insert into [stage_speedy].[dbo].[updates]
 (id)
 select sc.invoiceID
 from  [stage_speedy].[dbo].sls3invoice c

 inner join  [192.168.11.2].[speedy_sg3].[SLS3].[invoice] sc on sc.date>=cast (cast( year(getdate()) as varchar )+'-01-01' as date) and sc.invoiceID=c.invoiceID and sc.Version<> c.Version








  delete  from kharazmi.SLS3Invoice
where not exists   (select * from [192.168.200.12].[Rahkarandb_sg3].[sls3].Invoice ii where  ii.invoiceid=SLS3Invoice.InvoiceID)



 truncate table [Stage].[dbo].[Updates]
 insert into [stage].[dbo].[updates]
 (id)
 select sc.invoiceID
 from  [stage].[kharazmi].sls3invoice c

 inner join [192.168.200.12].[Rahkarandb_sg3].[SLS3].[invoice] sc on   sc.invoiceID=c.invoiceID and sc.Version<> c.Version




    insert into [stage].[kharazmi].sls3invoice
(
 [InvoiceID]
      ,[CompanyRef]
      ,[SalesOfficeRef]
      ,[CurrencyRef]
      ,[OperationalCurrencyExchangeRateRef]
      ,[OperationalCurrencyExchangeRate]
      ,[OperationalCurrencyExchangeRateIsReversed]
      ,[Number]
      ,[AutoNumber]
      ,[Date]
      ,[CustomerRef]
      ,[OneTimeCustomerRef]
      ,[BrokerRef]
      ,[AgentRef]
      ,[PayerType]
      ,[PayerAccountRef]
      ,[DeliveryMethod]
      ,[ShippingPointRef]
      ,[InventoryRef]
      ,[RecipientType]
      ,[RecipientRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[DeliveryState]
      ,[InitiallyDelivered]
      ,[PlantRef]
      ,[Price]
      ,[AdditionAmount]
      ,[ReductionAmount]
      ,[EffectiveNetPrice]
      ,[NetPrice]
      ,[Status]
      ,[Creator]
      ,[CreationDate]
      ,[LastModifier]
      ,[LastModificationDate]
      ,[SalesAreaRef]
      ,[CalculationDate]
      ,[FiscalYearRef]
      ,[BranchRef]
      ,[CustomerType]
      ,[PaymentAgreementRef]
      ,[SalesTypeRef]
      ,[AmendState]
      ,[Description]
      ,[ContractRef]
      ,[PolicyCalculationDateType]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[ReferenceInvoiceRef]
      ,[PolicyCalculationConsideringBaseDocumentPolicyIsApplied]
      ,[TotalWeight]
      ,[WeightUnitRef]
      ,[TotalVolume]
      ,[VolumeUnitRef]
      ,[Version]
      ,[SettlementRespite]
      ,[IsSettlementRespiteCalculated]
      ,[SettlementDate]
      ,[IsImported]
      ,[WithoutDistributorUnderTaker]
      ,[ContributionInTaxPayerBillCollection]
      ,[WithoutUndertaker]
      ,[ContractRegistrationNumber]
      ,[isinsert]
      ,[isupdate]   )                  
   select
 [InvoiceID]
      ,[CompanyRef]
      ,[SalesOfficeRef]
      ,[CurrencyRef]
      ,[OperationalCurrencyExchangeRateRef]
      ,[OperationalCurrencyExchangeRate]
      ,[OperationalCurrencyExchangeRateIsReversed]
      ,[Number]
      ,[AutoNumber]
      ,[Date]
      ,[CustomerRef]
      ,[OneTimeCustomerRef]
      ,[BrokerRef]
      ,[AgentRef]
      ,[PayerType]
      ,[PayerAccountRef]
      ,[DeliveryMethod]
      ,[ShippingPointRef]
      ,[InventoryRef]
      ,[RecipientType]
      ,[RecipientRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[DeliveryState]
      ,[InitiallyDelivered]
      ,[PlantRef]
      ,[Price]
      ,[AdditionAmount]
      ,[ReductionAmount]
      ,[EffectiveNetPrice]
      ,[NetPrice]
      ,[Status]
      ,[Creator]
      ,[CreationDate]
      ,[LastModifier]
      ,[LastModificationDate]
      ,[SalesAreaRef]
      ,[CalculationDate]
      ,[FiscalYearRef]
      ,[BranchRef]
      ,[CustomerType]
      ,[PaymentAgreementRef]
      ,[SalesTypeRef]
      ,[AmendState]
      ,[Description]
      ,[ContractRef]
      ,[PolicyCalculationDateType]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[ReferenceInvoiceRef]
      ,[PolicyCalculationConsideringBaseDocumentPolicyIsApplied]
      ,[TotalWeight]
      ,[WeightUnitRef]
      ,[TotalVolume]
      ,[VolumeUnitRef]
      ,[Version]
      ,[SettlementRespite]
      ,[IsSettlementRespiteCalculated]
      ,[SettlementDate]
      ,[IsImported]
      ,[WithoutDistributorUnderTaker]
      ,[ContributionInTaxPayerBillCollection]
      ,[WithoutUndertaker]
      ,[ContractRegistrationNumber] 
	  ,1
 ,NULL

   FROM [192.168.200.12].[Rahkarandb_sg3].[SLS3].[invoice] invoiceitem
where 
--invoiceitem.date>=cast (cast( year(getdate()) as varchar )+'-01-01' as date) and 
not exists(
 select [invoiceId] from [stage].[kharazmi].sls3invoice z1 where z1.[invoiceId] = invoiceitem.[invoiceId])


  delete ft 
  from [stage].[kharazmi].[sls3invoice] ft
 inner join (select * from [stage].[dbo].updates) tft1 on tft1.[id]=ft.[invoiceID]





     insert into [stage].[kharazmi].sls3invoice
(
 [InvoiceID]
      ,[CompanyRef]
      ,[SalesOfficeRef]
      ,[CurrencyRef]
      ,[OperationalCurrencyExchangeRateRef]
      ,[OperationalCurrencyExchangeRate]
      ,[OperationalCurrencyExchangeRateIsReversed]
      ,[Number]
      ,[AutoNumber]
      ,[Date]
      ,[CustomerRef]
      ,[OneTimeCustomerRef]
      ,[BrokerRef]
      ,[AgentRef]
      ,[PayerType]
      ,[PayerAccountRef]
      ,[DeliveryMethod]
      ,[ShippingPointRef]
      ,[InventoryRef]
      ,[RecipientType]
      ,[RecipientRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[DeliveryState]
      ,[InitiallyDelivered]
      ,[PlantRef]
      ,[Price]
      ,[AdditionAmount]
      ,[ReductionAmount]
      ,[EffectiveNetPrice]
      ,[NetPrice]
      ,[Status]
      ,[Creator]
      ,[CreationDate]
      ,[LastModifier]
      ,[LastModificationDate]
      ,[SalesAreaRef]
      ,[CalculationDate]
      ,[FiscalYearRef]
      ,[BranchRef]
      ,[CustomerType]
      ,[PaymentAgreementRef]
      ,[SalesTypeRef]
      ,[AmendState]
      ,[Description]
      ,[ContractRef]
      ,[PolicyCalculationDateType]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[ReferenceInvoiceRef]
      ,[PolicyCalculationConsideringBaseDocumentPolicyIsApplied]
      ,[TotalWeight]
      ,[WeightUnitRef]
      ,[TotalVolume]
      ,[VolumeUnitRef]
      ,[Version]
      ,[SettlementRespite]
      ,[IsSettlementRespiteCalculated]
      ,[SettlementDate]
      ,[IsImported]
      ,[WithoutDistributorUnderTaker]
      ,[ContributionInTaxPayerBillCollection]
      ,[WithoutUndertaker]
      ,[ContractRegistrationNumber]
      ,[isinsert]
      ,[isupdate]   )                  
   select
 [InvoiceID]
      ,[CompanyRef]
      ,[SalesOfficeRef]
      ,[CurrencyRef]
      ,[OperationalCurrencyExchangeRateRef]
      ,[OperationalCurrencyExchangeRate]
      ,[OperationalCurrencyExchangeRateIsReversed]
      ,[Number]
      ,[AutoNumber]
      ,[Date]
      ,[CustomerRef]
      ,[OneTimeCustomerRef]
      ,[BrokerRef]
      ,[AgentRef]
      ,[PayerType]
      ,[PayerAccountRef]
      ,[DeliveryMethod]
      ,[ShippingPointRef]
      ,[InventoryRef]
      ,[RecipientType]
      ,[RecipientRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[DeliveryState]
      ,[InitiallyDelivered]
      ,[PlantRef]
      ,[Price]
      ,[AdditionAmount]
      ,[ReductionAmount]
      ,[EffectiveNetPrice]
      ,[NetPrice]
      ,[Status]
      ,[Creator]
      ,[CreationDate]
      ,[LastModifier]
      ,[LastModificationDate]
      ,[SalesAreaRef]
      ,[CalculationDate]
      ,[FiscalYearRef]
      ,[BranchRef]
      ,[CustomerType]
      ,[PaymentAgreementRef]
      ,[SalesTypeRef]
      ,[AmendState]
      ,[Description]
      ,[ContractRef]
      ,[PolicyCalculationDateType]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[ReferenceInvoiceRef]
      ,[PolicyCalculationConsideringBaseDocumentPolicyIsApplied]
      ,[TotalWeight]
      ,[WeightUnitRef]
      ,[TotalVolume]
      ,[VolumeUnitRef]
      ,[Version]
      ,[SettlementRespite]
      ,[IsSettlementRespiteCalculated]
      ,[SettlementDate]
      ,[IsImported]
      ,[WithoutDistributorUnderTaker]
      ,[ContributionInTaxPayerBillCollection]
      ,[WithoutUndertaker]
      ,[ContractRegistrationNumber] 
	  ,NUll
 ,1

   FROM [192.168.200.12].[Rahkarandb_sg3].[SLS3].[invoice] invoiceitem
where 
--invoiceitem.date>=cast (cast( year(getdate()) as varchar )+'-01-01' as date) and 
not exists(
 select [invoiceId] from [stage].[kharazmi].sls3invoice z1 where z1.[invoiceId] = invoiceitem.[invoiceId])




   delete  from kharazmi.SLS3order
where not exists   (select * from [192.168.200.12].[Rahkarandb_sg3].[sls3].[order] ii where  ii.orderid=SLS3order.orderID)




 truncate table [Stage].[dbo].[Updates]
 insert into [stage].[dbo].[updates]
 (id)
 select sc.orderID
 from  [stage].[kharazmi].SLS3order c

 inner join [192.168.200.12].[Rahkarandb_sg3].[SLS3].[order] sc on   sc.orderID=c.orderID and sc.Version<> c.Version




 

    insert into [stage].[kharazmi].sls3order
(
  [OrderID]
      ,[Number]
      ,[State]
      ,[CustomerType]
      ,[CustomerRef]
      ,[Price]
      ,[AdditionAmount]
      ,[ReductionAmount]
      ,[NetPrice]
      ,[EffectiveNetPrice]
      ,[CurrencyRef]
      ,[OperationalCurrencyExchangeRateRef]
      ,[OperationalCurrencyExchangeRate]
      ,[OperationalCurrencyExchangeRateIsReversed]
      ,[Date]
      ,[DeliveryDate]
      ,[SalesOfficeRef]
      ,[CompanyRef]
      ,[SalesAreaRef]
      ,[PayerType]
      ,[RecipientType]
      ,[RecipientRef]
      ,[RecipientPartyRef]
      ,[CustomRecipientName]
      ,[CustomRecipientPhoneNo]
      ,[CustomRecipientEMail]
      ,[BrokerRef]
      ,[AgentRef]
      ,[ShippingPointRef]
      ,[LoadingPointRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[DeliveryAddressAsFinal]
      ,[CustomDeliveryAddressRef]
      ,[ExpirationDate]
      ,[OneTimeCustomerRef]
      ,[PayerAccountRef]
      ,[Creator]
      ,[CreationDate]
      ,[LastModifier]
      ,[LastModificationDate]
      ,[PlantRef]
      ,[InventoryRef]
      ,[CalculationDate]
      ,[FiscalYearRef]
      ,[BranchRef]
      ,[Type]
      ,[DeliveryPlaceType]
      ,[DeliveryPlaceref]
      ,[TransportationType]
      ,[PaymentAgreementRef]
      ,[SalesTypeRef]
      ,[DeliveryMethod]
      ,[BillIssueTime]
      ,[PrepaidAmount]
      ,[ContractRef]
      ,[PolicyCalculationDateType]
      ,[IsImported]
      ,[NoPolicyCalculation]
      ,[DistributionShiftRef]
      ,[DistributionShiftIsFixed]
      ,[TotalWeight]
      ,[WeightUnitRef]
      ,[TotalVolume]
      ,[VolumeUnitRef]
      ,[Description]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[Version]
      ,[SettlementRespite]
      ,[IsSettlementRespiteCalculated]
      ,[WithoutDistributorUnderTaker]
      ,[WithoutUndertaker]
      ,[isinsert]
      ,[isupdate]
	  )                  
   select
 [OrderID]
      ,[Number]
      ,[State]
      ,[CustomerType]
      ,[CustomerRef]
      ,[Price]
      ,[AdditionAmount]
      ,[ReductionAmount]
      ,[NetPrice]
      ,[EffectiveNetPrice]
      ,[CurrencyRef]
      ,[OperationalCurrencyExchangeRateRef]
      ,[OperationalCurrencyExchangeRate]
      ,[OperationalCurrencyExchangeRateIsReversed]
      ,[Date]
      ,[DeliveryDate]
      ,[SalesOfficeRef]
      ,[CompanyRef]
      ,[SalesAreaRef]
      ,[PayerType]
      ,[RecipientType]
      ,[RecipientRef]
      ,[RecipientPartyRef]
      ,[CustomRecipientName]
      ,[CustomRecipientPhoneNo]
      ,[CustomRecipientEMail]
      ,[BrokerRef]
      ,[AgentRef]
      ,[ShippingPointRef]
      ,[LoadingPointRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[DeliveryAddressAsFinal]
      ,[CustomDeliveryAddressRef]
      ,[ExpirationDate]
      ,[OneTimeCustomerRef]
      ,[PayerAccountRef]
      ,[Creator]
      ,[CreationDate]
      ,[LastModifier]
      ,[LastModificationDate]
      ,[PlantRef]
      ,[InventoryRef]
      ,[CalculationDate]
      ,[FiscalYearRef]
      ,[BranchRef]
      ,[Type]
      ,[DeliveryPlaceType]
      ,[DeliveryPlaceref]
      ,[TransportationType]
      ,[PaymentAgreementRef]
      ,[SalesTypeRef]
      ,[DeliveryMethod]
      ,[BillIssueTime]
      ,[PrepaidAmount]
      ,[ContractRef]
      ,[PolicyCalculationDateType]
      ,[IsImported]
      ,[NoPolicyCalculation]
      ,[DistributionShiftRef]
      ,[DistributionShiftIsFixed]
      ,[TotalWeight]
      ,[WeightUnitRef]
      ,[TotalVolume]
      ,[VolumeUnitRef]
      ,[Description]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[Version]
      ,[SettlementRespite]
      ,[IsSettlementRespiteCalculated]
      ,[WithoutDistributorUnderTaker]
      ,[WithoutUndertaker]
   ,1
 ,NULL

   FROM [192.168.200.12].[Rahkarandb_sg3].[SLS3].[order] invoiceitem
where 
--invoiceitem.date>=cast (cast( year(getdate()) as varchar )+'-01-01' as date) and 
not exists(
 select [orderId] from [stage].[kharazmi].sls3order z1 where z1.[orderId] = invoiceitem.[orderId])



 
  delete ft 
  from [stage].[kharazmi].[sls3order] ft
 inner join (select * from [stage].[dbo].updates) tft1 on tft1.[id]=ft.[orderID]




    insert into [stage].[kharazmi].sls3order
(
  [OrderID]
      ,[Number]
      ,[State]
      ,[CustomerType]
      ,[CustomerRef]
      ,[Price]
      ,[AdditionAmount]
      ,[ReductionAmount]
      ,[NetPrice]
      ,[EffectiveNetPrice]
      ,[CurrencyRef]
      ,[OperationalCurrencyExchangeRateRef]
      ,[OperationalCurrencyExchangeRate]
      ,[OperationalCurrencyExchangeRateIsReversed]
      ,[Date]
      ,[DeliveryDate]
      ,[SalesOfficeRef]
      ,[CompanyRef]
      ,[SalesAreaRef]
      ,[PayerType]
      ,[RecipientType]
      ,[RecipientRef]
      ,[RecipientPartyRef]
      ,[CustomRecipientName]
      ,[CustomRecipientPhoneNo]
      ,[CustomRecipientEMail]
      ,[BrokerRef]
      ,[AgentRef]
      ,[ShippingPointRef]
      ,[LoadingPointRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[DeliveryAddressAsFinal]
      ,[CustomDeliveryAddressRef]
      ,[ExpirationDate]
      ,[OneTimeCustomerRef]
      ,[PayerAccountRef]
      ,[Creator]
      ,[CreationDate]
      ,[LastModifier]
      ,[LastModificationDate]
      ,[PlantRef]
      ,[InventoryRef]
      ,[CalculationDate]
      ,[FiscalYearRef]
      ,[BranchRef]
      ,[Type]
      ,[DeliveryPlaceType]
      ,[DeliveryPlaceref]
      ,[TransportationType]
      ,[PaymentAgreementRef]
      ,[SalesTypeRef]
      ,[DeliveryMethod]
      ,[BillIssueTime]
      ,[PrepaidAmount]
      ,[ContractRef]
      ,[PolicyCalculationDateType]
      ,[IsImported]
      ,[NoPolicyCalculation]
      ,[DistributionShiftRef]
      ,[DistributionShiftIsFixed]
      ,[TotalWeight]
      ,[WeightUnitRef]
      ,[TotalVolume]
      ,[VolumeUnitRef]
      ,[Description]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[Version]
      ,[SettlementRespite]
      ,[IsSettlementRespiteCalculated]
      ,[WithoutDistributorUnderTaker]
      ,[WithoutUndertaker]
      ,[isinsert]
      ,[isupdate]
	  )                  
   select
 [OrderID]
      ,[Number]
      ,[State]
      ,[CustomerType]
      ,[CustomerRef]
      ,[Price]
      ,[AdditionAmount]
      ,[ReductionAmount]
      ,[NetPrice]
      ,[EffectiveNetPrice]
      ,[CurrencyRef]
      ,[OperationalCurrencyExchangeRateRef]
      ,[OperationalCurrencyExchangeRate]
      ,[OperationalCurrencyExchangeRateIsReversed]
      ,[Date]
      ,[DeliveryDate]
      ,[SalesOfficeRef]
      ,[CompanyRef]
      ,[SalesAreaRef]
      ,[PayerType]
      ,[RecipientType]
      ,[RecipientRef]
      ,[RecipientPartyRef]
      ,[CustomRecipientName]
      ,[CustomRecipientPhoneNo]
      ,[CustomRecipientEMail]
      ,[BrokerRef]
      ,[AgentRef]
      ,[ShippingPointRef]
      ,[LoadingPointRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[DeliveryAddressAsFinal]
      ,[CustomDeliveryAddressRef]
      ,[ExpirationDate]
      ,[OneTimeCustomerRef]
      ,[PayerAccountRef]
      ,[Creator]
      ,[CreationDate]
      ,[LastModifier]
      ,[LastModificationDate]
      ,[PlantRef]
      ,[InventoryRef]
      ,[CalculationDate]
      ,[FiscalYearRef]
      ,[BranchRef]
      ,[Type]
      ,[DeliveryPlaceType]
      ,[DeliveryPlaceref]
      ,[TransportationType]
      ,[PaymentAgreementRef]
      ,[SalesTypeRef]
      ,[DeliveryMethod]
      ,[BillIssueTime]
      ,[PrepaidAmount]
      ,[ContractRef]
      ,[PolicyCalculationDateType]
      ,[IsImported]
      ,[NoPolicyCalculation]
      ,[DistributionShiftRef]
      ,[DistributionShiftIsFixed]
      ,[TotalWeight]
      ,[WeightUnitRef]
      ,[TotalVolume]
      ,[VolumeUnitRef]
      ,[Description]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[Version]
      ,[SettlementRespite]
      ,[IsSettlementRespiteCalculated]
      ,[WithoutDistributorUnderTaker]
      ,[WithoutUndertaker]
   ,Null
 ,1

   FROM [192.168.200.12].[Rahkarandb_sg3].[SLS3].[order] invoiceitem
where 
--invoiceitem.date>=cast (cast( year(getdate()) as varchar )+'-01-01' as date) and 
not exists(
 select [orderId] from [stage].[kharazmi].sls3order z1 where z1.[orderId] = invoiceitem.[orderId])






 
   delete  from kharazmi.SLS3orderitem
where not exists   (select * from [192.168.200.12].[Rahkarandb_sg3].[sls3].[orderitem] ii where  ii.orderitemid=SLS3orderitem.orderitemID)



 truncate table [Stage].[dbo].[Updates]
 insert into [stage].[dbo].[updates]
 (id)
 select sc.orderitemID
 from  [stage].[kharazmi].SLS3orderitem c

 inner join [192.168.200.12].[Rahkarandb_sg3].[SLS3].[orderitem] sc on   sc.orderitemID=c.orderitemID and sc.Version<> c.Version





  

    insert into [stage].[kharazmi].sls3orderitem
(
   [OrderItemID]
      ,[OrderRef]
      ,[OrderNumber]
      ,[OrderDate]
      ,[RowNumber]
      ,[Type]
      ,[State]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[ProductRef]
      ,[ProductUnitRef]
      ,[PriceBaseUnitRef]
      ,[PriceBaseFee]
      ,[Quantity]
      ,[ProductPackRef]
      ,[ProductPackItemRef]
      ,[ProductPackQuantity]
      ,[PackagingMethodRef]
      ,[PackageRef]
      ,[MajorUnitQuantity]
      ,[InitialQuantity]
      ,[MajorUnitInitialQuantity]
      ,[Tolerance]
      ,[Fee]
      ,[Price]
      ,[AdditionAmount]
      ,[ReductionAmount]
      ,[NetPrice]
      ,[EffectiveNetPrice]
      ,[SalesAreaRef]
      ,[RecipientType]
      ,[RecipientRef]
      ,[RecipientPartyRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[DeliveryAddressAsFinal]
      ,[CustomDeliveryAddressRef]
      ,[ShippingPointRef]
      ,[LoadingPointRef]
      ,[BaseDeliveryAddressRef]
      ,[OriginalFreeProductRef]
      ,[FreeProductBusinessPolicyRef]
      ,[FreeProductBusinessPolicyConditionRowRef]
      ,[ParentRef]
      ,[Description]
      ,[OperationalCurrencyExchangeRateRef]
      ,[DestinationCountryRef]
      ,[ContractRef]
      ,[ContractItemRef]
      ,[ContractItemVersionNumber]
      ,[HasReservation]
      ,[ReferenceHasReservation]
      ,[TrackingFactor1]
      ,[TrackingFactor2]
      ,[TrackingFactor3]
      ,[TrackingFactor4]
      ,[TrackingFactor5]
      ,[PartTrackingFactorRef1]
      ,[PartTrackingFactorRef2]
      ,[PartTrackingFactorRef3]
      ,[PartTrackingFactorRef4]
      ,[PartTrackingFactorRef5]
      ,[TrackingFactorInputMode1]
      ,[TrackingFactorInputMode2]
      ,[TrackingFactorInputMode3]
      ,[TrackingFactorInputMode4]
      ,[TrackingFactorInputMode5]
      ,[TrackingFactorValue]
      ,[BatchRef]
      ,[MaxIncreasePercent]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[InclusiveRelatedInitialQuantity]
      ,[InclusiveRelatedInitialUnit]
      ,[CanSetTrackingFactorManually]
      ,[ExitPolicyRef]
      ,[Version]
      ,[SettlementRespite]
      ,[IsSettlementRespiteSetByReference]
      ,[ReserveStatus]
      ,[isinsert]
      ,[isupdate]
   )                  
   select
 [OrderItemID]
      ,[OrderRef]
      ,[OrderNumber]
      ,[OrderDate]
      ,[RowNumber]
      ,[Type]
      ,[State]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[ProductRef]
      ,[ProductUnitRef]
      ,[PriceBaseUnitRef]
      ,[PriceBaseFee]
      ,[Quantity]
      ,[ProductPackRef]
      ,[ProductPackItemRef]
      ,[ProductPackQuantity]
      ,[PackagingMethodRef]
      ,[PackageRef]
      ,[MajorUnitQuantity]
      ,[InitialQuantity]
      ,[MajorUnitInitialQuantity]
      ,[Tolerance]
      ,[Fee]
      ,[Price]
      ,[AdditionAmount]
      ,[ReductionAmount]
      ,[NetPrice]
      ,[EffectiveNetPrice]
      ,[SalesAreaRef]
      ,[RecipientType]
      ,[RecipientRef]
      ,[RecipientPartyRef]
      ,[DeliveryAddressType]
      ,[DeliveryAddressRef]
      ,[DeliveryAddressAsFinal]
      ,[CustomDeliveryAddressRef]
      ,[ShippingPointRef]
      ,[LoadingPointRef]
      ,[BaseDeliveryAddressRef]
      ,[OriginalFreeProductRef]
      ,[FreeProductBusinessPolicyRef]
      ,[FreeProductBusinessPolicyConditionRowRef]
      ,[ParentRef]
      ,[Description]
      ,[OperationalCurrencyExchangeRateRef]
      ,[DestinationCountryRef]
      ,[ContractRef]
      ,[ContractItemRef]
      ,[ContractItemVersionNumber]
      ,[HasReservation]
      ,[ReferenceHasReservation]
      ,[TrackingFactor1]
      ,[TrackingFactor2]
      ,[TrackingFactor3]
      ,[TrackingFactor4]
      ,[TrackingFactor5]
      ,[PartTrackingFactorRef1]
      ,[PartTrackingFactorRef2]
      ,[PartTrackingFactorRef3]
      ,[PartTrackingFactorRef4]
      ,[PartTrackingFactorRef5]
      ,[TrackingFactorInputMode1]
      ,[TrackingFactorInputMode2]
      ,[TrackingFactorInputMode3]
      ,[TrackingFactorInputMode4]
      ,[TrackingFactorInputMode5]
      ,[TrackingFactorValue]
      ,[BatchRef]
      ,[MaxIncreasePercent]
      ,[IncludedPolicies]
      ,[ExcludedPolicies]
      ,[InclusiveRelatedInitialQuantity]
      ,[InclusiveRelatedInitialUnit]
      ,[CanSetTrackingFactorManually]
      ,[ExitPolicyRef]
      ,[Version]
      ,[SettlementRespite]
      ,[IsSettlementRespiteSetByReference]
      ,[ReserveStatus]
   ,null
 ,1

   FROM [192.168.200.12].[Rahkarandb_sg3].[SLS3].[orderitem] invoiceitem
where 
--invoiceitem.date>=cast (cast( year(getdate()) as varchar )+'-01-01' as date) and 
not exists(
 select [orderitemId] from [stage].[kharazmi].sls3orderitem z1 where z1.[orderitemId] = invoiceitem.[orderitemId])






    delete ft 
  from [stage].[kharazmi].[sls3orderitem] ft
 inner join (select * from [stage].[dbo].updates) tft1 on tft1.[id]=ft.[orderitemID]




 
   delete  from kharazmi.LGS3IssuePermit
where not exists   (select * from [192.168.200.12].[Rahkarandb_sg3].[LGS3].[IssuePermit] ii where  ii.IssuePermitid=LGS3IssuePermit.IssuePermitID)


 truncate table [Stage].[dbo].[Updates]
 insert into [stage].[dbo].[updates]
 (id)
 select sc.IssuePermitID
 from  [stage].[kharazmi].LGS3IssuePermit c

 inner join [192.168.200.12].[Rahkarandb_sg3].[LGS3].[IssuePermit] sc on   sc.IssuePermitID=c.IssuePermitID and sc.Version<> c.Version



  

    insert into [stage].[kharazmi].LGS3IssuePermit
(
 [IssuePermitID]
      ,[Date]
      ,[ShippingPointRef]
      ,[StoreRef]
      ,[RecipientRef]
      ,[Version]
      ,[ExpirationDate]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[PlantRef]
      ,[State]
      ,[CounterpartEntityCode]
      ,[CounterpartEntityRef]
      ,[CounterpartEntityText]
      ,[CounterpartStoreRef]
      ,[Number]
      ,[BranchRef]
      ,[Additional1]
      ,[Additional2]
      ,[Additional3]
      ,[Additional4]
      ,[Additional5]
      ,[IssuePermitType]
      ,[RegisterBranchRef]
      ,[CreationDate]
      ,[LastModificationDate]
      ,[Creator]
      ,[LastModifier]
      ,[FiscalYearRef]
      ,[LedgerRef]
      ,[CounterpartPlantRef]
      ,[PrevState]
      ,[Description]
      ,[isinert]
      ,[isupdate]
   )                  
   select
 [IssuePermitID]
      ,[Date]
      ,[ShippingPointRef]
      ,[StoreRef]
      ,[RecipientRef]
      ,[Version]
      ,[ExpirationDate]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[PlantRef]
      ,[State]
      ,[CounterpartEntityCode]
      ,[CounterpartEntityRef]
      ,[CounterpartEntityText]
      ,[CounterpartStoreRef]
      ,[Number]
      ,[BranchRef]
      ,[Additional1]
      ,[Additional2]
      ,[Additional3]
      ,[Additional4]
      ,[Additional5]
      ,[IssuePermitType]
      ,[RegisterBranchRef]
      ,[CreationDate]
      ,[LastModificationDate]
      ,[Creator]
      ,[LastModifier]
      ,[FiscalYearRef]
      ,[LedgerRef]
      ,[CounterpartPlantRef]
      ,[PrevState]
      ,[Description]
   ,1
 ,NULL

   FROM [192.168.200.12].[Rahkarandb_sg3].[LGS3].[IssuePermit] invoiceitem
where 
--invoiceitem.date>=cast (cast( year(getdate()) as varchar )+'-01-01' as date) and 
not exists(
 select [IssuePermitId] from [stage].[kharazmi].LGS3IssuePermit z1 where z1.[IssuePermitId] = invoiceitem.[IssuePermitId])




   delete ft 
  from [stage].[kharazmi].[LGS3IssuePermit] ft
 inner join (select * from [stage].[dbo].updates) tft1 on tft1.[id]=ft.[IssuePermitID]




   

    insert into [stage].[kharazmi].LGS3IssuePermit
(
 [IssuePermitID]
      ,[Date]
      ,[ShippingPointRef]
      ,[StoreRef]
      ,[RecipientRef]
      ,[Version]
      ,[ExpirationDate]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[PlantRef]
      ,[State]
      ,[CounterpartEntityCode]
      ,[CounterpartEntityRef]
      ,[CounterpartEntityText]
      ,[CounterpartStoreRef]
      ,[Number]
      ,[BranchRef]
      ,[Additional1]
      ,[Additional2]
      ,[Additional3]
      ,[Additional4]
      ,[Additional5]
      ,[IssuePermitType]
      ,[RegisterBranchRef]
      ,[CreationDate]
      ,[LastModificationDate]
      ,[Creator]
      ,[LastModifier]
      ,[FiscalYearRef]
      ,[LedgerRef]
      ,[CounterpartPlantRef]
      ,[PrevState]
      ,[Description]
      ,[isinert]
      ,[isupdate]
   )                  
   select
 [IssuePermitID]
      ,[Date]
      ,[ShippingPointRef]
      ,[StoreRef]
      ,[RecipientRef]
      ,[Version]
      ,[ExpirationDate]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[PlantRef]
      ,[State]
      ,[CounterpartEntityCode]
      ,[CounterpartEntityRef]
      ,[CounterpartEntityText]
      ,[CounterpartStoreRef]
      ,[Number]
      ,[BranchRef]
      ,[Additional1]
      ,[Additional2]
      ,[Additional3]
      ,[Additional4]
      ,[Additional5]
      ,[IssuePermitType]
      ,[RegisterBranchRef]
      ,[CreationDate]
      ,[LastModificationDate]
      ,[Creator]
      ,[LastModifier]
      ,[FiscalYearRef]
      ,[LedgerRef]
      ,[CounterpartPlantRef]
      ,[PrevState]
      ,[Description]
   ,null
 ,1

   FROM [192.168.200.12].[Rahkarandb_sg3].[LGS3].[IssuePermit] invoiceitem
where 
--invoiceitem.date>=cast (cast( year(getdate()) as varchar )+'-01-01' as date) and 
not exists(
 select [IssuePermitId] from [stage].[kharazmi].LGS3IssuePermit z1 where z1.[IssuePermitId] = invoiceitem.[IssuePermitId])





    delete  from kharazmi.LGS3IssuePermit
where not exists   (select * from [192.168.200.12].[Rahkarandb_sg3].[LGS3].[IssuePermit] ii 
where  ii.IssuePermitid=LGS3IssuePermit.IssuePermitID)


 
 
   delete  from kharazmi.LGS3IssuePermitItem
where not exists   (  SELECT [IssuePermitItemID] FROM OPENQUERY([192.168.200.12], 'select [IssuePermitItemID] from [Rahkarandb_sg3].[LGS3].[IssuePermititem]')ii  
where  ii.IssuePermititemid=LGS3IssuePermititem.IssuePermititemID)





 truncate table [Stage].[dbo].[Updates]
 insert into [stage].[dbo].[updates]
 (id)
 select sc.IssuePermitItemID
 from  [stage].kharazmi.LGS3IssuePermitItem c

 inner join ( SELECT  
 [IssuePermitItemID]
 ,[IssuePermitRef]
      ,[RowNumber]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[PartRef]
      ,[UnitRef]
      ,[PartUnitRef]
      ,[Quantity]
      ,[MajorUnitQuantity]
      ,[State]
      ,[Version]
      ,[CounterpartEntityCode]
      ,[CounterpartEntityRef]
      ,[CounterpartEntityText]
      ,[Additional1]
      ,[Additional2]
      ,[Additional3]
      ,[Additional4]
      ,[Additional5]
      ,[IssuePermitTolerancePercent]
      ,[MaxMajorUnitQuantity]
      ,[PrevState]
      ,[ReferenceCode]
      ,[Description] FROM OPENQUERY([192.168.200.12], 'select
	  [IssuePermitItemID]
      ,[IssuePermitRef]
      ,[RowNumber]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[PartRef]
      ,[UnitRef]
      ,[PartUnitRef]
      ,[Quantity]
      ,[MajorUnitQuantity]
      ,[State]
      ,[Version]
      ,[CounterpartEntityCode]
      ,[CounterpartEntityRef]
      ,[CounterpartEntityText]
      ,[Additional1]
      ,[Additional2]
      ,[Additional3]
      ,[Additional4]
      ,[Additional5]
      ,[IssuePermitTolerancePercent]
      ,[MaxMajorUnitQuantity]
      ,[PrevState]
      ,[ReferenceCode]
      ,[Description] from [Rahkarandb_sg3].[LGS3].[IssuePermititem]' )kk)sc
 on   sc.IssuePermitItemID=c.IssuePermitItemID and sc.[Version]<> c.[Version]




 
  

    insert into [stage].[kharazmi].LGS3IssuePermititem
(
[IssuePermitItemID]
      ,[IssuePermitRef]
      ,[RowNumber]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[PartRef]
      ,[UnitRef]
      ,[PartUnitRef]
      ,[Quantity]
      ,[MajorUnitQuantity]
      ,[State]
      ,[Version]
      ,[CounterpartEntityCode]
      ,[CounterpartEntityRef]
      ,[CounterpartEntityText]
      ,[Additional1]
      ,[Additional2]
      ,[Additional3]
      ,[Additional4]
      ,[Additional5]
      ,[IssuePermitTolerancePercent]
      ,[MaxMajorUnitQuantity]
      ,[PrevState]
      ,[ReferenceCode]
      ,[Description]
      ,[isinsert]
      ,[isupdate]   )                  
   select
[IssuePermitItemID]
      ,[IssuePermitRef]
      ,[RowNumber]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[PartRef]
      ,[UnitRef]
      ,[PartUnitRef]
      ,[Quantity]
      ,[MajorUnitQuantity]
      ,[State]
      ,[Version]
      ,[CounterpartEntityCode]
      ,[CounterpartEntityRef]
      ,[CounterpartEntityText]
      ,[Additional1]
      ,[Additional2]
      ,[Additional3]
      ,[Additional4]
      ,[Additional5]
      ,[IssuePermitTolerancePercent]
      ,[MaxMajorUnitQuantity]
      ,[PrevState]
      ,[ReferenceCode]
      ,[Description]
   ,1
 ,null

 

    FROM OPENQUERY([192.168.200.12], 'select [IssuePermitItemID]
      ,[IssuePermitRef]
      ,[RowNumber]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[PartRef]
      ,[UnitRef]
      ,[PartUnitRef]
      ,[Quantity]
      ,[MajorUnitQuantity]
      ,[State]
      ,[Version]
      ,[CounterpartEntityCode]
      ,[CounterpartEntityRef]
      ,[CounterpartEntityText]
      ,[Additional1]
      ,[Additional2]
      ,[Additional3]
      ,[Additional4]
      ,[Additional5]
      ,[IssuePermitTolerancePercent]
      ,[MaxMajorUnitQuantity]
      ,[PrevState]
      ,[ReferenceCode]
      ,[Description]
 from [Rahkarandb_sg3].[LGS3].[IssuePermititem]') invoiceitem
where 
--invoiceitem.date>=cast (cast( year(getdate()) as varchar )+'-01-01' as date) and 
not exists(
 select [IssuePermititemId] from [stage].[kharazmi].LGS3IssuePermititem z1 where z1.[IssuePermititemId] = invoiceitem.[IssuePermititemId])




    delete ft 
  from [stage].[kharazmi].[LGS3IssuePermititem] ft
 inner join (select * from [stage].[dbo].updates) tft1 on tft1.[id]=ft.[IssuePermititemID]


   delete  from kharazmi.LGS3InventoryVoucher
where not exists   (select * from [192.168.200.12].[Rahkarandb_sg3].[LGS3].InventoryVoucher ii where  ii.InventoryVoucherid=LGS3InventoryVoucher.InventoryVoucherID)



 truncate table [Stage].[dbo].[Updates]
 insert into [stage].[dbo].[updates]
 (id)
 select sc.InventoryVoucherID
 from  [stage].[kharazmi].LGS3InventoryVoucher c

 inner join [192.168.200.12].[Rahkarandb_sg3].[LGS3].[InventoryVoucher] sc on   sc.InventoryVoucherID=c.InventoryVoucherID and sc.Version<> c.Version




 

    insert into [stage].[kharazmi].LGS3InventoryVoucher
(
[InventoryVoucherID]
      ,[InventoryVoucherSpecificationRef]
      ,[State]
      ,[Version]
      ,[StoreRef]
      ,[CounterpartStoreRef]
      ,[Date]
      ,[Number]
      ,[DelivererOrReceiverPartyRef]
      ,[CreationDate]
      ,[LastModificationDate]
      ,[Creator]
      ,[LastModifier]
      ,[SLRef]
      ,[CounterpartEntityCode]
      ,[CounterpartEntityRef]
      ,[CounterpartEntityText]
      ,[CounterpartDLCode]
      ,[Level5DLCode]
      ,[Level6DLCode]
      ,[BranchRef]
      ,[Editable]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[Description]
      ,[LedgerRef]
      ,[FiscalYearRef]
      ,[Additional1]
      ,[Additional2]
      ,[Additional3]
      ,[Additional4]
      ,[Additional5]
      ,[HandheldSpecificId]
      ,[isinsert]
      ,[isupdate]  )                  
   select
[InventoryVoucherID]
      ,[InventoryVoucherSpecificationRef]
      ,[State]
      ,[Version]
      ,[StoreRef]
      ,[CounterpartStoreRef]
      ,[Date]
      ,[Number]
      ,[DelivererOrReceiverPartyRef]
      ,[CreationDate]
      ,[LastModificationDate]
      ,[Creator]
      ,[LastModifier]
      ,[SLRef]
      ,[CounterpartEntityCode]
      ,[CounterpartEntityRef]
      ,[CounterpartEntityText]
      ,[CounterpartDLCode]
      ,[Level5DLCode]
      ,[Level6DLCode]
      ,[BranchRef]
      ,[Editable]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[Description]
      ,[LedgerRef]
      ,[FiscalYearRef]
      ,[Additional1]
      ,[Additional2]
      ,[Additional3]
      ,[Additional4]
      ,[Additional5]
      ,[HandheldSpecificId]
   ,NULL
 ,1

   FROM [192.168.200.12].[Rahkarandb_sg3].[LGS3].[InventoryVoucher] InventoryVoucher
where 
--invoiceitem.date>=cast (cast( year(getdate()) as varchar )+'-01-01' as date) and 
not exists(
 select [InventoryVoucherId] from [stage].[kharazmi].LGS3InventoryVoucher z1 where z1.[InventoryVoucherId] = InventoryVoucher.[InventoryVoucherId])




 
  delete ft 
  from [stage].[kharazmi].LGS3InventoryVoucher ft
 inner join (select * from [stage].[dbo].updates) tft1 on tft1.[id]=ft.[InventoryVoucherID]




    delete  from kharazmi.LGS3InventoryVoucheritem
where not exists   (select * from [192.168.200.12].[Rahkarandb_sg3].[LGS3].InventoryVoucheritem ii where  ii.InventoryVoucheritemid=LGS3InventoryVoucheritem.InventoryVoucheritemID)



 truncate table [Stage].[dbo].[Updates]
 insert into [stage].[dbo].[updates]
 (id)
 select sc.InventoryVoucheritemID
 from  [stage].[kharazmi].LGS3InventoryVoucheritem c

 inner join [192.168.200.12].[Rahkarandb_sg3].[LGS3].[InventoryVoucheritem] sc on   sc.InventoryVoucheritemID=c.InventoryVoucheritemID and sc.Version<> c.Version



 

    insert into [stage].[kharazmi].LGS3InventoryVoucheritem
(
[InventoryVoucherItemID]
      ,[InventoryVoucherRef]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[ReferenceCode]
      ,[State]
      ,[Version]
      ,[Description]
      ,[DelivererOrReceiverPartyRef]
      ,[PartRef]
      ,[PartUnitRef]
      ,[ReturnableVoucherItemRef]
      ,[SLRef]
      ,[CounterpartEntityCode]
      ,[CounterpartEntityRef]
      ,[CounterpartEntityText]
      ,[CounterpartDLCode]
      ,[Level5DLCode]
      ,[Level6DLCode]
      ,[InventoryVoucherSpecificationRef]
      ,[Number]
      ,[UnitRef]
      ,[RowNumber]
      ,[MajorUnitQuantity]
      ,[Quantity]
      ,[SecondUnitQuantity]
      ,[Additional1]
      ,[Additional2]
      ,[Additional3]
      ,[Additional4]
      ,[Additional5]
      ,[BarcodeTemplateRef]
      ,[Barcode]
      ,[FiscalYearRef]
      ,[StoreRef]
      ,[Date]
      ,[VoucherCreationDate]
      ,[HasQualityControl]
      ,[SLResolvingType]
      ,[DatesAsNumber]
      ,[isinsert]
      ,[isupdate]
	  )                  
   select
[InventoryVoucherItemID]
      ,[InventoryVoucherRef]
      ,[ReferenceType]
      ,[ReferenceRef]
      ,[ReferenceCode]
      ,[State]
      ,[Version]
      ,[Description]
      ,[DelivererOrReceiverPartyRef]
      ,[PartRef]
      ,[PartUnitRef]
      ,[ReturnableVoucherItemRef]
      ,[SLRef]
      ,[CounterpartEntityCode]
      ,[CounterpartEntityRef]
      ,[CounterpartEntityText]
      ,[CounterpartDLCode]
      ,[Level5DLCode]
      ,[Level6DLCode]
      ,[InventoryVoucherSpecificationRef]
      ,[Number]
      ,[UnitRef]
      ,[RowNumber]
      ,[MajorUnitQuantity]
      ,[Quantity]
      ,[SecondUnitQuantity]
      ,[Additional1]
      ,[Additional2]
      ,[Additional3]
      ,[Additional4]
      ,[Additional5]
      ,[BarcodeTemplateRef]
      ,[Barcode]
      ,[FiscalYearRef]
      ,[StoreRef]
      ,[Date]
      ,[VoucherCreationDate]
      ,[HasQualityControl]
      ,[SLResolvingType]
      ,[DatesAsNumber]
  ,Null
 ,1

   FROM [192.168.200.12].[Rahkarandb_sg3].[LGS3].[InventoryVoucherItem] InventoryVoucher
where 
--invoiceitem.date>=cast (cast( year(getdate()) as varchar )+'-01-01' as date) and 
not exists(
 select [InventoryVoucherItemId] from [stage].[kharazmi].LGS3InventoryVoucherItem z1 where z1.[InventoryVoucherItemId] = InventoryVoucher.[InventoryVoucherItemId])




 
  delete ft 
  from [stage].[kharazmi].LGS3InventoryVoucherItem ft
 inner join (select * from [stage].[dbo].updates) tft1 on tft1.[id]=ft.[InventoryVoucherItemID]




  use [Stage]
 Go
 drop table if exists kharazmi.[product]
 Go

 select * into kharazmi.[product]
 from [192.168.200.12].[Rahkarandb_sg3].[sls3].[product]




   use [Stage]
 Go
 drop table if exists kharazmi.Unit
 Go

 select * into kharazmi.Unit
 from [192.168.200.12].[Rahkarandb_sg3].[GNR3].[Unit]
GO





use [Stage]
 Go
 drop table if exists kharazmi.PartUnit
 Go

 select * into kharazmi.PartUnit
from [192.168.200.12].[Rahkarandb_sg3].[lgs3].[PartUnit]



  use [Stage]
 Go
 drop table if exists kharazmi.part
 Go

 select * into kharazmi.part
from [192.168.200.12].[Rahkarandb_sg3].[lgs3].[part]



use [Stage]
 Go
 drop table if exists  kharazmi.customer
 Go

 select * into  kharazmi.customer
from [192.168.200.12].[Rahkarandb_sg3].[sls3].[customer]




  use [Stage]
 Go
 drop table if exists kharazmi.salesarea
 Go

 select * into kharazmi.[salesarea]
from [192.168.200.12].[Rahkarandb_sg3].[sls3].[salesarea]



  use [Stage]
 Go
 drop table if exists kharazmi.ProductUnit
 Go

 select * into kharazmi. ProductUnit
from [192.168.200.12].[Rahkarandb_sg3].[SLS3].[ProductUnit]



  use [Stage]
 Go
 drop table if exists kharazmi.Currency
 Go

 select * into kharazmi.Currency
from[192.168.200.12].[Rahkarandb_sg3].[GNR3].[Currency]



  use [Stage]
 Go
 drop table if exists kharazmi.[CurrencyExchangeRate]
 Go

 select * into kharazmi.[CurrencyExchangeRate]
from [192.168.200.12].[Rahkarandb_sg3].[GNR3].[CurrencyExchangeRate]


  use [Stage]
 Go
 drop table if exists kharazmi.EntityGroup
 Go

 select * into kharazmi.EntityGroup

FROM [192.168.200.12].[Rahkarandb_sg3].[GNR3].[EntityGroup]



  use [Stage]
 Go
 drop table if exists kharazmi.EntityGrouping
 Go

 select * into kharazmi.EntityGrouping

  FROM [192.168.200.12].[Rahkarandb_sg3].[GNR3].[EntityGrouping]