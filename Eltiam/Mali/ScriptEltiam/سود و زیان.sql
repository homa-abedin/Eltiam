
DECLARE @FDate AS INT = 14020101
DECLARE @LDate AS INT = 14021229
DECLARE @DetailKey AS INT = 0
DECLARE @Tadil AS BIT = 1

DECLARE @DateHeader AS NVARCHAR(256) = ''
SET @DateHeader = (
					SELECT	CONVERT(VARCHAR(10),DayNumberOfMonth) + '' + PersianMonthName + '' + CONVERT(VARCHAR(10),CalendarYear) AS datet 
					FROM	PUBDimDate 
					WHERE	@LDate = DateKey
					)
DECLARE @FDate2 AS INT = (SELECT CAST(LEFT(@FDate,4) - 1 AS CHAR(4)) + RIGHT(@FDate,4) AS dates )
DECLARE @LDate2 AS INT = (SELECT CAST(LEFT(@FDate,4) - 1 AS CHAR(4)) + CASE WHEN RIGHT(@LDate,4) = '1229' THEN '1230' ELSE RIGHT(@LDate,4) END AS dates)

IF(@Tadil = 1)
BEGIN
	IF(@DetailKey = 0)
	BEGIN
		SELECT	LEFT(@FDate2, 4) AS Parsal, LEFT(@FDate, 4) AS Emsal, @DateHeader AS DateHeader
				, SUM(h.DAmaliati) AS DAmaliati, SUM(h.TamamAmaliati) AS TamamAmaliati, SUM(h.SoodeNakhales) AS SoodeNakhales
				, SUM(h.HazineForoosh) AS HazineForoosh, SUM(h.SayerAmaliati) AS SayerAmaliati, SUM(h.SoodeAmaliati) AS SoodeAmaliati
				, SUM(h.HazineMali) AS HazineMali, SUM(h.SayereGheir) AS SayereGheir, SUM(h.SoodeGhabl) AS SoodeGhabl, SUM(h.Maliat) AS Maliat
				, SUM(h.SoodeKhales) AS SoodeKhales, SUM(h.DAmaliati1) AS DAmaliati1, SUM(h.TamamAmaliati1) AS TamamAmaliati1
				, SUM(h.SoodeNakhales1) AS SoodeNakhales1, SUM(h.HazineForoosh1) AS HazineForoosh1, SUM(h.SayerAmaliati1) AS SayerAmaliati1
				, SUM(h.SoodeAmaliati1) AS SoodeAmaliati1, SUM(h.HazineMali1) AS HazineMali1, SUM(h.SayereGheir1) AS SayereGheir1
				, SUM(h.SoodeGhabl1) AS SoodeGhabl1, SUM(h.Maliat1) AS Maliat1, SUM(h.SoodeKhales1) AS SoodeKhales1
		FROM	(
					SELECT  SUM(f.DAmaliati) AS DAmaliati, SUM(f.TamamAmaliati) AS TamamAmaliati, SUM(f.SoodeNakhales) AS SoodeNakhales
							, SUM(f.HazineForoosh) AS HazineForoosh, SUM(f.SayerAmaliati) AS SayerAmaliati, SUM(f.SoodeAmaliati) AS SoodeAmaliati
							, SUM(f.HazineMali) AS HazineMali, SUM(f.SayereGheir) AS SayereGheir, SUM(f.SoodeGhabl) AS SoodeGhabl
							, CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS Maliat
							, SUM(SoodeGhabl) - CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS SoodeKhales
							, NULL AS DAmaliati1, NULL AS TamamAmaliati1, NULL AS SoodeNakhales1, NULL AS HazineForoosh1, NULL AS SayerAmaliati1
							, NULL AS SoodeAmaliati1, NULL AS HazineMali1, NULL AS SayereGheir1, NULL AS SoodeGhabl1, NULL AS Maliat1, NULL AS SoodeKhales1
					FROM	(
								SELECT	SUM(r.DAmaliati) AS DAmaliati, SUM(r.TamamAmaliati) AS TamamAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati) AS SoodeNakhales, SUM(r.HazineForoosh) AS HazineForoosh
										, SUM(r.SayerAmaliati) AS SayerAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati) AS SoodeAmaliati
										, SUM(r.HazineMali) AS HazineMali, SUM(r.SayereGheir) AS SayereGheir
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati + r.HazineMali + r.SayereGheir) AS SoodeGhabl
								FROM	(
											SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS DAmaliati,
													-- 800 : قیمت تمام شده کالا
													-- 810 : انحراف قیمت تمام شده کالای فروش رفته
													CASE WHEN l2.Code IN (800, 810) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS TamamAmaliati,
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 73005 : هزینه بهره
													CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineForoosh,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													CASE WHEN l2.code = 620 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayerAmaliati,
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.code IN (630, 830) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayereGheir,
													-- 73005 : هزینه بهره
													CASE WHEN l3.code = 73005 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineMali,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS MajmooeHazine
											FROM 
													FINDocHeaders AS h
													LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
													LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
													LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
											WHERE 
													h.DateKey BETWEEN @FDate AND @LDate 
													AND h.FINDocHeader_FINDocType NOT IN (2, 4) 																				
											GROUP BY 
													l2.Code, l3.code
										) r
							) f

					UNION ALL

					SELECT	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
							, SUM(f.DAmaliati) AS DAmaliati1, SUM(f.TamamAmaliati) AS TamamAmaliati1, SUM(f.SoodeNakhales) AS SoodeNakhales1
							, SUM(f.HazineForoosh) AS HazineForoosh1, SUM(f.SayerAmaliati) AS SayerAmaliati1, SUM(f.SoodeAmaliati) AS SoodeAmaliati1
							, SUM(f.HazineMali) AS HazineMali1, SUM(f.SayereGheir) AS SayereGheir1, SUM(f.SoodeGhabl) AS SoodeGhabl1
							, CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS Maliat1
							, SUM(SoodeGhabl) - CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS SoodeKhales1
					FROM	(
								SELECT	SUM(r.DAmaliati) AS DAmaliati, SUM(r.TamamAmaliati) AS TamamAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati) AS SoodeNakhales, SUM(r.HazineForoosh) AS HazineForoosh
										, SUM(r.SayerAmaliati) AS SayerAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati) AS SoodeAmaliati
										, SUM(r.HazineMali) AS HazineMali, SUM(r.SayereGheir) AS SayereGheir
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati + r.HazineMali + r.SayereGheir) AS SoodeGhabl
								FROM	(
											SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS DAmaliati,
													-- 800 : قیمت تمام شده کالا
													-- 810 : انحراف قیمت تمام شده کالای فروش رفته
													CASE WHEN l2.Code IN (800, 810) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS TamamAmaliati,
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 73005 : هزینه بهره
													CASE WHEN (l2.Code IN (710, 720, 730, 740,750) AND l3.code NOT IN (73005)) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineForoosh,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													CASE WHEN l2.code = 620 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayerAmaliati,
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.code IN (630, 830) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayereGheir,
													-- 73005 : هزینه بهره
													CASE WHEN l3.code = 73005 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineMali,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS MajmooeHazine
											FROM 
													FINDocHeaders AS h
													LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
													LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
													LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
											WHERE 
													h.DateKey BETWEEN @FDate2 AND @LDate2 
													AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
													--and (@DetailKey = 0 OR d.FINDocDetail_FINDetailAccountL4  = @DetailKey )--  OR  d.FINDocDetail_FINDetailAccountL4 IS NULL) --or  d.FINDocDetail_FINDetailAccountL4 IS NULL)
											GROUP BY 
													l2.Code,l3.code
										) r
							) f
				) h
	END
	ELSE IF(@DetailKey != 0)
	BEGIN
		SELECT	LEFT(@FDate2, 4) AS Parsal, LEFT(@FDate, 4) AS Emsal, @DateHeader AS DateHeader
				, SUM(h.DAmaliati) AS DAmaliati, SUM(h.TamamAmaliati) AS TamamAmaliati, SUM(h.SoodeNakhales) AS SoodeNakhales
				, SUM(h.HazineForoosh) AS HazineForoosh, SUM(h.SayerAmaliati) AS SayerAmaliati, SUM(h.SoodeAmaliati) AS SoodeAmaliati
				, SUM(h.HazineMali) AS HazineMali, SUM(h.SayereGheir) AS SayereGheir, SUM(h.SoodeGhabl) AS SoodeGhabl, SUM(h.Maliat) AS Maliat
				, SUM(h.SoodeKhales) AS SoodeKhales, SUM(h.darsadehazine) AS darsadehazine, SUM(h.DAmaliati1) AS DAmaliati1
				, SUM(h.TamamAmaliati1) AS TamamAmaliati1, SUM(h.SoodeNakhales1) AS SoodeNakhales1, SUM(h.HazineForoosh1) AS HazineForoosh1
				, SUM(h.SayerAmaliati1) AS SayerAmaliati1, SUM(h.SoodeAmaliati1) AS SoodeAmaliati1, SUM(h.HazineMali1) AS HazineMali1
				, SUM(h.SayereGheir1) AS SayereGheir1, SUM(h.SoodeGhabl1) AS SoodeGhabl1, SUM(h.Maliat1) AS Maliat1
				, SUM(h.SoodeKhales1) AS SoodeKhales1, SUM(h.darsadehazine1) AS darsadehazine1
		FROM	(
					SELECT	SUM(f.DAmaliati) AS DAmaliati, SUM(f.TamamAmaliati) AS TamamAmaliati, SUM(f.SoodeNakhales) AS SoodeNakhales
							, SUM(f.HazineForoosh) AS HazineForoosh, SUM(f.SayerAmaliati) AS SayerAmaliati, SUM(f.SoodeAmaliati) AS SoodeAmaliati
							, SUM(f.HazineMali) AS HazineMali, SUM(f.SayereGheir) AS SayereGheir, SUM(f.SoodeGhabl) AS SoodeGhabl
							, CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS Maliat
							, SUM(SoodeGhabl) - CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS SoodeKhales
							, SUM(f.darsadehazine) AS darsadehazine, NULL AS DAmaliati1, NULL AS TamamAmaliati1, NULL AS SoodeNakhales1
							, NULL AS HazineForoosh1, NULL AS SayerAmaliati1, NULL AS SoodeAmaliati1, NULL AS HazineMali1
							, NULL AS SayereGheir1, NULL AS SoodeGhabl1, NULL AS Maliat1, NULL AS SoodeKhales1, NULL AS darsadehazine1
					FROM	(
								SELECT	SUM(r.DAmaliati) AS DAmaliati, SUM(r.TamamAmaliati) AS TamamAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati) AS SoodeNakhales, SUM(r.HazineForoosh) AS HazineForoosh
										, SUM(r.SayerAmaliati) AS SayerAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati) AS SoodeAmaliati
										, SUM(r.HazineMali) AS HazineMali, SUM(r.SayereGheir) AS SayereGheir
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati + r.HazineMali + r.SayereGheir) AS SoodeGhabl
										, SUM(r.darsadehazine) AS darsadehazine
								FROM	(
											SELECT	CASE WHEN @DetailKey = 0 OR @DetailKey IN (9, 10, 362, 368, 369, 456, 459, 19254) 
														THEN SUM(DAmaliati) 
														ELSE ISNULL(SUM(e.DAmaliatiS * e.darsadehazine), 0) + SUM(DAmaliati) 
													END AS DAmaliati,
													CASE WHEN @DetailKey = 0 OR @DetailKey IN (9, 10, 362, 368, 369, 456, 459, 19254) 
														THEN SUM(TamamAmaliati) 
														ELSE ISNULL(SUM(e.TamamAmaliatiS * e.darsadehazine), 0) + SUM(TamamAmaliati) 
													END TamamAmaliati,
													CASE WHEN @DetailKey = 0 OR @DetailKey IN (9, 10, 362, 368, 369, 456, 459, 19254) 
														THEN SUM(HazineForoosh) 
														ELSE ISNULL(SUM(e.HazineForooshS * e.darsadehazine), 0) + SUM(HazineForoosh) 
													END HazineForoosh,
													CASE WHEN @DetailKey = 0 OR @DetailKey IN (9, 10, 362, 368, 369, 456, 459, 19254)
														THEN SUM(e.SayerAmaliati)
														ELSE ISNULL(SUM(e.SayerAmaliatiS * e.darsadehazine), 0) + SUM(SayerAmaliati)
													END AS SayerAmaliati,
													CASE WHEN @DetailKey = 0 OR @DetailKey IN (9, 10, 362, 368, 369, 456, 459, 19254)
														THEN SUM(e.HazineMali)
														ELSE ISNULL(SUM(e.HazineMaliS * e.darsadehazine), 0) + SUM(e.HazineMali) 
													END AS HazineMali,
													CASE WHEN @DetailKey = 0 OR @DetailKey IN (9, 10, 362, 368, 369, 456, 459, 19254)  
														THEN SUM(e.SayereGheir)
														ELSE ISNULL(SUM(e.SayereGheirS * e.darsadehazine), 0) + SUM(SayereGheir) 
													END AS SayereGheir,
													SUM(e.darsadehazine) AS darsadehazine
											FROM	(
														SELECT	SUM(t.DAmaliati) AS DAmaliati, SUM(t.TamamAmaliati) AS TamamAmaliati
																, SUM(t.HazineForoosh) AS HazineForoosh, SUM(t.SayerAmaliati) AS SayerAmaliati
																, SUM(t.HazineMali) AS HazineMali, SUM(t.SayereGheir) AS SayereGheir
																, SUM(t.MajmooeHazine) AS MajmooeHazine, SUM(t.DAmaliatiS) AS DAmaliatiS
																, SUM(t.TamamAmaliatiS) AS TamamAmaliatiS, SUM(t.HazineForooshS) AS HazineForooshS
																, SUM(t.SayerAmaliatiS) AS SayerAmaliatiS, SUM(t.HazineMaliS) AS HazineMaliS
																, SUM(t.SayereGheirS) AS SayereGheirS, SUM(t.MajmooeHazineS) AS MajmooeHazineS
																, SUM(t.DAmaliatiK) AS DAmaliatiK, SUM(t.TamamAmaliatiK) AS TamamAmaliatiK
																, SUM(t.HazineForooshK) AS HazineForooshK, SUM(t.SayerAmaliatiK) AS SayerAmaliatiK
																, SUM(t.HazineMaliK) AS HazineMaliK, SUM(t.SayereGheirK) AS SayereGheirK
																, SUM(t.MajmooeHazineK) AS MajmooeHazineK
																, ABS(CAST(ISNULL(SUM(t.MajmooeHazine),0) AS DECIMAL(17, 3)) /
																		CAST(ISNULL(SUM(t.MajmooeHazineK), 0) AS DECIMAL(17, 3))) AS darsadehazine
														FROM	(	
																	SELECT	SUM(s.DAmaliati) AS DAmaliati, SUM(s.TamamAmaliati) AS TamamAmaliati
																			, SUM(s.HazineForoosh) AS HazineForoosh, SUM(s.SayerAmaliati) AS SayerAmaliati
																			, SUM(s.HazineMali) AS HazineMali, SUM(s.SayereGheir) AS SayereGheir
																			, SUM(s.MajmooeHazine) MajmooeHazine, NULL AS DAmaliatiS, NULL AS TamamAmaliatiS
																			, NULL AS HazineForooshS, NULL AS SayerAmaliatiS, NULL AS HazineMaliS
																			, NULL AS SayereGheirS, NULL AS MajmooeHazineS, NULL AS DAmaliatiK
																			, NULL AS TamamAmaliatiK, NULL AS HazineForooshK, NULL AS SayerAmaliatiK
																			, NULL AS HazineMaliK, NULL AS SayereGheirK, NULL AS MajmooeHazineK
																	FROM	(
																				SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS DAmaliati,
																						-- 800 : قیمت تمام شده کالا
																						-- 810 : انحراف قیمت تمام شده کالای فروش رفته
																						CASE WHEN l2.Code IN (800, 810) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS TamamAmaliati,
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 73005 : هزینه بهره
																						CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineForoosh,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						CASE WHEN l2.code = 620 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayerAmaliati,
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.code IN (630, 830) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayereGheir,
																						-- 73005 : هزینه بهره
																						CASE WHEN l3.code = 73005 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineMali,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS MajmooeHazine
																				FROM 
																						FINDocHeaders AS h
																						LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
																						LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
																						LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
																				WHERE 
																						h.DateKey BETWEEN @FDate AND @LDate 
																						AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
																						AND (@DetailKey = 0 
																								OR d.FINDocDetail_FINDetailAccountL4 = @DetailKey)--  OR  d.FINDocDetail_FINDetailAccountL4 IS NULL) --or  d.FINDocDetail_FINDetailAccountL4 IS NULL)
																				GROUP BY 
																						l2.Code, l3.code
														
																				UNION ALL
														
																				SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS DAmaliati,
																						-- 800 : قیمت تمام شده کالا
																						-- 810 : انحراف قیمت تمام شده کالای فروش رفته
																						CASE WHEN l2.Code IN (800, 810) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS TamamAmaliati,
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 73005 : هزینه بهره
																						CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineForoosh,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						CASE WHEN l2.code = 620 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayerAmaliati,
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.code IN (630,830) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayereGheir,
																						-- 73005 : هزینه بهره
																						CASE WHEN l3.code = 73005 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineMali,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS MajmooeHazine
																				FROM 
																						FINDocHeaders AS h
																						LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
																						LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
																						LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
																				WHERE 
																						h.DateKey BETWEEN @FDate AND @LDate 
																						AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
																						AND (@DetailKey = 0 OR d.FINDocDetail_FINDetailAccountL5 = @DetailKey)--or  d.FINDocDetail_FINDetailAccountL5 IS NULL)
																				GROUP BY 
																						l2.Code, l3.code
																			) s

																	UNION ALL 

																	SELECT	NULL, NULL, NULL, NULL, NULL, NULL, NULL
																			, SUM(S.DAmaliati) AS DAmaliatiS, SUM(S.TamamAmaliati) AS TamamAmaliatiS
																			, SUM(S.HazineForoosh) AS HazineForooshS, SUM(S.SayerAmaliati) AS SayerAmaliatiS
																			, SUM(S.HazineMali) AS HazineMaliS, SUM(S.SayereGheir) AS SayereGheirS
																			, SUM(s.MajmooeHazine) AS MajmooeHazineS, NULL, NULL, NULL, NULL, NULL, NULL, NULL
																	FROM	(
																				SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS DAmaliati,
																						-- 800 : قیمت تمام شده کالا
																						-- 810 : انحراف قیمت تمام شده کالای فروش رفته
																						CASE WHEN l2.Code  IN (800, 810) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS TamamAmaliati,
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 73005 : هزینه بهره
																						CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineForoosh,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						CASE WHEN l2.code = 620 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayerAmaliati,
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.code IN (630, 830) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayereGheir,
																						-- 73005 : هزینه بهره
																						CASE WHEN l3.code = 73005 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineMali,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0
																						END AS MajmooeHazine
																				FROM 
																						FINDocHeaders AS h
																						LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
																						LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
																						LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
																				WHERE 
																						h.DateKey BETWEEN @FDate AND @LDate 
																						AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
																						AND (d.FINDocDetail_FINDetailAccountL4 NOT IN (7, 8, 279, 11, 12, 13, 14, 15, 16, 17, 18, 247, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31) 
																								OR  d.FINDocDetail_FINDetailAccountL4 IS NULL)
																				GROUP BY 
																						l2.Code, l3.code
																			) s
				
																	UNION ALL

																	SELECT	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
																			, SUM(S.DAmaliati) AS DAmaliatiK, SUM(S.TamamAmaliati) AS TamamAmaliatiK
																			, SUM(S.HazineForoosh) AS HazineForooshK, SUM(S.SayerAmaliati) AS SayerAmaliatiK
																			, SUM(S.HazineMali) AS HazineMaliK, SUM(S.SayereGheir) AS SayereGheirK
																			, SUM(s.MajmooeHazine) AS MajmooeHazineK
																	FROM	(
																				SELECT  CASE WHEN l2.Code = 610 -- 610 : فروش کالا
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS DAmaliati,
																						-- 800 : قیمت تمام شده کالا
																						-- 810 : انحراف قیمت تمام شده کالای فروش رفته
																						CASE WHEN l2.Code IN (800, 810) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS TamamAmaliati,
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 73005 : هزینه بهره
																						CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineForoosh,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						CASE WHEN l2.code = 620 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayerAmaliati,
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.code IN (630, 830) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayereGheir,
																						-- 73005 : هزینه بهره
																						CASE WHEN l3.code = 73005 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineMali,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS MajmooeHazine
																				FROM 
																						FINDocHeaders AS h
																						LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
																						LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
																						LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
																				WHERE 
																						h.DateKey BETWEEN @FDate AND @LDate 
																						AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
																						AND (d.FINDocDetail_FINDetailAccountL4 IN (7, 8, 279, 11, 12, 13, 14, 15, 16, 17, 18, 247, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31)) --or  d.FINDocDetail_FINDetailAccountL4 IS NULL)
																				GROUP BY 
																						l2.Code, l3.code
																			) S
																) t
													) e
										) r
							) f
	
					UNION ALL

					SELECT	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
							, SUM(f.DAmaliati) AS DAmaliati, SUM(f.TamamAmaliati) AS TamamAmaliati, SUM(f.SoodeNakhales) AS SoodeNakhales
							, SUM(f.HazineForoosh) AS HazineForoosh, SUM(f.SayerAmaliati) AS SayerAmaliati, SUM(f.SoodeAmaliati) AS SoodeAmaliati
							, SUM(f.HazineMali) AS HazineMali, SUM(f.SayereGheir) AS SayereGheir, SUM(f.SoodeGhabl) AS SoodeGhabl
							, CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) *  0.25 ELSE 0 END AS Maliat
							, SUM(SoodeGhabl) - CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS SoodeKhales
							, SUM(f.darsadehazine) AS darsadehazine1
					FROM	(
								SELECT	SUM(r.DAmaliati) AS DAmaliati, SUM(r.TamamAmaliati) AS TamamAmaliati, SUM(r.DAmaliati + r.TamamAmaliati) AS SoodeNakhales
										, SUM(r.HazineForoosh) AS HazineForoosh, SUM(r.SayerAmaliati) AS SayerAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati) AS SoodeAmaliati
										, SUM(r.HazineMali) AS HazineMali, SUM(r.SayereGheir) AS SayereGheir
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati + r.HazineMali + r.SayereGheir) AS SoodeGhabl
										, SUM(r.darsadehazine) AS darsadehazine
								FROM	(
											SELECT	CASE WHEN @DetailKey = 0 OR @DetailKey IN (9, 10, 362, 368, 369, 456, 459, 19254) 
														THEN SUM(DAmaliati) 
														ELSE ISNULL(SUM(e.DAmaliatiS * e.darsadehazine), 0) + SUM(DAmaliati) 
													END AS DAmaliati,
													CASE WHEN @DetailKey = 0 OR @DetailKey IN (9, 10, 362, 368, 369, 456, 459, 19254) 
														THEN SUM(TamamAmaliati) 
														ELSE ISNULL(SUM(e.TamamAmaliatiS * e.darsadehazine), 0) + SUM(TamamAmaliati) 
													END AS TamamAmaliati,
													CASE WHEN @DetailKey = 0 OR @DetailKey IN (9, 10, 362, 368, 369, 456, 459, 19254) 
														THEN SUM(HazineForoosh) 
														ELSE ISNULL(SUM(e.HazineForooshS * e.darsadehazine), 0) + SUM(HazineForoosh) 
													END AS HazineForoosh,
													CASE WHEN @DetailKey = 0 OR @DetailKey IN (9, 10, 362, 368, 369, 456, 459, 19254)
														THEN SUM(e.SayerAmaliati)
														ELSE ISNULL(SUM(e.SayerAmaliatiS * e.darsadehazine), 0) + SUM(SayerAmaliati) 
													END AS SayerAmaliati,
													CASE WHEN @DetailKey = 0 OR @DetailKey IN (9, 10, 362, 368, 369, 456, 459, 19254)
														THEN SUM(e.HazineMali)
														ELSE ISNULL(SUM(e.HazineMaliS * e.darsadehazine), 0) + SUM(e.HazineMali) 
													END AS HazineMali,
													CASE WHEN @DetailKey = 0 OR @DetailKey IN (9, 10, 362, 368, 369, 456, 459, 19254)
														THEN SUM(e.SayereGheir)
														ELSE ISNULL(SUM(e.SayereGheirS * e.darsadehazine), 0) + SUM(SayereGheir) 
													END AS SayereGheir,
													SUM(e.darsadehazine) AS darsadehazine
											FROM	(
														SELECT	SUM(t.DAmaliati) AS DAmaliati, SUM(t.TamamAmaliati) AS TamamAmaliati
																, SUM(t.HazineForoosh) AS HazineForoosh, SUM(t.SayerAmaliati)SayerAmaliati
																, SUM(t.HazineMali) AS HazineMali, SUM(t.SayereGheir) AS SayereGheir
																, SUM(t.MajmooeHazine) AS MajmooeHazine, SUM(t.DAmaliatiS) AS DAmaliatiS
																, SUM(t.TamamAmaliatiS) AS TamamAmaliatiS, SUM(t.HazineForooshS) AS HazineForooshS
																, SUM(t.SayerAmaliatiS) AS SayerAmaliatiS, SUM(t.HazineMaliS) AS HazineMaliS
																, SUM(t.SayereGheirS) AS SayereGheirS, SUM(t.MajmooeHazineS) AS MajmooeHazineS
																, SUM(t.DAmaliatiK) AS DAmaliatiK, SUM(t.TamamAmaliatiK) AS TamamAmaliatiK
																, SUM(t.HazineForooshK) AS HazineForooshK, SUM(t.SayerAmaliatiK) AS SayerAmaliatiK
																, SUM(t.HazineMaliK) AS HazineMaliK, SUM(t.SayereGheirK) AS SayereGheirK
																, SUM(t.MajmooeHazineK) AS MajmooeHazineK
																, ABS(CAST(ISNULL(SUM(t.MajmooeHazine), 0) AS DECIMAL(17, 3))
																		/CAST(ISNULL(SUM(t.MajmooeHazineK), 0) AS DECIMAL(17, 3))) AS darsadehazine
														FROM	(	
																	SELECT	SUM(s.DAmaliati) AS DAmaliati, SUM(s.TamamAmaliati) AS TamamAmaliati
																			, SUM(s.HazineForoosh) AS HazineForoosh, SUM(s.SayerAmaliati) AS SayerAmaliati
																			, SUM(s.HazineMali) AS HazineMali, SUM(s.SayereGheir) AS SayereGheir
																			, SUM(s.MajmooeHazine) AS MajmooeHazine, NULL AS DAmaliatiS, NULL AS TamamAmaliatiS
																			, NULL AS HazineForooshS, NULL AS SayerAmaliatiS, NULL AS HazineMaliS, NULL AS SayereGheirS
																			, NULL AS MajmooeHazineS, NULL AS DAmaliatiK, NULL AS TamamAmaliatiK, NULL AS HazineForooshK
																			, NULL AS SayerAmaliatiK, NULL AS HazineMaliK, NULL AS SayereGheirK, NULL AS MajmooeHazineK
																	FROM	(
																				SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS DAmaliati,
																						-- 800 : قیمت تمام شده کالا
																						-- 810 : انحراف قیمت تمام شده کالای فروش رفته
																						CASE WHEN l2.Code IN (800, 810) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS TamamAmaliati,
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 73005 : هزینه بهره
																						CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineForoosh,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						CASE WHEN l2.code = 620 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayerAmaliati,
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.code IN (630, 830) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayereGheir,
																						-- 73005 : هزینه بهره
																						CASE WHEN l3.code = 73005 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineMali,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS MajmooeHazine
																				FROM 
																						FINDocHeaders AS h
																						LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
																						LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
																						LEFT JOIN FINL2Accounts AS l2 ON l2.Id=l3.FINAccountsL3_FINAccountsL2
																				WHERE 
																						h.DateKey BETWEEN @FDate AND @LDate 
																						AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
																						AND (@DetailKey = 0 OR d.FINDocDetail_FINDetailAccountL4 = @DetailKey)--  OR  d.FINDocDetail_FINDetailAccountL4 IS NULL) --or  d.FINDocDetail_FINDetailAccountL4 IS NULL)
																				GROUP BY 
																						l2.Code, l3.code
														
																				UNION ALL

																				SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS DAmaliati,
																						-- 800 : قیمت تمام شده کالا
																						-- 810 : انحراف قیمت تمام شده کالای فروش رفته
																						CASE WHEN l2.Code IN (800, 810) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS TamamAmaliati,
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 73005 : هزینه بهره
																						CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineForoosh,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						CASE WHEN l2.code = 620 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayerAmaliati,
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.code IN (630, 830) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayereGheir,
																						-- 73005 : هزینه بهره
																						CASE WHEN l3.code = 73005 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineMali,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS MajmooeHazine
																				FROM 
																						FINDocHeaders AS h
																						LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
																						LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
																						LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
																				WHERE 
																						h.DateKey BETWEEN @FDate2 AND @LDate2 
																						AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
																						AND (@DetailKey = 0 OR d.FINDocDetail_FINDetailAccountL5 = @DetailKey)--or  d.FINDocDetail_FINDetailAccountL5 IS NULL)
																				GROUP BY 
																						l2.Code, l3.code
																			) s

																	UNION ALL 
	
																	SELECT	NULL, NULL, NULL, NULL, NULL, NULL, NULL
																			, SUM(S.DAmaliati) AS DAmaliatiS, SUM(S.TamamAmaliati) AS TamamAmaliatiS
																			, SUM(S.HazineForoosh) AS HazineForooshS, SUM(S.SayerAmaliati) AS SayerAmaliatiS
																			, SUM(S.HazineMali) AS HazineMaliS, SUM(S.SayereGheir) AS SayereGheirS
																			, SUM(s.MajmooeHazine) AS MajmooeHazineS
																			, NULL, NULL, NULL, NULL, NULL, NULL, NULL
																	FROM	(
																				SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS DAmaliati,
																						-- 800 : قیمت تمام شده کالا
																						-- 810 : انحراف قیمت تمام شده کالای فروش رفته
																						CASE WHEN l2.Code IN (800, 810) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS TamamAmaliati,
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 73005 : هزینه بهره
																						CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineForoosh,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						CASE WHEN l2.code = 620 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayerAmaliati,
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.code IN (630, 830) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayereGheir,
																						-- 73005 : هزینه بهره
																						CASE WHEN l3.code = 73005 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineMali,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS MajmooeHazine
																				FROM 
																						FINDocHeaders AS h
																						LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
																						LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
																						LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
																				WHERE 
																						h.DateKey BETWEEN @FDate2 AND @LDate2 
																						AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
																						AND (d.FINDocDetail_FINDetailAccountL4 NOT IN (7, 8, 279, 11, 12, 13, 14, 15, 16, 17, 18, 247, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31) 
																								OR d.FINDocDetail_FINDetailAccountL4 IS NULL)
																				GROUP BY 
																						l2.Code, l3.code
																			) s
				
																	UNION ALL 

																	SELECT	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
																			, SUM(S.DAmaliati) AS DAmaliatiK, SUM(S.TamamAmaliati) AS TamamAmaliatiK
																			, SUM(S.HazineForoosh) AS HazineForooshK, SUM(S.SayerAmaliati) AS SayerAmaliatiK
																			, SUM(S.HazineMali) AS HazineMaliK, SUM(S.SayereGheir) AS SayereGheirK
																			, SUM(s.MajmooeHazine) AS MajmooeHazineK
																	FROM	(
																				SELECT  CASE WHEN l2.Code = 610 -- 610 : فروش کالا
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS DAmaliati,
																						-- 800 : قیمت تمام شده کالا
																						-- 810 : انحراف قیمت تمام شده کالای فروش رفته
																						CASE WHEN l2.Code  IN (800, 810) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS TamamAmaliati,
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 73005 : هزینه بهره
																						CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineForoosh,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						CASE WHEN l2.code = 620 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayerAmaliati,
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.code IN (630, 830) 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS SayereGheir,
																						-- 73005 : هزینه بهره
																						CASE WHEN l3.code = 73005 
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS HazineMali,
																						-- 620 : سایر درآمدها و هزینه های عملیاتی
																						-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
																						-- 710 : هزینه های اداری عمومی
																						-- 720 : هزینه های توزیع و فروش
																						-- 730 : هزینه های مالی
																						-- 740 : هزینه های پرسنلی 1
																						-- 750 : هزینه های پرسنلی 2
																						-- 830 : قیمت تمام شده سایر
																						CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
																							THEN SUM(d.Credit - d.Debit) 
																							ELSE 0 
																						END AS MajmooeHazine
																				FROM 
																						FINDocHeaders AS h
																						LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
																						LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
																						LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
																				WHERE 
																						h.DateKey BETWEEN @FDate2 AND @LDate2 
																						AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
																						AND (d.FINDocDetail_FINDetailAccountL4 IN (7, 8, 279, 11, 12, 13, 14, 15, 16, 17, 18, 247, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31)) --or  d.FINDocDetail_FINDetailAccountL4 IS NULL)
																				GROUP BY 
																						l2.Code, l3.code
																			) S
																) t
													) e
										) r
							) f
				) h
	END
