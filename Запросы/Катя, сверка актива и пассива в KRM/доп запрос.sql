
with
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
                    and ch1.iso_ccode='EUR' )


select sum(dlt) dlt,  VALUE_DAY 
from           
       (
        select balance_usd_amt, 
                 balance_rur_amt, 
                 balance_cur_amt, 
                 balance_cur_amt / rate_usd.rate * rate_eur.rate as bal_my, 
                 round( balance_cur_amt / rate_usd.rate * rate_eur.rate ) as  bal_rnd,
                 round ( balance_cur_amt / rate_usd.rate * rate_eur.rate ) - balance_usd_amt as dlt, 
                 i.VALUE_DAY
        from dmfr.ifrsbalance_stat i, rate_usd,rate_eur
        where i.value_day BETWEEN CASE WHEN TO_CHAR(SYSDATE, 'D') IN (5,6,7) THEN TRUNC(SYSDATE, 'IW') - 4 ELSE TRUNC(SYSDATE, 'IW') - 11 END
                                   AND
                                   CASE WHEN TO_CHAR(SYSDATE, 'D') IN (5,6,7) THEN TRUNC(SYSDATE, 'IW') + 2 ELSE TRUNC(SYSDATE, 'IW') - 5 END
        and i.ACCOUNTCLAUSE_IFRSBAL_UK = 5216032239
        and currency_account_uk = 5205610988
        and i.SALESPLACE_BRANCH_UK not in (5203384761, 5203385578)
        and balance_usd_amt != round ( balance_cur_amt / rate_usd.rate * rate_eur.rate )
        and i.value_day = rate_eur.value_day
        and i.value_day = rate_usd.value_day 
       )
group by VALUE_DAY       
;
