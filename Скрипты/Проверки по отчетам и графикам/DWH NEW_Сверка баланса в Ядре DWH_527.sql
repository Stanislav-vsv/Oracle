--DWH NEW_—верка баланса в ядре DWH.xlsx

select value_day, sum(delta) 
from (
select --+full(ost) parallel(ost,4) use_hash(ost,acc,bch,gl2)
value_day, BCH.BRANCH_ODS_NCODE
--, GL2.NCODE 
, abs(sum(case GL2.ACCOUNTKIND_UK when 1 then ost.balance_amt_rur else 0 end) + sum(case GL2.ACCOUNTKIND_UK when 2 then ost.balance_amt_rur else 0 end)) as DELTA
from 
dwh.balance_hstat ost
join dwh.account_hdim acc on ost.account_uk=acc.uk and acc.deleted_flag='N' and acc.validto='31.12.5999'
join DWH.SALESPLACE_HDIM bch on acc.salesplace_uk=bch.uk and bch.deleted_flag='N' and bch.validto='31.12.5999' and bch.BRANCH_ODS_NCODE<>10004
join DWH.GL2ACCOUNT_HDIM gl2 on ACC.GL2ACCOUNT_UK=gl2.uk and gl2.deleted_flag='N' and gl2.validto='31.12.5999' and GL2.NCODE not like '9%' --AND GL2.NCODE NOT LIKE '55555%'
where 
ost.value_day IN ('08.03.2014', '09.03.2014') 
and ost.deleted_flag='N' and ost.validto='31.12.5999'
group by value_day,BCH.BRANCH_ODS_NCODE--, GL2.NCODE
--having sum(case GL2.ACCOUNTKIND_UK when 1 then ost.balance_amt_rur else 0 end) + sum(case GL2.ACCOUNTKIND_UK when 2 then ost.balance_amt_rur else 0 end)<>0
) group by value_day;



/*
'30.12.2013', '09.01.2014', '10.01.2014', '11.01.2014', '12.01.2014'   

06.03.2014 0:00
07.03.2014 0:00


*/









