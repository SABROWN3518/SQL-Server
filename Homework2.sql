-- --------------------------------------------------------------------------------
-- Name: Steve Brown
-- Class: IT-111-400
-- Abstract: Homework 2
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL1;     -- Get out of the master database
SET NOCOUNT ON; -- Report only errors

-- --------------------------------------------------------------------------------
-- Drop Tables
-- --------------------------------------------------------------------------------

IF OBJECT_ID( 'TCustomerJobs' )				IS NOT NULL DROP TABLE		TCustomerJobs
IF OBJECT_ID( 'TJobs' )				    	IS NOT NULL DROP TABLE		TJobs
IF OBJECT_ID( 'TCustomers' )			    IS NOT NULL DROP TABLE		TCustomers


-- --------------------------------------------------------------------------------
-- Step #1.1: Create Tables
-- --------------------------------------------------------------------------------

CREATE TABLE TCustomers
(
	 intCustomerID	    INTEGER			NOT NULL
	,strCustomerName    VARCHAR(50)		NOT NULL
	,strCustomerPhone	VARCHAR(50)		NOT NULL
	,strCustomerEmail	VARCHAR(50)		NOT NULL
	,CONSTRAINT TCustomers_PK PRIMARY KEY ( intCustomerID )
)

CREATE TABLE TJobs
(
	 intJobID			INTEGER			NOT NULL
	,strJobDescription	VARCHAR(250)	NOT NULL
	,dtmJobStartDate	Date     	    NULL
	,dtmJobEndDate  	Date     	    NULL
	,CONSTRAINT TJobs_PK PRIMARY KEY ( intJobID )
)

CREATE TABLE TCustomerJobs
(
	 intCustomerJobID	INTEGER			NOT NULL
	,intCustomerID		INTEGER			NOT NULL
	,intJobID	        INTEGER			NOT NULL
	,CONSTRAINT CustomerJobs_UQ   UNIQUE	( intCustomerID, intJobID )
	,CONSTRAINT TCustomerJobs_PK PRIMARY KEY ( intCustomerJobID )
)

-- --------------------------------------------------------------------------------
-- Step #1.2: Identify and Create Foreign Keys
-- --------------------------------------------------------------------------------
--
-- #	Child						Parent						Column(s)
-- -	-----						------						---------
-- 1	TCustomerJobs				TCustomers					intCustomerID
-- 2	TCustomerJobs				TJobs						intJobID

-- 1
ALTER TABLE TCustomerJobs ADD CONSTRAINT TCustomerJobs_TUsers_FK
FOREIGN KEY ( intCustomerID ) REFERENCES TCustomers ( intCustomerID )

-- 2
ALTER TABLE TCustomerJobs ADD CONSTRAINT TCustomerJobs_TSongs_FK
FOREIGN KEY ( intJobID ) REFERENCES TJobs ( intJobID )



-- --------------------------------------------------------------------------------
-- Step #1.3: Add at least 3 customers
-- --------------------------------------------------------------------------------
INSERT INTO TCustomers ( intCustomerID, strCustomerName, strCustomerPhone, strCustomerEmail )
VALUES	 ( 1, 'Steve Brown', '5136029877', 'sb3518@aol.com' )
		,( 2, 'Seth Smith', '5137695499','seths@yahoo.com' )
		,( 3, 'Kyle Green', '5138211405', 'kg@gmail.com' )
		,( 4, 'Andee Reeves', '5135436789', 'ar@gmail.com' )
		,( 5, 'Pete Rose', '5137864321', 'peterose@gmail.com' )
-- --------------------------------------------------------------------------------
-- Step #1.4: Add at least 3 Jobs
-- --------------------------------------------------------------------------------
INSERT INTO TJobs ( intJobID, strJobDescription, dtmJobStartDate, dtmJobEndDate )
VALUES	 ( 1, 'Snake out drain', '01/01/2018', '01/02/2018' )
		,( 2, 'Instal toilet', '01/05/2018', '01/06/2018' )
		,( 3, 'Run Copper lines in basement', Null, Null )
		,( 4, 'Repair Outside Drain Lines', '01/17/2018', Null )
		,( 5, 'Install countertop', '06/03/2017', '06/06/2017' )
		,( 6, 'Install Sprinkler System', '09/15/2017', '09/25/2017' )
		,( 7, 'Install Lighting', NULL, NULL )
		,( 8, 'Bathroom Remodel', '01/23/2018', NULL )
		,( 9, 'Kitchen Remodel', '01/23/2018', NULL )
-- --------------------------------------------------------------------------------
-- Step #1.5:	Give 2 customers jobs leaving 1 with no job. 	Give 1 customer 2 different jobs.
-- --------------------------------------------------------------------------------
INSERT INTO TCustomerJobs( intCustomerJobID, intCustomerID, intJobID )
VALUES	 ( 1, 1, 1 )
		,( 2, 1, 2 )
		,( 3, 2, 3 )
		,( 4, 2, 4 )
		,( 5, 3, 5 )
		,( 6, 3, 6 )
		,( 7, 3, 7 )
		,( 8, 3, 8 )
		,( 9, 5, 9 )

-- --------------------------------------------------------------------------------
-- Step #1.6: 8.	Try to give a customer the same job twice. This should fail.
-- --------------------------------------------------------------------------------

--INSERT INTO TCustomerJobs ( intCustomerJobID, intCustomerID, intJobID )
--VALUES	 ( 10, 1, 1 )

-- --------------------------------------------------------------------------------
-- Step #1.7:	Write query to show all customers and jobs
-- --------------------------------------------------------------------------------

SELECT
	 TC.strCustomerName
	,TJ.strJobDescription
FROM
	 TCustomers AS TC
	,TJobs AS TJ
	,TCustomerJobs AS TCJ
WHERE
	TJ.intJobID = TCJ.intJobID
	AND TC.intCustomerID = TCJ.intCustomerID

-- --------------------------------------------------------------------------------
-- Step #1.8:	Write query to show any job not completed
-- --------------------------------------------------------------------------------

SELECT
	TJ.strJobDescription
FROM
	 TCustomers AS TC
	,TJobs AS TJ
	,TCustomerJobs AS TCJ
WHERE
    TC.intCustomerID = TCJ.intCustomerID
    AND TJ.intJobID = TCJ.intJobID
	AND TJ.dtmJobEndDate IS NULL

-- --------------------------------------------------------------------------------
-- Step #1.8:	11.	Write query to update an End Date from NULL to a date after the Start Date for that job.
-- --------------------------------------------------------------------------------

SELECT * from TJobs

UPDATE TJobs
SET dtmJobEndDate = '01/17/2018'
WHERE intJobID = 4

SELECT * from TJobs