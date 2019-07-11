CREATE OR REPLACE VIEW monitoring.replicate_syscorr (
   entity,
   last_time_src,
   commit_time_trg,
   delay_minutes )
AS
select --+ full(t) parallel(t,8)
case session_name 
    --изменено патч C2091984.DF.ADH.DF135
    --when 's_m_Repl_SUBHLDBALANCE_STAT' then 'Остатки компаний в Adhoc'
    when 's_m_Repl_SUBHLDBALANCE_STAT_DMFR2DMOUT' then 'Выгрузка из ФВ в область DMOUT остатков по компаниям'
    when 's_m_Repl_SUBHLDBALANCE_STAT_DMOUT2ADHOC' then 'Выгрузка из DMOUT в ADHOC остатков по компаниям'
    when 's_m_Repl_ADJUSTMENTBS_UA_VHIST_BNK653' then 'Корректировки 653'
    when 's_m_dmfr_ADJUSTMENT_SDIM_TO_ADHOC_finres_staging_dmfr_ADJUSTMENT_SDIM' then 'Справочник коррекций в Adhoc'
    when 's_m_Load_ADJUSTMENT_SDIM' then 'Справочник коррекций в МВ'
    when 's_m_Load_ADJUSTMENTBS_UA_VHIST_TO_SUBHLD' then 'Корректировки в МВ'
    when 's_m_Load_SUBHLDBALANCE_STAT_SUBHLD2DMIN' then 'Остатки из МВ в DWH'
    when 's_m_SUBHLDBALANCE_STAT_INC' then 'Остатки из МВ в DWH'  
end as entity,   
to_char(max(workflow_start_time),'DD.MM HH24:MI') as last_time_src, 
to_char(max(end_time),'DD.MM HH24:MI') as commit_time_trg, 
round((sysdate-max(start_time))*24*60) as delay_minutes
from monitoring.mon_infa_sessions t where 
((server_name='INT_EX_PROD' and folder_name='DWH_FINDM_DMFR' and workflow_name like 'wf_Replicate_data_DMFR2ADHOC_INC'
and session_name in (/*'s_m_Repl_SUBHLDBALANCE_STAT',*/'s_m_Repl_ADJUSTMENTBS_UA_VHIST','s_m_dmfr_ADJUSTMENT_SDIM_TO_ADHOC_finres_staging_dmfr_ADJUSTMENT_SDIM'))
or --добавлено
(server_name='INT_EX_PROD' and folder_name='DWH_FINDM_DMFR' and workflow_name like 'wf_Replicate_data_DMFR2ADHOC_BNK653'
and session_name = 's_m_Repl_ADJUSTMENTBS_UA_VHIST_BNK653')--каждые 40 мин
or --добавлено
(server_name='INT_EX_PROD' and folder_name='DWH_FINDM_DMFR' and workflow_name like 'wf_Replicate_data_DMFR2ADHOC_SubhldBalance'
and session_name in ('s_m_Repl_SUBHLDBALANCE_STAT_DMFR2DMOUT', 's_m_Repl_SUBHLDBALANCE_STAT_DMOUT2ADHOC'))--каждые 10 мин
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
    --изменено патч C2091984.DF.ADH.DF135
    --when 's_m_Repl_SUBHLDBALANCE_STAT' then 'Остатки компаний в Adhoc'
    when 's_m_Repl_SUBHLDBALANCE_STAT_DMFR2DMOUT' then 'Выгрузка из ФВ в область DMOUT остатков по компаниям'
    when 's_m_Repl_SUBHLDBALANCE_STAT_DMOUT2ADHOC' then 'Выгрузка из DMOUT в ADHOC остатков по компаниям'
    when 's_m_Repl_ADJUSTMENTBS_UA_VHIST_BNK653' then 'Корректировки 653'
    when 's_m_Repl_ADJUSTMENTBS_UA_VHIST' then 'Корректировки в Adhoc'
    when 's_m_dmfr_ADJUSTMENT_SDIM_TO_ADHOC_finres_staging_dmfr_ADJUSTMENT_SDIM' then 'Справочник коррекций в Adhoc'
    when 's_m_Load_ADJUSTMENT_SDIM' then 'Справочник коррекций в МВ'
    when 's_m_Load_ADJUSTMENTBS_UA_VHIST_TO_SUBHLD' then 'Корректировки в МВ'
    when 's_m_Load_SUBHLDBALANCE_STAT_SUBHLD2DMIN' then 'Остатки из МВ в DWH'
    when 's_m_SUBHLDBALANCE_STAT_INC' then 'Остатки из МВ в DWH'   
end
