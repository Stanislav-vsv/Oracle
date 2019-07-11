
  SELECT value_day,
                       SALESPLACE_BRANCH_UK,
                       (ABS (
                           ABS (
                              SUM (
                                 CASE ACCOUNTKIND_UK
                                    WHEN 1 THEN balance_rur_amt
                                    ELSE 0
                                 END))
                           - ABS (
                                SUM (
                                   CASE ACCOUNTKIND_UK
                                      WHEN 2 THEN balance_rur_amt
                                      ELSE 0
                                   END))))
                          AS delta
                  FROM DMFR.IFRSBALANCE_STAT@DW_ST_PROD
              WHERE value_day in ('31.03.2014', '01.04.2014')     
                       AND deleted_flag = 'N'
                       AND account_number NOT LIKE '9%'
                       AND account_number NOT LIKE '55555%'
                       AND salesplace_branch_uk NOT IN (5203384761, 5203385578)
              GROUP BY value_day, SALESPLACE_BRANCH_UK;
              
              
--select trunc(sysdate) from dual;
              
/*
2299464,95912
2204442,227264
245284360,063152
245284360,063152
*/

---------------------------------//

SELECT * FROM DQMON.DQ_DETAILJOURNAL_TRAN
WHERE DQ_CONTROL_UK = 96
ORDER BY XK DESC;

SELECT * FROM DQMON.DQ_DETAILJOURNAL_TRAN
WHERE DQ_CONTROL_UK = 96
and RESULT_CHAR1 in ('31.03.14', '01.04.14')
ORDER BY XK DESC;

UPDATE DQMON.DQ_DETAILJOURNAL_TRAN
SET RESULT_CHAR3 = 0
WHERE DQ_CONTROL_UK = 96
and RESULT_CHAR1 in ('31.03.14', '01.04.14');

04.04.2014 12:46:11,000000    02.04.14    5203525917    2299464,95912
03.04.2014 1:06:55,000000    01.04.14    5203525917    2204442,227264
03.04.2014 1:06:55,000000    31.03.14    5203525917    245284360,063152
02.04.2014 6:54:21,000000    31.03.14    5203525917    245284360,063152

---------------------------------//