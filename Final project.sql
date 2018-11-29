-- --------------------------------------------------------------------------------
-- Name: Steve Brown
-- Class: IT-112
-- Abstract: SQL2_FINAL_PROJECT
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL1;     -- Get out of the master database
SET NOCOUNT ON; -- Report only errors
-- --------------------------------------------------------------------------------
-- Drop  PROCEDURES
-- --------------------------------------------------------------------------------

IF OBJECT_ID( 'uspWithdrawPatientStudy ' )					IS NOT NULL DROP PROCEDURE		uspWithdrawPatientStudy 
--IF OBJECT_ID( 'uspRandomPatientStudy ' )					IS NOT NULL DROP PROCEDURE		uspRandomPatientStudy 
IF OBJECT_ID( 'uspRandomizePatient54321 ' )			    	IS NOT NULL DROP PROCEDURE		uspRandomizePatient54321 
IF OBJECT_ID( 'uspRandomizePatient12345 ' )			    	IS NOT NULL DROP PROCEDURE		uspRandomizePatient12345 
IF OBJECT_ID( 'uspScreenedPatientStudy ' )		            IS NOT NULL DROP PROCEDURE		uspScreenedPatientStudy 



-- --------------------------------------------------------------------------------
-- Drop Tables
-- --------------------------------------------------------------------------------
IF OBJECT_ID( 'TDrugKits' )									IS NOT NULL DROP TABLE			TDrugKits
IF OBJECT_ID( 'TPatientVisits' )							IS NOT NULL DROP TABLE			TPatientVisits
IF OBJECT_ID( 'TWithdrawReasons' )							IS NOT NULL DROP TABLE			TWithdrawReasons
IF OBJECT_ID( 'TVisitTypes' )								IS NOT NULL DROP TABLE			TVisitTypes
IF OBJECT_ID( 'TPatients' )		            				IS NOT NULL DROP TABLE			TPatients
IF OBJECT_ID( 'TRandomCodes' )								IS NOT NULL DROP TABLE			TRandomCodes
IF OBJECT_ID( 'TGenders' )									IS NOT NULL DROP TABLE			TGenders
IF OBJECT_ID( 'TSites' )									IS NOT NULL DROP TABLE			TSites
IF OBJECT_ID( 'TStudies' )									IS NOT NULL DROP TABLE			TStudies 

-- --------------------------------------------------------------------------------
-- Drop Views
-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------
IF OBJECT_ID( 'vPatientWithdrawnWithSiteAndStudy ' )		IS NOT NULL DROP VIEW   		vPatientWithdrawnWithSiteAndStudy
IF OBJECT_ID( 'vAvailableDrugsAtSitesWithStudies ' )		IS NOT NULL DROP VIEW   		vAvailableDrugsAtSitesWithStudies
IF OBJECT_ID( 'vNextRandomCode2 ' )							IS NOT NULL DROP VIEW			vNextRandomCode2
IF OBJECT_ID( 'vNextRandomCode1 ' )							IS NOT NULL DROP VIEW			vNextRandomCode1
IF OBJECT_ID( 'vNextRandomCode ' )							IS NOT NULL DROP VIEW			vNextRandomCode
IF OBJECT_ID( 'vAllRandomizedPatientsSiteAndTreatment ' )	IS NOT NULL DROP VIEW			vAllRandomizedPatientsSiteAndTreatment
IF OBJECT_ID( 'vAllPatientsAtAllSitesAndStudies ' )			IS NOT NULL DROP VIEW			vAllPatientsAtAllSitesAndStudies
IF OBJECT_ID( 'vNextVisitID ' )								IS NOT NULL DROP VIEW			vNextVisitID
 
-- --------------------------------------------------------------------------------
-- Step 1: Create Tables
-- --------------------------------------------------------------------------------

CREATE TABLE TStudies
(
	 intStudyID					INTEGER					NOT NULL
	,strStudyDesc				VARCHAR(50)				NOT NULL
	,CONSTRAINT TStudies_PK PRIMARY KEY ( intStudyID )
)

CREATE TABLE TSites
(
	 intSiteID					INTEGER					NOT NULL   
	,intSiteNumber  			INTEGER					NOT NULL          
	,intStudyID 				INTEGER 				NOT NULL           
	,strName				    VARCHAR(50)				NOT NULL
	,strAddress					VARCHAR(50)				NOT NULL
	,strCity					VARCHAR(50)				NOT NULL
	,strState					VARCHAR(50)				NOT NULL
	,strZip						VARCHAR(50)				NOT NULL         
	,strPhone					VARCHAR(50)			 	NOT NULL           
	,CONSTRAINT TSites_PK PRIMARY KEY ( intSiteID )
)

