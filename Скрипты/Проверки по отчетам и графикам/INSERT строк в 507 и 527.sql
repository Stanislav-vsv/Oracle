
--Сначала смотрим, что записано в таблице dq_main за нужную нам дату:

select to_date(f_str1), rev_id, f_num1
from dq_main 
where list_id=527 and to_date(f_str1) IN ('24.11.2013', '01.12.2013')
ORDER by 1,2 desc ; 


/*Потом всталяем строку с нужной датой и нулевым значением для нашей проверки (ID генерится автоматически и т.к. он
самый новый, то запрос для графика выбирает эту строку с нулем):*/

insert into dq_main 
(f_str1, f_num1, list_id)
values 
('16.12.2013',0,527);


insert into dq_main 
(f_str1, f_num1, list_id)
values 
('20.10.2013','986,01',527);


/*
'24.11.2013', '01.12.2013'
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select to_date(f_str2), rev_id, f_num3
from dq_main 
where list_id=507 and to_date(f_str2) IN ('17.11.2013', ' 22.11.2013', ' 23.11.2013', ' 24.11.2013')   -- or to_date(f_str2)='22.05.2013' or to_date(f_str2)='23.05.2013'
ORDER by 1,2 desc ; 


insert into dq_main 
(f_str2, f_num3, list_id)
values 
('24.11.2013',0,507);


insert into dq_main 
(f_str2, f_num3, list_id)
values 
('16.12.2013','102728,7',507);


SELECT * FROM DQ_MAIN WHERE LIST_ID = 507
AND TO_DATE(F_STR2) = '19.05.2013';


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select * from dq_main
where list_id=501
order by REV_ID desc;

select to_date(f_str2), rev_id, f_num1, f_num2, f_num3
from dq_main 
where list_id=501 and to_date(f_str2) IN ('01.01.14', '06.01.14', '07.01.14')
ORDER by 1,2 desc ; 

insert into dq_main 
(f_str2, f_num1, f_num2, f_num3, list_id)
values 
('07.01.2014', '128824896,35','128824896,35', 0, 501);


select * from dq_main
where rev_id=383781750;

delete from dq_main
where rev_id=383781750;




