
SELECT A.week_id, week_descr, action 
FROM report_actions A 
JOIN
report_weeks W
ON A.WEEK_ID = W.WEEK_ID
WHERE A.author_id = 5
AND A.week_id IN (27, 29) ;


SELECT * 
FROM report_actions 
WHERE author_id = 5
AND week_id IN (28) ;

/*
UPDATE report_actions
SET week_id = 28
WHERE author_id = 5
AND week_id IN (27);
*/