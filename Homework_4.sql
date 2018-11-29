-- --------------------------------------------------------------------------------
-- Name: Steve Brown
-- Class: IT-111-400
-- Abstract: Homework:	4 – Stored Procedures (cont.)
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


-- Drop  PROCEDURES
-- --------------------------------------------------------------------------------
IF OBJECT_ID( 'uspAddCustomerAndJob ' )	        IS NOT NULL DROP PROCEDURE		uspAddCustomerAndJob 
IF OBJECT_ID( 'uspAddCustomerJob ' )			IS NOT NULL DROP PROCEDURE		uspAddCustomerJob 
IF OBJECT_ID( 'uspAddJob ' )		         	IS NOT NULL DROP PROCEDURE		uspAddJob 
IF OBJECT_ID( 'uspAddCustomer ' )		    	IS NOT NULL DROP PROCEDURE		uspAddCustomer 

-- --------------------------------------------------------------------------------
-- Step #1.1: Create Tables
-- --------------------------------------------------------------------------------

CREATE TABLE TCustomers
(
	 intCustomerID	       INTEGER			NOT NULL
	,strCustomerFirstName  VARCHAR(50)		NOT NULL
	,strCustomerLastName   VARCHAR(50)		NOT NULL
	,strCustomerPhone	   VARCHAR(50)		NOT NULL
	,strCustomerEmail	   VARCHAR(50)		NOT NULL
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
	 intCustomerJobID	INTEGER	 IDENTITY       NOT NULL
	,intCustomerID		INTEGER			        NOT NULL
	,intJobID	        INTEGER			        NOT NULL
	,CONSTRAINT TCustomerJobs_UQ UNIQUE	( intCustomerID, intJobID )
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
ALTER TABLE TCustomerJobs ADD CONSTRAINT TCustomerJobs_TCustomers_FK
FOREIGN KEY ( intCustomerID ) REFERENCES TCustomers ( intCustomerID )

-- 2
ALTER TABLE TCustomerJobs ADD CONSTRAINT TCustomerJobs_TJobs_FK
FOREIGN KEY ( intJobID ) REFERENCES TJobs ( intJobID )



-- --------------------------------------------------------------------------------
-- Step #1.3: Add at least 3 customers
-- --------------------------------------------------------------------------------
INSERT INTO TCustomers ( intCustomerID, strCustomerFirstName, strCustomerLastName, strCustomerPhone, strCustomerEmail )
VALUES	 ( 1, 'Steve', 'Brown', '5136029877', 'sb3518@aol.com' )
		,( 2, 'Seth', ' Smith', '5137695499','seths@yahoo.com' )
		,( 3, 'Kyle', ' Green', '5138211405', 'kg@gmail.com' )
		,( 4, 'Andee', ' Reeves', '5135436789', 'ar@gmail.com' )
		,( 5, 'Pete', ' Rose', '5137864321', 'peterose@gmail.com' )
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
-- Step #1.7:	5)	Create the stored procedure uspAddCustomer that will add a record to TCustomers.  Call the stored procedure after you create it to make sure it works correctly. Comment your test code out prior to submitting.
-- --------------------------------------------------------------------------------
GO
CREATE PROCEDURE uspAddCustomer
	 @intCustomerID                     AS INTEGER OUTPUT
	,@strCustomerFirstName              AS VARCHAR(50) 
	,@strCustomerLastName               AS VARCHAR(50) 
	,@strCustomerPhone	                VARCHAR(50)		
	,@strCustomerEmail	                VARCHAR(50)
AS
SET XACT_ABORT ON --TERMINATE AND ROLLBACK ENTIRE TRANSACTION ON ANY ERRORS
BEGIN TRANSACTION
	SELECT @intCustomerID = MAX(intCustomerID) + 1
	FROM TCustomers (TABLOCKX) -- LOCK TABLE TILL THE END OF TRANSACTION

	SELECT @intCustomerID = COALESCE(@intCustomerID, 1)

	INSERT INTO TCustomers( intCustomerID, strCustomerFirstName, strCustomerLastName, strCustomerPhone, strCustomerEmail )

	VALUES ( @intCustomerID, @strCustomerFirstName, @strCustomerLastName, @strCustomerPhone, @strCustomerEmail )


COMMIT TRANSACTION
GO

--Test Procedure
--DECLARE @intCustomerID AS INTEGER = 0
--EXECUTE uspAddCustomer @intCustomerID OUTPUT, 'Chad', 'Smith', '5136725431', 'ChadSmith@aol.com'
--PRINT 'Customer ID = ' + CONVERT(VARCHAR, @intCustomerID)

-- --------------------------------------------------------------------------------
-- Step #1.7:	6)	Create the stored procedure uspAddJob that will add a record to TJobs.  Call the stored procedure after you create it to make sure it works correctly. Comment your test code out prior to submitting.
-- --------------------------------------------------------------------------------
GO
CREATE PROCEDURE uspAddJob
	 @intJobID                 AS INTEGER OUTPUT
	,@strJobDescription        AS VARCHAR(50) 
	,@dtmJobStartDate          AS Date
	,@dtmJobEndDate            AS Date 

AS
SET XACT_ABORT ON --TERMINATE AND ROLLBACK ENTIRE TRANSACTION ON ANY ERRORS
BEGIN TRANSACTION
	SELECT @intJobID = MAX(intJobID) + 1
	FROM TJobs (TABLOCKX) -- LOCK TABLE TILL THE END OF TRANSACTION

	SELECT @intJobID = COALESCE(@intJobID, 1)

	INSERT INTO TJobs( intJobID, strJobDescription, dtmJobStartDate, dtmJobEndDate  )

	VALUES ( @intJobID, @strJobDescription, @dtmJobStartDate, @dtmJobEndDate )


COMMIT TRANSACTION
GO

--Test Procedure
--DECLARE @intJobID AS INTEGER = 0
--EXECUTE uspAddJob @intJobID OUTPUT, 'Water filter change', '01/25/2018', '01/25/2018'
--PRINT 'Job ID = ' + CONVERT(VARCHAR, @intJobID)

-- --------------------------------------------------------------------------------
-- Step #1.6: uspAddCustomerJob 1)	Create the stored procedure uspAddCustomerJob that will add a record to TCustomerJobs
-- --------------------------------------------------------------------------------



GO

CREATE PROCEDURE uspAddCustomerJob



	 @intCustomerJobID		AS INTEGER OUTPUT
	,@intCustomerID			INTEGER			            
	,@intJobID		       	INTEGER			           
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION

	INSERT INTO TCustomerJobs WITH (TABLOCKX)( intCustomerID, intJobID )
	VALUES( @intCustomerID, @intJobID )

	SELECT @intCustomerJobID = MAX( intCustomerJobID ) 
	FROM TCustomerJobs 

COMMIT TRANSACTION

GO
--Test it
--DECLARE @intCustomerJobID AS INTEGER = 0;
--EXECUTE uspAddCustomerJob @intCustomerJobID OUTPUT, 1,4
--PRINT 'CustomerJob ID = ' + CONVERT( VARCHAR, @intCustomerJobID )

SELECT * FROM TCustomers
SELECT * FROM TJobs
SELECT * FROM TCustomerJobs

-- --------------------------------------------------------------------------------
-- Step #1.7: 2)	Create the stored procedure uspAddCustomerAndJob that will add a customer to TCustomers, add a Job to TJobs and add a record to TCustomerJobs to join the new customer and job. 
-- --------------------------------------------------------------------------------



GO

CREATE PROCEDURE uspAddCustomerAndJob



	 @intCustomerJobID		 INTEGER OUTPUT
    ,@strCustomerFirstName   VARCHAR( 50 )	
	,@strCustomerLastName	 VARCHAR( 50 )
	,@strCustomerPhone	     VARCHAR( 50 )
	,@strCustomerEmail	     VARCHAR(50)

	,@strJobDescription      VARCHAR(250)
	,@dtmJobStartDate   	 DATE   
	,@dtmJobEndDate  	     DATE 
           
AS
SET NOCOUNT ON		-- Report only errors
SET XACT_ABORT ON	-- Terminate and rollback entire transaction on error

BEGIN TRANSACTION
DECLARE  @intCustomerID AS INTEGER
DECLARE  @intJobID AS INTEGER	

EXECUTE uspAddCustomer @intCustomerID OUTPUT, @strCustomerFirstName, @strCustomerLastName, @strCustomerPhone, @strCustomerEmail

EXECUTE uspAddJob @intJobID OUTPUT, @strJobDescription, @dtmJobStartDate, @dtmJobEndDate

EXECUTE uspAddCustomerJob @intCustomerJobID OUTPUT, @intCustomerID, @intJobID

	SELECT @intCustomerJobID = MAX(intCustomerJobID)
	FROM TCustomerJobs

COMMIT TRANSACTION

GO

-- Test it
--DECLARE @intCustomerJobID AS INTEGER = 0;
--EXECUTE uspAddCustomerAndJob @intCustomerJobID OUTPUT, 'tom', 'yellow', '513-821-2970', 'Zin@yahoo.com', 'Replace Kitchen Faucet', '01/30/2018', '01/30/2018'
--PRINT 'Customer AND Job ID = ' + CONVERT( VARCHAR, @intCustomerJobID )

SELECT * FROM TCustomers
SELECT * FROM TJobs
SELECT * FROM TCustomerJobs