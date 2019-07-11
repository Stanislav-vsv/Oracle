select count(*), sum(abs(BALANCE_RUR_AMT-BALANCE_AMT_RUR)),sum((BALANCE_RUR_AMT-BALANCE_AMT_RUR)), value_day
from (
select * from (
with t1 as
(
select /*+ inline no_merge*/account_uk, BALANCE_RUR_AMT, EFFECTIVE_FROM, EFFECTIVE_TO
from 
DMRB.BALANCE_SHIST@RBPROD
where 
EFFECTIVE_FROM <= trunc(sysdate)-1
and EFFECTIVE_TO > trunc(sysdate)-6
and deleted_flag<>'Y' 
),
t2 as 
(
select /*+ inline no_merge driving_site(balance_hstat)*/ account_uk, BALANCE_AMT_RUR, value_day
from 
DWH.balance_hstat@DW_ST_PROD
where value_day between trunc(sysdate)-5 and trunc(sysdate)-1 
and validto=to_date('31.12.5999','dd.mm.yyyy') and deleted_flag<>'Y' 
)
select 
t1.account_uk account_uk_rb,T1.BALANCE_RUR_AMT,t2.account_uk account_uk_dwh,T2.BALANCE_AMT_RUR
, t2.value_day, t1.effective_from, t1.effective_to
from 
t1 
full join t2 on T1.ACCOUNT_UK=T2.ACCOUNT_UK
and t2.value_day >= t1.EFFECTIVE_FROM
and t2.value_day < t1.EFFECTIVE_TO
where 
 (abs(T1.BALANCE_RUR_AMT)!=abs(t2.BALANCE_AMT_RUR) or t1.account_uk is null or t2.account_uk is null)
) t
where not(T.BALANCE_RUR_AMT=0 and t.account_uk_dwh is null) ) total group by value_day;