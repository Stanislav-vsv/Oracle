
--контроль УМа

WITH
 OFF_WORKFLOWS
     AS (  SELECT                                            /*+ MATERIALIZE*/
                 workflow_name,
                  loading_id,
                  MAX (status),
                  MIN (JOB_ID) JOB_ID
             FROM UM.job@EXINFPRD
             WHERE loading_id IN
                     (SELECT loading_id
                        FROM um.loading@EXINFPRD
                       WHERE LOADING_ID IN
                                 (SELECT loading_id
                                   FROM um.loading@EXINFPRD
                                  WHERE workflow_name = 'WF_CTL_CORE_LOADING')
                                 OR REG_LOADING_ID IN
                                   (SELECT loading_id
                                      FROM um.loading@EXINFPRD
                                     WHERE workflow_name =
                                              'WF_CTL_CORE_LOADING'))
         GROUP BY workflow_name, loading_id
           HAVING MAX (status) = 'FAILED' AND COUNT (*) > 1),
           
 max_success_day
     AS (  SELECT                                             /*+materialize*/
                 MAX (start_dttm) MAX_SCS_START,
                  workflow_name
             FROM um.job@EXINFPRD
            WHERE status = 'SUCCEEDED'
         GROUP BY workflow_name),
         
 t1
   as (SELECT J.FOLDER_NAME,
             J.WORKFLOW_NAME,
             TO_CHAR(J.JOB_ID),
             TO_CHAR(PR.PARAM_VALUE),
             TO_CHAR(CONTROL_FLAG),
             TO_CHAR(j.start_dttm),
             TO_CHAR(MSD.MAX_SCS_START)
    FROM UM.JOB@EXINFPRD J
    JOIN UM.PREVPARAM@EXINFPRD PR
     ON PR.JOB_ID = J.JOB_ID
     AND PR.JOB_ID IN (SELECT JOB_ID FROM OFF_WORKFLOWS)
    JOIN UM.WORKFLOW_CONTROL@EXINFPRD WC
     ON WC.WORKFLOW_NAME = J.WORKFLOW_NAME
    JOIN max_success_day MSD
     ON MSD.WORKFLOW_NAME = J.WORKFLOW_NAME
    WHERE msd.max_SCS_start < j.start_dttm
    AND TRUNC (J.START_DTTM) >= TRUNC (SYSDATE) - 30
    ORDER BY J.JOB_ID),
  
 dummy
  as (select ' ' as aa, ' ' as bb, ' ' as cc, ' ' as dd, ' ' as ee, ' ' as ff, 'OK' from dual)  
  
  select * from t1
  union
  select * from dummy where (select count(*) from t1) < 1 
  ;
