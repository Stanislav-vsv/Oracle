
WITH 
T1 AS
(SELECT 'COUNT'AS COUNT, COUNT(*) CNT
FROM SM_WORKORDER
WHERE SOTRUDNIKU_IMJA = 'Волков Станислав Владиславович ' 
AND TRUNC(CREATED) > '01.01.2016'),

T2 AS
(SELECT 'COUNT'AS COUNT, COUNT(*)  CNT
FROM SM_WORKORDER
WHERE SOTRUDNIKU_IMJA = 'Волков Станислав Владиславович ' 
AND TRUNC(CREATED) > '01.01.2016'
AND REAL_NOE_OKONCHANIE > SROK
AND PRICHINA_PROSROCHKI NOT IN ('Пришла просроченной', 'пришла просроченной', 'нахождение в отпуске', 'находился в отпуске', 'был в отпуске', 'отпуск', '.'))

SELECT ROUND((100 - CNT_PROSR*100/CNT_ALL),2) AS Процент_непросроченных_задач
FROM
    (SELECT T1.CNT AS CNT_ALL, T2.CNT AS CNT_PROSR
    FROM T1
    JOIN T2
    ON  T1.COUNT = T2.COUNT);
    
    
    
        
    
    

SELECT OBJECT_ID, OPISANIE, INFORMACIJA, CREATED, REAL_NOE_OKONCHANIE, SROK, RESHENIE, PRICHINA_PROSROCHKI  FROM SM_WORKORDER
WHERE SOTRUDNIKU_IMJA = 'Волков Станислав Владиславович ' 
AND TRUNC(CREATED) > '01.01.2015'
AND REAL_NOE_OKONCHANIE > SROK
AND PRICHINA_PROSROCHKI NOT IN ('Пришла просроченной', 'пришла просроченной', 'нахождение в отпуске', 'находился в отпуске', 'был в отпуске', 'отпуск', '.')  ;

    
    

SELECT* FROM SM_WORKORDER
WHERE OBJECT_ID = 'T4820926' ;

    