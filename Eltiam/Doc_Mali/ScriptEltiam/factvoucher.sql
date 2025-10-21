SELECT * FROM 

(

SELECT
Voucherid,
VoucherItemid,
    DateID = h.[Date],
	--FiscalDateID = D.FiscalDateID,
	AccountingVoucherTypeID = H.VoucherTypeRef,
	AccountingVoucherStateID = H.State,
	BranchID = H.BranchRef,
	AccountID = CAST(I.SLRef AS bigint),
	DL4ID = ISNULL(CAST(DL.DLID AS bigint),0),
	DL5ID = ISNULL(CAST(DL5.DLID AS bigint),0),
	DL6ID = ISNULL(CAST(DL6.DLID AS bigint),0),
	Debit = ISNULL(I.Debit,0),
	Credit = ISNULL(I.Credit,0),
	DebitBalance = (ISNULL(I.Debit,0) - ISNULL(I.Credit,0))

--ELSE CAST(SL.Title AS nvarchar(50)) END AS soratmali                     
FROM FIN3.Voucher H
LEFT JOIN FIN3.VoucherType VT ON VT.VoucherTypeID = H.VoucherTypeRef
--LEFT JOIN FIN3.ViewSystem S ON S.Code = VT.OwnerSystem
JOIN	FIN3.VoucherItem I ON H.VoucherID = I.VoucherRef
--JOIN	MRS3.DimDate D ON H.Date = D.FullDate
JOIN	FIN3.SL SL ON I.SLRef = SL.SLID
LEFT JOIN FIN3.DL DL ON DL.Code = I.DLLevel4 
LEFT JOIN FIN3.DL DL5 ON DL5.Code = I.DLLevel5 
LEFT JOIN FIN3.DL DL6 ON DL6.Code = I.DLLevel6 
 WHERE H.State<>2 --یادداشت
AND (h.vouchertyperef NOT IN (3,5))
--AND ( h.isinsert=1 
--or i.isinsert=1)
)a