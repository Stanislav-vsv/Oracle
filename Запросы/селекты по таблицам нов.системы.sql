
--(64,51,52,112,63,57,97,66,67,73,79,83,85,88,96,98,101,115)

select * from DQ_CONTROL_HDIM
where UK in (64,51,52,112,63,57,97,66,67,73,79,83,85,88,96,98,101,115);

select * from DQ_SQL_HDIM
where DQ_CONTROL_UK in (64,51,52,112,63,57,97,66,67,73,79,83,85,88,96,98,101,115);

select * from DQ_DETAILJOURNAL_TRAN
where DQ_CONTROL_UK in (64,51,52,112,63,57,97,66,67,73,79,83,85,88,96,98,101,115)
order by XK desc;

select * from DQ_CONTROL_HDIM
where UK = 43;

select * from DQ_SQL_HDIM
where UK = 63;

select * from DQ_DETAILJOURNAL_TRAN
where DQ_CONTROL_UK = 63
order by XK desc;

select * from DQ_CHECK_HDIM
where OWNER like 'Волков%';
