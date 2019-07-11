CREATE OR REPLACE VIEW monitoring.replicate_syscorr (
   entity,
   last_time_src,
   commit_time_trg,
   delay_minutes )
AS
select --+ full(t) parallel(t,8)
case session_name 
    --�������� ���� C2091984.DF.ADH.DF135
    --when 's_m_Repl_SUBHLDBALANCE_STAT' then '������� �������� � Adhoc'
    when 's_m_Repl_SUBHLDBALANCE_STAT_DMFR2DMOUT' then '�������� �� �� � ������� DMOUT �������� �� ���������'
    when 's_m_Repl_SUBHLDBALANCE_STAT_DMOUT2ADHOC' then '�������� �� DMOUT � ADHOC �������� �� ���������'
    when 's_m_Repl_ADJUSTMENTBS_UA_VHIST_BNK653' then '������������� 653'
    when 's_m_dmfr_ADJUSTMENT_SDIM_TO_ADHOC_finres_staging_dmfr_ADJUSTMENT_SDIM' then '���������� ��������� � Adhoc'
    when 's_m_Load_ADJUSTMENT_SDIM' then '���������� ��������� � ��'
    when 's_m_Load_ADJUSTMENTBS_UA_VHIST_TO_SUBHLD' then '������������� � ��'
    when 's_m_Load_SUBHLDBALANCE_STAT_SUBHLD2DMIN' then '������� �� �� � DWH'
    when 's_m_SUBHLDBALANCE_STAT_INC' then '������� �� �� � DWH'  
end as entity,   
to_char(max(workflow_start_time),'DD.MM HH24:MI') as last_time_src, 
to_char(max(end_time),'DD.MM HH24:MI') as commit_time_trg, 
round((sysdate-max(start_time))*24*60) as delay_minutes
from monitoring.mon_infa_sessions t where 
((server_name='INT_EX_PROD' and folder_name='DWH_FINDM_DMFR' and workflow_name like 'wf_Replicate_data_DMFR2ADHOC_INC'
and session_name in (/*'s_m_Repl_SUBHLDBALANCE_STAT',*/'s_m_Repl_ADJUSTMENTBS_UA_VHIST','s_m_dmfr_ADJUSTMENT_SDIM_TO_ADHOC_finres_staging_dmfr_ADJUSTMENT_SDIM'))
or --���������
(server_name='INT_EX_PROD' and folder_name='DWH_FINDM_DMFR' and workflow_name like 'wf_Replicate_data_DMFR2ADHOC_BNK653'
and session_name = 's_m_Repl_ADJUSTMENTBS_UA_VHIST_BNK653')--������ 40 ���
or --���������
(server_name='INT_EX_PROD' and folder_name='DWH_FINDM_DMFR' and workflow_name like 'wf_Replicate_data_DMFR2ADHOC_SubhldBalance'
and session_name in ('s_m_Repl_SUBHLDBALANCE_STAT_DMFR2DMOUT', 's_m_Repl_SUBHLDBALANCE_STAT_DMOUT2ADHOC'))--������ 10 ���
or
(server_name='INT_EX_PROD' and folder_name='ALFA_SUBHLD' and workflow_name like 'wf_Load_ADJUSTMENTBS_UA_VHIST_TO_SUBHLD'
and session_name in ('s_m_Load_ADJUSTMENTBS_UA_VHIST_TO_SUBHLD','s_m_Load_ADJUSTMENT_SDIM'))
or
(server_name='INT_EX_PROD' and folder_name='ALFA_SUBHLD' and workflow_name like 'wf_m_Load_SUBHLDBALANCE_STAT'
and session_name in ('s_m_Load_SUBHLDBALANCE_STAT_SUBHLD2DMIN','s_m_SUBHLDBALANCE_STAT_INC'))
)
and start_time >=sysdate-3 and RUN_STATUS_NAME='Succeeded'
group by 
case session_name 
    --�������� ���� C2091984.DF.ADH.DF135
    --when 's_m_Repl_SUBHLDBALANCE_STAT' then '������� �������� � Adhoc'
    when 's_m_Repl_SUBHLDBALANCE_STAT_DMFR2DMOUT' then '�������� �� �� � ������� DMOUT �������� �� ���������'
    when 's_m_Repl_SUBHLDBALANCE_STAT_DMOUT2ADHOC' then '�������� �� DMOUT � ADHOC �������� �� ���������'
    when 's_m_Repl_ADJUSTMENTBS_UA_VHIST_BNK653' then '������������� 653'
    when 's_m_Repl_ADJUSTMENTBS_UA_VHIST' then '������������� � Adhoc'
    when 's_m_dmfr_ADJUSTMENT_SDIM_TO_ADHOC_finres_staging_dmfr_ADJUSTMENT_SDIM' then '���������� ��������� � Adhoc'
    when 's_m_Load_ADJUSTMENT_SDIM' then '���������� ��������� � ��'
    when 's_m_Load_ADJUSTMENTBS_UA_VHIST_TO_SUBHLD' then '������������� � ��'
    when 's_m_Load_SUBHLDBALANCE_STAT_SUBHLD2DMIN' then '������� �� �� � DWH'
    when 's_m_SUBHLDBALANCE_STAT_INC' then '������� �� �� � DWH'   
end
