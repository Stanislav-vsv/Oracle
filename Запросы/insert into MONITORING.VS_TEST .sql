/*
CREATE TABLE MONITORING.VS_TEST
(
  RESULT_NUM1   NUMBER,
  RESULT_CHAR1  VARCHAR2(240 BYTE),
  RESULT_DATE1  DATE
)*/

insert into MONITORING.VS_TEST 
(
  RESULT_NUM1,
  RESULT_CHAR1,
  RESULT_DATE1
)
values
(
 3,
 'Hello 3',
 sysdate
);

select RESULT_CHAR1 from MONITORING.VS_TEST where RESULT_NUM1 = 1;

update MONITORING.VS_TEST
set RESULT_CHAR1 = '‘ункции €вл€ютс€ способом упаковки функциональности, которую вы хотите использовать повторно, так что вс€кий раз, когда вы хотите получить функциональность, вы можете просто вызвать функцию, а не посто€нно переписывать весь код.'
WHERE RESULT_NUM1 IN (3); 

select * from MONITORING.VS_TEST where RESULT_CHAR1 like '%кодова€ структура%';