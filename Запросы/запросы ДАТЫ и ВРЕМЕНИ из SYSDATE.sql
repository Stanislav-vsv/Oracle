
select to_char(SYSDATE, 'D') from dual; 
  
select to_char(sysdate, 'DD') from dual; 

select SYSDATE from dual; 

select 1 from dual 
where (select to_char(SYSDATE, 'D') from dual) in (1);

select to_char(SYSDATE, 'HH:MI') from dual; 

select 1 from dual 
where
(select to_char(SYSDATE, 'D') from dual) in (1)
and
(select to_char(SYSDATE, 'HH:MI') from dual) between '12:00' and '12:30';