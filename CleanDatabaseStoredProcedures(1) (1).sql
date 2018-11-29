SET NOCOUNT ON

IF OBJECT_ID( 'uspDropUserForeignKeys' )		IS NOT NULL DROP PROCEDURE uspDropUserForeignKeys
IF OBJECT_ID( 'uspDropUserTables' )				IS NOT NULL DROP PROCEDURE uspDropUserTables
IF OBJECT_ID( 'uspDropUserViews' )				IS NOT NULL DROP PROCEDURE uspDropUserViews
IF OBJECT_ID( 'uspDropUserStoredProcedures' )	IS NOT NULL DROP PROCEDURE uspDropUserStoredProcedures
IF OBJECT_ID( 'uspCleanDatabase' )				IS NOT NULL DROP PROCEDURE uspCleanDatabase
GO

-- --------------------------------------------------------------------------------
-- Name: uspDropForeignKeys
-- Abstract: Use a cursor to drop all the user foreign keys
-- --------------------------------------------------------------------------------
CREATE PROCEDURE uspDropUserForeignKeys
AS
SET NOCOUNT ON
DECLARE @strMessage		VARCHAR(250)
DECLARE @strForeignKey	VARCHAR(250)
DECLARE @strChildTable	VARCHAR(250)
DECLARE @strCommand		VARCHAR(250)

------------------------------Drop all user foreign keys------------------------------
PRINT CHAR(9) + 'DROP ALL USER FOREIGN KEYS ...'

DECLARE crsForeignKeys CURSOR FOR
SELECT 
	 name						AS strForeignKey
	,OBJECT_NAME( parent_obj )	AS strChildTable
	
FROM
	 SysObjects
WHERE
		type	 = 	'F'					/* Foreign Keys Only */
	AND	(
				name	LIKE	'%_FK'
			OR	name	LIKE	'%_FK_'
		)
	AND	OBJECT_NAME( parent_obj ) LIKE	'T%'
	
ORDER BY
	 name

OPEN crsForeignKeys
FETCH NEXT FROM crsForeignKeys INTO @strForeignKey, @strChildTable

-- Loop until no more records
WHILE @@FETCH_STATUS = 0
BEGIN

	SELECT @strMessage = CHAR(9) + Char(9) + '-DROP ' + @strForeignKey
	PRINT @strMessage

	-- Build command
	SELECT @strCommand = 'ALTER TABLE ' + @strChildTable + ' DROP CONSTRAINT ' + @strForeignKey

	--Execute command
	EXEC( @strCommand )
	
	FETCH NEXT FROM crsForeignKeys INTO @strForeignKey, @strChildTable
	
END

-- Clean up
CLOSE crsForeignKeys
DEALLOCATE crsForeignKeys

PRINT CHAR(9) + 'DONE'
GO



-- --------------------------------------------------------------------------------
-- Name: uspDropUserTables
-- Abstract: Use a cursor to drop all the user tables
-- --------------------------------------------------------------------------------
CREATE PROCEDURE uspDropUserTables
AS
SET NOCOUNT ON
DECLARE @strMessage		VARCHAR(250)
DECLARE @strUserTable	VARCHAR(250)
DECLARE @strCommand		VARCHAR(250)

------------------------------Drop all user tables ------------------------------
PRINT CHAR(9) + 'DROP ALL USER TABLES ...'

DECLARE crsUserTables CURSOR FOR
SELECT 
	 name	AS strUserTable
FROM
	 SysObjects
WHERE
		type	= 		'U'				/* User tables only */
	AND	name	LIKE	'T%'
ORDER BY
	 name

OPEN crsUserTables
FETCH NEXT FROM crsUserTables INTO @strUserTable

-- Loop until no more records
WHILE @@FETCH_STATUS = 0
BEGIN

	SELECT @strMessage = CHAR(9) + Char(9) + '-DROP ' + @strUserTable
	PRINT @strMessage

	-- Build command
	SELECT @strCommand = 'DROP TABLE ' + @strUserTable

	--Execute command
	EXEC( @strCommand )
	
	FETCH NEXT FROM crsUserTables INTO @strUserTable
	
