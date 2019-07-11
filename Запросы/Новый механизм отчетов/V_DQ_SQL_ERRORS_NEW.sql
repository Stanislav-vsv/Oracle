DROP VIEW MONITORING.V_DQ_SQL_ERRORS_NEW;

/* Formatted on 30.05.2013 16:39:55 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW MONITORING.V_DQ_SQL_ERRORS_NEW
(
   LIST_ID,
   SQL_TEXT
)
AS
   SELECT list_id,
          'select ' || REPLACE (sql_text, '#')
          || ' from dq_list, dq_main where dq_main.list_id= dq_list.list_id and dq_list.list_id = '
          || list_id
          || ' and REV_ID in (SELECT REV_ID FROM V_DQ_GET_REV_ID_NEW WHERE TO_DATE (rev_datetime, ''dd.mm.yyyy hh24:mi:ss'') = MAX_REV_DATETIME) and error_flag=1'
             AS sql_text
     --       ||' and REV_DATETIME = (select max(rev_datetime) from dq_main where rev_date >= to_number(to_char(sysdate-14,''yyyyddmm'')) and list_id = ' || list_id ||')' as  sql_text
     FROM (    SELECT rn,
                      cnt,
                      list_id,
                      SYS_CONNECT_BY_PATH (sql_text, '#') sql_text
                 FROM (SELECT rn,
                              cnt,
                              list_id,
                              sql_text,
                              LAG (rn, 1, 0)
                                 OVER (PARTITION BY list_id ORDER BY rn)
                                 ld_rn
                         FROM (SELECT TO_NUMBER (
                                         list_id
                                         || ROW_NUMBER ()
                                            OVER (PARTITION BY list_id
                                                  ORDER BY sort_num))
                                         rn --                                     to_number(list_id || sort_num) rn
                                           ,
                                      list_id,
                                      TO_NUMBER (
                                         list_id
                                         || COUNT (1) OVER (PARTITION BY list_id))
                                         cnt,
                                      CASE
                                         WHEN sort_num =
                                                 MIN (sort_num)
                                                    OVER (PARTITION BY list_id)
                                         THEN
                                               table_name
                                            || '.'
                                            || field_name
                                            || ' AS "'
                                            || column_name
                                            || '"'
                                         ELSE
                                               ','
                                            || table_name
                                            || '.'
                                            || field_name
                                            || ' AS "'
                                            || column_name
                                            || '"'
                                      END
                                         sql_text
                                 FROM dq_headings
                                WHERE rep_flag = 1))
           START WITH rn = TO_NUMBER (list_id || 1)
           CONNECT BY PRIOR rn = ld_rn)
    WHERE rn = cnt;
