
SELECT   
STATUS, 
WORKFLOW_NAME,
SUBJ_NAME, 
START_TIME, 
END_TIME,
ROW_INSERTED
from monitoring.mon_infa_workflows
where 
SERVER_NAME ='INT_EX_PROD' 
--AND SUBJ_NAME='DMSFR' 
AND WORKFLOW_NAME IN ('WF_CTL_CORE_LOADING','WF_CTL_DQTRANS_LOADING','WF_CTL_DQ_SYNC','WF_CTL_DQDWH_LOADING') 
AND start_time between  trunc (sysdate-1) + 22/24 and sysdate
AND status NOT IN ('Unscheduled')
order by 4;
