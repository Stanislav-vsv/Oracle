 with boy as (
   select 'Бой' sistem, 
   I1.VALUE_DAY,
   I1.GL2ACCOUNT_UK,
   I1.GL2ACCOUNTNCODE,
   I1.ACCOUNTCLAUSE_BAL_UK,
   A1.ACCOUNTCLAUSE_NUMBER,
   sum(I1.BALANCE_USD_AMT) sum_usd,
   count(*) count_b
   from
   DMFR.IFRSBALANCE_STAT@prod i1
   left join 
   DMFR.ACCOUNTCLAUSE_SDIM a1
   on I1.ACCOUNTCLAUSE_BAL_UK = a1.uk 
   where value_day='31/05/2014'
   group by I1.VALUE_DAY,I1.GL2ACCOUNT_UK,I1.GL2ACCOUNTNCODE,I1.ACCOUNTCLAUSE_BAL_UK,A1.ACCOUNTCLAUSE_NUMBER
   ), test as
   (select 'ТЕСТ' sistem,
    I1.VALUE_DAY,
    I1.GL2ACCOUNT_UK,
    I1.GL2ACCOUNTNCODE,
    I1.ACCOUNTCLAUSE_BAL_UK,
    A1.ACCOUNTCLAUSE_NUMBER,
    sum(I1.BALANCE_USD_AMT) sum_usd,
    count(*) count_T
   from
   DMFR.IFRSBALANCE_STAT i1
   left join 
   DMFR.ACCOUNTCLAUSE_SDIM a1
   on I1.ACCOUNTCLAUSE_BAL_UK = a1.uk 
   where value_day='31/05/2014'
   group by I1.VALUE_DAY,I1.GL2ACCOUNT_UK,I1.GL2ACCOUNTNCODE,I1.ACCOUNTCLAUSE_BAL_UK,A1.ACCOUNTCLAUSE_NUMBER),
   ravno as(
   select 'статьи равны' text,
   a1.VALUE_DAY,
   a1.GL2ACCOUNT_UK GL2ACCOUNT_UK_B,
   a1.GL2ACCOUNTNCODE GL2ACCOUNTNCODE_B,
   a1.ACCOUNTCLAUSE_BAL_UK ACCOUNTCLAUSE_BAL_UK_B,
   A1.ACCOUNTCLAUSE_NUMBER ACCOUNTCLAUSE_NUMBER_B,
   a2.GL2ACCOUNT_UK GL2ACCOUNT_UK_T,
   a2.GL2ACCOUNTNCODE GL2ACCOUNTNCODE_T,
   a2.ACCOUNTCLAUSE_BAL_UK ACCOUNTCLAUSE_BAL_UK_T,
   A2.ACCOUNTCLAUSE_NUMBER ACCOUNTCLAUSE_NUMBER_T,
   count_B-count_T az_count,
   a1.sum_usd-a2.sum_usd  dif
    from boy a1 
   join test a2
   on 
   a1.VALUE_DAY =a2.VALUE_DAY
   and a1.GL2ACCOUNT_UK=a2.GL2ACCOUNT_UK
   and a1.ACCOUNTCLAUSE_BAL_UK =a2.ACCOUNTCLAUSE_BAL_UK
   )
   , boy_bol as
   (
   select 'на бою больше' text,
   a1.VALUE_DAY,
   a1.GL2ACCOUNT_UK GL2ACCOUNT_UK_B,
   a1.GL2ACCOUNTNCODE GL2ACCOUNTNCODE_B,
   a1.ACCOUNTCLAUSE_BAL_UK ACCOUNTCLAUSE_BAL_UK_B,
   A1.ACCOUNTCLAUSE_NUMBER ACCOUNTCLAUSE_NUMBER_B,
   0 GL2ACCOUNT_UK_T,
   0 GL2ACCOUNTNCODE_T,
   0 ACCOUNTCLAUSE_BAL_UK_T,
   '' ACCOUNTCLAUSE_NUMBER_T,
   count_b raz_count,
   a1.sum_usd  dif
    from boy a1 
    where not exists 
   (select 1 from test a2 where
   a1.VALUE_DAY =a2.VALUE_DAY
   and a1.GL2ACCOUNT_UK=a2.GL2ACCOUNT_UK
   and a1.ACCOUNTCLAUSE_BAL_UK =a2.ACCOUNTCLAUSE_BAL_UK)
   )
   ,
    test_bol as
   (
   select 'тест больше' text,
   a1.VALUE_DAY,
   0 GL2ACCOUNT_UK_B,
   0 GL2ACCOUNTNCODE_B,
   0 ACCOUNTCLAUSE_BAL_UK_B,
   '' ACCOUNTCLAUSE_NUMBER_B,
   a1.GL2ACCOUNT_UK GL2ACCOUNT_UK_T,
   a1.GL2ACCOUNTNCODE GL2ACCOUNTNCODE_T,
   a1.ACCOUNTCLAUSE_BAL_UK ACCOUNTCLAUSE_BAL_UK_T,
   A1.ACCOUNTCLAUSE_NUMBER ACCOUNTCLAUSE_NUMBER_T,
   count_T raz_count,
   a1.sum_usd  dif  
     from test a1 
    where not exists 
   (select 1 from boy a2 where
   a1.VALUE_DAY =a2.VALUE_DAY
   and a1.GL2ACCOUNT_UK=a2.GL2ACCOUNT_UK
   and a1.ACCOUNTCLAUSE_BAL_UK =a2.ACCOUNTCLAUSE_BAL_UK)
   )
   select * from ravno   
   union all
   select * from boy_bol   
   union all
   select * from test_bol