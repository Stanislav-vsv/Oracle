
--today
select RESULT_CHAR1  as "DATE", sum(RESULT_CHAR3)/1000000000 as "maxVALUE/1000000000"
 from DQ_DETAILJOURNAL_TRAN_DWMON
 where (RESULT_CHAR1, REPORT_TIME) in
 (
  select RESULT_CHAR1  as "DATE", max(REPORT_TIME) as max_TIME 
  from DQ_DETAILJOURNAL_TRAN_DWMON
 where DQ_CONTROL_UK = 96 
 group by RESULT_CHAR1
 )
 and DQ_CONTROL_UK = 96
 group by RESULT_CHAR1
 order by to_date(RESULT_CHAR1);
 
 
 --history
select  RESULT_CHAR1 as "DATE", max(summ) as "maxVALUE/1000000000"
from
(select RESULT_CHAR1, sum(RESULT_CHAR3)/1000000000 as summ
from DQ_DETAILJOURNAL_TRAN_DWMON
where DQ_CONTROL_UK = 96 
and RESULT_CHAR1 is not NULL
group by RESULT_CHAR1, REPORT_TIME)
group by RESULT_CHAR1
order by to_date(RESULT_CHAR1);




