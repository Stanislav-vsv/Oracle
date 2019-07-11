-- взят из вьюшки  MONITORING.SVER_PROV_CORE_DMFR_501;
WITH 
        t11
        AS (SELECT *
              FROM dwh.transaction_htran
             WHERE     deleted_flag = 'N'
                   AND validto = '31.12.5999'
                   AND value_day = '28.12.2016'),
        t1
        AS (SELECT *
              FROM t11 at1
                   JOIN dwh.GL2ACCOUNT_HDIM gl21
                      ON     gl21.uk = at1.gl2account_debit_uk
                         AND gl21.deleted_flag = 'N'
                         AND gl21.validto = '31.12.5999'
                   JOIN dwh.GL2ACCOUNT_HDIM gl22
                      ON     gl22.uk = at1.gl2account_credit_uk
                         AND gl22.deleted_flag = 'N'
                         AND gl22.validto = '31.12.5999'
             WHERE NOT ( ( (gl21.ncode LIKE '707%')
                          AND (gl22.ncode LIKE '708%'))
                        OR ( (gl21.ncode LIKE '708%')
                            AND (gl22.ncode LIKE '707%'))
                        OR ( (gl21.ncode LIKE '707%')
                            AND (gl22.ncode LIKE '303%'))
                        OR ( (gl21.ncode LIKE '303%')
                            AND (gl22.ncode LIKE '707%')))),
        t2
        AS (SELECT gl2.ncode, 'D' AP, at1.*
              FROM    t1 at1
                   JOIN
                      dwh.GL2ACCOUNT_HDIM gl2
                   ON     gl2.uk = at1.gl2account_debit_uk
                      AND gl2.deleted_flag = 'N'
                      AND gl2.validto = '31.12.5999'
             WHERE gl2.ncode LIKE '706%' OR gl2.ncode LIKE '707%'),       --ok
        t3
        AS (SELECT gl2.ncode, 'C' AP, at1.*
              FROM    t1 at1
                   JOIN
                      dwh.GL2ACCOUNT_HDIM gl2
                   ON     gl2.uk = at1.gl2account_credit_uk
                      AND gl2.deleted_flag = 'N'
                      AND gl2.validto = '31.12.5999'
             WHERE gl2.ncode LIKE '706%' OR gl2.ncode LIKE '707%'),
        t4
        AS (SELECT * FROM t2
            UNION ALL
            SELECT * FROM t3),                                            --ok
        t5
        AS (                                         --select count(*) from t4
            SELECT   t4.value_day,
                     t4.TRN_SOURCE_NO || t4.AP AS Tk,
                     SUM (
                        CASE
                           WHEN (ncode < 70606 AND AP = 'C')
                           THEN
                              acc_cur_amt
                           WHEN (ncode < 70606 AND AP = 'D')
                           THEN
                              -acc_cur_amt
                           WHEN (ncode >= 70606 AND ncode < 70613 AND AP = 'C')
                           THEN
                              -acc_cur_amt
                           WHEN (ncode >= 70606 AND ncode < 70613 AND AP = 'D')
                           THEN
                              acc_cur_amt
                           WHEN (ncode >= 70613 AND ncode < 70614 AND AP = 'C')
                           THEN
                              acc_cur_amt
                           WHEN (ncode >= 70613 AND ncode < 70614 AND AP = 'D')
                           THEN
                              -acc_cur_amt
                           WHEN (ncode = 70615 AND AP = 'C')
                           THEN
                              acc_cur_amt
                           WHEN (ncode = 70615 AND AP = 'D')
                           THEN
                              -acc_cur_amt
                           WHEN (    ncode >= 70614
                                 AND ncode < 70700
                                 AND ncode <> 70615
                                 AND AP = 'C')
                           THEN
                              -acc_cur_amt
                           WHEN (    ncode >= 70614
                                 AND ncode < 70700
                                 AND ncode <> 70615
                                 AND AP = 'D')
                           THEN
                              acc_cur_amt
                           WHEN (ncode >= 70700 AND ncode < 70706 AND AP = 'C')
                           THEN
                              acc_cur_amt
                           WHEN (ncode >= 70700 AND ncode < 70706 AND AP = 'D')
                           THEN
                              -acc_cur_amt
                           WHEN (ncode >= 70706 AND AP = 'C')
                           THEN
                              -acc_cur_amt
                           WHEN (ncode >= 70706 AND AP = 'D')
                           THEN
                              acc_cur_amt
                        END)
                        summa
                FROM t4
            GROUP BY value_day, t4.TRN_SOURCE_NO || t4.AP),
        t6
        AS (  SELECT pl.value_day,
                     pl.TK,
                     SUM (
                        CASE
                           WHEN ACC.CHAPTBAL_UK <> PL.CHAPTBAL_UK
                           THEN
                              pl.acc_cur_amt * (-1)
                           ELSE
                              pl.acc_cur_amt
                        END)
                        summa_pl
                FROM dmfr.PLTRANSACTION_TRAN pl
                     LEFT JOIN DMFR.TRNMARKLOG_TRAN tr
                        ON     TR.TRN_SOURCE_NO = PL.TRN_SOURCE_NO
                           AND TR.ACCOUNT_PL_UK = PL.ACCOUNT_PL_UK
                           AND TR.VALUE_DAY = PL.VALUE_DAY
                           AND TR.FILED_NAME = 'ACCOUNTCLAUSE_MARK_UK'
                           AND TR.DIRTY_FLAG = 'N'
                           AND TR.NEW_VALUE = PL.ACCOUNTCLAUSE_MARK_UK
                     LEFT JOIN DMFR.ACCOUNTCLAUSE_SDIM acc
                        ON ACC.UK = TR.OLD_VALUE AND ACC.DELETED_FLAG = 'N'
               WHERE pl.deleted_flag = 'N'
                     AND pl.value_day = '28.12.2016'
            GROUP BY pl.value_day, pl.TK)
   SELECT DISTINCT
          2 rev_id,
          501 list_id,
          TO_NUMBER (TO_CHAR (SYSDATE, 'yyyymmdd')) rev_date,
          TO_CHAR (SYSDATE, 'dd.mm.yyyy hh24:mi:ss') rev_datetime,
          CASE
             WHEN err_flag = 1
             THEN
                'Проводки Ядро != Проводки ФВ'
             ELSE
                ''
          END
             AS F_STR1,
          value_day AS F_STR2,
          summa AS F_NUM1,
          summa_pl AS F_NUM2,
          ROUND (ABS (NVL (summa_pl, 0) - NVL (summa, 0)), 2) AS F_NUM3,
          err_flag
     FROM (  SELECT value_day,
                    NVL (summa, 0) AS summa,
                    NVL (summa_pl, 0) AS summa_pl,
                    NVL (delta, 0) AS delta,
                    MAX (CASE WHEN delta > 0.01 THEN 1 ELSE 0 END) AS err_flag
               FROM (  SELECT NVL (value_day5, value_day6) AS value_day,
                              SUM (summa) AS summa,
                              SUM (summa_pl) AS summa_pl,
                              SUM (delta) AS delta
                         FROM (SELECT t5.value_day AS value_day5,
                                      t6.value_day AS value_day6,
                                      t5.TK AS TK_5,
                                      t6.TK AS TK_6,
                                      t5.summa,
                                      t6.summa_pl,
                                      ROUND (
                                         ABS (
                                            NVL (t5.summa, 0)
                                            - NVL (t6.summa_pl, 0)),
                                         2)
                                         AS delta
                                 FROM    t5 t5
                                      FULL JOIN
                                         t6 t6
                                      ON t5.value_day = t6.value_day
                                         AND t5.TK = t6.TK)
                     GROUP BY NVL (value_day5, value_day6)) tt
           GROUP BY value_day,
                    summa,
                    summa_pl,
                    delta);