CREATE TABLE TPatients
(
	 intPatientID	            INTEGER	IDENTITY        NOT NULL
	,intPatientNumber   		INTEGER					NOT NULL
	,intSiteID			    	INTEGER					NOT NULL
	,dtmDOB                     DATE					NOT NULL
	,intGenderID                INTEGER					NOT NULL
	,intWeight					INTEGER					NOT NULL
	,intRandomCodeID			INTEGER						NULL
    ,CONSTRAINT TPatients_PK PRIMARY KEY ( intPatientID )
)

CREATE TABLE TVisitTypes
(
	 intVisitTypeID	            INTEGER					NOT NULL
	,strVisitDesc				VARCHAR(50)				NOT NULL
    ,CONSTRAINT TVisitTypes_PK PRIMARY KEY ( intVisitTypeID )
)

CREATE TABLE TPatientVisits
(
	 intVisitID     	        INTEGER	IDENTITY      	NOT NULL
	,intPatientID     	        INTEGER					NOT NULL
	,dtmVisit                   DATE					NOT NULL
	,intVisitTypeID             INTEGER					NOT NULL
	,intWithdrawReasonID        INTEGER						NULL
    ,CONSTRAINT TPatientVisits_PK PRIMARY KEY ( intVisitID )
)

CREATE TABLE TRandomCodes
(
	 intRandomCodeID			INTEGER					NOT NULL                      
	,intStudyID         		INTEGER 				NOT NULL
	,intRandomCode              INTEGER					NOT NULL
	,strTreatment				VARCHAR(50)				NOT NULL
	,blnAvailable				VARCHAR(50)				NOT NULL
	,CONSTRAINT TRandomCodes_PK PRIMARY KEY ( intRandomCodeID )
)

CREATE TABLE TDrugKits
(
	 intDrugKitID		    	INTEGER					NOT NULL                      
	,intSiteID           		INTEGER 				NOT NULL
	,strTreatment				VARCHAR(50)				NOT NULL
	,intVisitID				    INTEGER						NULL
	,CONSTRAINT TDrugKits_PK PRIMARY KEY ( intDrugKitID )
)

CREATE TABLE TWithdrawReasons
(
	 intWithdrawReasonID		INTEGER					NOT NULL                      
	,strWithdrawDesc			VARCHAR(50)				NOT NULL
	,CONSTRAINT TWithdrawReasons_PK PRIMARY KEY ( intWithdrawReasonID )
)

CREATE TABLE TGenders
(
	 intGenderID        		INTEGER					NOT NULL                      
	,strGender      			VARCHAR(50)				NOT NULL
	,CONSTRAINT TGenders_PK PRIMARY KEY ( intGenderID )
)
-- --------------------------------------------------------------------------------
-- Step #1.2: Identify and Create Foreign Keys
-- --------------------------------------------------------------------------------
--
-- #	Child								Parent						Column(s)
-- -	-----								------						---------
--1  TSites                              TStudies                    intStudyID
--2  TPatients                           TSites                      intSiteID
--3  TVisitTypes                         TPatientVisits              intVisitTypeID
--4  TPatientVisits		     			 TPatients					 intPatientID
--5  TRandomCodes                        TStudies                    intStudyID
--6  TDrugKits                           TSites                      intSiteID
--7  TPatientVisits                      TWithdrawReasons            intWithdrawReasonID
--8  TPatients                           TGender                     intGenderID 
--9  TDrugKits							 TPatientVisits				 intVisitID
--10 TPatients							 TRandomCodes				 intRandomCodeID

--1 
ALTER TABLE TSites ADD CONSTRAINT TSites_TStudies_FK
FOREIGN KEY ( intStudyID ) REFERENCES TStudies ( intStudyID )

--2 
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TSites_FK
FOREIGN KEY ( intSiteID ) REFERENCES TSites ( intSiteID )

--3 
ALTER TABLE TPatientVisits ADD CONSTRAINT TPatientVisits_TVisitTypes_FK
FOREIGN KEY ( intVisitTypeID ) REFERENCES TVisitTypes ( intVisitTypeID )

--4 
ALTER TABLE TPatientVisits ADD CONSTRAINT TPatientVisits_TPatients_FK
FOREIGN KEY ( intPatientID ) REFERENCES TPatients ( intPatientID )

