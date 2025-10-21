USE DW;
GO

INSERT INTO dw.kharazmi.dimProductPakhsh (
    LatinBrand,
    PersianBrand,
    GTIN,
    Daya,
    Qasem,
    Mahya,
    Momtaz,
    Hasti,
    Barij,
    Eltiam
)
SELECT 
    kharazmi.LatinBrand,
    kharazmi.PersianBrand,
    kharazmi.GTIN,
    MAX(daya.ProductId)       AS Daya,
    MAX(qhasem.ProductCode)   AS Qasem,
    MAX(mahya.ProductCode)    AS Mahya,
    MAX(momtaz.ProductCode)   AS Momtaz,
    MAX(hasti.ProdID)         AS Hasti,
    MAX(barij.ProductCode)    AS Barij,
    MAX(eltiam.ProductKey)    AS Eltiam
FROM (
    SELECT 
        GTIN, 
        LatinBrand, 
        PersianBrand 
    FROM Stage.Web.TotalProductImported
    WHERE Status NOT LIKE N'نیازمند ویرایش'
) AS kharazmi
LEFT JOIN (
    SELECT 
        ProductId, 
        RIGHT('00000000000000' + GTIN, 14) AS GTIN
    FROM stage.web.Daya_CustomerSales
    GROUP BY ProductId, GTIN
) AS daya ON RIGHT('00000000000000' + kharazmi.GTIN, 14) = daya.GTIN
LEFT JOIN (
    SELECT 
        ProductCode, 
        RIGHT('00000000000000' + GTIN, 14) AS GTIN
    FROM stage.web.Qhasem_CustomerSales
    GROUP BY ProductCode, GTIN
) AS qhasem ON RIGHT('00000000000000' + kharazmi.GTIN, 14) = qhasem.GTIN
LEFT JOIN (
    SELECT 
        ProductCode, 
        RIGHT('00000000000000' + GTIN, 14) AS GTIN
    FROM stage.web.Mahya_ProductSales
    GROUP BY ProductCode, GTIN
) AS mahya ON RIGHT('00000000000000' + kharazmi.GTIN, 14) = mahya.GTIN
LEFT JOIN (
    SELECT 
        ProductCode, 
        RIGHT('00000000000000' + GTIN, 14) AS GTIN
    FROM stage.web.Momtaz_Products
    GROUP BY ProductCode, GTIN
) AS momtaz ON RIGHT('00000000000000' + kharazmi.GTIN, 14) = momtaz.GTIN
LEFT JOIN (
    SELECT 
        ProdID, 
        RIGHT('00000000000000' + GTIN, 14) AS GTIN
    FROM stage.web.hasti_Inventory
    GROUP BY ProdID, GTIN
) AS hasti ON RIGHT('00000000000000' + kharazmi.GTIN, 14) = hasti.GTIN
LEFT JOIN (
    SELECT 
        ProductCode, 
        RIGHT('00000000000000' + GTIN, 14) AS GTIN
    FROM stage.web.Barij_Inventory
    GROUP BY ProductCode, GTIN
) AS barij ON RIGHT('00000000000000' + kharazmi.GTIN, 14) = barij.GTIN
LEFT JOIN (
    SELECT 
        ProductKey, 
        RIGHT('00000000000000' + GTIN, 14) AS GTIN
    FROM dw.dbo.dimproduct
    WHERE SupplierCode = 100
      AND ProductStatus = 1
      AND GTIN IS NOT NULL
    GROUP BY ProductKey, GTIN
) AS eltiam ON RIGHT('00000000000000' + kharazmi.GTIN, 14) = eltiam.GTIN
WHERE NOT EXISTS (
    SELECT 1 
    FROM dw.kharazmi.dimProductPakhsh p 
    WHERE p.GTIN = kharazmi.GTIN
)
GROUP BY 
    kharazmi.LatinBrand,
    kharazmi.PersianBrand,
    kharazmi.GTIN;
GO