END
ELSE 
BEGIN
	IF(@DetailKey = 0)
	BEGIN
		SELECT	LEFT(@FDate2, 4) AS Parsal, LEFT(@FDate, 4) AS Emsal, @DateHeader AS DateHeader
				, SUM(h.DAmaliati) AS DAmaliati, SUM(h.TamamAmaliati) AS TamamAmaliati, SUM(h.SoodeNakhales) AS SoodeNakhales
				, SUM(h.HazineForoosh) AS HazineForoosh, SUM(h.SayerAmaliati) AS SayerAmaliati, SUM(h.SoodeAmaliati) AS SoodeAmaliati
				, SUM(h.HazineMali) AS HazineMali, SUM(h.SayereGheir) AS SayereGheir, SUM(h.SoodeGhabl) AS SoodeGhabl, SUM(h.Maliat) AS Maliat
				, SUM(h.SoodeKhales) AS SoodeKhales, SUM(h.DAmaliati1) AS DAmaliati1, SUM(h.TamamAmaliati1) AS TamamAmaliati1
				, SUM(h.SoodeNakhales1) AS SoodeNakhales1, SUM(h.HazineForoosh1) AS HazineForoosh1, SUM(h.SayerAmaliati1) AS SayerAmaliati1
				, SUM(h.SoodeAmaliati1) AS SoodeAmaliati1, SUM(h.HazineMali1) AS HazineMali1, SUM(h.SayereGheir1) AS SayereGheir1
				, SUM(h.SoodeGhabl1) AS SoodeGhabl1, SUM(h.Maliat1) AS Maliat1, SUM(h.SoodeKhales1) AS SoodeKhales1
		FROM	(
					SELECT  SUM(f.DAmaliati) AS DAmaliati, SUM(f.TamamAmaliati) AS TamamAmaliati, SUM(f.SoodeNakhales) AS SoodeNakhales
							, SUM(f.HazineForoosh) AS HazineForoosh, SUM(f.SayerAmaliati) AS SayerAmaliati, SUM(f.SoodeAmaliati) AS SoodeAmaliati
							, SUM(f.HazineMali) AS HazineMali, SUM(f.SayereGheir) AS SayereGheir, SUM(f.SoodeGhabl) AS SoodeGhabl
							, CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS Maliat
							, SUM(SoodeGhabl) - CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS SoodeKhales
							, NULL AS DAmaliati1, NULL AS TamamAmaliati1, NULL AS SoodeNakhales1, NULL AS HazineForoosh1, NULL AS SayerAmaliati1
							, NULL AS SoodeAmaliati1, NULL AS HazineMali1, NULL AS SayereGheir1, NULL AS SoodeGhabl1, NULL AS Maliat1, NULL AS SoodeKhales1
					FROM	(
								SELECT	SUM(r.DAmaliati) AS DAmaliati, SUM(r.TamamAmaliati) AS TamamAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati) AS SoodeNakhales, SUM(r.HazineForoosh) AS HazineForoosh
										, SUM(r.SayerAmaliati) AS SayerAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati) AS SoodeAmaliati
										, SUM(r.HazineMali) AS HazineMali, SUM(r.SayereGheir) AS SayereGheir
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati + r.HazineMali + r.SayereGheir) AS SoodeGhabl
								FROM	(
											SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS DAmaliati,
													-- 800 : قیمت تمام شده کالا
													-- 810 : انحراف قیمت تمام شده کالای فروش رفته
													CASE WHEN l2.Code IN (800, 810) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS TamamAmaliati,
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 73005 : هزینه بهره
													CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineForoosh,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													CASE WHEN l2.code = 620 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayerAmaliati,
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.code IN (630, 830) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayereGheir,
													-- 73005 : هزینه بهره
													CASE WHEN l3.code = 73005 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineMali,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS MajmooeHazine
											FROM 
													FINDocHeaders AS h
													LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
													LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
													LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
											WHERE 
													h.DateKey BETWEEN @FDate AND @LDate 
													AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
											GROUP BY 
													l2.Code,l3.code
										) r
							) f
					
					UNION ALL				

					SELECT	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
							, SUM(f.DAmaliati) AS DAmaliati1, SUM(f.TamamAmaliati) AS TamamAmaliati1, SUM(f.SoodeNakhales) AS SoodeNakhales1
							, SUM(f.HazineForoosh) AS HazineForoosh1, SUM(f.SayerAmaliati) AS SayerAmaliati1, SUM(f.SoodeAmaliati) AS SoodeAmaliati1
							, SUM(f.HazineMali) AS HazineMali1, SUM(f.SayereGheir) AS SayereGheir1, SUM(f.SoodeGhabl) AS SoodeGhabl1
							, CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS Maliat1
							, SUM(SoodeGhabl) - CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS SoodeKhales1
					FROM	(
								SELECT	SUM(r.DAmaliati) AS DAmaliati, SUM(r.TamamAmaliati) AS TamamAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati) AS SoodeNakhales, SUM(r.HazineForoosh) AS HazineForoosh
										, SUM(r.SayerAmaliati) AS SayerAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati) AS SoodeAmaliati
										, SUM(r.HazineMali) AS HazineMali, SUM(r.SayereGheir) AS SayereGheir
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati + r.HazineMali + r.SayereGheir) AS SoodeGhabl
								FROM	(
											SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS DAmaliati,
													-- 800 : قیمت تمام شده کالا
													-- 810 : انحراف قیمت تمام شده کالای فروش رفته
													CASE WHEN l2.Code IN (800, 810) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS TamamAmaliati,
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 73005 : هزینه بهره
													CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineForoosh,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													CASE WHEN l2.code = 620 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayerAmaliati,
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.code IN (630, 830) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayereGheir,
													-- 73005 : هزینه بهره
													CASE WHEN l3.code = 73005 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineMali,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS MajmooeHazine
											FROM 
													FINDocHeaders AS h
													LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
													LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
													LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
											WHERE 
													h.DateKey BETWEEN @FDate2 AND @LDate2 
													AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
													--and (@DetailKey = 0 OR d.FINDocDetail_FINDetailAccountL4  = @DetailKey )--  OR  d.FINDocDetail_FINDetailAccountL4 IS NULL) --or  d.FINDocDetail_FINDetailAccountL4 IS NULL)
											GROUP BY 
													l2.Code, l3.code
										) r
							) f
				) h
	END
	IF(@DetailKey != 0)
	BEGIN
		SELECT	LEFT(@FDate2, 4) AS Parsal, LEFT(@FDate, 4) AS Emsal, @DateHeader AS DateHeader, SUM(h.DAmaliati) AS DAmaliati
				, SUM(h.TamamAmaliati) AS TamamAmaliati, SUM(h.SoodeNakhales) AS SoodeNakhales, SUM(h.HazineForoosh) AS HazineForoosh
				, SUM(h.SayerAmaliati) AS SayerAmaliati, SUM(h.SoodeAmaliati) AS SoodeAmaliati, SUM(h.HazineMali) AS HazineMali
				, SUM(h.SayereGheir) AS SayereGheir, SUM(h.SoodeGhabl) AS SoodeGhabl, SUM(h.Maliat) AS Maliat, SUM(h.SoodeKhales) AS SoodeKhales
				, SUM(h.DAmaliati1) AS DAmaliati1, SUM(h.TamamAmaliati1) AS TamamAmaliati1, SUM(h.SoodeNakhales1) AS SoodeNakhales1
				, SUM(h.HazineForoosh1) AS HazineForoosh1, SUM(h.SayerAmaliati1) AS SayerAmaliati1, SUM(h.SoodeAmaliati1) AS SoodeAmaliati1
				, SUM(h.HazineMali1) AS HazineMali1, SUM(h.SayereGheir1) AS SayereGheir1, SUM(h.SoodeGhabl1) AS SoodeGhabl1
				, SUM(h.Maliat1) AS Maliat1, SUM(h.SoodeKhales1) AS SoodeKhales1
		FROM	(
					SELECT  SUM(f.DAmaliati) AS DAmaliati, SUM(f.TamamAmaliati) AS TamamAmaliati, SUM(f.SoodeNakhales) AS SoodeNakhales
							, SUM(f.HazineForoosh) AS HazineForoosh, SUM(f.SayerAmaliati) AS SayerAmaliati, SUM(f.SoodeAmaliati) AS SoodeAmaliati
							, SUM(f.HazineMali) AS HazineMali, SUM(f.SayereGheir) AS SayereGheir, SUM(f.SoodeGhabl) AS SoodeGhabl
							, CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS Maliat
							, SUM(SoodeGhabl) - CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS SoodeKhales
							, NULL AS DAmaliati1, NULL AS TamamAmaliati1, NULL AS SoodeNakhales1, NULL AS HazineForoosh1, NULL AS SayerAmaliati1
							, NULL AS SoodeAmaliati1, NULL AS HazineMali1, NULL AS SayereGheir1, NULL AS SoodeGhabl1, NULL AS Maliat1, NULL AS SoodeKhales1
					FROM	(
								SELECT	SUM(r.DAmaliati) AS DAmaliati, SUM(r.TamamAmaliati) AS TamamAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati) AS SoodeNakhales
										, SUM(r.HazineForoosh) AS HazineForoosh, SUM(r.SayerAmaliati) AS SayerAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati) AS SoodeAmaliati
										, SUM(r.HazineMali) AS HazineMali, SUM(r.SayereGheir) AS SayereGheir
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati + r.HazineMali + r.SayereGheir) AS SoodeGhabl
								FROM	(
											SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS DAmaliati,
													-- 800 : قیمت تمام شده کالا
													-- 810 : انحراف قیمت تمام شده کالای فروش رفته
													CASE WHEN l2.Code IN (800, 810) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS TamamAmaliati,
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 73005 : هزینه بهره
													CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineForoosh,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													CASE WHEN l2.code = 620 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayerAmaliati,
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.code IN (630, 830) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayereGheir,
													-- 73005 : هزینه بهره
													CASE WHEN l3.code = 73005 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineMali,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS MajmooeHazine
											FROM 
													FINDocHeaders AS h
													LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
													LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
													LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
											WHERE 
													h.DateKey BETWEEN @FDate AND @LDate 
													AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
													AND (@DetailKey = 0 OR d.FINDocDetail_FINDetailAccountL4 = @DetailKey)--  OR  d.FINDocDetail_FINDetailAccountL4 IS NULL) --or  d.FINDocDetail_FINDetailAccountL4 IS NULL)
											GROUP BY 
													l2.Code, l3.code

											UNION ALL
																	
											SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS DAmaliati,
													-- 800 : قیمت تمام شده کالا
													-- 810 : انحراف قیمت تمام شده کالای فروش رفته
													CASE WHEN l2.Code IN (800, 810) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS TamamAmaliati,
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 73005 : هزینه بهره
													CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineForoosh,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													CASE WHEN l2.code = 620 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayerAmaliati,
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.code IN (630, 830) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayereGheir,
													-- 73005 : هزینه بهره
													CASE WHEN l3.code = 73005 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineMali,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS MajmooeHazine
											FROM 
													FINDocHeaders AS h
													LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
													LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
													LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
											WHERE 
													h.DateKey BETWEEN @FDate AND @LDate 
													AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
													AND (@DetailKey = 0 OR d.FINDocDetail_FINDetailAccountL5 = @DetailKey)--  OR  d.FINDocDetail_FINDetailAccountL4 IS NULL) --or  d.FINDocDetail_FINDetailAccountL4 IS NULL)
											GROUP BY 
													l2.Code, l3.code
										) r
							) f
								
					UNION ALL				

					SELECT	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
							, SUM(f.DAmaliati) AS DAmaliati1, SUM(f.TamamAmaliati) AS TamamAmaliati1, SUM(f.SoodeNakhales) AS SoodeNakhales1
							, SUM(f.HazineForoosh) AS HazineForoosh1, SUM(f.SayerAmaliati) AS SayerAmaliati1, SUM(f.SoodeAmaliati) AS SoodeAmaliati1
							, SUM(f.HazineMali) AS HazineMali1, SUM(f.SayereGheir) AS SayereGheir1, SUM(f.SoodeGhabl) AS SoodeGhabl1
							, CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS Maliat1
							, SUM(SoodeGhabl) - CASE WHEN SUM(f.SoodeGhabl) > 0 THEN SUM(f.SoodeGhabl) * 0.25 ELSE 0 END AS SoodeKhales1								
					FROM	(
								SELECT	SUM(r.DAmaliati) AS DAmaliati, SUM(r.TamamAmaliati) AS TamamAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati) AS SoodeNakhales
										, SUM(r.HazineForoosh) AS HazineForoosh, SUM(r.SayerAmaliati) AS SayerAmaliati
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati) AS SoodeAmaliati
										, SUM(r.HazineMali) AS HazineMali, SUM(r.SayereGheir) AS SayereGheir
										, SUM(r.DAmaliati + r.TamamAmaliati + r.HazineForoosh + r.SayerAmaliati + r.HazineMali + r.SayereGheir) AS SoodeGhabl
								FROM	(
											SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS DAmaliati,
													-- 800 : قیمت تمام شده کالا
													-- 810 : انحراف قیمت تمام شده کالای فروش رفته
													CASE WHEN l2.Code IN (800, 810) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS TamamAmaliati,
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 73005 : هزینه بهره
													CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineForoosh,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													CASE WHEN l2.code = 620 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayerAmaliati,
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.code IN (630, 830) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayereGheir,
													-- 73005 : هزینه بهره
													CASE WHEN l3.code = 73005 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineMali,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS MajmooeHazine
											FROM 
													FINDocHeaders AS h
													LEFT JOIN FINDocDetails AS d ON h.Id = d.FINDocDetail_FINDocHeader
													LEFT JOIN FINL3Accounts AS l3 ON l3.id = d.FINDocDetail_FINL3Account
													LEFT JOIN FINL2Accounts AS l2 ON l2.Id = l3.FINAccountsL3_FINAccountsL2
											WHERE 
													h.DateKey BETWEEN @FDate2 AND @LDate2 
													AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
													AND (@DetailKey = 0 OR d.FINDocDetail_FINDetailAccountL4 = @DetailKey)--  OR  d.FINDocDetail_FINDetailAccountL4 IS NULL) --or  d.FINDocDetail_FINDetailAccountL4 IS NULL)
											GROUP BY 
													l2.Code, l3.code
															
											UNION ALL
											
											SELECT	CASE WHEN l2.Code = 610 -- 610 : فروش کالا
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS DAmaliati,
													-- 800 : قیمت تمام شده کالا
													-- 810 : انحراف قیمت تمام شده کالای فروش رفته
													CASE WHEN l2.Code  IN (800, 810) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS TamamAmaliati,
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 73005 : هزینه بهره
													CASE WHEN (l2.Code IN (710, 720, 730, 740, 750) AND l3.code NOT IN (73005)) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineForoosh,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													CASE WHEN l2.code = 620 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayerAmaliati,
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.code IN (630, 830) 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS SayereGheir,
													-- 73005 : هزینه بهره
													CASE WHEN l3.code = 73005 
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS HazineMali,
													-- 620 : سایر درآمدها و هزینه های عملیاتی
													-- 630 : سایر درآمدها و هزینه های غیر عملیاتی
													-- 710 : هزینه های اداری عمومی
													-- 720 : هزینه های توزیع و فروش
													-- 730 : هزینه های مالی
													-- 740 : هزینه های پرسنلی 1
													-- 750 : هزینه های پرسنلی 2
													-- 830 : قیمت تمام شده سایر
													CASE WHEN l2.Code IN (710, 720, 730, 740, 750, 620, 630, 830)  
														THEN SUM(d.Credit - d.Debit) 
														ELSE 0 
													END AS MajmooeHazine
											FROM 
													FINDocHeaders AS h
													LEFT JOIN FINDocDetails AS d on h.Id = d.FINDocDetail_FINDocHeader
													LEFT JOIN FINL3Accounts AS l3 on l3.id = d.FINDocDetail_FINL3Account
													LEFT JOIN FINL2Accounts AS l2 on l2.Id = l3.FINAccountsL3_FINAccountsL2
											WHERE 
													h.DateKey BETWEEN @FDate2 AND @LDate2 
													AND h.FINDocHeader_FINDocType NOT IN (2, 4) 
													AND (@DetailKey = 0 OR d.FINDocDetail_FINDetailAccountL5 = @DetailKey)--  OR  d.FINDocDetail_FINDetailAccountL4 IS NULL) --or  d.FINDocDetail_FINDetailAccountL4 IS NULL)
											GROUP BY 
													l2.Code, l3.code
										) r
							) f
				) h
	END
END