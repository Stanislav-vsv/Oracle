--контроль IPC
with sess_month_stat as (
select session_name, round(min(src_success_rows)) min_src_rows from mon_infa_sessions where server_name='INT_EX_PROD' and folder_name like 'DWI%' AND 
 session_name LIKE 's_m%' and trunc(workflow_start_time)>=trunc(sysdate)-30 and trunc(workflow_start_time)<>trunc(sysdate)
 group by session_name)
select mis.session_name, min_src_rows,src_success_rows, 
 case when src_success_rows is null then 'Сессия не отработала в инкременте!!!' else 'Ok' end sess_run  from sess_month_stat sms left join mon_infa_sessions mis on sms.session_name=mis.session_name where mis.server_name='INT_EX_PROD' and folder_name like 'DWI%'
and mis.session_name LIKE 's_m%' and trunc(workflow_start_time)=trunc(sysdate)
and (src_success_rows is null  or (src_success_rows=0 and src_success_rows<min_src_rows));

--контроль УМа
WITH OFF_WORKFLOWS AS (
select /*+ MATERIALIZE*/  workflow_name, loading_id, max(status),MIN(JOB_ID) JOB_ID from UM.job@EXINFPRD where loading_id in ( 
select loading_id from  um.loading@EXINFPRD WHERE LOADING_ID IN (
select loading_id from um.loading@EXINFPRD where workflow_name='WF_CTL_CORE_LOADING')
OR REG_LOADING_ID IN (
select loading_id from um.loading@EXINFPRD where workflow_name='WF_CTL_CORE_LOADING')
)
group by workflow_name, loading_id
having max(status)='FAILED' AND COUNT(*)>1
),
 max_success_day as 
(select /*+materialize*/  max(start_dttm) MAX_SCS_START, workflow_name from um.job@EXINFPRD  where status='SUCCEEDED' group by workflow_name )


SELECT J.FOLDER_NAME, J.WORKFLOW_NAME, J.JOB_ID,   PR.PARAM_VALUE, CONTROL_FLAG, j.start_dttm, MSD.MAX_SCS_START FROM UM.JOB@EXINFPRD J JOIN UM.PREVPARAM@EXINFPRD PR ON PR.JOB_ID=J.JOB_ID AND PR.JOB_ID  IN (
SELECT  JOB_ID FROM OFF_WORKFLOWS
)
JOIN UM.WORKFLOW_CONTROL@EXINFPRD WC ON WC.WORKFLOW_NAME=J.WORKFLOW_NAME
JOIN  max_success_day MSD ON MSD.WORKFLOW_NAME=J.WORKFLOW_NAME
where msd.max_SCS_start<j.start_dttm AND TRUNC(J.START_DTTM)>=TRUNC(SYSDATE)-30
--убрать для просмотра всех потоков, а не только для последнего инкр.--
/*where j.loading_id in (
select loading_id from  um.loading WHERE LOADING_ID IN (
select MAX(LOADING_ID) from um.loading where workflow_name='WF_CTL_CORE_LOADING')
OR REG_LOADING_ID IN (
select MAX(LOADING_ID) from um.loading where workflow_name='WF_CTL_CORE_LOADING')
)*/
--убрать для просмотра всех потоков, а не только для последнего инкр.--
ORDER BY J.JOB_ID;
