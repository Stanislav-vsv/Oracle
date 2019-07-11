

SELECT COUNT(*)*100/30 FROM    -- 30 это колличество дней за которые смотрим ошибки
    (
    SELECT error_flag, report_time, LEAD(error_flag, 1) OVER(ORDER BY report_time) AS error_flag_1, LEAD(report_time, 1) OVER(ORDER BY report_time) AS report_time_1
    FROM 
        (
        SELECT SUM(error_flag) AS error_flag, TRUNC(report_time) AS report_time
        FROM
            (
            SELECT CASE WHEN error_flag = 'Y' THEN 1 ELSE 0 END AS error_flag, report_time FROM dqmon.dq_detailjournal_tran
            WHERE dq_control_uk = 63  -- 96  -- 246  --63
            AND trunc(report_time) > trunc(SYSDATE-30)
            GROUP BY report_time, error_flag 
            )
        GROUP BY report_time
        )
    ORDER BY report_time DESC 
    )
WHERE error_flag = 1
AND error_flag_1 = 1
;




SELECT SUM(proc)/COUNT(*)
FROM
(
    SELECT dq_control_uk, COUNT(*)*100/300 proc
    FROM
        (
        SELECT dq_control_uk, error_flag, report_time, LEAD(error_flag, 1) OVER(ORDER BY dq_control_uk) AS error_flag_1, LEAD(report_time, 1) OVER(ORDER BY dq_control_uk) AS report_time_1
        FROM 
            (
            SELECT dq_control_uk, SUM(error_flag) AS error_flag, TRUNC(report_time) AS report_time
            FROM
                (            
                SELECT dq_control_uk, CASE WHEN error_flag = 'Y' THEN 1 ELSE 0 END AS error_flag, report_time 
                FROM 
                    (
                    SELECT * FROM dqmon.dq_detailjournal_tran
                    WHERE dq_control_uk IN 
                    (98, 88, 51, 52, 66, 57, 112, 67, 73, 79, 83, 85, 179, 183, 184, 185, 186, 187, 188,
                     189, 190, 191, 193, 194, 195, 196, 197, 202, 203, 204, 63, 96, 64, 97, 246, 258, 263,
                     269, 272, 273, 282, 570, 571, 573, 577, 580, 115, 251)
                    AND trunc(report_time) > trunc(SYSDATE-300)
                    ) -- +
                GROUP BY dq_control_uk, report_time, error_flag                              
                ) -- +
            GROUP BY dq_control_uk, report_time 
            )  --  +
         ORDER BY dq_control_uk, report_time 
        ) -- +
    WHERE error_flag = 1
    AND error_flag_1 = 1
    GROUP BY dq_control_uk
)      ;


-- Итоговый запрос для получения процента корректного срабатывания проверок
SELECT ROUND((100 - SUM(proc)/COUNT(*)), 2) procent
FROM
(
    SELECT dq_control_uk, COUNT(*)*100/300 proc
    FROM
        (
        SELECT dq_control_uk, error_flag, report_time, LEAD(error_flag, 1) OVER(ORDER BY dq_control_uk) AS error_flag_1, LEAD(report_time, 1) OVER(ORDER BY dq_control_uk) AS report_time_1
        FROM 
            (
            SELECT dq_control_uk, SUM(error_flag) AS error_flag, TRUNC(report_time) AS report_time
            FROM
                (            
                SELECT dq_control_uk, CASE WHEN error_flag = 'Y' THEN 1 ELSE 0 END AS error_flag, report_time 
                FROM 
                    (
                    SELECT * FROM dqmon.dq_detailjournal_tran
                    WHERE dq_control_uk IN 
                    (98, 88, 51, 52, 66, 57, 112, 67, 73, 79, 83, 85, 179, 183, 184, 185, 186, 187, 188,
                     189, 190, 191, 193, 194, 195, 196, 197, 202, 203, 204, 63, 64, 97, 258, 263,
                     269, 272, 273, 282, 570, 571, 573, 577, 580, 115, 251)
                    AND trunc(report_time) > trunc(SYSDATE-300)
                    ) -- +
                GROUP BY dq_control_uk, report_time, error_flag                              
                ) -- +
            GROUP BY dq_control_uk, report_time 
            )  --  +
         ORDER BY dq_control_uk, report_time 
        ) -- +
    WHERE error_flag = 1
    AND error_flag_1 = 1
    GROUP BY dq_control_uk -- +
)      ;
