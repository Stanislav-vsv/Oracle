
--контроль IPC

WITH 

t1
     AS (  SELECT session_name, ROUND (MIN (src_success_rows)) min_src_rows
             FROM mon_infa_sessions
            WHERE     server_name = 'INT_EX_PROD'
                  AND folder_name LIKE 'DWI%'
                  AND session_name LIKE 's_m%'
                  AND TRUNC (workflow_start_time) >= TRUNC (SYSDATE) - 30
                  AND TRUNC (workflow_start_time) <> TRUNC (SYSDATE)
         GROUP BY session_name),
         
sess_month_stat         
    AS  ( SELECT mis.session_name,
                   TO_CHAR(min_src_rows),
                   TO_CHAR(src_success_rows),
                   CASE
                      WHEN src_success_rows IS NULL
                      THEN
                         '—есси€ не отработала в инкременте!!!'
                      ELSE
                         'Ok'
                   END
                      sess_run
        FROM    t1 sms
        LEFT JOIN
        mon_infa_sessions mis
        ON sms.session_name = mis.session_name
        WHERE mis.server_name = 'INT_EX_PROD'
               AND folder_name LIKE 'DWI%'
               AND mis.session_name LIKE 's_m%'
               AND TRUNC (workflow_start_time) = TRUNC (SYSDATE)
               AND (src_success_rows IS NULL
                    OR (src_success_rows = 0 AND src_success_rows < min_src_rows))),
                    
t3 
    as (select ' ' as aa, ' ' as bb, ' ' as cc, 'ok' from dual) 
 
select * from sess_month_stat
union
select * from t3 where (select count(*) from sess_month_stat) < 1                  
                    
;