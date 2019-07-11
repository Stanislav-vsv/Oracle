
DROP VIEW MONITORING.V_DQ_GET_REV_ID_NEW;

/* Formatted on 28.05.2013 14:48:10 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW MONITORING.V_DQ_GET_REV_ID_NEW
(
   REV_ID, LIST_ID, REV_DATETIME, MAX_REV_DATETIME
)
AS
SELECT REV_ID, LIST_ID, REV_DATETIME,  MAX (TO_DATE (rev_datetime, 'dd.mm.yyyy hh24:mi:ss'))
OVER (PARTITION BY TRUNC(TO_DATE (rev_datetime, 'dd.mm.yyyy hh24:mi:ss')), LIST_ID) MAX_REV_DATETIME
FROM DQ_MAIN 
WHERE  TRUNC(TO_DATE(rev_datetime, 'dd.mm.yyyy hh24:mi:ss')) BETWEEN
                                            CASE  
                                            WHEN TO_CHAR (SYSDATE, 'D') = 1
                                            THEN
                                               TRUNC (SYSDATE) - 2
                                            WHEN TO_CHAR (SYSDATE, 'D') NOT IN 1
                                            THEN 
                                               TRUNC (SYSDATE)
                                            END
                                            AND 
                                            CASE
                                            WHEN TO_CHAR (SYSDATE, 'D') = 1
                                            THEN
                                               TRUNC (SYSDATE)
                                            WHEN TO_CHAR (SYSDATE, 'D') NOT IN 1
                                            THEN 
                                               TRUNC (SYSDATE)
                                            END
--group by list_id, rev_id
;