--5 
ALTER TABLE TRandomCodes ADD CONSTRAINT TRandomCodes_TStudies_FK
FOREIGN KEY ( intStudyID ) REFERENCES TStudies ( intStudyID )

--6 
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TSites_FK
FOREIGN KEY ( intSiteID ) REFERENCES TSites ( intSiteID )

--7 
ALTER TABLE TPatientVisits ADD CONSTRAINT TPatientVisits_TWithdrawReasons_FK
FOREIGN KEY ( intWithdrawReasonID ) REFERENCES TWithdrawReasons ( intWithdrawReasonID )

--8 
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TGenders_FK
FOREIGN KEY ( intGenderID ) REFERENCES TGenders ( intGenderID )

-- 9
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TPatientVisits_FK
FOREIGN KEY ( intVisitID ) REFERENCES TPatientVisits ( intVisitID )

--10
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TRandomCodes_FK
FOREIGN KEY ( intRandomCodeID ) REFERENCES TRandomCodes ( intRandomCodeID )

-- --------------------------------------------------------------------------------
-- Inserts for TStudies
-- --------------------------------------------------------------------------------
INSERT INTO TStudies ( intStudyID, strStudyDesc )
VALUES	 ( 12345, 'Study 1' )
		,( 54321, 'Study 2' )
				
-- --------------------------------------------------------------------------------
-- Inserts for TSites 
-- --------------------------------------------------------------------------------
INSERT INTO TSites ( intSiteID, intSiteNumber, intStudyID, strName, strAddress,strCity, strState, strZip, strPhone )
VALUES	 ( 1, 101,	12345, 'Dr. Stan Heinrich', '123 E. Main St', 'Atlanta', 'GA', '25869', '1234567890' )
		,( 2, 111,	12345, 'Mercy Hospital', '3456 Elmhurst Rd.', 'Secaucus', 'NJ',	'32659', '5013629564' )
		,( 3, 121,	12345, 'St. Elizabeth Hospital', '976 Jackson Way',	'Ft. Thomas', 'KY',	'41258', '3026521478' )
		,( 4, 131,	12345, 'Dr. Jim Smith', '32454 Morris Rd.', 'Hamilton', 'OH', '45013', '3256847596' )
		,( 5, 141,	12345,	'Dr. Dan Jones', '1865 Jelico Hwy.', 'Knoxville', 'TN',	'34568', '2145798241' )
-- -----------------------------------------------------------------------------------------------------------------
		,( 6, 501,	54321, 'Dr. Robert Adler', '9087 W. Maple Ave.', 'Cedar Rapids', 'IA', '42365',	'6149652574' )
		,( 7, 511,	54321, 'Dr. Tim Schmitz', '4539 Helena Run', 'Johnson City', 'TN', '34785',	'5066987462' )
		,( 8, 521,	54321, 'Dr. Lawrence Snell', '9201 NW. Washington Blvd.', 'Bristol', 'VA', '20163',	'3876510249' )
		,( 9, 531,	54321, 'Cedar Sinai Medical Center', '40321 Hollywood Blvd.', 'Portland', 'OR', '50236', '5439510246' )
		,( 10, 541,	54321, 'Vally View Hospital', '398 Hampton Rd.', 'Seattle', 'WA', '41203',	'7243780036' )


-- --------------------------------------------------------------------------------
-- Inserts for TVisitTypes
-- --------------------------------------------------------------------------------
INSERT INTO TVisitTypes ( intVisitTypeID, strVisitDesc )
VALUES	 ( 1, 'Screening' )
        ,( 2, 'Randomization' )
		,( 3, 'Withdrawal' )


