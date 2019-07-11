
SELECT SERVER_NAME, WORKFLOW_NAME, START_TIME, END_TIME,
  DECODE (RUN_STATUS_CODE,
                   1, 'Suceeded',
                   2, 'Disabled',
                   3, 'Failed',
                   4, 'Stopped',
                   5, 'Aborted',
                   6, 'Running',
                   7, 'Suspending',
                   8, 'Suspended',
                   9, 'Stopping',
                   10, 'Aborting',
                   11, 'Waiting',
                   12, 'Scheduled',
                   13, 'Unscheduled',
                   14, 'Unknown',
                   15, 'Terminated',
                   'Unknown') AS STATUS
    FROM REP_EX_PROD.OPB_WFLOW_RUN@EXINFPRD                
  WHERE SERVER_NAME='INT_EX_PROD'
 AND WORKFLOW_NAME IN ('WF_CTL_REFUND_LOADING_M')
 AND START_TIME>=SYSDATE-3 
 ORDER BY START_TIME DESC ;