SELECT        alc.idCase, CAST(alc.casCreationDate AS date) AS StartDate, DATEDIFF(MINUTE, casCreationDate, a.wiExitDate) - DATEDIFF(MINUTE, a.wiEntryDate, a.wiExitDate) AS DateBeforDone, DATEDIFF(MINUTE, a.wiEntryDate, 
                         a.wiExitDate) AS duration_minute, t.Rate, t.timeRequired * 60 AS timeRequired_minute, tch.idprm_TicketCtgHeadline, tch.headLine, tch.ticketCategory, tc.categoryTitle, t.applicant, ura.fullName AS requester, cs.csName, 
                         ur.fullName AS processor, a.decisionTitle, a.tskDisplayName, CAST(a.wiExitDate AS date) AS EndDate, ITI.Title
FROM            [192.168.10.11].ExtraBizagiDB.dbo.vw_AllCases AS alc LEFT OUTER JOIN
                             (SELECT        *
                               FROM            [192.168.10.11].Prd_Bamdad.dbo.tbl_Ticket) AS t ON alc.idCase = t.caseId LEFT OUTER JOIN
                         [192.168.10.11].Prd_Bamdad.dbo.WFUSER AS u ON u.idUser = t.applicant LEFT OUTER JOIN
                             (SELECT        *
                               FROM            [192.168.10.11].Prd_Bamdad.dbo.prm_TicketCtgHeadline) AS tch ON tch.idprm_TicketCtgHeadline = t.ticketCtgHeadLine LEFT OUTER JOIN
                             (SELECT        *
                               FROM            [192.168.10.11].Prd_Bamdad.dbo.prm_TicketCategory) AS tc ON tc.idprm_TicketCategory = tch.ticketCategory LEFT OUTER JOIN
                             (SELECT        *
                               FROM           [192.168.10.11].Prd_Bamdad.dbo.prm_ITIlLevel) AS ITI ON ITI.idprm_ITIlLevel = tch.ITIlLevel LEFT OUTER JOIN
                             (SELECT        *
                               FROM           [192.168.10.11].Prd_Bamdad.dbo.WFUSER) AS ur ON ur.idUser = CASE WHEN teckExpert IS NOT NULL THEN teckExpert ELSE HeadOrTeckExpert END LEFT OUTER JOIN
                             (SELECT        *
                               FROM            [192.168.10.11].Prd_Bamdad.dbo.WFUSER) AS ura ON ura.idUser = t.applicant LEFT OUTER JOIN
                             (SELECT        *
                               FROM            [192.168.10.11].Prd_Bamdad.dbo.CASESTATE) AS cs ON cs.idCaseState = alc.idCaseState LEFT OUTER JOIN
                             (SELECT        casefull.CaseId, idprm_TaskDecision, decisionTitle, wiEntryDate, wiExitDate, WorkItemId, tskDisplayName
                               FROM            (SELECT        MAX(casefull.idtbl_CaseDescriptions) AS idtbl_CaseDescriptions, CaseId
                                                         FROM            [192.168.10.11].ExtraBizagiDB.dbo.vw_CaseDescriptionFull
                                                         WHERE        (idprm_TaskDecision <> 6)
                                                         GROUP BY CaseId) AS casefull INNER JOIN
                                                             (SELECT        *
                                                               FROM            [192.168.10.11].ExtraBizagiDB.dbo.vw_CaseDescriptionFull) AS casedetail ON casedetail.CaseId = casefull.CaseId AND casefull.idtbl_CaseDescriptions = casedetail.idtbl_CaseDescriptions) 
                         AS a ON a.CaseId = alc.idCase
WHERE        (t.caseId IS NOT NULL)