-- --------------------------------------------------------------------------------
-- Inserts for TRandomCodes
-- --------------------------------------------------------------------------------
INSERT INTO TRandomCodes ( intRandomCodeID, intStudyID, intRandomCode, strTreatment, blnAvailable )
VALUES	 ( 1, 12345, 1000, 'A', 'T' )  --DRUG KIT 10000F
		,( 2, 12345, 1001, 'P', 'T' )  --DRUG KIT 10004F
		,( 3, 12345, 1002, 'A', 'T' )  --DRUG KIT 10001F
		,( 4, 12345, 1003, 'P', 'T' )  --DRUG KIT 10005
		,( 5, 12345, 1004, 'P', 'T' )  --DRUG KIT 10006
		,( 6, 12345, 1005, 'A', 'T' )  --DRUG KIT 10002F
		,( 7, 12345, 1006, 'A', 'T' )  --DRUG KIT 10003F
		,( 8, 12345, 1007, 'P', 'T' )  --DRUG KIT 10007
		,( 9, 12345, 1008,	'A', 'T' ) --DRUG KIT 10008
		,( 10, 12345, 1009, 'P', 'T' ) --DRUG KIT 10012
		,( 11, 12345, 1010, 'P', 'T' ) --DRUG KIT 10013
		,( 12, 12345, 1011, 'A', 'T' ) --DRUG KIT 10009
		,( 13, 12345, 1012, 'P', 'T' ) --DRUG KIT 10014
		,( 14, 12345, 1013, 'A', 'T' ) --DRUG KIT 10010
		,( 15, 12345, 1014, 'A', 'T' ) --DRUG KIT 10011
		,( 16, 12345, 1015, 'A', 'T' ) --DRUG KIT 10016
		,( 17, 12345, 1016, 'P', 'T' ) --DRUG KIT 10015
		,( 18, 12345, 1017, 'P', 'T' ) --DRUG KIT 10020
		,( 19, 12345, 1018, 'A', 'T' ) --DRUG KIT 10017
		,( 20, 12345, 1019, 'P', 'T' ) --DRUG KIT 10021
-- --------------------------------------------------------------------
		,( 21, 54321, 5000, 'A', 'T' ) --DRUG KIT 10018
		,( 22, 54321, 5001, 'A', 'T' ) --DRUG KIT 10019
		,( 23, 54321, 5002, 'A', 'T' ) --DRUG KIT 10024
		,( 24, 54321, 5003, 'A', 'T' ) --DRUG KIT 10025
		,( 25, 54321, 5004, 'A', 'T' ) --DRUG KIT 10026
		,( 26, 54321, 5005, 'A', 'T' ) --DRUG KIT 10027
		,( 27, 54321, 5006, 'A', 'T' ) --DRUG KIT 10032F
		,( 28, 54321, 5007, 'A', 'T' ) --DRUG KIT 10033F
		,( 29, 54321, 5008, 'A', 'T' ) --DRUG KIT 10034 F
		,( 30, 54321, 5009, 'A', 'T' ) --DRUG KIT 10035F
		,( 31, 54321, 5010, 'P', 'T' ) --DRUG KIT 10022
		,( 32, 54321, 5011, 'P', 'T' ) --DRUG KIT 10023
		,( 33, 54321, 5012, 'P', 'T' ) --DRUG KIT 10028
		,( 34, 54321, 5013, 'P', 'T' ) --DRUG KIT 10029
		,( 35, 54321, 5014, 'P', 'T' ) --DRUG KIT 10030
		,( 36, 54321, 5015, 'P', 'T' ) --DRUG KIT 10031
		,( 37, 54321, 5016, 'P', 'T' ) --DRUG KIT 10036F
		,( 38, 54321, 5017, 'P', 'T' ) --DRUG KIT 10037
		,( 39, 54321, 5018, 'P', 'T' ) --DRUG KIT 10038
		,( 40, 54321, 5019, 'P', 'T' ) --DRUG KIT 10039
		
-- --------------------------------------------------------------------------------
-- Inserts for TWithdrawReasons
-- --------------------------------------------------------------------------------
INSERT INTO TWithdrawReasons ( intWithdrawReasonID, strWithdrawDesc )
VALUES	 (1, 'Patient withdrew consent' )
        ,(2, 'Adverse event' )
		,(3, 'Health issue-related to study' )
		,(4, 'Health issue-unrelated to study' )
		,(5, 'Personal reason' )
		,(6, 'Completed the study' )

-- --------------------------------------------------------------------------------
-- Inserts for TGenders
-- --------------------------------------------------------------------------------
INSERT INTO TGenders ( intGenderID, strGender )
VALUES	 ( 1, 'Female' )
		,( 2, 'Male' )	

