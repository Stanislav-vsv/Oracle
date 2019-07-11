
SELECT
'ALL' AS column_name, 
0 AS COLUMN_UK1, 
'N' AS DEFAULTST_FLAG, 
case when ERROR_FLAG = 0 then 'ok' else 'Îøèáêà' end  AS DESCRIPTION, 
63  AS DQ_CONTROL_UK, 
5  AS DQ_LEVEL_UK, 
case when ERROR_FLAG = 0 then 'N' else 'Y' end  AS ERROR_FLAG, 
F_NUM1 AS RESULT_NUM1, 
F_STR1 AS VALUE_DATE
FROM 
(
     SELECT 2 as REV_ID,
            527 as LIST_ID,
            TO_NUMBER (TO_CHAR (SYSDATE, 'yyyymmdd')) AS REV_DATE,
            TO_CHAR (SYSDATE, 'dd.mm.yyyy hh24:mi:ss') AS REV_DATETIME,
            SUM (delta) AS F_NUM1,
            value_day AS F_STR1,
            CASE WHEN SUM (delta) > 0.5 THEN 1 ELSE 0 END AS ERROR_FLAG
       FROM (  SELECT   --+full(ost) parallel(ost,4) use_hash(ost,acc,bch,gl2)
                     value_day,
                      BCH.BRANCH_ODS_NCODE,
                      ABS (
                         SUM (
                            CASE GL2.ACCOUNTKIND_UK
                               WHEN 1 THEN ost.balance_amt_rur
                               ELSE 0
                            END)
                         + SUM (
                              CASE GL2.ACCOUNTKIND_UK
                                 WHEN 2 THEN ost.balance_amt_rur
                                 ELSE 0
                              END))
                         AS DELTA
                 FROM dwh.balance_hstat ost
                      JOIN dwh.account_hdim acc
                         ON ost.account_uk = acc.uk AND acc.deleted_flag = 'N'
                            AND acc.validto =
                                   TO_DATE ('31.12.5999', 'DD.MM.YYYY')
                      JOIN DWH.SALESPLACE_HDIM bch
                         ON acc.salesplace_uk = bch.uk AND bch.deleted_flag = 'N'
                            AND bch.validto =
                                   TO_DATE ('31.12.5999', 'DD.MM.YYYY')
                            AND bch.BRANCH_ODS_NCODE <> 10004
                      JOIN DWH.GL2ACCOUNT_HDIM gl2
                         ON ACC.GL2ACCOUNT_UK = gl2.uk AND gl2.deleted_flag = 'N'
                            AND gl2.validto =
                                   TO_DATE ('31.12.5999', 'DD.MM.YYYY')
                            AND GL2.NCODE NOT LIKE '9%'
                --AND GL2.NCODE NOT LIKE '55555%'
                WHERE ost.value_day between '24.12.2015' and '30.12.2015'
                      AND ost.deleted_flag = 'N'
                      AND ost.validto = TO_DATE ('31.12.5999', 'DD.MM.YYYY')
             GROUP BY value_day, BCH.BRANCH_ODS_NCODE)
   GROUP BY value_day
)
