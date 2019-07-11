
select * from dwh.transaction_htran
where value_day = '30.10.2013';

select * from DMFR.PLtransaction_tran
where value_day = '23.10.2013';

select * from dwh.GL2ACCOUNT_HDIM
where as_of_day = '30.10.2013';

select * from DWH.balance_hstat
where value_day = '30.10.2013';

select * from dwh.ACCOUNT_HDIM
where VALIDTO = '30.10.2013';

select * from DMFR.IFRSBALANCE_STAT
where value_day = '23.10.2013';