-- --------------------------------------------------------------------------------
-- Inserts for TDrugKits
-- --------------------------------------------------------------------------------
INSERT INTO TDrugKits ( intDrugKitID, intSiteID, strTreatment, intVisitID )
VALUES	 ( 10000, 1, 'A', NULL ) --RandomID 1000 2
        ,( 10001, 1, 'A', NULL ) --RandomID 1002 4
		,( 10002, 1, 'A', NULL ) --RandomID 1005 7
		,( 10003, 1, 'A', NULL ) --RandomID 1006 9
		,( 10004, 1, 'P', NULL ) --RandomID 1001 12
		,( 10005, 1, 'P', NULL ) --RandomID 1003
		,( 10006, 1, 'P', NULL ) --RandomID 1004
		,( 10007, 1, 'P', NULL ) --RandomID 1007

		,( 10008, 2, 'A', NULL ) --RandomID 1008
		,( 10009, 2, 'A', NULL ) --RandomID 1011
		,( 10010, 2, 'A', NULL ) --RandomID 1013
		,( 10011, 2, 'A', NULL ) --RandomID 1014
		,( 10012, 2, 'P', NULL ) --RandomID 1009
		,( 10013, 2, 'P', NULL ) --RandomID 1010
		,( 10014, 2, 'P', NULL ) --RandomID 1012
		,( 10015, 2, 'P', NULL ) --RandomID 1016

		,( 10016, 3, 'A', NULL ) --RandomID 1015
		,( 10017, 3, 'A', NULL ) --RandomID 1018
		,( 10018, 3, 'A', NULL ) --RandomID 5000
		,( 10019, 3, 'A', NULL ) --RandomID 5001
		,( 10020, 3, 'P', NULL ) --RandomID 1017
		,( 10021, 3, 'P', NULL ) --RandomID 1019
		,( 10022, 3, 'P', NULL ) --RandomID 5010
		,( 10023, 3, 'P', NULL ) --RandomID 5011
		,( 10024, 3, 'A', NULL ) --RandomID 5002

		,( 10025, 4, 'A', NULL ) --RandomID 5003
		,( 10026, 4, 'A', NULL ) --RandomID 5004
		,( 10027, 4, 'A', NULL ) --RandomID 5005
		,( 10028, 4, 'P', NULL ) --RandomID 5012
		,( 10029, 4, 'P', NULL ) --RandomID 5013
		,( 10030, 4, 'P', NULl ) --RandomID 5014
		,( 10031, 4, 'P', NULl ) --RandomID 5015

		,( 10032, 5, 'A', NULL ) --RandomID 5006 14
		,( 10033, 5, 'A', NULL ) --RandomID 5007 17
		,( 10034, 5, 'A', NULL ) --RandomID 5008 19
		,( 10035, 5, 'A', NULL ) --RandomID 5009 22
		,( 10036, 5, 'P', NULL ) --RandomID 5016 24
		,( 10037, 5, 'P', NULL ) --RandomID 5017
		,( 10038, 5, 'P', NULL ) --RandomID 5018
		,( 10039, 5, 'P', NULL ) --RandomID 5019

		,( 10040, 6, 'A', NULL ) --RandomID
		,( 10041, 6, 'A', NULL ) --RandomID
		,( 10042, 6, 'A', NULL ) --RandomID
		,( 10043, 6, 'A', NULL ) --RandomID
		,( 10044, 6, 'P', NULL ) --RandomID
		,( 10045, 6, 'P', NULL ) --RandomID
		,( 10046, 6, 'P', NULL ) --RandomID
		,( 10047, 6, 'P', NULL ) --RandomID

		,( 10048, 7, 'A', NULL ) --RandomID
		,( 10049, 7, 'A', NULL ) --RandomID
		,( 10050, 7, 'A', NULL ) --RandomID
		,( 10051, 7, 'A', NULL ) --RandomID
		,( 10052, 7, 'P', NULL ) --RandomID
		,( 10053, 7, 'P', NULL ) --RandomID
		,( 10054, 7, 'P', NULL ) --RandomID
		,( 10055, 7, 'P', NULL ) --RandomID

		,( 10056, 8, 'A', NULL ) --RandomID
		,( 10057, 8, 'A', NULL ) --RandomID
		,( 10058, 8, 'A', NULL ) --RandomID
		,( 10059, 8, 'A', NULL ) --RandomID
		,( 10060, 8, 'P', NULL ) --RandomID
		,( 10061, 8, 'P', NULL ) --RandomID
		,( 10062, 8, 'P', NULL ) --RandomID
		,( 10063, 8, 'P', NULL ) --RandomID

		,( 10064, 9, 'A', NULL ) --RandomID
		,( 10065, 9, 'A', NULL ) --RandomID
		,( 10066, 9, 'A', NULL ) --RandomID
		,( 10067, 9, 'A', NULL ) --RandomID
		,( 10068, 9, 'P', NULL ) --RandomID
		,( 10069, 9, 'P', NULL ) --RandomID
		,( 10070, 9, 'P', NULL ) --RandomID
		,( 10071, 9, 'P', NULL ) --RandomID

		,( 10072, 10, 'A', NULL ) --RandomID
		,( 10073, 10, 'A', NULL ) --RandomID
		,( 10074, 10, 'A', NULL ) --RandomID
		,( 10075, 10, 'A', NULL ) --RandomID
		,( 10076, 10, 'P', NULL ) --RandomID
		,( 10077, 10, 'P', NULL ) --RandomID
		,( 10078, 10, 'P', NULL ) --RandomID
		,( 10079, 10, 'P', NULL ) --RandomID

