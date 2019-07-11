
-- 507

WITH t1
        AS (  SELECT value_day, account_uk, SUM (acc_cur_amt) AS result
                FROM (SELECT  --+ full(pl) parallel(pl,4) use_hash(pl,acc,gl2)
                            value_day,
                             pl.account_credit_uk AS account_uk,
                             acc_cur_amt
                        FROM DWH.TRANSACTION_HTRAN pl
                             JOIN dwh.account_hdim acc
                                ON pl.account_credit_uk = acc.uk
                                   AND acc.deleted_flag = 'N'
                                   AND acc.validto =
                                          TO_DATE ('31.12.5999', 'DD.MM.YYYY')
                             JOIN DWH.GL2ACCOUNT_HDIM gl2
                                ON ACC.GL2ACCOUNT_UK = gl2.uk
                                   AND gl2.deleted_flag = 'N'
                                   AND gl2.validto =
                                          TO_DATE ('31.12.5999', 'DD.MM.YYYY')
                                   AND GL2.NCODE LIKE '7%'
                       WHERE pl.value_day BETWEEN TRUNC (SYSDATE - 5, 'dd')
                                              AND TRUNC (SYSDATE - 1, 'dd')
                             AND pl.deleted_flag = 'N'
                             AND pl.validto =
                                    TO_DATE ('31.12.5999', 'DD.MM.YYYY')
                      UNION ALL
                      SELECT  --+ full(pl) parallel(pl,4) use_hash(pl,acc,gl2)
                            value_day,
                             pl.account_debit_uk AS account_uk,
                             acc_cur_amt
                        FROM DWH.TRANSACTION_HTRAN pl
                             JOIN dwh.account_hdim acc
                                ON pl.account_debit_uk = acc.uk
                                   AND acc.deleted_flag = 'N'
                                   AND acc.validto =
                                          TO_DATE ('31.12.5999', 'DD.MM.YYYY')
                             JOIN DWH.GL2ACCOUNT_HDIM gl2
                                ON ACC.GL2ACCOUNT_UK = gl2.uk
                                   AND gl2.deleted_flag = 'N'
                                   AND gl2.validto =
                                          TO_DATE ('31.12.5999', 'DD.MM.YYYY')
                                   AND GL2.NCODE LIKE '7%'
                       WHERE pl.value_day BETWEEN TRUNC (SYSDATE - 5, 'dd')
                                              AND TRUNC (SYSDATE - 1, 'dd')
                             AND pl.deleted_flag = 'N'
                             AND pl.validto =
                                    TO_DATE ('31.12.5999', 'DD.MM.YYYY')) t
            GROUP BY value_day, account_uk),
        t2
        AS (  SELECT       --+ full(ost) parallel(ost,4) use_hash(ost,acc,gl2)
                    value_day,
                     ost.account_uk AS account_uk,
                     SUM (credit_turn_amt_cur + debet_turn_amt_cur) AS result
                FROM dwh.balance_hstat ost
                     JOIN dwh.account_hdim acc
                        ON ost.account_uk = acc.uk AND acc.deleted_flag = 'N'
                           AND acc.validto =
                                  TO_DATE ('31.12.5999', 'DD.MM.YYYY')
                     JOIN DWH.GL2ACCOUNT_HDIM gl2
                        ON ACC.GL2ACCOUNT_UK = gl2.uk
                           AND gl2.deleted_flag = 'N'
                           AND gl2.validto =
                                  TO_DATE ('31.12.5999', 'DD.MM.YYYY')
                           AND GL2.NCODE LIKE '7%'
               WHERE ost.value_day BETWEEN TRUNC (SYSDATE - 5, 'dd')
                                       AND TRUNC (SYSDATE - 1, 'dd')
                     AND ost.deleted_flag = 'N'
                     AND ost.validto = TO_DATE ('31.12.5999', 'DD.MM.YYYY')
            GROUP BY value_day, ost.account_uk)
     SELECT 2,
            507,
            TO_NUMBER (TO_CHAR (SYSDATE, 'yyyymmdd')),
            TO_CHAR (SYSDATE, 'dd.mm.yyyy hh24:mi:ss'),
            CASE WHEN err = 0 THEN '' ELSE 'Œ¯Ë·Í‡' END AS MSG,
            NVL (result_trans, 0),
            NVL (result_bal, 0),
            delta,
            value_day,
            err AS error_flag
       FROM (  SELECT NVL (value_day1, value_day2) AS value_day,
                      SUM (result_trans) AS result_trans,
                      SUM (result_bal) AS result_bal,
                      SUM (Delta) AS delta,
                      CASE WHEN SUM (delta) = 0 THEN 0 ELSE 1 END err
                 FROM (SELECT t1.value_day AS value_day1,
                              t2.value_day AS value_day2,
                              t1.account_uk,
                              t2.account_uk,
                              t1.result AS result_trans,
                              t2.result AS result_bal,
                              ABS (NVL (t1.result, 0) - NVL (t2.result, 0))
                                 AS Delta
                         FROM    t1
                              FULL JOIN
                                 t2
                              ON t1.value_day = t2.value_day
                                 AND t1.account_uk = t2.account_uk) t
             GROUP BY NVL (value_day1, value_day2))
   ORDER BY value_day DESC;