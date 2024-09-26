CREATE OR REPLACE PROCEDURE TEST_EMP.PROCS.SP_MIGRATE_VIEWS("SRCDB" VARCHAR, "SRCSCHEMA" VARCHAR, "TGTDB" VARCHAR, "TGTSCHEMA" VARCHAR, "ALL_FLAG" VARCHAR(1)) 
RETURNS VARCHAR 
LANGUAGE SQL 
EXECUTE AS CALLER 
AS

DECLARE 

-- ALL_FLAG - 'Y' if you want to migrate all tables from Schema, 'N' if you want to migrate specific tables

cur_all_views cursor for SELECT DISTINCT TABLE_NAME as VIEW_NAME FROM TABLE(?) 
							WHERE TABLE_SCHEMA = ? AND TABLE_TYPE = 'VIEW';
cur_some_views cursor for SELECT DISTINCT VIEW_NAME FROM TABLE(?);

cur_env cursor for SELECT SRC_ENV_DB, TGT_ENV_DB FROM TABLE(?);

SRCVIEW VARCHAR;
ddl_statement VARCHAR;

BEGIN

IF (:ALL_FLAG = 'Y') THEN

	OPEN cur_all_views USING(:SRCDB||'.INFORMATION_SCHEMA.TABLES', :SRCSCHEMA);
	
	for rec in cur_all_views do 
	
		SRCVIEW := rec.VIEW_NAME;
		SELECT get_ddl('VIEW', :SRCDB||'.'||:SRCSCHEMA||'.'||:SRCVIEW) into :ddl_statement;
		
		-- replace the databases in the view definition
		OPEN cur_env USING(:TGTDB||'.WORK.XW_ENV_DATABASES');
		for rec1 in cur_env do
			ddl_statement := REGEXP_REPLACE(:ddl_statement, rec1.SRC_ENV_DB, rec1.TGT_ENV_DB, 1, 0, 'i');
		end for;
		CLOSE cur_env;
				
		ddl_statement := REGEXP_REPLACE(:ddl_statement, 'create or replace view ', 'create or replace view '||:TGTDB||'.'||:TGTSCHEMA||'.', 1, 0, 'i');
				
		execute immediate :ddl_statement;	
		
	end for;
	CLOSE cur_all_views;
		
ELSE 
	OPEN cur_some_views USING(:TGTDB||'.WORK.MIGRATE_VIEWS');
	
	for rec in cur_some_views do 
	
		SRCVIEW := rec.VIEW_NAME;
		SELECT get_ddl('VIEW', :SRCDB||'.'||:SRCSCHEMA||'.'||:SRCVIEW) into :ddl_statement;
		
		OPEN cur_env USING(:TGTDB||'.WORK.XW_ENV_DATABASES');
		for rec1 in cur_env do
			ddl_statement := REGEXP_REPLACE(:ddl_statement, rec1.SRC_ENV_DB, rec1.TGT_ENV_DB, 1, 0, 'i');
		end for;
		CLOSE cur_env;
				
		ddl_statement := REGEXP_REPLACE(:ddl_statement, 'create or replace view ', 'create or replace view '||:TGTDB||'.'||:TGTSCHEMA||'.', 1, 0, 'i');
				
		execute immediate :ddl_statement;	
		
	end for;
	CLOSE cur_some_views;

END IF;

RETURN 'Views Migrated Successfully';

END;

-- INSERT INTO TEST_EMP.WORK.MIGRATE_VIEWS VALUES ('V_COUNTRIES'), ('V_DEPT_WISE_EMP_HIRED'), (''V_EMPLOYEE_DETAILS);
-- CALL TEST_EMP.PROCS.SP_MIGRATE_VIEWS('DEV_EMP', 'HRDATA', 'TEST_EMP', 'HRDATA', 'N');
-- CALL TEST_EMP.PROCS.SP_MIGRATE_VIEWS('DEV_EMP', 'HRDATA', 'TEST_EMP', 'HRDATA', 'Y');