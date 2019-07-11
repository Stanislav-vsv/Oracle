
        with prod as (

                select /*+ no_index(pl PK_PLTRANSACTION_TRAN)*/
                ac.ACCOUNTCLAUSE_NUMBER,
                sum(pl.RUR_AMT) as rur,
                sum(pl.USD_AMT) as usd , 
                count(*) as cnt 
                from
                     DMFR.PLTRANSACTION_TRAN@PUBLIC_DWSTPROD pl
                inner join 
                     DMFR.ACCOUNTCLAUSE_SDIM@PUBLIC_DWSTPROD ac
                on ac.uk = PL.ACCOUNTCLAUSE_MARK_UK
                and ac.DELETED_FLAG = 'N'
                where pl.VALUE_DAY>='21.08.2014'  
                and pl.VALUE_DAY<='27.08.2014' 
                and PL.DELETED_FLAG = 'N'
                group by ac.ACCOUNTCLAUSE_NUMBER
                order by 1 
         )
        ,
        pre as (

                select /*+ no_index(pl PK_PLTRANSACTION_TRAN)*/
                ac.ACCOUNTCLAUSE_NUMBER,
                sum(pl.RUR_AMT) as rur,
                sum(pl.USD_AMT) as usd, 
                count(*) as cnt 
                from 
                     DMFR.PLTRANSACTION_TRAN pl
                inner join 
                     DMFR.ACCOUNTCLAUSE_SDIM ac
                on ac.uk = PL.ACCOUNTCLAUSE_MARK_UK
                and ac.DELETED_FLAG = 'N'
                where pl.VALUE_DAY>='21.08.2014'  
                and pl.VALUE_DAY<='27.08.2014' 
                and PL.DELETED_FLAG = 'N'
                group by ac.ACCOUNTCLAUSE_NUMBER
                order by 1 
         )
         
         select 
         case 
            when (nvl(prod.rur,0)-nvl(pre.rur,0))<>0 or (nvl(prod.usd,0)-nvl(pre.usd,0))<>0 or (nvl(prod.cnt,0)-nvl(pre.cnt,0))<>0
                then 'Расхождение' else 'OK'
                end description,
         prod.ACCOUNTCLAUSE_NUMBER, 
         nvl(prod.rur,0) as prod_rur, 
         nvl(pre.rur,0) as pre_rur, 
         nvl(prod.rur,0)-nvl(pre.rur,0) as diff_rur,
         nvl(prod.usd,0) as prod_usd , 
         nvl(pre.usd,0) as pre_usd, 
         nvl(prod.usd,0)-nvl(pre.usd,0) as diff_usd,
         nvl(prod.cnt,0) as prod_cnt, 
         nvl(pre.cnt,0) as pre_cnt ,
         nvl(prod.cnt,0)-nvl(pre.cnt,0) as diff_cnt
         from 
            prod
         full outer join
            pre 
         on prod.ACCOUNTCLAUSE_NUMBER=pre.ACCOUNTCLAUSE_NUMBER;

