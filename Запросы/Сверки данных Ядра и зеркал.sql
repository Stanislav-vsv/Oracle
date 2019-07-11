--проверка  сходимости количества записей на истонике и в зеркале

-- Сверка данных  в зеркалах и ОВ источника

--1.  Сверка данных ОВ LM и зеркал Ядра whftDealOther

--whftDealOther

with 
src as (select SRC_SUCCESS_ROWS as cnt1 from monitoring.mon_infa_sessions t
where server_name =  'INT_EX_PROD'  
and FOLDER_NAME='DWI054_LM'
and WORKFLOW_NAME='WF_WHFTDEALOTHER054_MIRROR'
and t.session_name = 's_m_WHFTDEALOTHER__WHFTDEALOTHER054_DSRC'  
and t.start_time >= TO_DATE(sysdate,'dd.mm.rrrr')),

dsrc as (select count(*) cnt2 from DWI054_LM.WHFTDEALOTHER054_DSRC@DWSTPROD),

mirr as (select count(*) cnt3 from DWS054_LM.WHFTDEALOTHER054_MIRROR@DWSTPROD
where nvl(DWSARCHIVE,0)<>'D')

select (src.cnt1-dsrc.cnt2) as delta_dsrc,
(dsrc.cnt2-mirr.cnt3) as delta_mirror,

case
when (src.cnt1-dsrc.cnt2)>0 then 'количество записей на источнике больше, чем в DSRC'

when (src.cnt1-dsrc.cnt2)<0 then 'количество записей на источнике меньше, чем в DSRC'
else 'количество записей на источнике и в DSRC   совпадает'  end  result_dsrc,

case

when (dsrc.cnt2-mirr.cnt3)>0 then 'количество записей в DSRC больше, чем в MIRROR'

when (dsrc.cnt2-mirr.cnt3)<0 then 'количество записей в DSRC меньше, чем в MIRROR'
else 'количество записей в DSRC и в MIRROR  совпадает'  end  result_mirror

 from src,dsrc,mirr
 where 1=1;
 
 
 
 -- 2. Сверка данных ОВ LM и зеркал Ядра whftDealCREDIT
 
--WHFTDEALCREDIT

with 
src as (select SRC_SUCCESS_ROWS as cnt1 from monitoring.mon_infa_sessions t
where server_name =  'INT_EX_PROD'  
and FOLDER_NAME='DWI054_LM'
and WORKFLOW_NAME='WF_WHFTDEALCREDIT054_MIRROR'
and t.session_name = 's_m_WHFTDEALCREDIT__WHFTDEALCREDIT054_DSRC'  
and t.start_time >= TO_DATE(sysdate,'dd.mm.rrrr')),
dsrc as (select count(*) cnt2 from DWI054_LM.WHFTDEALCREDIT054_DSRC@DWSTPROD),
mirr as (select count(*) cnt3 from DWS054_LM.WHFTDEALCREDIT054_MIRROR@DWSTPROD
where nvl(DWSARCHIVE,0)<>'D')
select (src.cnt1-dsrc.cnt2) as delta_dsrc,
(dsrc.cnt2-mirr.cnt3) as delta_mirror,

case
when (src.cnt1-dsrc.cnt2)>0 then 'количество записей на источнике больше, чем в DSRC'

when (src.cnt1-dsrc.cnt2)<0 then 'количество записей на источнике меньше, чем в DSRC'
else 'количество записей на источнике и в DSRC   совпадает'  end  result_dsrc,

case

when (dsrc.cnt2-mirr.cnt3)>0 then 'количество записей в DSRC больше, чем в MIRROR'

when (dsrc.cnt2-mirr.cnt3)<0 then 'количество записей в DSRC меньше, чем в MIRROR'
else 'количество записей в DSRC и в MIRROR  совпадает'  end  result_mirror


 from src,dsrc,mirr
 where 1=1;
 
 
 
 -- 3. Сверка данных ОВ LM и зеркал Ядра whftPercent
 
--whftPercent
with 
src as (select SRC_SUCCESS_ROWS as cnt1 from monitoring.mon_infa_sessions t
where server_name =  'INT_EX_PROD'  
and FOLDER_NAME='DWI054_LM'
and WORKFLOW_NAME='WF_WHFTPERCENT054_MIRROR'
and t.session_name = 's_m_WHFTPERCENT__WHFTPERCENT054_DSRC'  
and t.start_time >= TO_DATE(sysdate,'dd.mm.rrrr')),
dsrc as (select count(*) cnt2 from DWI054_LM.WHFTPERCENT054_DSRC@DWSTPROD),
mirr as (select count(*) cnt3 from DWS054_LM.WHFTPERCENT054_MIRROR@DWSTPROD
where nvl(DWSARCHIVE,0)<>'D')
select (src.cnt1-dsrc.cnt2) as delta_dsrc,
(dsrc.cnt2-mirr.cnt3) as delta_mirror,

case
when (src.cnt1-dsrc.cnt2)>0 then 'количество записей на источнике больше, чем в DSRC'

when (src.cnt1-dsrc.cnt2)<0 then 'количество записей на источнике меньше, чем в DSRC'
else 'количество записей на источнике и в DSRC   совпадает'  end  result_dsrc,

case

when (dsrc.cnt2-mirr.cnt3)>0 then 'количество записей в DSRC больше, чем в MIRROR'

