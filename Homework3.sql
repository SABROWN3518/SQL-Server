-- --------------------------------------------------------------------------------
-- Name: 
-- Class: IT-111-400
-- Abstract: Views
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL1;     -- Get out of the master database
SET NOCOUNT ON; -- Report only errors

-- --------------------------------------------------------------------------------
-- Drop Tables
-- --------------------------------------------------------------------------------

IF OBJECT_ID( 'TUserSongs' )				IS NOT NULL DROP TABLE		TUserSongs
IF OBJECT_ID( 'TSongs' )					IS NOT NULL DROP TABLE		TSongs
IF OBJECT_ID( 'TUsers' )					IS NOT NULL DROP TABLE		TUsers

-- --------------------------------------------------------------------------------
-- Drop VIEWS
-- --------------------------------------------------------------------------------

IF OBJECT_ID( 'vUserSongs' )				IS NOT NULL DROP TABLE		vUserSongs
IF OBJECT_ID( 'vLikedSongs' )				IS NOT NULL DROP TABLE		vLikedSongs
IF OBJECT_ID( 'vNotLikedSongs' )				IS NOT NULL DROP TABLE		vNotLikedSongs
IF OBJECT_ID( 'vUserSongCount' )				IS NOT NULL DROP TABLE		vUserSongCount
-- --------------------------------------------------------------------------------
-- Step #1.1: Create Tables
-- --------------------------------------------------------------------------------

CREATE TABLE TUsers
(
	 intUserID			INTEGER			NOT NULL
	,strUserName		VARCHAR(50)		NOT NULL
	,strEmailAddress	VARCHAR(50)		NOT NULL
	,CONSTRAINT TUsers_PK PRIMARY KEY ( intUserID )
)

CREATE TABLE TSongs
(
	 intSongID			INTEGER			NOT NULL
	,strSongName		VARCHAR(50)		NOT NULL
	,strArtist			VARCHAR(50)		NOT NULL
	,CONSTRAINT TSongs_PK PRIMARY KEY ( intSongID )
)

CREATE TABLE TUserSongs
(
	 intUserSongID		INTEGER			NOT NULL
	,intUserID			INTEGER			NOT NULL
	,intSongID			INTEGER			NOT NULL
	,CONSTRAINT UserSongs_UQ   UNIQUE	( intUserID, intSongID )
	,CONSTRAINT TUserSongs_PK PRIMARY KEY ( intUserSongID )
)

-- --------------------------------------------------------------------------------
-- Step #1.2: Identify and Create Foreign Keys
-- --------------------------------------------------------------------------------
--
-- #	Child						Parent						Column(s)
-- -	-----						------						---------
-- 1	TUserSongs					TUsers						intUserID
-- 2	TUserSongs					TSongs						intSongID

-- 1
ALTER TABLE TUserSongs ADD CONSTRAINT TUserSongs_TUsers_FK
FOREIGN KEY ( intUserID ) REFERENCES TUsers ( intUserID )

-- 2
ALTER TABLE TUserSongs ADD CONSTRAINT TUserSongs_TSongs_FK
FOREIGN KEY ( intSongID ) REFERENCES TSongs ( intSongID )



-- --------------------------------------------------------------------------------
-- Step #1.3: Add at least 3 users
-- --------------------------------------------------------------------------------
INSERT INTO TUsers ( intUserID, strUserName, strEmailAddress )
VALUES	 ( 1, 'IAmHere', 'RUHere@Gmail.com' )
		,( 2, 'JPSamuels', 'JSam@cinci.rr.com' )
		,( 3, 'JamminPete', 'JMP@Yahoo.com' )
		
		
-- --------------------------------------------------------------------------------
-- Step #1.4: Add at least 3 Songs
-- --------------------------------------------------------------------------------
INSERT INTO TSongs ( intSongID, strSongName, strArtist )
VALUES	 ( 1, 'Hysteria', 'Def Leppard' )
		,( 2, 'Faithfully', 'Journey' )
		,( 3, 'Any Way You Want It', 'Journey' )
		,( 4, 'Hotel California', 'Eagles' )
		,( 5, 'The Last Resort', 'Eagles' )
		,( 6, 'Those Shoes', 'Eagles' )
		
-- --------------------------------------------------------------------------------
-- Step #1.5: Add at at least 6 User/Song assignments
-- --------------------------------------------------------------------------------
INSERT INTO TUserSongs ( intUserSongID, intUserID, intSongID )
VALUES	 ( 1, 1, 1 )
		,( 2, 1, 2 )
		,( 3, 2, 1 )
		,( 4, 2, 3 )
		,( 5, 3, 2 )
		,( 6, 3, 3 )
		,( 7, 3, 4 )
		,( 8, 3, 6 )


-- --------------------------------------------------------------------------------
-- Step #1.6: Create a view to show all users and their favorite songs
-- --------------------------------------------------------------------------------
Go 
CREATE VIEW vUserSongs
AS
SELECT
	 TU.intUserID
	,TU.strUserName
	,TS.intSongID
	,TS.strSongName

FROM
	TUsers AS TU
	,TSongs AS TS
	,TUserSongs AS TUS

WHERE
	TU.intUserID = TUS.intUserID
	AND TS.intSongID = TUS.intSongID

GO

-- --------------------------------------------------------------------------------
-- Step #1.7: Create a view to show all songs liked by at least 1 user
-- --------------------------------------------------------------------------------
Go 
CREATE VIEW vLikedSongs
AS
SELECT
	TS.intSongID
	,TS.strSongName
	,TS.strArtist

FROM
	TSongs AS TS
	
WHERE
TS.intSongID IN (SELECT intSongID FROM TUserSongs)

GO

-- --------------------------------------------------------------------------------
-- Step #1.8: Create a view to show all songs NOT liked by at least 1 user
-- --------------------------------------------------------------------------------
Go 
CREATE VIEW vNotLikedSongs
AS
SELECT
	TS.intSongID
	,TS.strSongName
	,TS.strArtist

FROM
	TSongs AS TS
	
WHERE
TS.intSongID NOT IN (SELECT intSongID FROM TUserSongs)

GO
SELECT * FROM vNotLikedSongs
-- --------------------------------------------------------------------------------
-- Step #1.9: Create a view to show the number of songs like by each user
-- --------------------------------------------------------------------------------

Go 
CREATE VIEW vUserSongCount
AS
SELECT
	 TU.intUserID
	,TU.strUserName
	,COUNT(TS.intSongID) AS Song_Count

FROM
	TUsers AS TU
	,TSongs AS TS
	,TUserSongs AS TUS

WHERE
	TU.intUserID = TUS.intUserID
	AND TS.intSongID = TUS.intSongID

GROUP BY
	 TU.intUserID
	,TU.strUserName

GO