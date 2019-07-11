--DWH NEW_—верка проводок и остатков в ядре.xls

with t1 as 
(select value_day, account_uk, sum(acc_cur_amt) as result
from 
(select --+ full(pl) parallel(pl,4) use_hash(pl,acc,gl2)
value_day,pl.account_credit_uk as account_uk, acc_cur_amt
from 
DWH.TRANSACTION_HTRAN pl
  join dwh.account_hdim acc on pl.account_credit_uk=acc.uk and acc.deleted_flag='N' and acc.validto='31.12.5999'
  join DWH.GL2ACCOUNT_HDIM gl2 on ACC.GL2ACCOUNT_UK=gl2.uk and gl2.deleted_flag='N' and gl2.validto='31.12.5999' and GL2.NCODE like '7%'
where pl.value_day  IN ('16.12.2013') and pl.deleted_flag='N' and pl.validto='31.12.5999'
union all
select --+ full(pl) parallel(pl,4) use_hash(pl,acc,gl2)
value_day,pl.account_debit_uk as account_uk, acc_cur_amt
from 
DWH.TRANSACTION_HTRAN pl
  join dwh.account_hdim acc on pl.account_debit_uk=acc.uk and acc.deleted_flag='N' and acc.validto='31.12.5999'
  join DWH.GL2ACCOUNT_HDIM gl2 on ACC.GL2ACCOUNT_UK=gl2.uk and gl2.deleted_flag='N' and gl2.validto='31.12.5999' and GL2.NCODE like '7%'
where pl.value_day  IN ('16.12.2013') and pl.deleted_flag='N' and pl.validto='31.12.5999'
) t
group by value_day,account_uk),

t2 as (
SELECT   --+ full(ost) parallel(ost,4) use_hash(ost,acc,gl2)
value_day,ost.account_uk as account_uk, sum(credit_turn_amt_cur + debet_turn_amt_cur) as result
  FROM   dwh.balance_hstat ost
  join dwh.account_hdim acc on ost.account_uk=acc.uk and acc.deleted_flag='N' and acc.validto='31.12.5999'
  join DWH.GL2ACCOUNT_HDIM gl2 on ACC.GL2ACCOUNT_UK=gl2.uk and gl2.deleted_flag='N' and gl2.validto='31.12.5999' and GL2.NCODE like '7%'
 WHERE       ost.value_day  IN ('16.12.2013')
         AND ost.deleted_flag = 'N'
         AND ost.validto = '31.12.5999'
 group by value_day,ost.account_uk)
 
 select nvl(value_day1,value_day2) as value_day, sum(result_trans) as result_trans,sum(result_bal) as result_bal, sum(Delta) as delta
 from
 (select t1.value_day as value_day1 ,t2.value_day as value_day2,t1.account_uk,t2.account_uk, t1.result as result_trans, t2.result as result_bal, abs(nvl(t1.result,0)-nvl(t2.result,0)) as Delta
 from t1 full join t2 on t1.value_day=t2.value_day and t1.account_uk=t2.account_uk 
 ) t
 group by nvl(value_day1,value_day2);
 
 
 /*
'16.12.2013'
*/

