CREATE TABLE TPCH2.sales_data (
	data_dt VARCHAR(25),
	sales_classify VARCHAR(40),
	je INTEGER
);

call SYSCS_UTIL.IMPORT_DATA('TPCH2', 'sales_data', null, '/opt/data/db_init/TPCH2/02-01.csv',null, null, null, null, null, 0, '/opt/data/db_init/bad', true, null);

