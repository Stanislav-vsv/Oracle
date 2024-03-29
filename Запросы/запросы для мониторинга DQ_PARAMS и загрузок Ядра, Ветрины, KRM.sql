SELECT * FROM DQ_PARAMS;

 SELECT *  FROM MON_INFA_WORKFLOWS   -- ���� 
 WHERE SERVER_NAME='INT_DW_PROD'
 AND WORKFLOW_NAME='WF_CTL_CORE_LOADING_V2'
 AND START_TIME>=SYSDATE-7 
 AND STATUS<>'Unscheduled';
 
  /* SELECT *  FROM MON_INFA_WORKFLOWS   -- �� ���.������� 
 WHERE SERVER_NAME='INT_DW_PROD'
 AND WORKFLOW_NAME='WF_CTL_DMFR_LOADING_AW_INCR_AND_NPC'
 AND START_TIME>=SYSDATE-7 
 AND STATUS<>'Unscheduled'; */
 
  SELECT *  FROM MON_INFA_WORKFLOWS   -- �� ���.������� ��� ������ 
 WHERE SERVER_NAME='INT_DW_PROD'
 AND WORKFLOW_NAME IN ('WF_CTL_DMFR_LOADING_AW_INCR_AND_NPC', 'WF_CTL_DMFR_LOADING_FULL')
 AND START_TIME>=SYSDATE-7 
 AND STATUS<>'Unscheduled'; 
 
 SELECT *  FROM MON_INFA_WORKFLOWS   -- KRM 
 WHERE SERVER_NAME='INT_DW_PROD'
 AND WORKFLOW_NAME='WF_CTL_LOAD_TO_DMOUT_AW'
 AND START_TIME>=SYSDATE-7 
 AND STATUS<>'Unscheduled';
  
 SELECT *  FROM MON_INFA_WORKFLOWS   -- ��, ������� ������� � ������� �� ������
 WHERE SERVER_NAME='INT_DW_PROD'
 AND WORKFLOW_NAME='WF_CTL_DMFR_COMP_CORR_LOADING_AW'
 AND START_TIME>=SYSDATE-7 
 AND STATUS<>'Unscheduled';
  
 SELECT *  FROM MON_INFA_WORKFLOWS   -- ��, ������� ������� � ������� �� �����
 WHERE SERVER_NAME='INT_DW_PROD'
 AND WORKFLOW_NAME='WF_CTL_DMFR_COMP_REF_LOADING_M'
 AND START_TIME>=SYSDATE-7 
 AND STATUS<>'Unscheduled'; 
 
 
 SELECT T1.*, TO_CHAR(END_TIME, 'DY') DAY  FROM DQ_PARAMS T1;
 
 SELECT * FROM DQ_PARAMS 
 WHERE TO_CHAR(START_TIME, 'DD.MM.YYYY HH24:MI:SS') IN ('21.08.2013 06:23:31');
   
  
 SELECT START_TIME, LAG(START_TIME)OVER(ORDER BY START_TIME )
 FROM DQ_PARAMS ; 
 
 /*UPDATE DQ_PARAMS
 SET DQ_RUN = 'N'
 WHERE TO_CHAR(START_TIME, 'DD.MM.YYYY HH24:MI:SS') IN ('21.08.2013 06:23:31');*/
 
TRUNCATE TABLE DQ_MAIN_DEL_LOG;
 
SELECT * FROM MONITORING.DQ_MAIN_DEL_LOG;


