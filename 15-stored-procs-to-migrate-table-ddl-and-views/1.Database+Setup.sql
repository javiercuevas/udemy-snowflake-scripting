-- Create Databases and Schemas for 3 environments
CREATE DATABASE IF NOT EXISTS DEV_EMP; 
CREATE SCHEMA  IF NOT EXISTS DEV_EMP.HRDATA;
CREATE SCHEMA  IF NOT EXISTS DEV_EMP.WORK;
CREATE SCHEMA  IF NOT EXISTS DEV_EMP.PROCS;

CREATE DATABASE IF NOT EXISTS TEST_EMP;
CREATE SCHEMA  IF NOT EXISTS TEST_EMP.HRDATA;
CREATE SCHEMA  IF NOT EXISTS TEST_EMP.WORK;
CREATE SCHEMA  IF NOT EXISTS TEST_EMP.PROCS;

CREATE DATABASE IF NOT EXISTS PROD_EMP; 
CREATE SCHEMA  IF NOT EXISTS PROD_EMP.HRDATA;
CREATE SCHEMA  IF NOT EXISTS PROD_EMP.WORK;
CREATE SCHEMA  IF NOT EXISTS PROD_EMP.PROCS;

-- Create a work table in all environments
CREATE TABLE DEV_EMP.WORK.MIGRATE_TABLES(TABLE_NAME VARCHAR(50));
CREATE TABLE TEST_EMP.WORK.MIGRATE_TABLES(TABLE_NAME VARCHAR(50));
CREATE TABLE PROD_EMP.WORK.MIGRATE_TABLES(TABLE_NAME VARCHAR(50));