END

-- Clean up
CLOSE crsUserTables
DEALLOCATE crsUserTables

PRINT CHAR(9) + 'DONE'
GO



-- --------------------------------------------------------------------------------
-- Name: uspDropUserViews
-- Abstract: Use a cursor to drop all the user views
-- --------------------------------------------------------------------------------
CREATE PROCEDURE uspDropUserViews
AS
SET NOCOUNT ON
DECLARE @strMessage		VARCHAR(250)
DECLARE @strUserView	VARCHAR(250)
DECLARE @strCommand		VARCHAR(250)

------------------------------Drop all user views ------------------------------
PRINT CHAR(9) + 'DROP ALL USER VIEWS ...'

DECLARE crsUserViews CURSOR FOR
SELECT 
	 name	AS strUserView
FROM
	 SysObjects
WHERE
		type	= 		'V'				/* User views only */
	AND	name	LIKE	'V%'
ORDER BY
	 name

OPEN crsUserViews
FETCH NEXT FROM crsUserViews INTO @strUserView

-- Loop until no more records
WHILE @@FETCH_STATUS = 0
BEGIN

	SELECT @strMessage = CHAR(9) + Char(9) + '-DROP ' + @strUserView
	PRINT @strMessage

	-- Build command
	SELECT @strCommand = 'DROP VIEW ' + @strUserView

	--Execute command
	EXEC( @strCommand )
	
	FETCH NEXT FROM crsUserViews INTO @strUserView
	
END

-- Clean up
CLOSE crsUserViews
DEALLOCATE crsUserViews

PRINT CHAR(9) + 'DONE'
GO



-- --------------------------------------------------------------------------------
-- Name: uspDropUserStoredProcedures
-- Abstract: Use a cursor to drop all the user stored procedures
-- --------------------------------------------------------------------------------
CREATE PROCEDURE uspDropUserStoredProcedures
AS
SET NOCOUNT ON
DECLARE @strMessage				VARCHAR(250)
DECLARE @strUserStoredProcedure	VARCHAR(250)
DECLARE @strCommand				VARCHAR(250)

------------------------------Drop all user Stored Procedures ------------------------------
PRINT CHAR(9) + 'DROP ALL USER STORED PROCEDURES ...'

DECLARE crsUserStoredProcedures CURSOR FOR
SELECT 
	 name	AS strUserStoredProcedure
FROM
	 SysObjects
WHERE
		type	= 			'P'				/* User Stored Procedures only */
	AND	name	LIKE		'usp%'
	AND name	<>			'uspCleanDatabase'
	AND	name	NOT LIKE	'uspDrop%'
ORDER BY
	 name

OPEN crsUserStoredProcedures
FETCH NEXT FROM crsUserStoredProcedures INTO @strUserStoredProcedure

-- Loop until no more records
WHILE @@FETCH_STATUS = 0
BEGIN

	SELECT @strMessage = CHAR(9) + Char(9) + '-DROP ' + @strUserStoredProcedure
	PRINT @strMessage

	-- Build command
	SELECT @strCommand = 'DROP PROCEDURE ' + @strUserStoredProcedure

	--Execute command
	EXEC( @strCommand )
	
	FETCH NEXT FROM crsUserStoredProcedures INTO @strUserStoredProcedure
	
END

-- Clean up
CLOSE crsUserStoredProcedures
DEALLOCATE crsUserStoredProcedures

PRINT CHAR(9) + 'DONE'
GO




-- --------------------------------------------------------------------------------
-- Name: uspCleanDatabaes
-- Abstract: Call the drop procedures
-- --------------------------------------------------------------------------------
CREATE PROCEDURE uspCleanDatabase
AS
SET NOCOUNT ON

PRINT 'CLEANING THE DATABASE ...'

EXECUTE uspDropUSerForeignKeys
EXECUTE uspDropUserTables
EXECUTE uspDropUserViews
EXECUTE uspDropUserStoredProcedures

PRINT 'DONE'
GO
