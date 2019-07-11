
SELECT
'ALL', 
0, 
'N', 
case when cnt=0 then 'Отсутствуют записи за отчетную дату в ФВ' else 'ok' end, 
66, 
5, 
case when cnt=0 then 'Y' else 'N' end, 
tab, 
day

FROM
(SELECT   clnd.day,
                                 SUM(CASE
                                        WHEN B.BALANCE_RUR_AMT IS NULL THEN 0
                                        ELSE 1
                                     END)
                                    cnt,
                                 'DMFR.IFRSBALANCE_STAT' tab
                          FROM      DWH.PRDCALENDAR_SDIM clnd
                                 LEFT JOIN
                                    DMFR.IFRSBALANCE_STAT b
                                 ON clnd.day = b.value_day
                         WHERE   day between '24.12.2015' and '30.12.2015'
                      GROUP BY   clnd.day
                        HAVING   SUM(CASE
                                        WHEN B.BALANCE_RUR_AMT IS NULL THEN 0
                                        ELSE 1
                                     END) = 0
                      UNION ALL
                        SELECT   clnd.day,
                                 SUM (
                                    CASE WHEN T.ACC_CUR_AMT IS NULL THEN 0 ELSE 1 END
                                 )
                                    cnt,
                                 'DMFR.PLTRANSACTION_TRAN' tab
                          FROM      DWH.PRDCALENDAR_SDIM clnd
                                 LEFT JOIN
                                    DMFR.PLTRANSACTION_TRAN t
                                 ON clnd.day = t.value_day
                         WHERE   day between '24.12.2015' and '30.12.2015'
                      GROUP BY   clnd.day
                    )
          /*ORDER BY   tab, day desc*/;