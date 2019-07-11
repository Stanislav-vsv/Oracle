
            --среднее время работы 23-28 минут
            -- сверка в разрезе ПЦ, сделка, клиент, клиент УУ, продукт, модуль, статья сметы, ККУ

            with 
            t_pc as 
                    (
                    select /*+ full(pl) use_hash(pl1)*/  
                    'Расходится ПЦ' as description ,
                    'PROFITCENTER_MARK_UK' as check_field,
                    PL.VALUE_DAY,
                    PL.PROFITCENTER_MARK_UK as pre,
                    PL1.PROFITCENTER_MARK_UK as prod,
                    count(*),
                    sum(PL.USD_AMT)
                    from     
                     DMFR.PLTRANSACTION_TRAN@DW_ST_PRE pl
                    join
                     DMFR.PLTRANSACTION_TRAN@DW_ST_PROD pl1
                    on pl1.tk = PL.TK and PL.VALUE_DAY = PL1.VALUE_DAY
                    where       pl.VALUE_DAY >= '25.09.2014'
                    and pl.VALUE_DAY <= '01.10.2014'
                    and PL.DELETED_FLAG = 'N'
                    and PL1.PROFITCENTER_MARK_UK <> PL.PROFITCENTER_MARK_UK
                    and not exists
                                     (select /*+ hash_sj*/  *
                                       from   
                                               DMFRUA.PLTRNMANUALMARK_TRAN@DW_ST_PROD plt
                                       where   PLT.VALUE_DAY between '25.09.2014' and '01.10.2014'
                                       and PLT.FINAL_MARK_FLAG = 'Y'
                                       and PLT.PLTRANSACTION_TK = PL.TK
                                       and PLT.VALUE_DAY = PL.VALUE_DAY)
                    group by PL.VALUE_DAY,PL.PROFITCENTER_MARK_UK,PL1.PROFITCENTER_MARK_UK                         
                    order by   1),

            t_deal as
                    (
                    select/*+ full(pl) use_hash(pl1)*/ 
                    'Расходится Сделка' as description ,
                    'DEAL_MARK_UK' as check_field,
                    PL.VALUE_DAY,
                    PL.DEAL_MARK_UK as pre,
                    PL1.DEAL_MARK_UK as prod,
                    count(*),
                    sum(PL.USD_AMT)
                   from 
                        DMFR.PLTRANSACTION_TRAN@DW_ST_PRE pl
                   join
                        DMFR.PLTRANSACTION_TRAN@DW_ST_PROD pl1  
                   on pl1.tk =PL.TK  
                   and PL.VALUE_DAY =PL1.VALUE_DAY
                   left join 
                        DMFR.TRNMARKLOG_TRAN@DW_ST_PRE lg 
                   on PL.TRN_SOURCE_NO=LG.TRN_SOURCE_NO 
                   and PL.VALUE_DAY =lg.VALUE_DAY
                   left join
                         DMFR.TRNMARKLOG_TRAN@DW_ST_PROD lg1 
                   on PL1.TRN_SOURCE_NO=LG1.TRN_SOURCE_NO 
                   and PL1.VALUE_DAY =lg1.VALUE_DAY
                   where pl.VALUE_DAY>='02.10.2014' 
                   and pl.VALUE_DAY<='08.10.2014'
                   and PL.DELETED_FLAG = 'N'
                   and PL1.DEAL_MARK_UK  <>PL.DEAL_MARK_UK 
                   and LG.MAINTRNMARK_XK not in (11458,11501) 
                   and LG.MAINTRNMARK_XK not in (11458,11501)-- исключаем алгоритм маркировки 
                   and LG.FILED_NAME='DEAL_MARK_UK ' 
                   and LG1.FILED_NAME='DEAL_MARK_UK '
                   and not exists 
                               (select /*+ hash_sj*/  * 
                                from 
                                        DMFRUA.PLTRNMANUALMARK_TRAN@DW_ST_PROD plt
                                where PLT.VALUE_DAY between '02.10.2014' and '08.10.2014'
                                and PLT.FINAL_MARK_FLAG ='Y'
                                and PLT.PLTRANSACTION_TK = PL.TK
                                and PLT.VALUE_DAY =PL.VALUE_DAY
                                )
                   group by PL.VALUE_DAY,PL.DEAL_MARK_UK,PL1.DEAL_MARK_UK    
                   order by 1 

                   ),

            t_est as
                    (
                     select/*+ full(pl) use_hash(pl1)*/ 
                    'Расходится Статья Сметы' as description ,
                    'ESTIMATEITEM_UK' as check_field,
                    PL.VALUE_DAY,
                    PL.ESTIMATEITEM_UK as pre,
                    PL1.ESTIMATEITEM_UK as prod,
                    count(*),
                    sum(PL.USD_AMT) 
                    from 
                         DMFR.PLTRANSACTION_TRAN@DW_ST_PRE pl
                    join
                         DMFR.PLTRANSACTION_TRAN@DW_ST_PROD pl1
                    on pl1.tk =PL.TK
                    and PL.VALUE_DAY =PL1.VALUE_DAY
                    where pl.VALUE_DAY>='02.10.2014' and pl.VALUE_DAY<='08.10.2014'
                    and PL.DELETED_FLAG = 'N'
                    and PL1.ESTIMATEITEM_UK <>PL.ESTIMATEITEM_UK
                    and not exists 
                                   (select * 
                                   from 
                                        DMFRUA.PLTRNMANUALMARK_TRAN@DW_ST_PROD plt
                                    where PLT.VALUE_DAY between '02.10.2014' and '08.10.2014'
                                    and PLT.FINAL_MARK_FLAG ='Y'
                                    and PLT.PLTRANSACTION_TK = PL.TK
                                    and PLT.VALUE_DAY =PL.VALUE_DAY
                                  )
                     group by PL.VALUE_DAY,PL.ESTIMATEITEM_UK,PL1.ESTIMATEITEM_UK  
                     order by 1 
                    ),

            t_com as 
                    (
                    select /*+ full(pl) use_hash(pl1)*/  
                    'Расходится ККУ' as description ,
                    'COMMISSIONSRVC_MARK_UK' as check_field,
                    PL.VALUE_DAY,
                    PL.COMMISSIONSRVC_MARK_UK as pre,
                    PL1.COMMISSIONSRVC_MARK_UK as prod,
                    count(*),
                    sum(PL.USD_AMT) 
                   from 
                        DMFR.PLTRANSACTION_TRAN@DW_ST_PRE pl
                   join 
                        DMFR.PLTRANSACTION_TRAN@DW_ST_PROD pl1
                   on pl1.tk =PL.TK
                   and PL.VALUE_DAY =PL1.VALUE_DAY
                   where pl.VALUE_DAY>='02.10.2014' and pl.VALUE_DAY<='08.10.2014'
                   and PL.DELETED_FLAG = 'N'
                   and PL1.COMMISSIONSRVC_MARK_UK <>PL.COMMISSIONSRVC_MARK_UK
                   and not exists 
                               (select /*+ hash_sj*/ * 
                               from 
                                    DMFRUA.PLTRNMANUALMARK_TRAN@DW_ST_PROD plt
                                where PLT.VALUE_DAY between '02.10.2014' and '08.10.2014'
                                and PLT.FINAL_MARK_FLAG ='Y'
                                and PLT.PLTRANSACTION_TK = PL.TK
                                and PLT.VALUE_DAY =PL.VALUE_DAY
                               )
                     group by PL.VALUE_DAY,PL.COMMISSIONSRVC_MARK_UK,PL1.COMMISSIONSRVC_MARK_UK    
                     order by 1 
                    ),

            t_cl as
                    (
                    select /*+ full(pl) use_hash(pl1)*/  
                    'Расходится Клиент' as description ,
                    'CLIENT_MARK_UK' as check_field,
                    PL.VALUE_DAY,
                    PL.CLIENT_MARK_UK as pre,
                    PL1.CLIENT_MARK_UK as prod,
                    count(*),
                    sum(PL.USD_AMT) 
                   from 
                        DMFR.PLTRANSACTION_TRAN@DW_ST_PRE pl
                   join 
                        DMFR.PLTRANSACTION_TRAN@DW_ST_PROD pl1
                   on pl1.tk =PL.TK
                   and PL.VALUE_DAY =PL1.VALUE_DAY
                   where pl.VALUE_DAY>='02.10.2014' and pl.VALUE_DAY<='08.10.2014'
                   and PL.DELETED_FLAG = 'N'
                   and PL1.CLIENT_MARK_UK <>PL.CLIENT_MARK_UK
                   and not exists 
                               (select /*+ hash_sj*/  * 
                                from 
                                    DMFRUA.PLTRNMANUALMARK_TRAN@DW_ST_PROD plt
                                where PLT.VALUE_DAY between '02.10.2014' and '08.10.2014'
                                and PLT.FINAL_MARK_FLAG ='Y'
                                and PLT.PLTRANSACTION_TK = PL.TK
                                and PLT.VALUE_DAY =PL.VALUE_DAY
                               )
                     group by PL.VALUE_DAY,PL.CLIENT_MARK_UK,PL1.CLIENT_MARK_UK    
                     order by 1 
                    ),


            t_claa as
                    (
                    select /*+ full(pl) use_hash(pl1)*/ 
                    'Расходится Клиент AA' as description ,
                    'CLIENT_AAMARK_UK' as check_field,
                    PL.VALUE_DAY,
                    PL.CLIENT_AAMARK_UK as pre,
                    PL1.CLIENT_AAMARK_UK as prod,
                    count(*),
                    sum(PL.USD_AMT) 
                   from 
                        DMFR.PLTRANSACTION_TRAN@DW_ST_PRE pl
                   join 
                        DMFR.PLTRANSACTION_TRAN@DW_ST_PROD pl1
                   on pl1.tk =PL.TK
                   and PL.VALUE_DAY =PL1.VALUE_DAY
                   where pl.VALUE_DAY>='02.10.2014' and pl.VALUE_DAY<='08.10.2014'
                   and PL.DELETED_FLAG = 'N'
                   and PL1.CLIENT_AAMARK_UK <>PL.CLIENT_AAMARK_UK
                   and not exists 
                                   (select * 
                                   from 
                                        DMFRUA.PLTRNMANUALMARK_TRAN@DW_ST_PROD plt
                                    where PLT.VALUE_DAY between '02.10.2014' and '08.10.2014'
                                    and PLT.FINAL_MARK_FLAG ='Y'
                                    and PLT.PLTRANSACTION_TK = PL.TK
                                    and PLT.VALUE_DAY =PL.VALUE_DAY
                                   )
                     group by PL.VALUE_DAY,PL.CLIENT_AAMARK_UK,PL1.CLIENT_AAMARK_UK    
                     order by 1 
                    ),

            t_product as
                    (
                    select /*+ full(pl) use_hash(pl1)*/  
                    'Расходится Продукт' as description ,
                    'PRODUCT_MARK_UK' as check_field,
                    PL.VALUE_DAY,
                    PL.PRODUCT_MARK_UK as pre,
                    PL1.PRODUCT_MARK_UK as prod,
                    count(*),
                    sum(PL.USD_AMT) 
                   from 
                        DMFR.PLTRANSACTION_TRAN@DW_ST_PRE pl
                   join 
                        DMFR.PLTRANSACTION_TRAN@DW_ST_PROD pl1   
                   on pl1.tk =PL.TK  
                   and PL.VALUE_DAY =PL1.VALUE_DAY
                   left join 
                        DMFR.TRNMARKLOG_TRAN@DW_ST_PRE lg 
                        
                   on PL.TRN_SOURCE_NO=LG.TRN_SOURCE_NO 
                   and PL.VALUE_DAY =lg.VALUE_DAY
                   left join 
                        DMFR.TRNMARKLOG_TRAN@DW_ST_PROD lg1 
                        
                   on PL1.TRN_SOURCE_NO=LG1.TRN_SOURCE_NO 
                   and PL1.VALUE_DAY =lg1.VALUE_DAY
                   where pl.VALUE_DAY>='02.10.2014' and pl.VALUE_DAY<='08.10.2014'
                   and PL.DELETED_FLAG = 'N'
                   and PL1.PRODUCT_MARK_UK <>PL.PRODUCT_MARK_UK
                   and LG.MAINTRNMARK_XK not in (11458,11501) and LG.MAINTRNMARK_XK not in (11458,11501)-- исключаем алгоритм маркировки 
                   and LG.FILED_NAME='PRODUCT_MARK_UK' and LG1.FILED_NAME='PRODUCT_MARK_UK'
                   and not exists 
                               (select /*+ hash_sj*/ *
                                from 
                                     DMFRUA.PLTRNMANUALMARK_TRAN@DW_ST_PROD plt
                                where PLT.VALUE_DAY between '02.10.2014' and '08.10.2014'
                                and PLT.FINAL_MARK_FLAG ='Y'
                                and PLT.PLTRANSACTION_TK = PL.TK
                                and PLT.VALUE_DAY =PL.VALUE_DAY
                               )
                     group by PL.VALUE_DAY,PL.PRODUCT_MARK_UK,PL1.PRODUCT_MARK_UK    
                     order by 1 
                    ),


            t_modul as
                    (
                    select /*+ full(pl) use_hash(pl1)*/  
                    'Расходится Модуль' as description ,
                    'MODULE_UK' as check_field,
                    PL.VALUE_DAY,
                    PL.MODULE_UK as pre,
                    PL1.MODULE_UK as prod,
                    count(*),
                    sum(PL.USD_AMT) 
                   from
                         DMFR.PLTRANSACTION_TRAN@DW_ST_PRE pl
                   join 
                        DMFR.PLTRANSACTION_TRAN@DW_ST_PROD pl1
                   on pl1.tk =PL.TK
                   and PL.VALUE_DAY =PL1.VALUE_DAY
                   where pl.VALUE_DAY>='02.10.2014' and pl.VALUE_DAY<='08.10.2014'
                   and PL.DELETED_FLAG = 'N'
                   and PL1.MODULE_UK <>PL.MODULE_UK
                   and not exists 
                               (select /*+ hash_sj*/  * 
                                from 
                                    DMFRUA.PLTRNMANUALMARK_TRAN@DW_ST_PROD plt
                                where PLT.VALUE_DAY between '02.10.2014' and '08.10.2014'
                                and PLT.FINAL_MARK_FLAG ='Y'
                                and PLT.PLTRANSACTION_TK = PL.TK
                                and PLT.VALUE_DAY =PL.VALUE_DAY
                               )
                     group by PL.VALUE_DAY,PL.MODULE_UK,PL1.MODULE_UK    
                     order by 1 
                    )


            select * from t_pc
            union all
            select * from t_deal
            union all
            select * from t_est
            union all
            select * from t_com
            union all
            select * from t_cl
            union all
            select * from t_claa
            union all
            select * from t_product
            union all
            select * from t_modul
            ;
