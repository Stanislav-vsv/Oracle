

with
t1 as (select '1', '2', '3' from dual ),
t2 as (select  '1', '2', '3' from t1 where 1=1),
t3 as (select '-', '--', 'ok' from dual)
select '1', '2', '3' from t2
union
select * from t3 where (select count(*) from t2) < 1

;

