
--Вот скрипт:
with
 aa as(
            select --+NO_INDEX(krmportfldb_dmout) 
            * from dmout.krmportfldb_dmout 
            where dealvalue_day  BETWEEN CASE WHEN TO_CHAR(SYSDATE, 'D') IN (5,6,7) THEN TRUNC(SYSDATE, 'IW') - 4 ELSE TRUNC(SYSDATE, 'IW') - 11 END
                                            AND
                                            CASE WHEN TO_CHAR(SYSDATE, 'D') IN (5,6,7) THEN TRUNC(SYSDATE, 'IW') + 2 ELSE TRUNC(SYSDATE, 'IW') - 5 END  ), 
            
 bb as(
              select uniquekrm_ccode,
                        dealvalue_day,
                        to_number(decode(amorttypekrm_ncode,700,ACCOUNTCLAUSE1_NUMBER,ACCLREPLACE_NUMBER)) ACCOUNT2, 
                        CURRENCY1_CCODE as currency,
                        DEALDIRECTKRM_NCODE,
                        (case when amorttypekrm_ncode in(100, 110, 140, 500,510, 540) then nvl(BALANCE_AMT,0) else nvl(DEALKRM_AMT,0) end)  CUR_BK_BAL,
                        to_number(SETOFRECORDS_CCODE) A20
              from aa
              union all 
              select uniquekrm_ccode,
                       dealvalue_day,
                       to_number(decode(amorttypekrm_ncode,700,ACCLREPLACE_NUMBER,ACCOUNTCLAUSE1_NUMBER)) ACCOUNT2,
                       decode(amorttypekrm_ncode,700,CURRENCY2_CCODE,CURRENCY1_CCODE) CURRENCY,
                       DEALDIRECTKRM_NCODE,
                       case when amorttypekrm_ncode=700 then nvl(SELLCOUNTER_AMT,0) when amorttypekrm_ncode in(100, 110,140,500,510,540) then BALANCE_AMT else DEALKRM_AMT end CUR_BK_BAL,                     
                       to_number(SETOFRECORDS_CCODE) A20
              from aa 
              where ACCLREPLACE_NUMBER like('9%') and ACCOUNTCLAUSE1_NUMBER is not null 
              order by account2),
        
 rate_usd as(
                     select distinct es.rate,                              
                              ch1.iso_ccode,
                              es.value_day 
                     from DWH.EXCHANGERATE_STAT es
                         inner join DWH.CURRENCY_HDIM ch
                    on CH.UK=ES.CURRENCY_FROM_UK
                         inner join DWH.CURRENCY_HDIM ch1
                    on CH1.UK=ES.CURRENCY_TO_UK
                     where es.value_day BETWEEN CASE WHEN TO_CHAR(SYSDATE, 'D') IN (5,6,7) THEN TRUNC(SYSDATE, 'IW') - 4 ELSE TRUNC(SYSDATE, 'IW') - 11 END
                                                  AND
                                                  CASE WHEN TO_CHAR(SYSDATE, 'D') IN (5,6,7) THEN TRUNC(SYSDATE, 'IW') + 2 ELSE TRUNC(SYSDATE, 'IW') - 5 END
                     and ch.iso_ccode='RUR'
                     and ch1.iso_ccode='USD' ),
                
 rate_eur as(
                    select distinct es.rate,                              
                              ch1.iso_ccode,
                              es.value_day 
                    from DWH.EXCHANGERATE_STAT es
                    inner join DWH.CURRENCY_HDIM ch
                    on CH.UK=ES.CURRENCY_FROM_UK
                    inner join DWH.CURRENCY_HDIM ch1
                    on CH1.UK=ES.CURRENCY_TO_UK
                    where es.value_day BETWEEN CASE WHEN TO_CHAR(SYSDATE, 'D') IN (5,6,7) THEN TRUNC(SYSDATE, 'IW') - 4 ELSE TRUNC(SYSDATE, 'IW') - 11 END
                                                 AND
                                                 CASE WHEN TO_CHAR(SYSDATE, 'D') IN (5,6,7) THEN TRUNC(SYSDATE, 'IW') + 2 ELSE TRUNC(SYSDATE, 'IW') - 5 END
                    and ch.iso_ccode='RUR'
                    and ch1.iso_ccode='EUR' ),
                    
                    
 cc as (
              select bb.account2, 
             bb.dealvalue_day,
            case when bb.currency='EUR' 
                    then (bb.cur_bk_bal*(rate_eur.rate/rate_usd.rate))  
                    when bb.currency='RUR' then (bb.cur_bk_bal*(1/rate_usd.rate)) 
                    else (bb.cur_bk_bal)  end cur_bk_bal   
             from bb,rate_usd,rate_eur
             where bb.dealvalue_day = rate_eur.value_day
                and  bb.dealvalue_day = rate_usd.value_day             
         ),
                
 dd as ( 
                select cc.account2, dealvalue_day,
                        sum(cc.cur_bk_bal) summ 
                from cc 
                group by cc.account2, cc.dealvalue_day 
                order by cc.account2 )
                
        
 
                         
 select bal_aktiv, bal_passiv, round(abs(bal_aktiv-bal_passiv),4)as delta,t1.dealvalue_day
 from    
       
 (select sum(dd.summ)bal_aktiv, dd.dealvalue_day          
 from dd
 where dd.account2 like '1%'
 group by dd.dealvalue_day )t1,  
 
( select sum(dd.summ)bal_passiv,dd.dealvalue_day            
 from dd 
 where dd.account2 like '2%' 
  or dd.account2 like '4%'
  group by dd.dealvalue_day)t2
  
  where  t1.dealvalue_day = t2.dealvalue_day; 
