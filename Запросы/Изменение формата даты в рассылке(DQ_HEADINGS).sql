
select * from DQ_HEADINGS_NEWDQ where FIELD_NAME like ('%REPORT_TIME, %DD:MM:YYYY HH24:MI:SS%)%'); 
select * from DQ_HEADINGS_NEWDQ where FIELD_NAME like ('%VALUE_DATE, %DD:MM:YYYY HH24:MI:SS%)%');
select * from DQ_HEADINGS_NEWDQ where FIELD_NAME like ('%RESULT_DATE1, %DD:MM:YYYY%)%');  -- RESULT_DATE1, 'DD:MM:YYYY') 

select * from DQ_HEADINGS_NEWDQ where FIELD_NAME like ('%DD:MM:YYYY%');
select * from DQ_HEADINGS_NEWDQ where FIELD_NAME like ('%DD.MM.YYYY%');  


update MONITORING.DQ_HEADINGS_NEWDQ
set FIELD_NAME = 'RESULT_DATE1, ''DD.MM.YYYY'')'  -- 'REPORT_TIME, ''DD:MM:YYYY HH24:MI:SS'')'
where FIELD_NAME like ('%RESULT_DATE1, %DD:MM:YYYY%)%'); 


select * from DQ_HEADINGS_NEWDQ where FIELD_NAME like ('%REPORT_TIME, %DD.MM.YYYY HH24:MI:SS%)%'); 
select * from DQ_HEADINGS_NEWDQ where FIELD_NAME like ('%VALUE_DATE, %DD.MM.YYYY HH24:MI:SS%)%');
select * from DQ_HEADINGS_NEWDQ where FIELD_NAME like ('%RESULT_DATE1, %DD.MM.YYYY%)%');  


select * from DQ_HEADINGS_NEWDQ where LIST_ID = 1705;