-- --------------------------------------------------------------------------------
-- 3.	Create the view that will show all patients at all sites for both studies. You can do this together or 1 view for each study.
-- --------------------------------------------------------------------------------
GO 
CREATE VIEW vAllPatientsAtAllSitesAndStudies
AS
SELECT
		TP.intPatientNumber, TS.strName, TSU.strStudyDesc
FROM
		 TPatients AS TP
		,TSites AS TS
		,TStudies AS TSU

WHERE
		TP.intSiteID = TS.intSiteID and 
		TSU.intStudyID = TS.intStudyID
GO

-- --------------------------------------------------------------------------------
-- 4.	Create the view that will show all randomized patients, their site and their treatment for both studies. You can do this together or 1 view for each study.
-- --------------------------------------------------------------------------------
GO
CREATE VIEW vAllRandomizedPatientsSiteAndTreatment
AS
SELECT      
			TPatients.intPatientNumber, TSites.intSiteNumber, TRandomCodes.strTreatment
FROM            
			TPatients INNER JOIN TRandomCodes ON TPatients.intRandomCodeID = 
			TRandomCodes.intRandomCodeID INNER JOIN TSites ON TPatients.intSiteID = 
			TSites.intSiteID INNER JOIN TPatientVisits ON TPatients.intPatientID = 
			TPatientVisits.intPatientID
WHERE                  
            TPatientVisits.intVisitTypeID = '2'
GO
-- --------------------------------------------------------------------------------
-- 5.	Create the view that will show the next available random codes (MIN) for both studies. You can do this together or 1 view for each study.
-- --------------------------------------------------------------------------------
-- View that shows next available random codes (MIN) for both studies together
GO
CREATE VIEW vNextRandomCode
AS
SELECT DISTINCT 
		 MIN(intRandomCode) OVER(PARTITION BY intStudyID) AS Minumum_For_Both_Studies, intStudyID
FROM        
         TRandomCodes
WHERE 
		 blnAvailable = 'T'
GROUP BY intStudyID, intRandomCode
GO

-- View that shows next available random codes (MIN) for study 1
GO
CREATE VIEW vNextRandomCode1
AS
SELECT DISTINCT 
		 MIN(intRandomCodeID) OVER(PARTITION BY intStudyID) AS Minumum_For_Study1
FROM        
         TRandomCodes
WHERE 
		 (blnAvailable = 'T' AND TRandomCodes.intStudyID = 12345)
GO
-- View that shows next available random codes (MIN) for study 2

GO
CREATE VIEW vNextRandomCode2
AS
SELECT DISTINCT 
		 MIN(intRandomCode) OVER(PARTITION BY intStudyID) AS Minumum_For_Study2
FROM        
         TRandomCodes
WHERE 
		 (blnAvailable = 'T' AND TRandomCodes.intStudyID = 54321)
GO

-- --------------------------------------------------------------------------------
-- 6.	Create the view that will show all available drug kits at all sites for both studies. You can do this together or 1 view for each study.
-- --------------------------------------------------------------------------------
GO
CREATE VIEW vAvailableDrugsAtSitesWithStudies
AS
SELECT        
		  TDrugKits.intDrugKitID, TSites.intSiteID, TStudies.intStudyID
FROM            
		  TDrugKits INNER JOIN TSites ON TDrugKits.intSiteID = 
		  TSites.intSiteID INNER JOIN TStudies ON TSites.intStudyID = 
		  TStudies.intStudyID
WHERE
		  TDrugKits.intVisitID IS NULL
GO	
-- --------------------------------------------------------------------------------
-- 7.	Create the view that will show all withdrawn patients, their site, withdrawal date and withdrawal reason for both studies.
-- --------------------------------------------------------------------------------
GO
CREATE VIEW vPatientWithdrawnWithSiteAndStudy
AS
SELECT
		  TPatients.intPatientNumber, TSites.intSiteNumber, TPatientVisits.dtmVisit, TWithdrawReasons.strWithdrawDesc
