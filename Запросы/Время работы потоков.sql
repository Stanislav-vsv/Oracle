
WITH T1
AS
(SELECT WORKFLOW_NAME, ROUND(SUM(TIMES),2) AS Время_работы_в_I_запуске 
FROM ( SELECT WORKFLOW_NAME, (END_TIME  - START_TIME)*1440/60*60 AS TIMES
            FROM monitoring.mon_infa_workflows
            WHERE 
            SERVER_NAME ='INT_EX_PRE' 
            AND SUBJ_NAME = 'DMSFR'
            AND START_TIME BETWEEN TO_DATE('01.06.2015 16:24:08', 'DD.MM.YYYY HH24:MI:SS')  
                                        AND TO_DATE('02.06.2015 4:41:21', 'DD.MM.YYYY HH24:MI:SS') )
GROUP BY WORKFLOW_NAME 
),
                          
T2 AS
(SELECT WORKFLOW_NAME,ROUND(SUM(TIMES),2) AS Время_работы_в_II_запуске 
FROM ( SELECT WORKFLOW_NAME, (END_TIME  - START_TIME)*1440/60*60 AS TIMES
            FROM monitoring.mon_infa_workflows
            WHERE 
            SERVER_NAME ='INT_EX_PRE' 
            AND SUBJ_NAME = 'DMSFR'
            AND START_TIME BETWEEN TO_DATE('03.08.2015 17:47:43', 'DD.MM.YYYY HH24:MI:SS')  
                                        AND TO_DATE('04.08.2015 16:46:58', 'DD.MM.YYYY HH24:MI:SS') )
GROUP BY WORKFLOW_NAME ), 

T3 AS  
(SELECT WORKFLOW_NAME, ROUND(SUM(TIMES),2) AS Время_работы_в_III_запуске 
FROM ( SELECT WORKFLOW_NAME, (END_TIME  - START_TIME)*1440/60*60 AS TIMES
            FROM monitoring.mon_infa_workflows
            WHERE 
            SERVER_NAME ='INT_EX_PRE' 
            AND SUBJ_NAME = 'DMSFR'
            AND START_TIME BETWEEN TO_DATE('07.08.2015 18:24:35', 'DD.MM.YYYY HH24:MI:SS')  
                                        AND TO_DATE('08.08.2015 5:41:36', 'DD.MM.YYYY HH24:MI:SS'  ) )
GROUP BY WORKFLOW_NAME  
) 
                            
SELECT T1.WORKFLOW_NAME, Время_работы_в_I_запуске, Время_работы_в_II_запуске, Время_работы_в_III_запуске 
FROM T1
JOIN T2
ON T1.WORKFLOW_NAME = T2.WORKFLOW_NAME
JOIN T3
ON T1.WORKFLOW_NAME = T3.WORKFLOW_NAME
;                            
   





                            
SELECT TO_DATE('01.06.2015 16:24:00', 'DD.MM.YYYY HH24:MI:SS') DATE1, 
            TO_DATE('01.06.2015 16:23:00', 'DD.MM.YYYY HH24:MI:SS') DATE2,
            (TO_DATE('01.06.2015 16:24:00', 'DD.MM.YYYY HH24:MI:SS')  - TO_DATE('01.06.2015 16:23:00', 'DD.MM.YYYY HH24:MI:SS'))*1440/60*60     --   *1440*60 секунды        *1440/60 часы      *1440/60*60 минуты
             AS DELTA FROM DUAL;  


                

SELECT WORKFLOW_NAME, (END_TIME  - START_TIME)*1440/60*60 AS Время_работы_в_I_запуске
FROM monitoring.mon_infa_workflows
WHERE 
SERVER_NAME ='INT_EX_PRE' 
AND SUBJ_NAME = 'DMSFR'
AND START_TIME BETWEEN TO_DATE('01.06.2015 16:24:08', 'DD.MM.YYYY HH24:MI:SS')  
                            AND TO_DATE('02.06.2015 4:41:21', 'DD.MM.YYYY HH24:MI:SS') 
ORDER BY WORKFLOW_NAME                            ;


