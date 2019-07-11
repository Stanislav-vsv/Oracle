select /*+ ordered*/
tf.accountclause_ccode_mark as ACCOUNTCLAUSE_MARK_CCODE,
tf.adjustment_ncode as ADJUSTMENT_MARK_NCODE,
null as CLIENT_AA_MARK_PIN,
null as CLIENT_MARK_PIN,
null as COMMISSIONSRVC_MARK_CCODE,
null as PRODUCT_MARK_NCODE,
null as PROFITCENTER_MARK_RUS_CCODE,
s.TK,
s.VALUE_DAY,
s.trn_id,
s.trn_source_no,
s.trn_content

from dmfr.pltransaction_tran s 

   join DMFR.ACCOUNTCLAUSE_SDIM cl on s.accountclause_mark_uk=cl.UK 
      and lnnvl(cl.deleted_flag='Y')
      and s.value_day between cl.START_DATE and cl.END_DATE
   join DMFRua.Accountclausetf_Mbrg tf on cl.ACCOUNTCLAUSE_NUMBER=tf.accountclause_ccode 
      and lnnvl(tf.deleted_flag='Y')
 join dmfr.deal_vhist dv on dv.deal_uk=s.deal_mark_uk 
      and s.deal_mark_uk > 0
      and lnnvl(dv.deleted_flag='Y')
      and s.value_day between dv.effective_from and dv.effective_to
 join dmfr.deal_vhist dv1 on dv1.deal_ref=dv.deal_ref
      and s.deal_mark_uk > 0
      and lnnvl(dv1.deleted_flag='Y')
      and s.value_day between dv1.effective_from and dv1.effective_to
 join dmfr.deal2acct_vhist t1 on t1.deal_uk=dv1.deal_uk -- побуем через ФВ - связка сделка-счет
 join DMFR.ACCOUNT_SDIM act on act.uk=t1.account_uk
 join dws001_ods.accr_acct001_mirror acc on trim(acc.sbal_kod)||trim(acc.ss_kod)=act.account_number
              and lnnvl(acc.dwsarchive='D')
              and
                 (    s.value_day>=nvl(trunc(acc.begin_date,'mm'),trunc(acc.create_ts,'mm'))
                  and s.value_day<=last_day(acc.end_date)
                 )
              and regexp_like(trim(acc.sbal_kod), '[0-9][0-9][0-9][0-9][0-9]')
where 1=1
and s.value_day between date'2013-07-01' and date'2013-07-31'
and s.deal_mark_uk > 0

group by
tf.accountclause_ccode_mark,
tf.adjustment_ncode,
s.tk,
s.value_day,
s.trn_id,
s.trn_source_no,
s.trn_content

union

-- 4-я часть, deal_mark_uk < 1
select /*+ ordered*/
tf.accountclause_ccode_mark as ACCOUNTCLAUSE_MARK_CCODE,
tf.adjustment_ncode as ADJUSTMENT_MARK_NCODE,
null as CLIENT_AA_MARK_PIN,
null as CLIENT_MARK_PIN,
null as COMMISSIONSRVC_MARK_CCODE,
null as PRODUCT_MARK_NCODE,
null as PROFITCENTER_MARK_RUS_CCODE,
s.TK,
s.VALUE_DAY,
s.trn_id,
s.trn_source_no,
s.trn_content

from dmfr.pltransaction_tran s 

   join DMFR.ACCOUNTCLAUSE_SDIM cl on s.accountclause_mark_uk=cl.UK 
      and lnnvl(cl.deleted_flag='Y')
      and s.value_day between cl.START_DATE and cl.END_DATE
   join DMFRua.Accountclausetf_Mbrg tf on cl.ACCOUNTCLAUSE_NUMBER=tf.accountclause_ccode 
      and lnnvl(tf.deleted_flag='Y')
   join dws001_ods.accr_acct001_mirror acc on INSTR(s.TRN_CONTENT, trim(acc.lcn), 1 ) > 0 
      and s.deal_mark_uk < 1
      and lnnvl(acc.dwsarchive='D')
      and
        (    s.value_day>=nvl(trunc(acc.begin_date,'mm'),trunc(acc.create_ts,'mm'))
         and s.value_day<=last_day(acc.end_date)
        )
      and regexp_like(trim(acc.sbal_kod), '[0-9][0-9][0-9][0-9][0-9]')
where 1=1
and s.value_day between date'2013-07-01' and date'2013-07-31'
and s.deal_mark_uk < 1

group by
tf.accountclause_ccode_mark,
tf.adjustment_ncode,
s.tk,
s.value_day,
s.trn_id,
s.trn_source_no,
s.trn_content