FROM         
		  TPatients INNER JOIN TSites ON TPatients.intSiteID = 
		  TSites.intSiteID INNER JOIN TPatientVisits ON TPatients.intPatientID = 
		  TPatientVisits.intPatientID INNER JOIN TWithdrawReasons ON TPatientVisits.intWithdrawReasonID = 
		  TWithdrawReasons.intWithdrawReasonID
WHERE   
	      intVisitTypeID = 3
GO

-- --------------------------------------------------------------------------------
-- 8.	Create other views as needed. Put as much as possible into Views so you are pulling from them instead of from tables.
-- --------------------------------------------------------------------------------
GO
CREATE VIEW vNextVisitID
AS
SELECT 
		 TPatientVisits.intVisitID
FROM     
		 TDrugKits,  TPatientVisits INNER JOIN
		 TPatients ON TPatientVisits.intPatientID = TPatients.intPatientID
WHERE 
		 TPatientVisits.intVisitTypeID = '2'
		 AND TPatients.intPatientID = TPatientVisits.intPatientID 
		 AND TDrugKits.intSiteID = TPatients.intSiteID  
GO
-- --------------------------------------------------------------------------------
-- 9.	Create the stored procedure(s) that will screen a patient for both studies. You can do this together or 1 for each study.
-- --------------------------------------------------------------------------------
GO
CREATE PROCEDURE uspScreenedPatientStudy
--Patients 
	 @intPatientNumber                  AS INTEGER
	,@intSiteID                         AS INTEGER 
	,@dtmDOB 	                        AS DATE		
	,@intGenderID                       AS INTEGER
	,@intWeight                         AS INTEGER

 --PatientVisits
    ,@intVisitID     					AS INTEGER  			
	,@dtmVisit                          AS DATE           
	,@intVisitTypeID					AS INTEGER          
 
AS  
SET XACT_ABORT ON --TERMINATE AND ROLLBACK ENTIRE TRANSACTION ON ANY ERRORS
BEGIN TRANSACTION

    DECLARE @intPatientID               AS INTEGER 



INSERT INTO TPatients(  intPatientNumber, intSiteID, dtmDOB, intGenderID, intWeight )
VALUES ( @intPatientNumber, @intSiteID, @dtmDOB, @intGenderID, @intWeight )

-- TVisitTypes Table
SELECT @intPatientID = MAX(intPatientID)
FROM TPatients

SELECT @intVisitID = (intVisitID)
FROM TPatientVisits(TABLOCKX)

INSERT INTO TPatientVisits ( intPatientID, dtmVisit, intVisitTypeID)
VALUES( @intPatientID, @dtmVisit, @intVisitTypeID)

COMMIT TRANSACTION
GO

-- --------------------------------------------------------------------------------
-- 10.1	Create the stored procedure(s) that will randomize a patient for both studies. You can do this together or 1 for each study
-- --------------------------------------------------------------------------------
GO
CREATE PROCEDURE uspRandomizePatient12345

     	  @intPatientID                      AS INTEGER OUTPUT
	     ,@dtmVisit                          AS DATE     
	     ,@intVisitTypeID					 AS INTEGER          

                   

AS  
SET XACT_ABORT ON --TERMINATE AND ROLLBACK ENTIRE TRANSACTION ON ANY ERRORS
BEGIN TRANSACTION
	
    INSERT INTO TPatientVisits ( intPatientID, dtmVisit, intVisitTypeID)
	VALUES( @intPatientID, @dtmVisit, @intVisitTypeID)

DECLARE @Now DATE
	BEGIN
		DECLARE TimeCursor CURSOR LOCAL FOR

		SELECT dtmVisit
		FROM TPatientVisits
		WHERE dtmVisit = null

		SET @Now = GETDATE() 
	 END
	
DECLARE @RandomCode AS int
	BEGIN
		DECLARE RandomizePatientCursor CURSOR LOCAL FOR
		
		SELECT Minumum_For_Study1
		FROM vNextRandomCode1

		OPEN RandomizePatientCursor

		FETCH FROM RandomizePatientCursor
		INTO @RandomCode
	
	End


DECLARE @DrugKit AS int
	BEGIN
		DECLARE DrugKitCursor CURSOR LOCAL FOR

		SELECT MIN(intDrugKitID)
		FROM vAvailableDrugsAtSitesWithStudies
		
		OPEN DrugKitCursor

		FETCH FROM DrugKitCursor
		INTO @DrugKit
	End

DECLARE @Visit AS int
	Begin
		DECLARE VisitCursor CURSOR LOCAL FOR

