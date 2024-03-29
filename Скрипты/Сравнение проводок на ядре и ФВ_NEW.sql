with
t11 as
(select * from dwh.transaction_htran where deleted_flag  = 'N'and validto = '31.12.5999' and value_day between '28.05.2015' and '03.06.2015'),


t1 as
(select * from t11 at1 
join dwh.GL2ACCOUNT_HDIM gl21
on  gl21.uk = at1.gl2account_debit_uk and gl21.deleted_flag  = 'N'and gl21.validto = '31.12.5999'
join  dwh.GL2ACCOUNT_HDIM gl22
on  gl22.uk = at1.gl2account_credit_uk and gl22.deleted_flag  = 'N'and gl22.validto = '31.12.5999'
      
              
where not(
           (   ( gl21.ncode  like '707%') and  ( gl22.ncode  like '708%') ) 
        or (   ( gl21.ncode  like '708%') and  ( gl22.ncode  like '707%') ) 
        or (   ( gl21.ncode  like '707%') and  ( gl22.ncode  like '303%' 
                      
        
        ) ) 
        or (   ( gl21.ncode  like '303%') and  ( gl22.ncode  like '707%') ) 
         )
),
t2 as
(
select gl2.ncode, 'D' AP , at1.* 
from t1 at1 
join dwh.GL2ACCOUNT_HDIM gl2 
on gl2.uk = at1.gl2account_debit_uk and gl2.deleted_flag  = 'N'and gl2.validto = '31.12.5999'
where gl2.ncode like '706%' or gl2.ncode like '707%' 
),
t3 as 
( 
select gl2.ncode , 'C' AP , at1.* 
from t1 at1 
join dwh.GL2ACCOUNT_HDIM gl2 
on gl2.uk = at1.gl2account_credit_uk and gl2.deleted_flag  = 'N'and gl2.validto = '31.12.5999'
where gl2.ncode like '706%' or gl2.ncode like '707%' 
),
t4 as
(
select * from t2
union all 
select * from t3
),
t5 as
(
--select count(*) from t4
select t4.value_day, t4.TRN_SOURCE_NO||t4.AP as Tk, 
sum (
case  when (ncode <  70606 and AP= 'C') then  acc_cur_amt
      when (ncode <  70606 and AP= 'D') then  -acc_cur_amt
      when (ncode >= 70606 and ncode < 70613 and AP= 'C') then  -acc_cur_amt
      when (ncode >= 70606 and ncode < 70613 and AP= 'D') then  acc_cur_amt
      when (ncode >= 70613 and ncode < 70614 and AP= 'C') then  acc_cur_amt
      when (ncode >= 70613 and ncode < 70614 and AP= 'D') then  -acc_cur_amt                  
      
      when (ncode = 70615 and AP= 'C') then  acc_cur_amt      
      when (ncode = 70615 and AP= 'D') then  -acc_cur_amt            
      when (ncode >= 70614 and ncode < 70700 and ncode <> 70615 and AP= 'C') then  -acc_cur_amt      
      when (ncode >= 70614 and ncode < 70700 and ncode <> 70615 and AP= 'D') then  acc_cur_amt                              
      
      when (ncode >= 70700 and ncode < 70706 and AP= 'C') then  acc_cur_amt
      when (ncode >= 70700 and ncode < 70706 and AP= 'D') then  -acc_cur_amt
      when (ncode >= 70706 and AP= 'C') then  -acc_cur_amt
      when (ncode >= 70706 and AP= 'D') then  acc_cur_amt
end  ) summa       
from t4 
group by value_day, t4.TRN_SOURCE_NO||t4.AP
),

t6 as 
(
select pl.value_day ,pl.TK, sum(case when ACC.CHAPTBAL_UK <> PL.CHAPTBAL_UK and PL.CHAPTBAL_UK = 4 then pl.acc_cur_amt*(-1) else pl.acc_cur_amt end) summa_pl 
  from dmfr.PLTRANSACTION_TRAN pl
  left join DMFR.TRNMARKLOG_TRAN tr
         on TR.TRN_SOURCE_NO = PL.TRN_SOURCE_NO
        and TR.ACCOUNT_PL_UK = PL.ACCOUNT_PL_UK
        and TR.VALUE_DAY = PL.VALUE_DAY
        and TR.FILED_NAME = 'ACCOUNTCLAUSE_MARK_UK'
        and TR.DIRTY_FLAG = 'N'
        and TR.NEW_VALUE = PL.ACCOUNTCLAUSE_MARK_UK
  left join DMFR.ACCOUNTCLAUSE_SDIM acc
         on ACC.UK = TR.OLD_VALUE
        and ACC.DELETED_FLAG = 'N'  
 where pl.deleted_flag  = 'N'and pl.value_day  between '28.05.2015' and '03.06.2015'
 group by pl.value_day,pl.TK  
)

--�������� �� ������� ����������� �� �����
select nvl(value_day5,value_day6) as value_day
      ,sum(summa) as summa
      ,sum(summa_pl) as summa_pl
      ,sum(delta) as delta
from
(select t5.value_day as value_day5
       ,t6.value_day as value_day6
       ,t5.TK as TK_5
       ,t6.TK as TK_6
       ,t5.summa
       ,t6.summa_pl
       ,abs(nvl(t5.summa,0)-nvl(t6.summa_pl,0)) as delta 
   from t5 t5 
full join t6 t6 on t5.value_day = t6.value_day and t5.TK=t6.TK
) 
group by nvl(value_day5,value_day6)
order by 1; 