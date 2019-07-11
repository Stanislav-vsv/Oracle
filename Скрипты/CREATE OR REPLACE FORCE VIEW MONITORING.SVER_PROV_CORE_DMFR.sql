
CREATE OR REPLACE FORCE VIEW MONITORING.SVER_PROV_CORE_DMFR
(rev_id,
                                   list_id,
                                   rev_date,
                                   rev_datetime,
                                   F_STR1,
                                   F_STR2,
                                   F_NUM1,
                                   F_NUM2,
                                   F_NUM3,
                                   error_flag)
     WITH t11
             AS (SELECT /*+ no_index(trn)*/  *
                   FROM   dwh.transaction_htran
                  WHERE   deleted_flag = 'N' AND validto = '31.12.5999'
                          AND value_day BETWEEN TRUNC (SYSDATE, 'IW') - 11
                                            AND  TRUNC (SYSDATE, 'IW') - 5),
          t1
             AS (SELECT   *
                   FROM         t11 at1
                             JOIN
                                dwh.GL2ACCOUNT_HDIM gl21
                             ON     gl21.uk = at1.gl2account_debit_uk
                                AND gl21.deleted_flag = 'N'
                                AND gl21.validto = '31.12.5999'
                          JOIN
                             dwh.GL2ACCOUNT_HDIM gl22
                          ON     gl22.uk = at1.gl2account_credit_uk
                             AND gl22.deleted_flag = 'N'
                             AND gl22.validto = '31.12.5999'
                  WHERE   NOT ( ( (gl21.ncode LIKE '707%')
                                 AND (gl22.ncode LIKE '708%'))
                               OR ( (gl21.ncode LIKE '708%')
                                   AND (gl22.ncode LIKE '707%'))
                               OR ( (gl21.ncode LIKE '707%')
                                   AND (gl22.ncode LIKE '303%'))
                               OR ( (gl21.ncode LIKE '303%')
                                   AND (gl22.ncode LIKE '707%')))),
          t2
             AS (SELECT   gl2.ncode, 'D' AP, at1.*
                   FROM      t1 at1
                          JOIN
                             dwh.GL2ACCOUNT_HDIM gl2
                          ON     gl2.uk = at1.gl2account_debit_uk
                             AND gl2.deleted_flag = 'N'
                             AND gl2.validto = '31.12.5999'
                  WHERE   gl2.ncode LIKE '706%' OR gl2.ncode LIKE '707%'),
          t3
             AS (SELECT   gl2.ncode, 'C' AP, at1.*
                   FROM      t1 at1
                          JOIN
                             dwh.GL2ACCOUNT_HDIM gl2
                          ON     gl2.uk = at1.gl2account_credit_uk
                             AND gl2.deleted_flag = 'N'
                             AND gl2.validto = '31.12.5999'
                  WHERE   gl2.ncode LIKE '706%' OR gl2.ncode LIKE '707%'),
          t4 AS (SELECT   * FROM t2
                 UNION ALL
                 SELECT   * FROM t3),
          t5
             AS (  --select count(*) from t4
                   SELECT   t4.value_day,
                            t4.trn_id,
                            SUM(CASE
                                   WHEN (ncode < 70606 AND AP = 'C')
                                   THEN
                                      acc_cur_amt
                                   WHEN (ncode < 70606 AND AP = 'D')
                                   THEN
                                      -acc_cur_amt
                                   WHEN (    ncode >= 70606
                                         AND ncode < 70613
                                         AND AP = 'C')
                                   THEN
                                      -acc_cur_amt
                                   WHEN (    ncode >= 70606
                                         AND ncode < 70613
                                         AND AP = 'D')
                                   THEN
                                      acc_cur_amt
                                   WHEN (    ncode >= 70613
                                         AND ncode < 70614
                                         AND AP = 'C')
                                   THEN
                                      acc_cur_amt
                                   WHEN (    ncode >= 70613
                                         AND ncode < 70614
                                         AND AP = 'D')
                                   THEN
                                      -acc_cur_amt
                                   WHEN (    ncode >= 70614
                                         AND ncode < 70700
                                         AND AP = 'C')
                                   THEN
                                      -acc_cur_amt
                                   WHEN (    ncode >= 70614
                                         AND ncode < 70700
                                         AND AP = 'D')
                                   THEN
                                      acc_cur_amt
                                   WHEN (    ncode >= 70700
                                         AND ncode < 70706
                                         AND AP = 'C')
                                   THEN
                                      acc_cur_amt
                                   WHEN (    ncode >= 70700
                                         AND ncode < 70706
                                         AND AP = 'D')
                                   THEN
                                      -acc_cur_amt
                                   WHEN (ncode >= 70706 AND AP = 'C')
                                   THEN
                                      -acc_cur_amt
                                   WHEN (    ncode >= 70706
                                         AND ncode < 70713
                                         AND AP = 'D')
                                   THEN
                                      acc_cur_amt
                                   WHEN (ncode = 70713 AND AP = 'D')
                                   THEN
                                      -acc_cur_amt
                                END)
                               summa
                     FROM   t4
                 GROUP BY   value_day, t4.trn_id),
          t6
             AS (  SELECT   value_day, trn_id, SUM (acc_cur_amt) summa_pl
                     FROM   dmfr.PLTRANSACTION_TRAN
                    WHERE   deleted_flag = 'N'
                            AND value_day BETWEEN TRUNC (SYSDATE, 'IW') - 11
                                              AND  TRUNC (SYSDATE, 'IW') - 5
                 GROUP BY   value_day, trn_id)
      SELECT   DISTINCT
               2 rev_id,
               501 list_id,
               TO_NUMBER (TO_CHAR (SYSDATE, 'yyyymmdd')) rev_date,
               TO_CHAR (SYSDATE, 'dd.mm.yyyy hh24:mi:ss') rev_datetime,
               CASE
                  WHEN err_flag = 1 THEN 'Проводки Ядро != Проводки ФВ'
                  ELSE ''
               END
                  AS F_STR1,
               value_day AS F_STR2,
               summa AS F_NUM1,
               summa_pl AS F_NUM2,
               ABS (NVL (summa_pl, 0) - NVL (summa, 0)) AS F_NUM3,
               err_flag

        FROM   (  SELECT   value_day,
                           NVL (summa, 0) AS summa,
                           NVL (summa_pl, 0) AS summa_pl,
                           NVL (delta, 0) AS delta,
                           MAX (CASE WHEN delta <> 0 THEN 1 ELSE 0 END)
                              AS err_flag
                    FROM   (  SELECT   NVL (value_day5, value_day6) AS value_day,
                                       SUM (summa) AS summa,
                                       SUM (summa_pl) AS summa_pl,
                                       SUM (delta) AS delta
                                FROM   (SELECT   t5.value_day AS value_day5,
                                                 t6.value_day AS value_day6,
                                                 t5.trn_id,
                                                 t6.trn_id,
                                                 t5.summa,
                                                 t6.summa_pl,
                                                 ABS(NVL (t5.summa, 0)
                                                     - NVL (t6.summa_pl, 0))
                                                    AS delta
                                          FROM      t5 t5
                                                 FULL JOIN
                                                    t6 t6
                                                 ON t5.value_day = t6.value_day
                                                    AND t5.trn_id = t6.trn_id)
                            GROUP BY   NVL (value_day5, value_day6)) tt
                GROUP BY   value_day,
                           summa,
                           summa_pl,
                           delta);