SELECT MAX(intVisitID)
FROM     vNextVisitID
	
		OPEN VisitCursor

		FETCH FROM VisitCursor
		INTO @Visit
	End
	
	
	    UPDATE TPatientVisits
		SET dtmVisit = @Now
		WHERE intVisitTypeID = '2'

		UPDATE TDrugKits
		SET intVisitID = @Visit 
		WHERE intDrugKitID = @DrugKit 
		

		UPDATE TPatients
		SET intRandomCodeID = @RandomCode
		WHERE intPatientID = @intPatientID

		UPDATE TRandomCodes
		SET blnAvailable = 'F'
		WHERE intRandomCodeID = @RandomCode


COMMIT TRANSACTION
GO

-- --------------------------------------------------------------------------------
-- 10.2 This will include a stored procedure for obtaining a random code as well as a drug kit. 
-- --------------------------------------------------------------------------------
GO
CREATE PROCEDURE uspRandomizePatient54321

  	      @intPatientID                      AS INTEGER OUTPUT
	     ,@dtmVisit                          AS DATE     
	     ,@intVisitTypeID					 AS INTEGER          

                   

AS  
SET XACT_ABORT ON --TERMINATE AND ROLLBACK ENTIRE TRANSACTION ON ANY ERRORS
BEGIN TRANSACTION
	
    INSERT INTO TPatientVisits ( intPatientID, dtmVisit, intVisitTypeID)
	VALUES( @intPatientID, @dtmVisit, @intVisitTypeID)

DECLARE @Now DATE
	BEGIN
		DECLARE TimeCursor CURSOR LOCAL FOR

		SELECT dtmVisit
		FROM TPatientVisits
		WHERE dtmVisit = null

		SET @Now = GETDATE() 
	 END
	
DECLARE @RandomCode AS int
	BEGIN
		DECLARE RandomizePatientCursor CURSOR LOCAL FOR
		
		SELECT Minumum_For_Study2
		FROM vNextRandomCode2

		OPEN RandomizePatientCursor

		FETCH FROM RandomizePatientCursor
		INTO @RandomCode
	
	End


DECLARE @DrugKit AS int
	BEGIN
		DECLARE DrugKitCursor CURSOR LOCAL FOR

		SELECT MIN(intDrugKitID)
		FROM vAvailableDrugsAtSitesWithStudies
		
		OPEN DrugKitCursor

		FETCH FROM DrugKitCursor
		INTO @DrugKit
	End

DECLARE @Visit AS int
	Begin
		DECLARE VisitCursor CURSOR LOCAL FOR

SELECT MAX(intVisitID)
FROM     vNextVisitID
	
		OPEN VisitCursor

		FETCH FROM VisitCursor
		INTO @Visit
	End
	
	
	    UPDATE TPatientVisits
		SET dtmVisit = @Now
		WHERE intVisitTypeID = '2'

		UPDATE TDrugKits
		SET intVisitID = @Visit 
		WHERE intDrugKitID = @DrugKit
		

		UPDATE TPatients
		SET intRandomCodeID = @RandomCode
		WHERE intPatientID = @RandomCode

		UPDATE TRandomCodes
		SET blnAvailable = 'F'
		WHERE intRandomCodeID = @RandomCode
		--IF @RandomCode <= .5
		--		SET strTreatment 'A' 
		--		ELSE
		--		SET strTreatment 'P'

COMMIT TRANSACTION
GO

-- --------------------------------------------------------------------------------
-- 11.	Create the stored procedure(s) that will withdraw a patient for both studies. You can do this together or 1 for each study. 
--      Remember a patient can go from Screening Visit to Withdrawal without being randomized. This will be up to the Doctor. Your code just has to be able to do it.
-- --------------------------------------------------------------------------------
GO
CREATE PROCEDURE uspWithdrawPatientStudy

          @intPatientID                      AS INTEGER 
	     ,@dtmVisit                          AS DATE    
	     ,@intVisitTypeID					 AS INTEGER
		 ,@intWithdrawReason                 AS INTEGER
AS  

SET XACT_ABORT ON --TERMINATE AND ROLLBACK ENTIRE TRANSACTION ON ANY ERRORS

BEGIN TRANSACTION

	DECLARE @intVisitID AS INTEGER

	INSERT INTO TPatientVisits ( intPatientID, dtmVisit, intVisitTypeID, intWithdrawReasonID )
	VALUES  ( @intPatientID, @dtmVisit, @intVisitTypeID, @intWithdrawReason )



COMMIT TRANSACTION

GO

 