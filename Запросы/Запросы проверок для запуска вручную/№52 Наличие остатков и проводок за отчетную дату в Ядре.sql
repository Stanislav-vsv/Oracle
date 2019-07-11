
SELECT
'ALL', 
0, 
'N', 
case when cnt=0 then 'ќтсутствуют записи за отчетную дату в ядре' else 'ok' end, 
52, 
5, 
case when cnt=0 then 'Y' else 'N' end, 
tab, 
day
                  
FROM   (  SELECT   clnd.day,
                                 SUM(CASE
                                        WHEN B.BALANCE_AMT_RUR IS NULL THEN 0
                                        ELSE 1
                                     END)
                                    cnt,
                                 'DWH.BALANCE_HSTAT' tab
                          FROM      DWH.PRDCALENDAR_SDIM clnd
                                 LEFT JOIN
                                    DWH.BALANCE_HSTAT b
                                 ON clnd.day = b.value_day
                         WHERE   day between '24.12.2015' and '30.12.2015'
                      GROUP BY   clnd.day
                      UNION ALL
                        SELECT   clnd.day,
                                 SUM (
                                    CASE WHEN T.ACC_CUR_AMT IS NULL THEN 0 ELSE 1 END
                                 )
                                    cnt,
                                 'DWH.TRANSACTION_HTRAN' tab
                          FROM      DWH.PRDCALENDAR_SDIM clnd
                                 LEFT JOIN
                                    DWH.TRANSACTION_HTRAN t
                                 ON clnd.day = t.value_day
                         WHERE   day between '24.12.2015' and '30.12.2015'
                      GROUP BY   clnd.day
                      )
          /*ORDER BY   tab, day desc*/;