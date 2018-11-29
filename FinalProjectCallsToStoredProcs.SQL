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
--  A)	8 patients for each study for screening.  Study 12345, each site
EXECUTE uspScreenedPatientStudy 101001, 1, '10/01/1980', 1, 150, 26, '01/01/2017', 1  -- SITE 1 101
EXECUTE uspScreenedPatientStudy 102001, 1, '10/02/1980', 2, 250, 27, '01/02/2017', 1  -- SITE 1 101
EXECUTE uspScreenedPatientStudy 103001, 2, '11/03/1970', 1, 100,  3, '01/03/2017', 1  -- SITE 2 111
EXECUTE uspScreenedPatientStudy 104001, 2, '12/07/1976', 2, 159,  4, '01/04/2017', 1  -- SITE 2 111
EXECUTE uspScreenedPatientStudy 105001, 3, '10/05/1990', 1, 105,  5, '01/05/2017', 1  -- SITE 3 121
EXECUTE uspScreenedPatientStudy 106001, 3, '09/06/1974', 2, 170,  6, '01/06/2017', 1  -- SITE 3 121
EXECUTE uspScreenedPatientStudy 107001, 4, '06/03/1974', 1,  95,  7, '01/07/2017', 1  -- SITE 4 131
EXECUTE uspScreenedPatientStudy 108001, 5, '04/08/1993', 2, 275,  8, '01/08/2017', 1  -- SITE 5 141

----    8 patients for each study for screening.  Study 54321, each site
EXECUTE uspScreenedPatientStudy 109001, 6,  '01/09/1982', 1, 120, 9,  '02/01/2017', 1 -- SITE 6 501
EXECUTE uspScreenedPatientStudy 110001, 6,  '10/11/1984', 2, 180, 10, '02/02/2017', 1 -- SITE 6 501
EXECUTE uspScreenedPatientStudy 111001, 7,  '12/10/1970', 2, 180, 11, '02/03/2017', 1 -- SITE 7 511
EXECUTE uspScreenedPatientStudy 112001, 7,  '07/10/1950', 2, 180, 12, '02/04/2017', 1 -- SITE 7 511
EXECUTE uspScreenedPatientStudy 113001, 8,  '09/01/1989', 2, 180, 13, '02/05/2017', 1 -- SITE 8 521
EXECUTE uspScreenedPatientStudy 114001, 8,  '07/04/1978', 2, 180, 14, '02/06/2017', 1 -- SITE 8 521
EXECUTE uspScreenedPatientStudy 115001, 9,  '08/02/1983', 2, 180, 15, '02/07/2017', 1 -- SITE 9 531
EXECUTE uspScreenedPatientStudy 116001, 10, '01/10/1968', 2, 180, 16, '02/08/2017', 1 -- SITE 10 541

---- B)  5 patients randomized for each study. (including assigning drug kit) Study 12345, each site
EXECUTE uspRandomizePatient12345 1, '02/08/2017', 2
EXECUTE uspRandomizePatient12345 3, '02/08/2017', 2
EXECUTE uspRandomizePatient12345 5, '02/08/2017', 2
EXECUTE uspRandomizePatient12345 7, '02/08/2017', 2
EXECUTE uspRandomizePatient12345 8, '02/08/2017', 2


----    5 patients randomized for each study. (including assigning drug kit) Study 54321, each site
EXECUTE uspRandomizePatient54321 9, '02/08/2017', 2
EXECUTE uspRandomizePatient54321 11, '02/08/2017', 2
EXECUTE uspRandomizePatient54321 13, '02/08/2017', 2
EXECUTE uspRandomizePatient54321 15, '02/08/2017', 2
EXECUTE uspRandomizePatient54321 16, '02/08/2017', 2

----C)	4 patients (2 randomized and 2 not randomized patients) withdrawn from each study. Study 12345
EXECUTE uspWithdrawPatientStudy 2, '06/03/2018', 2, 1
EXECUTE uspWithdrawPatientStudy 4, '06/03/2018', 2, 2
EXECUTE uspWithdrawPatientStudy 1, '06/03/2018', 3, 4
EXECUTE uspWithdrawPatientStudy 3, '06/03/2018', 3, 5

----    4 patients (2 randomized and 2 not randomized patients) withdrawn from each study. Study 54321
EXECUTE uspWithdrawPatientStudy 10, '06/03/2018', 2, 1
EXECUTE uspWithdrawPatientStudy 12, '06/03/2018', 2, 2
EXECUTE uspWithdrawPatientStudy 9, '06/03/2018', 3, 4
EXECUTE uspWithdrawPatientStudy 11, '06/03/2018', 3, 5

