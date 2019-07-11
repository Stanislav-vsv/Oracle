 with 
   boy as (
       select 'Бой' sistem, I1.VALUE_DAY,I1.GL2ACCOUNT_UK,I1.GL2ACCOUNTNCODE,I1.ACCOUNTCLAUSE_BAL_UK,A1.ACCOUNTCLAUSE_NUMBER, sum(I1.BALANCE_USD_AMT) sum_usd
       from
       DMFR.IFRSBALANCE_STAT i1
       left join 
       DMFR.ACCOUNTCLAUSE_SDIM a1
       on I1.ACCOUNTCLAUSE_BAL_UK = a1.uk 
       where value_day='31/05/2014'
       group by I1.VALUE_DAY,I1.GL2ACCOUNT_UK,I1.GL2ACCOUNTNCODE,I1.ACCOUNTCLAUSE_BAL_UK,A1.ACCOUNTCLAUSE_NUMBER ), 
   
   test as (
       select 'ТЕСТ' sistem, I1.VALUE_DAY,I1.GL2ACCOUNT_UK,I1.GL2ACCOUNTNCODE,I1.ACCOUNTCLAUSE_BAL_UK,A1.ACCOUNTCLAUSE_NUMBER, sum(I1.BALANCE_USD_AMT) sum_usd
       from
       DMFR.IFRSBALANCE_STAT i1
       left join 
       DMFR.ACCOUNTCLAUSE_SDIM a1
       on I1.ACCOUNTCLAUSE_BAL_UK = a1.uk 
       where value_day='31/05/2014'
       group by I1.VALUE_DAY,I1.GL2ACCOUNT_UK,I1.GL2ACCOUNTNCODE,I1.ACCOUNTCLAUSE_BAL_UK,A1.ACCOUNTCLAUSE_NUMBER),
       
   ravno as (
       select 'статьи равны' text,
                     a1.VALUE_DAY,
                     a1.GL2ACCOUNT_UK,
                     a1.GL2ACCOUNTNCODE,
                     a1.ACCOUNTCLAUSE_BAL_UK,
                     A1.ACCOUNTCLAUSE_NUMBER,
       a1.sum_usd-a2.sum_usd
        from boy a1 
       join test a2
       on 
       a1.VALUE_DAY =a2.VALUE_DAY
       and a1.GL2ACCOUNT_UK=a2.GL2ACCOUNT_UK
       and a1.ACCOUNTCLAUSE_BAL_UK =a2.ACCOUNTCLAUSE_BAL_UK), 
   
   boy_bol as (
       select 'на бою больше' text,
                         a1.VALUE_DAY,
                         a1.GL2ACCOUNT_UK,
                         a1.GL2ACCOUNTNCODE,
                         a1.ACCOUNTCLAUSE_BAL_UK,
                         A1.ACCOUNTCLAUSE_NUMBER,
                         a1.sum_usd
        from boy a1 
        where not exists 
           (   select 1 
               from test a2 
               where
               a1.VALUE_DAY =a2.VALUE_DAY
               and a1.GL2ACCOUNT_UK=a2.GL2ACCOUNT_UK
               and a1.ACCOUNTCLAUSE_BAL_UK =a2.ACCOUNTCLAUSE_BAL_UK ) ),
   
   test_bol as (
        select 'тест больше' text,
                     a1.VALUE_DAY,
                     a1.GL2ACCOUNT_UK,
                     a1.GL2ACCOUNTNCODE,
                     a1.ACCOUNTCLAUSE_BAL_UK,
                     A1.ACCOUNTCLAUSE_NUMBER,
                    a1.sum_usd
        from test a1 
        where not exists 
            ( select 1 
               from boy a2 
               where
               a1.VALUE_DAY =a2.VALUE_DAY
               and a1.GL2ACCOUNT_UK=a2.GL2ACCOUNT_UK
               and a1.ACCOUNTCLAUSE_BAL_UK =a2.ACCOUNTCLAUSE_BAL_UK ) )
               
       
       select * from ravno
       union all
       select * from boy_bol
       union all
       select * from test_bol