
--520

SELECT 2,
            520,
            TO_CHAR (SYSDATE, 'dd.mm.yyyy hh24:mi:ss') AS rev_datetime,
            TO_NUMBER (TO_CHAR (SYSDATE, 'yyyymmdd')) rev_date,
            account_number AS f_str1,
            salesplace_uk AS f_str2,
            COUNT (1) AS f_str3,
            'ERROR' AS f_str4,
            1 AS error_flag
       FROM dwh.account_hdim
      WHERE     validto = '31.12.5999'
            AND account_number != 'N/A'
            AND deleted_flag <> 'Y'
   GROUP BY account_number, salesplace_uk
     HAVING COUNT (1) > 1
   UNION
   SELECT 2,
          520,
          TO_CHAR (SYSDATE, 'dd.mm.yyyy hh24:mi:ss') AS rev_datetime,
          TO_NUMBER (TO_CHAR (SYSDATE, 'yyyymmdd')) rev_date,
          NULL,
          NULL,
          NULL,
          CASE
             WHEN NOT EXISTS
                         (  SELECT account_number,
                                   salesplace_uk,
                                   COUNT (1) cnt,
                                   'ERROR' err_message,
                                   1 AS error_flag
                              FROM dwh.account_hdim
                             WHERE     validto = '31.12.5999'
                                   AND account_number != 'N/A'
                                   AND deleted_flag <> 'Y'
                          GROUP BY account_number, salesplace_uk
                            HAVING COUNT (1) > 1)
             THEN
                'OK'
          END
             AS err_message,
          0 AS error_flag
     FROM DUAL;