when (dsrc.cnt2-mirr.cnt3)<0 then 'количество записей в DSRC меньше, чем в MIRROR'
else 'количество записей в DSRC и в MIRROR  совпадает'  end  result_mirror


 from src,dsrc,mirr
 where 1=1;
 
 
 
 -- 4. Сверка данных ОВ LM и зеркал Ядра whftProperty
 
--whftProperty
with 
src as (select SRC_SUCCESS_ROWS as cnt1 from monitoring.mon_infa_sessions t
where server_name =  'INT_EX_PROD'  
and FOLDER_NAME='DWI054_LM'
and WORKFLOW_NAME='WF_WHFTPROPERTY054_MIRROR'
and t.session_name = 's_m_WHFTPROPERTY__WHFTPROPERTY054_DSRC'  
and t.start_time >= TO_DATE(sysdate,'dd.mm.rrrr')),
dsrc as (select count(*) cnt2 from DWI054_LM.WHFTPROPERTY054_DSRC@DWSTPROD),
mirr as (select count(*) cnt3 from DWS054_LM.WHFTPROPERTY054_MIRROR@DWSTPROD
where nvl(DWSARCHIVE,0)<>'D')
select (src.cnt1-dsrc.cnt2) as delta_dsrc,
(dsrc.cnt2-mirr.cnt3) as delta_mirror,

case
when (src.cnt1-dsrc.cnt2)>0 then 'количество записей на источнике больше, чем в DSRC'

when (src.cnt1-dsrc.cnt2)<0 then 'количество записей на источнике меньше, чем в DSRC'
else 'количество записей на источнике и в DSRC   совпадает'  end  result_dsrc,

case

when (dsrc.cnt2-mirr.cnt3)>0 then 'количество записей в DSRC больше, чем в MIRROR'

when (dsrc.cnt2-mirr.cnt3)<0 then 'количество записей в DSRC меньше, чем в MIRROR'
else 'количество записей в DSRC и в MIRROR  совпадает'  end  result_mirror


 from src,dsrc,mirr
 where 1=1;
 
 
 
-- 5. Сверка данных ОВ Альфа-Фактора и зеркал Ядра f_get_gd 
 
--f_get_gd
with 
src as (select SRC_SUCCESS_ROWS as cnt1 from monitoring.mon_infa_sessions t
where server_name =  'INT_EX_PROD'  
and FOLDER_NAME='DWI057_AF'
and WORKFLOW_NAME='WF_F_GET_GD057_MIRROR'
and t.session_name = 's_m_F_GET_GD__F_GET_GD057_DSRC'   
and t.start_time >= TO_DATE(sysdate,'dd.mm.rrrr')),
dsrc as (select count(*) cnt2 from DWI057_AF.F_GET_GD057_DSRC@DWSTPROD),
mirr as (select count(*) cnt3 from DWS057_AF.F_GET_GD057_MIRROR@DWSTPROD
where nvl(DWSARCHIVE,0)<>'D')
select (src.cnt1-dsrc.cnt2) as delta_dsrc,
(dsrc.cnt2-mirr.cnt3) as delta_mirror,

case
when (src.cnt1-dsrc.cnt2)>0 then 'количество записей на источнике больше, чем в DSRC'

when (src.cnt1-dsrc.cnt2)<0 then 'количество записей на источнике меньше, чем в DSRC'
else 'количество записей на источнике и в DSRC   совпадает'  end  result_dsrc,

case

when (dsrc.cnt2-mirr.cnt3)>0 then 'количество записей в DSRC больше, чем в MIRROR'

when (dsrc.cnt2-mirr.cnt3)<0 then 'количество записей в DSRC меньше, чем в MIRROR'
else 'количество записей в DSRC и в MIRROR  совпадает'  end  result_mirror


 from src,dsrc,mirr
 where 1=1;
 
 
-- 6.Сверка данных ОВ Альфа-Фактора и зеркал Ядра f_get_finrate
 
--f_get_finrate
with 
src as (select SRC_SUCCESS_ROWS as cnt1 from monitoring.mon_infa_sessions t
where server_name =  'INT_EX_PROD'  
and FOLDER_NAME='DWI057_AF'
and WORKFLOW_NAME='WF_F_GET_FINRATE057_MIRROR'
and t.session_name = 's_m_F_GET_FINRATE__F_GET_FINRATE057_DSRC'    
and t.start_time >= TO_DATE(sysdate,'dd.mm.rrrr')),
dsrc as (select count(*) cnt2 from DWI057_AF.F_GET_FINRATE057_DSRC@DWSTPROD),
mirr as (select count(*) cnt3 from DWS057_AF.F_GET_FINRATE057_MIRROR@DWSTPROD
where nvl(DWSARCHIVE,0)<>'D')
select (src.cnt1-dsrc.cnt2) as delta_dsrc,
(dsrc.cnt2-mirr.cnt3) as delta_mirror,

case
when (src.cnt1-dsrc.cnt2)>0 then 'количество записей на источнике больше, чем в DSRC'

when (src.cnt1-dsrc.cnt2)<0 then 'количество записей на источнике меньше, чем в DSRC'
else 'количество записей на источнике и в DSRC   совпадает'  end  result_dsrc,

case

when (dsrc.cnt2-mirr.cnt3)>0 then 'количество записей в DSRC больше, чем в MIRROR'

when (dsrc.cnt2-mirr.cnt3)<0 then 'количество записей в DSRC меньше, чем в MIRROR'
else 'количество записей в DSRC и в MIRROR  совпадает'  end  result_mirror


 from src,dsrc,mirr
 where 1=1;