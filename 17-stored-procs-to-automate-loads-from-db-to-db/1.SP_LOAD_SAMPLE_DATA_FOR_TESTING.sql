CREATE OR REPLACE PROCEDURE TEST_EMP.PROCS.SP_LOAD_SAMPLE_DATA("SRCDB" VARCHAR, "SRCSCHEMA" VARCHAR, "SRCTBL" VARCHAR,"TGTDB" VARCHAR, "TGTSCHEMA" VARCHAR, "TGTTBL" VARCHAR, "DATA_VOLUME" INTEGER) 
RETURNS VARCHAR 
LANGUAGE SQL 
EXECUTE AS CALLER 
AS

DECLARE 
-- DATA_VOLUME is the % of records to be copied
cre_tbl_qry VARCHAR;
insrt_qry VARCHAR;

BEGIN

-- Create Target Table if it doesn't exists
cre_tbl_qry := 'CREATE TABLE IF NOT EXISTS '||:TGTDB||'.'||:TGTSCHEMA||'.'||:TGTTBL||
				' as SELECT * FROM ' ||:SRCDB||'.'||:SRCSCHEMA||'.'||:SRCTBL||' WHERE 1=2';
execute immediate :cre_tbl_qry;

insrt_qry := 'INSERT INTO '||:TGTDB||'.'||:TGTSCHEMA||'.'||:TGTTBL||
				' SELECT * FROM ' ||:SRCDB||'.'||:SRCSCHEMA||'.'||:SRCTBL||' SAMPLE('||:DATA_VOLUME||')';
execute immediate :insrt_qry;

RETURN 'Insertion of Sample Data completed';

END;

-- CALL TEST_EMP.PROCS.SP_LOAD_SAMPLE_DATA('SNOWFLAKE_SAMPLE_DATA', 'TPCH_SF1', 'CUSTOMER', 'TEST_EMP', 'HRDATA', 'CUSTOMER_COPY', 10);
